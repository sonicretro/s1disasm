; ===========================================================================
; ---------------------------------------------------------------------------
; Object 30 - large green glass pillars (MZ)
; ---------------------------------------------------------------------------

GlassBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Glass_Index(pc,d0.w),d1
		jsr	Glass_Index(pc,d1.w)

		out_of_range.w	.delete
		bra.w	DisplaySprite

	.delete:
		bra.w	DeleteObject

; ===========================================================================
Glass_Index:	dc.w Glass_Main-Glass_Index			; 0
		dc.w Glass_Pillar_UpDown-Glass_Index		; 2
		dc.w Glass_Sheen_UpDown-Glass_Index		; 4
		dc.w Glass_Pillar_Triggered-Glass_Index		; 6
		dc.w Glass_Sheen_Triggered-Glass_Index		; 8

glass_origY:		equ objoff_30	; initial Y-position (can be changed)
glass_distanceY:	equ objoff_32	; Y-distance pillar can move down from origin, stops at 0
glass_switch_flag:	equ objoff_34	; subtype 4 (switch pillar) set to 1 if switch was pressed
glass_stomp_flags:	equ objoff_34	; subtype 3 (stomp pillar) bit 0 = set if Sonic is on pillar; bit 7 = set if currently moving down
glass_stomp_first:	equ objoff_35	; set after first landing on stomp pillar
glass_stomp_distance:	equ objoff_36	; number of pixels for pillar to get stomped down
glass_stomp_delay:	equ objoff_38	; frames to delay moving down after stomp
glass_parent:		equ objoff_3C	; address of parent object
; ===========================================================================

; routine, y-axis dist (unused), frame num
Glass_Vars1:	dc.b 2,	0, 0	; tall block
		dc.b 4,	0, 1	; shine

Glass_Vars2:	dc.b 6,	0, 2	; short block
		dc.b 8,	0, 1	; shine
; ===========================================================================

Glass_Main:	; Routine 0
		lea	(Glass_Vars1).l,a2			; use default values (tall pillar)
		moveq	#2-1,d1					; spawn two objects
		move.b	#144/2,obHeight(a0)			; set object height

		cmpi.b	#3,obSubtype(a0)			; is object type 0/1/2?
		blo.s	.IsType012				; if yes, branch
		lea	(Glass_Vars2).l,a2			; use alternate values (short pillar)
		moveq	#2-1,d1					; spawn two objects (...again)
		move.b	#112/2,obHeight(a0)			; use shorter object height

	.IsType012:
		movea.l	a0,a1					; load main object into current RAM slot
		bra.s	.makePillar				; load main object
; ---------------------------------------------------------------------------

	.loop:
		bsr.w	FindNextFreeObj				; find a free object slot for the shine
		bne.s	.finalizePillar				; if object RAM is full, branch

	.makePillar:
		move.b	(a2)+,obRoutine(a1)			; set routine for object (2/4/6/8)
		_move.b	#id_GlassBlock,obID(a1)			; load another glass block object

		move.w	obX(a0),obX(a1)				; copy X-position from parent
		move.b	(a2)+,d0				; get relative Y-offset (this is always 0)
		ext.w	d0					; extend to word
		add.w	obY(a0),d0				; add base Y-position
		move.w	d0,obY(a1)				; set adjusted Y-position

		move.l	#Map_Glass,obMap(a1)			; set mappings
		move.w	#ArtTile_MZ_Glass_Pillar|Tile_Pal3|Tile_Prio,obGfx(a1) ; set art tile, palette line, and high-priority flag
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.w	obY(a1),glass_origY(a1)			; remember initial Y-position
		move.b	obSubtype(a0),obSubtype(a1)		; copy subtype from parent
		move.b	#64/2,obActWid(a1)			; set sprite display width for pillar
		move.b	#4,obPriority(a1)			; set sprite priority for pillar
		move.b	(a2)+,obFrame(a1)			; load frame number (0/1/2)
		move.l	a0,glass_parent(a1)			; remember parent object
		dbf	d1,.loop				; repeat once to load "reflection object"

		move.b	#32/2,obActWid(a1)			; use smaller sprite display width for shine
		move.b	#3,obPriority(a1)			; use higher sprite priority for shine
		addq.b	#1<<3,obSubtype(a1)			; add 8 to sheen subtype to treat it separately in Glass_Types
		andi.b	#$F,obSubtype(a1)			; clear upper digit in sheen subtype (used for switch)

	.finalizePillar:
		move.w	#144,glass_distanceY(a0)		; set Y-distance pillar can move down from origin
		bset	#sprite_customheight_bit,obRender(a0)	; use custom sprite display height for the large pillar
