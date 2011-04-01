; ---------------------------------------------------------------------------
; Object 86 - energy balls (FZ)
; ---------------------------------------------------------------------------

BossPlasma:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj86_Index(pc,d0.w),d0
		jmp	Obj86_Index(pc,d0.w)
; ===========================================================================
Obj86_Index:	dc.w Obj86_Main-Obj86_Index
		dc.w Obj86_Generator-Obj86_Index
		dc.w Obj86_MakeBalls-Obj86_Index
		dc.w loc_1A962-Obj86_Index
		dc.w loc_1A982-Obj86_Index
; ===========================================================================

Obj86_Main:	; Routine 0
		move.w	#$2588,obX(a0)
		move.w	#$53C,obY(a0)
		move.w	#$300,obGfx(a0)
		move.l	#Map_PLaunch,obMap(a0)
		move.b	#0,obAnim(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obWidth(a0)
		move.b	#8,obHeight(a0)
		move.b	#4,obRender(a0)
		bset	#7,obRender(a0)
		addq.b	#2,obRoutine(a0)

Obj86_Generator:; Routine 2
		movea.l	$34(a0),a1
		cmpi.b	#6,$34(a1)
		bne.s	loc_1A850
		move.b	#$3F,(a0)
		move.b	#0,obRoutine(a0)
		jmp	DisplaySprite
; ===========================================================================

loc_1A850:
		move.b	#0,obAnim(a0)
		tst.b	$29(a0)
		beq.s	loc_1A86C
		addq.b	#2,obRoutine(a0)
		move.b	#1,obAnim(a0)
		move.b	#$3E,obSubtype(a0)

loc_1A86C:
		move.w	#$13,d1
		move.w	#8,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		jsr	SolidObject
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bmi.s	loc_1A89A
		subi.w	#$140,d0
		bmi.s	loc_1A89A
		tst.b	obRender(a0)
		bpl.w	Obj84_Delete

loc_1A89A:
		lea	Ani_PLaunch(pc),a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ===========================================================================

Obj86_MakeBalls:; Routine 4
		tst.b	$29(a0)
		beq.w	loc_1A954
		clr.b	$29(a0)
		add.w	$30(a0),d0
		andi.w	#$1E,d0
		adda.w	d0,a2
		addq.w	#4,$30(a0)
		clr.w	$32(a0)
		moveq	#3,d2

Obj86_Loop:
		jsr	FindNextFreeObj
		bne.w	loc_1A954
		move.b	#id_BossPlasma,(a1)
		move.w	obX(a0),obX(a1)
		move.w	#$53C,obY(a1)
		move.b	#8,obRoutine(a1)
		move.w	#$2300,obGfx(a1)
		move.l	#Map_Plasma,obMap(a1)
		move.b	#$C,obHeight(a1)
		move.b	#$C,obWidth(a1)
		move.b	#0,obColType(a1)
		move.b	#3,obPriority(a1)
		move.w	#$3E,obSubtype(a1)
		move.b	#4,obRender(a1)
		bset	#7,obRender(a1)
		move.l	a0,$34(a1)
		jsr	(RandomNumber).l
		move.w	$32(a0),d1
		muls.w	#-$4F,d1
		addi.w	#$2578,d1
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d1,d0
		move.w	d0,$30(a1)
		addq.w	#1,$32(a0)
		move.w	$32(a0),$38(a0)
		dbf	d2,Obj86_Loop	; repeat sequence 3 more times

loc_1A954:
		tst.w	$32(a0)
		bne.s	loc_1A95E
		addq.b	#2,obRoutine(a0)

loc_1A95E:
		bra.w	loc_1A86C
; ===========================================================================

loc_1A962:	; Routine 6
		move.b	#2,obAnim(a0)
		tst.w	$38(a0)
		bne.s	loc_1A97E
		move.b	#2,obRoutine(a0)
		movea.l	$34(a0),a1
		move.w	#-1,$32(a1)

loc_1A97E:
		bra.w	loc_1A86C
; ===========================================================================

loc_1A982:	; Routine 8
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Obj86_Index2(pc,d0.w),d0
		jsr	Obj86_Index2(pc,d0.w)
		lea	Ani_Plasma(pc),a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ===========================================================================
Obj86_Index2:	dc.w loc_1A9A6-Obj86_Index2
		dc.w loc_1A9C0-Obj86_Index2
		dc.w loc_1AA1E-Obj86_Index2
; ===========================================================================

loc_1A9A6:				; XREF: Obj86_Index2
		move.w	$30(a0),d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)
		move.w	#$B4,obSubtype(a0)
		addq.b	#2,ob2ndRout(a0)
		rts	
; ===========================================================================

loc_1A9C0:				; XREF: Obj86_Index2
		tst.w	obVelX(a0)
		beq.s	loc_1A9E6
		jsr	SpeedToPos
		move.w	obX(a0),d0
		sub.w	$30(a0),d0
		bcc.s	loc_1A9E6
		clr.w	obVelX(a0)
		add.w	d0,obX(a0)
		movea.l	$34(a0),a1
		subq.w	#1,$32(a1)

loc_1A9E6:
		move.b	#0,obAnim(a0)
		subq.w	#1,obSubtype(a0)
		bne.s	locret_1AA1C
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.b	#$9A,obColType(a0)
		move.w	#$B4,obSubtype(a0)
		moveq	#0,d0
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		move.w	d0,obVelX(a0)
		move.w	#$140,obVelY(a0)

locret_1AA1C:
		rts	
; ===========================================================================

loc_1AA1E:				; XREF: Obj86_Index2
		jsr	SpeedToPos
		cmpi.w	#$5E0,obY(a0)
		bcc.s	loc_1AA34
		subq.w	#1,obSubtype(a0)
		beq.s	loc_1AA34
		rts	
; ===========================================================================

loc_1AA34:
		movea.l	$34(a0),a1
		subq.w	#1,$38(a1)
		bra.w	Obj84_Delete
