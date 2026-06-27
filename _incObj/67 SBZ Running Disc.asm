; ===========================================================================
; ---------------------------------------------------------------------------
; Object 67 - disc that Sonic runs around (SBZ act 2)
; 
; Note: This is just the invisible object that control Sonic,
; as well as the small circular spot that moves inside the gear.
; The gear graphics themselves are part of the level chunks.
; ---------------------------------------------------------------------------

RunningDisc:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Disc_Index(pc,d0.w),d1
		jmp	Disc_Index(pc,d1.w)
; ===========================================================================
Disc_Index:	dc.w Disc_Main-Disc_Index
		dc.w Disc_Action-Disc_Index

disc_origY:		equ objoff_30		; original y-axis position
disc_origX:		equ objoff_32		; original x-axis position
disc_spot_distance:	equ objoff_34		; radius distance for the small moving spot inside gear
disc_spot_speed:	equ objoff_36		; small spot rotation speed
disc_triggersize:	equ objoff_38		; trigger distance for Sonic to latch onto gear
disc_sonic_attached:	equ objoff_3A		; flag set while Sonic is attached to gear
; ===========================================================================

Disc_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Disc_Action
		move.l	#Map_Disc,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Disc|Tile_Pal3|Tile_Prio,obGfx(a0) ; set art tile, palette line, and high-priority flag
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#16/2,obActWid(a0)			; set sprite display width

		move.w	obX(a0),disc_origX(a0)			; remember initial X-position
		move.w	obY(a0),disc_origY(a0)			; remember initial Y-position
		move.b	#$18,disc_spot_distance(a0)		; set radius distance for the small moving spot inside gear
		move.b	#$48,disc_triggersize(a0)		; set trigger distance for Sonic to latch onto gear

		; This is a leftover from the prototype, where it was planned to also
		; have smaller sized gears. In the final game, only large gears exist.
		move.b	obSubtype(a0),d1			; get object subtype
		andi.b	#$0F,d1					; read only the lower digit
		beq.s	.setupSmallDot				; branch if 0 (it always is)
		move.b	#$10,disc_spot_distance(a0)		; use smaller spot radius
		move.b	#$38,disc_triggersize(a0)		; use shorter trigger distance

	.setupSmallDot:
		move.b	obSubtype(a0),d1			; get object subtype again
		andi.b	#$F0,d1					; read only the upper digit
		ext.w	d1					; extend to word
		asl.w	#3,d1					; multiply by 8
		move.w	d1,disc_spot_speed(a0)			; set result as rotation speed for the small spot

		move.b	obStatus(a0),d0				; get status flags containing X/Y-flip flags
		ror.b	#2,d0					; move X/Y-flip flags in bits 0-1 to upper bits 6-7
		andi.b	#%11000000,d0				; limit to only bits 6-7 ($C0)
		move.b	d0,obAngle(a0)				; set initial angle for small spot
; ---------------------------------------------------------------------------

Disc_Action:	; Routine 2
		bsr.w	Disc_MoveSonic				; handle Sonic moving on gear
		bsr.w	Disc_MoveSpot				; move the spot inside the gear circularly
		bra.w	Disc_Display				; display spot, or delete whole object if offscreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle Sonic around the gear
; ---------------------------------------------------------------------------

Disc_MoveSonic:
		moveq	#0,d2					; clear d2
		move.b	disc_triggersize(a0),d2			; get trigger distance for Sonic to latch onto gear
		move.w	d2,d3					; copy trigger distance
		add.w	d3,d3					; double trigger distance to get diameter

		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a1),d0				; get Sonic's current X-position
		sub.w	disc_origX(a0),d0			; calculate difference to gear's X-position
		add.w	d2,d0					; add trigger distance
		cmp.w	d3,d0					; is Sonic horizontally within trigger distance?
		bhs.s	Disc_DetachSonic			; if not, branch

		move.w	obY(a1),d1				; get Sonic's current Y-position
		sub.w	disc_origY(a0),d1			; calculate difference to gear's Y-position
		add.w	d2,d1					; add trigger distance
		cmp.w	d3,d1					; is Sonic vertically within trigger distance?
		bhs.s	Disc_DetachSonic			; if not, branch

		btst	#1,obStatus(a1)				; is Sonic on the ground?
		beq.s	Disc_AttachSonic			; if yes, attach Sonic to gear
		clr.b	disc_sonic_attached(a0)			; clear attached flag while Sonic is in air
		rts						; return
