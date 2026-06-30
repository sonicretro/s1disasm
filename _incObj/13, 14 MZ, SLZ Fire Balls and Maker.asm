; ===========================================================================
; ---------------------------------------------------------------------------
; Object 13 - lava ball maker (MZ, SLZ)
; ---------------------------------------------------------------------------

LavaMaker:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LavaM_Index(pc,d0.w),d1
		jsr	LavaM_Index(pc,d1.w)

	if FixBugs
		; This had to be changed because LBall_ChkDel has
		; been adjusted to fix display-and-delete bugs.
		out_of_range.w	DeleteObject
		rts
	else
		bra.w	LBall_ChkDel
	endif
; ===========================================================================
LavaM_Index:	dc.w LavaM_Main-LavaM_Index
		dc.w LavaM_MakeLava-LavaM_Index
; ===========================================================================

LavaM_Rates:	; Lava ball firing intervals (multiples of 30 frames)
		dc.b 30, 60, 90, 120, 150, 180
; ===========================================================================

LavaM_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to LavaM_MakeLava

		move.b	obSubtype(a0),d0			; get maker's subtype
		lsr.w	#4,d0					; only read upper digit
		andi.w	#$F,d0					; limit to sane values
		move.b	LavaM_Rates(pc,d0.w),obDelayAni(a0)	; load firing interval for subtype (multiples of 30 frames)
		move.b	obDelayAni(a0),obTimeFrame(a0)		; set interval for firing lava balls
		andi.b	#$F,obSubtype(a0)			; clear upper subtype digit
; ---------------------------------------------------------------------------

LavaM_MakeLava:	; Routine 2
		subq.b	#1,obTimeFrame(a0)			; decrement firing interval
		bne.s	.return					; if time still remains, branch
		move.b	obDelayAni(a0),obTimeFrame(a0)		; reset firing interval

		bsr.w	ChkObjectVisible			; is lava maker on screen?
		bne.s	.return					; if not, don't spawn lava ball

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.return					; if object RAM is full, branch
		_move.b	#id_LavaBall,obID(a1)			; load lava ball object
		move.w	obX(a0),obX(a1)				; copy maker's X-position
		move.w	obY(a0),obY(a1)				; copy maker's Y-position
		move.b	obSubtype(a0),obSubtype(a1)		; copy maker's subtype

	.return:
		rts						; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 14 - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

LavaBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LBall_Index(pc,d0.w),d1
	if FixBugs
		jmp	LBall_Index(pc,d1.w)
	else
		jsr	LBall_Index(pc,d1.w)
		bra.w	DisplaySprite
	endif
; ===========================================================================
LBall_Index:	dc.w LBall_Main-LBall_Index
		dc.w LBall_Action-LBall_Index
		dc.w LBall_Delete-LBall_Index

lball_fromboss:	equ objoff_29	; set if spawned from MZ boss (from lava pit, see notes in BossMarble_MakeLava)
lball_origY:	equ objoff_30	; initial Y-position
; ===========================================================================

LBall_Speeds:	dc.w -$400	; 0 - vertical
		dc.w -$500	; 1 - vertical
		dc.w -$600	; 2 - vertical
		dc.w -$700	; 3 - vertical
		dc.w -$200	; 4 - vertical
		dc.w  $200	; 5 - vertical
		dc.w -$200	; 6 - horizontal
		dc.w  $200	; 7 - horizontal
		dc.w     0	; 8 - stationary
; ===========================================================================

LBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to LBall_Action
		move.b	#16/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width
		move.l	#Map_Fire,obMap(a0)			; set mappings

		move.w	#ArtTile_MZ_Fireball,obGfx(a0)		; set art tile for Marble Zone
		cmpi.b	#id_SLZ,(v_zone).w			; are we in Star Light Zone?
		bne.s	.continueSetup				; if not, branch
		move.w	#ArtTile_SLZ_Fireball,obGfx(a0)		; set art tile for Star Light Zone

	.continueSetup:
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#col_16x16|col_hurt,obColType(a0)	; make lava balls harmful on touch
		move.w	obY(a0),lball_origY(a0)			; remember initial Y-position (for balls that fall back down)

		tst.b	lball_fromboss(a0)			; was lava ball spawned from MZ boss? (balls that come from lava)
		beq.s	.setSpeed				; if not, branch
		addq.b	#2,obPriority(a0)			; use lower sprite priority

	.setSpeed:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get lava ball subtype
		add.w	d0,d0					; double for word-sized speed values
		move.w	LBall_Speeds(pc,d0.w),obVelY(a0)	; load object speed (vertical by default)
		move.b	#16/2,obActWid(a0)			; set sprite display width for vertical lava balls

		cmpi.b	#6,obSubtype(a0)			; is this a horizontal lava ball? (subtype 6 or higher)
		blo.s	.sound					; if not, branch (vertical lava ball)
		move.b	#32/2,obActWid(a0)			; set sprite display width for horizontal lava balls
		move.b	#2,obAnim(a0)				; use horizontal animation
		move.w	obVelY(a0),obVelX(a0)			; make balls fly horizontal instead
		move.w	#0,obVelY(a0)				; clear vertical speed

	.sound:
		move.w	#sfx_Fireball,d0			; set lava ball sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

