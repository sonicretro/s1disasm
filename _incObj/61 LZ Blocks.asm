; ===========================================================================
; ---------------------------------------------------------------------------
; Object 61 - multi-variant blocks (LZ)
; ---------------------------------------------------------------------------

LabyrinthBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LBlk_Index(pc,d0.w),d1
		jmp	LBlk_Index(pc,d1.w)
; ===========================================================================
LBlk_Index:	dc.w LBlk_Main-LBlk_Index
		dc.w LBlk_Action-LBlk_Index

lblk_origY:	equ objoff_30		; original y-axis position
lblk_origX:	equ objoff_34		; original x-axis position
lblk_time:	equ objoff_36		; time delay for block movement
lblk_untouched:	equ objoff_38		; flag block as untouched
lblk_nudge:	equ objoff_3E		; nudge Y-offset while Sonic is standing on block
lblk_touchtype:	equ objoff_3F		; stores Sonic's touch response from SolidObject (0, +1, -1)
; ===========================================================================

LBlk_Var:	; width, height
		dc.b 32/2, 32/2		; block that sinks when stood on
		dc.b 64/2, 24/2		; platform that rises when stood on 
		dc.b 32/2, 32/2		; cork block that floats on water
		dc.b 32/2, 32/2		; generic solid block
; ===========================================================================

LBlk_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to LBlk_Action
		move.l	#Map_LBlock,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Blocks|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get block subtype
		lsr.w	#3,d0					; divide by 8 (upper nybble of subtype, $10 per size entry)
		andi.w	#$E,d0					; limit results to multiples of 2, up to $E
		lea	LBlk_Var(pc,d0.w),a2			; load dimension array
		move.b	(a2)+,obActWid(a0)			; set width for block
		move.b	(a2),obHeight(a0)			; set height for block
		lsr.w	#1,d0					; divide above result by 2
		move.b	d0,obFrame(a0)				; set frame ID for block (0-3)

		move.w	obX(a0),lblk_origX(a0)			; remember initial X-position
		move.w	obY(a0),lblk_origY(a0)			; remember initial Y-position

		move.b	obSubtype(a0),d0			; get block subtype again
		andi.b	#$0F,d0					; read only the lower digit
		beq.s	LBlk_Action				; branch if 0
		cmpi.b	#7,d0					; is this the small secret platform in LZ1?
		beq.s	LBlk_Action				; if yes, branch
		move.b	#1,lblk_untouched(a0)			; set block as untouched
; ---------------------------------------------------------------------------

LBlk_Action:	; Routine 2
		move.w	obX(a0),-(sp)				; backup old X-position before executing behavior
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get block subtype
		andi.w	#$F,d0					; limit to 0-F
		add.w	d0,d0					; double for word-based indexing
		move.w	LBlk_Types(pc,d0.w),d1			; find entry in jump table for behavior
		jsr	LBlk_Types(pc,d1.w)			; execute block behavior, then return here

		move.w	(sp)+,d4				; restore previous X-position for SolidObject input
		tst.b	obRender(a0)				; is platform on screen?
		bpl.s	.chkdel					; if not, branch
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		addi.w	#sonic_solid_width,d1			; add Sonic's own collision width
		moveq	#0,d2					; clear d2
		move.b	obHeight(a0),d2				; get object height as solidity height (initial)
		move.w	d2,d3					; copy for stood-on check
		addq.w	#1,d3					; +1px for stood-on check
		bsr.w	SolidObject				; make platform solid for Sonic
		move.b	d4,lblk_touchtype(a0)			; store collision response value (0, +1, -1)
		bsr.w	LBlk_Nudge				; nudge platform as Sonic stannds on it

	.chkdel:
		out_of_range.w	DeleteObject,lblk_origX(a0)	; has block gone out of range? if yes, delete it
		bra.w	DisplaySprite				; display block sprite

; ===========================================================================
LBlk_Types:	dc.w LBlk_Stationary-LBlk_Types			; 0
		dc.w LBlk_CheckStand-LBlk_Types			; 1
		dc.w LBlk_Sink-LBlk_Types			; 2
		dc.w LBlk_CheckStand-LBlk_Types			; 3
		dc.w LBlk_Rise-LBlk_Types			; 4
		dc.w LBlk_SideSink-LBlk_Types			; 5
		dc.w LBlk_Sink-LBlk_Types			; 6
		dc.w LBlk_OnWater-LBlk_Types			; 7
; ===========================================================================

LBlk_Stationary:
		rts						; do nothing
; ===========================================================================

