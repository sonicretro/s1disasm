; ---------------------------------------------------------------------------
; Object 3D - Eggman (GHZ) - part 1
; ---------------------------------------------------------------------------

BossGreenHill:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BGHZ_Index(pc,d0.w),d1
		jmp	BGHZ_Index(pc,d1.w)
; ===========================================================================
BGHZ_Index:	offsetTable
		ptr BGHZ_Main
		ptr BGHZ_ShipMain
		ptr BGHZ_FaceMain
		ptr BGHZ_FlameMain

BGHZ_ObjData:	dc.b 2,	0		; routine counter, animation
		dc.b 4,	1
		dc.b 6,	7
; ===========================================================================

BGHZ_Main:	; Routine 0
		lea	(BGHZ_ObjData).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	BGHZ_LoadBoss
; ===========================================================================

BGHZ_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	loc_17772

BGHZ_LoadBoss:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_BossGreenHill,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Eggman,obMap(a1)
		move.w	#ArtTile_Eggman,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.b	#3,obPriority(a1)
		move.b	(a2)+,obAnim(a1)
		move.l	a0,objoff_34(a1)
		dbf	d1,BGHZ_Loop	; repeat sequence 2 more times

loc_17772:
		move.w	obX(a0),obBossX(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obBossHits(a0) ; set number of hits to 8

BGHZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BGHZ_ShipIndex(pc,d0.w),d1
		jsr	BGHZ_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
BGHZ_ShipIndex:	offsetTable
		ptr BGHZ_ShipStart
		ptr BGHZ_MakeBall
		ptr BGHZ_ShipMove
		ptr BGHZ_ChgDir
		ptr BGHZ_Explode
		ptr BGHZ_Recover
		ptr BGHZ_Escape
; ===========================================================================

BGHZ_ShipStart:
		move.w	#$100,obVelY(a0) ; move ship down
		bsr.w	BossMove
		cmpi.w	#boss_ghz_y+$38,obBossY(a0)
		bne.s	loc_177E6
		move.w	#0,obVelY(a0)	; stop ship
		addq.b	#2,ob2ndRout(a0) ; goto next routine

loc_177E6:
		move.b	objoff_3F(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	obBossY(a0),d0
		move.w	d0,obY(a0)
		move.w	obBossX(a0),obX(a0)
		addq.b	#2,objoff_3F(a0)
		cmpi.b	#8,ob2ndRout(a0)
		bhs.s	locret_1784A
		tst.b	obStatus(a0)
		bmi.s	loc_1784C
		tst.b	obColType(a0)
		bne.s	locret_1784A
		tst.b	obBossFlash(a0)
		bne.s	BGHZ_ShipFlash
		move.b	#$20,obBossFlash(a0)	; set number of times for ship to flash
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l	; play boss damage sound

BGHZ_ShipFlash:
		lea	(v_palette+$22).w,a1 ; load 2nd palette, 2nd entry
		moveq	#0,d0		; move 0 (black) to d0
		tst.w	(a1)
		bne.s	loc_1783C
		move.w	#cWhite,d0	; move 0EEE (white) to d0

loc_1783C:
		move.w	d0,(a1)		; load colour stored in d0
		subq.b	#1,obBossFlash(a0)
		bne.s	locret_1784A
		move.b	#$F,obColType(a0)

locret_1784A:
		rts
; ===========================================================================

loc_1784C:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#8,ob2ndRout(a0)
		move.w	#$B3,objoff_3C(a0)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Defeated boss subroutine (shared by all bosses)
; ---------------------------------------------------------------------------

BossDefeated:
		move.b	(v_vblank_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_178A2
		jsr	(FindFreeObj).l
		bne.s	locret_178A2
		_move.b	#id_Explosion,obID(a1)	; load explosion object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

locret_178A2:
		rts
; End of function BossDefeated


; ---------------------------------------------------------------------------
; Subroutine to move a boss (shared by all bosses)
; ---------------------------------------------------------------------------

BossMove:
		move.l	obBossX(a0),d2
		move.l	obBossY(a0),d3
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,obBossX(a0)
		move.l	d3,obBossY(a0)
		rts
; End of function BossMove

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3D - Eggman (GHZ) - part 2
; ---------------------------------------------------------------------------

BGHZ_MakeBall:
		move.w	#-$100,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		bsr.w	BossMove
		cmpi.w	#boss_ghz_x+$A0,obBossX(a0)
		bne.s	loc_17916
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_17910
		_move.b	#id_BossBall,obID(a1) ; load swinging ball object
		move.w	obBossX(a0),obX(a1)
		move.w	obBossY(a0),obY(a1)
		move.l	a0,objoff_34(a1)

loc_17910:
		move.w	#$77,objoff_3C(a0)

loc_17916:
		bra.w	loc_177E6
; ===========================================================================

BGHZ_ShipMove:
		subq.w	#1,objoff_3C(a0)
		bpl.s	BGHZ_Reverse
		addq.b	#2,ob2ndRout(a0)
		move.w	#$40-1,objoff_3C(a0)
		move.w	#$100,obVelX(a0) ; move the ship sideways
		cmpi.w	#boss_ghz_x+$A0,obBossX(a0)
		bne.s	BGHZ_Reverse
		move.w	#($40*2)-1,objoff_3C(a0)
		move.w	#$40,obVelX(a0)

BGHZ_Reverse:
		btst	#0,obStatus(a0)
		bne.s	loc_17950
		neg.w	obVelX(a0)	; reverse direction of the ship

loc_17950:
		bra.w	loc_177E6
; ===========================================================================

; loc_17954:
BGHZ_ChgDir:
		subq.w	#1,objoff_3C(a0)
		bmi.s	loc_17960
		bsr.w	BossMove
		bra.s	loc_17976
; ===========================================================================

loc_17960:
		bchg	#0,obStatus(a0)
		move.w	#$40-1,objoff_3C(a0)
		subq.b	#2,ob2ndRout(a0)
		move.w	#0,obVelX(a0)

loc_17976:
		bra.w	loc_177E6
; ===========================================================================

; loc_1797A:
BGHZ_Explode:
		subq.w	#1,objoff_3C(a0)
		bmi.s	loc_17984
		bra.w	BossDefeated
; ===========================================================================

loc_17984:
		bset	#0,obStatus(a0)
		bclr	#7,obStatus(a0)
		clr.w	obVelX(a0)
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$26,objoff_3C(a0)
		tst.b	(v_bossstatus).w
		bne.s	locret_179AA
		move.b	#1,(v_bossstatus).w

locret_179AA:
		rts
; ===========================================================================

; loc_179AC:
BGHZ_Recover:
		addq.w	#1,objoff_3C(a0)
		beq.s	loc_179BC
		bpl.s	loc_179C2
		addi.w	#$18,obVelY(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179BC:
		clr.w	obVelY(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179C2:
		cmpi.w	#$30,objoff_3C(a0)
		blo.s	loc_179DA
		beq.s	loc_179E0
		cmpi.w	#$38,objoff_3C(a0)
		blo.s	loc_179EE
		addq.b	#2,ob2ndRout(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179DA:
		subq.w	#8,obVelY(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179E0:
		clr.w	obVelY(a0)
		move.w	#bgm_GHZ,d0
		jsr	(QueueSound1).l		; play GHZ music

loc_179EE:
		bsr.w	BossMove
		bra.w	loc_177E6
; ===========================================================================

; loc_179F6:
BGHZ_Escape:
		move.w	#$400,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		cmpi.w	#boss_ghz_end,(v_limitright2).w
		beq.s	loc_17A10
		addq.w	#2,(v_limitright2).w
		bra.s	loc_17A16
; ===========================================================================

loc_17A10:
		tst.b	obRender(a0)
		bpl.s	BGHZ_ShipDel

loc_17A16:
		bsr.w	BossMove
		bra.w	loc_177E6
; ===========================================================================

BGHZ_ShipDel:
	if FixBugs
		; We do not want to return to BGHZ_ShipMain, as objects
		; should not queue themselves for display while also being
		; deleted.
		addq.l	#4,sp
	endif
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#1,d1
		movea.l	objoff_34(a0),a1
		move.b	ob2ndRout(a1),d0
		subq.b	#4,d0
		bne.s	loc_17A3E
		cmpi.w	#boss_ghz_x+$A0,obBossX(a1)
		bne.s	loc_17A46
		moveq	#4,d1

loc_17A3E:
		subq.b	#6,d0
		bmi.s	loc_17A46
		moveq	#$A,d1
		bra.s	loc_17A5A
; ===========================================================================

loc_17A46:
		tst.b	obColType(a1)
		bne.s	loc_17A50
		moveq	#5,d1
		bra.s	loc_17A5A
; ===========================================================================

loc_17A50:
		cmpi.b	#4,(v_player+obRoutine).w
		blo.s	loc_17A5A
		moveq	#4,d1

loc_17A5A:
		move.b	d1,obAnim(a0)
		subq.b	#2,d0
		bne.s	BGHZ_FaceDisp
		move.b	#6,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	BGHZ_FaceDel

BGHZ_FaceDisp:
		bra.s	BGHZ_Display
; ===========================================================================

BGHZ_FaceDel:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_FlameMain:	; Routine 6
		move.b	#7,obAnim(a0)
		movea.l	objoff_34(a0),a1
		cmpi.b	#$C,ob2ndRout(a1)
		bne.s	loc_17A96
		move.b	#$B,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	BGHZ_FlameDel
		bra.s	BGHZ_FlameDisp
; ===========================================================================

loc_17A96:
		move.w	obVelX(a1),d0
		beq.s	BGHZ_FlameDisp
		move.b	#8,obAnim(a0)

BGHZ_FlameDisp:
		bra.s	BGHZ_Display
; ===========================================================================

BGHZ_FlameDel:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_Display:
		movea.l	objoff_34(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
