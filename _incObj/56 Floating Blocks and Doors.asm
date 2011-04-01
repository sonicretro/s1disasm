; ---------------------------------------------------------------------------
; Object 56 - floating blocks (SYZ/SLZ), large doors (LZ)
; ---------------------------------------------------------------------------

FloatingBlock:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FBlock_Index(pc,d0.w),d1
		jmp	FBlock_Index(pc,d1.w)
; ===========================================================================
FBlock_Index:	dc.w FBlock_Main-FBlock_Index
		dc.w FBlock_Action-FBlock_Index

fb_origX:	= $34		; original x-axis position
fb_origY:	= $30		; original y-axis position
fb_height:	= $3A		; total object height
fb_type:	= $3C		; subtype (2nd digit only)

FBlock_Var:	; width/2, height/2
		dc.b  $10, $10	; subtype 0x/8x
		dc.b  $20, $20	; subtype 1x/9x
		dc.b  $10, $20	; subtype 2x/Ax
		dc.b  $20, $1A	; subtype 3x/Bx
		dc.b  $10, $27	; subtype 4x/Cx
		dc.b  $10, $10	; subtype 5x/Dx
		dc.b	8, $20	; subtype 6x/Ex
		dc.b  $40, $10	; subtype 7x/Fx
; ===========================================================================

FBlock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_FBlock,obMap(a0)
		move.w	#$4000,obGfx(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	@notLZ
		move.w	#$43C4,obGfx(a0) ; LZ specific code

	@notLZ:
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get subtype
		lsr.w	#3,d0
		andi.w	#$E,d0		; read only the 1st digit
		lea	FBlock_Var(pc,d0.w),a2 ; get size data
		move.b	(a2)+,obActWid(a0)
		move.b	(a2),obHeight(a0)
		lsr.w	#1,d0
		move.b	d0,obFrame(a0)
		move.w	obX(a0),fb_origX(a0)
		move.w	obY(a0),fb_origY(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,fb_height(a0)
		if Revision=0
		else
			cmpi.b	#$37,obSubtype(a0)
			bne.s	@dontdelete
			cmpi.w	#$1BB8,obX(a0)
			bne.s	@notatpos
			tst.b	($FFFFF7CE).w
			beq.s	@dontdelete
			jmp	DeleteObject
	@notatpos:
			clr.b	obSubtype(a0)
			tst.b	($FFFFF7CE).w
			bne.s	@dontdelete
			jmp	DeleteObject
	@dontdelete:
		endc
		moveq	#0,d0
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		beq.s	@stillnotLZ
		move.b	obSubtype(a0),d0 ; SYZ/SLZ specific code
		andi.w	#$F,d0
		subq.w	#8,d0
		bcs.s	@stillnotLZ
		lsl.w	#2,d0
		lea	(v_oscillate+$2C).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	@stillnotLZ
		bchg	#0,obStatus(a0)

	@stillnotLZ:
		move.b	obSubtype(a0),d0
		bpl.s	FBlock_Action
		andi.b	#$F,d0
		move.b	d0,fb_type(a0)
		move.b	#5,obSubtype(a0)
		cmpi.b	#7,obFrame(a0)
		bne.s	@chkstate
		move.b	#$C,obSubtype(a0)
		move.w	#$80,fb_height(a0)

@chkstate:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	FBlock_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	FBlock_Action
		addq.b	#1,obSubtype(a0)
		clr.w	fb_height(a0)

FBlock_Action:	; Routine 2
		move.w	obX(a0),-(sp)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object subtype
		andi.w	#$F,d0		; read only the	2nd digit
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)	; move block subroutines
		move.w	(sp)+,d4
		tst.b	obRender(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	obHeight(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

	@chkdel:
		if Revision=0
		out_of_range	DeleteObject,fb_origX(a0)
		bra.w	DisplaySprite
		else
			out_of_range.s	@chkdel2,fb_origX(a0)
		@display:                
			bra	DisplaySprite
		@chkdel2:
			cmpi.b	#$37,obSubtype(a0)
			bne.s	@delete
			tst.b	$38(a0)
			bne.s	@display
		@delete:
			jmp     DeleteObject
		endc
; ===========================================================================
@index:		dc.w @type00-@index, @type01-@index
		dc.w @type02-@index, @type03-@index
		dc.w @type04-@index, @type05-@index
		dc.w @type06-@index, @type07-@index
		dc.w @type08-@index, @type09-@index
		dc.w @type0A-@index, @type0B-@index
		dc.w @type0C-@index, @type0D-@index
; ===========================================================================

@type00:				; XREF: @index
; doesn't move
		rts	
; ===========================================================================

@type01:				; XREF: @index
; moves side-to-side
		move.w	#$40,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	@moveLR
; ===========================================================================

@type02:				; XREF: @index
; moves side-to-side
		move.w	#$80,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

	@moveLR:
		btst	#0,obStatus(a0)
		beq.s	@noflip
		neg.w	d0
		add.w	d1,d0

	@noflip:
		move.w	fb_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)	; move object horizontally
		rts	
; ===========================================================================

@type03:				; XREF: @index
; moves up/down
		move.w	#$40,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	@moveUD
; ===========================================================================

@type04:				; XREF: @index
; moves up/down
		move.w	#$80,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

	@moveUD:
		btst	#0,obStatus(a0)
		beq.s	@noflip04
		neg.w	d0
		add.w	d1,d0

	@noflip04:
		move.w	fb_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)	; move object vertically
		rts	
