; ---------------------------------------------------------------------------
; Object 8A - "SONIC TEAM PRESENTS" and credits
; ---------------------------------------------------------------------------

CreditsText:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cred_Index(pc,d0.w),d1
		jmp	Cred_Index(pc,d1.w)
; ===========================================================================
Cred_Index:	dc.w Cred_Main-Cred_Index
		dc.w Cred_Display-Cred_Index
; ===========================================================================

Cred_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Cred_Display
		move.w	#(320/2)+$80,obX(a0)			; set X-position to horizontally centered ($120)
		move.w	#(224/2)+$80,obScreenY(a0)		; set Y-position to vertically centered ($F0)
		move.l	#Map_Cred,obMap(a0)			; set mappings pointer
		move.w	#ArtTile_Credits_Font,obGfx(a0)		; default art tile offset
		move.w	(v_creditsnum).w,d0			; load credits page index number (doesn't reset between game mode changes)
		move.b	d0,obFrame(a0)				; display appropriate sprite
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen coordinates positioning mode
		move.b	#0,obPriority(a0)			; set top sprite priority

		cmpi.b	#id_Title,(v_gamemode).w		; is the mode #4 (title screen)?
		bne.s	Cred_Display				; if not, branch
		move.w	#ArtTile_Sonic_Team_Font,obGfx(a0)	; alternate art tile offset for title screen
		move.b	#$A,obFrame(a0)				; display "SONIC TEAM PRESENTS" frame

		tst.b	(f_creditscheat).w			; is hidden Japanese credits cheat on?
		beq.s	Cred_Display				; if not, branch
		cmpi.b	#btnABC+btnDn,(v_jpadhold1).w		; is exactly A+B+C+Down being held? ($72)
		bne.s	Cred_Display				; if not, branch
		move.w	#cWhite,(v_palette_fading_line_3).w	; 3rd palette, 1st entry = white
		move.w	#$880,(v_palette_fading_line_3+2).w	; 3rd palette, 2nd entry = cyan
		jmp	(DeleteObject).l			; delete STP object for hidden Japanese credits
; ===========================================================================

Cred_Display:	; Routine 2
		jmp	(DisplaySprite).l			; just display credits sprite
; ===========================================================================

Map_Cred:	include	"_maps/Credits.asm"
