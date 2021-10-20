; ---------------------------------------------------------------------------
; Subroutine calculate a sine

; input:
;	d0 = angle

; output:
;	d0 = sine
;	d1 = cosine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CalcSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	Sine_Data(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	Sine_Data(pc,d0.w),d0
		rts	
; End of function CalcSine

; ===========================================================================

Sine_Data:	incbin	"misc\sinewave.bin"	; values for a 360° sine wave

; ===========================================================================
