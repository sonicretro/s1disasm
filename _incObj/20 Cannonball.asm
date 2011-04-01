; ---------------------------------------------------------------------------
; Object 20 - cannonball that Ball Hog throws (SBZ)
; ---------------------------------------------------------------------------

Cannonball:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cbal_Index(pc,d0.w),d1
		jmp	Cbal_Index(pc,d1.w)
; ===========================================================================
Cbal_Index:	dc.w Cbal_Main-Cbal_Index
		dc.w Cbal_Bounce-Cbal_Index

cbal_time:	= $30		; time until the cannonball explodes (2 bytes)
; ===========================================================================

Cbal_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#7,obHeight(a0)
		move.l	#Map_Hog,obMap(a0)
		move.w	#$2302,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; move subtype to d0
		mulu.w	#60,d0		; multiply by 60 frames	(1 second)
		move.w	d0,cbal_time(a0) ; set explosion time
		move.b	#4,obFrame(a0)

Cbal_Bounce:	; Routine 2
		jsr	ObjectFall
		tst.w	obVelY(a0)
		bmi.s	Cbal_ChkExplode
		jsr	ObjFloorDist
		tst.w	d1		; has ball hit the floor?
		bpl.s	Cbal_ChkExplode	; if not, branch

		add.w	d1,obY(a0)
		move.w	#-$300,obVelY(a0) ; bounce
		tst.b	d3
		beq.s	Cbal_ChkExplode
		bmi.s	loc_8CA4
		tst.w	obVelX(a0)
		bpl.s	Cbal_ChkExplode
		neg.w	obVelX(a0)
		bra.s	Cbal_ChkExplode
; ===========================================================================

loc_8CA4:
		tst.w	obVelX(a0)
		bmi.s	Cbal_ChkExplode
		neg.w	obVelX(a0)

Cbal_ChkExplode:			; XREF: Cbal_Bounce
		subq.w	#1,cbal_time(a0) ; subtract 1 from explosion time
		bpl.s	Cbal_Animate	; if time is > 0, branch

	Cbal_Explode:
		move.b	#id_MissileDissolve,0(a0)
		move.b	#id_ExplosionBomb,0(a0)	; change object	to an explosion	($3F)
		move.b	#0,obRoutine(a0) ; reset routine counter
		bra.w	ExplosionBomb	; jump to explosion code
; ===========================================================================

Cbal_Animate:
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	Cbal_Display
		move.b	#5,obTimeFrame(a0) ; set frame duration to 5 frames
		bchg	#0,obFrame(a0)	; change frame

Cbal_Display:
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object fallen off	the level?
		bcs.w	DeleteObject	; if yes, branch
		rts	
