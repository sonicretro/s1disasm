; ---------------------------------------------------------------------------
; Subroutine to	delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeleteObject:
		movea.l	a0,a1		; move object RAM address to (a1)

DeleteChild:				; child objects are already in (a1)
		moveq	#0,d1
		moveq	#$F,d0

	DelObj_Loop:
		move.l	d1,(a1)+	; clear	the object RAM
		dbf	d0,DelObj_Loop	; repeat for length of object RAM
		rts	

; End of function DeleteObject