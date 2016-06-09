; ---------------------------------------------------------------------------
; Object 2C - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Jaws:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Jaws_Index(pc,d0.w),d1
		jmp	Jaws_Index(pc,d1.w)
; ===========================================================================
Jaws_Index:	dc.w Jaws_Main-Jaws_Index
		dc.w Jaws_Turn-Jaws_Index

jaws_timecount = $30
jaws_timedelay = $32
; ===========================================================================

Jaws_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Jaws,obMap(a0)
		move.w	#$2486,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$A,obColType(a0)
		move.b	#4,obPriority(a0)
		move.b	#$10,obActWid(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; load object subtype number
		lsl.w	#6,d0		; multiply d0 by 64
		subq.w	#1,d0
		move.w	d0,jaws_timecount(a0) ; set turn delay time
		move.w	d0,jaws_timedelay(a0)
		move.w	#-$40,obVelX(a0) ; move Jaws to the left
		btst	#0,obStatus(a0)	; is Jaws facing left?
		beq.s	Jaws_Turn	; if yes, branch
		neg.w	obVelX(a0)	; move Jaws to the right

Jaws_Turn:	; Routine 2
		subq.w	#1,jaws_timecount(a0) ; subtract 1 from turn delay time
		bpl.s	.animate	; if time remains, branch
		move.w	jaws_timedelay(a0),jaws_timecount(a0) ; reset turn delay time
		neg.w	obVelX(a0)	; change speed direction
		bchg	#0,obStatus(a0)	; change Jaws facing direction
		move.b	#1,obNextAni(a0) ; reset animation

.animate:
		lea	(Ani_Jaws).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		bra.w	RememberState