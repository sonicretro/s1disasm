; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3B - purple rock (GHZ)
; ---------------------------------------------------------------------------

PurpleRock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Rock_Index(pc,d0.w),d1
		jmp	Rock_Index(pc,d1.w)
; ===========================================================================
Rock_Index:	dc.w Rock_Main-Rock_Index
		dc.w Rock_Solid-Rock_Index
; ===========================================================================

Rock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Rock_Solid
		move.l	#Map_PRock,obMap(a0)			; set mappings
		move.w	#ArtTile_GHZ_Purple_Rock|Tile_Pal4,obGfx(a0) ; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
	if FixBugs
		; This should be 48 pixels, otherwise it gets culled too soon.
		move.b	#48/2,obActWid(a0)			; set sprite display width (corrected)
	else
		move.b	#38/2,obActWid(a0)			; set sprite display width (too small)
	endif
		move.b	#4,obPriority(a0)			; set sprite priority
; ---------------------------------------------------------------------------

Rock_Solid:	; Routine 2
		move.w	#32/2+sonic_solid_width,d1		; SolidObject input: width
		move.w	#32/2,d2				; SolidObject input: height (initial)
		move.w	#32/2,d3				; SolidObject input: height (stood-on)
		move.w	obX(a0),d4				; SolidObject input: object X-position (stood-on)
		bsr.w	SolidObject				; make rock solid for Sonic

	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		; This same bugfix can be found in Sonic 2's unused copy of
		; this object.
		out_of_range.w	DeleteObject			; has object gone out of range? if yes, delete it
		bra.w	DisplaySprite				; otherwise, display object
	else
		bsr.w	DisplaySprite				; display object
		out_of_range.w	DeleteObject			; has object gone out of range? if yes, delete it
		rts						; return
	endif
