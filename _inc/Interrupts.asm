; ===========================================================================
; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------
id_VBlank_Lag:		equ $00					; (lag frame)
id_VBlank_Sega:		equ $02					; Sega Screen
id_VBlank_Title:	equ $04					; Title Screen, Credits
id_VBlank_Unused06:	equ $06					; (unused)
id_VBlank_Levels:	equ $08					; Levels, Demos
id_VBlank_SpecialStage:	equ $0A					; Special Stages
id_VBlank_TitleCards:	equ $0C					; Title Cards
id_VBlank_Unused0E:	equ $0E					; (unused)
id_VBlank_Paused:	equ $10					; Paused
id_VBlank_PaletteFade:	equ $12					; Palette Fade
id_VBlank_SegaPCM:	equ $14					; Sega Screen PCM
id_VBlank_Continue:	equ $16					; Continue Screen
id_VBlank_Ending:	equ $18					; Ending Sequence
; ---------------------------------------------------------------------------

; loc_B10: VBla:
VBlank:
		movem.l	d0-a6,-(sp)				; backup all registers except stack pointer (a7)

		tst.b	(v_vblank_routine).w			; was a VBlank routine set?
		beq.s	VBlank_Lag				; if not, this is a lag frame, branch

		move.w	(vdp_control_port).l,d0			; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		move.l	#$40000010,(vdp_control_port).l		; set VDP to VSRAM write mode
		move.l	(v_scrposy_vdp).w,(vdp_data_port).l	; send screen y-axis pos. to VSRAM

		; Wait here in a loop doing nothing for a while. This seems to be a pretty harsh attempt
		; to push CRAM dots outside of the visible view area, due to Sonic 1 not using all
		; the available screen space PAL offers, as they would otherwise be seen at the bottom.
		btst	#6,(v_megadrive).w			; is Mega Drive PAL?
		beq.s	.notPAL					; if not, branch
		move.w	#$700,d0				; set to waste a bunch of cycles
	.waitPAL:
		dbf	d0,.waitPAL				; loop until cycles have been wasted

.notPAL:
		move.b	(v_vblank_routine).w,d0			; copy specified VBlank routine to d0
		move.b	#id_VBlank_Lag,(v_vblank_routine).w	; reset actual routine to lag frame (which ideally should get set again in the next frame)
		move.w	#1,(f_hblank_pal).w			; set HBlank palette swap flag (only relevant for LZ)
		andi.w	#$3E,d0					; mask out irrelevant bits in VBlank routine
		move.w	VBlank_Index(pc,d0.w),d0		; load address to relevant VBlank routine
		jsr	VBlank_Index(pc,d0.w)			; jump to VBlank routine and then return here

VBlank_Music:
		jsr	(UpdateMusic).l				; run sound driver to advance music

VBlank_Exit:
		addq.l	#1,(v_vblank_count).w			; increment VBlank counter
		movem.l	(sp)+,d0-a6				; restore all backed-up registers
		rte						; return from interrupt and resume normal operation

; ===========================================================================
; VBla_Index:
VBlank_Index:	dc.w VBlank_Lag-VBlank_Index			; $00 - (lag frame)
		dc.w VBlank_Sega-VBlank_Index			; $02 - Sega Screen
		dc.w VBlank_Title-VBlank_Index			; $04 - Title Screen, Credits, Try Again
		dc.w VBlank_Unused06-VBlank_Index		; $06 - (unused)
		dc.w VBlank_Levels-VBlank_Index			; $08 - Levels, Demos
		dc.w VBlank_SpecialStage-VBlank_Index		; $0A - Special Stages
		dc.w VBlank_TitleCards-VBlank_Index		; $0C - Title Cards
		dc.w VBlank_Unused0E-VBlank_Index		; $0E - (unused)
		dc.w VBlank_Paused-VBlank_Index			; $10 - Paused
		dc.w VBlank_PaletteFade-VBlank_Index		; $12 - Palette Fade
		dc.w VBlank_SegaPCM-VBlank_Index		; $14 - Sega Screen PCM
		dc.w VBlank_Continue-VBlank_Index		; $16 - Continue Screen, SS Finish
		dc.w VBlank_Ending-VBlank_Index			; $18 - Ending Sequence
