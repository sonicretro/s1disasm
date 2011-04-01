; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeRepel:			; XREF: Obj01_MdNormal; Obj01_MdRoll
		nop	
		tst.b	$38(a0)
		bne.s	locret_13580
		tst.w	$3E(a0)
		bne.s	loc_13582
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_13580
		move.w	obInertia(a0),d0
		bpl.s	loc_1356A
		neg.w	d0

loc_1356A:
		cmpi.w	#$280,d0
		bcc.s	locret_13580
		clr.w	obInertia(a0)
		bset	#1,obStatus(a0)
		move.w	#$1E,$3E(a0)

locret_13580:
		rts	
; ===========================================================================

loc_13582:
		subq.w	#1,$3E(a0)
		rts	
; End of function Sonic_SlopeRepel