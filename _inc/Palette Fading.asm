; ===========================================================================
; ---- Palette fading subroutines input format, shared by all variations ----
;
; v_pfade_start = Start position in palette. One word per color. Examples:
;                 $00: palette line 1, first color
;                 $20: palette line 2, first color
;                 $42: palette line 3, second color
; 
; v_pfade_size  = Number of colors to affect, minus 1. Examples:
;                 $0F: 16 colors (one palette line)
;                 $1F: 32 colors (two palette lines)
;                 $3F: is the entire palette (four palette lines)
; 
; v_pfade_start and v_pfade_size are back to back in RAM, so they usually
; get set together as a single word write to v_pfade_start. The most common
; setting is $003F for "the entire palette", which is why it has a shorthand.
; 
; One more note about RGB: the Mega Drive stores the color values backwards,
; meaning that one color word has the format BGR (blue-green-red).
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade in from black
; ---------------------------------------------------------------------------

PaletteFadeIn:
		move.w	#$003F,(v_pfade_start).w		; set start position = 0; affect all $40 palette colors
; ---------------------------------------------------------------------------

PalFadeIn_Alt:	; start position and size are already set
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance palette buffer to start position
		moveq	#cBlack,d1				; fill palette with black ($000)
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fillBlack:
		move.w	d1,(a0)+				; make color black
		dbf	d0,.fillBlack 				; loop until colors have been filled with black

		move.w	#22-1,d4				; fade in for 22 frames (d4 must not be used elsewhere!)
	.fadeMainLoop:
		move.b	#id_VBlank_PaletteFade,(v_vblank_routine).w ; set VBlank routine to fade-in ($12)
		bsr.w	WaitForVBlank				; wait for VBlank to transfer CRAM and sync screen
		bsr.s	FadeIn_FromBlack			; fade-in all affected colors from black a bit more
		bsr.w	RunPLC					; run any PLC, if necessary
		dbf	d4,.fadeMainLoop			; loop for 22 frames

		rts						; return
; End of function PaletteFadeIn
; ===========================================================================

FadeIn_FromBlack:
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load active palette buffer
		lea	(v_palette_fading).w,a1			; load fade-in palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		adda.w	d0,a1					; advance fade-in palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColors:
		bsr.s	FadeIn_AddColor				; fade-in current color a bit more
		dbf	d0,.fadeColors				; loop until all colors have been faded in more
; ---------------------------------------------------------------------------

		cmpi.b	#id_LZ,(v_zone).w			; are we in Labyrinth Zone?
		bne.s	.return					; if not, don't affect underwater palette buffer

		moveq	#0,d0					; clear d0
		lea	(v_palette_water).w,a0			; load active underwater palette buffer
		lea	(v_palette_water_fading).w,a1		; load fade-in underwater palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active underwater palette buffer to start position
		adda.w	d0,a1					; advance fade-in underwater palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColorsWater:
		bsr.s	FadeIn_AddColor				; fade-in current color from black a bit more
		dbf	d0,.fadeColorsWater			; loop until all water colors have been faded in more

	.return:
		rts						; return
; End of function FadeIn_FromBlack
; ===========================================================================

; The fade-in logic increases one RGB value at a time until the target color
; has been reached. Sonic 1 fades blue first, then green, then red, resulting
; in the characteristic blue-tinted fade seen throughout the entire game.
; A simultaneous RGB fade would appear more natural, but would also complete
; much faster. This staggered approach may have been chosen to extend
; the fade duration while giving it a distinct visual style.

FadeIn_AddColor:
		move.w	(a1)+,d2				; get current target color (and advance index for next color)
		move.w	(a0),d3					; get current active color
		cmp.w	d2,d3					; has active color already reached its target level?
		beq.s	.nextColor				; if yes, fade is done for this color

	.addBlue:
		move.w	d3,d1					; get current active color
		addi.w	#$200,d1				; increase blue value by one step
		cmp.w	d2,d1					; has blue exceeded target level?
		bhi.s	.addGreen				; if yes, start fading in green
		move.w	d1,(a0)+				; update active color
		rts						; do not update green or red values until blue is done
; ---------------------------------------------------------------------------

	.addGreen:
		move.w	d3,d1					; get current active color
		addi.w	#$020,d1				; increase green value by one step
		cmp.w	d2,d1					; has green exceeded target level?
		bhi.s	.addRed					; if yes, start fading in red
		move.w	d1,(a0)+				; update active color
		rts						; do not update red value until green is done
; ---------------------------------------------------------------------------

	.addRed:
		addq.w	#$002,(a0)+				; increase red value by one step & update active color
		rts						; return
; ---------------------------------------------------------------------------

	.nextColor:
		addq.w	#2,a0					; advance active palette buffer to next color
		rts						; return