LBall_Action:	; Routine 2
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get lavaball subtype (0-8)
		add.w	d0,d0					; double for word-based indexing
		move.w	LBall_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jsr	LBall_TypeIndex(pc,d1.w)		; execute lava ball behavior, then return here

		bsr.w	SpeedToPos				; update lava ball position
		lea	(Ani_Fire).l,a1				; load animation script
		bsr.w	AnimateSprite				; (wall-collided balls advance obRoutine to LBall_Delete)

LBall_ChkDel:
		out_of_range.w	DeleteObject			; has lava ball gone out of range? if yes, delete it
	if FixBugs
		bra.w	DisplaySprite				; display lava ball
	else
		rts						; return
	endif

; ===========================================================================
LBall_TypeIndex:dc.w LBall_RiseAndFall-LBall_TypeIndex		; 0
		dc.w LBall_RiseAndFall-LBall_TypeIndex		; 1
		dc.w LBall_RiseAndFall-LBall_TypeIndex		; 2
		dc.w LBall_RiseAndFall-LBall_TypeIndex		; 3
		dc.w LBall_Up-LBall_TypeIndex			; 4
		dc.w LBall_Down-LBall_TypeIndex			; 5
		dc.w LBall_Left-LBall_TypeIndex			; 6
		dc.w LBall_Right-LBall_TypeIndex		; 7
		dc.w LBall_DoNothing-LBall_TypeIndex		; 8
; ===========================================================================

; Types 00-03 - fly up and fall back down
LBall_RiseAndFall:
		addi.w	#$18,obVelY(a0)				; make lava ball fall down faster
		move.w	lball_origY(a0),d0			; get initial Y-position
		cmp.w	obY(a0),d0				; has object fallen back to its original position?
		bhs.s	.checkYFlip				; if not, branch
		addq.b	#2,obRoutine(a0)			; set to "LBall_Delete" routine

	.checkYFlip:
		bclr	#1,obStatus(a0)				; make lava ball face down
		tst.w	obVelY(a0)				; is lava ball still going up?
		bpl.s	.return					; if not, branch
		bset	#1,obStatus(a0)				; make lava ball face up

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; Type 4 - flies up until it hits the ceiling
LBall_Up:
		bset	#1,obStatus(a0)				; set Y-flip flag (face up)

		bsr.w	ObjHitCeiling				; get distance to ceiling
		tst.w	d1					; has ball hit the ceiling?
		bpl.s	.return					; if not, branch
		move.b	#8,obSubtype(a0)			; set to LBall_DoNothing (stop moving)
		move.b	#1,obAnim(a0)				; set to wall-collide animation (vertical)
		move.w	#0,obVelY(a0)				; stop the lava ball moving vertically

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; Type 5 - falls down until it hits the floor
LBall_Down:
		bclr	#1,obStatus(a0)				; clear Y-flip flag (face down)

		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has ball hit the floor?
		bpl.s	.return					; if not, branch
		move.b	#8,obSubtype(a0)			; set to LBall_DoNothing (stop moving)
		move.b	#1,obAnim(a0)				; set to wall-collide animation (vertical)
		move.w	#0,obVelY(a0)				; stop the lava ball moving vertically

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; Type 6 - moves sideways to the left
LBall_Left:
		bset	#0,obStatus(a0)				; set X-flip flag (face left)

		moveq	#-8,d3					; check 8px ahead to the left
		bsr.w	ObjHitWallLeft				; get distance to wall
		tst.w	d1					; has ball hit the wall?
		bpl.s	.return					; if not, branch
		move.b	#8,obSubtype(a0)			; set to LBall_DoNothing (stop moving)
		move.b	#3,obAnim(a0)				; set to wall-collide animation (horizontal)
		move.w	#0,obVelX(a0)				; stop the lava ball moving horizontally

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; Type 7 - moves sideways to the right
LBall_Right:
		bclr	#0,obStatus(a0)				; clear X-flip flag (face right)

		moveq	#8,d3					; check 8px ahead to the right
		bsr.w	ObjHitWallRight				; get distance to wall
		tst.w	d1					; has ball hit the wall?
		bpl.s	.return					; if not, branch
		move.b	#8,obSubtype(a0)			; set to LBall_DoNothing (stop moving)
		move.b	#3,obAnim(a0)				; set to wall-collide animation (horizontal)
		move.w	#0,obVelX(a0)				; stop the lava ball moving horizontally

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; Type 8 - doesn't move at all (set when collided with wall)
LBall_DoNothing:
		rts						; do nothing
; ===========================================================================

LBall_Delete:	; Routine 4
		bra.w	DeleteObject				; delete lava ball

; ===========================================================================

		include	"_anim/Fireballs.asm"
