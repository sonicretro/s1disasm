; ---------------------------------------------------------------------------
; Object 48 - ball on a	chain that Eggman swings (GHZ)
; ---------------------------------------------------------------------------

BossBall:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GBall_Index(pc,d0.w),d1
		jmp	GBall_Index(pc,d1.w)
; ===========================================================================
GBall_Index:	dc.w GBall_Main-GBall_Index
		dc.w GBall_Base-GBall_Index
		dc.w GBall_Display2-GBall_Index
		dc.w loc_17C68-GBall_Index
		dc.w GBall_ChkVanish-GBall_Index
; ===========================================================================

GBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$4080,obAngle(a0)
		move.w	#-$200,$3E(a0)
		move.l	#Map_BossItems,obMap(a0)
		move.w	#$46C,obGfx(a0)
		lea	obSubtype(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_17B60
; ===========================================================================

GBall_MakeLinks:
		jsr	FindNextFreeObj
		bne.s	GBall_MakeBall
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#id_BossBall,0(a1) ; load chain link object
		move.b	#6,obRoutine(a1)
		move.l	#Map_Swing_GHZ,obMap(a1)
		move.w	#$380,obGfx(a1)
		move.b	#1,obFrame(a1)
		addq.b	#1,obSubtype(a0)

loc_17B60:				; XREF: GBall_Main
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,obRender(a1)
		move.b	#8,obActWid(a1)
		move.b	#6,obPriority(a1)
		move.l	$34(a0),$34(a1)
		dbf	d1,GBall_MakeLinks ; repeat sequence 5 more times

GBall_MakeBall:
		move.b	#8,obRoutine(a1)
		move.l	#Map_GBall,obMap(a1) ; load different mappings for final link
		move.w	#$43AA,obGfx(a1) ; use different graphics
		move.b	#1,obFrame(a1)
		move.b	#5,obPriority(a1)
		move.b	#$81,obColType(a1) ; make object hurt Sonic
		rts	
; ===========================================================================

GBall_PosData:	dc.b 0,	$10, $20, $30, $40, $60	; y-position data for links and	giant ball

; ===========================================================================

GBall_Base:	; Routine 2
		lea	(GBall_PosData).l,a3
		lea	obSubtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_17BC6:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	$3C(a1),d0
		beq.s	loc_17BE0
		addq.b	#1,$3C(a1)

loc_17BE0:
		dbf	d6,loc_17BC6

		cmp.b	$3C(a1),d0
		bne.s	loc_17BFA
		movea.l	$34(a0),a1
		cmpi.b	#6,ob2ndRout(a1)
		bne.s	loc_17BFA
		addq.b	#2,obRoutine(a0)

loc_17BFA:
		cmpi.w	#$20,$32(a0)
		beq.s	GBall_Display
		addq.w	#1,$32(a0)

GBall_Display:
		bsr.w	sub_17C2A
		move.b	obAngle(a0),d0
		jsr	(Swing_Move2).l
		jmp	DisplaySprite
; ===========================================================================

GBall_Display2:	; Routine 4
		bsr.w	sub_17C2A
		jsr	(Obj48_Move).l
		jmp	DisplaySprite

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_17C2A:				; XREF: GBall_Display; GBall_Display2
		movea.l	$34(a0),a1
		addi.b	#$20,obAniFrame(a0)
		bcc.s	loc_17C3C
		bchg	#0,obFrame(a0)

loc_17C3C:
		move.w	obX(a1),$3A(a0)
		move.w	obY(a1),d0
		add.w	$32(a0),d0
		move.w	d0,$38(a0)
		move.b	obStatus(a1),obStatus(a0)
		tst.b	obStatus(a1)
		bpl.s	locret_17C66
		move.b	#$3F,0(a0)
		move.b	#0,obRoutine(a0)

locret_17C66:
		rts	
; End of function sub_17C2A

; ===========================================================================

loc_17C68:	; Routine 6
		movea.l	$34(a0),a1
		tst.b	obStatus(a1)
		bpl.s	GBall_Display3
		move.b	#$3F,0(a0)
		move.b	#0,obRoutine(a0)

GBall_Display3:
		jmp	DisplaySprite
; ===========================================================================

GBall_ChkVanish:; Routine 8
		moveq	#0,d0
		tst.b	obFrame(a0)
		bne.s	GBall_Vanish
		addq.b	#1,d0

GBall_Vanish:
		move.b	d0,obFrame(a0)
		movea.l	$34(a0),a1
		tst.b	obStatus(a1)
		bpl.s	GBall_Display4
		move.b	#0,obColType(a0)
		bsr.w	BossDefeated
		subq.b	#1,$3C(a0)
		bpl.s	GBall_Display4
		move.b	#$3F,(a0)
		move.b	#0,obRoutine(a0)

GBall_Display4:
		jmp	DisplaySprite
