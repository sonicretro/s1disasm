; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1F - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------

Crabmeat:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Crab_Index(pc,d0.w),d1
		jmp	Crab_Index(pc,d1.w)
; ===========================================================================
Crab_Index:	dc.w Crab_Main-Crab_Index	; 0
		dc.w Crab_Action-Crab_Index	; 2
		dc.w Crab_Delete-Crab_Index	; 4
		dc.w Crab_BallMain-Crab_Index	; 6
		dc.w Crab_BallMove-Crab_Index	; 8

crab_timedelay:	equ objoff_30		; delay timer before and after launching fireballs
crab_flags:	equ objoff_32		; contains two flags (0 = scuttle check mode // 1 = firing flag)
; ===========================================================================

Crab_Main:	; Routine 0
		move.b	#32/2,obHeight(a0)		; set height
		move.b	#16/2,obWidth(a0)		; set width
		move.l	#Map_Crab,obMap(a0)		; set mappings
		move.w	#ArtTile_Crabmeat,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
		move.b	#3,obPriority(a0)		; set sprite priority
		move.b	#col_badnik|col_32x32,obColType(a0) ; set collision type ($06)
		move.b	#42/2,obActWid(a0)		; set sprite display width

		; Make the Crabmeat fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall			; increase gravity and update position
		jsr	(ObjFloorDist).l		; get distance between Crabmeat and floor
		tst.w	d1				; has Crabmeat hit the floor?
		bpl.s	.hide				; if not, branch
		add.w	d1,obY(a0)			; match object's position with the floor
		move.b	d3,obAngle(a0)			; update angle to floor
		move.w	#0,obVelY(a0)			; clear falling speed
		addq.b	#2,obRoutine(a0)		; advance to Crab_Action
	.hide:
		rts					; return (and do NOT display sprite yet)
; ===========================================================================

Crab_Action:	; Routine 2
		moveq	#0,d0				; clear d0 (ob2ndRout is a byte, but we need word-addressing)
		move.b	ob2ndRout(a0),d0		; get secondary routine counter
		move.w	Crab_ActIndex(pc,d0.w),d1	; find current index in Crab_ActIndex
		jsr	Crab_ActIndex(pc,d1.w)		; jump there, then return here

		lea	(Ani_Crab).l,a1			; load Crabmeat animation script
		bsr.w	AnimateSprite			; animate with correct slope ID
		bra.w	RememberState			; display sprite, or delete object if offscreen
; ===========================================================================
Crab_ActIndex:	dc.w Crab_Action_WaitFire-Crab_ActIndex
		dc.w Crab_Action_Scuttle-Crab_ActIndex
; ===========================================================================

; .waittofire:
Crab_Action_WaitFire:
		subq.w	#1,crab_timedelay(a0)		; decrement firing time delay
		bpl.s	.return				; if time remains, branch
		tst.b	obRender(a0)			; is Crabmeat on screen?
		bpl.s	.startMoving			; if not, don't fire
		bchg	#1,crab_flags(a0)		; toggle firing flag
		bne.s	Crab_Action_Fire		; if it was already set, launch fireballs

	.startMoving:
		addq.b	#2,ob2ndRout(a0)		; advance to Crab_Action_Scuttle
		move.w	#128-1,crab_timedelay(a0)	; set time delay to approx 2 seconds
		move.w	#$80,obVelX(a0)			; move Crabmeat to the right
		bsr.w	Crab_SetAni			; find animation ID based on angle
		addq.b	#3,d0				; advance to walking set of animations
		move.b	d0,obAnim(a0)			; update Crabmeat animation ID
		bchg	#0,obStatus(a0)			; X-flip Crabmeat
		bne.s	.return				; is it facing left now? if not, branch
		neg.w	obVelX(a0)			; negate direction when moving left

	.return:
		rts					; return
; ---------------------------------------------------------------------------

Crab_Action_Fire:
		move.w	#60-1,crab_timedelay(a0)	; set time to stay on post-firing animation to 1 second
		move.b	#6,obAnim(a0)			; use firing animation

	.loadLeftFireball:
		bsr.w	FindFreeObj			; find a free object slot
		bne.s	.loadRightFireball		; if object RAM is full, branch (could just branch to return here, right will also fail)
		_move.b	#id_Crabmeat,obID(a1)		; load left fireball
		move.b	#6,obRoutine(a1)		; set to Crab_BallMain
		move.w	obX(a0),obX(a1)			; copy Crabmeat's X-position
		subi.w	#$10,obX(a1)			; align with left claw
		move.w	obY(a0),obY(a1)			; copy Crabmeat's Y-position
		move.w	#-$100,obVelX(a1)		; launch ball leftward

	.loadRightFireball:
		bsr.w	FindFreeObj			; find a free object slot
		bne.s	.return				; if object RAM is full, branch
		_move.b	#id_Crabmeat,obID(a1)		; load right fireball
		move.b	#6,obRoutine(a1)		; set to Crab_BallMain
		move.w	obX(a0),obX(a1)			; copy Crabmeat's X-position
		addi.w	#$10,obX(a1)			; align with right claw
		move.w	obY(a0),obY(a1)			; copy Crabmeat's Y-position
		move.w	#$100,obVelX(a1)		; launch ball rightward

	.return:
		rts					; return
; ===========================================================================

; .walkonfloor:
Crab_Action_Scuttle:
		subq.w	#1,crab_timedelay(a0)		; decrement timer until firing (if a ledge wasn't found first)
		bmi.s	.initFire			; if timer expired, launch fireballs

		bsr.w	SpeedToPos			; update Crabmeat position
		bchg	#0,crab_flags(a0)		; alternate between wall check and align/animate every frame
		bne.s	.alignAndAnimate		; branch for align/animate

		move.w	obX(a0),d3			; get Crabmeat's current X-position
		addi.w	#16,d3				; look 16px ahead to the right
		btst	#0,obStatus(a0)			; is Crabmeat currently facing to the left?
		beq.s	.checkLedge			; if not, branch
		subi.w	#16*2,d3			; look 16px ahead to the left instead
	; loc_9640:
	.checkLedge:
		jsr	(ObjFloorDist2).l		; get floor distance 16px ahead (left or right)
		cmpi.w	#-8,d1				; is there a steep upward slope ahead?
		blt.s	.initFire			; if yes, branch
		cmpi.w	#$C,d1				; is there a large drop ahead?
		bge.s	.initFire			; if yes, branch
		rts					; return
; ---------------------------------------------------------------------------

; loc_9654:
.alignAndAnimate:
		jsr	(ObjFloorDist).l		; calculate distance and angle to floor
		add.w	d1,obY(a0)			; align Crabmeat to floor
		move.b	d3,obAngle(a0)			; update angle to floor
		bsr.w	Crab_SetAni			; find animation ID based on angle
		addq.b	#3,d0				; advance to walking set of animations
		move.b	d0,obAnim(a0)			; update Crabmeat animation ID
		rts					; return
; ---------------------------------------------------------------------------

; loc_966E:
.initFire:
		subq.b	#2,ob2ndRout(a0)		; go back to Crab_Action_WaitFire
		move.w	#60-1,crab_timedelay(a0)	; set pre-firing delay to 1 second
		move.w	#0,obVelX(a0)			; stop Crabmeat from moving
		bsr.w	Crab_SetAni			; find animation ID based on angle
		move.b	d0,obAnim(a0)			; update Crabmeat animation ID
		rts					; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set d0 to correct animation ID based on the floor angle:
;   0 = flat
;   1 = sloped (regular, left leg extended)
;   2 = sloped (flipped, right leg extended)
; ---------------------------------------------------------------------------

Crab_SetAni:
		moveq	#0,d0				; use flat animation by default
		move.b	obAngle(a0),d3			; get Crabmeat's angle to floor
		bmi.s	Crab_SetAni_Ascending		; branch if on an ascending slope (to the right)

Crab_SetAni_Descending:
		cmpi.b	#6,d3				; is floor angle steep enough?
		blo.s	.return				; if not, keep using flat animation
		moveq	#1,d0				; use sloped animation
		btst	#0,obStatus(a0)			; is Crabmeat facing to the left?
		bne.s	.return				; if not, branch
		moveq	#2,d0				; use X-flipped sloped animation
	.return:
		rts					; return with animation ID in d0
; ---------------------------------------------------------------------------

; loc_96A4:
Crab_SetAni_Ascending:
		cmpi.b	#-6,d3				; is floor angle steep enough?
		bhi.s	.return				; if not, keep using flat animation
		moveq	#2,d0				; use X-flipped sloped animation
		btst	#0,obStatus(a0)			; is Crabmeat facing to the left?
		bne.s	.return				; if not, branch
		moveq	#1,d0				; use regular sloped animation
	.return:
		rts					; return with animation ID in d0
; End of function Crab_SetAni

; ===========================================================================

Crab_Delete:	; Routine 4 (unreachable, deletion is handled elsewhere)
		bsr.w	DeleteObject			; delete object
		rts					; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Sub-object - missile that the Crabmeat throws
; ---------------------------------------------------------------------------

Crab_BallMain:	; Routine 6
		addq.b	#2,obRoutine(a0)		; advance to Crab_BallMove
		move.l	#Map_Crab,obMap(a0)		; set mappings
		move.w	#ArtTile_Crabmeat,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
		move.b	#3,obPriority(a0)		; set sprite priority
		move.b	#col_12x12|col_hurt,obColType(a0) ; set hitbox size to 12x12 and make it damaging
		move.b	#16/2,obActWid(a0)		; set sprite display width
		move.w	#-$400,obVelY(a0)		; launch balls upwards
		move.b	#7,obAnim(a0)			; use ball animation
; ---------------------------------------------------------------------------

Crab_BallMove:	; Routine 8
		lea	(Ani_Crab).l,a1			; load crabmeat animation script
		bsr.w	AnimateSprite			; animate balls

		bsr.w	ObjectFall			; make balls fall (apply gravity)

	if FixBugs
		move.w	(v_limitbtm2).w,d0		; get lower level boundary
		addi.w	#224,d0				; add screen height
		cmp.w	obY(a0),d0			; have balls moved below the level boundary?
		blo.s	.delete				; if yes, branch
		bra.w	DisplaySprite			; display balls
	else
		; Another bug where an object is queued for display and then
		; deleted, causing a null-pointer dereference.
		bsr.w	DisplaySprite			; display balls
		move.w	(v_limitbtm2).w,d0		; get lower level boundary
		addi.w	#224,d0				; add screen height
		cmp.w	obY(a0),d0			; have balls moved below the level boundary?
		blo.s	.delete				; if yes, branch
		rts					; return
	endif

	.delete:
		bra.w	DeleteObject			; delete balls
; ===========================================================================

		include	"_anim/Crabmeat.asm"
Map_Crab:	include	"_maps/Crabmeat.asm"
