; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine execution subroutine
; ---------------------------------------------------------------------------

PaletteCycle:
	if FixBugs
		; Fix palettes getting corrupted during level transitions between different zones
		tst.w	(f_restart).w				; is level set to restart?
		beq.s	.doCycle				; if not, branch
		rts						; don't execute palette cycle
	endif

	.doCycle:
		moveq	#0,d2					; clear d2 (redundant, not used here)
		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get zone ID
		add.w	d0,d0					; double for word-based indexing
		move.w	PalCycle_Index(pc,d0.w),d0		; find palette routine for current zone
		jmp	PalCycle_Index(pc,d0.w)			; jump to relevant palette routine
; End of function PaletteCycle

; ---------------------------------------------------------------------------
; Palette cycling routines per Zone
; ---------------------------------------------------------------------------

PalCycle_Index:	dc.w PalCycle_GHZ-PalCycle_Index		; Green Hill Zone
		dc.w PalCycle_LZ-PalCycle_Index			; Labyrinth Zone
		dc.w PalCycle_MZ-PalCycle_Index			; Marble Zone (empty)
		dc.w PalCycle_SLZ-PalCycle_Index		; Star Light Zone
		dc.w PalCycle_SYZ-PalCycle_Index		; Spring Yard Zone
		dc.w PalCycle_SBZ-PalCycle_Index		; Scrap Brain Zone
		zonewarning PalCycle_Index,2
		dc.w PalCycle_GHZ-PalCycle_Index		; Ending Sequence (reuses GHZ)


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Green Hill Zone & Title Screen
; ---------------------------------------------------------------------------

PalCycle_Title:
		lea	(Pal_TitleCyc_Water).l,a0		; use special palette cycle for the title screen
		bra.s	PCycGHZ_Go
; ===========================================================================

PalCycle_GHZ:
		lea	(Pal_GHZCyc_Water).l,a0			; use regular GHZ palette cycle data

	PCycGHZ_Go:
		; Waterfalls and background water reflections
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.w	#6-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get cycle number
		addq.w	#1,(v_pcyc_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0					; data is arranged in blocks of 8 bytes each

		lea	(v_palette_line_3+(8*2)).w,a1		; target palette line 3, colors 8-B
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.l	4(a0,d0.w),(a1)				; write 2 colors

	.return:
		rts						; return
; End of function PalCycle_GHZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Labyrinth Zone
; ---------------------------------------------------------------------------

PalCycle_LZ:
		; Waterfalls
		subq.w	#1,(v_pcyc_time).w			; decrement timer for waterfalls
		bpl.s	.conveyorBelts				; if time remains, branch

		move.w	#3-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get cycle number
		addq.w	#1,(v_pcyc_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0					; data is arranged in blocks of 8 bytes each

		lea	(Pal_LZCyc_Waterfall).l,a0		; load LZ palette cycle data
		cmpi.b	#act4,(v_act).w				; check if on act 4 (SBZ3)
		bne.s	.cycleWaterfalls			; if not, branch
		lea	(Pal_SBZ3Cyc_Waterfall).l,a0		; load SBZ3 palette cycle data instead

	.cycleWaterfalls:
		lea	(v_palette_line_3+($B*2)).w,a1		; target palette line 3, colors B-E
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.l	4(a0,d0.w),(a1)				; write 2 colors

		lea	(v_palette_water_line_3+($B*2)).w,a1	; target underwater palette line 3, colors B-E
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.l	4(a0,d0.w),(a1)				; write 2 colors
; ---------------------------------------------------------------------------

