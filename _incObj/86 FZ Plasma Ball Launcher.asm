; ---------------------------------------------------------------------------
; Object 86 - energy balls (FZ)
; ---------------------------------------------------------------------------

BossPlasma:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BossPlasma_Index(pc,d0.w),d0
		jmp	BossPlasma_Index(pc,d0.w)
; ===========================================================================
BossPlasma_Index:
		dc.w BossPlasma_Main-BossPlasma_Index
		dc.w BossPlasma_Generator-BossPlasma_Index
		dc.w BossPlasma_MakeBalls-BossPlasma_Index
		dc.w loc_1A962-BossPlasma_Index
		dc.w loc_1A982-BossPlasma_Index
; ===========================================================================

BossPlasma_Main:	; Routine 0
		move.w	#boss_fz_x+$138,obX(a0)
		move.w	#boss_fz_y+$2C,obY(a0)
		move.w	#make_art_tile(ArtTile_FZ_Boss,0,0),obGfx(a0)
		move.l	#Map_PLaunch,obMap(a0)
		move.b	#0,obAnim(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obWidth(a0)
		move.b	#8,obHeight(a0)
		move.b	#4,obRender(a0)
		bset	#7,obRender(a0)
		addq.b	#2,obRoutine(a0)

BossPlasma_Generator:; Routine 2
		movea.l	objoff_34(a0),a1
		cmpi.b	#6,objoff_34(a1)
		bne.s	loc_1A850
		move.b	#id_ExplosionBomb,obID(a0)
		move.b	#0,obRoutine(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A850:
		move.b	#0,obAnim(a0)
		tst.b	objoff_29(a0)
		beq.s	loc_1A86C
		addq.b	#2,obRoutine(a0)
		move.b	#1,obAnim(a0)
		move.b	#$3E,obSubtype(a0)

loc_1A86C:
		move.w	#$13,d1
		move.w	#8,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bmi.s	loc_1A89A
		subi.w	#$140,d0
		bmi.s	loc_1A89A
		tst.b	obRender(a0)
		bpl.w	EggmanCylinder_Delete

loc_1A89A:
		lea	Ani_PLaunch(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

BossPlasma_MakeBalls:; Routine 4
		tst.b	objoff_29(a0)
		beq.w	loc_1A954
		clr.b	objoff_29(a0)
		add.w	objoff_30(a0),d0
		andi.w	#$1E,d0
		adda.w	d0,a2
		addq.w	#4,objoff_30(a0)
		clr.w	objoff_32(a0)
		moveq	#3,d2

BossPlasma_Loop:
		jsr	(FindNextFreeObj).l
		bne.w	loc_1A954
		move.b	#id_BossPlasma,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	#boss_fz_y+$2C,obY(a1)
		move.b	#8,obRoutine(a1)
		move.w	#make_art_tile(ArtTile_FZ_Boss,1,0),obGfx(a1)
		move.l	#Map_Plasma,obMap(a1)
		move.b	#$C,obHeight(a1)
		move.b	#$C,obWidth(a1)
		move.b	#0,obColType(a1)
		move.b	#3,obPriority(a1)
		move.w	#$3E,obSubtype(a1)
		move.b	#4,obRender(a1)
		bset	#7,obRender(a1)
		move.l	a0,objoff_34(a1)
		jsr	(RandomNumber).l
		move.w	objoff_32(a0),d1
		muls.w	#-$4F,d1
		addi.w	#boss_fz_x+$128,d1
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d1,d0
		move.w	d0,objoff_30(a1)
		addq.w	#1,objoff_32(a0)
		move.w	objoff_32(a0),objoff_38(a0)
		dbf	d2,BossPlasma_Loop	; repeat sequence 3 more times

loc_1A954:
		tst.w	objoff_32(a0)
		bne.s	loc_1A95E
		addq.b	#2,obRoutine(a0)

loc_1A95E:
		bra.w	loc_1A86C
; ===========================================================================

loc_1A962:	; Routine 6
		move.b	#2,obAnim(a0)
		tst.w	objoff_38(a0)
		bne.s	loc_1A97E
		move.b	#2,obRoutine(a0)
		movea.l	objoff_34(a0),a1
		move.w	#-1,objoff_32(a1)

loc_1A97E:
		bra.w	loc_1A86C
; ===========================================================================

loc_1A982:	; Routine 8
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BossPlasma_Index2(pc,d0.w),d0
		jsr	BossPlasma_Index2(pc,d0.w)
		lea	Ani_Plasma(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
BossPlasma_Index2:
		dc.w loc_1A9A6-BossPlasma_Index2
		dc.w loc_1A9C0-BossPlasma_Index2
		dc.w loc_1AA1E-BossPlasma_Index2
; ===========================================================================

loc_1A9A6:
		move.w	objoff_30(a0),d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)
		move.w	#$B4,obSubtype(a0)
		addq.b	#2,ob2ndRout(a0)
		rts	
; ===========================================================================

loc_1A9C0:
		tst.w	obVelX(a0)
		beq.s	loc_1A9E6
		jsr	(SpeedToPos).l
		move.w	obX(a0),d0
		sub.w	objoff_30(a0),d0
		bcc.s	loc_1A9E6
		clr.w	obVelX(a0)
		add.w	d0,obX(a0)
		movea.l	objoff_34(a0),a1
		subq.w	#1,objoff_32(a1)

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

loc_1AA1E:
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_y+$D0,obY(a0)
		bhs.s	loc_1AA34
		subq.w	#1,obSubtype(a0)
		beq.s	loc_1AA34
		rts	
; ===========================================================================

loc_1AA34:
		movea.l	objoff_34(a0),a1
		subq.w	#1,objoff_38(a1)
	if FixBugs
		; Avoid returning to loc_1A982 to prevent a display-and-delete bug.
		addq.l	#4,sp
	endif
		bra.w	EggmanCylinder_Delete