; End of function FadeIn_AddColor


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------

PaletteFadeOut:
		move.w	#$003F,(v_pfade_start).w		; set start position = 0; affect all $40 palette colors

		move.w	#22-1,d4				; fade in for 22 frames (d4 must not be used elsewhere!)
	.fadeMainLoop:
		move.b	#id_VBlank_PaletteFade,(v_vblank_routine).w ; set VBlank routine to fade-in ($12)
		bsr.w	WaitForVBlank				; wait for VBlank to transfer CRAM and sync screen
		bsr.s	FadeOut_ToBlack				; fade-out all affected colors to black a bit more
		bsr.w	RunPLC					; run any PLC, if necessary
		dbf	d4,.fadeMainLoop			; loop for 22 frames

		rts						; return
; End of function PaletteFadeOut
; ===========================================================================

FadeOut_ToBlack:
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load active palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColors:
		bsr.s	FadeOut_DecColor			; fade-out current color a bit more
		dbf	d0,.fadeColors				; repeat for size of palette

		; Underwater palette is faded out to black even in non-LZ levels
		moveq	#0,d0					; clear d0
		lea	(v_palette_water).w,a0			; load active underwater palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColorsWater:
		bsr.s	FadeOut_DecColor			; fade-out current color to black a bit more
		dbf	d0,.fadeColorsWater			; loop until all water colors have been faded out more

		rts						; return
; End of function FadeOut_ToBlack
; ===========================================================================

FadeOut_DecColor:
		move.w	(a0),d2					; get current active color
		beq.s	.nextColor				; if it's already fully black ($000), fade-out is done for this color

	.decRed:
		move.w	d2,d1					; get current active color again
		andi.w	#$00E,d1				; only look at red channel
		beq.s	.decGreen				; if red channel is already at 0, start fading out green
		subq.w	#$002,(a0)+				; decrease red value
		rts						; do not update green or blues values until blue is done
; ---------------------------------------------------------------------------

	.decGreen:
		move.w	d2,d1					; get current active color again
		andi.w	#$0E0,d1				; only look at green channel
		beq.s	.decBlue				; if green channel is already at 0, start fading out blue
		subi.w	#$020,(a0)+				; decrease green value
		rts						; do not update blue value until green is done
; ---------------------------------------------------------------------------

	.decBlue:
		move.w	d2,d1					; get current active color again
		andi.w	#$E00,d1				; only look at blue channel
		beq.s	.nextColor				; if blue channel is already at 0, exit
		subi.w	#$200,(a0)+				; decrease blue value
		rts						; return
; ---------------------------------------------------------------------------

	.nextColor:
		addq.w	#2,a0					; advance active palette buffer to next color
		rts						; return
; End of function FadeOut_DecColor


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade in from white (Special Stage)
; ---------------------------------------------------------------------------

PaletteWhiteIn:
		move.w	#$003F,(v_pfade_start).w		; set start position = 0; affect all $40 palette colors
; ---------------------------------------------------------------------------

PalWhiteIn_Alt:	; start position and size are already set
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance palette buffer to start position
		move.w	#cWhite,d1				; fill palette with white ($EEE)
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fillWhite:
		move.w	d1,(a0)+				; make color white
		dbf	d0,.fillWhite				; fill palette with white

		move.w	#22-1,d4				; fade in for 22 frames (d4 must not be used elsewhere!)
	.fadeMainLoop:
		move.b	#id_VBlank_PaletteFade,(v_vblank_routine).w ; set VBlank routine to fade-in ($12)
		bsr.w	WaitForVBlank				; wait for VBlank to transfer CRAM and sync screen
		bsr.s	WhiteIn_FromWhite			; fade-in all affected colors from white a bit more
		bsr.w	RunPLC					; run any PLC, if necessary
		dbf	d4,.fadeMainLoop			; loop for 22 frames

		rts						; return
; End of function PaletteWhiteIn
; ===========================================================================

WhiteIn_FromWhite:
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load active palette buffer
		lea	(v_palette_fading).w,a1			; load fade-in palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		adda.w	d0,a1					; advance fade-in palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColors:
		bsr.s	WhiteIn_DecColor			; fade-in current color from white a bit more
		dbf	d0,.fadeColors				; repeat for size of palette
; ---------------------------------------------------------------------------

		cmpi.b	#id_LZ,(v_zone).w			; are we in Labyrinth Zone?
		bne.s	.return					; if not, don't affect underwater palette buffer

		moveq	#0,d0					; clear d0
		lea	(v_palette_water).w,a0			; load active underwater palette buffer
		lea	(v_palette_water_fading).w,a1		; load fade-in underwater palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active underwater palette buffer to start position
		adda.w	d0,a1					; advance fade-in underwater palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColorsWater:
		bsr.s	WhiteIn_DecColor			; fade-in current color from white a bit more
		dbf	d0,.fadeColorsWater			; loop until all water colors have been faded in more

	.return:
		rts						; return