.conveyorBelts:
		; Conveyor belts
		move.w	(v_framecount).w,d0			; get current level frame counter
		andi.w	#7,d0					; limit to 0-7
		move.b	PCycLZ_ConveyorSequence(pc,d0.w),d0	; get byte from palette sequence (0 or 1)
		beq.s	.return					; if byte is 0, don't update palette

		moveq	#1,d1					; cycle conveyor palette forwards
		tst.b	(f_conveyrev).w				; have conveyor belts been reversed?
		beq.s	.cycleConveyors				; if not, branch
		neg.w	d1					; cycle conveyor palette backwards
	.cycleConveyors:
		move.w	(v_pal_buffer).w,d0			; get current conveyor palette offset
		andi.w	#3,d0					; if cycle > 3, reset to 0
		add.w	d1,d0					; add cycle direction (+1 or -1)
		cmpi.w	#3,d0					; is new palette index > 2? (unsigned)
		blo.s	.writeConveyors				; if not, branch
		move.w	d0,d1					; backup cycle direction
		moveq	#0,d0					; if cycle > 2, reset to 0
		tst.w	d1					; are conveyors going backwards?
		bpl.s	.writeConveyors				; if not, branch
		moveq	#2,d0					; if cycle < 0, reset to 2
	.writeConveyors:
		move.w	d0,(v_pal_buffer).w			; write new conveyor palette offset

		add.w	d0,d0					; double offset
		move.w	d0,d1					; copy doubled offset
		add.w	d0,d0					; double offset again
		add.w	d1,d0					; d0 = offset multiplied by 6

		lea	(Pal_LZCyc_Conveyor).l,a0		; dry conveyor belt colors
		lea	(v_palette_line_4+($B*2)).w,a1		; target palette line 4, colors B-D
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.w	4(a0,d0.w),(a1)				; write 1 color

		lea	(Pal_LZCyc_ConveyorUW).l,a0		; underwater conveyor belt colors
		lea	(v_palette_water_line_4+($B*2)).w,a1	; target underwater palette line 3, colors B-D
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.w	4(a0,d0.w),(a1)				; write 1 color

	.return:
		rts						; return
; End of function PalCycle_LZ

; ---------------------------------------------------------------------------
PCycLZ_ConveyorSequence:
		; 0 = skip cycle this frame // 1 = advance cycle this frame
		dc.b 1,	0, 0, 1, 0, 0, 1, 0
		even
; ---------------------------------------------------------------------------


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Marble Zone
; ---------------------------------------------------------------------------

PalCycle_MZ:
		; Marble Zone doesn't have any palette cycles (anymore).
		; There is an unused set of palette cycle data found at
		; "Pal_MZCyc_Unused", which consists of red/orange/yellow
		; colors, suggesting they were once intended for lava.
		; It's pretty likely that those got dropped in favor of
		; the animated level graphics once those got introduced.
		rts						; return
; End of function PalCycle_MZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Star Light Zone
; ---------------------------------------------------------------------------

PalCycle_SLZ:
		; Lanterns, red lights, cyan lights
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.w	#8-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get lights palette offset
		addq.w	#1,d0					; increment cycle number
		cmpi.w	#6,d0					; has cycle reached 6?
		blo.s	.writeCycle				; if not, branch
		moveq	#0,d0					; if cycle > 5, reset to 0
	.writeCycle:
		move.w	d0,(v_pcyc_num).w			; write new lights palette offset

		move.w	d0,d1					; copy offset
		add.w	d1,d1					; double copy
		add.w	d1,d0					; add copy to original
		add.w	d0,d0					; d0 = multiplied by 3

		lea	(Pal_SLZCyc_Lights).l,a0		; cyan, red, yellow lights
		lea	(v_palette_line_3+($B*2)).w,a1		; target palette line 3, colors B-D
		move.w	(a0,d0.w),(a1)				; write 1 color
		move.l	2(a0,d0.w),4(a1)			; write 2 colors

	.return:
		rts						; return
; End of function PalCycle_SLZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Spring Yard Zone
; ---------------------------------------------------------------------------

PalCycle_SYZ:
		; Flashy scenery lights
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.w	#6-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get cycle number
		addq.w	#1,(v_pcyc_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#2,d0					; multiply by 4
		move.w	d0,d1					; two colors for red/white
		add.w	d0,d0					; four colors for black/yellow

		lea	(Pal_SYZCyc_BlackYellow).l,a0		; rotating black/yellow
		lea	(v_palette_line_4+(7*2)).w,a1		; target palette line 4, colors 7-A
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.l	4(a0,d0.w),(a1)				; write 2 colors

		lea	(Pal_SYZCyc_RedWhite).l,a0		; pulsating red/white
		lea	(v_palette_line_4+($B*2)).w,a1		; target palette line 4, colors B-C
		move.w	(a0,d1.w),(a1)				; write 1 color
		move.w	2(a0,d1.w),4(a1)			; write 1 color

	.return:
		rts						; return
; End of function PalCycle_SYZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Scrap Brain Zone
; ---------------------------------------------------------------------------

