; ===========================================================================
; ---------------------------------------------------------------------------
; Object 71 - invisible solid barriers
; ---------------------------------------------------------------------------

Invisibarrier:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Invis_Index(pc,d0.w),d1
		jmp	Invis_Index(pc,d1.w)
; ===========================================================================
Invis_Index:	dc.w Invis_Main-Invis_Index
		dc.w Invis_Solid-Invis_Index
; ===========================================================================

Invis_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to Invis_Solid
		move.l	#Map_Invis,obMap(a0)		; set mappings (debug mode only)
		move.w	#ArtTile_Monitor|Tile_Prio,obGfx(a0) ; set art tile and priority bit (debug mode only)
		ori.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode

		move.b	obSubtype(a0),d0		; get width/height settings for block
		move.b	d0,d1				; copy for height
		andi.w	#$F0,d0				; read only the 1st byte
		addi.w	#$10,d0				; settings are 0-based, actual sizes are 1-based
		lsr.w	#1,d0				; divide by 2 ($10px per digit, obActWid is halved)
		move.b	d0,obActWid(a0)			; set object width
		andi.w	#$F,d1				; read only the 2nd byte
		addq.w	#1,d1				; settings are 0-based, actual sizes are 1-based
		lsl.w	#3,d1				; multiply by 8 ($10px per setting, obHeight is halved)
		move.b	d1,obHeight(a0)			; set object height
; ---------------------------------------------------------------------------

Invis_Solid:	; Routine 2
	if FixBugs
		; Fixes phasing through barriers while ducking
		; (note that ChkPartiallyVisible had to be fixed as well)
		bsr.w	ChkPartiallyVisible		; check if object is in visible screen space (including vertically)
	else
		bsr.w	ChkObjectVisible		; check if object is in visible screen space (vertically imprecise)
	endif
		bne.s	.chkdel				; if not, branch

		moveq	#0,d1				; clear d1 (obActWid is a byte, we need words)
		move.b	obActWid(a0),d1			; get collision width of invisible block
		addi.w	#sonic_solid_width,d1		; add Sonic's own collision width
		moveq	#0,d2				; clear d2 (obHeight is a byte, we need words)
		move.b	obHeight(a0),d2			; get collision height of invisible block
		move.w	d2,d3				; duplicate it for secondary collision height input
		addq.w	#1,d3				; increase secondary collision height by 1
		move.w	obX(a0),d4			; set invisible block's X-position as input
		bsr.w	SolidObject_NoRenderChk		; handle collision with Sonic (don't check for display, invisible object)
; ---------------------------------------------------------------------------

.chkdel:
		out_of_range.s	.delete			; has object gone offscreen? if yes, delete it
		tst.w	(v_debuguse).w			; are you using debug mode?
		beq.s	.nodisplay			; if not, branch
		jmp	(DisplaySprite).l		; display the invisible object for debugging purposes

	.nodisplay:
		rts					; keep object alive, but don't display it

	.delete:
		jmp	(DeleteObject).l		; delete object
; ===========================================================================

Map_Invis:	include	"_maps/Invisible Barriers.asm"
