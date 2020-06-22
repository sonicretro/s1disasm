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
		; used built in function
		move.b	tan(d1,d2),d0
		rts
; End of function CalcAngle

; ===========================================================================

Angle_Data:	incbin	"misc\angles.bin"

; ===========================================================================