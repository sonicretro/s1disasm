; ---------------------------------------------------------------------------
; Object 46 - solid blocks and blocks that fall	from the ceiling (MZ)
; ---------------------------------------------------------------------------

MarbleBrick:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Brick_Index(pc,d0.w),d1
		jmp	Brick_Index(pc,d1.w)
; ===========================================================================
Brick_Index:	dc.w Brick_Main-Brick_Index
		dc.w Brick_Action-Brick_Index

origY:		= $30
; ===========================================================================

Brick_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.l	#Map_Brick,obMap(a0)
		move.w	#$4000,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.w	obY(a0),origY(a0)
		move.w	#$5C0,$32(a0)

Brick_Action:	; Routine 2
		tst.b	obRender(a0)
		bpl.s	@chkdel
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		andi.w	#7,d0		; read only the	1st digit
		add.w	d0,d0
		move.w	Brick_TypeIndex(pc,d0.w),d1
		jsr	Brick_TypeIndex(pc,d1.w)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject

	@chkdel:
		if Revision=0
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
		else
			out_of_range	DeleteObject
			bra.w	DisplaySprite
		endc
; ===========================================================================
Brick_TypeIndex:dc.w Brick_Type00-Brick_TypeIndex
		dc.w Brick_Type01-Brick_TypeIndex
		dc.w Brick_Type02-Brick_TypeIndex
		dc.w Brick_Type03-Brick_TypeIndex
		dc.w Brick_Type04-Brick_TypeIndex
; ===========================================================================

Brick_Type00:				; XREF: Brick_TypeIndex
		rts	
; ===========================================================================

Brick_Type02:				; XREF: Brick_TypeIndex
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_E888
		neg.w	d0

loc_E888:
		cmpi.w	#$90,d0		; is Sonic within $90 pixels of	the block?
		bcc.s	Brick_Type01	; if not, resume wobbling
		move.b	#3,obSubtype(a0)	; if yes, make the block fall

Brick_Type01:				; XREF: Brick_TypeIndex
		moveq	#0,d0
		move.b	(v_oscillate+$16).w,d0
		btst	#3,obSubtype(a0)
		beq.s	loc_E8A8
		neg.w	d0
		addi.w	#$10,d0

loc_E8A8:
		move.w	origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)	; update the block's position to make it wobble
		rts	
; ===========================================================================

Brick_Type03:				; XREF: Brick_TypeIndex
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)	; increase falling speed
		bsr.w	ObjFloorDist
		tst.w	d1		; has the block	hit the	floor?
		bpl.w	locret_E8EE	; if not, branch
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)	; stop the block falling
		move.w	obY(a0),origY(a0)
		move.b	#4,obSubtype(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		if Revision=0
		cmpi.w	#$2E8,d0
		else
			cmpi.w	#$16A,d0
		endc
		bcc.s	locret_E8EE
		move.b	#0,obSubtype(a0)

locret_E8EE:
		rts	
; ===========================================================================

Brick_Type04:				; XREF: Brick_TypeIndex
		moveq	#0,d0
		move.b	(v_oscillate+$12).w,d0
		lsr.w	#3,d0
		move.w	origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)	; make the block wobble
		rts	
