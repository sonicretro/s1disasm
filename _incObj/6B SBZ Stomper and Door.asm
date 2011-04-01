; ---------------------------------------------------------------------------
; Object 6B - stomper and sliding door (SBZ)
; ---------------------------------------------------------------------------

ScrapStomp:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sto_Index(pc,d0.w),d1
		jmp	Sto_Index(pc,d1.w)
; ===========================================================================
Sto_Index:	dc.w Sto_Main-Sto_Index
		dc.w Sto_Action-Sto_Index

sto_height:	= $16
sto_origX:	= $34		; original x-axis position
sto_origY:	= $30		; original y-axis position
sto_active:	= $38		; flag set when a switch is pressed

Sto_Var:	dc.b  $40,  $C,	$80,   1 ; width, height, ????,	type number
		dc.b  $1C, $20,	$38,   3
		dc.b  $1C, $20,	$40,   4
		dc.b  $1C, $20,	$60,   4
		dc.b  $80, $40,	  0,   5
; ===========================================================================

Sto_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0
		lea	Sto_Var(pc,d0.w),a3
		move.b	(a3)+,obActWid(a0)
		move.b	(a3)+,sto_height(a0)
		lsr.w	#2,d0
		move.b	d0,obFrame(a0)
		move.l	#Map_Stomp,obMap(a0)
		move.w	#$22C0,obGfx(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ/SBZ3
		bne.s	@isSBZ12	; if not, branch
		bset	#0,(v_obj6B).w
		beq.s	@isSBZ3

@chkdel:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		jmp	DeleteObject
; ===========================================================================

@isSBZ3:
		move.w	#$41F0,obGfx(a0)
		cmpi.w	#$A80,obX(a0)
		bne.s	@isSBZ12
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@isSBZ12
		btst	#0,2(a2,d0.w)
		beq.s	@isSBZ12
		clr.b	(v_obj6B).w
		bra.s	@chkdel
; ===========================================================================

@isSBZ12:
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.w	obX(a0),sto_origX(a0)
		move.w	obY(a0),sto_origY(a0)
		moveq	#0,d0
		move.b	(a3)+,d0
		move.w	d0,$3C(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		bpl.s	Sto_Action
		andi.b	#$F,d0
		move.b	d0,$3E(a0)
		move.b	(a3),obSubtype(a0)
		cmpi.b	#5,(a3)
		bne.s	@chkgone
		bset	#4,obRender(a0)

	@chkgone:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	Sto_Action
		bclr	#7,2(a2,d0.w)

Sto_Action:	; Routine 2
		move.w	obX(a0),-(sp)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	obRender(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	sto_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

	@chkdel:
		out_of_range.s	@chkgone,sto_origX(a0)
		jmp	DisplaySprite

	@chkgone:
		cmpi.b	#id_LZ,(v_zone).w
		bne.s	@delete
		clr.b	(v_obj6B).w
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		jmp	DeleteObject
; ===========================================================================
@index:		dc.w @type00-@index, @type01-@index
		dc.w @type02-@index, @type03-@index
		dc.w @type04-@index, @type05-@index
; ===========================================================================

@type00:				; XREF: @index
		rts
; ===========================================================================

@type01:				; XREF: @index
		tst.b	sto_active(a0)
		bne.s	@isactive01
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	$3E(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@loc_15DC2
		move.b	#1,sto_active(a0)

	@isactive01:
		move.w	$3C(a0),d0
		cmp.w	$3A(a0),d0
		beq.s	@loc_15DE0
		addq.w	#2,$3A(a0)

	@loc_15DC2:
		move.w	$3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@noflip01
		neg.w	d0
		addi.w	#$80,d0

	@noflip01:
		move.w	sto_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts	
; ===========================================================================

@loc_15DE0:
		addq.b	#1,obSubtype(a0)
		move.w	#$B4,$36(a0)
		clr.b	sto_active(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@loc_15DC2
		bset	#0,2(a2,d0.w)
		bra.s	@loc_15DC2
; ===========================================================================

@type02:				; XREF: @index
		tst.b	sto_active(a0)
		bne.s	@isactive02
		subq.w	#1,$36(a0)
		bne.s	@loc_15E1E
		move.b	#1,sto_active(a0)

	@isactive02:
		tst.w	$3A(a0)
		beq.s	@loc_15E3C
		subq.w	#2,$3A(a0)

	@loc_15E1E:
		move.w	$3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@noflip02
		neg.w	d0
		addi.w	#$80,d0

	@noflip02:
		move.w	sto_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts	
; ===========================================================================

@loc_15E3C:
		subq.b	#1,obSubtype(a0)
		clr.b	sto_active(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@loc_15E1E
		bclr	#0,2(a2,d0.w)
		bra.s	@loc_15E1E
; ===========================================================================

@type03:				; XREF: @index
		tst.b	sto_active(a0)
		bne.s	@isactive03
		tst.w	$3A(a0)
		beq.s	@loc_15E6A
		subq.w	#1,$3A(a0)
		bra.s	@loc_15E8E
; ===========================================================================

@loc_15E6A:
		subq.w	#1,$36(a0)
		bpl.s	@loc_15E8E
		move.w	#$3C,$36(a0)
		move.b	#1,sto_active(a0)

@isactive03:
		addq.w	#8,$3A(a0)
		move.w	$3A(a0),d0
		cmp.w	$3C(a0),d0
		bne.s	@loc_15E8E
		clr.b	sto_active(a0)

@loc_15E8E:
		move.w	$3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@noflip03
		neg.w	d0
		addi.w	#$38,d0

	@noflip03:
		move.w	sto_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

@type04:				; XREF: @index
		tst.b	sto_active(a0)
		bne.s	@isactive04
		tst.w	$3A(a0)
		beq.s	@loc_15EBE
		subq.w	#8,$3A(a0)
		bra.s	@loc_15EF0
; ===========================================================================

@loc_15EBE:
		subq.w	#1,$36(a0)
		bpl.s	@loc_15EF0
		move.w	#$3C,$36(a0)
		move.b	#1,sto_active(a0)

@isactive04:
		move.w	$3A(a0),d0
		cmp.w	$3C(a0),d0
		beq.s	@loc_15EE0
		addq.w	#8,$3A(a0)
		bra.s	@loc_15EF0
; ===========================================================================

@loc_15EE0:
		subq.w	#1,$36(a0)
		bpl.s	@loc_15EF0
		move.w	#$3C,$36(a0)
		clr.b	sto_active(a0)

@loc_15EF0:
		move.w	$3A(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@noflip04
		neg.w	d0
		addi.w	#$38,d0

	@noflip04:
		move.w	sto_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

@type05:				; XREF: @index
		tst.b	sto_active(a0)
		bne.s	@loc_15F3E
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	$3E(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@locret_15F5C
		move.b	#1,sto_active(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@loc_15F3E
		bset	#0,2(a2,d0.w)

@loc_15F3E:
		subi.l	#$10000,obX(a0)
		addi.l	#$8000,obY(a0)
		move.w	obX(a0),sto_origX(a0)
		cmpi.w	#$980,obX(a0)
		beq.s	@loc_15F5E

@locret_15F5C:
		rts	
; ===========================================================================

@loc_15F5E:
		clr.b	obSubtype(a0)
		clr.b	sto_active(a0)
		rts	
