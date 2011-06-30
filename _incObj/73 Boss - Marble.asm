; ---------------------------------------------------------------------------
; Object 73 - Eggman (MZ)
; ---------------------------------------------------------------------------

BossMarble:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj73_Index(pc,d0.w),d1
		jmp	Obj73_Index(pc,d1.w)
; ===========================================================================
Obj73_Index:	dc.w Obj73_Main-Obj73_Index
		dc.w Obj73_ShipMain-Obj73_Index
		dc.w Obj73_FaceMain-Obj73_Index
		dc.w Obj73_FlameMain-Obj73_Index
		dc.w Obj73_TubeMain-Obj73_Index

Obj73_ObjData:	dc.b 2,	0, 4		; routine number, animation, priority
		dc.b 4,	1, 4
		dc.b 6,	7, 4
		dc.b 8,	0, 3
; ===========================================================================

Obj73_Main:	; Routine 0
		move.w	obX(a0),$30(a0)
		move.w	obY(a0),$38(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obColProp(a0) ; set number of hits to 8
		lea	Obj73_ObjData(pc),a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	Obj73_LoadBoss
; ===========================================================================

Obj73_Loop:
		jsr	FindNextFreeObj
		bne.s	Obj73_ShipMain
		move.b	#id_BossMarble,0(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

Obj73_LoadBoss:				; XREF: Obj73_Main
		bclr	#0,obStatus(a0)
		clr.b	ob2ndRout(a1)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,obAnim(a1)
		move.b	(a2)+,obPriority(a1)
		move.l	#Map_Eggman,obMap(a1)
		move.w	#$400,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.l	a0,$34(a1)
		dbf	d1,Obj73_Loop	; repeat sequence 3 more times

Obj73_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Obj73_ShipIndex(pc,d0.w),d1
		jsr	Obj73_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	AnimateSprite
		moveq	#3,d0
		and.b	obStatus(a0),d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	DisplaySprite
; ===========================================================================
Obj73_ShipIndex:dc.w loc_18302-Obj73_ShipIndex
		dc.w loc_183AA-Obj73_ShipIndex
		dc.w loc_184F6-Obj73_ShipIndex
		dc.w loc_1852C-Obj73_ShipIndex
		dc.w loc_18582-Obj73_ShipIndex
; ===========================================================================

loc_18302:				; XREF: Obj73_ShipIndex
		move.b	$3F(a0),d0
		addq.b	#2,$3F(a0)
		jsr	(CalcSine).l
		asr.w	#2,d0
		move.w	d0,obVelY(a0)
		move.w	#-$100,obVelX(a0)
		bsr.w	BossMove
		cmpi.w	#$1910,$30(a0)
		bne.s	loc_18334
		addq.b	#2,ob2ndRout(a0)
		clr.b	obSubtype(a0)
		clr.l	obVelX(a0)

loc_18334:
		jsr	(RandomNumber).l
		move.b	d0,$34(a0)

loc_1833E:
		move.w	$38(a0),obY(a0)
		move.w	$30(a0),obX(a0)
		cmpi.b	#4,ob2ndRout(a0)
		bcc.s	locret_18390
		tst.b	obStatus(a0)
		bmi.s	loc_18392
		tst.b	obColType(a0)
		bne.s	locret_18390
		tst.b	$3E(a0)
		bne.s	loc_18374
		move.b	#$28,$3E(a0)
		sfx	sfx_HitBoss	; play boss damage sound

loc_18374:
		lea	(v_pal_dry+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_18382
		move.w	#cWhite,d0

loc_18382:
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_18390
		move.b	#$F,obColType(a0)

locret_18390:
		rts	
; ===========================================================================

loc_18392:				; XREF: loc_1833E
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#4,ob2ndRout(a0)
		move.w	#$B4,$3C(a0)
		clr.w	obVelX(a0)
		rts	
; ===========================================================================

loc_183AA:				; XREF: Obj73_ShipIndex
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.w	off_183C2(pc,d0.w),d0
		jsr	off_183C2(pc,d0.w)
		andi.b	#6,obSubtype(a0)
		bra.w	loc_1833E
; ===========================================================================
off_183C2:	dc.w loc_183CA-off_183C2
		dc.w Obj73_MakeLava2-off_183C2
		dc.w loc_183CA-off_183C2
		dc.w Obj73_MakeLava2-off_183C2
; ===========================================================================

loc_183CA:				; XREF: off_183C2
		tst.w	obVelX(a0)
		bne.s	loc_183FE
		moveq	#$40,d0
		cmpi.w	#$22C,$38(a0)
		beq.s	loc_183E6
		bcs.s	loc_183DE
		neg.w	d0

loc_183DE:
		move.w	d0,obVelY(a0)
		bra.w	BossMove
; ===========================================================================

loc_183E6:
		move.w	#$200,obVelX(a0)
		move.w	#$100,obVelY(a0)
		btst	#0,obStatus(a0)
		bne.s	loc_183FE
		neg.w	obVelX(a0)

loc_183FE:
		cmpi.b	#$18,$3E(a0)
		bcc.s	Obj73_MakeLava
		bsr.w	BossMove
		subq.w	#4,obVelY(a0)

Obj73_MakeLava:
		subq.b	#1,$34(a0)
		bcc.s	loc_1845C
		jsr	FindFreeObj
		bne.s	loc_1844A
		move.b	#id_LavaBall,0(a1) ; load lava ball object
		move.w	#$2E8,obY(a1)	; set Y	position
		jsr	(RandomNumber).l
		andi.l	#$FFFF,d0
		divu.w	#$50,d0
		swap	d0
		addi.w	#$1878,d0
		move.w	d0,obX(a1)
		lsr.b	#7,d1
		move.w	#$FF,obSubtype(a1)

loc_1844A:
		jsr	(RandomNumber).l
		andi.b	#$1F,d0
		addi.b	#$40,d0
		move.b	d0,$34(a0)

loc_1845C:
		btst	#0,obStatus(a0)
		beq.s	loc_18474
		cmpi.w	#$1910,$30(a0)
		blt.s	locret_1849C
		move.w	#$1910,$30(a0)
		bra.s	loc_18482
; ===========================================================================

loc_18474:
		cmpi.w	#$1830,$30(a0)
		bgt.s	locret_1849C
		move.w	#$1830,$30(a0)

loc_18482:
		clr.w	obVelX(a0)
		move.w	#-$180,obVelY(a0)
		cmpi.w	#$22C,$38(a0)
		bcc.s	loc_18498
		neg.w	obVelY(a0)

loc_18498:
		addq.b	#2,obSubtype(a0)

locret_1849C:
		rts	
; ===========================================================================

Obj73_MakeLava2:			; XREF: off_183C2
		bsr.w	BossMove
		move.w	$38(a0),d0
		subi.w	#$22C,d0
		bgt.s	locret_184F4
		move.w	#$22C,d0
		tst.w	obVelY(a0)
		beq.s	loc_184EA
		clr.w	obVelY(a0)
		move.w	#$50,$3C(a0)
		bchg	#0,obStatus(a0)
		jsr	FindFreeObj
		bne.s	loc_184EA
		move.w	$30(a0),obX(a1)
		move.w	$38(a0),obY(a1)
		addi.w	#$18,obY(a1)
		move.b	#$74,(a1)	; load lava ball object
		move.b	#1,obSubtype(a1)

loc_184EA:
		subq.w	#1,$3C(a0)
		bne.s	locret_184F4
		addq.b	#2,obSubtype(a0)

locret_184F4:
		rts	
; ===========================================================================

loc_184F6:				; XREF: Obj73_ShipIndex
		subq.w	#1,$3C(a0)
		bmi.s	loc_18500
		bra.w	BossDefeated
; ===========================================================================

loc_18500:
		bset	#0,obStatus(a0)
		bclr	#7,obStatus(a0)
		clr.w	obVelX(a0)
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$26,$3C(a0)
		tst.b	(v_bossstatus).w
		bne.s	locret_1852A
		move.b	#1,(v_bossstatus).w
		clr.w	obVelY(a0)

locret_1852A:
		rts	
; ===========================================================================

loc_1852C:				; XREF: Obj73_ShipIndex
		addq.w	#1,$3C(a0)
		beq.s	loc_18544
		bpl.s	loc_1854E
		cmpi.w	#$270,$38(a0)
		bcc.s	loc_18544
		addi.w	#$18,obVelY(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_18544:
		clr.w	obVelY(a0)
		clr.w	$3C(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_1854E:
		cmpi.w	#$30,$3C(a0)
		bcs.s	loc_18566
		beq.s	loc_1856C
		cmpi.w	#$38,$3C(a0)
		bcs.s	loc_1857A
		addq.b	#2,ob2ndRout(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_18566:
		subq.w	#8,obVelY(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_1856C:
		clr.w	obVelY(a0)
		music	bgm_MZ		; play MZ music

loc_1857A:
		bsr.w	BossMove
		bra.w	loc_1833E
; ===========================================================================

loc_18582:				; XREF: Obj73_ShipIndex
		move.w	#$500,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		cmpi.w	#$1960,(v_limitright2).w
		bcc.s	loc_1859C
		addq.w	#2,(v_limitright2).w
		bra.s	loc_185A2
; ===========================================================================

loc_1859C:
		tst.b	obRender(a0)
		bpl.s	Obj73_ShipDel

loc_185A2:
		bsr.w	BossMove
		bra.w	loc_1833E
; ===========================================================================

Obj73_ShipDel:
		jmp	DeleteObject
; ===========================================================================

Obj73_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#1,d1
		movea.l	$34(a0),a1
		move.b	ob2ndRout(a1),d0
		subq.w	#2,d0
		bne.s	loc_185D2
		btst	#1,obSubtype(a1)
		beq.s	loc_185DA
		tst.w	obVelY(a1)
		bne.s	loc_185DA
		moveq	#4,d1
		bra.s	loc_185EE
; ===========================================================================

loc_185D2:
		subq.b	#2,d0
		bmi.s	loc_185DA
		moveq	#$A,d1
		bra.s	loc_185EE
; ===========================================================================

loc_185DA:
		tst.b	obColType(a1)
		bne.s	loc_185E4
		moveq	#5,d1
		bra.s	loc_185EE
; ===========================================================================

loc_185E4:
		cmpi.b	#4,(v_player+obRoutine).w
		bcs.s	loc_185EE
		moveq	#4,d1

loc_185EE:
		move.b	d1,obAnim(a0)
		subq.b	#4,d0
		bne.s	loc_18602
		move.b	#6,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	Obj73_FaceDel

loc_18602:
		bra.s	Obj73_Display
; ===========================================================================

Obj73_FaceDel:
		jmp	DeleteObject
; ===========================================================================

Obj73_FlameMain:; Routine 6
		move.b	#7,obAnim(a0)
		movea.l	$34(a0),a1
		cmpi.b	#8,ob2ndRout(a1)
		blt.s	loc_1862A
		move.b	#$B,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	Obj73_FlameDel
		bra.s	loc_18636
; ===========================================================================

loc_1862A:
		tst.w	obVelX(a1)
		beq.s	loc_18636
		move.b	#8,obAnim(a0)

loc_18636:
		bra.s	Obj73_Display
; ===========================================================================

Obj73_FlameDel:				; XREF: Obj73_FlameMain
		jmp	DeleteObject
; ===========================================================================

Obj73_Display:
		lea	(Ani_Eggman).l,a1
		jsr	AnimateSprite

loc_1864A:
		movea.l	$34(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)
		moveq	#3,d0
		and.b	obStatus(a0),d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	DisplaySprite
; ===========================================================================

Obj73_TubeMain:	; Routine 8
		movea.l	$34(a0),a1
		cmpi.b	#8,ob2ndRout(a1)
		bne.s	loc_18688
		tst.b	obRender(a0)
		bpl.s	Obj73_TubeDel

loc_18688:
		move.l	#Map_BossItems,obMap(a0)
		move.w	#$246C,obGfx(a0)
		move.b	#4,obFrame(a0)
		bra.s	loc_1864A
; ===========================================================================

Obj73_TubeDel:
		jmp	DeleteObject