; ===========================================================================

Disc_DetachSonic:
		tst.b	disc_sonic_attached(a0)			; was Sonic attached to gear?
		beq.s	.return					; if not, branch
		clr.b	sticktoconvex(a1)			; clear Sonic's stick-to-convex state flag
		clr.b	disc_sonic_attached(a0)			; clear attached flag for gear

	.return:
		rts						; return
; ===========================================================================

Disc_AttachSonic:
		tst.b	disc_sonic_attached(a0)			; was Sonic already attached to gear?
		bne.s	.moveSonic				; if yes, branch

		move.b	#1,disc_sonic_attached(a0)		; set attached flag for gear
		btst	#2,obStatus(a1)				; is Sonic rolling?
		bne.s	.stickToConvex				; if yes, branch
		clr.b	obAnim(a1)				; set Sonic's animation back to walking (ID 0)
	.stickToConvex:
		bclr	#5,obStatus(a1)				; clear Sonic's pushing flag
		move.b	#id_Run,obPrevAni(a1)			; restart Sonic's animation
		move.b	#1,sticktoconvex(a1)			; set Sonic's stick-to-convex state flag for the gear
; ---------------------------------------------------------------------------

.moveSonic:
		move.w	obInertia(a1),d0			; get Sonic's current ground speed
		tst.w	disc_spot_speed(a0)			; is gear moving clockwise? (it always is)
		bpl.s	.clockwiseMinSpeed			; if yes, branch

	.counterclockwiseMinSpeed:
		cmpi.w	#-$400,d0				; is Sonic's speed at least $400? (to the left)
		ble.s	.counterclockwiseMaxSpeed		; if yes, branch
		move.w	#-$400,obInertia(a1)			; force Sonic's minimum speed on gear
		rts						; return
; ---------------------------------------------------------------------------

	.counterclockwiseMaxSpeed:
		cmpi.w	#-$F00,d0				; is Sonic's speed greater than $F00? (to the left)
		bge.s	.return					; if not, branch
		move.w	#-$F00,obInertia(a1)			; limit Sonic's maximum speed on gear
	.return:
		rts						; return
; ===========================================================================

	.clockwiseMinSpeed:
		cmpi.w	#$400,d0				; is Sonic's speed at least $400? (to the right)
		bge.s	.clockwiseMaxSpeed			; if yes, branch
		move.w	#$400,obInertia(a1)			; force Sonic's minimum speed on gear
		rts						; return
; ---------------------------------------------------------------------------

	.clockwiseMaxSpeed:
		cmpi.w	#$F00,d0				; is Sonic's speed greater than $F00? (to the right)
		ble.s	.return2				; if not, branch
		move.w	#$F00,obInertia(a1)			; limit Sonic's maximum speed on gear
	.return2:
		rts						; return
; End of function Disc_MoveSonic

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move the small spot inside the gear circularly
; ---------------------------------------------------------------------------

Disc_MoveSpot:
		move.w	disc_spot_speed(a0),d0			; get object circling speed (can be positive or negative)
		add.w	d0,obAngle(a0)				; add speed to current angle

		move.b	obAngle(a0),d0				; get current angle
		jsr	(CalcSine).l				; calculate sine and cosine for current angle
		move.w	disc_origY(a0),d2			; get initial X-position
		move.w	disc_origX(a0),d3			; get initial Y-position

		moveq	#0,d4					; clear d4
		move.b	disc_spot_distance(a0),d4		; get radius distance for spot
		lsl.w	#8,d4					; shift radius into upper byte
		move.l	d4,d5					; copy radius
		muls.w	d0,d4					; multiply radius by angle sine
		swap	d4					; use upper word from result
		muls.w	d1,d5					; multiply radius by angle cosine
		swap	d5					; use upper word from result
		add.w	d2,d4					; add initial Y-position to sine
		add.w	d3,d5					; add initial X-position to cosine
		move.w	d4,obY(a0)				; set new X/Y-positions...
		move.w	d5,obX(a0)				; ...to move spot circularly
		rts						; return
; End of function Disc_MoveSpot

; ===========================================================================

Disc_Display:
		out_of_range.s	.delete,disc_origX(a0)		; is object out of range? if yes, branch
		jmp	(DisplaySprite).l			; display small spot

	.delete:
		jmp	(DeleteObject).l			; delete whole object

; ===========================================================================

Map_Disc:	include	"_maps/Running Disc.asm"
