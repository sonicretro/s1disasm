; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge
; ---------------------------------------------------------------------------

Bridge:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bri_Index(pc,d0.w),d1
		jmp	Bri_Index(pc,d1.w)
; ===========================================================================
Bri_Index:	dc.w Bri_Main-Bri_Index, Bri_Action-Bri_Index
		dc.w Bri_Platform-Bri_Index, Bri_Delete-Bri_Index
		dc.w Bri_Delete-Bri_Index, Bri_Display-Bri_Index
; ===========================================================================

Bri_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bri,obMap(a0)
		move.w	#$438E,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$80,obActWid(a0)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		move.b	0(a0),d4	; copy object number ($11) to d4
		lea	obSubtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1		; copy bridge length to d1
		move.b	#0,(a2)+	; clear bridge length
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3		; d3 is position of leftmost log
		subq.b	#2,d1
		bcs.s	Bri_Action	; don't make more if bridge has only 1 log

@buildloop:
		bsr.w	FindFreeObj
		bne.s	Bri_Action
		addq.b	#1,obSubtype(a0)
		cmp.w	obX(a0),d3	; is this log the leftmost one?
		bne.s	@notleftmost	; if not, branch

		addi.w	#$10,d3
		move.w	d2,obY(a0)
		move.w	d2,$3C(a0)
		move.w	a0,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		addq.b	#1,obSubtype(a0)

	@notleftmost:
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1)
		move.b	d4,0(a1)	; load bridge object (d4 = $11)
		move.w	d2,obY(a1)
		move.w	d2,$3C(a1)
		move.w	d3,obX(a1)
		move.l	#Map_Bri,obMap(a1)
		move.w	#$438E,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#3,obPriority(a1)
		move.b	#8,obActWid(a1)
		addi.w	#$10,d3
		dbf	d1,@buildloop ; repeat d1 times (length of bridge)

Bri_Action:	; Routine 2
		bsr.s	Bri_Solid
		tst.b	$3E(a0)
		beq.s	@display
		subq.b	#4,$3E(a0)
		bsr.w	Bri_Bend

	@display:
		bsr.w	DisplaySprite
		bra.w	Bri_ChkDel

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Bri_Solid:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		cmp.w	d2,d0
		bcc.w	Plat_Exit
		bra.s	Plat_NoXCheck
; End of function Bri_Solid
