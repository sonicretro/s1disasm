; ===========================================================================
; ---------------------------------------------------------------------------
; Object 44 - edge walls (GHZ)
; ---------------------------------------------------------------------------

EdgeWalls:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Edge_Index(pc,d0.w),d1
		jmp	Edge_Index(pc,d1.w)
; ===========================================================================
Edge_Index:	dc.w Edge_Main-Edge_Index
		dc.w Edge_Solid-Edge_Index
		dc.w Edge_Display-Edge_Index
; ===========================================================================

Edge_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Edge_Solid
		move.l	#Map_Edge,obMap(a0)			; load mappings
		move.w	#ArtTile_GHZ_Edge_Wall|Tile_Pal3,obGfx(a0) ; load art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#6,obPriority(a0)			; set sprite priority (very low)

		move.b	obSubtype(a0),obFrame(a0)		; copy object type number to frame number
		bclr	#4,obFrame(a0)				; clear 4th bit (deduct $10)
		beq.s	Edge_Solid				; make object solid if 4th bit = 0
		addq.b	#2,obRoutine(a0)			; advance to Edge_Display for non-solid cosmetic-only walls
		bra.s	Edge_Display				; don't make it solid if 4th bit = 1
; ===========================================================================

Edge_Solid:	; Routine 2
		move.w	#38/2,d1				; set collision detection width
		move.w	#80/2,d2				; set collision detection height
		bsr.w	EdgeWall_SolidWall			; check if Sonic has collided with the wall and stop him if so
; ---------------------------------------------------------------------------

Edge_Display:	; Routine 4
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================

Map_Edge:	include	"_maps/GHZ Edge Walls.asm"
