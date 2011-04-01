; ---------------------------------------------------------------------------
; Object 32 - buttons (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------

Button:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	But_Index(pc,d0.w),d1
		jmp	But_Index(pc,d1.w)
; ===========================================================================
But_Index:	dc.w But_Main-But_Index
		dc.w But_Pressed-But_Index
; ===========================================================================

But_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_But,obMap(a0)
		move.w	#$4513,obGfx(a0) ; MZ specific code
		cmpi.b	#id_MZ,(v_zone).w ; is level Marble Zone?
		beq.s	But_IsMZ	; if yes, branch

		move.w	#$513,obGfx(a0)	; SYZ, LZ and SBZ specific code

	But_IsMZ:
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		addq.w	#3,obY(a0)

But_Pressed:	; Routine 2
		tst.b	obRender(a0)
		bpl.s	But_Display
		move.w	#$1B,d1
		move.w	#5,d2
		move.w	#5,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		bclr	#0,obFrame(a0)	; use "unpressed" frame
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		lea	(f_switch).w,a3
		lea	(a3,d0.w),a3
		moveq	#0,d3
		btst	#6,obSubtype(a0)
		beq.s	loc_BDB2
		moveq	#7,d3

loc_BDB2:
		tst.b	obSubtype(a0)
		bpl.s	loc_BDBE
		bsr.w	But_MZBlock
		bne.s	loc_BDC8

loc_BDBE:
		tst.b	ob2ndRout(a0)
		bne.s	loc_BDC8
		bclr	d3,(a3)
		bra.s	loc_BDDE
; ===========================================================================

loc_BDC8:
		tst.b	(a3)
		bne.s	loc_BDD6
		sfx	sfx_Switch	; play switch sound

loc_BDD6:
		bset	d3,(a3)
		bset	#0,obFrame(a0)	; use "pressed"	frame

loc_BDDE:
		btst	#5,obSubtype(a0)
		beq.s	But_Display
		subq.b	#1,obTimeFrame(a0)
		bpl.s	But_Display
		move.b	#7,obTimeFrame(a0)
		bchg	#1,obFrame(a0)

But_Display:
		bsr.w	DisplaySprite
		out_of_range	But_Delete
		rts	
; ===========================================================================

But_Delete:
		bsr.w	DeleteObject
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


But_MZBlock:				; XREF: But_Pressed
		move.w	d3,-(sp)
		move.w	obX(a0),d2
		move.w	obY(a0),d3
		subi.w	#$10,d2
		subq.w	#8,d3
		move.w	#$20,d4
		move.w	#$10,d5
		lea	(v_lvlobjspace).w,a1 ; begin checking object RAM
		move.w	#$5F,d6

But_MZLoop:
		tst.b	obRender(a1)
		bpl.s	loc_BE4E
		cmpi.b	#id_PushBlock,(a1) ; is the object a green MZ block?
		beq.s	loc_BE5E	; if yes, branch

loc_BE4E:
		lea	$40(a1),a1	; check	next object
		dbf	d6,But_MZLoop	; repeat $5F times

		move.w	(sp)+,d3
		moveq	#0,d0

locret_BE5A:
		rts	
; ===========================================================================
But_MZData:	dc.b $10, $10
; ===========================================================================

loc_BE5E:				; XREF: But_MZBlock
		moveq	#1,d0
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	But_MZData-2(pc,d0.w),a2
		move.b	(a2)+,d1
		ext.w	d1
		move.w	obX(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_BE80
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_BE84
		bra.s	loc_BE4E
; ===========================================================================

loc_BE80:
		cmp.w	d4,d0
		bhi.s	loc_BE4E

loc_BE84:
		move.b	(a2)+,d1
		ext.w	d1
		move.w	obY(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_BE9A
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_BE9E
		bra.s	loc_BE4E
; ===========================================================================

loc_BE9A:
		cmp.w	d5,d0
		bhi.s	loc_BE4E

loc_BE9E:
		move.w	(sp)+,d3
		moveq	#1,d0
		rts	
; End of function But_MZBlock
