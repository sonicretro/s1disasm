; ---------------------------------------------------------------------------
; Object 0B - pole that	breaks (LZ)
; ---------------------------------------------------------------------------

Pole:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pole_Index(pc,d0.w),d1
		jmp	Pole_Index(pc,d1.w)
; ===========================================================================
Pole_Index:	dc.w Pole_Main-Pole_Index
		dc.w Pole_Action-Pole_Index
		dc.w Pole_Display-Pole_Index

pole_time:	= $30		; time between grabbing the pole & breaking
pole_grabbed:	= $32		; flag set when Sonic grabs the pole
; ===========================================================================

Pole_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Pole,obMap(a0)
		move.w	#$43DE,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#8,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	#$E1,obColType(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		mulu.w	#60,d0		; multiply by 60 (1 second)
		move.w	d0,pole_time(a0) ; set breakage time

Pole_Action:	; Routine 2
		tst.b	pole_grabbed(a0) ; has pole already been grabbed?
		beq.s	@grab		; if not, branch
		tst.w	pole_time(a0)
		beq.s	@moveup
		subq.w	#1,pole_time(a0) ; decrement time until break
		bne.s	@moveup
		move.b	#1,obFrame(a0)	; break	the pole
		bra.s	@release
; ===========================================================================

@moveup:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		subi.w	#$18,d0
		btst	#bitUp,(v_jpadhold1).w ; is "up" pressed?
		beq.s	@movedown	; if not, branch
		subq.w	#1,obY(a1)	; move Sonic up
		cmp.w	obY(a1),d0
		bcs.s	@movedown
		move.w	d0,obY(a1)

@movedown:
		addi.w	#$24,d0
		btst	#bitDn,(v_jpadhold1).w ; is "down" pressed?
		beq.s	@letgo		; if not, branch
		addq.w	#1,obY(a1)	; move Sonic down
		cmp.w	obY(a1),d0
		bcc.s	@letgo
		move.w	d0,obY(a1)

@letgo:
		move.b	(v_jpadpress2).w,d0
		andi.w	#btnABC,d0	; is A/B/C pressed?
		beq.s	Pole_Display	; if not, branch

@release:
		clr.b	obColType(a0)
		addq.b	#2,obRoutine(a0) ; goto Pole_Display next
		clr.b	(f_lockmulti).w
		clr.b	(f_wtunnelallow).w
		clr.b	pole_grabbed(a0)
		bra.s	Pole_Display
; ===========================================================================

@grab:
		tst.b	obColProp(a0)	; has Sonic touched the	pole?
		beq.s	Pole_Display	; if not, branch
		lea	(v_player).w,a1
		move.w	obX(a0),d0
		addi.w	#$14,d0
		cmp.w	obX(a1),d0
		bcc.s	Pole_Display
		clr.b	obColProp(a0)
		cmpi.b	#4,obRoutine(a1)
		bcc.s	Pole_Display
		clr.w	obVelX(a1)	; stop Sonic moving
		clr.w	obVelY(a1)	; stop Sonic moving
		move.w	obX(a0),d0
		addi.w	#$14,d0
		move.w	d0,obX(a1)
		bclr	#0,obStatus(a1)
		move.b	#id_Hang,obAnim(a1) ; set Sonic's animation to "hanging" ($11)
		move.b	#1,(f_lockmulti).w ; lock controls
		move.b	#1,(f_wtunnelallow).w ; disable wind tunnel
		move.b	#1,pole_grabbed(a0) ; begin countdown to breakage

Pole_Display:	; Routine 4
		bra.w	RememberState
