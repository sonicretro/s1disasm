; ---------------------------------------------------------------------------
; Object 5A - platforms	moving in circles (SLZ)
; ---------------------------------------------------------------------------

circ_origX = $32		; original x-axis position
circ_origY = $30		; original y-axis position

CirclingPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Circ_Index(pc,d0.w),d1
		jsr	Circ_Index(pc,d1.w)
		out_of_range.w	DeleteObject,circ_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================
Circ_Index:	dc.w Circ_Main-Circ_Index
		dc.w Circ_Platform-Circ_Index
		dc.w Circ_Action-Circ_Index

; ===========================================================================

Circ_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Circ,obMap(a0)
		move.w	#$4000,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.w	obX(a0),circ_origX(a0)
		move.w	obY(a0),circ_origY(a0)

Circ_Platform:	; Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.w	Circ_Types
; ===========================================================================

Circ_Action:	; Routine 4
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
		move.w	obX(a0),-(sp)
		bsr.w	Circ_Types
		move.w	(sp)+,d2
		jmp	(MvSonicOnPtfm2).l
; ===========================================================================

Circ_Types:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$C,d0
		lsr.w	#1,d0
		move.w	.index(pc,d0.w),d1
		jmp	.index(pc,d1.w)
; ===========================================================================
.index:		dc.w .type00-.index
		dc.w .type04-.index
; ===========================================================================

.type00:
		move.b	(v_oscillate+$22).w,d1 ; get rotating value
		subi.b	#$50,d1		; set radius of circle
		ext.w	d1
		move.b	(v_oscillate+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,obSubtype(a0)
		beq.s	.noshift00a
		neg.w	d1
		neg.w	d2

.noshift00a:
		btst	#1,obSubtype(a0)
		beq.s	.noshift00b
		neg.w	d1
		exg	d1,d2

.noshift00b:
		add.w	circ_origX(a0),d1
		move.w	d1,obX(a0)
		add.w	circ_origY(a0),d2
		move.w	d2,obY(a0)
		rts	
; ===========================================================================

.type04:
		move.b	(v_oscillate+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(v_oscillate+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,obSubtype(a0)
		beq.s	.noshift04a
		neg.w	d1
		neg.w	d2

.noshift04a:
		btst	#1,obSubtype(a0)
		beq.s	.noshift04b
		neg.w	d1
		exg	d1,d2

.noshift04b:
		neg.w	d1
		add.w	circ_origX(a0),d1
		move.w	d1,obX(a0)
		add.w	circ_origY(a0),d2
		move.w	d2,obY(a0)
		rts	
