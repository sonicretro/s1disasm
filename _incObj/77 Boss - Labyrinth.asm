; ---------------------------------------------------------------------------
; Object 77 - Eggman (LZ)
; ---------------------------------------------------------------------------

BossLabyrinth:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj77_Index(pc,d0.w),d1
		jmp	Obj77_Index(pc,d1.w)
; ===========================================================================
Obj77_Index:	dc.w Obj77_Main-Obj77_Index
		dc.w Obj77_ShipMain-Obj77_Index
		dc.w Obj77_FaceMain-Obj77_Index
		dc.w Obj77_FlameMain-Obj77_Index

Obj77_ObjData:	dc.b 2,	0		; routine number, animation
		dc.b 4,	1
		dc.b 6,	7
; ===========================================================================

Obj77_Main:	; Routine 0
		move.w	#$1E10,obX(a0)
		move.w	#$5C0,obY(a0)
		move.w	obX(a0),$30(a0)
		move.w	obY(a0),$38(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obColProp(a0) ; set number of hits to 8
		move.b	#4,obPriority(a0)
		lea	Obj77_ObjData(pc),a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	Obj77_LoadBoss
; ===========================================================================

Obj77_Loop:
		jsr	FindNextFreeObj
		bne.s	Obj77_ShipMain
		move.b	#id_BossLabyrinth,0(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

Obj77_LoadBoss:				; XREF: Obj77_Main
		bclr	#0,obStatus(a0)
		clr.b	ob2ndRout(a1)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,obAnim(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.l	#Map_Eggman,obMap(a1)
		move.w	#$400,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.l	a0,$34(a1)
		dbf	d1,Obj77_Loop

Obj77_ShipMain:	; Routine 2
		lea	(v_player).w,a1
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Obj77_ShipIndex(pc,d0.w),d1
		jsr	Obj77_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	AnimateSprite
		moveq	#3,d0
		and.b	obStatus(a0),d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	DisplaySprite
; ===========================================================================
Obj77_ShipIndex:dc.w loc_17F1E-Obj77_ShipIndex,	loc_17FA0-Obj77_ShipIndex
		dc.w loc_17FE0-Obj77_ShipIndex,	loc_1801E-Obj77_ShipIndex
		dc.w loc_180BC-Obj77_ShipIndex,	loc_180F6-Obj77_ShipIndex
		dc.w loc_1812A-Obj77_ShipIndex,	loc_18152-Obj77_ShipIndex
; ===========================================================================

loc_17F1E:				; XREF: Obj77_ShipIndex
		move.w	obX(a1),d0
		cmpi.w	#$1DA0,d0
		bcs.s	loc_17F38
		move.w	#-$180,obVelY(a0)
		move.w	#$60,obVelX(a0)
		addq.b	#2,ob2ndRout(a0)

loc_17F38:
		bsr.w	BossMove
		move.w	$38(a0),obY(a0)
		move.w	$30(a0),obX(a0)

loc_17F48:
		tst.b	$3D(a0)
		bne.s	loc_17F8E
		tst.b	obStatus(a0)
		bmi.s	loc_17F92
		tst.b	obColType(a0)
		bne.s	locret_17F8C
		tst.b	$3E(a0)
		bne.s	loc_17F70
		move.b	#$20,$3E(a0)
		sfx	sfx_HitBoss

loc_17F70:
		lea	(v_pal_dry+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_17F7E
		move.w	#cWhite,d0

loc_17F7E:
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_17F8C
		move.b	#$F,obColType(a0)

locret_17F8C:
		rts	
; ===========================================================================

loc_17F8E:				; XREF: loc_17F48
		bra.w	BossDefeated
; ===========================================================================

loc_17F92:				; XREF: loc_17F48
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#-1,$3D(a0)
		rts	
; ===========================================================================

loc_17FA0:				; XREF: Obj77_ShipIndex
		moveq	#-2,d0
		cmpi.w	#$1E48,$30(a0)
		bcs.s	loc_17FB6
		move.w	#$1E48,$30(a0)
		clr.w	obVelX(a0)
		addq.w	#1,d0

loc_17FB6:
		cmpi.w	#$500,$38(a0)
		bgt.s	loc_17FCA
		move.w	#$500,$38(a0)
		clr.w	obVelY(a0)
		addq.w	#1,d0

loc_17FCA:
		bne.s	loc_17FDC
		move.w	#$140,obVelX(a0)
		move.w	#-$200,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)

loc_17FDC:
		bra.w	loc_17F38
; ===========================================================================

loc_17FE0:				; XREF: Obj77_ShipIndex
		moveq	#-2,d0
		cmpi.w	#$1E70,$30(a0)
		bcs.s	loc_17FF6
		move.w	#$1E70,$30(a0)
		clr.w	obVelX(a0)
		addq.w	#1,d0

loc_17FF6:
		cmpi.w	#$4C0,$38(a0)
		bgt.s	loc_1800A
		move.w	#$4C0,$38(a0)
		clr.w	obVelY(a0)
		addq.w	#1,d0

loc_1800A:
		bne.s	loc_1801A
		move.w	#-$180,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		clr.b	$3F(a0)

loc_1801A:
		bra.w	loc_17F38
; ===========================================================================

loc_1801E:				; XREF: Obj77_ShipIndex
		cmpi.w	#$100,$38(a0)
		bgt.s	loc_1804E
		move.w	#$100,$38(a0)
		move.w	#$140,obVelX(a0)
		move.w	#-$80,obVelY(a0)
		tst.b	$3D(a0)
		beq.s	loc_18046
		asl	obVelX(a0)
		asl	obVelY(a0)

loc_18046:
		addq.b	#2,ob2ndRout(a0)
		bra.w	loc_17F38
; ===========================================================================

loc_1804E:
		bset	#0,obStatus(a0)
		addq.b	#2,$3F(a0)
		move.b	$3F(a0),d0
		jsr	(CalcSine).l
		tst.w	d1
		bpl.s	loc_1806C
		bclr	#0,obStatus(a0)

loc_1806C:
		asr.w	#4,d0
		swap	d0
		clr.w	d0
		add.l	$30(a0),d0
		swap	d0
		move.w	d0,obX(a0)
		move.w	obVelY(a0),d0
		move.w	(v_player+obY).w,d1
		sub.w	obY(a0),d1
		bcs.s	loc_180A2
		subi.w	#$48,d1
		bcs.s	loc_180A2
		asr.w	#1,d0
		subi.w	#$28,d1
		bcs.s	loc_180A2
		asr.w	#1,d0
		subi.w	#$28,d1
		bcs.s	loc_180A2
		moveq	#0,d0

loc_180A2:
		ext.l	d0
		asl.l	#8,d0
		tst.b	$3D(a0)
		beq.s	loc_180AE
		add.l	d0,d0

loc_180AE:
		add.l	d0,$38(a0)
		move.w	$38(a0),obY(a0)
		bra.w	loc_17F48
; ===========================================================================

loc_180BC:				; XREF: Obj77_ShipIndex
		moveq	#-2,d0
		cmpi.w	#$1F4C,$30(a0)
		bcs.s	loc_180D2
		move.w	#$1F4C,$30(a0)
		clr.w	obVelX(a0)
		addq.w	#1,d0

loc_180D2:
		cmpi.w	#$C0,$38(a0)
		bgt.s	loc_180E6
		move.w	#$C0,$38(a0)
		clr.w	obVelY(a0)
		addq.w	#1,d0

loc_180E6:
		bne.s	loc_180F2
		addq.b	#2,ob2ndRout(a0)
		bclr	#0,obStatus(a0)

loc_180F2:
		bra.w	loc_17F38
; ===========================================================================

loc_180F6:				; XREF: Obj77_ShipIndex
		tst.b	$3D(a0)
		bne.s	loc_18112
		cmpi.w	#$1EC8,obX(a1)
		blt.s	loc_18126
		cmpi.w	#$F0,obY(a1)
		bgt.s	loc_18126
		move.b	#$32,$3C(a0)

loc_18112:
		music	bgm_LZ		; play LZ music
		if Revision=0
		else
			clr.b	(f_lockscreen).w
		endc
		bset	#0,obStatus(a0)
		addq.b	#2,ob2ndRout(a0)

loc_18126:
		bra.w	loc_17F38
; ===========================================================================

loc_1812A:				; XREF: Obj77_ShipIndex
		tst.b	$3D(a0)
		bne.s	loc_18136
		subq.b	#1,$3C(a0)
		bne.s	loc_1814E

loc_18136:
		clr.b	$3C(a0)
		move.w	#$400,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		clr.b	$3D(a0)
		addq.b	#2,ob2ndRout(a0)

loc_1814E:
		bra.w	loc_17F38
; ===========================================================================

loc_18152:				; XREF: Obj77_ShipIndex
		cmpi.w	#$2030,(v_limitright2).w
		bcc.s	loc_18160
		addq.w	#2,(v_limitright2).w
		bra.s	loc_18166
; ===========================================================================

loc_18160:
		tst.b	obRender(a0)
		bpl.s	Obj77_ShipDel

loc_18166:
		bra.w	loc_17F38
; ===========================================================================

Obj77_ShipDel:
		jmp	DeleteObject
; ===========================================================================

Obj77_FaceMain:	; Routine 4
		movea.l	$34(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.s	Obj77_FaceDel
		moveq	#0,d0
		move.b	ob2ndRout(a1),d0
		moveq	#1,d1
		tst.b	$3D(a0)
		beq.s	loc_1818C
		moveq	#$A,d1
		bra.s	loc_181A0
; ===========================================================================

loc_1818C:
		tst.b	obColType(a1)
		bne.s	loc_18196
		moveq	#5,d1
		bra.s	loc_181A0
; ===========================================================================

loc_18196:
		cmpi.b	#4,(v_player+obRoutine).w
		bcs.s	loc_181A0
		moveq	#4,d1

loc_181A0:
		move.b	d1,obAnim(a0)
		cmpi.b	#$E,d0
		bne.s	loc_181B6
		move.b	#6,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	Obj77_FaceDel

loc_181B6:
		bra.s	Obj77_Display
; ===========================================================================

Obj77_FaceDel:
		jmp	DeleteObject
; ===========================================================================

Obj77_FlameMain:; Routine 6
		move.b	#7,obAnim(a0)
		movea.l	$34(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.s	Obj77_FlameDel
		cmpi.b	#$E,ob2ndRout(a1)
		bne.s	loc_181F0
		move.b	#$B,obAnim(a0)
		tst.b	1(a0)
		bpl.s	Obj77_FlameDel
		bra.s	loc_181F0
; ===========================================================================
		tst.w	obVelX(a1)
		beq.s	loc_181F0
		move.b	#8,obAnim(a0)

loc_181F0:
		bra.s	Obj77_Display
; ===========================================================================

Obj77_FlameDel:				; XREF: Obj77_FlameMain
		jmp	DeleteObject
; ===========================================================================

Obj77_Display:
		lea	(Ani_Eggman).l,a1
		jsr	AnimateSprite
		movea.l	$34(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)
		moveq	#3,d0
		and.b	obStatus(a0),d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	DisplaySprite
