; ---------------------------------------------------------------------------
; Object 8B - Eggman on "TRY AGAIN" and "END"	screens
; ---------------------------------------------------------------------------

EndEggman:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	EEgg_Index(pc,d0.w),d1
		jsr	EEgg_Index(pc,d1.w)
		jmp	DisplaySprite
; ===========================================================================
EEgg_Index:	dc.w EEgg_Main-EEgg_Index
		dc.w EEgg_Animate-EEgg_Index
		dc.w EEgg_Juggle-EEgg_Index
		dc.w EEgg_Wait-EEgg_Index

eegg_time:	= $30		; time between juggle motions
; ===========================================================================

EEgg_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$120,obX(a0)
		move.w	#$F4,obScreenY(a0)
		move.l	#Map_EEgg,obMap(a0)
		move.w	#$3E1,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#2,obAnim(a0)	; use "END" animation
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	EEgg_Animate	; if yes, branch

		move.b	#id_CreditsText,(v_objspace+$C0).w ; load credits object
		move.w	#9,(v_creditsnum).w ; use "TRY AGAIN" text
		move.b	#id_TryChaos,(v_objspace+$800).w ; load emeralds object on "TRY AGAIN" screen
		move.b	#0,obAnim(a0)	; use "TRY AGAIN" animation

EEgg_Animate:	; Routine 2
		lea	(Ani_EEgg).l,a1
		jmp	AnimateSprite
; ===========================================================================

EEgg_Juggle:	; Routine 4
		addq.b	#2,obRoutine(a0)
		moveq	#2,d0
		btst	#0,obAnim(a0)
		beq.s	@noflip
		neg.w	d0

	@noflip:
		lea	(v_objspace+$800).w,a1 ; get RAM address for emeralds
		moveq	#5,d1

@emeraldloop:
		move.b	d0,$3E(a1)
		move.w	d0,d2
		asl.w	#3,d2
		add.b	d2,obAngle(a1)
		lea	$40(a1),a1
		dbf	d1,@emeraldloop
		addq.b	#1,obFrame(a0)
		move.w	#112,eegg_time(a0)

EEgg_Wait:	; Routine 6
		subq.w	#1,eegg_time(a0) ; decrement timer
		bpl.s	@nochg		; branch if time remains
		bchg	#0,obAnim(a0)
		move.b	#2,obRoutine(a0) ; goto EEgg_Animate next

	@nochg:
		rts	