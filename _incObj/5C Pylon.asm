; ---------------------------------------------------------------------------
; Object 5C - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------

Pylon:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pyl_Index(pc,d0.w),d1
		jmp	Pyl_Index(pc,d1.w)
; ===========================================================================
Pyl_Index:	dc.w Pyl_Main-Pyl_Index
		dc.w Pyl_Display-Pyl_Index
; ===========================================================================

Pyl_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Pylon,obMap(a0)
		move.w	#$83CC,obGfx(a0)
		move.b	#$10,obActWid(a0)

Pyl_Display:	; Routine 2
		move.l	(v_screenposx).w,d1
		add.l	d1,d1
		swap	d1
		neg.w	d1
		move.w	d1,obX(a0)
		move.l	(v_screenposy).w,d1
		add.l	d1,d1
		swap	d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,obScreenY(a0)
		bra.w	DisplaySprite