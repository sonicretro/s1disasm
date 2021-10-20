; ---------------------------------------------------------------------------
; Subroutine calculate a square root (only available in REV00)

; input:
;	d0 = number

; output:
;	d0 = square root of number
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CalcSqrt:
		movem.l	d1-d2,-(sp)
		move.w	d0,d1
		swap	d1
		moveq	#0,d0
		move.w	d0,d1
		moveq	#7,d2

	loc_2C80:
		rol.l	#2,d1
		add.w	d0,d0
		addq.w	#1,d0
		sub.w	d0,d1
		bcc.s	loc_2C9A
		add.w	d0,d1
		subq.w	#1,d0
		dbf	d2,loc_2C80
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts	
; ===========================================================================

	loc_2C9A:
		addq.w	#1,d0
		dbf	d2,loc_2C80
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts	
; End of function CalcSqrt
