; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to generate a pseudo-random number in d0
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(v_random).w,d1				; load current pseudo random number
		bne.s	.scramble				; if it's not 0, branch
		move.l	#$2A6D365A,d1				; set initial/starting seed

.scramble:
		move.l	d1,d0					; copy to d0
		asl.l	#2,d1					; shift left two bits
		add.l	d0,d1					; add original to shifted
		asl.l	#3,d1					; shift left three more bits
		add.l	d0,d1					; add original again
		move.w	d1,d0					; load lower word of shifted to original
		swap	d1					; get upper word
		add.w	d1,d0					; add upper to lower
		move.w	d0,d1					; save back to d1
		swap	d1					; swap upper and lower back
		move.l	d1,(v_random).w				; save result for next time
		rts						; return (d0 contains pseudo-random number)
; End of function RandomNumber