; ---------------------------------------------------------------------------

; Glass_Block012:
Glass_Pillar_UpDown: ; Routine 2
		bsr.w	Glass_Types				; handle pillar subtype behavior

		move.w	#64/2+sonic_solid_width,d1		; collision width
		move.w	#144/2,d2				; collision height (initial)
		move.w	#146/2,d3				; collision height (stood-on)
		move.w	obX(a0),d4				; collision X-position (stood-on)
		bra.w	SolidObject				; make glass pillar solid
; ===========================================================================

; Glass_Reflect012:
Glass_Sheen_UpDown: ; Routine 4
		movea.l	glass_parent(a0),a1			; load parent glass pillar object
		move.w	glass_distanceY(a1),glass_distanceY(a0)	; copy parent's Y-distance

		bra.w	Glass_Types				; handle sheen behavior
; ===========================================================================

; Glass_Block34:
Glass_Pillar_Triggered: ; Routine 6
		bsr.w	Glass_Types				; handle pillar subtype behavior

		move.w	#64/2+sonic_solid_width,d1		; collision width
		move.w	#112/2,d2				; collision height (initial)
		move.w	#114/2,d3				; collision height (stood-on)
		move.w	obX(a0),d4				; collision X-position (stood-on)
		bra.w	SolidObject				; make glass pillar solid
; ===========================================================================

; Glass_Reflect34:
Glass_Sheen_Triggered: ; Routine 8
		movea.l	glass_parent(a0),a1			; load parent glass pillar object
		move.w	glass_distanceY(a1),glass_distanceY(a0)	; copy parent's Y-distance
		move.w	obY(a1),glass_origY(a0)			; copy parent's Y-position for Y-origin

		bra.w	Glass_Types				; handle sheen behavior

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move glass pillar and its sheen based on subtype
; ---------------------------------------------------------------------------

Glass_Types:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#7,d0					; limit to sane values
		add.w	d0,d0					; double for word-based indexing
		move.w	Glass_TypeIndex(pc,d0.w),d1		; find relevant entry in jump table
		jmp	Glass_TypeIndex(pc,d1.w)		; execute pillar behavior
; End of function Glass_Types

; ===========================================================================
Glass_TypeIndex:dc.w Glass_Type0_Stationary-Glass_TypeIndex	; 0 - does not move
		dc.w Glass_Type1_UpDown-Glass_TypeIndex		; 1 - oscillate up and down
		dc.w Glass_Type2_DownUp-Glass_TypeIndex		; 2 - oscillate up and down (opposite direction of type 1)
		dc.w Glass_Type3_Stomp-Glass_TypeIndex		; 3 - moves down when Sonic jumps on it repeatedly (unused prototype leftover)
		dc.w Glass_Type4_Switch-Glass_TypeIndex		; 4 - moves down after a matching switch was pressed
; ===========================================================================

; Subtype 0 - stationary
Glass_Type0_Stationary:
		rts						; don't do anything
; ===========================================================================

; Subtype 1 - oscillate up and down
Glass_Type1_UpDown:
		move.b	(v_oscillate+$12).w,d0			; get oscillation value (frequency = 4, middle value = $20)
		move.w	#64,d1					; manually adjust sheen Y-offset by 64px
		bra.s	Glass_Type12_MoveSheen			; update sheen position
; ===========================================================================

; Subtype 2 - oscillate up and down (inverted to subtype 1)
Glass_Type2_DownUp:
		move.b	(v_oscillate+$12).w,d0			; get oscillation value (frequency = 4, middle value = $20)
		move.w	#64,d1					; manually adjust pillar and sheen Y-offset by 64px
		neg.w	d0					; invert oscillation direction
		add.w	d1,d0					; keep objects in same general Y-position
; ---------------------------------------------------------------------------

Glass_Type12_MoveSheen:
		btst	#3,obSubtype(a0)			; is this the sheen object?
		beq.s	.setYDistance				; if not, branch
		neg.w	d0					; make sheen oscillate in opposite direction to the pillar
		add.w	d1,d0					; keep sheen in same general Y-position
		lsr.b	#1,d0					; sheen moves half as fast as pillar
		addi.w	#32,d0					; adjust Y-position further after halving

	.setYDistance:
		bra.w	Glass_UpdateY				; oscillate pillar and sheen Y-positions
; ===========================================================================

; Subtype 3 - moves down when Sonic jumps on it repeatedly (unused prototype leftover)
Glass_Type3_Stomp:
		btst	#3,obSubtype(a0)			; is this the sheen object?
		beq.s	.checkSonicStomp			; if not, branch

		move.b	(v_oscillate+$12).w,d0			; get oscillation value for sheen (frequency = 4, middle value = $20)
		subi.w	#16,d0					; manually adjust sheen down by 16px
		bra.w	Glass_UpdateY				; oscillate sheen Y-position
