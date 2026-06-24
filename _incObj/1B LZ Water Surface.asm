; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1B - water surface (LZ)
; (Two objects are loaded, one for the left and one for the right side.)
; ---------------------------------------------------------------------------

WaterSurface:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Surf_Index(pc,d0.w),d1
		jmp	Surf_Index(pc,d1.w)
; ===========================================================================
Surf_Index:	dc.w Surf_Main-Surf_Index
		dc.w Surf_Action-Surf_Index

surf_origX:	equ objoff_30		; original x-axis position
surf_freeze:	equ objoff_32		; flag to freeze animation while game is paused
; ===========================================================================

Surf_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Surf_Action
		move.l	#Map_Surf,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Water_Surface|Tile_Pal3|Tile_Prio,obGfx(a0) ; set art tile, palette line, and priority flag
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#256/2,obActWid(a0)			; set sprite display width (very large)
		move.w	obX(a0),surf_origX(a0)			; remember original X-position ($60 for left surface, $120 for right surface)
; ---------------------------------------------------------------------------

Surf_Action:	; Routine 2
		move.w	(v_screenposx).w,d1			; get current camera X-position
		andi.w	#$FFE0,d1				; wrap every $20px to make surface seem camera-independent
		add.w	surf_origX(a0),d1			; add base X-position for left or right surface object
		btst	#0,(v_framebyte).w			; are we on an odd frame?
		beq.s	.setX					; if not, branch
		addi.w	#$20,d1					; flicker between position 0 and $20 every frame
	.setX:	move.w	d1,obX(a0)				; match Y-position to screen position

		move.w	(v_waterpos1).w,d1			; get current water height
		move.w	d1,obY(a0)				; match Y-position to water height

		; If the game gets paused with the flickering surface object on screen,
		; this will swap it out with an alternate frame that lacks the gaps to make
		; the water surface seem continuous while the game is paused.
		tst.b	surf_freeze(a0)				; has surface already been frozen from a paused game?
		bne.s	.gamePaused				; if yes, branch
		btst	#bitStart,(v_jpadpress1).w		; is Start button pressed?
		beq.s	.animate				; if not, branch
		addq.b	#3,obFrame(a0)				; use the seamless "paused" frames
		move.b	#1,surf_freeze(a0)			; stop animation
		bra.s	.display				; skip over .gamePaused
; ---------------------------------------------------------------------------

	.gamePaused:
		tst.w	(f_pause).w				; has the game been unpaused yet?
		bne.s	.display				; if not, keep skipping animation
		move.b	#0,surf_freeze(a0)			; resume animation
		subq.b	#3,obFrame(a0)				; use normal interlaced frames again

	.animate:
		subq.b	#1,obTimeFrame(a0)			; decrement animation delay
		bpl.s	.display				; if time remains, branch
		move.b	#8-1,obTimeFrame(a0)			; reset animation delay to 8 frames
		addq.b	#1,obFrame(a0)				; advance to next frame
		cmpi.b	#3,obFrame(a0)				; have we reached frame 3?
		blo.s	.display				; if not, branch
		move.b	#0,obFrame(a0)				; reset back to frame 0

	.display:
		bra.w	DisplaySprite				; display surface sprite
; ===========================================================================

Map_Surf:	include	"_maps/Water Surface.asm"
