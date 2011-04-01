
Bri_Platform:	; Routine 4
		bsr.s	Bri_WalkOff
		bsr.w	DisplaySprite
		bra.w	Bri_ChkDel

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk off a bridge
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Bri_WalkOff:				; XREF: Bri_Platform
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	ExitPlatform2
		bcc.s	locret_75BE
		lsr.w	#4,d0
		move.b	d0,$3F(a0)
		move.b	$3E(a0),d0
		cmpi.b	#$40,d0
		beq.s	loc_75B6
		addq.b	#4,$3E(a0)

loc_75B6:
		bsr.w	Bri_Bend
		bsr.w	Bri_MoveSonic

locret_75BE:
		rts	
; End of function Bri_WalkOff