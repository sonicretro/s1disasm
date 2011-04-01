; ---------------------------------------------------------------------------
; Subroutine translating object	speed to update	object position
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SpeedToPos:
		move.l	obX(a0),d2
		move.l	obY(a0),d3
		move.w	obVelX(a0),d0	; load horizontal speed
		ext.l	d0
		asl.l	#8,d0		; multiply speed by $100
		add.l	d0,d2		; add to x-axis	position
		move.w	obVelY(a0),d0	; load vertical	speed
		ext.l	d0
		asl.l	#8,d0		; multiply by $100
		add.l	d0,d3		; add to y-axis	position
		move.l	d2,obX(a0)	; update x-axis	position
		move.l	d3,obY(a0)	; update y-axis	position
		rts	

; End of function SpeedToPos