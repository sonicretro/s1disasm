; ---------------------------------------------------------------------------
; Object 12 - lamp (SYZ)
; ---------------------------------------------------------------------------

SpinningLight:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Light_Index(pc,d0.w),d1
		jmp	Light_Index(pc,d1.w)
; ===========================================================================
Light_Index:	dc.w Light_Main-Light_Index
		dc.w Light_Animate-Light_Index
; ===========================================================================

Light_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Light,obMap(a0)
		move.w	#0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#6,obPriority(a0)

Light_Animate:	; Routine 2
		subq.b	#1,obTimeFrame(a0)
		bpl.s	@chkdel
		move.b	#7,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#6,obFrame(a0)
		bcs.s	@chkdel
		move.b	#0,obFrame(a0)

	@chkdel:
		out_of_range	DeleteObject
		bra.w	DisplaySprite