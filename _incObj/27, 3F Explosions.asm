; ===========================================================================
; ---------------------------------------------------------------------------
; Object 27 - Gray explosion from a destroyed enemy or monitor
; ---------------------------------------------------------------------------

ExplosionItem:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ExItem_Index(pc,d0.w),d1
		jmp	ExItem_Index(pc,d1.w)
; ===========================================================================
ExItem_Index:	dc.w ExItem_Animal-ExItem_Index		; 0
		dc.w ExItem_Main-ExItem_Index		; 2
		dc.w ExItem_Animate-ExItem_Index	; 4
; ===========================================================================

ExItem_Animal:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to ExItem_Main

		bsr.w	FindFreeObj			; find a free object slot
		bne.s	ExItem_Main			; if object RAM is full, skip loading animal object
		_move.b	#id_Animals,obID(a1)		; load animal object
		move.w	obX(a0),obX(a1)			; copy X-position
		move.w	obY(a0),obY(a1)			; copy Y-position
		move.w	objoff_3E(a0),objoff_3E(a1)	; ???
; ---------------------------------------------------------------------------

ExItem_Main:	; Routine 2 - set directly for non-Badnik objects (e.g. monitors)
		addq.b	#2,obRoutine(a0)		; advance to ExItem_Animate
		move.l	#Map_ExplodeItem,obMap(a0)	; set mappings
		move.w	#ArtTile_Explosion,obGfx(a0)	; set art tile
		move.b	#4,obRender(a0)			; set to playfield-positioned mode
		move.b	#1,obPriority(a0)		; set sprite priority (above Sonic)
		move.b	#0,obColType(a0)		; disable collision response
		move.b	#24/2,obActWid(a0)		; set sprite display width
		move.b	#8-1,obTimeFrame(a0)		; set frame interval to 8 frames
		move.b	#0,obFrame(a0)			; start at frame 0
		move.w	#sfx_BreakItem,d0		; set explosion puff sound
		jsr	(QueueSound2).l			; play it
; ---------------------------------------------------------------------------

ExItem_Animate:	; Routine 4 (2 for Explosion)
		subq.b	#1,obTimeFrame(a0)		; subtract 1 from frame duration
		bpl.s	.display			; if time remains, branch
		move.b	#8-1,obTimeFrame(a0)		; reset frame interval to 8 frames
		addq.b	#1,obFrame(a0)			; advance to next frame
		cmpi.b	#5,obFrame(a0)			; is the final frame (05) displayed?
		beq.w	DeleteObject			; if yes, delete explosion object

	.display:
		bra.w	DisplaySprite			; display explosion sprite


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3F - Fiery explosion from destroyed boss, Walking Bomb badnik, or Ball Hog cannonball
; ---------------------------------------------------------------------------

; ExplosionBomb: <--- old misnomer, this is used for more than just bombs
Explosion:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Expl_Index(pc,d0.w),d1
		jmp	Expl_Index(pc,d1.w)
; ===========================================================================
Expl_Index:	dc.w Expl_Main-Expl_Index		; 0
		dc.w ExItem_Animate-Expl_Index		; 2 <-- this branches to object 27 above!
; ===========================================================================

Expl_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to ExItem_Animate (foreign object)

		move.l	#Map_ExplodeBomb,obMap(a0)	; set mappings
		move.w	#ArtTile_Explosion,obGfx(a0)	; set art tile
		move.b	#4,obRender(a0)			; set to playfield-positioned mode
		move.b	#1,obPriority(a0)		; set sprite priority (above SOnic)
		move.b	#0,obColType(a0)		; disable collision response
		move.b	#24/2,obActWid(a0)		; set sprite display width
		move.b	#8-1,obTimeFrame(a0)		; set frame interval to 8 frames
		move.b	#0,obFrame(a0)			; start at frame 0
		move.w	#sfx_Bomb,d0			; set explosion sound
		jmp	(QueueSound2).l			; play it

; ===========================================================================

; Mappings for the explosions are located after the Ball Hog badnik and unused explosion in ROM.
includes_explosion: macro {GLOBALSYMBOLS}
		; Contains Map_ExplodeItem and Map_ExplodeBomb (cross-referencing!)
		include	"_maps/Explosions.asm"
	endm