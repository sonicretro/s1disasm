; ---------------------------------------------------------------------------
; Object 30 - large green glass blocks (MZ)
; ---------------------------------------------------------------------------

GlassBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Glass_Index(pc,d0.w),d1
		jsr	Glass_Index(pc,d1.w)
		out_of_range.w	Glass_Delete
		bra.w	DisplaySprite
; ===========================================================================

Glass_Delete:
		bra.w	DeleteObject
; ===========================================================================
Glass_Index:	dc.w Glass_Main-Glass_Index
		dc.w Glass_Block012-Glass_Index
		dc.w Glass_Reflect012-Glass_Index
		dc.w Glass_Block34-Glass_Index
		dc.w Glass_Reflect34-Glass_Index

glass_dist = $32		; distance block moves when switch is pressed
glass_parent = $3C		; address of parent object

Glass_Vars1:	dc.b 2,	0, 0	; routine num, y-axis dist from	origin,	frame num
		dc.b 4,	0, 1
Glass_Vars2:	dc.b 6,	0, 2
		dc.b 8,	0, 1
; ===========================================================================

Glass_Main:	; Routine 0
		lea	(Glass_Vars1).l,a2
		moveq	#1,d1
		move.b	#$48,obHeight(a0)
		cmpi.b	#3,obSubtype(a0) ; is object type 0/1/2 ?
		bcs.s	.IsType012	; if yes, branch

		lea	(Glass_Vars2).l,a2
		moveq	#1,d1
		move.b	#$38,obHeight(a0)

.IsType012:
		movea.l	a0,a1
		bra.s	.Load		; load main object
; ===========================================================================

.Repeat:
		bsr.w	FindNextFreeObj
		bne.s	.Fail

.Load:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_GlassBlock,0(a1)
		move.w	obX(a0),obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_Glass,obMap(a1)
		move.w	#$C38E,obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obY(a1),$30(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$20,obActWid(a1)
		move.b	#4,obPriority(a1)
		move.b	(a2)+,obFrame(a1)
		move.l	a0,glass_parent(a1)
		dbf	d1,.Repeat	; repeat once to load "reflection object"

		move.b	#$10,obActWid(a1)
		move.b	#3,obPriority(a1)
		addq.b	#8,obSubtype(a1)
		andi.b	#$F,obSubtype(a1)

.Fail:
		move.w	#$90,glass_dist(a0)
		bset	#4,obRender(a0)

Glass_Block012:	; Routine 2
		bsr.w	Glass_Types
		move.w	#$2B,d1
		move.w	#$48,d2
		move.w	#$49,d3
		move.w	obX(a0),d4
		bra.w	SolidObject
; ===========================================================================

Glass_Reflect012:
		; Routine 4
		movea.l	$3C(a0),a1
		move.w	glass_dist(a1),glass_dist(a0)
		bra.w	Glass_Types
; ===========================================================================

Glass_Block34:	; Routine 6
		bsr.w	Glass_Types
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$39,d3
		move.w	obX(a0),d4
		bra.w	SolidObject
; ===========================================================================

Glass_Reflect34:
		; Routine 8
		movea.l	$3C(a0),a1
		move.w	glass_dist(a1),glass_dist(a0)
		move.w	obY(a1),$30(a0)
		bra.w	Glass_Types

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Glass_Types:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Glass_TypeIndex(pc,d0.w),d1
		jmp	Glass_TypeIndex(pc,d1.w)
; End of function Glass_Types

; ===========================================================================
Glass_TypeIndex:dc.w Glass_Type00-Glass_TypeIndex
		dc.w Glass_Type01-Glass_TypeIndex
		dc.w Glass_Type02-Glass_TypeIndex
		dc.w Glass_Type03-Glass_TypeIndex
		dc.w Glass_Type04-Glass_TypeIndex
; ===========================================================================

Glass_Type00:
		rts	
; ===========================================================================

Glass_Type01:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		bra.s	loc_B514
; ===========================================================================

Glass_Type02:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0

loc_B514:
		btst	#3,obSubtype(a0)
		beq.s	loc_B526
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0
		addi.w	#$20,d0

loc_B526:
		bra.w	loc_B5EE
; ===========================================================================

Glass_Type03:
		btst	#3,obSubtype(a0)
		beq.s	loc_B53E
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_B5EE
; ===========================================================================

loc_B53E:
		btst	#3,obStatus(a0)
		bne.s	loc_B54E
		bclr	#0,$34(a0)
		bra.s	loc_B582
; ===========================================================================

loc_B54E:
		tst.b	$34(a0)
		bne.s	loc_B582
		move.b	#1,$34(a0)
		bset	#0,$35(a0)
		beq.s	loc_B582
		bset	#7,$34(a0)
		move.w	#$10,$36(a0)
		move.b	#$A,$38(a0)
		cmpi.w	#$40,glass_dist(a0)
		bne.s	loc_B582
		move.w	#$40,$36(a0)

loc_B582:
		tst.b	$34(a0)
		bpl.s	loc_B5AA
		tst.b	$38(a0)
		beq.s	loc_B594
		subq.b	#1,$38(a0)
		bne.s	loc_B5AA

loc_B594:
		tst.w	glass_dist(a0)
		beq.s	loc_B5A4
		subq.w	#1,glass_dist(a0)
		subq.w	#1,$36(a0)
		bne.s	loc_B5AA

loc_B5A4:
		bclr	#7,$34(a0)

loc_B5AA:
		move.w	glass_dist(a0),d0
		bra.s	loc_B5EE
; ===========================================================================

Glass_Type04:
		btst	#3,obSubtype(a0)
		beq.s	Glass_ChkSwitch
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_B5EE
; ===========================================================================

Glass_ChkSwitch:
		tst.b	$34(a0)
		bne.s	loc_B5E0
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; load object type number
		lsr.w	#4,d0		; read only the	first nybble
		tst.b	(a2,d0.w)	; has switch number d0 been pressed?
		beq.s	loc_B5EA	; if not, branch
		move.b	#1,$34(a0)

loc_B5E0:
		tst.w	glass_dist(a0)
		beq.s	loc_B5EA
		subq.w	#2,glass_dist(a0)

loc_B5EA:
		move.w	glass_dist(a0),d0

loc_B5EE:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts	
