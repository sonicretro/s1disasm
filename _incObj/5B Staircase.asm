; ---------------------------------------------------------------------------
; Object 5B - blocks that form a staircase (SLZ)
; ---------------------------------------------------------------------------

stair_origX = $30		; original x-axis position
stair_origY = $32		; original y-axis position

stair_parent = $3C		; address of parent object (4 bytes)

Staircase:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Stair_Index(pc,d0.w),d1
		jsr	Stair_Index(pc,d1.w)
		out_of_range.w	DeleteObject,stair_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================
Stair_Index:	dc.w Stair_Main-Stair_Index
		dc.w Stair_Move-Stair_Index
		dc.w Stair_Solid-Stair_Index

; ===========================================================================

Stair_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#$38,d3
		moveq	#1,d4
		btst	#0,obStatus(a0)	; is object flipped?
		beq.s	.notflipped	; if not, branch
		moveq	#$3B,d3
		moveq	#-1,d4

.notflipped:
		move.w	obX(a0),d2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	.makeblocks
; ===========================================================================

.loop:
		bsr.w	FindNextFreeObj
		bne.w	.fail
		move.b	#4,obRoutine(a1)

.makeblocks:
		_move.b	#id_Staircase,0(a1) ; load another block object
		move.l	#Map_Stair,obMap(a1)
		move.w	#$4000,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#3,obPriority(a1)
		move.b	#$10,obActWid(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.w	d2,obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obX(a0),stair_origX(a1)
		move.w	obY(a1),stair_origY(a1)
		addi.w	#$20,d2
		move.b	d3,$37(a1)
		move.l	a0,stair_parent(a1)
		add.b	d4,d3
		dbf	d1,.loop	; repeat sequence 3 times

.fail:

Stair_Move:	; Routine 2
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Stair_TypeIndex(pc,d0.w),d1
		jsr	Stair_TypeIndex(pc,d1.w)

Stair_Solid:	; Routine 4
		movea.l	stair_parent(a0),a2
		moveq	#0,d0
		move.b	$37(a0),d0
		move.b	(a2,d0.w),d0
		add.w	stair_origY(a0),d0
		move.w	d0,obY(a0)
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		tst.b	d4
		bpl.s	loc_10F92
		move.b	d4,$36(a2)

loc_10F92:
		btst	#3,obStatus(a0)
		beq.s	locret_10FA0
		move.b	#1,$36(a2)

locret_10FA0:
		rts	
; ===========================================================================
Stair_TypeIndex:dc.w Stair_Type00-Stair_TypeIndex
		dc.w Stair_Type01-Stair_TypeIndex
		dc.w Stair_Type02-Stair_TypeIndex
		dc.w Stair_Type01-Stair_TypeIndex
; ===========================================================================

Stair_Type00:
		tst.w	$34(a0)
		bne.s	loc_10FC0
		cmpi.b	#1,$36(a0)
		bne.s	locret_10FBE
		move.w	#$1E,$34(a0)

locret_10FBE:
		rts	
; ===========================================================================

loc_10FC0:
		subq.w	#1,$34(a0)
		bne.s	locret_10FBE
		addq.b	#1,obSubtype(a0) ; add 1 to type
		rts	
; ===========================================================================

Stair_Type02:
		tst.w	$34(a0)
		bne.s	loc_10FE0
		tst.b	$36(a0)
		bpl.s	locret_10FDE
		move.w	#$3C,$34(a0)

locret_10FDE:
		rts	
; ===========================================================================

loc_10FE0:
		subq.w	#1,$34(a0)
		bne.s	loc_10FEC
		addq.b	#1,obSubtype(a0) ; add 1 to type
		rts	
; ===========================================================================

loc_10FEC:
		lea	$38(a0),a1
		move.w	$34(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		rts	
; ===========================================================================

Stair_Type01:
		lea	$38(a0),a1
		cmpi.b	#$80,(a1)
		beq.s	locret_11038
		addq.b	#1,(a1)
		moveq	#0,d1
		move.b	(a1)+,d1
		swap	d1
		lsr.l	#1,d1
		move.l	d1,d2
		lsr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.b	d3,(a1)+
		move.b	d2,(a1)+
		move.b	d1,(a1)+

locret_11038:
		rts	
		rts	