; ===========================================================================

@type05:				; XREF: @index
; moves up when a switch is pressed
		tst.b	$38(a0)
		bne.s	@loc_104A4
		cmpi.w	#(id_LZ<<8)+0,(v_zone).w ; is level LZ1 ?
		bne.s	@aaa		; if not, branch
		cmpi.b	#3,fb_type(a0)
		bne.s	@aaa
		clr.b	(f_wtunnelallow).w
		move.w	(v_player+obX).w,d0
		cmp.w	obX(a0),d0
		bcc.s	@aaa
		move.b	#1,(f_wtunnelallow).w

	@aaa:
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@loc_104AE
		cmpi.w	#(id_LZ<<8)+0,(v_zone).w ; is level LZ1 ?
		bne.s	@loc_1049E	; if not, branch
		cmpi.b	#3,d0
		bne.s	@loc_1049E
		clr.b	(f_wtunnelallow).w

@loc_1049E:
		move.b	#1,$38(a0)

@loc_104A4:
		tst.w	fb_height(a0)
		beq.s	@loc_104C8
		subq.w	#2,fb_height(a0)

@loc_104AE:
		move.w	fb_height(a0),d0
		btst	#0,$22(a0)
		beq.s	@loc_104BC
		neg.w	d0

@loc_104BC:
		move.w	fb_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

@loc_104C8:
		addq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@loc_104AE
		bset	#0,2(a2,d0.w)
		bra.s	@loc_104AE
; ===========================================================================

@type06:				; XREF: @index
		tst.b	$38(a0)
		bne.s	@loc_10500
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	@loc_10512
		move.b	#1,$38(a0)

@loc_10500:
		moveq	#0,d0
		move.b	obHeight(a0),d0
		add.w	d0,d0
		cmp.w	fb_height(a0),d0
		beq.s	@loc_1052C
		addq.w	#2,fb_height(a0)