; End of function WhiteIn_FromWhite
; ===========================================================================

WhiteIn_DecColor:
		move.w	(a1)+,d2				; get current target color (and advance index for next color)
		move.w	(a0),d3					; get current active color
		cmp.w	d2,d3					; has active color already reached its target level?
		beq.s	.nextColor				; if yes, fade is done for this color

	.decBlue:
		move.w	d3,d1					; get current active color
		subi.w	#$200,d1				; decrease blue value by one step
		blo.s	.decGreen				; was blue value already at 0? if yes, start fading in green
		cmp.w	d2,d1					; has blue value exceeded target level?
		blo.s	.decGreen				; if yes, start fading in green
		move.w	d1,(a0)+				; update active color
		rts						; do not update green or red value until blue is done
; ---------------------------------------------------------------------------

	.decGreen:
		move.w	d3,d1					; get current active color
		subi.w	#$020,d1				; decrease green value by one step
		blo.s	.decRed					; was green value already at 0? if yes, start fading in red
		cmp.w	d2,d1					; has green value exceeded target level?
		blo.s	.decRed					; if yes, start fading in red
		move.w	d1,(a0)+				; update active color
		rts						; do not update red value until green is done
; ---------------------------------------------------------------------------

	.decRed:
		subq.w	#$002,(a0)+				; decrease red value by one step & update active color
		rts						; return
; ---------------------------------------------------------------------------

	.nextColor:
		addq.w	#2,a0					; advance active palette buffer to next color
		rts						; return
; End of function WhiteIn_DecColor


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade out to white (Special Stage)
; ---------------------------------------------------------------------------

PaletteWhiteOut:
		move.w	#$003F,(v_pfade_start).w		; set start position = 0; affect all $40 palette colors

		move.w	#22-1,d4				; fade in for 22 frames (d4 must not be used elsewhere!)
	.fadeMainLoop:
		move.b	#id_VBlank_PaletteFade,(v_vblank_routine).w ; set VBlank routine to fade-in ($12)
		bsr.w	WaitForVBlank				; wait for VBlank to transfer CRAM and sync screen
		bsr.s	WhiteOut_ToWhite			; fade-out all affected colors to white bit more
		bsr.w	RunPLC					; run any PLC, if necessary
		dbf	d4,.fadeMainLoop			; loop for 22 frames

		rts						; return
; End of function PaletteWhiteOut
; ===========================================================================

WhiteOut_ToWhite:
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load active palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColors:
		bsr.s	WhiteOut_AddColor			; fade-out current color to white a bit more
		dbf	d0,.fadeColors				; loop until all colors have been faded out more

		; Underwater palette is faded out to white even in non-LZ levels
		moveq	#0,d0					; clear d0
		lea	(v_palette_water).w,a0			; load active underwater palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active underwater palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColorsWater:
		bsr.s	WhiteOut_AddColor			; fade-out current color to white a bit more
		dbf	d0,.fadeColorsWater			; loop until all colors have been faded out more

		rts						; return
; End of function WhiteOut_ToWhite
; ===========================================================================

WhiteOut_AddColor:
		move.w	(a0),d2					; get current active color
		cmpi.w	#cWhite,d2				; is color already at fully white? ($EEE)
		beq.s	.nextColor				; if yes, fade-out is done for this color

	.addRed:
		move.w	d2,d1					; get current active color again
		andi.w	#$00E,d1				; only look at red channel
		cmpi.w	#cRed,d1				; is channel already at fully red? ($00E)
		beq.s	.addGreen				; if yes, start fading out green
		addq.w	#$002,(a0)+				; increase red value
		rts						; do not update green or blues values until blue is done
; ---------------------------------------------------------------------------

	.addGreen:
		move.w	d2,d1					; get current active color again
		andi.w	#$0E0,d1				; only look at green channel
		cmpi.w	#cGreen,d1				; is channel already at fully green? ($0E0)
		beq.s	.addBlue				; if yes, start fading out blue
		addi.w	#$020,(a0)+				; increase green value
		rts						; do not update blue value until green is done
; ---------------------------------------------------------------------------

	.addBlue:
		move.w	d2,d1					; get current active color again
		andi.w	#$E00,d1				; only look at blue channel
		cmpi.w	#cBlue,d1				; is channel already at fully blue? ($E00)
		beq.s	.nextColor				; if yes, exit
		addi.w	#$200,(a0)+				; increase blue value
		rts						; return
; ---------------------------------------------------------------------------

	.nextColor:
		addq.w	#2,a0					; advance active palette buffer to next color
		rts						; return
; End of function WhiteOut_AddColor
