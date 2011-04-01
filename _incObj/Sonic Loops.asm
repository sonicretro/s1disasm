; ---------------------------------------------------------------------------
; Subroutine to	make Sonic run around loops (GHZ/SLZ)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Loops:				; XREF: Obj01_Control
		cmpi.b	#id_SLZ,(v_zone).w ; is level SLZ ?
		beq.s	@isstarlight	; if yes, branch
		tst.b	(v_zone).w	; is level GHZ ?
		bne.w	@noloops	; if not, branch

	@isstarlight:
		move.w	obY(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.b	obX(a0),d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1	; d1 is	the 256x256 tile Sonic is currently on

		cmp.b	(v_256roll1).w,d1 ; is Sonic on a "roll tunnel" tile?
		beq.w	Sonic_ChkRoll	; if yes, branch
		cmp.b	(v_256roll2).w,d1
		beq.w	Sonic_ChkRoll

		cmp.b	(v_256loop1).w,d1 ; is Sonic on a loop tile?
		beq.s	@chkifleft	; if yes, branch
		cmp.b	(v_256loop2).w,d1
		beq.s	@chkifinair
		bclr	#6,obRender(a0) ; return Sonic to high plane
		rts	
; ===========================================================================

@chkifinair:
		btst	#1,obStatus(a0)	; is Sonic in the air?
		beq.s	@chkifleft	; if not, branch

		bclr	#6,obRender(a0)	; return Sonic to high plane
		rts	
; ===========================================================================

@chkifleft:
		move.w	obX(a0),d2
		cmpi.b	#$2C,d2
		bcc.s	@chkifright

		bclr	#6,obRender(a0)	; return Sonic to high plane
		rts	
; ===========================================================================

@chkifright:
		cmpi.b	#$E0,d2
		bcs.s	@chkangle1

		bset	#6,obRender(a0)	; send Sonic to	low plane
		rts	
; ===========================================================================

@chkangle1:
		btst	#6,obRender(a0) ; is Sonic on low plane?
		bne.s	@chkangle2	; if yes, branch

		move.b	obAngle(a0),d1
		beq.s	@done
		cmpi.b	#$80,d1		; is Sonic upside-down?
		bhi.s	@done		; if yes, branch
		bset	#6,obRender(a0)	; send Sonic to	low plane
		rts	
; ===========================================================================

@chkangle2:
		move.b	obAngle(a0),d1
		cmpi.b	#$80,d1		; is Sonic upright?
		bls.s	@done		; if yes, branch
		bclr	#6,obRender(a0)	; send Sonic to	high plane

@noloops:
@done:
		rts	
; End of function Sonic_Loops
