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
		; using built in math functions
		move.l	sin(d0),d0
		move.l	cos(d0),d1
		rts	
; End of function CalcSine

; ===========================================================================

Sine_Data:	incbin	"misc\sinewave.bin"	; values for a 360º sine wave

; ===========================================================================

; The following code is unused garbage. got rid of it