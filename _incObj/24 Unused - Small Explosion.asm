; ===========================================================================
; ---------------------------------------------------------------------------
; Object 24 - Unused small explosion, originally used for the front-facing
; Ball Hog badnik from the prototype. Would also technically be used by the
; Buzz Bomber badnik to dissolve its missile after destroying it, but does
; not work because the relevant flag is never set, and the required graphics
; aren't even loaded into VRAM (it would be "Nem_UnkExplode", but loading
; it overwrites part of the Crabmeat graphics at "ArtTile_UnusedExplosion").
; ---------------------------------------------------------------------------

; MissileDissolve: <--- old misnomer
UnusedExplosion:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	UnkExpl_Index(pc,d0.w),d1
		jmp	UnkExpl_Index(pc,d1.w)
; ===========================================================================
UnkExpl_Index:	dc.w UnkExpl_Main-UnkExpl_Index
		dc.w UnkExpl_Animate-UnkExpl_Index
; ===========================================================================

UnkExpl_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_UnkExplode,obMap(a0)
		move.w	#ArtTile_UnusedExplosion,obGfx(a0)
		move.b	#sprite_cam_field,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#col_none,obColType(a0)
		move.b	#24/2,obActWid(a0)
		move.b	#9,obTimeFrame(a0)
		move.b	#0,obFrame(a0)
		move.w	#sfx_A5,d0		; (this sfx is also unused)
		jsr	(QueueSound2).l		; play sound

UnkExpl_Animate:	; Routine 2
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.display
		move.b	#9,obTimeFrame(a0) ; set frame duration to 9 frames
		addq.b	#1,obFrame(a0)	; next frame
		cmpi.b	#4,obFrame(a0)	; has animation completed?
		beq.w	DeleteObject	; if yes, branch

.display:
		bra.w	DisplaySprite
