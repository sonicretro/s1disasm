; ---------------------------------------------------------------------------
; Object 7B - exploding	spikeys	that Eggman drops (SLZ)
; ---------------------------------------------------------------------------

BossSpikeball:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj7B_Index(pc,d0.w),d0
		jsr	Obj7B_Index(pc,d0.w)
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	Obj7A_Delete
		cmpi.w	#$280,d0
		bhi.w	Obj7A_Delete
		jmp	DisplaySprite
; ===========================================================================
Obj7B_Index:	dc.w Obj7B_Main-Obj7B_Index
		dc.w Obj7B_Fall-Obj7B_Index
		dc.w loc_18DC6-Obj7B_Index
		dc.w loc_18EAA-Obj7B_Index
		dc.w Obj7B_Explode-Obj7B_Index
		dc.w Obj7B_MoveFrag-Obj7B_Index
; ===========================================================================

Obj7B_Main:	; Routine 0
		move.l	#Map_SSawBall,obMap(a0)
		move.w	#$518,obGfx(a0)
		move.b	#1,obFrame(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.b	#$C,obActWid(a0)
		movea.l	$3C(a0),a1
		move.w	obX(a1),$30(a0)
		move.w	obY(a1),$34(a0)
		bset	#0,obStatus(a0)
		move.w	obX(a0),d0
		cmp.w	obX(a1),d0
		bgt.s	loc_18D68
		bclr	#0,obStatus(a0)
		move.b	#2,$3A(a0)

loc_18D68:
		addq.b	#2,obRoutine(a0)

Obj7B_Fall:	; Routine 2
		jsr	ObjectFall
		movea.l	$3C(a0),a1
		lea	(word_19018).l,a2
		moveq	#0,d0
		move.b	obFrame(a1),d0
		move.w	8(a0),d1
		sub.w	$30(a0),d1
		bcc.s	loc_18D8E
		addq.w	#2,d0

