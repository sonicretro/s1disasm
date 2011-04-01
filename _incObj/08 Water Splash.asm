; ---------------------------------------------------------------------------
; Object 08 - water splash (LZ)
; ---------------------------------------------------------------------------

Splash:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Spla_Index(pc,d0.w),d1
		jmp	Spla_Index(pc,d1.w)
; ===========================================================================
Spla_Index:	dc.w Spla_Main-Spla_Index
		dc.w Spla_Display-Spla_Index
		dc.w Spla_Delete-Spla_Index
; ===========================================================================

Spla_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Splash,obMap(a0)
		ori.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.w	#$4259,obGfx(a0)
		move.w	(v_player+obX).w,obX(a0) ; copy x-position from Sonic

Spla_Display:	; Routine 2
		move.w	(v_waterpos1).w,obY(a0) ; copy y-position from water height
		lea	(Ani_Splash).l,a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ===========================================================================

Spla_Delete:	; Routine 4
		jmp	DeleteObject	; delete when animation	is complete