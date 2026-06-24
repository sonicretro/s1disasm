; ===========================================================================
; ---------------------------------------------------------------------------
; Object 21 - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------

HUD:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	HUD_Index(pc,d0.w),d1
		jmp	HUD_Index(pc,d1.w)
; ===========================================================================
HUD_Index:	dc.w HUD_Main-HUD_Index
		dc.w HUD_Flash-HUD_Index
; ===========================================================================

HUD_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to HUD_Flash
		move.w	#$80+$10,obX(a0)		; set screen X-position
		move.w	#$80+$88,obScreenY(a0)		; set screen Y-position
		move.l	#Map_HUD,obMap(a0)		; set mappings
		move.w	#ArtTile_HUD,obGfx(a0)		; set art tile (mappings themselves are high-prio)
		move.b	#sprite_cam_screen,obRender(a0)	; set to screen-positioned mode
		move.b	#0,obPriority(a0)		; set to maximum sprite priority
; ---------------------------------------------------------------------------

HUD_Flash:	; Routine 2
	if FixBugs
		; Fix the HUD blinking
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_HUD_blinking
		moveq	#0,d0				; use all-yellow frame by edefault
		btst	#3,(v_framebyte).w		; flash every 8 frames
		bne.s	.display			; branch on other frames
		tst.w	(v_rings).w			; do you have any rings?
		bne.s	.norings			; if so, branch
		addq.w	#1,d0				; make ring counter flash red
.norings:
	else
		tst.w	(v_rings).w			; do you have any rings?
		beq.s	.norings			; if not, branch
		clr.b	obFrame(a0)			; make all counters yellow
		jmp	(DisplaySprite).l		; display HUD
; ===========================================================================

.norings:
		moveq	#0,d0				; use all-yellow frame by default
		btst	#3,(v_framebyte).w		; flash every 8 frames
		bne.s	.display			; branch on other frames
		addq.w	#1,d0				; make ring counter flash red
	endif
		cmpi.b	#9,(v_timemin).w		; have 9 minutes elapsed?
		bne.s	.display			; if not, branch
		addq.w	#2,d0				; make time counter flash red

.display:
		move.b	d0,obFrame(a0)
		jmp	(DisplaySprite).l		; display HUD
; ===========================================================================

Map_HUD:	include	"_maps/HUD.asm"