PalCycle_SBZ:
		; Custom palette scripts per act 1 and act 2 / FZ, see notes below
		lea	(Pal_SBZCycList_Act1).l,a2		; script for SBZ act 1
		tst.b	(v_act).w				; are we in the first act?
		beq.s	.executeCycleScripts			; if yes, branch
		lea	(Pal_SBZCycList_Act2FZ).l,a2		; script for SBZ act 2 and Final Zone
	.executeCycleScripts:
		lea	(v_pal_buffer).w,a1			; write to special SBZ palette cycle buffer
		move.w	(a2)+,d1				; get number of entries in palette cycle script list (minus 1 for dbf)

.sbzLoop:
		subq.b	#1,(a1)					; decrement timer for current script
		bmi.s	.updateColor				; if timer expired, branch to update colors
		addq.l	#2,a1					; advance to next stored palette index
		addq.l	#6,a2					; advance to next palette cycle script
		bra.s	.sbzNext				; execute next palette cycle script

	.updateColor:
		move.b	(a2)+,(a1)+				; reset timer
		move.b	(a1),d0					; get previously stored palette index
		addq.b	#1,d0					; increment palette index
		cmp.b	(a2)+,d0				; did palette index exceed number of colors to affect?
		blo.s	.writeColor				; if not, branch
		moveq	#0,d0					; reset to palette index 0
	.writeColor:
		move.b	d0,(a1)+				; remember current paletteindex

		andi.w	#$F,d0					; limit to 16 colors
		add.w	d0,d0					; double for word-sized colors
		movea.w	(a2)+,a0				; get source palette data
		movea.w	(a2)+,a3				; get target palette index in RAM
		move.w	(a0,d0.w),(a3)				; write 1 color

	.sbzNext:
		dbf	d1,.sbzLoop				; loop for all palette cycle scripts
; ---------------------------------------------------------------------------

		; Conveyor belts (spinning platforms and floor), act 2 gear wheels, electrocutor stems
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		lea	(Pal_SBZCyc_ConveyAct1).l,a0		; use SBZ1 palette cycle data
		move.w	#2-1,(v_pcyc_time).w			; reset timer
		tst.b	(v_act).w				; are we in SBZ act 1?
		beq.s	.conveyorDirection			; if yes, branch
		lea	(Pal_SBZCyc_ConveyAct2).l,a0		; use SBZ2/FZ palette cycle data
		move.w	#1-1,(v_pcyc_time).w			; shorter timer
	.conveyorDirection:
		moveq	#-1,d1					; cycle conveyor palette backwards
		tst.b	(f_conveyrev).w				; have conveyor belts been reversed?
		beq.s	.cycleConveyors				; if not, branch
		neg.w	d1					; cycle conveyor palette forwards
	.cycleConveyors:
		move.w	(v_pcyc_num).w,d0			; get current conveyor palette offset
		andi.w	#3,d0					; if cycle > 3, reset to 0
		add.w	d1,d0					; add cycle direction (+1 or -1)
		cmpi.w	#3,d0					; is new palette index > 2? (unsigned)
		blo.s	.writeConveyors				; if not, branch
		move.w	d0,d1					; backup cycle direction
		moveq	#0,d0					; if cycle > 2, reset to 0
		tst.w	d1					; are conveyors going forwards?
		bpl.s	.writeConveyors				; if not, branch
		moveq	#2,d0					; if cycle < 0, reset to 2
	.writeConveyors:
		move.w	d0,(v_pcyc_num).w			; write new conveyor palette offset
		add.w	d0,d0					; double offset for word-based color sizes

		lea	(v_palette_line_3+($C*2)).w,a1		; target palette line 3, colors C-E
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.w	4(a0,d0.w),(a1)				; write 1 color

	.return:
		rts						; return
; End of function PalCycle_SBZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycle data bincludes
; ---------------------------------------------------------------------------

Pal_TitleCyc_Water:	binclude	"palette/Cycle - Title Screen Water.bin"
Pal_GHZCyc_Water:	binclude	"palette/Cycle - GHZ.bin"
Pal_LZCyc_Waterfall:	binclude	"palette/Cycle - LZ Waterfall.bin"
Pal_LZCyc_Conveyor:	binclude	"palette/Cycle - LZ Conveyor Belt.bin"
Pal_LZCyc_ConveyorUW:	binclude	"palette/Cycle - LZ Conveyor Belt Underwater.bin"
Pal_SBZ3Cyc_Waterfall:	binclude	"palette/Cycle - SBZ3 Waterfall.bin"
	if UnusedOptimization=0
