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
Pal_MZCyc_Unused:	binclude	"palette/Cycle - MZ (Unused).bin"
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
