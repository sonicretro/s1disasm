; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump, SLZ lava thrower)
; ---------------------------------------------------------------------------

Scenery:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Scen_Index(pc,d0.w),d1
		jmp	Scen_Index(pc,d1.w)
; ===========================================================================
Scen_Index:	dc.w Scen_Main-Scen_Index
		dc.w Scen_ChkDel-Scen_Index
; ===========================================================================

Scen_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; copy object subtype to d0
		mulu.w	#$A,d0		; multiply by $A
		lea	Scen_Values(pc,d0.w),a1
		move.l	(a1)+,obMap(a0)
		move.w	(a1)+,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	(a1)+,obFrame(a0)
		move.b	(a1)+,obActWid(a0)
		move.b	(a1)+,obPriority(a0)
		move.b	(a1)+,obColType(a0)

Scen_ChkDel:	; Routine 2
		out_of_range	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Variables for	object $1C are stored in an array
; ---------------------------------------------------------------------------
Scen_Values:	dc.l Map_Scen		; mappings address
		dc.w $44D8		; VRAM setting
		dc.b 0,	8, 2, 0		; frame, width,	priority, collision response
		dc.l Map_Scen
		dc.w $44D8
		dc.b 0,	8, 2, 0
		dc.l Map_Scen
		dc.w $44D8
		dc.b 0,	8, 2, 0
		dc.l Map_Bri
		dc.w $438E
		dc.b 1,	$10, 1,	0
		even