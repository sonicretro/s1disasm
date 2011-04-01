; ---------------------------------------------------------------------------
; Object 35 - fireball that sits on the	floor (MZ)
; (appears when	you walk on sinking platforms)
; ---------------------------------------------------------------------------

GrassFire:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GFire_Index(pc,d0.w),d1
		jmp	GFire_Index(pc,d1.w)
; ===========================================================================
GFire_Index:	dc.w GFire_Main-GFire_Index
		dc.w loc_B238-GFire_Index
		dc.w GFire_Move-GFire_Index

origX:		= $2A
; ===========================================================================

GFire_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#$345,obGfx(a0)
		move.w	obX(a0),origX(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.b	#8,obActWid(a0)
		sfx	sfx_Burning	 ; play burning sound
		tst.b	obSubtype(a0)
		beq.s	loc_B238
		addq.b	#2,obRoutine(a0)
		bra.w	GFire_Move
; ===========================================================================

loc_B238:	; Routine 2
		movea.l	$30(a0),a1
		move.w	obX(a0),d1
		sub.w	origX(a0),d1
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	$2C(a0),d0
		move.w	d0,d2
		add.w	$3C(a0),d0
		move.w	d0,obY(a0)
		cmpi.w	#$84,d1
		bcc.s	loc_B2B0
		addi.l	#$10000,obX(a0)
		cmpi.w	#$80,d1
		bcc.s	loc_B2B0
		move.l	obX(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	loc_B2B0
		bsr.w	FindNextFreeObj
		bne.s	loc_B2B0
		move.b	#id_GrassFire,0(a1)
		move.w	obX(a0),obX(a1)
		move.w	d2,$2C(a1)
		move.w	$3C(a0),$3C(a1)
		move.b	#1,obSubtype(a1)
		movea.l	$38(a0),a2
		bsr.w	sub_B09C

loc_B2B0:
		bra.s	GFire_Animate
; ===========================================================================

GFire_Move:	; Routine 4
		move.w	$2C(a0),d0
		add.w	$3C(a0),d0
		move.w	d0,obY(a0)

GFire_Animate:				; XREF: loc_B238
		lea	(Ani_GFire).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
