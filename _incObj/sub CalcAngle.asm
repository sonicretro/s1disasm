; ---------------------------------------------------------------------------
; Subroutine calculate an angle

; input:
;	d1 = x-axis distance
;	d2 = y-axis distance

; output:
;	d0 = angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	loc_2D04
		move.w	d2,d4
		tst.w	d3
		bpl.w	loc_2CC2
		neg.w	d3

loc_2CC2:
		tst.w	d4
		bpl.w	loc_2CCA
		neg.w	d4

loc_2CCA:
		cmp.w	d3,d4
		bcc.w	loc_2CDC
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	Angle_Data(pc,d4.w),d0
		bra.s	loc_2CE6
; ===========================================================================

loc_2CDC:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	Angle_Data(pc,d3.w),d0

loc_2CE6:
		tst.w	d1
		bpl.w	loc_2CF2
		neg.w	d0
		addi.w	#$80,d0

loc_2CF2:
		tst.w	d2
		bpl.w	loc_2CFE
		neg.w	d0
		addi.w	#$100,d0

loc_2CFE:
		movem.l	(sp)+,d3-d4
		rts	
; ===========================================================================

loc_2D04:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts	
; End of function CalcAngle

; ===========================================================================

Angle_Data:	incbin	misc\angles.bin

; ===========================================================================