; ---------------------------------------------------------------------------
; Object 1E - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------

BallHog:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Hog_Index(pc,d0.w),d1
		jmp	Hog_Index(pc,d1.w)
; ===========================================================================
Hog_Index:	dc.w Hog_Main-Hog_Index
		dc.w Hog_Action-Hog_Index

launchflag:	= $32		; 0 to launch a cannonball
; ===========================================================================

Hog_Main:	; Routine 0
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Hog,obMap(a0)
		move.w	#$2302,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		bsr.w	ObjectFall
		jsr	ObjFloorDist	; find floor
		tst.w	d1
		bpl.s	@floornotfound
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)

	@floornotfound:
		rts	
; ===========================================================================

Hog_Action:	; Routine 2
		lea	(Ani_Hog).l,a1
		bsr.w	AnimateSprite
		cmpi.b	#1,obFrame(a0)	; is final frame (01) displayed?
		bne.s	@setlaunchflag	; if not, branch
		tst.b	launchflag(a0)	; is it	set to launch cannonball?
		beq.s	@makeball	; if yes, branch
		bra.s	@remember
; ===========================================================================

@setlaunchflag:
		clr.b	launchflag(a0)	; set to launch	cannonball

@remember:
		bra.w	RememberState
; ===========================================================================

@makeball:
		move.b	#1,launchflag(a0)
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Cannonball,0(a1) ; load cannonball object ($20)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$100,obVelX(a1) ; cannonball bounces to the left
		move.w	#0,obVelY(a1)
		moveq	#-4,d0
		btst	#0,obStatus(a0)	; is Ball Hog facing right?
		beq.s	@noflip		; if not, branch
		neg.w	d0
		neg.w	obVelX(a1)	; cannonball bounces to	the right

	@noflip:
		add.w	d0,obX(a1)
		addi.w	#$C,obY(a1)
		move.b	obSubtype(a0),obSubtype(a1) ; copy object type from Ball Hog

	@fail:
		bra.s	@remember
