; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ, LZ, SBZ)
; ---------------------------------------------------------------------------

MovingBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	MBlock_Index(pc,d0.w),d1
		jmp	MBlock_Index(pc,d1.w)
; ===========================================================================
MBlock_Index:	dc.w MBlock_Main-MBlock_Index
		dc.w MBlock_Platform-MBlock_Index
		dc.w MBlock_StandOn-MBlock_Index

mblock_origX = $30
mblock_origY = $32

MBlock_Var:	dc.b $10, 0		; object width,	frame number
		dc.b $20, 1
		dc.b $20, 2
		dc.b $40, 3
		dc.b $30, 4
; ===========================================================================

MBlock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_MBlock,obMap(a0)
		move.w	#$42B8,obGfx(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	loc_FE44
		move.l	#Map_MBlockLZ,obMap(a0) ; LZ specific code
		move.w	#$43BC,obGfx(a0)
		move.b	#7,obHeight(a0)

loc_FE44:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	loc_FE60
		move.w	#$22C0,obGfx(a0) ; SBZ specific code (object 5228)
		cmpi.b	#$28,obSubtype(a0) ; is object 5228 ?
		beq.s	loc_FE60	; if yes, branch
		move.w	#$4460,obGfx(a0) ; SBZ specific code (object 523x)

loc_FE60:
		move.b	#4,obRender(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	MBlock_Var(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		move.b	#4,obPriority(a0)
		move.w	obX(a0),mblock_origX(a0)
		move.w	obY(a0),mblock_origY(a0)
		andi.b	#$F,obSubtype(a0)

MBlock_Platform: ; Routine 2
		bsr.w	MBlock_Move
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.s	MBlock_ChkDel
; ===========================================================================

MBlock_StandOn:	; Routine 4
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
		move.w	obX(a0),-(sp)
		bsr.w	MBlock_Move
		move.w	(sp)+,d2
		jsr	(MvSonicOnPtfm2).l

MBlock_ChkDel:
		out_of_range.w	DeleteObject,mblock_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================

MBlock_Move:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	MBlock_TypeIndex(pc,d0.w),d1
		jmp	MBlock_TypeIndex(pc,d1.w)
; ===========================================================================
MBlock_TypeIndex:dc.w MBlock_Type00-MBlock_TypeIndex, MBlock_Type01-MBlock_TypeIndex
		dc.w MBlock_Type02-MBlock_TypeIndex, MBlock_Type03-MBlock_TypeIndex
		dc.w MBlock_Type02-MBlock_TypeIndex, MBlock_Type05-MBlock_TypeIndex
		dc.w MBlock_Type06-MBlock_TypeIndex, MBlock_Type07-MBlock_TypeIndex
		dc.w MBlock_Type08-MBlock_TypeIndex, MBlock_Type02-MBlock_TypeIndex
		dc.w MBlock_Type0A-MBlock_TypeIndex
; ===========================================================================

MBlock_Type00:
		rts	
; ===========================================================================

MBlock_Type01:
		move.b	(v_oscillate+$E).w,d0
		move.w	#$60,d1
		btst	#0,obStatus(a0)
		beq.s	loc_FF26
		neg.w	d0
		add.w	d1,d0

loc_FF26:
		move.w	mblock_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts	
; ===========================================================================

MBlock_Type02:
		cmpi.b	#4,obRoutine(a0) ; is Sonic standing on the platform?
		bne.s	MBlock_02_Wait
		addq.b	#1,obSubtype(a0) ; if yes, add 1 to type

MBlock_02_Wait:
		rts	
; ===========================================================================

MBlock_Type03:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1		; has the platform hit a wall?
		bmi.s	MBlock_03_End	; if yes, branch
		addq.w	#1,obX(a0)	; move platform	to the right
		move.w	obX(a0),mblock_origX(a0)
		rts	
; ===========================================================================

MBlock_03_End:
		clr.b	obSubtype(a0)	; change to type 00 (non-moving	type)
		rts	
; ===========================================================================

MBlock_Type05:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1		; has the platform hit a wall?
		bmi.s	MBlock_05_End	; if yes, branch
		addq.w	#1,obX(a0)	; move platform	to the right
		move.w	obX(a0),mblock_origX(a0)
		rts	
; ===========================================================================

MBlock_05_End:
		addq.b	#1,obSubtype(a0) ; change to type 06 (falling)
		rts	
; ===========================================================================

MBlock_Type06:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)	; make the platform fall
		bsr.w	ObjFloorDist
		tst.w	d1		; has platform hit the floor?
		bpl.w	locret_FFA0	; if not, branch
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)	; stop platform	falling
		clr.b	obSubtype(a0)	; change to type 00 (non-moving)

locret_FFA0:
		rts	
; ===========================================================================

MBlock_Type07:
		tst.b	(f_switch+2).w	; has switch number 02 been pressed?
		beq.s	MBlock_07_ChkDel
		subq.b	#3,obSubtype(a0) ; if yes, change object type to 04

MBlock_07_ChkDel:
		addq.l	#4,sp
		out_of_range.w	DeleteObject,mblock_origX(a0)
		rts	
; ===========================================================================

MBlock_Type08:
		move.b	(v_oscillate+$1E).w,d0
		move.w	#$80,d1
		btst	#0,obStatus(a0)
		beq.s	loc_FFE2
		neg.w	d0
		add.w	d1,d0

loc_FFE2:
		move.w	mblock_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

MBlock_Type0A:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		add.w	d3,d3
		moveq	#8,d1
		btst	#0,obStatus(a0)
		beq.s	loc_10004
		neg.w	d1
		neg.w	d3

loc_10004:
		tst.w	$36(a0)		; is platform set to move back?
		bne.s	MBlock_0A_Back	; if yes, branch
		move.w	obX(a0),d0
		sub.w	mblock_origX(a0),d0
		cmp.w	d3,d0
		beq.s	MBlock_0A_Wait
		add.w	d1,obX(a0)	; move platform
		move.w	#300,$34(a0)	; set time delay to 5 seconds
		rts	
; ===========================================================================

MBlock_0A_Wait:
		subq.w	#1,$34(a0)	; subtract 1 from time delay
		bne.s	locret_1002E	; if time remains, branch
		move.w	#1,$36(a0)	; set platform to move back to its original position

locret_1002E:
		rts	
; ===========================================================================

MBlock_0A_Back:
		move.w	obX(a0),d0
		sub.w	mblock_origX(a0),d0
		beq.s	MBlock_0A_Reset
		sub.w	d1,obX(a0)	; return platform to its original position
		rts	
; ===========================================================================

MBlock_0A_Reset:
		clr.w	$36(a0)
		subq.b	#1,obSubtype(a0)
		rts	