; ===========================================================================

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 00 - Lag frame (VBlank occurred before call to WaitForVBlank)
; ---------------------------------------------------------------------------

; loc_B88: VBla_00:
VBlank_Lag:
		cmpi.b	#$80+id_Level,(v_gamemode).w		; is pre level sequence active?
		beq.s	.isLevel				; if not, just update sound driver and resume operation
		cmpi.b	#id_Level,(v_gamemode).w		; is game on a level?
		bne.w	VBlank_Music				; if not, just update sound driver and resume operation

.isLevel:
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.w	VBlank_Music				; if not, just update sound driver and resume operation

		; --- A lag frame has occurred while in Labyrinth Zone ---

		move.w	(vdp_control_port).l,d0			; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)

		; Same as in the opening block of the VBlank routine, this time during a lag frame.
		; This only happens if the level is LZ (note, Sonic 2/3/&K would change this so it runs in any level).
		btst	#6,(v_megadrive).w			; is Mega Drive PAL?
		beq.s	.paletteTransfer			; if not, branch
		move.w	#$700,d0				; set to waste a bunch of cycles
	.waitPAL:
		dbf	d0,.waitPAL				; loop until cycles have been wasted

.paletteTransfer:
		move.w	#1,(f_hblank_pal).w			; set HBlank flag
		stopZ80						; stop Z80 for CRAM transfers
		waitZ80						; wait until Z80 has stopped
		tst.b	(f_wtr_state).w				; is the screen completely underwater?
		bne.s	.waterAbove 				; if not, branch
		writeCRAM	v_palette,0			; write regular palette buffer to CRAM
		bra.s	.waterBelow				; skip over
	.waterAbove:
		writeCRAM	v_palette_water,0		; write water palette buffer to CRAM
	.waterBelow:
		move.w	(v_hblank_hreg).w,(a5)			; write HBlank trigger scan line for water palette swap to VDP
		startZ80					; restart Z80

		bra.w	VBlank_Music				; branch back to update sound driver and resume operation

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 02 - Sega Screen
; ---------------------------------------------------------------------------

; loc_C32: VBla_02:
VBlank_Sega:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		; fall-through...

; ---------------------------------------------------------------------------
; VBlank 14 - Sega Screen while the PCM sample is playing
; ---------------------------------------------------------------------------

; loc_C36: VBla_14:
VBlank_SegaPCM:
		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 04 - Title Screen, Level Select, Credits, "Try Again" screen
; ---------------------------------------------------------------------------

; loc_C44: VBla_04:
VBlank_Title:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		bsr.w	LoadTilesAsYouMove_BGOnly		; update background tiles as title screen scrolls
		bsr.w	ProcessPLC_9Tiles			; decompress up to 9 Nemesis-compressed tiles

		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 06 - Unused and unknown purpose
; ---------------------------------------------------------------------------

; loc_C5E: VBla_06:
VBlank_Unused06:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers...
		rts						; ...and nothing else

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 10 - While game is paused
; ---------------------------------------------------------------------------

; loc_C64: VBla_10:
VBlank_Paused:
		cmpi.b	#id_Special,(v_gamemode).w		; is game on special stage?
		beq.w	VBlank_SpecialStage			; if yes, branch
		; fall-through...

; ---------------------------------------------------------------------------
; VBlank 08 - Levels and Demos
; ---------------------------------------------------------------------------

