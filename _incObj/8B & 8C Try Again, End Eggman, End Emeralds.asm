; ---------------------------------------------------------------------------
; Object 8B - Eggman on "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------

EndEggman:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	EEgg_Index(pc,d0.w),d1
		jsr	EEgg_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
EEgg_Index:	offsetTable
		ptr EEgg_Main
		ptr EEgg_Animate
		ptr EEgg_Juggle
		ptr EEgg_Wait

eegg_time = objoff_30		; time between juggle motions
; ===========================================================================

EEgg_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$120,obX(a0)
		move.w	#$F4,obScreenY(a0)
		move.l	#Map_EEgg,obMap(a0)
		move.w	#ArtTile_Try_Again_Eggman,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#2,obAnim(a0)	; use "END" animation
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	EEgg_Animate	; if yes, branch

		move.b	#id_CreditsText,(v_tryagain).w ; load credits object
		move.w	#9,(v_creditsnum).w ; use "TRY AGAIN" text
		move.b	#id_TryChaos,(v_eggmanchaos).w ; load emeralds object on "TRY AGAIN" screen
		move.b	#0,obAnim(a0)	; use "TRY AGAIN" animation

EEgg_Animate:	; Routine 2
		lea	(Ani_EEgg).l,a1
		jmp	(AnimateSprite).l
; ===========================================================================

EEgg_Juggle:	; Routine 4
		addq.b	#2,obRoutine(a0)
		moveq	#2,d0
		btst	#0,obAnim(a0)
		beq.s	.noflip
		neg.w	d0

.noflip:
		lea	(v_eggmanchaos).w,a1 ; get RAM address for emeralds
		moveq	#5,d1

.emeraldloop:
		move.b	d0,objoff_3E(a1)
		move.w	d0,d2
		asl.w	#3,d2
		add.b	d2,obAngle(a1)
		lea	object_size(a1),a1
		dbf	d1,.emeraldloop
		addq.b	#1,obFrame(a0)
		move.w	#112,eegg_time(a0)

EEgg_Wait:	; Routine 6
		subq.w	#1,eegg_time(a0) ; decrement timer
		bpl.s	.nochg		; branch if time remains
		bchg	#0,obAnim(a0)
		move.b	#2,obRoutine(a0) ; goto EEgg_Animate next

.nochg:
		rts
; ===========================================================================

		include "_anim/Try Again & End Eggman.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 8C - chaos emeralds on the "TRY AGAIN" screen
; ---------------------------------------------------------------------------

TryChaos:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	TCha_Index(pc,d0.w),d1
		jsr	TCha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
TCha_Index:	offsetTable
		ptr TCha_Main
		ptr TCha_Move
; ===========================================================================

TCha_Main:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#5,d1
		sub.b	(v_emeralds).w,d1

.makeemerald:
		move.b	#id_TryChaos,obID(a1) ; load emerald object
		addq.b	#2,obRoutine(a1)
		move.l	#Map_ECha,obMap(a1)
		move.w	#ArtTile_Try_Again_Emeralds,obGfx(a1)
		move.b	#0,obRender(a1)
		move.b	#1,obPriority(a1)
		move.w	#$104,obX(a1)
		move.w	#$120,objoff_38(a1)
		move.w	#$EC,obScreenY(a1)
		move.w	obScreenY(a1),objoff_3A(a1)
		move.b	#$1C,objoff_3C(a1)
		lea	(v_emldlist).w,a3

.chkemerald:
		moveq	#0,d0
		move.b	(v_emeralds).w,d0
		subq.w	#1,d0
		bcs.s	.loc_5B42

.chkloop:
		cmp.b	(a3,d0.w),d2
		bne.s	.notgot
		addq.b	#1,d2
		bra.s	.chkemerald
; ===========================================================================

.notgot:
		dbf	d0,.chkloop

.loc_5B42:
		move.b	d2,obFrame(a1)
		addq.b	#1,obFrame(a1)
		addq.b	#1,d2
		move.b	#$80,obAngle(a1)
		move.b	d3,obTimeFrame(a1)
		move.b	d3,obDelayAni(a1)
		addi.w	#10,d3
		lea	object_size(a1),a1
		dbf	d1,.makeemerald	; repeat 5 times

TCha_Move:	; Routine 2
		tst.w	objoff_3E(a0)
		beq.s	locret_5BBA
		tst.b	obTimeFrame(a0)
		beq.s	loc_5B78
		subq.b	#1,obTimeFrame(a0)
		bne.s	loc_5B80

loc_5B78:
		move.w	objoff_3E(a0),d0
		add.w	d0,obAngle(a0)

loc_5B80:
		move.b	obAngle(a0),d0
		beq.s	loc_5B8C
		cmpi.b	#$80,d0
		bne.s	loc_5B96

loc_5B8C:
		clr.w	objoff_3E(a0)
		move.b	obDelayAni(a0),obTimeFrame(a0)

loc_5B96:
		jsr	(CalcSine).l
		moveq	#0,d4
		move.b	objoff_3C(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	objoff_38(a0),d1
		add.w	objoff_3A(a0),d0
		move.w	d1,obX(a0)
		move.w	d0,obScreenY(a0)

locret_5BBA:
		rts
; ===========================================================================

Map_EEgg:	include	"_maps/Try Again & End Eggman.asm"
