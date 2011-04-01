; ---------------------------------------------------------------------------
; Object 0C - flapping door (LZ)
; ---------------------------------------------------------------------------

FlapDoor:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Flap_Index(pc,d0.w),d1
		jmp	Flap_Index(pc,d1.w)
; ===========================================================================
Flap_Index:	dc.w Flap_Main-Flap_Index
		dc.w Flap_OpenClose-Flap_Index

flap_time:	= $32		; time between opening/closing
flap_wait:	= $30		; time until change
; ===========================================================================

Flap_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Flap,obMap(a0)
		move.w	#$4328,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$28,obActWid(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		mulu.w	#60,d0		; multiply by 60 (1 second)
		move.w	d0,flap_time(a0) ; set flap delay time

Flap_OpenClose:	; Routine 2
		subq.w	#1,flap_wait(a0) ; decrement time delay
		bpl.s	@wait		; if time remains, branch
		move.w	flap_time(a0),flap_wait(a0) ; reset time delay
		bchg	#0,obAnim(a0)	; open/close door
		tst.b	obRender(a0)
		bpl.s	@nosound
		sfx	sfx_Door	; play door sound

	@wait:
	@nosound:
		lea	(Ani_Flap).l,a1
		bsr.w	AnimateSprite
		clr.b	(f_wtunnelallow).w ; enable wind tunnel
		tst.b	obFrame(a0)	; is the door open?
		bne.s	@display	; if yes, branch
		move.w	(v_player+obX).w,d0
		cmp.w	obX(a0),d0	; has Sonic passed through the door?
		bcc.s	@display	; if yes, branch
		move.b	#1,(f_wtunnelallow).w ; disable wind tunnel
		move.w	#$13,d1
		move.w	#$20,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject	; make the door	solid

	@display:
		bra.w	RememberState