; loc_C6E: VBla_08:
VBlank_Levels:
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM

		tst.b	(f_wtr_state).w				; is the screen completely underwater?
		bne.s	.waterAbove 				; if not, branch
		writeCRAM	v_palette,0			; write regular palette buffer to CRAM
		bra.s	.waterBelow				; skip over
	.waterAbove:
		writeCRAM	v_palette_water,0		; write water palette buffer to CRAM
	.waterBelow:
		move.w	(v_hblank_hreg).w,(a5)			; write HBlank trigger scan line for water palette swap to VDP

		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM

		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		startZ80					; restart Z80

		movem.l	(v_screenposx).w,d0-d7			; copy everything from v_screenposx to v_bg3screenposy...
		movem.l	d0-d7,(v_screenposx_dup).w		; ...to backup RAM (used in LoadTilesAsYouMove)
		movem.l	(v_fg_scroll_flags).w,d0-d1		; copy FG and BG scroll flags...
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w		; ...to backup RAM

		; The following code handles an awkward visual glitch for the LZ water surface.
		; If the surface is near the top of the screen (within 96 pixels), the VDP would not have
		; enough time to do all the transfers in VBlank_UpdateScreen before the palette needs to get
		; changed for the water. Without this special check, the water surface would violently flicker
		; whenever it's near the top of the screen. It's a rather dirty workaround, but it works.
		cmpi.b	#96,(v_hblank_line).w			; is LZ water surface within 96 pixels of the top of the screen?
		bhs.s	VBlank_UpdateScreen			; if not, do screen updates now
		move.b	#1,(f_doupdatesinhblank).w		; otherwise, we don't have enough time to do them now before HBlank hits, defer updates to then
		addq.l	#4,sp					; skip return address (i.e. postpone updating the sound driver as well)
		bra.w	VBlank_Exit				; go straight back to to the VBlank exit

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update various screen elements during interrupts.
; Also deducts the generic timer that controls the length of a Demo.
; ---------------------------------------------------------------------------

; Demo_Time: VBla_UpdateScreen:
VBlank_UpdateScreen:
		bsr.w	LoadTilesAsYouMove			; update level tiles while screen is moving
		jsr	(AnimateLevelGfx).l			; updated animated tiles
		jsr	(HUD_Update).l				; update HUD data
		bsr.w	ProcessPLC_3Tiles			; decompress up to 3 Nemesis-compressed tiles (instead of the usual 9)

		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts						; return
; End of function VBlank_UpdateScreen

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0A - Special Stages
; ---------------------------------------------------------------------------

; loc_DA6: VBla_0A:
VBlank_SpecialStage:
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM
		writeCRAM	v_palette,0			; write regular palette buffer to CRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		startZ80					; restart Z80

		bsr.w	PalCycle_SS				; advance special stage palette cycle and animate bird/fish graphics

		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0C - While title cards are displayed (Levels and SS Results)
; VBlank 18 - During the Ending Sequence
; ---------------------------------------------------------------------------

; loc_E72: VBla_0C: VBla_18:
VBlank_TitleCards:
VBlank_Ending:
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM

		tst.b	(f_wtr_state).w				; is the screen completely underwater?
		bne.s	.waterAbove 				; if not, branch
		writeCRAM	v_palette,0			; write regular palette buffer to CRAM
		bra.s	.waterBelow				; skip over
	.waterAbove:
		writeCRAM	v_palette_water,0		; write water palette buffer to CRAM
	.waterBelow:
		move.w	(v_hblank_hreg).w,(a5)			; write HBlank trigger scan line for water palette swap to VDP

		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM

		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		startZ80					; restart Z80

		movem.l	(v_screenposx).w,d0-d7			; copy everything from v_screenposx to v_bg3screenposy...
		movem.l	d0-d7,(v_screenposx_dup).w		; ...to backup RAM (used in LoadTilesAsYouMove)
		movem.l	(v_fg_scroll_flags).w,d0-d1		; copy FG and BG scroll flags...
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w		; ...to backup RAM

		bsr.w	LoadTilesAsYouMove			; update rendered
		jsr	(AnimateLevelGfx).l			; animate uncompressed level graphics (e.g. MZ lava)
		jsr	(HUD_Update).l				; update HUD numbers
		bsr.w	ProcessPLC_9Tiles			; decompress up to 9 Nemesis-compressed tiles
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0E - Unused (possibly once used as a lag frame counter?)
; ---------------------------------------------------------------------------

