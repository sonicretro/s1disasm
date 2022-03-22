; ---------------------------------------------------------------------------
; Object 6D - flame thrower (SBZ)
; ---------------------------------------------------------------------------

Flamethrower:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Flame_Index(pc,d0.w),d1
		jmp	Flame_Index(pc,d1.w)
; ===========================================================================
Flame_Index:	dc.w Flame_Main-Flame_Index
		dc.w Flame_Action-Flame_Index
; ===========================================================================

Flame_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Flame,obMap(a0)
		move.w	#$83D9,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.w	obY(a0),$30(a0)	; store obY (gets overwritten later though)
		move.b	#$C,obActWid(a0)
		move.b	obSubtype(a0),d0
		andi.w	#$F0,d0		; read 1st digit of object type
		add.w	d0,d0		; multiply by 2
		move.w	d0,$30(a0)
		move.w	d0,$32(a0)	; set flaming time
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0		; read 2nd digit of object type
		lsl.w	#5,d0		; multiply by $20
		move.w	d0,$34(a0)	; set pause time
		move.b	#$A,$36(a0)
		btst	#1,obStatus(a0)
		beq.s	Flame_Action
		move.b	#2,obAnim(a0)
		move.b	#$15,$36(a0)

Flame_Action:	; Routine 2
		subq.w	#1,$30(a0)	; subtract 1 from time
		bpl.s	loc_E57A	; if time remains, branch
		move.w	$34(a0),$30(a0)	; begin	pause time
		bchg	#0,obAnim(a0)
		beq.s	loc_E57A
		move.w	$32(a0),$30(a0)	; begin	flaming	time
		sfx	sfx_Flamethrower,0,0,0 ; play flame sound

loc_E57A:
		lea	(Ani_Flame).l,a1
		bsr.w	AnimateSprite
		move.b	#0,obColType(a0)
		move.b	$36(a0),d0
		cmp.b	obFrame(a0),d0
		bne.s	Flame_ChkDel
		move.b	#$A3,obColType(a0)

Flame_ChkDel:
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite