; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine calculate a square root (only available in REV00 and unused)
; 
; input:
;	d0 = number
; 
; output:
;	d0 = square root of number
; ---------------------------------------------------------------------------

CalcSqrt:
		movem.l	d1-d2,-(sp)				; store register data
		move.w	d0,d1					; copy input
		swap	d1					; send to upper word
		moveq	#0,d0					; clear lower word
		move.w	d0,d1					; ''
		moveq	#($10/2)-1,d2				; set elements to count ($10 bits, 2 each time)

.nextElement:
		rol.l	#2,d1					; send two bits down
		add.w	d0,d0					; shift current result left
		addq.w	#1,d0					; increase by 1
		sub.w	d0,d1					; subtract from current two bits
		bhs.s	.incrementRoot				; if current result is not larger than the input so far, branch
		add.w	d0,d1					; restore back to normal
		subq.w	#1,d0					; subtract 1 back again
		dbf	d2,.nextElement				; repeat for all elements

		lsr.w	#1,d0					; keep result in the lower 8 bits
		movem.l	(sp)+,d1-d2				; restore register data
		rts						; return
; ---------------------------------------------------------------------------

.incrementRoot:
		addq.w	#1,d0					; increase by 1 again
		dbf	d2,.nextElement				; repeat for all elements

		lsr.w	#1,d0					; keep result in the lower 8 bits
		movem.l	(sp)+,d1-d2				; restore register data
		rts						; return
; End of function CalcSqrt