; loc_F8A: VBla_0E:
VBlank_Unused0E:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		addq.b	#1,(v_vblank_0e_counter).w		; increment some counter (unused besides this one write...)
		move.b	#id_VBlank_Unused0E,(v_vblank_routine).w ; set itself to land back here again if not further altered
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 12 - During palette fades
; ---------------------------------------------------------------------------

; loc_F9A: VBla_12:
VBlank_PaletteFade:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		move.w	(v_hblank_hreg).w,(a5)			; write HBlank trigger scan line for water palette swap to VDP
		bra.w	ProcessPLC_9Tiles			; decompress up to 9 Nemesis-compressed tiles

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 16 - Continue Screen and Special Stage finish loop
; ---------------------------------------------------------------------------

; loc_FA6: VBla_16:
VBlank_Continue:
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM

		writeCRAM	v_palette,0			; write regular palette buffer to CRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		startZ80					; restart Z80

		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform standard VRAM transfers (palette, sprites, H-scroll)
; ---------------------------------------------------------------------------

; sub_106E:
VBlank_StandardTransfers:
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM

		tst.b	(f_wtr_state).w				; is the screen completely underwater?
		bne.s	.waterAbove 				; if not, branch
		writeCRAM	v_palette,0			; write regular palette buffer to CRAM
		bra.s	.waterBelow				; skip over
	.waterAbove:
		writeCRAM	v_palette_water,0		; write water palette buffer to CRAM
	.waterBelow:

		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM

		startZ80					; restart Z80
		rts						; return
; End of function VBlank_StandardTransfers
; End of VBlank (as a whole)


; ===========================================================================
; ---------------------------------------------------------------------------
; Horizontal interrupt (exclusively used for the LZ water palette effect)
; ---------------------------------------------------------------------------

; PalToCRAM: <-- old misnomer
HBlank:
		disable_ints					; disable interrupts (VBlank in this context)
		tst.w	(f_hblank_pal).w			; is palette set to change?
		beq.s	.nochg					; if not, branch
		move.w	#0,(f_hblank_pal).w			; clear palette change flag

		movem.l	a0-a1,-(sp)				; backup a0 and a1 registers
		lea	(vdp_data_port).l,a1			; load VDP data port to a1
		lea	(v_palette_water).w,a0			; get water palette from RAM
		move.l	#$C0000000,4(a1)			; set VDP to CRAM write
		rept (4*$10)/2					; overwrite full palette (4 rows, 2 colors per move)
			move.l	(a0)+,(a1)			; move water palette to CRAM
		endr						; repeat at assembly time
		move.w	#vreg_hintrate|223,4(a1)			; reset horizontal interrupt counter
		movem.l	(sp)+,a0-a1				; restore a0 and a1

		tst.b	(f_doupdatesinhblank).w			; was frame update delayed by water surface being near the top of the screen?
		bne.s	.delayed_transfer			; if yes, resume transfer now

.nochg:
		rte						; return from horizontal interrupt and resume normal operation
; ===========================================================================

; loc_119E:
.delayed_transfer:
		clr.b	(f_doupdatesinhblank).w			; clear delayed updates flag
		movem.l	d0-a6,-(sp)				; backup all registers except stack pointer (a7)
		bsr.w	VBlank_UpdateScreen			; do all the screen updates that were skipped during VBlank now
		jsr	(UpdateMusic).l				; update the sound driver
		movem.l	(sp)+,d0-a6				; restore registers
		rte						; return from horizontal interrupt and resume normal operation
; End of function HBlank
