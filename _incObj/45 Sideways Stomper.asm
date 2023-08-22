; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

SideStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SStom_Index(pc,d0.w),d1
		jmp	SStom_Index(pc,d1.w)
; ===========================================================================
SStom_Index:	dc.w SStom_Main-SStom_Index
		dc.w SStom_Solid-SStom_Index
		dc.w loc_BA8E-SStom_Index
		dc.w SStom_Display-SStom_Index
		dc.w SStom_Pole-SStom_Index

		;	routine		frame
		;		 xpos
SStom_Var:	dc.b	2,  	 4,	0	; main block
		dc.b	4,	-$1C,	1	; spikes
		dc.b	8,	 $34,	3	; pole
		dc.b	6,	 $28,	2	; wall bracket

;word_B9BE:	; Note that this indicates three subtypes
SStom_Len:	dc.w $3800	; short
		dc.w $A000	; long
		dc.w $5000	; medium
; ===========================================================================

SStom_Main:	; Routine 0
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	SStom_Len(pc,d0.w),d2
		lea	(SStom_Var).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	.load

.loop:
		bsr.w	FindNextFreeObj
		bne.s	.fail

.load:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_SideStomp,obID(a1)
		move.w	obY(a0),obY(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obX(a0),d0
		move.w	d0,obX(a1)
		move.l	#Map_SStom,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Spike_Stomper,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obX(a1),objoff_30(a1)
		move.w	obX(a0),objoff_3A(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$20,obActWid(a1)
		move.w	d2,objoff_34(a1)
		move.b	#4,obPriority(a1)
		cmpi.b	#1,(a2)		; is subobject spikes?
		bne.s	.notspikes	; if not, branch
		move.b	#$91,obColType(a1) ; use harmful collision type

.notspikes:
		move.b	(a2)+,obFrame(a1)
		move.l	a0,objoff_3C(a1)
		dbf	d1,.loop	; repeat 3 times

		move.b	#3,obPriority(a1)

.fail:
		move.b	#$10,obActWid(a0)

SStom_Solid:	; Routine 2
		move.w	obX(a0),-(sp)
		bsr.w	SStom_Move
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		bra.w	SStom_ChkDel
; ===========================================================================

SStom_Pole:	; Routine 8
		movea.l	objoff_3C(a0),a1
		move.b	objoff_32(a1),d0
		addi.b	#$10,d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,obFrame(a0)

loc_BA8E:	; Routine 4
		movea.l	objoff_3C(a0),a1
		moveq	#0,d0
		move.b	objoff_32(a1),d0
		neg.w	d0
		add.w	objoff_30(a0),d0
		move.w	d0,obX(a0)

SStom_Display:	; Routine 6
		bsr.w	DisplaySprite

SStom_ChkDel:
		out_of_range.w	DeleteObject,objoff_3A(a0)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SStom_Move:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	off_BAD6(pc,d0.w),d1
		jmp	off_BAD6(pc,d1.w)
; End of function SStom_Move

; ===========================================================================
		; This indicates only two subtypes... that do the same thing
		; Compare to SStom_Len. This breaks subtype 02
off_BAD6:	dc.w loc_BADA-off_BAD6
		dc.w loc_BADA-off_BAD6
; ===========================================================================

loc_BADA:
		tst.w	objoff_36(a0)
		beq.s	loc_BB08
		tst.w	objoff_38(a0)
		beq.s	loc_BAEC
		subq.w	#1,objoff_38(a0)
		bra.s	loc_BB3C
; ===========================================================================

loc_BAEC:
		subi.w	#$80,objoff_32(a0)
		bcc.s	loc_BB3C
		move.w	#0,objoff_32(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,objoff_36(a0)
		bra.s	loc_BB3C
; ===========================================================================

loc_BB08:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	loc_BB3C
		move.w	obVelX(a0),d0
		addi.w	#$70,obVelX(a0)
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	loc_BB3C
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelX(a0)
		move.w	#1,objoff_36(a0)
		move.w	#$3C,objoff_38(a0)

loc_BB3C:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		neg.w	d0
		add.w	objoff_30(a0),d0
		move.w	d0,obX(a0)
		rts	