loc_18D8E:
		add.w	d0,d0
		move.w	$34(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	obY(a0),d1
		bgt.s	locret_18DC4
		movea.l	$3C(a0),a1
		moveq	#2,d1
		btst	#0,obStatus(a0)
		beq.s	loc_18DAE
		moveq	#0,d1

loc_18DAE:
		move.w	#$F0,obSubtype(a0)
		move.b	#10,obDelayAni(a0)	; set frame duration to	10 frames
		move.b	obDelayAni(a0),obTimeFrame(a0)
		bra.w	loc_18FA2
; ===========================================================================

locret_18DC4:
		rts	
; ===========================================================================

loc_18DC6:	; Routine 4
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$3A(a0),d0
		sub.b	$3A(a1),d0
		beq.s	loc_18E2A
		bcc.s	loc_18DDA
		neg.b	d0

loc_18DDA:
		move.w	#-$818,d1
		move.w	#-$114,d2
		cmpi.b	#1,d0
		beq.s	loc_18E00
		move.w	#-$960,d1
		move.w	#-$F4,d2
		cmpi.w	#$9C0,$38(a1)
		blt.s	loc_18E00
		move.w	#-$A20,d1
		move.w	#-$80,d2

loc_18E00:
		move.w	d1,obVelY(a0)
		move.w	d2,obVelX(a0)
		move.w	obX(a0),d0
		sub.w	$30(a0),d0
		bcc.s	loc_18E16
		neg.w	obVelX(a0)

loc_18E16:
		move.b	#1,obFrame(a0)
		move.w	#$20,obSubtype(a0)
		addq.b	#2,obRoutine(a0)
		bra.w	loc_18EAA
; ===========================================================================

loc_18E2A:				; XREF: loc_18DC6
		lea	(word_19018).l,a2
		moveq	#0,d0
		move.b	obFrame(a1),d0
		move.w	#$28,d2
		move.w	obX(a0),d1
		sub.w	$30(a0),d1
		bcc.s	loc_18E48
		neg.w	d2
		addq.w	#2,d0

loc_18E48:
		add.w	d0,d0
		move.w	$34(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,obY(a0)
		add.w	$30(a0),d2
		move.w	d2,obX(a0)
		clr.w	obY+2(a0)
		clr.w	obX+2(a0)
		subq.w	#1,obSubtype(a0)
		bne.s	loc_18E7A
		move.w	#$20,obSubtype(a0)
		move.b	#8,obRoutine(a0)
		rts	
; ===========================================================================

loc_18E7A:
		cmpi.w	#$78,obSubtype(a0)
		bne.s	loc_18E88
		move.b	#5,obDelayAni(a0)

loc_18E88:
		cmpi.w	#$3C,obSubtype(a0)
		bne.s	loc_18E96
		move.b	#2,obDelayAni(a0)

loc_18E96:
		subq.b	#1,obTimeFrame(a0)
		bgt.s	locret_18EA8
		bchg	#0,obFrame(a0)
		move.b	obDelayAni(a0),obTimeFrame(a0)

locret_18EA8:
		rts	
; ===========================================================================

loc_18EAA:	; Routine 6
		lea	(v_objspace+$40).w,a1
		moveq	#id_BossStarLight,d0
		moveq	#$40,d1
		moveq	#$3E,d2

loc_18EB4:
		cmp.b	(a1),d0
		beq.s	loc_18EC0
		adda.w	d1,a1
		dbf	d2,loc_18EB4

		bra.s	loc_18F38
; ===========================================================================

loc_18EC0:
		move.w	obX(a1),d0
		move.w	obY(a1),d1
		move.w	obX(a0),d2
		move.w	obY(a0),d3
		lea	byte_19022(pc),a2
		lea	byte_19026(pc),a3
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d0
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d2
		cmp.w	d0,d2
		bcs.s	loc_18F38
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d0
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d2
		cmp.w	d2,d0
		bcs.s	loc_18F38
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d1
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d3
		cmp.w	d1,d3
		bcs.s	loc_18F38
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d1
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d3
		cmp.w	d3,d1
		bcs.s	loc_18F38
		addq.b	#2,obRoutine(a0)
		clr.w	obSubtype(a0)
		clr.b	obColType(a1)
		subq.b	#1,obColProp(a1)
		bne.s	loc_18F38
		bset	#7,obStatus(a1)
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)

loc_18F38:
		tst.w	obVelY(a0)
		bpl.s	loc_18F5C
		jsr	ObjectFall
		move.w	$34(a0),d0
		subi.w	#$2F,d0
		cmp.w	obY(a0),d0
		bgt.s	loc_18F58
		jsr	ObjectFall

loc_18F58:
		bra.w	loc_18E7A
; ===========================================================================

loc_18F5C:
		jsr	ObjectFall
		movea.l	$3C(a0),a1
		lea	(word_19018).l,a2
		moveq	#0,d0
		move.b	obFrame(a1),d0
		move.w	obX(a0),d1
		sub.w	$30(a0),d1
		bcc.s	loc_18F7E
		addq.w	#2,d0

loc_18F7E:
		add.w	d0,d0
		move.w	$34(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	obY(a0),d1
		bgt.s	loc_18F58
		movea.l	$3C(a0),a1
		moveq	#2,d1
		tst.w	obVelX(a0)
		bmi.s	loc_18F9C
		moveq	#0,d1

loc_18F9C:
		move.w	#0,obSubtype(a0)

loc_18FA2:
		move.b	d1,$3A(a1)
		move.b	d1,$3A(a0)
		cmp.b	obFrame(a1),d1
		beq.s	loc_19008
		bclr	#3,obStatus(a1)
		beq.s	loc_19008
		clr.b	ob2ndRout(a1)
		move.b	#2,obRoutine(a1)
		lea	(v_objspace).w,a2
		move.w	obVelY(a0),obVelY(a2)
		neg.w	obVelY(a2)
		cmpi.b	#1,obFrame(a1)
		bne.s	loc_18FDC
		asr	obVelY(a2)

loc_18FDC:
		bset	#1,obStatus(a2)
		bclr	#3,obStatus(a2)
		clr.b	$3C(a2)
		move.l	a0,-(sp)
		lea	(a2),a0
		jsr	Sonic_ChkRoll
		movea.l	(sp)+,a0
		move.b	#2,obRoutine(a2)
		sfx	sfx_Spring	; play "spring" sound

loc_19008:
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
		addq.b	#2,obRoutine(a0)
		bra.w	loc_18E7A
; ===========================================================================
word_19018:	dc.w -8, -$1C, -$2F, -$1C, -8
		even
byte_19022:	dc.b $E8, $30, $E8, $30
		even
byte_19026:	dc.b 8,	$F0, 8,	$F0
		even
; ===========================================================================

Obj7B_Explode:	; Routine 8
		move.b	#$3F,(a0)
		clr.b	obRoutine(a0)
		cmpi.w	#$20,obSubtype(a0)
		beq.s	Obj7B_MakeFrag
		rts	
; ===========================================================================

Obj7B_MakeFrag:
		move.w	$34(a0),obY(a0)
		moveq	#3,d1
		lea	Obj7B_FragSpeed(pc),a2

Obj7B_Loop:
		jsr	FindFreeObj
		bne.s	loc_1909A
		move.b	#id_BossSpikeball,(a1) ; load shrapnel object
		move.b	#$A,obRoutine(a1)
		move.l	#Map_BSBall,obMap(a1)
		move.b	#3,obPriority(a1)
		move.w	#$518,obGfx(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(a2)+,obVelX(a1)
		move.w	(a2)+,obVelY(a1)
		move.b	#$98,obColType(a1)
		ori.b	#4,obRender(a1)
		bset	#7,obRender(a1)
		move.b	#$C,obActWid(a1)

loc_1909A:
		dbf	d1,Obj7B_Loop	; repeat sequence 3 more times

		rts	
; ===========================================================================
Obj7B_FragSpeed:dc.w -$100, -$340	; horizontal, vertical
		dc.w -$A0, -$240
		dc.w $100, -$340
		dc.w $A0, -$240
; ===========================================================================

Obj7B_MoveFrag:	; Routine $A
		jsr	SpeedToPos
		move.w	obX(a0),$30(a0)
		move.w	obY(a0),$34(a0)
		addi.w	#$18,obVelY(a0)
		moveq	#4,d0
		and.w	(v_vbla_word).w,d0
		lsr.w	#2,d0
		move.b	d0,obFrame(a0)
		tst.b	1(a0)
		bpl.w	Obj7A_Delete
		rts	
