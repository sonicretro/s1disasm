
BGHZ_MakeBall:
		move.w	#-$100,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		bsr.w	BossMove
		cmpi.w	#boss_ghz_x+$A0,objoff_30(a0)
		bne.s	loc_17916
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_17910
		_move.b	#id_BossBall,obID(a1) ; load swinging ball object
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_38(a0),obY(a1)
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
		cmpi.w	#boss_ghz_x+$A0,objoff_30(a0)
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

loc_17954:
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

loc_1797A:
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

loc_179AC:
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

loc_179F6:
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
		cmpi.w	#boss_ghz_x+$A0,objoff_30(a1)
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
