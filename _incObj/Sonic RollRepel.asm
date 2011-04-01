; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope	while he's rolling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRepel:			; XREF: Obj01_MdRoll
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#-$40,d0
		bcc.s	locret_13544
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		bmi.s	loc_1353A
		tst.w	d0
		bpl.s	loc_13534
		asr.l	#2,d0

loc_13534:
		add.w	d0,obInertia(a0)
		rts	
; ===========================================================================

loc_1353A:
		tst.w	d0
		bmi.s	loc_13540
		asr.l	#2,d0

loc_13540:
		add.w	d0,obInertia(a0)

locret_13544:
		rts	
; End of function Sonic_RollRepel