; ---------------------------------------------------------------------------

.checkSonicStomp:
		btst	#3,obStatus(a0)				; is Sonic standing on top of pillar?
		bne.s	.sonicOnPillar				; if yes, branch
		bclr	#0,glass_stomp_flags(a0)		; clear "Sonic standing on pillar" flag
		bra.s	.checkMoveDown				; keep pillar moving down if it has just been stomped
; ---------------------------------------------------------------------------

.sonicOnPillar:
		tst.b	glass_stomp_flags(a0)			; is Sonic already standing on pillar or is it currently moving down?
		bne.s	.checkMoveDown				; if yes, branch

		move.b	#1,glass_stomp_flags(a0)		; set "Sonic standing on pillar" flag
		bset	#0,glass_stomp_first(a0)		; set flag that pillar has been touched at least once
		beq.s	.checkMoveDown				; was this the first touch? if yes, don't move pillar yet
		bset	#7,glass_stomp_flags(a0)		; set pillar as moving down
		move.w	#16,glass_stomp_distance(a0)		; move pillar down by 16px
		move.b	#10,glass_stomp_delay(a0)		; wait 10 frames before starting to move
		cmpi.w	#64,glass_distanceY(a0)			; has pillar already been stomped down 5 times? (64 = 144 - 16*5)
		bne.s	.checkMoveDown				; if not, branch
		move.w	#64,glass_stomp_distance(a0)		; make the final descend 64px instead of just 16px

	.checkMoveDown:
		tst.b	glass_stomp_flags(a0)			; is pillar currently moving down?
		bpl.s	.setYDistance				; if not, branch
		tst.b	glass_stomp_delay(a0)			; has delay before moving down expired?
		beq.s	.moveDown				; if yes, start moving down pillar
		subq.b	#1,glass_stomp_delay(a0)		; decrement delay time
		bne.s	.setYDistance				; if time remains, don't move pillar down yet

	.moveDown:
		tst.w	glass_distanceY(a0)			; has pillar already been fully moved down?
		beq.s	.stopMoveDown				; if yes, don't move it down further
		subq.w	#1,glass_distanceY(a0)			; move pillar down 1px
		subq.w	#1,glass_stomp_distance(a0)		; decrement remaining pixels to move down
		bne.s	.setYDistance				; if more pixels remain, branch

	.stopMoveDown:
		bclr	#7,glass_stomp_flags(a0)		; stop pillar moving down from this stomp

	.setYDistance:
		move.w	glass_distanceY(a0),d0			; get current Y-distance pillar distance from origin
		bra.s	Glass_UpdateY				; set updated pillar Y-position
; ===========================================================================

; Subtype 4 - moves down after a matching switch was pressed
Glass_Type4_Switch:
		btst	#3,obSubtype(a0)			; is this the sheen object?
		beq.s	Glass_ChkSwitch				; if not, branch

		move.b	(v_oscillate+$12).w,d0			; get oscillation value for sheen (frequency = 4, middle value = $20)
		subi.w	#16,d0					; manually adjust sheen down by 16px
		bra.s	Glass_UpdateY				; oscillate sheen Y-position
; ---------------------------------------------------------------------------

Glass_ChkSwitch:
		tst.b	glass_switch_flag(a0)			; has switch already been pressed?
		bne.s	.movePillarDown				; if yes, branch

		lea	(f_switch).w,a2				; load switch status array
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; load object subtype number
		lsr.w	#4,d0					; read only the upper digit
		tst.b	(a2,d0.w)				; has switch matching upper subtype digit been pressed?
		beq.s	.setYDistance				; if not, branch
		move.b	#1,glass_switch_flag(a0)		; set flag to move pillar down

	.movePillarDown:
		tst.w	glass_distanceY(a0)			; has pillar already reached target destination?
		beq.s	.setYDistance				; if yes, don't move it down further
		subq.w	#2,glass_distanceY(a0)			; move pillar down at 2px/frame

	.setYDistance:
		move.w	glass_distanceY(a0),d0			; get current pillar Y-offset
; ---------------------------------------------------------------------------

Glass_UpdateY:
		move.w	glass_origY(a0),d1			; get initial Y-position
		sub.w	d0,d1					; add relative Y-offset (fixed position or oscillation value)
		move.w	d1,obY(a0)				; set adjusted Y-position
		rts						; return

; ===========================================================================

Map_Glass:	include	"_maps/MZ Large Green Glass Blocks.asm"
