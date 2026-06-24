; ===========================================================================
; ---------------------------------------------------------------------------
; Object 12 - spinning light in hexagonal glass prism (SYZ)
; ---------------------------------------------------------------------------

SpinningLight:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Light_Index(pc,d0.w),d1
		jmp	Light_Index(pc,d1.w)
; ===========================================================================
Light_Index:	dc.w Light_Main-Light_Index
		dc.w Light_Animate-Light_Index
; ===========================================================================

Light_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to Light_Animate
		move.l	#Map_Light,obMap(a0)		; set mappings
		move.w	#ArtTile_Level,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
		move.b	#32/2,obActWid(a0)		; set display width
		move.b	#6,obPriority(a0)		; set very low sprite priority
; ---------------------------------------------------------------------------

Light_Animate:	; Routine 2
		subq.b	#1,obTimeFrame(a0)		; decrement time delay until next frame
		bpl.s	.chkdel				; if time remains, branch
		move.b	#8-1,obTimeFrame(a0)		; reset time delay to 8 frames
		addq.b	#1,obFrame(a0)			; advance to next frame ID
		cmpi.b	#6,obFrame(a0)			; has it reached frame ID 6?
		blo.s	.chkdel				; if not, branch
		move.b	#0,obFrame(a0)			; reset back to frame 0

	.chkdel:
		out_of_range.w	DeleteObject		; has object gone offscreen? if yes, delete it
		bra.w	DisplaySprite			; display sprite
; ===========================================================================

Map_Light	include	"_maps/Light.asm"
