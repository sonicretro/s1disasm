; ---------------------------------------------------------------------------
; Object 6C - vanishing	platforms (SBZ)
; ---------------------------------------------------------------------------

VanishPlatform:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	VanP_Index(pc,d0.w),d1
		jmp	VanP_Index(pc,d1.w)
; ===========================================================================
VanP_Index:	dc.w VanP_Main-VanP_Index
		dc.w VanP_Vanish-VanP_Index
		dc.w VanP_Appear-VanP_Index
		dc.w loc_16068-VanP_Index

vanp_timer:	= $30		; counter for time until event
vanp_timelen:	= $32		; time between events (general)
; ===========================================================================

VanP_Main:	; Routine 0
		addq.b	#6,obRoutine(a0)
		move.l	#Map_VanP,obMap(a0)
		move.w	#$44C3,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		andi.w	#$F,d0		; read only the	2nd digit
		addq.w	#1,d0		; add 1
		lsl.w	#7,d0		; multiply by $80
		move.w	d0,d1
		subq.w	#1,d0
		move.w	d0,vanp_timer(a0)
		move.w	d0,vanp_timelen(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		andi.w	#$F0,d0		; read only the	1st digit
		addi.w	#$80,d1
		mulu.w	d1,d0
		lsr.l	#8,d0
		move.w	d0,$36(a0)
		subq.w	#1,d1
		move.w	d1,$38(a0)

loc_16068:	; Routine 6
		move.w	(v_framecount).w,d0
		sub.w	$36(a0),d0
		and.w	$38(a0),d0
		bne.s	@animate
		subq.b	#4,obRoutine(a0) ; goto VanP_Vanish next
		bra.s	VanP_Vanish
; ===========================================================================

@animate:
		lea	(Ani_Van).l,a1
		jsr	AnimateSprite
		bra.w	RememberState
; ===========================================================================

VanP_Vanish:	; Routine 2
VanP_Appear:	; Routine 4
		subq.w	#1,vanp_timer(a0)
		bpl.s	@wait
		move.w	#127,vanp_timer(a0)
		tst.b	obAnim(a0)	; is platform vanishing?
		beq.s	@isvanishing	; if yes, branch
		move.w	vanp_timelen(a0),vanp_timer(a0)

	@isvanishing:
		bchg	#0,obAnim(a0)

	@wait:
		lea	(Ani_Van).l,a1
		jsr	AnimateSprite
		btst	#1,obFrame(a0)	; has platform vanished?
		bne.s	@notsolid	; if yes, branch
		cmpi.b	#2,obRoutine(a0)
		bne.s	@loc_160D6
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.w	RememberState
; ===========================================================================

@loc_160D6:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
		move.w	obX(a0),d2
		jsr	(MvSonicOnPtfm2).l
		bra.w	RememberState
; ===========================================================================

@notsolid:
		btst	#3,obStatus(a0)
		beq.s	@display
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		move.b	#2,obRoutine(a0)
		clr.b	obSolid(a0)

	@display:
		bra.w	RememberState