LBlk_CheckStand:
		tst.w	lblk_time(a0)				; has time counter already started?
		bne.s	.delayAndAdvance			; if yes, branch
		btst	#3,obStatus(a0)				; is Sonic standing on the block?
		beq.s	.return					; if not, branch
		move.w	#30,lblk_time(a0)			; wait for half second

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.delayAndAdvance:
		subq.w	#1,lblk_time(a0)			; decrement waiting time
		bne.s	.return					; if time remains, branch
		addq.b	#1,obSubtype(a0)			; advance to LBlk_Sink or LBlk_Rise
		clr.b	lblk_untouched(a0)			; flag block as touched
		rts						; return
; ===========================================================================

LBlk_Sink:
		bsr.w	SpeedToPos				; update block position
		addq.w	#8,obVelY(a0)				; make block fall faster

		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has block hit the floor?
		bpl.w	.return					; if not, branch
		addq.w	#1,d1					; manually adjust by 1px down
		add.w	d1,obY(a0)				; align block to floor
		clr.w	obVelY(a0)				; stop block falling
		clr.b	obSubtype(a0)				; set to subtype 0 (stationary type)

	.return:
		rts						; return
; ===========================================================================

LBlk_Rise:
		bsr.w	SpeedToPos				; update block position
		subq.w	#8,obVelY(a0)				; make block rise faster

		bsr.w	ObjHitCeiling				; get distance to ceiling
		tst.w	d1					; has block hit the ceiling?
		bpl.w	.return					; if not, branch
		sub.w	d1,obY(a0)				; align block to ceiling
		clr.w	obVelY(a0)				; stop block rising
		clr.b	obSubtype(a0)				; set to subtype 0 (stationary type)

	.return:
		rts						; return
; ===========================================================================

LBlk_SideSink:
		cmpi.b	#1,lblk_touchtype(a0)			; is Sonic touching the block from the sides?
		bne.s	.return					; if not, branch
		addq.b	#1,obSubtype(a0)			; advance to LBlk_Sink
		clr.b	lblk_untouched(a0)			; set block as touched

	.return:
		rts						; return
; ===========================================================================

LBlk_OnWater:
		move.w	(v_waterpos1).w,d0			; get current water height
		sub.w	obY(a0),d0				; is block level with water?
		beq.s	.return2				; if yes, branch
		bcc.s	.corkSink				; branch if block is above water

.corkRise:
		cmpi.w	#-2,d0					; is block at most 2px below water level?
		bge.s	.rise					; if not, branch
		moveq	#-2,d0					; cap rising speed to 2px/frame
	.rise:	add.w	d0,obY(a0)				; make the block rise with water level

		bsr.w	ObjHitCeiling				; get distance to ceiling
		tst.w	d1					; has block hit the ceiling?
		bpl.w	.return					; if not, branch
		sub.w	d1,obY(a0)				; align block with ceiling

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.corkSink:
		cmpi.w	#2,d0					; is block at most 2px above water level?
		ble.s	.sink					; if not, branch
		moveq	#2,d0					; cap block sinking speed to 2px/frame
	.sink:	add.w	d0,obY(a0)				; make the block sink with water level

		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has block hit the floor?
		bpl.w	.return2				; if not, branch
		addq.w	#1,d1					; manually adjust by 1px down
		add.w	d1,obY(a0)				; align block to floor

	.return2:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to slightly nudge block down as Sonic stands on it
; ---------------------------------------------------------------------------

LBlk_Nudge:
		tst.b	lblk_untouched(a0)			; has block been stood on or touched?
		beq.s	.return					; if yes, branch
		btst	#3,obStatus(a0)				; is Sonic standing on it now?
		bne.s	.nudgeDown				; if yes, branch

		tst.b	lblk_nudge(a0)				; is platform back at default position?
		beq.s	.return					; if yes, branch
		subq.b	#4,lblk_nudge(a0)			; slightly move platform back up
		bra.s	.updateYPosition			; update platform's Y-position
; ---------------------------------------------------------------------------

	.nudgeDown:
		cmpi.b	#$40,lblk_nudge(a0)			; is platform fully nudged down?
		beq.s	.return					; if yes, branch
		addq.b	#4,lblk_nudge(a0)			; slightly move platform down

	.updateYPosition:
		move.b	lblk_nudge(a0),d0			; get current nudge Y-offset
		jsr	(CalcSine).l				; calculate sine for nudge offset
		move.w	#$400,d1				; set nudge force
		muls.w	d1,d0					; multiply sine result by nudge force
		swap	d0					; divide by $10000
		add.w	lblk_origY(a0),d0			; add initial Y-position
		move.w	d0,obY(a0)				; set nudged Y-position for block

	.return:
		rts						; return
; End of function LBlk_Nudge

; ===========================================================================

Map_LBlock:	include	"_maps/LZ Blocks.asm"
