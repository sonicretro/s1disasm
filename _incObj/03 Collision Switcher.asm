; ----------------------------------------------------------------------------
; Object 03 - Collision plane/layer switcher
; ----------------------------------------------------------------------------
; Sprite_1FCDC:
Obj03:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj03_Index(pc,d0.w),d1
		jsr	Obj03_Index(pc,d1.w)
		tst.w	(f_debugcheat).w
		bne.w	RememberState
		move.w	obX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	RememberState
		rts
; ===========================================================================
; off_1FCF0:
Obj03_Index:
		dc.w Obj03_Init-Obj03_Index	; 0
		dc.w Obj03_MainX-Obj03_Index	; 2
		dc.w Obj03_MainY-Obj03_Index	; 4
; ===========================================================================
; loc_1FCF6:
Obj03_Init:
		addq.b	#2,obRoutine(a0) ; => Obj03_MainX
		move.l	#Obj03_MapUnc_1FFB8,obMap(a0)
		move.w	#$27B2,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#5,obPriority(a0)
		move.b	obSubtype(a0),d0
		btst	#2,d0
		beq.s	Obj03_Init_CheckX
;Obj03_Init_CheckY:
		addq.b	#2,obRoutine(a0) ; => Obj03_MainY
		andi.w	#7,d0
		move.b	d0,obFrame(a0)
		andi.w	#3,d0
		add.w	d0,d0
		move.w	word_1FD68(pc,d0.w),$32(a0)
		move.w	obY(a0),d1
		lea	(v_player).w,a1 ; a1=character
		cmp.w	obY(a1),d1
		bhs.w	Obj03_MainY
		move.b	#1,$34(a0)
		bra.w	Obj03_MainY
; ===========================================================================
word_1FD68:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_1FD70:
Obj03_Init_CheckX:
		andi.w	#3,d0
		move.b	d0,obFrame(a0)
		add.w	d0,d0
		move.w	word_1FD68(pc,d0.w),$32(a0)
		move.w	obX(a0),d1
		lea	(v_player).w,a1 ; a1=character
		cmp.w	obX(a1),d1
		bhs.s	@jump
		move.b	#1,$34(a0)
@jump:

; loc_1FDA4:
Obj03_MainX:
		tst.w	(v_debuguse).w
		bne.w	return_1FEAC
		move.w	obX(a0),d1
		lea	$34(a0),a2
		lea	(v_player).w,a1 ; a1=character
		tst.b	(a2)+
		bne.s	Obj03_MainX_Alt
		cmp.w	obX(a1),d1
		bhi.w	return_1FEAC
		move.b	#1,-1(a2)
		move.w	obY(a0),d2
		move.w	d2,d3
		move.w	$32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obY(a1),d4
		cmp.w	d2,d4
		blt.w	return_1FEAC
		cmp.w	d3,d4
		bge.w	return_1FEAC
		move.b	obSubtype(a0),d0
		bpl.s	@jump
		btst	#1,obStatus(a1)
		bne.w	return_1FEAC
@jump:
		btst	#0,obRender(a0)
		bne.s	@jump2
		clr.b	(v_collayer).l
		btst	#3,d0
		beq.s	@jump2
		move.b	#1,(v_collayer).l
@jump2:
		tst.b	(f_debugcheat).w
		beq.s	@jump3
		sfx	sfx_Lamppost,0,0,1
@jump3:
		andi.w	#$7FFF,obGfx(a1)
		btst	#5,d0
		beq.w	return_1FEAC
		ori.w	#(1<<15),obGfx(a1)
		bra.s	return_1FEAC
; ===========================================================================
; loc_1FE38:
Obj03_MainX_Alt:
		cmp.w	obX(a1),d1
		bls.w	return_1FEAC
		move.b	#0,-1(a2)
		move.w	obY(a0),d2
		move.w	d2,d3
		move.w	$32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obY(a1),d4
		cmp.w	d2,d4
		blt.w	return_1FEAC
		cmp.w	d3,d4
		bge.w	return_1FEAC
		move.b	obSubtype(a0),d0
		bpl.s	@jump
		btst	#1,obStatus(a1)
		bne.w	return_1FEAC
@jump:
		btst	#0,obRender(a0)
		bne.s	@jump2
		clr.b	(v_collayer).l
		btst	#4,d0
		beq.s	@jump2
		move.b	#1,(v_collayer).l
@jump2:
		tst.b	(f_debugcheat).w
		beq.s	@jump3
		sfx	sfx_Lamppost,0,0,1
@jump3:
		andi.w	#$7FFF,obGfx(a1)
		btst	#6,d0
		beq.s	return_1FEAC
		ori.w	#(1<<15),obGfx(a1)

return_1FEAC:
		rts
; ===========================================================================

Obj03_MainY:
		tst.w	(v_debuguse).w
		bne.w	return_1FFB6
		move.w	obY(a0),d1
		lea	$34(a0),a2
		lea	(v_player).w,a1 ; a1=character
		tst.b	(a2)+
		bne.s	Obj03_MainY_Alt
		cmp.w	obY(a1),d1
		bhi.w	return_1FFB6
		move.b	#1,-1(a2)
		move.w	obX(a0),d2
		move.w	d2,d3
		move.w	$32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obX(a1),d4
		cmp.w	d2,d4
		blt.w	return_1FFB6
		cmp.w	d3,d4
		bge.w	return_1FFB6
		move.b	obSubtype(a0),d0
		bpl.s	@jump
		btst	#1,obStatus(a1)
		bne.w	return_1FFB6
@jump:
		btst	#0,obRender(a0)
		bne.s	@jump2
		clr.b	(v_collayer).l
		btst	#3,d0
		beq.s	@jump2
		move.b	#1,(v_collayer).l
@jump2:
		andi.w	#$7FFF,obGfx(a1)
		btst	#5,d0
		beq.s	return_1FFB6
		ori.w	#(1<<15),obGfx(a1)
		bra.s	return_1FFB6
; ===========================================================================
; loc_1FF42:
Obj03_MainY_Alt:
		cmp.w	obY(a1),d1
		bls.w	return_1FFB6
		move.b	#0,-1(a2)
		move.w	obX(a0),d2
		move.w	d2,d3
		move.w	$32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		move.w	obX(a1),d4
		cmp.w	d2,d4
		blt.w	return_1FFB6
		cmp.w	d3,d4
		bge.w	return_1FFB6
		move.b	obSubtype(a0),d0
		bpl.s	@jump
		btst	#1,obStatus(a1)
		bne.w	return_1FFB6
@jump:
		btst	#0,obRender(a0)
		bne.s	@jump2
		clr.b	(v_collayer).l
		btst	#4,d0
		beq.s	@jump2
		move.b	#1,(v_collayer).l
@jump2:
		andi.w	#$7FFF,obGfx(a1)
		btst	#6,d0
		beq.s	return_1FFB6
		ori.w	#(1<<15),obGfx(a1)

return_1FFB6:
		rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj03_MapUnc_1FFB8:	include "_maps/Collision Switcher.asm"
; ===========================================================================