Pal_MZCyc_Unused:	binclude	"palette/Cycle - MZ (Unused).bin"
	endif
Pal_SLZCyc_Lights:	binclude	"palette/Cycle - SLZ.bin"
Pal_SYZCyc_BlackYellow:	binclude	"palette/Cycle - SYZ1.bin"
Pal_SYZCyc_RedWhite:	binclude	"palette/Cycle - SYZ2.bin"


; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap Brain Zone palette cycling script
; ---------------------------------------------------------------------------

mSBZh:	macro {INTLABEL}
__LABEL__:	label	*
		dc.w ((__LABEL___end-__LABEL__-2)/6)-1
		endm

mSBZp:	macro duration,colours,sourceAddress,destinationPalette
		dc.b (duration-1), colours
		dc.w sourceAddress, destinationPalette
		endm

; duration in frames, number of colours, source palette data, target palette index in RAM buffer

Pal_SBZCycList_Act1: mSBZh
		mSBZp	 8,  8, Pal_SBZCyc1,   v_palette_line_3+(8*2)	; FG multi-colored small blinking lights
		mSBZp	14,  8, Pal_SBZCyc2,   v_palette_line_3+(9*2)	; FG slow red/yellow pulse
		mSBZp	15,  8, Pal_SBZCyc3,   v_palette_line_4+(7*2)	; BG very slow red pulse
		mSBZp	12,  8, Pal_SBZCyc5,   v_palette_line_4+(8*2)	; BG slow red pulse
		mSBZp	 8,  8, Pal_SBZCyc6,   v_palette_line_4+(9*2)	; BG slow teal pulse
		mSBZp	29, 16, Pal_SBZCyc7,   v_palette_line_4+($F*2)	; BG very slow yellow/cyan pulse
		mSBZp	 4,  3, Pal_SBZCyc8,   v_palette_line_4+($C*2)	; electrocutor pink/purple 1
		mSBZp	 4,  3, Pal_SBZCyc8+2, v_palette_line_4+($D*2)	; electrocutor pink/purple 2
		mSBZp	 4,  3, Pal_SBZCyc8+4, v_palette_line_4+($E*2)	; electrocutor pink/purple 3
Pal_SBZCycList_Act1_end:
		even

Pal_SBZCycList_Act2FZ: mSBZh
		mSBZp	 8,  8, Pal_SBZCyc1,   v_palette_line_3+(8*2)	; FG multi-colored small blinking lights
		mSBZp	14,  8, Pal_SBZCyc2,   v_palette_line_3+(9*2)	; FG slow red/yellow pulse
		mSBZp	10,  8, Pal_SBZCyc9,   v_palette_line_4+(8*2)	; BG multi-colored small blinking lights
		mSBZp	 8,  8, Pal_SBZCyc6,   v_palette_line_4+(9*2)	; BG slow teal pulse
		mSBZp	 4,  3, Pal_SBZCyc8,   v_palette_line_4+($C*2)	; electrocutor pink/purple & BG pink square 1
		mSBZp	 4,  3, Pal_SBZCyc8+2, v_palette_line_4+($D*2)	; electrocutor pink/purple & BG pink square 2
		mSBZp	 4,  3, Pal_SBZCyc8+4, v_palette_line_4+($E*2)	; electrocutor pink/purple & BG pink square 3
Pal_SBZCycList_Act2FZ_end:
		even

; ---------------------------------------------------------------------------
; SBZ palette cycle data bincludes
; ---------------------------------------------------------------------------

Pal_SBZCyc1:		binclude	"palette/Cycle - SBZ 1.bin"	; FG multi-colored small blinking lights
Pal_SBZCyc2:		binclude	"palette/Cycle - SBZ 2.bin"	; FG slow red/yellow pulse
Pal_SBZCyc3:		binclude	"palette/Cycle - SBZ 3.bin"	; BG very slow red pulse
Pal_SBZCyc_ConveyAct1:	binclude	"palette/Cycle - SBZ 4.bin"	; conveyor belts in act 1
Pal_SBZCyc5:		binclude	"palette/Cycle - SBZ 5.bin"	; BG slow red pulse
Pal_SBZCyc6:		binclude	"palette/Cycle - SBZ 6.bin"	; BG slow teal pulse
Pal_SBZCyc7:		binclude	"palette/Cycle - SBZ 7.bin"	; BG very slow yellow/cyan pulse
Pal_SBZCyc8:		binclude	"palette/Cycle - SBZ 8.bin"	; electrocutor pink/purple & act 2 BG pink square
Pal_SBZCyc9:		binclude	"palette/Cycle - SBZ 9.bin"	; BG multi-colored small blinking lights (act 2 only)
Pal_SBZCyc_ConveyAct2:	binclude	"palette/Cycle - SBZ 10.bin"	; conveyor belts in act 2 / FZ

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

; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

PalCycle_Sega:
		tst.b	(v_pcyc_time+1).w			; is light scanning effect done?
		bne.s	PCycSega_FadeIn				; if yes, branch

; ---------------------------------------------------------------------------
; First part of the Sega screen palette cycle (the "light scan effect")
; ---------------------------------------------------------------------------

		lea	(v_palette_line_2).w,a1			; set target start palette line (affects line 2-4 overall)
		lea	(Pal_Sega1).l,a0			; get palette cycle colors for the light scanning effect
		moveq	#(Pal_Sega1_end-Pal_Sega1)/2-1,d1	; set size of colors to write (6 in total)
		move.w	(v_pcyc_num).w,d0			; load current palcycle position (initialized to -$A)

; loc_2020:
.findScanStart:
		bpl.s	.doLightScan				; has start position been found? if yes, branch (d0 >= 0)
		addq.w	#2,a0					; get next color in Pal_Sega1
		subq.w	#1,d1					; set to load one less color
		addq.w	#2,d0					; go to next starting color for light effect
		bra.s	.findScanStart				; loop until current position has been found
; ===========================================================================

; loc_202A:
.doLightScan:
		move.w	d0,d2					; get current target position
		andi.w	#$1E,d2					; limit to one palette line ($20 bytes)
		bne.s	.notTransparent1			; is it the first (transparent) color? if not, branch
		addq.w	#2,d0					; skip over transparent color

; loc_2034:
.notTransparent1:
		cmpi.w	#v_palette_line_4-v_palette_line_1,d0	; (=$60) would we write past the last palette entry?
		bhs.s	.writeNoMore				; if yes, do not write new color
		move.w	(a0)+,(a1,d0.w)				; write current light scan color to palette buffer

; loc_203E:
.writeNoMore:
		addq.w	#2,d0					; go to next starting color for light effect
		dbf	d1,.doLightScan				; loop until all colors have been written

		; Palette dumping is done, update next offset or set to next part
		move.w	(v_pcyc_num).w,d0			; load current palcycle position
		addq.w	#2,d0					; go to next starting color
		move.w	d0,d2					; get current target position
		andi.w	#$1E,d2					; limit to one palette line ($20 bytes)
		bne.s	.notTransparent2			; is it the first (transparent) color? if not, branch
		addq.w	#2,d0					; skip over transparent color

; loc_2054:
.notTransparent2:
		cmpi.w	#v_palette_line_4-v_palette_line_1+4,d0	; (=$64) has light scan effect finished?
		blt.s	.scanNotDone				; if not, branch
		move.w	#(4<<8)+1,(v_pcyc_time).w		; set delay between fade-in increments (high byte) and "light scan done" flag (low byte)
		moveq	#-6*2,d0				; set starting offset for fade-in palette (gets set to 0 for first fade-in step)

; loc_2062:
.scanNotDone:
		move.w	d0,(v_pcyc_num).w
		moveq	#1,d0					; clear Z-flag (possibly for a return signal, but now unsued)
		rts						; return
; ===========================================================================

; ---------------------------------------------------------------------------
; Second part of the Sega screen palette cycle (the fade-in)
; ---------------------------------------------------------------------------

; loc_206A:
PCycSega_FadeIn:
		subq.b	#1,(v_pcyc_time).w			; decrement delay until next brightness increase
		bpl.s	.delayFadeIn				; does delay time remain? if yes, branch

		move.b	#4,(v_pcyc_time).w			; reset delay between fade-in increments
		move.w	(v_pcyc_num).w,d0			; get current fade-in position
		addi.w	#6*2,d0					; go to next set of colors
		cmpi.w	#(6*2)*4,d0				; have four color sets been done?
		blo.s	.doFadeIn				; if not, do next fade-in step

		moveq	#0,d0					; set Z-flag (possibly for a return signal, but now unsued)
		rts						; return
; ===========================================================================