@loc_10512:
		move.w	fb_height(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@loc_10520
		neg.w	d0

@loc_10520:
		move.w	fb_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

@loc_1052C:
		subq.b	#1,obSubtype(a0)
		clr.b	$38(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@loc_10512
		bclr	#0,2(a2,d0.w)
		bra.s	@loc_10512
; ===========================================================================

@type07:				; XREF: @index
		tst.b	$38(a0)
		bne.s	@loc_1055E
		tst.b	(f_switch+$F).w	; has switch number $F been pressed?
		beq.s	@locret_10578
		move.b	#1,$38(a0)
		clr.w	fb_height(a0)

@loc_1055E:
		addq.w	#1,obX(a0)
		move.w	obX(a0),fb_origX(a0)
		addq.w	#1,fb_height(a0)
		cmpi.w	#$380,fb_height(a0)
		bne.s	@locret_10578
		if Revision=0
		else
			move.b	#1,($FFFFF7CE).w
			clr.b	$38(a0)
		endc
		clr.b	obSubtype(a0)

@locret_10578:
		rts	
; ===========================================================================

@type0C:				; XREF: @index
		tst.b	$38(a0)
		bne.s	@loc_10598
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@loc_105A2
		move.b	#1,$38(a0)

@loc_10598:
		tst.w	fb_height(a0)
		beq.s	@loc_105C0
		subq.w	#2,fb_height(a0)

@loc_105A2:
		move.w	fb_height(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@loc_105B4
		neg.w	d0
		addi.w	#$80,d0

@loc_105B4:
		move.w	fb_origX(a0),d1
		add.w	d0,d1
		move.w	d1,obX(a0)
		rts	
; ===========================================================================

@loc_105C0:
		addq.b	#1,obSubtype(a0)
		clr.b	$38(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@loc_105A2
		bset	#0,2(a2,d0.w)
		bra.s	@loc_105A2
; ===========================================================================

@type0D:				; XREF: @index
		tst.b	$38(a0)
		bne.s	@loc_105F8
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	@wtf
		move.b	#1,$38(a0)

@loc_105F8:
		move.w	#$80,d0
		cmp.w	fb_height(a0),d0
		beq.s	@loc_10624
		addq.w	#2,fb_height(a0)

@wtf:
		move.w	fb_height(a0),d0
		btst	#0,obStatus(a0)
		beq.s	@loc_10618
		neg.w	d0
		addi.w	#$80,d0

@loc_10618:
		move.w	fb_origX(a0),d1
		add.w	d0,d1
		move.w	d1,obX(a0)
		rts	
; ===========================================================================

@loc_10624:
		subq.b	#1,obSubtype(a0)
		clr.b	$38(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	@wtf
		bclr	#0,2(a2,d0.w)
		bra.s	@wtf
; ===========================================================================

@type08:				; XREF: @index
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2A).w,d0
		lsr.w	#1,d0
		move.w	(v_oscillate+$2C).w,d3
		bra.s	@square
; ===========================================================================

@type09:				; XREF: @index
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2E).w,d0
		move.w	(v_oscillate+$30).w,d3
		bra.s	@square
; ===========================================================================

@type0A:				; XREF: @index
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(v_oscillate+$32).w,d0
		move.w	(v_oscillate+$34).w,d3
		bra.s	@square
; ===========================================================================

@type0B:				; XREF: @index
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(v_oscillate+$36).w,d0
		move.w	(v_oscillate+$38).w,d3

@square:
		tst.w	d3
		bne.s	@loc_1068E
		addq.b	#1,obStatus(a0)
		andi.b	#3,obStatus(a0)

@loc_1068E:
		move.b	obStatus(a0),d2
		andi.b	#3,d2
		bne.s	@loc_106AE
		sub.w	d1,d0
		add.w	fb_origX(a0),d0
		move.w	d0,obX(a0)
		neg.w	d1
		add.w	fb_origY(a0),d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

@loc_106AE:
		subq.b	#1,d2
		bne.s	@loc_106CC
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	fb_origY(a0),d0
		move.w	d0,obY(a0)
		addq.w	#1,d1
		add.w	fb_origX(a0),d1
		move.w	d1,obX(a0)
		rts	
; ===========================================================================

@loc_106CC:
		subq.b	#1,d2
		bne.s	@loc_106EA
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	fb_origX(a0),d0
		move.w	d0,obX(a0)
		addq.w	#1,d1
		add.w	fb_origY(a0),d1
		move.w	d1,obY(a0)
		rts	
; ===========================================================================

@loc_106EA:
		sub.w	d1,d0
		add.w	fb_origY(a0),d0
		move.w	d0,obY(a0)
		neg.w	d1
		add.w	fb_origX(a0),d1
		move.w	d1,obX(a0)
		rts	
