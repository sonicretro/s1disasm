; ===========================================================================
; ---------------------------------------------------------------------------
; Object 60 - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Orbinaut:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Orb_Index(pc,d0.w),d1
		jmp	Orb_Index(pc,d1.w)
; ===========================================================================
Orb_Index:	dc.w Orb_Main-Orb_Index			; 0
		dc.w Orb_CheckSonic-Orb_Index		; 2
		dc.w Orb_DisplayAndMove-Orb_Index	; 4
		dc.w Orb_CircleSpikeball-Orb_Index	; 6
		dc.w Orb_FiredSpikeball-Orb_Index	; 8

orb_parent:	equ objoff_3C		; address of parent Orbinaut object for spikeballs
orb_circledir:	equ objoff_36		; circling direction for spikeballs (1 clockwise, -1 counter clockwise)
orb_balldata:	equ objoff_37		; ball data array (0: number of not-fired spikeballs // 1-4: RAM indeces for spikeballs)
; ===========================================================================

Orb_Main:	; Routine 0
		move.l	#Map_Orb,obMap(a0)			; set mappings

		move.w	#ArtTile_SBZ_Orbinaut,obGfx(a0)		; SBZ-specific art tile
		cmpi.b	#id_SBZ,(v_zone).w			; check if level is SBZ
		beq.s	.artTile				; if yes, branch
		move.w	#ArtTile_SLZ_Orbinaut|Tile_Pal2,obGfx(a0) ; SLZ-specific art tile and palette line
	.artTile:
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.continueSetup				; if not, branch
		move.w	#ArtTile_LZ_Orbinaut,obGfx(a0)		; LZ-specific art tile

	.continueSetup:
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#col_16x16|col_badnik,obColType(a0)	; set ReactToItem type
		move.b	#24/2,obActWid(a0)			; set sprite display width

		moveq	#0,d2					; clear d2 (used for angle offsets, starting at 0 degrees)
		lea	orb_balldata(a0),a2			; prepare ball data array
		movea.l	a2,a3					; keep a copy of the base address (will be used for ammo counter)
		addq.w	#1,a2					; advance remembered data pointer to next byte, will hold RAM indeces
		moveq	#4-1,d1					; load 4 orbiting spikeballs

.loopSpikeBalls:
		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.finishSpikeBalls			; if object RAM is full, branch
		addq.b	#1,(a3)					; increment number of attached spikeballs (ammo, basically)
		move.w	a1,d5					; copy target RAM location from FindNextFreeObj
		subi.w	#v_objspace&$FFFF,d5			; subtract base RAM offset
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; limit to sane value
		move.b	d5,(a2)+				; store RAM index for spikeball

		_move.b	obID(a0),obID(a1)			; load spiked orb object
		move.b	#6,obRoutine(a1)			; set to Orb_CircleSpikeball routine
		move.l	obMap(a0),obMap(a1)			; copy mappings
		move.w	obGfx(a0),obGfx(a1)			; copy art tile (zone-specific)
		ori.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#4,obPriority(a1)			; set sprite priority
		move.b	#16/2,obActWid(a1)			; set sprite display width
		move.b	#3,obFrame(a1)				; use spikeball frame
		move.b	#col_8x8|col_hurt,obColType(a1)		; set ReactToItem type (damaging)
		move.b	d2,obAngle(a1)				; set offset angle
		addi.b	#$40,d2					; make next spikeball offset by another 90 degrees
		move.l	a0,orb_parent(a1)			; remember parent Orbinaut object

		dbf	d1,.loopSpikeBalls			; repeat sequence 3 more times

.finishSpikeBalls:
		moveq	#1,d0					; circle clockwise by default
		btst	#0,obStatus(a0)				; is Orbinaut facing left?
		beq.s	.dir					; if not, branch
		neg.w	d0					; circle counter-clockwise instead
	.dir:	move.b	d0,orb_circledir(a0)			; set circling direction

		move.b	obSubtype(a0),obRoutine(a0)		; use subtype as base routine (0 = LZ // 2 = SLZ, skip Orb_CheckSonic)
		addq.b	#2,obRoutine(a0)			; advance to Orb_CheckSonic (LZ) or Orb_DisplayAndMove (SLZ)

		move.w	#-$40,obVelX(a0)			; move Orbinaut to the left
		btst	#0,obStatus(a0)				; is Orbinaut facing left?
		beq.s	.return					; if not, branch
		neg.w	obVelX(a0)				; move Orbinaut to the right

	.return:
		rts						; return
; ===========================================================================

Orb_CheckSonic:	; Routine 2
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; is Sonic to the right of the Orbinaut?
		bhs.s	.chkX					; if yes, branch
		neg.w	d0					; make difference positive
	.chkX:	cmpi.w	#160,d0					; is Sonic horizontally within 160px of Orbinaut?
		bhs.s	.animate				; if not, branch

		move.w	(v_player+obY).w,d0			; get Sonic's Y-position
		sub.w	obY(a0),d0				; is Sonic above the Orbinaut?
		bhs.s	.chkY					; if yes, branch
		neg.w	d0					; make difference positive
	.chkY:	cmpi.w	#80,d0					; is Sonic vertically within 80px of Orbinaut?
		bhs.s	.animate				; if not, branch

		tst.w	(v_debuguse).w				; is debug mode on?
		bne.s	.animate				; if yes, branch

		move.b	#1,obAnim(a0)				; use "angry" animation (triggers launch in Orb_CircleSpikeball)
; ---------------------------------------------------------------------------

.animate:
		lea	(Ani_Orb).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate Orbinaut
		bra.w	Orb_DisplayNoMove			; display or delete Orbinaut (no movement)
; ===========================================================================

Orb_DisplayAndMove: ; Routine 4
		bsr.w	SpeedToPos				; update Orbinaut's position

Orb_DisplayNoMove:
		out_of_range.w	.deleteWithSpikeballs		; has Orbinaut gone offscreen? if yes, branch
		bra.w	DisplaySprite				; otherwise, display it
; ---------------------------------------------------------------------------

; This is essentially a custom version of RememberState,
; as we also needs to delete any (non-fired) spikeballs.
.deleteWithSpikeballs:
		lea	(v_objstate).w,a2			; load respawn table
		moveq	#0,d0					; clear d0 for word-based addressing
		move.b	obRespawnNo(a0),d0			; get Orbinaut's respawn table index
		beq.s	.deleteBalls				; if it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear Orbinaut's respawn block flag so it can spawn again

	.deleteBalls:
		lea	orb_balldata(a0),a2			; load data of fired spikeballs
		moveq	#0,d2					; clear d2
		move.b	(a2)+,d2				; get number of not-fired spikeballs
		subq.w	#1,d2					; decrement for dbf
		bcs.s	.deleteParent				; if all spikeballs have already been fired, branch

	.loopDeleteBalls:
		moveq	#0,d0					; clear d0 for long-addressing
		move.b	(a2)+,d0				; get RAM index for spikeball
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM offset
		movea.l	d0,a1					; copy to a1 as input for DeleteChild
		bsr.w	DeleteChild				; delete spikeball
		dbf	d2,.loopDeleteBalls			; loop for all non-fired balls

	.deleteParent:
		bra.w	DeleteObject				; delete the parent Orbinaut object itself
; ===========================================================================

Orb_CircleSpikeball: ; Routine 6
		movea.l	orb_parent(a0),a1			; load parent Orbinaut object

		_cmpi.b	#id_Orbinaut,obID(a1)			; has parent Orbinaut object been deleted?
		bne.w	DeleteObject				; if yes, delete spikeball

		cmpi.b	#2,obFrame(a1)				; is Orbinaut angry?
		bne.s	.circleBalls				; if not, branch
		cmpi.b	#$40,obAngle(a0)			; is spikeball directly under the Orbinaut? (angle = 90 degrees)
		bne.s	.circleBalls				; if not, branch
		addq.b	#2,obRoutine(a0)			; set spikeball to Orb_FiredSpikeball
		subq.b	#1,orb_balldata(a1)			; decrement number of remaining non-fired spikeballs
		bne.s	.fireSpikeball				; if ammo is left, branch
		addq.b	#2,obRoutine(a1)			; once ammo is out, advance parent Orbinaut to Orb_DisplayAndMove to make it start moving

	.fireSpikeball:
		move.w	#-$200,obVelX(a0)			; shoot spikeball to the left
		btst	#0,obStatus(a1)				; is Orbinaut facing to the right?
		beq.s	.display				; if not, branch
		neg.w	obVelX(a0)				; shoot spikeball to the right instead

	.display:
		bra.w	DisplaySprite				; display spikeball sprite
; ---------------------------------------------------------------------------

.circleBalls:
		move.b	obAngle(a0),d0				; get current spikeball angle as input for CalcSine
		jsr	(CalcSine).l				; get sine and cosine from angle
		asr.w	#4,d1					; adjust radius for cosine part
		add.w	obX(a1),d1				; add parent's X-position
		move.w	d1,obX(a0)				; set result as new X-position for spikeball
		asr.w	#4,d0					; adjust radius for sine part
		add.w	obY(a1),d0				; add parent's Y-position
		move.w	d0,obY(a0)				; set result as new Y-position for spikeball

		move.b	orb_circledir(a1),d0			; get set circle direction (1 or -1)
		add.b	d0,obAngle(a0)				; advance angle to circle
		bra.w	DisplaySprite				; display spikeball sprite
; ===========================================================================

Orb_FiredSpikeball: ; Routine 8
		bsr.w	SpeedToPos				; update spikeball's position
		tst.b	obRender(a0)				; has spikeball gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		bra.w	DisplaySprite				; keep displaying spikeball
; ===========================================================================

		include	"_anim/Orbinaut.asm"
Map_Orb:	include	"_maps/Orbinaut.asm"