; loc_2088:
.doFadeIn:
		move.w	d0,(v_pcyc_num).w			; remember position for next fade-in increment
		lea	(Pal_Sega2).l,a0			; get palette cycle colors for the fade-in effect
		lea	(a0,d0.w),a0				; go to relevant color data
		lea	(v_palette_line_1+$04).w,a1		; set to write past transparent and pure-white color
		move.l	(a0)+,(a1)+				; write colors 1 and 2 to buffer
		move.l	(a0)+,(a1)+				; write colors 3 and 4 to buffer
		move.w	(a0)+,(a1)				; write color 5 to buffer

		; Main palette dumping is done, fill remaining palette buffer with 6th color
		lea	(v_palette_line_2).w,a1			; start from second palette line (up to fourth one)
		moveq	#0,d0					; clear d0
		moveq	#((v_palette_line_4-v_palette_line_1)/2)-3-1,d1 ; (=$2C) write 3 lines, minus skipped transparent colors, minus 1

; loc_20A8:
.fillRest:
		move.w	d0,d2					; get current target position
		andi.w	#$1E,d2					; limit to one palette line ($20 bytes)
		bne.s	.notTransparent3			; is it the first (transparent) color? if not, branch
		addq.w	#2,d0					; skip over transparent color

; loc_20B2:
.notTransparent3:
		move.w	(a0),(a1,d0.w)				; write fill color to current palette slot (and don't advance index)
		addq.w	#2,d0					; go to next palette target
		dbf	d1,.fillRest				; loop until remaining palette has been filled completely

; loc_20BC:
.delayFadeIn:
		moveq	#1,d0					; clear Z-flag (possibly for a return signal, but now unsued)
		rts						; return
; End of function PalCycle_Sega

; ===========================================================================
; >>> Palette cycle data used for Sega screen
Pal_Sega1:	bincludeEndMarker	"palette/Sega1.bin"	; used during the light scanning effect
Pal_Sega2:	bincludeEndMarker	"palette/Sega2.bin"	; used during the fade-in (three color sets, 5+1 colors each)

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load main palettes into the fading buffer.
; These get displayed once PaletteFadeIn/PaletteWhiteIn is called.

; input:
; d0 = index number for palette
; ---------------------------------------------------------------------------

PalLoad_Fade:
		lea	(Pal_Index).l,a1			; get palette pointers
		lsl.w	#3,d0					; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1					; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		adda.w	#v_palette_fading-v_palette,a3		; load to palette fade-in buffer instead of active palette buffer (+$80)
		move.w	(a1)+,d7				; get length of palette data

.loop:
		move.l	(a2)+,(a3)+				; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop				; loop until all colors are loaded
		rts						; return
; End of function PalLoad_Fade

; ---------------------------------------------------------------------------
; Subroutine to directly load main palettes to the active palette.
; Same as PalLoad_Fade, but without adding $80.
; ---------------------------------------------------------------------------

PalLoad:
		lea	(Pal_Index).l,a1			; get palette pointers
		lsl.w	#3,d0					; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1					; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		move.w	(a1)+,d7				; get length of palette data

.loop:
		move.l	(a2)+,(a3)+				; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop				; loop until all colors are loaded
		rts						; return
; End of function PalLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load underwater palettes into the water fading buffer.
; These get displayed once PaletteFadeIn/PaletteWhiteIn is called.
; ---------------------------------------------------------------------------

PalLoad_Fade_Water:
		lea	(Pal_Index).l,a1			; get palette pointers
		lsl.w	#3,d0					; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1					; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		suba.w	#v_palette-v_palette_water,a3		; load to (water) palette fade-in buffer instead of active palette buffer
		move.w	(a1)+,d7				; get length of palette data

.loop:
		move.l	(a2)+,(a3)+				; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop				; loop until all colors are loaded
		rts						; return
; End of function PalLoad_Fade_Water

; ---------------------------------------------------------------------------
; Subroutine to directly load underwater palettes to the active palette.
; Same as PalLoad_Fade_Water, but writing $80 before it.
; ---------------------------------------------------------------------------

PalLoad_Water:
		lea	(Pal_Index).l,a1			; get palette pointers
		lsl.w	#3,d0					; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1					; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		suba.w	#v_palette-v_palette_water_fading,a3	; load to active (water) palette buffer instead of main active palette buffer
		move.w	(a1)+,d7				; get length of palette data

.loop:
		move.l	(a2)+,(a3)+				; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop				; loop until all colors are loaded
		rts						; return
; End of function PalLoad_Water

; ===========================================================================
; ---------------------------------------------------------------------------
; Palette index
; ---------------------------------------------------------------------------

makePalEntry:	macro paletteLabel,paletteRAMaddress,{INTLABEL}
__LABEL__:	label	(*-Pal_Index)/8
		dc.l paletteLabel
		dc.w paletteRAMaddress,(paletteLabel_end-paletteLabel)/4-1
		endm
; ---------------------------------------------------------------------------

Pal_Index:

; Id			Palette label,		RAM location
; NOTE: Palette size is calculated dynamically using an end marker made by bincludeEndMarker
palid_SegaBG:		makePalEntry	Pal_SegaBG, 		v_palette_line_1
palid_Title:		makePalEntry	Pal_Title,		v_palette_line_1
palid_LevelSel:		makePalEntry	Pal_LevelSel,		v_palette_line_1
palid_Sonic:		makePalEntry	Pal_Sonic,		v_palette_line_1

	Pal_Levels:
palid_GHZ:		makePalEntry	Pal_GHZ, 		v_palette_line_2
palid_LZ:		makePalEntry	Pal_LZ, 		v_palette_line_2
palid_MZ:		makePalEntry	Pal_MZ, 		v_palette_line_2
palid_SLZ:		makePalEntry	Pal_SLZ,		v_palette_line_2
palid_SYZ:		makePalEntry	Pal_SYZ,		v_palette_line_2
palid_SBZ1:		makePalEntry	Pal_SBZ1, 		v_palette_line_2
	zonewarning Pal_Levels,8

palid_Special:		makePalEntry	Pal_Special, 		v_palette_line_1
palid_LZWater:		makePalEntry	Pal_LZWater, 		v_palette_line_1
palid_SBZ3:		makePalEntry	Pal_SBZ3, 		v_palette_line_2
palid_SBZ3Water:	makePalEntry	Pal_SBZ3Water, 		v_palette_line_1
palid_SBZ2:		makePalEntry	Pal_SBZ2, 		v_palette_line_2
palid_LZSonWater:	makePalEntry	Pal_LZSonWater,		v_palette_line_1
palid_SBZ3SonWat:	makePalEntry	Pal_SBZ3SonWat,		v_palette_line_1
palid_SSResult:		makePalEntry	Pal_SSResult, 		v_palette_line_1
palid_Continue:		makePalEntry	Pal_Continue, 		v_palette_line_1
palid_Ending:		makePalEntry	Pal_Ending, 		v_palette_line_1
	even


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette data bincludes
; ---------------------------------------------------------------------------

Pal_SegaBG:		bincludeEndMarker	"palette/Sega Background.bin"
Pal_Title:		bincludeEndMarker	"palette/Title Screen.bin"
Pal_LevelSel:		bincludeEndMarker	"palette/Level Select.bin"
Pal_Sonic:		bincludeEndMarker	"palette/Sonic.bin"
Pal_GHZ:		bincludeEndMarker	"palette/Green Hill Zone.bin"
Pal_LZ:			bincludeEndMarker	"palette/Labyrinth Zone.bin"
Pal_LZWater:		bincludeEndMarker	"palette/Labyrinth Zone Underwater.bin"
Pal_MZ:			bincludeEndMarker	"palette/Marble Zone.bin"
Pal_SLZ:		bincludeEndMarker	"palette/Star Light Zone.bin"
Pal_SYZ:		bincludeEndMarker	"palette/Spring Yard Zone.bin"
Pal_SBZ1:		bincludeEndMarker	"palette/SBZ Act 1.bin"
Pal_SBZ2:		bincludeEndMarker	"palette/SBZ Act 2.bin"
Pal_Special:		bincludeEndMarker	"palette/Special Stage.bin"
Pal_SBZ3:		bincludeEndMarker	"palette/SBZ Act 3.bin"
Pal_SBZ3Water:		bincludeEndMarker	"palette/SBZ Act 3 Underwater.bin"
Pal_LZSonWater:		bincludeEndMarker	"palette/Sonic - LZ Underwater.bin"
Pal_SBZ3SonWat:		bincludeEndMarker	"palette/Sonic - SBZ3 Underwater.bin"
Pal_SSResult:		bincludeEndMarker	"palette/Special Stage Results.bin"
Pal_Continue:		bincludeEndMarker	"palette/Special Stage Continue Bonus.bin"
Pal_Ending:		bincludeEndMarker	"palette/Ending.bin"