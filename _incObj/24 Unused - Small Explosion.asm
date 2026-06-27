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
UnkExpl_Index:	dc.w UnkExpl_Main-UnkExpl_Index		; 0
		dc.w UnkExpl_Animate-UnkExpl_Index	; 2
; ===========================================================================

UnkExpl_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to UnkExpl_Animate
		move.l	#Map_UnkExplode,obMap(a0)	; set mappings
		move.w	#ArtTile_UnusedExplosion,obGfx(a0) ; set art tile
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
		move.b	#1,obPriority(a0)		; set sprite priority (above Sonic)
		move.b	#col_none,obColType(a0)		; disable collision response
		move.b	#24/2,obActWid(a0)		; set sprite display width
		move.b	#10-1,obTimeFrame(a0)		; set frame interval to 10 frames
		move.b	#0,obFrame(a0)			; start at frame 0
		move.w	#sfx_A5,d0			; (this sfx is also unused)
		jsr	(QueueSound2).l			; play sound
; ---------------------------------------------------------------------------

UnkExpl_Animate: ; Routine 2
		subq.b	#1,obTimeFrame(a0)		; subtract 1 from frame duration
		bpl.s	.display			; if time remains
		move.b	#10-1,obTimeFrame(a0)		; set frame duration to 10 frames
		addq.b	#1,obFrame(a0)			; advance to next frame
		cmpi.b	#4,obFrame(a0)			; is the final frame (04) displayed?
		beq.w	DeleteObject			; if yes, delete explosion object

	.display:
		bra.w	DisplaySprite			; display explosion sprite
