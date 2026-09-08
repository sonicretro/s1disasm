;  =========================================================================
; |           Sonic the Hedgehog Disassembly for Sega Mega Drive            |
;  =========================================================================
;
; Disassembly created by Hivebrain
; thanks to drx, Stealth and Esrael L.G. Neto
; ---------------------------------------------------------------------------
; NOTE:
; Set your editor's tab width to 8 characters wide for viewing this file.

; ===========================================================================
; ASSEMBLY OPTIONS:

Revision = 1
; 	| If 0, build the original version of the game, dubbed REV00
; 	| If 1, build the later version, dubbed REV01, which includes various bugfixes and enhancements
; 	| If 2, build the hacked version from Sonic Mega Collection, dubbed REVXB,
;	|       which (sloppily) fixes the infamous "spike bug" -- not recommended

FixBugs = 0
;	| If 1, enables various bugfixes across the game and sound driver
;	|       (see also the "_Fixed Binary Files" folder, and FixMusicAndSFXDataBugs)

CheatsEnabled = 0
;	| If 1, all in-game cheats (Level Select, Debug Mode, Slow-Motion, Japanese Credits)
;	|       will be enabled by default, without requiring any title screen button inputs

AllOptimizations = 0
;	| If 1, enables all optimizations
SkipChecksumCheck = 0|AllOptimizations
;	| If 1, disables the slow bootup checksum calculation
ZeroOffsetOptimization = 0|AllOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
PaddingOptimization = 0|AllOptimizations
;	| If 1, removes about 3 KB of various superfluous padding
UnusedOptimization = 0|AllOptimizations
;	| If 1, removes dead code and unused data and optimizes tables with unused entries.

EnableSRAM = 0
;	| If 1, enable SRAM support
BackupSRAM = 1
;	| 0 = no saving (read-only SRAM); 1 = allow saving
AddressSRAM = 3
;	| 0 = odd+even; 2 = even only; 3 = odd only
;	| (odd only is the most common setting)

ZoneCount = 6
;	| Used for the "zonewarning" macro. Do not change, unless more zones get added.
;	| Discrete zones are: GHZ, LZ, MZ, SLZ, SYZ, and SBZ

; ===========================================================================
; AS-specific macros and assembler settings
	cpu 68000
	include "MacroSetup.asm"

; ===========================================================================
; Simplifying macros and functions
	include	"Macros.asm"

; ===========================================================================
; Equates section - Names for constants
	include	"_Constants.asm"

; ===========================================================================
; Equates section - Names for variables
	include	"_Variables.asm"

; ===========================================================================
; Expressing sprite mappings and DPLCs in a portable and human-readable form
SonicMappingsVer = 1
SonicDplcVer = 1
	include	"_maps/_MapMacros.asm"

; ===========================================================================
; start of ROM

StartOfRom:
	if * <> 0
		fatal "StartOfRom was $\{*} but it should be 0"
	endif

Vectors:
		dc.l v_systemstack&$FFFFFF			; Initial stack pointer value
		dc.l EntryPoint					; Start of program
		dc.l BusError					; Bus error
		dc.l AddressError				; Address error (4)
		dc.l IllegalInstr				; Illegal instruction
		dc.l ZeroDivide					; Division by zero
		dc.l ChkInstr					; CHK exception
		dc.l TrapvInstr					; TRAPV exception (8)
		dc.l PrivilegeViol				; Privilege violation
		dc.l Trace					; TRACE exception
		dc.l Line1010Emu				; Line-A emulator
		dc.l Line1111Emu				; Line-F emulator (12)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved) (16)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved) (20)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved) (24)
		dc.l ErrorExcept				; Spurious exception
		dc.l ErrorTrap					; IRQ level 1
		dc.l ErrorTrap					; IRQ level 2
		dc.l ErrorTrap					; IRQ level 3 (28)
		dc.l HBlank					; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap					; IRQ level 5
		dc.l VBlank					; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap					; IRQ level 7 (32)
		dc.l ErrorTrap					; TRAP #00 exception
		dc.l ErrorTrap					; TRAP #01 exception
		dc.l ErrorTrap					; TRAP #02 exception
		dc.l ErrorTrap					; TRAP #03 exception (36)
		dc.l ErrorTrap					; TRAP #04 exception
		dc.l ErrorTrap					; TRAP #05 exception
		dc.l ErrorTrap					; TRAP #06 exception
		dc.l ErrorTrap					; TRAP #07 exception (40)
		dc.l ErrorTrap					; TRAP #08 exception
		dc.l ErrorTrap					; TRAP #09 exception
		dc.l ErrorTrap					; TRAP #10 exception
		dc.l ErrorTrap					; TRAP #11 exception (44)
		dc.l ErrorTrap					; TRAP #12 exception
		dc.l ErrorTrap					; TRAP #13 exception
		dc.l ErrorTrap					; TRAP #14 exception
		dc.l ErrorTrap					; TRAP #15 exception (48)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
	if Revision<>2|FixBugs
		if (Revision=2)&(FixBugs=1)&(MOMPASS=1)
			warning "'Revision = 2' is unnecessary with 'FixBugs' enabled (use 'Revision = 1' instead)."
		endif
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
	else
		; loc_E0:
	Rev02_SpikeBugFix:
		; Relocated code from Spik_Hurt. REVXB was a nasty hex-edit.
		; See _incObj/36 Spikes.asm for more info.
		move.l	obY(a0),d3				; get Sonic's Y-position (with subpixels)
		move.w	obVelY(a0),d0				; get Sonic's Y-velocity
		ext.l	d0					; extend velocity to longword
		asl.l	#8,d0					; shift velocity to upper word (16.16 fixed point)
		jmp	(Rev02_SpikeBugFix_Return).l		; return to main spikes logic
		dc.w ErrorTrap					; Unused (reserved)
	endif
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)

		dc.b "SEGA MEGA DRIVE "				; Hardware system ID (Console name)
		dc.b "(C)SEGA 1991.APR"				; Copyright holder and release date (generally year)
	rept 2
		 ; Name (identical for domestic and overseas version)
		dc.b "SONIC THE               HEDGEHOG                "
	endr

	if Revision=0
		dc.b "GM 00001009-00"				; Serial/version number (Rev 0)
	else
		dc.b "GM 00004049-01"				; Serial/version number (Rev non-0)
	endif

Checksum:		; Checksum is hardcoded to make it easier to check for ROM correctness
	if Revision=0
		dc.w $264A
	else
		dc.w $AFC7
	endif

		dc.b "J               "				; I/O support
		dc.l StartOfRom					; Start address of ROM
RomEndLoc:	dc.l EndOfRom-1					; End address of ROM
		dc.l $FF0000					; Start address of RAM
		dc.l $FFFFFF					; End address of RAM
	if EnableSRAM=1
		dc.b "RA", $A0+(BackupSRAM<<6)+(AddressSRAM<<3), $20 ; SRAM support
		dc.l sram_start					; SRAM start
		dc.l sram_end-1					; SRAM end
	else
		dc.b "    "
		dc.b "    "
		dc.b "    "
	endif
		dc.b "            "				; Modem support
		dc.b "                                        " ; Notes (unused, anything can be put in this space, but it has to be 40 bytes)
		dc.b "JUE             "				; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too
ErrorTrap:
		nop						; no operation
		nop						; ''
		bra.s	ErrorTrap				; loop forever
; ===========================================================================

; ---------------------------------------------------------------------------
; Entry point for the game on boot or soft-reset
; (This section from a standard Mega Drive devkit library)
; ---------------------------------------------------------------------------

EntryPoint:
		tst.l	(port_1_control_hi).l			; test port A & B control registers
		bne.s	PortA_Ok				; if either of them are already initialized, branch
		tst.w	(expansion_control_hi).l		; test port C control register
PortA_Ok:	bne.s	SkipSetup				; if any port was already initialized, skip the VDP and Z80 setup code (this is a soft-reset)

		lea	SetupValues(pc),a5			; load setup values array address
		movem.w	(a5)+,d5-d7				; d5 = VDP register start number; d6 = size of RAM/4; d7 = VDP register diff
		movem.l	(a5)+,a0-a4				; a0 = start of Z80 RAM; a1 = Z80 bus request; a2 = Z80 reset; a3 = VDP data; a4 = VDP control

		move.b	-$10FF(a1),d0				; get hardware version (from $A10001)
		andi.b	#$F,d0					; only look at Mega Drive version
		beq.s	SkipSecurity				; if the console has no TMSS, skip the security stuff
		move.l	#'SEGA',$2F00(a1)			; write "SEGA" to TMSS security register ($A14000)

SkipSecurity:
		move.w	(a4),d0					; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		moveq	#0,d0					; clear d0
		movea.l	d0,a6					; clear a6
		move.l	a6,usp					; set usp to $0

		moveq	#SetupValues_VDP_End-SetupValues_VDP-1,d1 ; write to all VDP registers
VDPInitLoop:	move.b	(a5)+,d5				; add $8000 to value
		move.w	d5,(a4)					; write value to VDP register
		add.w	d7,d5					; next register
		dbf	d1,VDPInitLoop				; loop until all registers are set up

		move.l	(a5)+,(a4)				; write DMA destination to VDP (VRAM 0000)
		move.w	d0,(a3)					; set DMA fill value to 00 (DMA starts here, clears entire VRAM)

		move.w	d7,(a1)					; stop the Z80
		move.w	d7,(a2)					; reset the Z80
WaitForZ80:	btst	d0,(a1)					; has the Z80 stopped?
		bne.s	WaitForZ80				; if not, loop until it has

		moveq	#SetupValues_Z80_End-SetupValues_Z80-1,d2 ; write all Z80 boot code
Z80InitLoop:	move.b	(a5)+,(a0)+				; write boot code to Z80 RAM
		dbf	d2,Z80InitLoop				; loop until all boot code has been written

		move.w	d0,(a2)					; set Z80 reset on
		move.w	d0,(a1)					; set Z80 stop off
		move.w	d7,(a2)					; set Z80 reset off

ClrRAMLoop:	move.l	d0,-(a6)				; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop				; repeat until the entire RAM is cleared

		move.l	(a5)+,(a4)				; set VDP display mode and increment mode

		move.l	(a5)+,(a4)				; set VDP to CRAM write
		moveq	#(v_palette_end-v_palette)/4-1,d3	; set repeat times to cover full CRAM
ClrCRAMLoop:	move.l	d0,(a3)					; clear 2 colors
		dbf	d3,ClrCRAMLoop				; repeat until the entire CRAM is clear

		move.l	(a5)+,(a4)				; set VDP to VSRAM write
		moveq	#$14-1,d4
ClrVSRAMLoop:	move.l	d0,(a3)					; clear 4 bytes of VSRAM
		dbf	d4,ClrVSRAMLoop				; repeat until the entire VSRAM is clear

		moveq	#SetupValues_PSG_End-SetupValues_PSG-1,d5 ; write to all PSG registers
PSGInitLoop:	move.b	(a5)+,$11(a3)				; write PSG volume values to PSG port ($C00011)
		dbf	d5,PSGInitLoop				; repeat for all channels

		move.w	d0,(a2)					; set Z80 reset on
		movem.l	(a6),d0-a6				; clear all registers
		disable_ints					; disable interrupts

SkipSetup:
		bra.s	GameProgram				; begin actual game
; ===========================================================================

SetupValues:	dc.w vreg_mode1					; VDP register start number
		dc.w (v_ram_end-v_ram_start_def/4)-1		; size of RAM/4 ($3FFF)
		dc.w $100					; VDP register diff

		dc.l z80_ram					; start of Z80 RAM
		dc.l z80_bus_request				; Z80 bus request
		dc.l z80_reset					; Z80 reset
		dc.l vdp_data_port				; VDP data
		dc.l vdp_control_port				; VDP control

	SetupValues_VDP:
		; Note that most of these are immediately overwritten again in VDPSetupArray
		dc.b %000100					; VDP $80 - 8-colour mode
		dc.b %00010100					; VDP $81 - Mega Drive mode, DMA enable
		dc.b ($C000>>10)				; VDP $82 - foreground nametable address
		dc.b ($F000>>10)				; VDP $83 - window nametable address
		dc.b ($E000>>13)				; VDP $84 - background nametable address
		dc.b ($D800>>9)					; VDP $85 - sprite table address
		dc.b 0						; VDP $86 - unused
		dc.b 0<<4|0					; VDP $87 - background colour
		dc.b 0						; VDP $88 - unused
		dc.b 0						; VDP $89 - unused
		dc.b 255					; VDP $8A - HBlank register
		dc.b %0000					; VDP $8B - full screen scroll
		dc.b %10000001					; VDP $8C - 40 cell display
		dc.b ($DC00>>10)				; VDP $8D - h-scroll table address
		dc.b 0						; VDP $8E - unused
		dc.b 1						; VDP $8F - VDP increment
		dc.b %000001					; VDP $90 - 64 cell h-scroll size
		dc.b 0						; VDP $91 - window h position
		dc.b 0						; VDP $92 - window v position
		dc.w $FFFF					; VDP $93/94 - DMA length
		dc.w $0000					; VDP $95/96 - DMA source
		dc.b $80					; VDP $97 - DMA fill VRAM
	SetupValues_VDP_End:
		dc.l $40000080					; DMA fill destination (VRAM 0000)

	SetupValues_Z80:
		; Z80 instructions (not the sound driver; that gets loaded later)
		save
		CPU Z80						; start assembling Z80 code
		phase 0						; pretend we're at address 0

		xor	a					; clear a to 0
		ld	bc,((z80_ram_end-z80_ram)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
		ld	de,zStartupCodeEndLoc+1			; initial destination address
		ld	hl,zStartupCodeEndLoc			; initial source address
		ld	sp,hl					; set the address the stack starts at
		ld	(hl),a					; set first byte of the stack to 0
		ldir						; loop to fill the stack (entire remaining available Z80 RAM) with 0
		pop	ix					; clear ix
		pop	iy					; clear iy
		ld	i,a					; clear i
		ld	r,a					; clear r
		pop	de					; clear de
		pop	hl					; clear hl
		pop	af					; clear af
		ex	af,af'					; swap af with af'
		exx						; swap bc/de/hl with their shadow registers too
		pop	bc					; clear bc
		pop	de					; clear de
		pop	hl					; clear hl
		pop	af					; clear af
		ld	sp,hl					; clear sp
		di						; clear iff1 (for interrupt handler)
		im	1					; interrupt handling mode = 1
		ld	(hl),0E9h				; replace the first instruction with a jump to itself
		jp	(hl)	 				; jump to the first instruction (to stay there forever)
	zStartupCodeEndLoc:
		dephase						; stop pretending
		restore
		padding off					; unfortunately our flags got reset so we have to set them again...
	SetupValues_Z80_End:

		dc.w vreg_mode2|%00000100			; VDP display mode
		dc.w vreg_autoinc|2				; VDP increment
		dc.l $C0000000					; CRAM write mode
		dc.l $40000010					; VSRAM address 0

	SetupValues_PSG:
		dc.b $9F, $BF, $DF, $FF				; values for PSG channel volumes
	SetupValues_PSG_End:
; End of SetupValues


; ===========================================================================
; ---------------------------------------------------------------------------
; Proper game entry point for Sonic the Hedgehog after initialization
; ---------------------------------------------------------------------------

GameProgram:
		tst.w	(vdp_control_port).l			; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		btst	#6,(expansion_control).l		; has port C been initialized?
		beq.s	CheckSumCheck				; if not, branch
		cmpi.l	#'init',(v_init).w			; has checksum routine already run?
		beq.w	GameInit				; if yes, branch

CheckSumCheck:
	if SkipChecksumCheck=0
		movea.l	#EndOfHeader,a0				; start checking bytes after the header ($200)
		movea.l	#RomEndLoc,a1				; stop at end of ROM
		move.l	(a1),d0					; retrieve long of ROM end
		moveq	#0,d1					; clear d1
	.loop:	add.w	(a0)+,d1				; add next byte value of ROM word
		cmp.l	a0,d0					; has iterator reached end of ROM?
		bhs.s	.loop					; if not, loop until so

		movea.l	#Checksum,a1				; read the checksum
		cmp.w	(a1),d1					; compare calculated value with checksum in ROM header
		bne.w	CheckSumError				; if they don't match, a checksum error has occurred
	endif

CheckSumOk:
		lea	(v_crossresetram).w,a6			; load cross-reset RAM location
		moveq	#0,d7					; overwrite with 0
		move.w	#(v_ram_end-v_crossresetram)/4-1,d6	; write to all of cross-reset RAM ($FE00-$FFFF)
.clearRAM:	move.l	d7,(a6)+				; clear RAM
		dbf	d6,.clearRAM				; loop until done

		move.b	(console_version).l,d0			; get hardware information from console
		andi.b	#%11000000,d0				; filter to only overseas flag and PAL flag
		move.b	d0,(v_megadrive).w			; store region settings

		move.l	#'init',(v_init).w			; set flag so checksum won't run again

GameInit:
		lea	(v_ram_start).l,a6			; load start location of RAM
		moveq	#0,d7					; overwrite with 0
		move.w	#(v_crossresetram-v_ram_start_def)/4-1,d6 ; write to all of RAM except cross-reset RAM ($0000-$FDFF)
.clearRAM:	move.l	d7,(a6)+				; clear RAM
		dbf	d6,.clearRAM				; loop until done

		bsr.w	VDPSetupGame				; initialize (proper) VDP registers
		bsr.w	DACDriverLoad				; initialize Z80 DAC driver
		bsr.w	JoypadInit				; initialize controller ports
		move.b	#id_Sega,(v_gamemode).w			; set first Game Mode to Sega Screen

	if CheatsEnabled=1
		moveq	#1,d0					; enable all cheats by default
		move.b	d0,(f_levselcheat).w			; enable level select cheat
		move.b	d0,(f_slomocheat).w			; enable slow-motion cheat
		move.b	d0,(f_debugcheat).w			; enable debug mode cheat
		move.b	d0,(f_creditscheat).w			; enable hidden Japanese credits cheat
	endif

MainGameLoop:
		move.b	(v_gamemode).w,d0			; load Game Mode
		andi.w	#$1C,d0					; limit Game Mode value to $1C max (change to a maximum of 7C to add more game modes)
		jsr	GameModeArray(pc,d0.w)			; jump to apt location in ROM
		bra.s	MainGameLoop				; loop indefinitely

; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------

GameModeArray:

gmptr:		macro gamemode,{INTLABEL}
__LABEL__:	label	*-GameModeArray
		bra.w	gamemode
		endm

id_Sega:	gmptr	GM_Sega					; Sega Screen ($00)
id_Title:	gmptr	GM_Title				; Title Screen ($04)
id_Demo:	gmptr	GM_Level				; Demo Mode ($08)
id_Level:	gmptr	GM_Level				; Normal Level ($0C)
id_Special:	gmptr	GM_Special				; Special Stage ($10)
id_Continue:	gmptr	GM_Continue				; Continue Screen ($14)
id_Ending:	gmptr	GM_Ending				; End of game sequence ($18)
id_Credits:	gmptr	GM_Credits				; Credits ($1C)

		rts						; redundant rts

; ===========================================================================
; >>> Error handler
	include	"_inc/Error Handler.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed art text for debug mode, level select, and errors
; (formerly "menutext.bin")
; ---------------------------------------------------------------------------

Art_Text:	bincludeEndMarker	"artunc/Level Select & Debug Text.unc"

; ===========================================================================
; >>> Interrupts exceptions and subroutines
	include	"_inc/Interrupts.asm"

; ===========================================================================
; >>> Joypad handling subroutines
	include	"_inc/Joypads.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup the VDP with values used for the game itself
; ---------------------------------------------------------------------------

VDPSetupGame:
		lea	(vdp_control_port).l,a0			; load VDP control port
		lea	(vdp_data_port).l,a1			; load VDP data port
		lea	(VDPSetupArray).l,a2			; load address of register values
		moveq	#(VDPSetupArray_End-VDPSetupArray)/2-1,d7 ; set repeat times
.setreg:
		move.w	(a2)+,(a0)				; save register value to VDP
		dbf	d7,.setreg				; repeat until all register values have been sent

		move.w	(VDPSetupArray+2).l,d0			; get second entry of VDPSetupArray
		move.w	d0,(v_vdp_buffer1).w			; buffer register $81 (used for enabling/disabling display)

		move.w	#vreg_hintrate|223,(v_hblank_hreg).w		; HBlank every 224th scanline

		moveq	#cBlack,d0				; set d0 to 0 (black)
		move.l	#$C0000000,(vdp_control_port).l		; set VDP to CRAM write
		move.w	#($80)/2-1,d7				; set repeat times to cover full CRAM
.clrCRAM:
		move.w	d0,(a1)					; clear colours
		dbf	d7,.clrCRAM				; repeat until the entire palette is clear (black)

		clr.l	(v_scrposy_vdp).w			; clear single vertical scroll buffer
		clr.l	(v_scrposx_vdp).w			; clear single horizontal scroll buffer
		move.l	d1,-(sp)				; store d1 data in the stack for now
		fillVRAM 0,0,$10000				; clear the entirety of VRAM
		move.l	(sp)+,d1				; reload d1 data back out of the stack
		rts						; return
; End of function VDPSetupGame

; ---------------------------------------------------------------------------
; VDP register settings to use for the game. Do note that a handful of these
; are getting rewritten for every game mode change, though the majority
; will stay at their initial settings defined in this array.
; ---------------------------------------------------------------------------
; See here for details on VDP registers:
; https://segaretro.org/Sega_Mega_Drive/VDP_registers
; ---------------------------------------------------------------------------

VDPSetupArray:
		dc.w vreg_mode1|%000100				; 8-color mode
		dc.w vreg_mode2|%00110100			; vertical interrupts, DMA, Mega Drive display
		dc.w vreg_fgvram|(vram_fg>>10)			; foreground nametable address
		dc.w vreg_winvram|(vram_win>>10)		; window nametable address
		dc.w vreg_bgvram|(vram_bg>>13)			; background nametable address
		dc.w vreg_spritevram|(vram_sprites>>9)		; sprite table address
		dc.w $8600					; (unused, only relevant for 128KB VRAM mode)
		dc.w vreg_bgcolor|0<<4|0			; background colour (palette line 0, entry 0)
		dc.w $8800					; (unused, only relevant for Master System)
		dc.w $8900					; (unused, only relevant for Master System)
		dc.w vreg_hintrate|$00				; horizontal interrupt register
		dc.w vreg_mode3|%0000				; full-screen vertical scrolling
		dc.w vreg_mode4|%10000001			; 40-cell display mode
		dc.w vreg_hscrollvram|(vram_hscroll>>10)	; background H-scroll address
		dc.w $8E00					; (unused, only relevant for 128KB VRAM mode)
		dc.w vreg_autoinc|2				; VDP auto-increment size (2)
		dc.w vreg_planesize|%000001			; 64-cell H-scroll size
		dc.w vreg_winxpos|0				; window horizontal position
		dc.w vreg_winypos|0				; window vertical position
VDPSetupArray_End:


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to clear the screen (plane mappings, sprites, and scroll data)
; ---------------------------------------------------------------------------

ClearScreen:
		fillVRAM 0, vram_fg, vram_fg+plane_size_64x32	; clear foreground namespace
		fillVRAM 0, vram_bg, vram_bg+plane_size_64x32	; clear background namespace

	if Revision=0
		move.l	#0,(v_scrposy_vdp).w			; clear single vertical scroll buffer
		move.l	#0,(v_scrposx_vdp).w			; clear single horizontal scroll buffer
	else
		; REV01 changed this from moving 0 to clears, but functionally identical
		clr.l	(v_scrposy_vdp).w			; clear single vertical scroll buffer
		clr.l	(v_scrposx_vdp).w			; clear single horizontal scroll buffer
	endif

	if FixBugs
		clearRAM v_spritetablebuffer,v_spritetablebuffer_end ; clear sprite table buffer
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded ; clear H-Scroll table buffer
	else
		; Both of these clear loops clear one more longwords than they should.
		; This will clear the first 4 bytes of v_palette_water and v_objspace, respectively.
		clearRAM v_spritetablebuffer,v_spritetablebuffer_end+4 ; clear sprite table buffer
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded+4 ; clear H-Scroll table buffer
	endif

		rts						; return
; End of function ClearScreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load the DAC driver
; ---------------------------------------------------------------------------

; SoundDriverLoad: <-- old misnomer
DACDriverLoad:
		nop						; delay
		stopZ80						; request Z80 stop on
		deassertZ80Reset				; request Z80 reset off
		lea	(DACDriver).l,a0			; load compressed DAC driver address as source
		lea	(z80_ram).l,a1				; set Z80 RAM address as target
		bsr.w	KosDec					; decompress the DAC driver into Z80 RAM
		assertZ80Reset					; request Z80 reset on
		nop						; delay (while the Z80 resets)
		nop						; ''
		nop						; ''
		nop						; ''
		deassertZ80Reset				; request Z80 reset off
		startZ80					; request Z80 stop off
		rts						; return
; End of function DACDriverLoad

; ===========================================================================
; >>> Subroutines to queue sound commands to be executed by the sound driver during VBlank
	; includes QueueSound1, QueueSound2, QueueSound3
	; (formerly called PlaySound, PlaySound_Special, PlaySound_Unknown)
	include	"_inc/Queue Sound Routines.asm"


; ===========================================================================
; >>> Subroutine to allow pausing the game
	include	"_inc/PauseGame.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to copy a tile map from RAM to VRAM namespace

; input:
;	a1 = tile map address
;	d0 = VRAM address
;	d1 = width (cells)
;	d2 = height (cells)
; ---------------------------------------------------------------------------

TilemapToVRAM:
		lea	(vdp_data_port).l,a6			; load VDP data port address
		move.l	#$800000,d4				; prepare plane width size for VDP address advancing (row)

Tilemap_Line:
		move.l	d0,4(a6)				; set the VDP the VRAM write mode with address
		move.w	d1,d3					; load width of rectangle

Tilemap_Cell:
		move.w	(a1)+,(a6)				; copy tile map to VRAM plane space
		dbf	d3,Tilemap_Cell				; repeat for the entire width
		add.l	d4,d0					; advance VDP value address to the next row
		dbf	d2,Tilemap_Line				; repeat for the entire height
		rts						; return
; End of function TilemapToVRAM

; ===========================================================================
; >>> Decompression algorithms
	include	"_inc/Decompression.asm"

; ===========================================================================
; >>> Palette logic routines
	include	"_inc/Palette.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to wait for VBlank routines to complete
; ---------------------------------------------------------------------------

; DelayProgram: <-- old misnomer
; WaitForVBla: <-- old name
WaitForVBlank:
		enable_ints					; enable interrupts so vertical interrupts can occur

.wait:
		tst.b	(v_vblank_routine).w			; has VBlank routine finished?
		bne.s	.wait					; if not, loop until it has
		rts						; resume normal operation
; End of function WaitForVBlank

; ===========================================================================
; >>> Subroutines for generic calculations
	include	"_inc/Math.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

; SegaScreen:
GM_Sega:
		; fading out from previous game mode
		move.b	#bgm_Stop,d0				; set stop music command
		bsr.w	QueueSound2				; stop music
		bsr.w	ClearPLC				; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut				; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_bgcolor|0<<4|0,(a6)		; set background colour (palette entry 0)
		move.w	#vreg_mode3|%0000,(a6)			; full-screen vertical scrolling
		clr.b	(f_wtr_state).w				; clear water state

		disable_ints					; disable interrupts
		disable_display					; disable screen output
		bsr.w	ClearScreen				; wipe the screen

		locVRAM	ArtTile_Sega_Tiles*tile_size		; set target VRAM location for Sega logo patterns
		lea	(Nem_SegaLogo).l,a0			; load Sega logo patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		lea	(v_ram_start).l,a1			; set start of RAM to be used as decompression buffer
		lea	(Eni_SegaLogo).l,a0			; load Sega logo mappings
		move.w	#ArtTile_Sega_Tiles,d0			; set art tile for Sega screen mappings
		bsr.w	EniDec					; decompress Enigma-compressed mappings to RAM buffer
		copyTilemap v_ram_start,vram_bg+$510,24,8	; transfer decompressed patterns to VRAM (BG plane, light scanning effect)
		copyTilemap v_ram_start+24*8*2,vram_fg,40,28	; transfer decompressed patterns to VRAM (FG plane, Sega logo cutout)

	if Revision<>0
		tst.b	(v_megadrive).w				; is console Japanese?
		bmi.s	.loadpal				; if not, branch
		copyTilemap v_ram_start+$A40,vram_fg+$53A,3,2	; hide "TM" with a white rectangle
.loadpal:
	endif

		moveq	#palid_SegaBG,d0			; load Sega screen palette...
		bsr.w	PalLoad					; ...directly to active palette (not fade-in buffer)
		move.w	#-$A,(v_pcyc_num).w			; light scanning palette cycle effect start offset
		move.w	#0,(v_pcyc_time).w			; clear palette fade-in counter
	if UnusedOptimization=0
		move.w	#0,(v_pal_buffer+$12).w			; clear some palcycle buffer (unused?)
		move.w	#0,(v_pal_buffer+$10).w			; clear some palcycle buffer (unused?)
	endif
		enable_display					; enable screen output
; ---------------------------------------------------------------------------

Sega_WaitPal:		; while light scanning effect is active
		move.b	#id_VBlank_Sega,(v_vblank_routine).w	; set VBlank routine to $02
		bsr.w	WaitForVBlank				; wait for VBlank to finish
		bsr.w	PalCycle_Sega				; advance light scanning palette cycle effect
		bne.s	Sega_WaitPal				; loop until it's finished
; ---------------------------------------------------------------------------

		; while "SEGA" sound is playing
		move.b	#sfx_Sega,d0				; set "SEGA" sound
		bsr.w	QueueSound2				; queue it
		move.b	#id_VBlank_SegaPCM,(v_vblank_routine).w	; set VBlank routine to $14
		bsr.w	WaitForVBlank				; wait for VBlank to play the sound (CPU is frozen here until sound finished playing)
; ---------------------------------------------------------------------------

		; after sound has finished playing
		move.w	#30,(v_generictimer).w			; wait 30 frames before automatic fade-out

Sega_WaitEnd:
		move.b	#id_VBlank_Sega,(v_vblank_routine).w	; set VBlank routine to $02
		bsr.w	WaitForVBlank				; wait for VBlank to finish
		tst.w	(v_generictimer).w			; has post-chant timer expired?
		beq.s	Sega_GotoTitle				; if yes, go to title screen
		andi.b	#btnStart,(v_jpadpress1).w		; is Start button pressed?
		beq.s	Sega_WaitEnd				; if not, loop post-chant routine
; ---------------------------------------------------------------------------

Sega_GotoTitle:		; transition to title screen
		move.b	#id_Title,(v_gamemode).w		; go to title screen
		rts						; return to MainGameLoop
; End of function GM_Sega


; ===========================================================================
; ---------------------------------------------------------------------------
; Title screen
; ---------------------------------------------------------------------------

; TitleScreen:
GM_Title:		; fading out from previous game mode
		move.b	#bgm_Stop,d0				; set stop music command
		bsr.w	QueueSound2				; stop music
		bsr.w	ClearPLC				; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut				; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading "SONIC TEAM PRESENTS" (STP) patterns
		disable_ints					; disable ints while accessing the VDP
		bsr.w	DACDriverLoad				; load Z80 driver
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_planesize|%000001,(a6)		; 64-cell hscroll size
		move.w	#vreg_winypos|0,(a6)			; window vertical position
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_bgcolor|2<<4|0,(a6)		; set background colour (palette line 2, entry 0)
		clr.b	(f_wtr_state).w				; clear water state
		bsr.w	ClearScreen				; wipe the screen
		clearRAM v_objspace				; clear object RAM

		locVRAM	ArtTile_Title_Japanese_Text*tile_size	; set target VRAM location for hidden Japanese credits
		lea	(Nem_JapNames).l,a0			; load hidden Japanese credits
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Sonic_Team_Font*tile_size	; set target VRAM location for "SONIC TEAM PRESENTS" font
		lea	(Nem_CreditText).l,a0			; load STP font (same as the credits font)
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		lea	(v_ram_start).l,a1			; set start of RAM to be used as decompression buffer
		lea	(Eni_JapNames).l,a0			; load mappings for hidden Japanese credits
	if FixBugs
		move.w	#ArtTile_Title_Japanese_Text|Tile_Pal3,d0 ; set art tile for hidden Japanese credits (cyan)
	else
		; The hidden Japanese credits cheat in Object 8A sets the text color to cyan on palette line 3,
		; but this part makes the text continue using palette line 1, rendering them black instead.
		move.w	#ArtTile_Title_Japanese_Text|Tile_Pal1,d0 ; set art tile for hidden Japanese credits (black)
	endif
		bsr.w	EniDec					; decompress Enigma-compressed mappings to RAM buffer
		copyTilemap v_ram_start,vram_fg,40,28		; transfer decompressed patterns from RAM buffer to VRAM

		clearRAM v_palette_fading			; set palette fade-in buffer to all-black
		moveq	#palid_Sonic,d0				; load Sonic's palette...
		bsr.w	PalLoad_Fade				; ...into fade-in buffer
		move.b	#id_CreditsText,(v_sonicteam).w		; load "SONIC TEAM PRESENTS" object
		jsr	(ExecuteObjects).l			; execute objects to load STP object
		jsr	(BuildSprites).l			; build sprites for the STP object
		bsr.w	PaletteFadeIn				; fade-in STP screen
; ---------------------------------------------------------------------------

		; load main title screen patterns while "SONIC TEAM PRESENTS" screen is shown
		disable_ints					; display is frozen during the STP screen

		locVRAM	ArtTile_Title_Foreground*tile_size	; set target VRAM location title screen foreground emblem
		lea	(Nem_TitleFg).l,a0			; load title screen foreground emblem patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Title_Sonic*tile_size		; set target VRAM location big Sonic object
		lea	(Nem_TitleSonic).l,a0			; load big Sonic title screen patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Title_Trademark*tile_size	; set target VRAM location for "TM" patterns
		lea	(Nem_TitleTM).l,a0			; load "TM" patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		lea	(vdp_data_port).l,a6			; load VDP data transfer port
		locVRAM	ArtTile_Level_Select_Font*tile_size,4(a6) ; set target VRAM location for level select font
		lea	(Art_Text).l,a5				; load uncompressed level select font
		move.w	#(Art_Text_end-Art_Text)/2-1,d1		; set loop count for level select
Tit_LoadText:
		move.w	(a5)+,(a6)				; write one row of the level select font to VRAM
		dbf	d1,Tit_LoadText				; loop until it's fully loaded

		move.b	#0,(v_lastlamp).w			; clear lamppost counter
		move.w	#0,(v_debuguse).w			; exit debug mode if necessary
		move.w	#0,(f_demo).w				; disable demo mode
	if UnusedOptimization=0
		move.w	#0,(v_unused2).w			; unused variable
	endif
		move.w	#id_GHZ_act1,(v_zone_act).w		; set level to GHZ1 (000)
		move.w	#0,(v_pcyc_time).w			; disable palette cycling
		bsr.w	LevelSizeLoad				; load level size (will use GHZ1's sizes)
		bsr.w	DeformLayers				; initialize background deformation before fade-in (redundant here)

		lea	(v_16x16).w,a1				; set target buffer for blocks mappings
		lea	(Blk16_GHZ).l,a0			; load GHZ 16x16 blocks mappings
		move.w	#ArtTile_Level,d0			; set to target VRAM address $0000
		bsr.w	EniDec					; decompress Enigma-compressed blocks mappings to buffer

		lea	(Blk256_GHZ).l,a0			; load GHZ 256x256 mappings
		lea	(v_256x256).l,a1			; set target buffer for chunks mappings
		bsr.w	KosDec					; decompress Kosinski-compressed chunks mappings to buffer

		bsr.w	LevelLayoutLoad				; load level layout for the background
		bsr.w	PaletteFadeOut				; fade-out "SONIC TEAM PRESENTS" screen
; ---------------------------------------------------------------------------

		; "SONIC TEAM PRESENTS" screen has faded out, load remaining patterns and fade in
		disable_ints					; disable interrupts again after the fade-out
		bsr.w	ClearScreen				; wipe screen

		lea	(vdp_control_port).l,a5			; set VDP control port
		lea	(vdp_data_port).l,a6			; set VDP data port
		lea	(v_bgscreenposx).w,a3			; get current background X position
		lea	(v_lvllayout_bg).w,a4			; get location in level layout RAM where background is stored
		move.w	#$4000+(vram_bg-vram_fg),d2		; =$6000 (VRAM write command $4000 + nametable start address relative to vram_fg)
		bsr.w	DrawChunks				; draw initial background layer

		lea	(v_ram_start).l,a1			; set start of RAM to be used as decompression buffer (this overwrites unused chunk RAM)
		lea	(Eni_Title).l,a0			; load title screen emblem mappings
		move.w	#ArtTile_Level,d0			; =$0000 (emblem mappings are themselves set up with a +$2000 offset per tile)
		bsr.w	EniDec					; decompress Enigma-compressed emblem mappings to buffer
	if FixBugs
		; Fix title screen position
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Title_Screen_position_in_Sonic_1
		copyTilemap v_ram_start,vram_fg+$208,34,22	; transfer decompressed patterns from RAM buffer to VRAM (correctly centered)
	else
		copyTilemap v_ram_start,vram_fg+$206,34,22	; transfer decompressed patterns from RAM buffer to VRAM (off-center)
	endif

		locVRAM	ArtTile_Level*tile_size			; set target VRAM location for level patterns
		lea	(Nem_GHZ_1st).l,a0			; load first half of GHZ patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		moveq	#palid_Title,d0				; load title screen palette...
		bsr.w	PalLoad_Fade				; ...to fade-in buffer
		move.b	#bgm_Title,d0				; set title screen music
		bsr.w	QueueSound2				; play title screen music
		move.b	#0,(f_debugmode).w			; disable debug mode (cheat remains active though)
		move.w	#376,(v_generictimer).w			; run title screen for 376 frames (6 seconds plus some change)

	if FixBugs
		; Fix the Press Start Button text
		; https://info.sonicretro.org/SCHG_How-to:Display_the_Press_Start_Button_text
		clearRAM v_sonicteam,v_sonicteam+object_size	; delete RAM used by "SONIC TEAM PRESENTS" object (fully)
	else
		; Bug: this only clears half of the "SONIC TEAM PRESENTS" slot.
		; This is responsible for why the "PRESS START BUTTON" text doesn't
		; show up, as the routine ID isn't reset.
		clearRAM v_sonicteam,v_sonicteam+object_size/2	; delete RAM used by "SONIC TEAM PRESENTS" object (partially)
	endif

		move.b	#id_TitleSonic,(v_titlesonic).w		; load big Sonic object
		move.b	#id_PSBTM,(v_pressstart).w		; load "PRESS START BUTTON" object
	;	clr.b	(v_pressstart+obRoutine).w		; The 'Mega Games 10' version of Sonic 1 added this line to fix the 'PRESS START BUTTON' object not appearing

	if Revision<>0
		tst.b	(v_megadrive).w				; is console Japanese?
		bpl.s	.isjap					; if yes, don't load TM object
	endif
		move.b	#id_PSBTM,(v_titletm).w			; load title screen HUD object
		move.b	#3,(v_titletm+obFrame).w		; set it to the "TM" frame
	.isjap:

		move.b	#id_PSBTM,(v_ttlsonichide).w		; load title screen HUD object
		move.b	#2,(v_ttlsonichide+obFrame).w		; load object which hides part of Sonic's torso behind the emblem

		jsr	(ExecuteObjects).l			; load title screen objects
		bsr.w	DeformLayers				; initialize background deformation before fade-in
		jsr	(BuildSprites).l			; build sprites for the title screen objects before fade-in
		moveq	#plcid_Main,d0				; load main patterns (rings, etc.)
		bsr.w	NewPLC					; (these get loaded once for the title screen and then never again, except when exiting Special Stages)

		move.w	#0,(v_title_dcount).w			; clear D-Pad counter for title screen cheats
		move.w	#0,(v_title_ccount).w			; clear C counter for title screen cheats
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		enable_display					; enable display
		bsr.w	PaletteFadeIn				; fade-in title screen

; ---------------------------------------------------------------------------
; Title screen main loop and cheat checks
; ---------------------------------------------------------------------------

Tit_MainLoop:
		move.b	#id_VBlank_Title,(v_vblank_routine).w	; set VBlank routine to $04
		bsr.w	WaitForVBlank				; wait for VBlank to finish
		jsr	(ExecuteObjects).l			; execute title screen objects
		bsr.w	DeformLayers				; run background deformation
		jsr	(BuildSprites).l			; display sprites
		bsr.w	PalCycle_Title				; run title screen palette cycle
		bsr.w	RunPLC					; run any potential PLC

		move.w	(v_player+obX).w,d0			; get current title screen position (big Sonic object)
		addq.w	#2,d0					; move it 2px to the right
		move.w	d0,(v_player+obX).w			; write new X position
		cmpi.w	#$1C00,d0				; has Sonic object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion				; if not, branch
		; Will never happen due to the short title screen generic timer.
		; This likely was an old failsafe before Demos were introduced.
		move.b	#id_Sega,(v_gamemode).w			; return to Sega screen
		rts
; ===========================================================================

Tit_ChkRegion:
		tst.b	(v_megadrive).w				; check if the machine is US or Japanese
		bpl.s	Tit_RegionJap				; if Japanese, branch
		lea	(LevSelCode_US).l,a0			; load US code
		bra.s	Tit_EnterCheat				; skip over

Tit_RegionJap:
		lea	(LevSelCode_J).l,a0			; load J code

Tit_EnterCheat:
		move.w	(v_title_dcount).w,d0			; get number of successful D-Pad cheat inputs
		adda.w	d0,a0					; add to loaded code to find current cheat input requirement
		move.b	(v_jpadpress1).w,d0			; get buttons pressed this frame
		andi.b	#btnDir,d0				; read only D-Pad buttons (UDLR)
		cmp.b	(a0),d0					; does button press match current cheat entry?
		bne.s	Tit_ResetCheat				; if not, branch and reset cheat
		addq.w	#1,(v_title_dcount).w			; increment number of successful D-Pad cheat inputs
		tst.b	d0					; has end of cheat code been reached? (0-entry in cheat)
		bne.s	Tit_CountC				; if not, branch
	if FixBugs
		; Allow additional cheats to be entered without resetting the sequence first.
		clr.w	(v_title_dcount).w			; reset D-Pad counter
	endif

Tit_ActivateCheat:
		; (On JAPANESE consoles only) Activated cheat depends on the amount of times C was pressed:
		; 0-1 level select -- 2-3 slow motion -- 4-5 debug mode -- 6-7: hidden Japanese credits & sound test 9E/9F
		; For any other regions, pressing C twice or more will ALWAYS result in slow motion and debug mode,
		; and the hidden Japanese credits cheat is unavailable under any circumstances on such consoles.
		lea	(f_levselcheat).w,a0			; get base cheat index
		move.w	(v_title_ccount).w,d1			; get number of tiles C was pressed
		lsr.w	#1,d1					; half pressed amount
		andi.w	#3,d1					; only four cheats are possible
		beq.s	Tit_PlayRing				; if C was not pressed, only activate level select
		tst.b	(v_megadrive).w				; check if the machine is US or Japanese
		bpl.s	Tit_PlayRing				; if Japanese, branch
		moveq	#1,d1					; on non-Japanese console, force index to slow motion cheat
		move.b	d1,1(a0,d1.w)				; enable debug mode first (and slow motion in the next line)

Tit_PlayRing:
		move.b	#1,(a0,d1.w)				; activate cheat depending on C-press count
		move.b	#sfx_Ring,d0				; set ring sound when code is entered
		bsr.w	QueueSound2				; play it
		bra.s	Tit_CountC				; skip over cheat reset
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0					; has D-Pad been pressed?
		beq.s	Tit_CountC				; if not, don't reset D-Pad counter
		cmpi.w	#9,(v_title_dcount).w			; has cheat reached index 9? (impossible condition)
		beq.s	Tit_CountC				; if yes, don't reset D-Pad counter
		move.w	#0,(v_title_dcount).w			; reset cheat index counter
	if FixBugs
		; Entering an incorrect cheat input normally resets the entire sequence.
		; If the incorrect input matches the first cheat button, it should be treated
		; as the first successful input to make repeated attempts less awkward.
		lea	(LevSelCode_J).l,a0			; reload J code
		tst.b	(v_megadrive).w				; check if the machine is US or Japanese
		bpl.s	.chkUp					; if Japanese, branch
		lea	(LevSelCode_US).l,a0			; reload US code
	.chkUp:	cmp.b	(a0),d0					; was incorrect button press the first cheat input?
		beq.s	Tit_EnterCheat				; if yes, treat it as first correct input right away
	endif

Tit_CountC:
		move.b	(v_jpadpress1).w,d0			; get currently pressed buttons
		andi.b	#btnC,d0				; is C button pressed?
		beq.s	Tit_ChkStartOrDemo			; if not, branch
		addq.w	#1,(v_title_ccount).w			; increment C counter

; loc_3230:
Tit_ChkStartOrDemo:
		tst.w	(v_generictimer).w			; has title screen timer expired?
		beq.w	GotoDemo				; if yes, launch Demo mode
		andi.b	#btnStart,(v_jpadpress1).w		; check if Start is pressed
		beq.w	Tit_MainLoop				; if not, continue looping title screen

Tit_ChkLevSel:
		tst.b	(f_levselcheat).w			; check if level select code is on
		beq.w	PlayLevel				; if not, begin game by playing normal level
		btst	#bitA,(v_jpadhold1).w			; check if A was held while pressing Start
		beq.w	PlayLevel				; if not, begin game by playing normal level
; ---------------------------------------------------------------------------

Tit_EnterLevelSelect:
	if FixBugs
		; Fix the level selects graphics bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Level_Select_graphics_bug
		move.b	#id_VBlank_Title,(v_vblank_routine).w	; set VBlank routine to $04
		bsr.w	WaitForVBlank				; run VBlank one extra frame to prevent graphical glitches
	endif
		moveq	#palid_LevelSel,d0			; load level select palette...
		bsr.w	PalLoad					; ...directly to active palette

		clearRAM v_hscrolltablebuffer			; clear H-Scroll buffer
		move.l	d0,(v_scrposy_vdp).w			; clear VSRAM (d0 is still 0)
		disable_ints					; disable interrupts

		lea	(vdp_data_port).l,a6			; prepare VDP data write
		locVRAM	vram_bg					; write to background nametable
		move.w	#plane_size_64x32/4-1,d1		; write full screen
.LevSelClearBG:	move.l	d0,(a6)					; clear background plane
		dbf	d1,.LevSelClearBG			; loop until plane is fully cleared

		bsr.w	LevSelTextLoad				; load level select text before entering main loop

; ---------------------------------------------------------------------------
; Level Select main loop
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#id_VBlank_Title,(v_vblank_routine).w	; set VBlank routine to $04
		bsr.w	WaitForVBlank				; wait for VBlank to finish
		bsr.w	LevSelControls				; update selected line if necessary
		bsr.w	RunPLC					; run any potential PLC
		tst.l	(v_plc_buffer).w			; are any patterns in the PLC still left to be loaded?
		bne.s	LevelSelect				; if yes, block quitting level select until finished
		andi.b	#btnABC+btnStart,(v_jpadpress1).w	; is A, B, C, or Start pressed?
		beq.s	LevelSelect				; if not, loop level select

LevSel_SelectionMade:
		move.w	(v_levselitem).w,d0			; get currently selected line
		cmpi.w	#levsel_sndtest_row,d0			; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS				; if not, go to Level/SS subroutine
		move.w	(v_levselsound).w,d0			; get currently selected sound test entry
		addi.w	#$80,d0					; make it $80-based

		; 9E/9F shortcuts with hidden Japanese Credits cheat
		tst.b	(f_creditscheat).w			; is hidden Japanese Credits cheat on?
		beq.s	LevSel_NoCheat				; if not, branch
		cmpi.w	#$9F,d0					; is sound $9F being played?
		beq.s	LevSel_Ending				; if yes, go to Ending Sequence
		cmpi.w	#$9E,d0					; is sound $9E being played?
		beq.s	LevSel_Credits				; if yes, go to Credits
LevSel_NoCheat:
	if FixBugs=0
		; This is a workaround for a bug (see PlaySoundID in the sound driver for more info)
		cmpi.w	#bgm__Last+1,d0				; is sound $80-$93 being played?
		blo.s	LevSel_PlaySnd				; if yes, branch
		cmpi.w	#sfx__First,d0				; is sound $94-$9F being played?
		blo.s	LevelSelect				; if yes, branch
LevSel_PlaySnd:
	endif
		bsr.w	QueueSound2				; play selected sound
		bra.s	LevelSelect				; loop level select
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).w 		; set screen mode to $18 (Ending)
		move.w	#id_EndZ_good,(v_zone_act).w  		; set level to good Ending (will be bad Ending without 6 emeralds)
		rts
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).w		; set screen mode to $1C (Credits)
		move.b	#bgm_Credits,d0				; set credits music
		bsr.w	QueueSound2				; play it
		move.w	#0,(v_creditsnum).w			; start at the first credits page
		rts
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0					; double selected line for word-based indexing
		move.w	LevSel_Ptrs(pc,d0.w),d0			; find relevant level pointer from table
		bmi.w	LevelSelect				; if it's an invalid entry, branch back to main loop
		cmpi.w	#id_SS<<8,d0				; check if selected level Special Stage (0700 is used as dummy value)
		bne.s	LevSel_Level				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set screen mode to $10 (Special Stage)
		clr.w	(v_zone_act).w				; clear level
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0					; set d0 to 0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
	if Revision<>0
		move.l	#5000,(v_scorelife).w			; extra life is awarded at 50000 points
	endif
		rts
; ===========================================================================

LevSel_Level:
		andi.w	#$3FFF,d0				; mask out invalid bits of level number
		move.w	d0,(v_zone_act).w			; set new level number (zone and act)

PlayLevel:
		move.b	#id_Level,(v_gamemode).w		; set screen mode to $0C (level)
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0					; set d0 to 0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		move.b	d0,(v_lastspecial).w			; clear special stage number
		move.b	d0,(v_emeralds).w			; clear emeralds
		move.l	d0,(v_emldlist).w			; clear emeralds
		move.l	d0,(v_emldlist+4).w			; clear emeralds
		move.b	d0,(v_continues).w			; clear continues
	if Revision<>0
		move.l	#5000,(v_scorelife).w			; extra life is awarded at 50000 points
	endif
		move.b	#bgm_Fade,d0				; set music fade-out command
		bsr.w	QueueSound2				; fade out music
		rts						; return to MainGameLoop to start level
; End of function GM_Title

; ===========================================================================
; ---------------------------------------------------------------------------
; Level select - level pointers
; ---------------------------------------------------------------------------
; This is just for the pointers. For the text itself, see: LevelMenuText
; ---------------------------------------------------------------------------

LevSel_Ptrs:
		dc.w id_GHZ_act1
		dc.w id_GHZ_act2
		dc.w id_GHZ_act3
	if Revision=0
		; old level order
		dc.w id_LZ_act1
		dc.w id_LZ_act2
		dc.w id_LZ_act3
		dc.w id_MZ_act1
		dc.w id_MZ_act2
		dc.w id_MZ_act3
		dc.w id_SLZ_act1
		dc.w id_SLZ_act2
		dc.w id_SLZ_act3
		dc.w id_SYZ_act1
		dc.w id_SYZ_act2
		dc.w id_SYZ_act3
	else
		; correct level order
		dc.w id_MZ_act1
		dc.w id_MZ_act2
		dc.w id_MZ_act3
		dc.w id_SYZ_act1
		dc.w id_SYZ_act2
		dc.w id_SYZ_act3
		dc.w id_LZ_act1
		dc.w id_LZ_act2
		dc.w id_LZ_act3
		dc.w id_SLZ_act1
		dc.w id_SLZ_act2
		dc.w id_SLZ_act3
	endif
		dc.w id_SBZ_act1
		dc.w id_SBZ_act2
		dc.w id_LZ_act4			; Scrap Brain Zone 3
		dc.w id_FZ			; Final Zone
		dc.w id_SS<<8			; Special Stage (dummy value)
		dc.w $8000			; Sound Test
LevSel_PtrsEnd:	even

; ===========================================================================
; ---------------------------------------------------------------------------
; Level select codes
; ---------------------------------------------------------------------------

LevSelCode_J:
	if Revision=0
		dc.b btnUp,btnDn,btnL,btnR,0,$FF
	else
		dc.b btnUp,btnDn,btnDn,btnDn,btnL,btnR,0,$FF
	endif
		even

LevSelCode_US:	dc.b btnUp,btnDn,btnL,btnR,0,$FF
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Demo mode loading routine
; ---------------------------------------------------------------------------

GotoDemo:	; wait half a second on the final frame of Sonic's finger wagging before going to demo
		move.w	#30,(v_generictimer).w			; set timeout to 30 frames

; loc_33B6:
GotoDemo_PreDelayLoop:
		move.b	#id_VBlank_Title,(v_vblank_routine).w	; set VBlank routine to $04
		bsr.w	WaitForVBlank				; wait for VBlank to finish
		bsr.w	DeformLayers				; run background deformation
		bsr.w	PaletteCycle				; run normal palette cycle routine (this briefly uses GHZ's cycle)
		bsr.w	RunPLC					; run any potential PLC

		move.w	(v_player+obX).w,d0			; get current title screen position (big Sonic object)
		addq.w	#2,d0					; move it 2px to the right
		move.w	d0,(v_player+obX).w			; write new X position
		cmpi.w	#$1C00,d0				; has Sonic object passed $1C00 on x-axis?
		blo.s	GotoDemo_ChkLoop			; if not, branch
		; Will never happen due to the short title screen generic timer.
		; This likely was an old failsafe before Demos were introduced.
		move.b	#id_Sega,(v_gamemode).w			; return to Sega screen
		rts
; ===========================================================================

; loc_33E4:
GotoDemo_ChkLoop:
		andi.b	#btnStart,(v_jpadpress1).w		; has Start button been pressed during pre-delay?
		bne.w	Tit_ChkLevSel				; if yes, abort loading demo and load normal level instead
		tst.w	(v_generictimer).w			; has pre-delay timer expired?
		bne.w	GotoDemo_PreDelayLoop			; if not, branch
; ---------------------------------------------------------------------------

		; start loading demo now
		move.b	#bgm_Fade,d0				; set music fade-out command
		bsr.w	QueueSound2				; fade out music

		move.w	(v_demonum).w,d0			; load demo number
		andi.w	#7,d0					; limit to four demo entries
		add.w	d0,d0					; double for word-based indexing
		move.w	Demo_Levels(pc,d0.w),d0			; load level number for demo
		move.w	d0,(v_zone_act).w			; set level for demo

		addq.w	#1,(v_demonum).w			; add 1 to demo number
		cmpi.w	#4,(v_demonum).w			; is demo number less than 4?
		blo.s	GotoDemo_NoReset			; if yes, branch
		move.w	#0,(v_demonum).w			; reset demo number to 0

; loc_3422:
GotoDemo_NoReset:
		move.w	#1,(f_demo).w				; turn demo mode on
		move.b	#id_Demo,(v_gamemode).w			; set game mode to 08 (demo)

		cmpi.w	#$600,d0				; is level number 0600 (Special Stage dummy value)?
		bne.s	GotoDemo_NotSS				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set game mode to $10 (Special Stage)
		clr.w	(v_zone_act).w				; clear level number
		clr.b	(v_lastspecial).w			; clear special stage number to play demo in stage 1

; Demo_Level:
GotoDemo_NotSS:
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0					; clear d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
	if Revision<>0
		move.l	#5000,(v_scorelife).w			; extra life is awarded at 50000 points
	endif
		rts						; return to MainGameLoop to start demo
; End of function GotoDemo

; ===========================================================================
; ---------------------------------------------------------------------------
; Levels used in demos
; ---------------------------------------------------------------------------

Demo_Levels:	; previously in "misc/Demo Level Order - Intro.bin"
		dc.w id_GHZ_act1
		dc.w id_MZ_act1
		dc.w id_SYZ_act1
		dc.w $600 ; used as dummy value to start the Special Stage demo
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to change what you're selecting in the level select
; ---------------------------------------------------------------------------

LevSelControls:
		move.b	(v_jpadpress1).w,d1			; get current button presses
		andi.b	#btnUp+btnDn,d1				; is up/down pressed this frame?
		bne.s	LevSel_UpDown				; if yes, branch
		subq.w	#1,(v_levseldelay).w			; if held, subtract 1 from delay until next move
		bpl.s	LevSel_SndTest				; if time remains, branch

LevSel_UpDown:
		move.w	#12-1,(v_levseldelay).w			; reset time delay
		move.b	(v_jpadhold1).w,d1			; get currently held buttons
		andi.b	#btnUp+btnDn,d1				; is up/down held?
		beq.s	LevSel_SndTest				; if not, branch
		move.w	(v_levselitem).w,d0			; get currently selected line
		btst	#bitUp,d1				; is up held?
		beq.s	LevSel_Down				; if not, branch
		subq.w	#1,d0					; move up 1 selection
		bhs.s	LevSel_Down				; if entry is still valid, branch
		moveq	#levsel_line_count-1,d0			; if selection moves below 0, jump to selection last row

LevSel_Down:
		btst	#bitDn,d1				; is down held?
		beq.s	LevSel_Refresh				; if not, branch
		addq.w	#1,d0					; move down 1 selection
		cmpi.w	#levsel_line_count,d0			; is selection past the last one now?
		blo.s	LevSel_Refresh				; if not, branch
		moveq	#0,d0					; if selection moves past the last row, jump to selection 0

LevSel_Refresh:
		move.w	d0,(v_levselitem).w			; set new selection
		bsr.w	LevSelTextLoad				; refresh text
		rts
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#levsel_sndtest_row,(v_levselitem).w	; is sound test row selected?
		bne.s	LevSel_NoMove				; if not, branch
		move.b	(v_jpadpress1).w,d1			; get currently pressed buttons
		andi.b	#btnR+btnL,d1				; is left/right pressed?
		beq.s	LevSel_NoMove				; if not, branch

		move.w	(v_levselsound).w,d0			; get currently selected sound test number
		btst	#bitL,d1				; is left pressed?
		beq.s	LevSel_Right				; if not, branch
		subq.w	#1,d0					; subtract 1 from sound test
		bhs.s	LevSel_Right				; is result still positive? if yes, branch
		moveq	#sfx__Last-$80,d0 			; if sound test moves below 0, set to last entry (non-$80 based)

LevSel_Right:
		btst	#bitR,d1				; is right pressed?
		beq.s	LevSel_Refresh2				; if not, branch
		addq.w	#1,d0					; add 1 to sound test
		cmpi.w	#sfx__Last-$80+1,d0			; is result now past the last entry?
		blo.s	LevSel_Refresh2				; if not, branch
		moveq	#0,d0					; if sound test moves above last entry, set to 0

LevSel_Refresh2:
		move.w	d0,(v_levselsound).w			; set sound test number
		bsr.w	LevSelTextLoad				; refresh text

LevSel_NoMove:
		rts
; End of function LevSelControls

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load level select text
; ---------------------------------------------------------------------------

levsel_line_count:	equ 21	; total number of lines
levsel_line_length:	equ 24	; characters per line
levsel_sndtest_row:	equ levsel_line_count-1  ; row index of the sound test
levsel_sndtest_col:	equ levsel_line_length-8 ; column offset for the sound test number

levsel_start_row:	equ 4	; top tile offset for start position
levsel_start_col:	equ 8	; left tile offset for start position
levsel_vram_main:	equ vram_bg+(levsel_start_row<<7)+(levsel_start_col<<1)	; nametable address in VRAM
levsel_vram_sndtestnum:	equ levsel_vram_main+(levsel_sndtest_row<<7)+(levsel_sndtest_col<<1) ; nametable address for sound test numbers

levsel_white:		equ ArtTile_Level_Select_Font|Tile_Pal4|Tile_Prio ; VRAM setting for white text (non-selected lines)
levsel_yellow:		equ ArtTile_Level_Select_Font|Tile_Pal3|Tile_Prio ; VRAM setting for yellow text (selected line)

; ---------------------------------------------------------------------------

LevSelTextLoad:
		; Write main text in white
		lea	(LevelMenuText).l,a1			; load menu text offset
		lea	(vdp_data_port).l,a6			; prepare VDP data write
		locVRAM	levsel_vram_main,d4			; prepare base VRAM nametable location in d4
		move.w	#levsel_white,d3			; VRAM setting
		moveq	#levsel_line_count-1,d1			; number of lines of text to write
.DrawAll:	move.l	d4,4(a6)				; write to VDP
		bsr.w	LevSel_ChgLine				; draw line of text
		addi.l	#$00800000,d4				; jump to next line
		dbf	d1,.DrawAll				; repeat until all lines are drawn

		; Draw currently selected line in yellow
		moveq	#0,d0					; clear d0
		move.w	(v_levselitem).w,d0			; get currently selected line
		move.w	d0,d1					; back up selected line
		locVRAM	levsel_vram_main,d4			; prepare base VRAM nametable location in d4
		lsl.w	#7,d0					; times $80
		swap	d0					; swap so that line now becomes VRAM nametable offset
		add.l	d0,d4					; add that to base VRAM location
		lea	(LevelMenuText).l,a1			; load menu text offset
	if levsel_line_length=24
		lsl.w	#3,d1					; times 8
		move.w	d1,d0					; copy result
		add.w	d1,d1					; times...
		add.w	d0,d1					; ...3 (because default line length 8 x 3 = 24)
	else
		; The above calculation assumes 24 as line length, we need a different approach if it changes.
		mulu.w	#levsel_line_length,d1			; multiply selected line index by line length
	endif
		adda.w	d1,a1					; add to menu text offset
		move.w	#levsel_yellow,d3 			; prepare selected-line VRAM setting
		move.l	d4,4(a6)				; write to VDP
		bsr.w	LevSel_ChgLine				; recolour selected line

		; Write sound test numbers
		move.w	#levsel_white,d3			; draw numbers in white by default
		cmpi.w	#levsel_sndtest_row,(v_levselitem).w	; is currently selected line the sound test?
		bne.s	LevSel_DrawSnd				; if not, branch
		move.w	#levsel_yellow,d3			; draw numbers in yellow
LevSel_DrawSnd:
		locVRAM	levsel_vram_sndtestnum			; write sound test number position to VRAM
		move.w	(v_levselsound).w,d0			; get currently selected sound test number
		addi.w	#$80,d0					; make sound ID to be drawn $80-based
		move.b	d0,d2					; backup number
		lsr.b	#4,d0					; move first digit to lower nybble
		bsr.w	LevSel_ChgSnd				; draw 1st digit
		move.b	d2,d0					; restore backup
		bsr.w	LevSel_ChgSnd				; draw 2nd digit
		rts
; ===========================================================================

LevSel_ChgSnd:
		andi.w	#$F,d0					; mask out upper nybble
		cmpi.b	#$A,d0					; is digit $A-$F?
		blo.s	.DrawNum				; if not, branch
		addi.b	#7,d0					; use letter characters
.DrawNum:	add.w	d3,d0					; combine number with VRAM setting (white or yellow)
		move.w	d0,(a6)					; send to VRAM
		rts
; ===========================================================================

LevSel_ChgLine:
		moveq	#levsel_line_length-1,d2		; number of characters per line

.LineLoop:	moveq	#0,d0					; clear d0
		move.b	(a1)+,d0				; get current character
		bpl.s	.CharOk					; is it a valid ASCII character? if yes, branch
		move.w	#0,(a6)					; draw a blank character
		dbf	d2,.LineLoop				; loop until all characters are drawn
		rts

.CharOk:	add.w	d3,d0					; combine char with VRAM setting (white or yellow)
		move.w	d0,(a6)					; send to VRAM
		dbf	d2,.LineLoop				; loop until all characters are drawn
		rts
; End of function LevSelTextLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Level select menu text
; ---------------------------------------------------------------------------
; This is just for the actual text. For the level pointers, see: LevSel_Ptrs
; ---------------------------------------------------------------------------

LevelMenuText:
	charset ' ', $FF
	charset '0','9',$00
	charset '$', $0A
	charset '-', $0B
	charset '=', $0C
	charset '>', $0D
;	charset '>', $0E ; there are two identical right arrows in the font for some reason
	charset 'Y','Z',$0F ; Y and Z come before A-X
	charset 'A','X',$11

		dc.b "GREEN HILL ZONE  STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
	if Revision=0
		; old level order
		dc.b "LABYRINTH ZONE   STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "MARBLE ZONE      STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "STAR LIGHT ZONE  STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "SPRING YARD ZONE STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
	else
		; correct level order
		dc.b "MARBLE ZONE      STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "SPRING YARD ZONE STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "LABYRINTH ZONE   STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "STAR LIGHT ZONE  STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
	endif
		dc.b "SCRAP BRAIN ZONE STAGE 1"
		dc.b "                 STAGE 2"
		dc.b "                 STAGE 3"
		dc.b "FINAL ZONE              "
		dc.b "SPECIAL STAGE           "
		dc.b "SOUND SELECT            "
		even

	if MOMPASS=1
		if *-(levsel_line_count*levsel_line_length)<>LevelMenuText
			warning "LevelMenuText does not match expected line count/length."
		endif
		if (LevSel_PtrsEnd-LevSel_Ptrs)/2<>levsel_line_count
			warning "LevSel_Ptrs does not match expected line count."
		endif
	endif

	charset	; reset charset to default
	even

; ===========================================================================
; ---------------------------------------------------------------------------
; Music playlist for the start of a level. Note that restarting the music
; after invincibility has worn off is controlled in MusicList2 (part of
; Sonic's object). Bosses have the post-defeat music hardcoded.
; ---------------------------------------------------------------------------

MusicList:
		dc.b bgm_GHZ		; GHZ
		dc.b bgm_LZ		; LZ
		dc.b bgm_MZ		; MZ
		dc.b bgm_SLZ		; SLZ
		dc.b bgm_SYZ		; SYZ
		dc.b bgm_SBZ		; SBZ
		zonewarning MusicList,1
		dc.b bgm_FZ		; Ending
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

; Level:
GM_Level:	; fading out from previous game mode
		bset	#7,(v_gamemode).w			; add $80 to screen mode (for pre level sequence)

		tst.w	(f_demo).w				; is an ending sequence demo running?
		bmi.s	Level_NoMusicFade			; if yes, don't fade out music
		move.b	#bgm_Fade,d0				; queue music fade-out command
		bsr.w	QueueSound2				; fade out music

Level_NoMusicFade:
		bsr.w	ClearPLC				; clear any remaining PLC entries
		bsr.w	PaletteFadeOut				; fade out from the previous screen
; ---------------------------------------------------------------------------

		; load title cards, queue PLCs, setup screen, play music
		tst.w	(f_demo).w				; is an ending sequence demo running?
		bmi.s	Level_ClrRam				; if yes, don't load title screen or main level patterns

		disable_ints					; disable interrupts
		locVRAM	ArtTile_Title_Card*tile_size		; set VRAM target location for title cards
		lea	(Nem_TitleCard).l,a0			; load title card patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM
		enable_ints					; enable interrupts again

		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current Zone ID
		lsl.w	#4,d0					; multiply by $10 (number of bytes per level header entry)
		lea	(LevelHeaders).l,a2			; load level headers
		lea	(a2,d0.w),a2				; get relevant header for current level
		moveq	#0,d0					; clear d0
		move.b	(a2),d0					; get first PLC entry
		beq.s	Level_NoPLC				; if it's null, branch (never the case)
		bsr.w	AddPLC					; load level patterns for current Zone
; loc_37FC:
Level_NoPLC:
		moveq	#plcid_Main2,d0				; load secondary standard patterns (monitors, etc.)
		bsr.w	AddPLC					; (these can be overwritten by stuff like the sign post art)

Level_ClrRam:
		clearRAM v_objspace				; clear object RAM
		clearRAM v_misc_variables			; clear various miscellaneous RAM
		clearRAM v_levelvariables			; clear level variables RAM (camera position, etc.)
		clearRAM v_timingandscreenvariables		; clear various timing and screen RAM (for animated tiles, etc.)

		disable_ints					; disable interrupts
		bsr.w	ClearScreen				; wipe the screen
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_spritevram|(vram_sprites>>9),(a6)	; set sprite table address
		move.w	#vreg_planesize|%000001,(a6)		; 64-cell hscroll size
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_bgcolor|2<<4|0,(a6)		; set background colour (line 3; colour 0)
		move.w	#vreg_hintrate|223,(v_hblank_hreg).w	; set palette change position (for water)
		move.w	(v_hblank_hreg).w,(a6)			; write to VDP

		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.s	Level_LoadPal				; if not, branch
		move.w	#vreg_mode1|%010100,(a6)		; enable horizontal interrupts (HBlank)
		moveq	#0,d0					; clear d0
		move.b	(v_act).w,d0				; get current LZ act
		add.w	d0,d0					; double for word-based indexing
		lea	(WaterHeight).l,a1			; load water height array
		move.w	(a1,d0.w),d0				; get water height entries for current LZ act
		move.w	d0,(v_waterpos1).w			; set water height (actual)
		move.w	d0,(v_waterpos2).w			; set water height (ignoring surface sway)
		move.w	d0,(v_waterpos3).w			; set water height (target)
		clr.b	(v_wtr_routine).w			; clear water routine counter
		clr.b	(f_wtr_state).w				; clear water state
		move.b	#1,(f_water).w				; enable water

Level_LoadPal:
		move.w	#30,(v_air).w				; set Sonic's air timer to 30 seconds
		enable_ints					; enable interrupts

		moveq	#palid_Sonic,d0				; load Sonic's palette...
		bsr.w	PalLoad					; ...directly to active palette (for title cards)
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.s	Level_GetBgm				; if not, branch
		moveq	#palid_LZSonWater,d0			; palette number $F (LZ)
		cmpi.b	#act4,(v_act).w				; check if on act 4 (for SBZ3/LZ4)?
		bne.s	Level_WaterPal				; if not, branch
		moveq	#palid_SBZ3SonWat,d0			; palette number $10 (SBZ3)

Level_WaterPal:
		bsr.w	PalLoad_Fade_Water			; load underwater palette
		tst.b	(v_lastlamp).w				; are we respawning from a checkpoint?
		beq.s	Level_GetBgm				; if not, branch
		move.b	(v_lamp_wtrstat).w,(f_wtr_state).w	; restore water state from checkpoint

Level_GetBgm:
		tst.w	(f_demo).w				; is this a credits demo?
		bmi.s	Level_SkipTtlCard			; if yes, don't load title cards or change music

		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current Zone ID
		cmpi.w	#id_LZ_act4,(v_zone_act).w		; is level SBZ3 (LZ4)?
		bne.s	Level_BgmNotLZ4				; if not, branch
		moveq	#5,d0					; use 5th music (SBZ)

Level_BgmNotLZ4:
		cmpi.w	#id_FZ,(v_zone_act).w			; is level FZ?
		bne.s	Level_PlayBgm				; if not, branch
		moveq	#6,d0					; use 6th music (FZ)

Level_PlayBgm:
		lea	(MusicList).l,a1			; load music playlist
		move.b	(a1,d0.w),d0				; get music ID for current level
		bsr.w	QueueSound1				; play music
		move.b	#id_TitleCard,(v_titlecard).w		; load title card object
; ---------------------------------------------------------------------------

Level_TtlCardLoop: ; move in title cards, stay on them until PLCs have finished
		move.b	#id_VBlank_TitleCards,(v_vblank_routine).w ; set VBlank routine to $0C
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		jsr	(ExecuteObjects).l			; execute title cards object
		jsr	(BuildSprites).l			; build sprites to show title cards
		bsr.w	RunPLC					; decompress level graphics
	if FixBugs=0
		move.w	(v_ttlcardact+obX).w,d0			; get current position of the "ACT" element of the title cards
		cmp.w	(v_ttlcardact+card_mainX).w,d0		; has "ACT" element reached its target position?
		bne.s	Level_TtlCardLoop			; if not, loop until it has
	else
		; Check if *every* title card element has reached their target position.
		; Decompression is normally slow enough that every element is able
		; to reach their target position before it's finished, but if
		; decompression is upgraded with something faster, then the risk
		; of decompression finishing and exiting this loop before all of the title
		; card is finished moving into place is increased.
		lea	(v_titlecard).w,a0			; get title card elements
		moveq	#4-1,d1					; number of title card elements

Level_CheckTtlCard:
		move.w	obX(a0),d0				; get current position of a title card element
		cmp.w	card_mainX(a0),d0			; has this title card element reached its target position?
		bne.s	Level_TtlCardLoop			; if not, loop until it has
		lea	object_size(a0),a0			; next title card element
		dbf	d1,Level_CheckTtlCard			; loop until every element has reached its target position
	endif
		tst.l	(v_plc_buffer).w			; have patterns been fully decompressed and loaded?
		bne.s	Level_TtlCardLoop			; if not, loop until they have
; ---------------------------------------------------------------------------

		; PLCs have finished, load/initialize remaining data

	if FixBugs
		; Do VBlank for one extra frame to provide enough processing time
		; for the remaining data initialization below. Without it, it's
		; possible for VBlank to interrupt in the middle of a transfer,
		; resulting in visual corruption. This will also make title cards
		; smoother should decompression get upgraded with something faster.
		move.b	#id_VBlank_TitleCards,(v_vblank_routine).w ; set VBlank routine to $0C
		bsr.w	WaitForVBlank				; wait until VBlank has finished
	endif

		jsr	(Hud_Base).l				; load basic HUD graphics (only in levels, not in the ending demos)

Level_SkipTtlCard:
		moveq	#palid_Sonic,d0				; load Sonic's palette to fade-in buffer
		bsr.w	PalLoad_Fade				; (doesn't actually do anything, the PalFadeIn_Alt call below skips the first palette line)
		bsr.w	LevelSizeLoad				; load level size and set default level boundaries
		bsr.w	DeformLayers				; initialize background deformation
		bset	#2,(v_fg_scroll_flags).w		; draw an extra column at the left side of the screen during level start
		bsr.w	LevelDataLoad				; load block mappings and palettes
		bsr.w	LoadTilesFromStart			; fully draw the foreground and background once before fade-in
	if UnusedOptimization=0
		jsr	(ConvertCollisionArray).l		; call a routine that immediately returns (this is a disabled development function)
	endif
		bsr.w	ColIndexLoad				; set collision index for current zone
		bsr.w	LZWaterFeatures				; initialize water features if zone is LZ

		move.b	#id_SonicPlayer,(v_player).w		; load Sonic object

		tst.w	(f_demo).w				; is this a credits demo?
		bmi.s	Level_ChkDebug				; if yes, don't load HUD
		move.b	#id_HUD,(v_hud).w			; load HUD object

Level_ChkDebug:
		tst.b	(f_debugcheat).w			; has debug cheat been entered?
		beq.s	Level_ChkWater				; if not, branch
		btst	#bitA,(v_jpadhold1).w			; is A button held?
		beq.s	Level_ChkWater				; if not, branch
		move.b	#1,(f_debugmode).w			; enable debug mode

Level_ChkWater:
		move.w	#0,(v_jpadhold2).w			; clear button input states for Sonic player object
		move.w	#0,(v_jpadhold1).w			; clear actual button input states for controller 1

		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.s	Level_LoadObj				; if not, branch
		move.b	#id_WaterSurface,(v_watersurface1).w	; load water surface object A
		move.w	#$60,(v_watersurface1+obX).w		; set base X-position for surface A
		move.b	#id_WaterSurface,(v_watersurface2).w	; load water surface object B
		move.w	#$120,(v_watersurface2+obX).w		; set base X-position for surface B

Level_LoadObj:
		jsr	(ObjPosLoad).l				; initialize object manager
		jsr	(ExecuteObjects).l			; load objects that are already visible during fade-in
		jsr	(BuildSprites).l			; build sprites for objects before fade-in

		moveq	#0,d0					; clear d0
		tst.b	(v_lastlamp).w				; are we starting from a lamppost?
		bne.s	Level_SkipClr				; if yes, branch
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.b	d0,(v_lifecount).w			; clear extra lives flags when getting 100/200 rings

Level_SkipClr:
		move.b	d0,(f_timeover).w			; clear time over flag
		move.b	d0,(v_shield).w				; clear shield
		move.b	d0,(v_invinc).w				; clear invincibility
		move.b	d0,(v_shoes).w				; clear speed shoes
	if UnusedOptimization=0
		move.b	d0,(v_unused1).w			; clear unused flag (goggles?)
	endif
		move.w	d0,(v_debuguse).w			; exit debug mode if necessary
		move.w	d0,(f_restart).w			; clear level restart flag
		move.w	d0,(v_framecount).w			; reset frames since level start to 0
		bsr.w	OscillateNumInit			; initialize oscillation values
		move.b	#1,(f_scorecount).w			; update score counter
		move.b	#1,(f_ringcount).w			; update rings counter
		move.b	#1,(f_timecount).w			; update time counter

		move.w	#0,(v_btnpushtime1).w			; clear button push counters for demos
		lea	(DemoDataPtr).l,a1			; load demo data
		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current Zone ID
		lsl.w	#2,d0					; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1				; get demo pointer for current level
		tst.w	(f_demo).w				; are we in a regular (not-credits) demo?
		bpl.s	Level_Demo				; if yes, branch
		lea	(DemoEndDataPtr).l,a1			; load ending demo data
		move.w	(v_creditsnum).w,d0			; get current credits page
		subq.w	#1,d0					; subtract by 1
		lsl.w	#2,d0					; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1				; get demo pointer for current credits page

Level_Demo:
		move.b	1(a1),(v_btnpushtime2).w		; load initial demo key press duration
		subq.b	#1,(v_btnpushtime2).w			; subtract 1 from demo key pressduration
		move.w	#1800,(v_generictimer).w		; run regular demos for 30 seconds
		tst.w	(f_demo).w				; is this a regular (not-credits) demo?
		bpl.s	Level_ChkWaterPal			; if not, branch
		move.w	#540,(v_generictimer).w			; run credits demos for 9 seconds each
		cmpi.w	#4,(v_creditsnum).w			; is this credits demo 4? (Labyrinth)
		bne.s	Level_ChkWaterPal			; if not, branch
		move.w	#510,(v_generictimer).w			; run this specific demo for 0.5 seconds less

Level_ChkWaterPal:
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ/SBZ3?
		bne.s	Level_Delay				; if not, branch
		moveq	#palid_LZWater,d0			; palette $B (LZ underwater)
		cmpi.b	#act4,(v_act).w				; check if on act 4 (for SBZ3/LZ4)
		bne.s	Level_WtrNotSbz				; if not, branch
		moveq	#palid_SBZ3Water,d0			; palette $D (SBZ3 underwater)

Level_WtrNotSbz:
		bsr.w	PalLoad_Water				; load underwater palette to active palette

Level_Delay:
		move.w	#4-1,d1					; run 4 extra frames of VBlank to do palette transfers

Level_DelayLoop:
		move.b	#id_VBlank_Levels,(v_vblank_routine).w	; set VBlank routine to $08
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		dbf	d1,Level_DelayLoop			; repeat for 4 frames in total

		move.w	#$202F,(v_pfade_start).w		; set to fade in 2nd, 3rd & 4th palette lines
		bsr.w	PalFadeIn_Alt				; fade-in main palette
; ---------------------------------------------------------------------------

		; level has faded in, make title cards move and enter main loop
		tst.w	(f_demo).w				; is an ending sequence demo running?
		bmi.s	Level_ClrCardArt			; if yes, load explosion and animal graphics now
		addq.b	#2,(v_ttlcardname+obRoutine).w		; make title card move (name)
		addq.b	#4,(v_ttlcardzone+obRoutine).w		; make title card move ("ZONE")
		addq.b	#4,(v_ttlcardact+obRoutine).w		; make title card move ("ACT")
		addq.b	#4,(v_ttlcardoval+obRoutine).w		; make title card move (blue oval)
		bra.s	Level_StartGame
; ===========================================================================

Level_ClrCardArt:
		; This portion is only for the credits demos to loads explosions
		; and animal graphics right now, as normally they get loaded by
		; the title cards (which aren't loaded for credits demos).
		moveq	#plcid_Explode,d0			; load explosion graphics
		jsr	(AddPLC).l				; queue PLC
		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current Zone ID
		addi.w	#plcid_GHZAnimals,d0			; add offset to animal patterns (+$15)
		jsr	(AddPLC).l				; load animal patterns

Level_StartGame:
		bclr	#7,(v_gamemode).w			; subtract $80 from mode to end pre-level stuff
		; enter main loop...

; ---------------------------------------------------------------------------
; Main level loop (when all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame				; handle pausing the game when pressing start
		move.b	#id_VBlank_Levels,(v_vblank_routine).w	; set VBlank routine to $08
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		addq.w	#1,(v_framecount).w			; add 1 to level timer

		bsr.w	MoveSonicInDemo				; simulate controls in demos (immediately returns outside demos)
		bsr.w	LZWaterFeatures				; apply water features if in Labyrinth Zone
		jsr	(ExecuteObjects).l			; execute all objects in object RAM

	if FixBugs
		tst.w	(f_restart).w				; is the level set to restart?
		bne.s	Level_CheckRestart			; if yes, branch to check restart condition
	elseif Revision<>0
		; For REV01, this code has been relocated from below to avoid brief visual glitches
		; as a result of the zone ID changing. This, however, had the side effect of demos
		; restarting if Sonic dies, rather than immediately going to the next game mode.
		; In the case of the ending demos, it could result in the credits getting aborted.
		tst.w	(f_restart).w				; is the level set to restart?
		bne.w	GM_Level				; if yes, restart level immediately
	endif

		tst.w	(v_debuguse).w				; is debug mode being used?
		bne.s	Level_DoScroll				; if yes, continue plane scrolling even when dying
		cmpi.b	#6,(v_player+obRoutine).w		; has Sonic just died?
		bhs.s	Level_SkipScroll			; if yes, don't do plane scrolling

Level_DoScroll:
		bsr.w	DeformLayers				; scroll planes and do background deformation

Level_SkipScroll:
		jsr	(BuildSprites).l			; build sprite table
		jsr	(ObjPosLoad).l				; run the object manager to load level objects
		bsr.w	PaletteCycle				; run palette cycles
		bsr.w	RunPLC					; run PLC, if any
		bsr.w	OscillateNumDo				; advance oscillation values
		bsr.w	SynchroAnimate				; advance animation timers
		bsr.w	SignpostArtLoad				; check if sign post art needs to be loaded and lock left boundary

Level_CheckRestart:
		cmpi.b	#id_Demo,(v_gamemode).w			; are we in a demo?
		beq.s	Level_ChkDemo				; if yes, branch
	if FixBugs|(Revision=0)
		tst.w	(f_restart).w				; is the level set to restart?
		bne.w	GM_Level				; if yes, restart leve
	endif
		cmpi.b	#id_Level,(v_gamemode).w		; is game mode still set to level?
		beq.w	Level_MainLoop				; if yes, loop level game mode
		rts						; if game mode changed, return to MainGameLoop
; ===========================================================================

Level_ChkDemo:
		tst.w	(f_restart).w				; is level set to restart?
		bne.s	Level_EndDemo				; if yes, branch
		tst.w	(v_generictimer).w			; is there time left on the demo?
		beq.s	Level_EndDemo				; if not, branch
		cmpi.b	#id_Demo,(v_gamemode).w			; is game mode still demo?
		beq.w	Level_MainLoop				; if yes, loop level game mode
		move.b	#id_Sega,(v_gamemode).w			; otherwise, return to Sega screen
		rts						; return to MainGameLoop
; ===========================================================================

Level_EndDemo:
		cmpi.b	#id_Demo,(v_gamemode).w			; is game mode still demo?
		bne.s	Level_FadeDemo				; if not, slowly fade-out demo
		move.b	#id_Sega,(v_gamemode).w			; return to Sega screen
		tst.w	(f_demo).w				; is demo mode on & not ending sequence?
		bpl.s	Level_FadeDemo				; if yes, branch
		move.b	#id_Credits,(v_gamemode).w		; return to credits game mode (next credits page)

Level_FadeDemo:
		move.w	#60,(v_generictimer).w			; run fade-out for one second
		move.w	#$003F,(v_pfade_start).w		; set palette fade-out position and size
		clr.w	(v_palchgspeed).w			; do first palette dimming immediately

Level_FDLoop:
		move.b	#id_VBlank_Levels,(v_vblank_routine).w	; set VBlank routine to $08
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		bsr.w	MoveSonicInDemo				; continue updating demo controls during fade-out
		jsr	(ExecuteObjects).l			; continue executing objects during fade-out
		jsr	(BuildSprites).l			; continue building sprites during fade-out
		jsr	(ObjPosLoad).l				; continue running object manager during fade-out

		subq.w	#1,(v_palchgspeed).w			; decrement palette fade-out delay
		bpl.s	Level_FDLoop_NoDim			; if time remains, branch
		move.w	#2,(v_palchgspeed).w			; reset palette fade-out delay
		bsr.w	FadeOut_ToBlack				; dim palette further

; loc_3BC8:
Level_FDLoop_NoDim:
		tst.w	(v_generictimer).w			; has fade-out loop finished?
		bne.s	Level_FDLoop				; if not, loop
		rts						; return to MainGameLoop
; End of function GM_Level

; ===========================================================================
; >>> Misc level logic for specific circumstances
	include	"_inc/LZWaterFeatures.asm"
	include	"_inc/MoveSonicInDemo.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Collision index pointer loading subroutine
; ---------------------------------------------------------------------------

ColIndexLoad:
		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current zone ID
		lsl.w	#2,d0					; multiply by 4 for long-based indexing
		move.l	ColPointers(pc,d0.w),(v_collindex).w	; set collision index pointer for current zone
		rts						; return
; End of function ColIndexLoad

; ---------------------------------------------------------------------------
; Collision index pointers
; ---------------------------------------------------------------------------

ColPointers:	dc.l Col_GHZ
		dc.l Col_LZ
		dc.l Col_MZ
		dc.l Col_SLZ
		dc.l Col_SYZ
		dc.l Col_SBZ
		zonewarning ColPointers,4
		; The ending doesn't get an entry, as it's hardcoded to use Col_GHZ
		even

; ===========================================================================
; >>> Routines to set and update values that change on a fixed timer
	include	"_inc/Oscillatory Routines.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to change synchronised animation variables (rings, giant rings)
; ---------------------------------------------------------------------------

SynchroAnimate:

; Used for GHZ spiked log
Sync1:
		subq.b	#1,(v_ani0_time).w			; has first timer reached 0?
		bpl.s	Sync2					; if not, branch
		move.b	#12-1,(v_ani0_time).w			; reset first timer to 12 frames
		subq.b	#1,(v_ani0_frame).w			; go to next frame (backwards)
		andi.b	#7,(v_ani0_frame).w 			; limit to frames 0-7

; Used for rings and giant rings
Sync2:
		subq.b	#1,(v_ani1_time).w			; has second timer reached 0?
		bpl.s	Sync3					; if not, branch
		move.b	#8-1,(v_ani1_time).w			; reset second timer to 8 frames
		addq.b	#1,(v_ani1_frame).w			; go to next frame
		andi.b	#3,(v_ani1_frame).w			; limit to frames 0-3

; Used for nothing
Sync3:
		subq.b	#1,(v_ani2_time).w			; has third timer reached 0?
		bpl.s	Sync4					; if not, branch
		move.b	#8-1,(v_ani2_time).w			; reset third timer to 8 frames
		addq.b	#1,(v_ani2_frame).w			; go to next frame
		cmpi.b	#6,(v_ani2_frame).w			; limit to frames 0-5
		blo.s	Sync4					; if still frame 0-5, branch
		move.b	#0,(v_ani2_frame).w			; set to frame 0 when it reached frame 6

; Used for bouncing rings
Sync4:
		tst.b	(v_ani3_time).w				; is ring loss timer active at all?
		beq.s	SyncEnd					; if not, don't advance animation
		moveq	#0,d0					; clear d0
		move.b	(v_ani3_time).w,d0			; get remaining ring loss timer
		add.w	(v_ani3_buf).w,d0			; add buffered timer value
		move.w	d0,(v_ani3_buf).w			; set that as new buffered timer
		rol.w	#7,d0					; align for speed
		andi.w	#3,d0					; limit to frames 0-3
		move.b	d0,(v_ani3_frame).w			; set as current frame for lost rings
		subq.b	#1,(v_ani3_time).w			; decrease ring loss timer

SyncEnd:
		rts						; return
; End of function SynchroAnimate

; ===========================================================================
; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine. Also locks left boundary.
; ---------------------------------------------------------------------------

SignpostArtLoad:
		tst.w	(v_debuguse).w				; is debug mode being used?
		bne.w	.return					; if yes, do not lock screen or load art
		cmpi.b	#act3,(v_act).w				; is this a third act?
		beq.s	.return					; if yes, don't load art (due to the boss fight)

		move.w	(v_screenposx).w,d0			; get current X-camera position
		move.w	(v_limitright2).w,d1			; get right level boundary
		subi.w	#$100,d1				; check for $100 pixels before the right boundary
		cmp.w	d1,d0					; has Sonic reached the right edge of the level?
		blt.s	.return					; if not, branch

		tst.b	(f_timecount).w				; has time already stopped from touching the signpost?
		beq.s	.return					; if yes, branch
		cmp.w	(v_limitleft2).w,d1			; has left boundary already been locked?
		beq.s	.return					; if yes, branch
		move.w	d1,(v_limitleft2).w			; lock left level boundary to current screen position
		moveq	#plcid_Signpost,d0			; load signpost, hidden points, giant ring flash patterns
		bra.w	NewPLC					; add to new PLC queue

.return:
		rts						; return
; End of function SignpostArtLoad

; ===========================================================================
; >>> Demo inputs for title screen demos
Demo_GHZ:	include	"demodata/Intro - GHZ.asm"
Demo_MZ:	include	"demodata/Intro - MZ.asm"
Demo_SYZ:	include	"demodata/Intro - SYZ.asm"
Demo_SS:	include	"demodata/Intro - Special Stage.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Special Stage
; ---------------------------------------------------------------------------

; SpecialStage:
GM_Special:		; white fade-out from previous game mode
		move.w	#sfx_EnterSS,d0				; set special stage entry sound
		bsr.w	QueueSound2				; play it
		bsr.w	PaletteWhiteOut				; fade-out to white
; ---------------------------------------------------------------------------

		; load special stage patterns
		disable_ints					; disable interrupts
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_hintrate|175,(v_hblank_hreg).w	; set HBlank counter to scanline 175 (even though horizontal interrupts aren't used here...)
		move.w	#$9011,(a6)				; 128-cell hscroll size
		disable_display					; disable screen output
		bsr.w	ClearScreen				; wipe screen
		enable_ints					; enable interrupts

		fillVRAM 0, ArtTile_SS_Plane_1*tile_size+plane_size_64x32, ArtTile_SS_Plane_5*tile_size ; clear nametables
		bsr.w	SS_BGLoad				; load background clouds/bubbles/birds/fish mappings
		moveq	#plcid_SpecialStage,d0			; load special stage patterns
		bsr.w	QuickPLC				; execute PLCs immediately (no queue)

		clearRAM v_objspace				; clear object RAM space
		clearRAM v_levelvariables			; clear various level variables
		clearRAM v_timingvariables			; clear various timing variables
		clearRAM v_ngfx_buffer				; clear Nemesis decompression buffer

		clr.b	(f_wtr_state).w				; clear water state
		clr.w	(f_restart).w				; clear level restart flag
		moveq	#palid_Special,d0			; load special stage palette...
		bsr.w	PalLoad_Fade				; ...into the palette fade-in buffer
		jsr	(SS_Load).l				; load SS layout data (based on last stage entered and collected emeralds)

	if FixBugs
		; Set custom level boundaries so that the fixed
		; debug mode will not break for Special Stages.
		move.w	#$2B0,(v_limittop2).w			; set top boundary
		move.w	#$7D0,(v_limitbtm2).w			; set bottom boundary
		move.w	#$2E0,(v_limitleft2).w			; set left boundary
		move.w	#$7A0,(v_limitright2).w			; set right boundary
	endif

		move.l	#0,(v_screenposx).w			; reset X-camera position
		move.l	#0,(v_screenposy).w			; reset Y-camera position
		move.b	#id_SonicSpecial,(v_player).w		; load special stage Sonic object
		bsr.w	PalCycle_SS				; initialize palette cycle and background for fade-in
		clr.w	(v_ssangle).w				; set stage angle to "upright"
		move.w	#ss_rotatespeed,(v_ssrotate).w		; set initial stage rotation speed ($40, see object 09)
		move.w	#bgm_SS,d0				; play special stage BG music
		bsr.w	QueueSound1				; play it

		move.w	#0,(v_btnpushtime1).w			; clear button push counters for demos
		lea	(DemoDataPtr).l,a1			; load demo data
		moveq	#6,d0					; hardcoded to load the entry for the Special Stage demo
		lsl.w	#2,d0					; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1				; get demo pointer for current level
		move.b	1(a1),(v_btnpushtime2).w		; load initial demo key press duration
		subq.b	#1,(v_btnpushtime2).w			; subtract 1 from demo key pressduration

		clr.w	(v_rings).w				; clear rings
		clr.b	(v_lifecount).w				; clear extra lives flags when getting 100/200 rings

		move.w	#0,(v_debuguse).w			; exit debug mode if necessary
		move.w	#1800,(v_generictimer).w		; run regular demos for 30 seconds
		tst.b	(f_debugcheat).w			; has debug cheat been entered?
		beq.s	SS_NoDebug				; if not, branch
		btst	#bitA,(v_jpadhold1).w			; is A button held?
		beq.s	SS_NoDebug				; if not, branch
		move.b	#1,(f_debugmode).w			; enable debug mode

SS_NoDebug:
		enable_display					; enable screen out-put
		bsr.w	PaletteWhiteIn				; fade-in from white

; ---------------------------------------------------------------------------
; Special Stage main loop
; ---------------------------------------------------------------------------

SS_MainLoop:
		bsr.w	PauseGame				; handle pausing the game when pressing start
		move.b	#id_VBlank_SpecialStage,(v_vblank_routine).w ; set VBlank routine to $0A
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		bsr.w	MoveSonicInDemo				; simulate controls in demos (immediately returns outside demos)
		move.w	(v_jpadhold1).w,(v_jpadhold2).w		; copy controller 1 inputs to Sonic player object inputs

		jsr	(ExecuteObjects).l			; execute Special Stage object
		jsr	(BuildSprites).l			; build sprites
		jsr	(SS_ShowLayout).l			; render Special Stage layout
		bsr.w	SS_BGAnimate				; animate Special Stage background

		tst.w	(f_demo).w				; is demo mode on?
		beq.s	SS_ChkEnd				; if not, branch
		tst.w	(v_generictimer).w			; is there time left on the demo?
		beq.w	SS_ToSegaScreen				; if not, return to Sega screen

SS_ChkEnd:
		cmpi.b	#id_Special,(v_gamemode).w		; is game mode still the Special Stage?
		beq.w	SS_MainLoop				; if yes, loop game mode
; ---------------------------------------------------------------------------

		; Exiting Special Stage...
		tst.w	(f_demo).w				; are we exiting from a demo?
	if Revision=0
		bne.w	SS_ToSegaScreen				; if yes, return to Sega Screen
	else
		; REV01 added a small convenience improvement by returning straight
		; to the title screen when pressing start during the Special Stage demo,
		; rather than always being forced back to the Sega screen.
		bne.w	SS_ToNextScreen				; if yes, return to next game mode
	endif

		move.b	#id_Level,(v_gamemode).w		; set screen mode to $0C (level)
		cmpi.w	#id_FZ+1,(v_zone_act).w			; is level number higher than FZ (0502)?
		blo.s	SS_Finish				; if not, branch
		clr.w	(v_zone_act).w				; set to GHZ1 (possibly as a failsafe)


SS_Finish:
		move.w	#60,(v_generictimer).w			; run fade-out for one second
		move.w	#$003F,(v_pfade_start).w		; set palette fade-out position and size
		clr.w	(v_palchgspeed).w			; do first palette brightening immediately

SS_FinLoop:
		move.b	#id_VBlank_Continue,(v_vblank_routine).w ; set VBlank routine to $16 (uses the same one as the continue screen)
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		bsr.w	MoveSonicInDemo				; continue updating demo controls during fade-out
		move.w	(v_jpadhold1).w,(v_jpadhold2).w		; continue copying 1P inputs to Sonic object (even though controls are locked...)
		jsr	(ExecuteObjects).l			; continue executing objects during fade-out
		jsr	(BuildSprites).l			; continue building sprites during fade-out
		jsr	(SS_ShowLayout).l			; continue rendering Special Stage layout
		bsr.w	SS_BGAnimate				; continue to animate background

		subq.w	#1,(v_palchgspeed).w			; decrement palette fade-out delay
		bpl.s	SS_FinLoop_NoBrighten			; if time remains, branch
		move.w	#2,(v_palchgspeed).w			; reset palette fade-out delay
		bsr.w	WhiteOut_ToWhite			; brighten palette further

; loc_47D4:
SS_FinLoop_NoBrighten:
		tst.w	(v_generictimer).w			; has fade-out loop finished?
		bne.s	SS_FinLoop				; if not, loop
; ---------------------------------------------------------------------------

		; Fade-out done, load Special Stage Results screen
		disable_ints					; disable interrupts
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_planesize|%000001,(a6)		; 64-cell hscroll size
		bsr.w	ClearScreen				; wipe screen

		locVRAM	ArtTile_Title_Card*tile_size		; set VRAM location for title card font
		lea	(Nem_TitleCard).l,a0			; load title card patterns
		bsr.w	NemDec					; decompress Nemesis-compressed graphics directly to VRAM

		jsr	(Hud_Base).l				; load basic HUD graphics
		enable_ints					; enable interrupts

		moveq	#palid_SSResult,d0			; load Special Stage results screen palette...
		bsr.w	PalLoad					; ...directly to active palette
		moveq	#plcid_Main,d0				; load main patterns (rings, etc.)
		bsr.w	NewPLC					; add to new PLC queue
		moveq	#plcid_SSResult,d0			; load Special Stage results screen patterns
		bsr.w	AddPLC					; add to PLC queue

		move.b	#1,(f_scorecount).w			; update score counter
		move.b	#1,(f_endactbonus).w			; update ring bonus counter
		move.w	(v_rings).w,d0				; get rings collected in Special Stage
		mulu.w	#10,d0					; award 100 bonus points per collected ring
		move.w	d0,(v_ringbonus).w			; set rings bonus

		move.w	#bgm_GotThrough,d0			; play end-of-level music
		jsr	(QueueSound2).l	 			; play it

		clearRAM v_objspace				; clear object RAM

		move.b	#id_SSResult,(v_ssrescard).w		; load Special Stage Results screen object
; ---------------------------------------------------------------------------

SS_NormalExit:		; Special Stage results screen loop
		bsr.w	PauseGame				; allow pausing during the results screen
		move.b	#id_VBlank_TitleCards,(v_vblank_routine).w ; set VBlank routine to $0C
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		jsr	(ExecuteObjects).l			; execute SSR objects
		jsr	(BuildSprites).l			; build sprites
		bsr.w	RunPLC					; load SSR patterns
		tst.w	(f_restart).w				; has the SSR object signaled that we can exit?
		beq.s	SS_NormalExit				; if not, loop results screen
		tst.l	(v_plc_buffer).w			; is PLC buffer empty?
		bne.s	SS_NormalExit				; if not, loop (pointless here, SSR object has its own check)
; ---------------------------------------------------------------------------

		; Exit Special Stage normally
		move.w	#sfx_EnterSS,d0				; play special stage exit sound
		bsr.w	QueueSound2 				; play it
		bsr.w	PaletteWhiteOut				; fade-out to white
		rts						; return to MainGameLoop
; ===========================================================================

SS_ToSegaScreen:
		move.b	#id_Sega,(v_gamemode).w			; set game mode to Sega screen
		rts						; return to MainGameLoop
; ===========================================================================

	if Revision<>0
; SS_ToLevel: <-- old misnomer
SS_ToNextScreen:
		cmpi.b	#id_Level,(v_gamemode).w		; was demo exited with the instruction to go to a level next?
		beq.s	SS_ToSegaScreen				; if yes, return to the Sega screen instead (if demo finished)
		rts						; otherwise, go to new game mode (which is the title screen, if demo was aborted)
	endif
; ENd of function GM_Special

; ===========================================================================

; >>> Special Stage background drawing and palette cycle logic
	include	"_inc/Special Stage Background & Palette Cycle.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Continue screen
; ---------------------------------------------------------------------------

; ContinueScreen:
GM_Continue:
		bsr.w	PaletteFadeOut				; fade-out palette from previous game mode

		disable_ints					; disable interrupts
		disable_display					; disable screen output
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_bgcolor|0<<4|0,(a6)		; background colour
		bsr.w	ClearScreen				; wipe screen

		clearRAM v_objspace				; clear object RAM

		locVRAM	ArtTile_Title_Card*tile_size		; set VRAM location for title card patterns
		lea	(Nem_TitleCard).l,a0			; load title card patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Continue_Sonic*tile_size	; set VRAM location for Sonic on the continue screen
		lea	(Nem_ContSonic).l,a0			; load Sonic patterns
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Mini_Sonic*tile_size		; set VRAM location for the mini Sonic icons
		lea	(Nem_MiniSonic).l,a0			; load mini Sonic icons
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		moveq	#10,d1					; draw continue screen countdown to start with digits 10
		jsr	(ContScrCounter).l			; initialize countdown

		moveq	#palid_Continue,d0			; load continue screen palette...
		bsr.w	PalLoad_Fade				; ...into fade-in buffer
		move.b	#bgm_Continue,d0			; play continue screen music
		bsr.w	QueueSound1				; play it

		move.w	#(11*60)-1,(v_generictimer).w		; show continue screen for 11 seconds in total

		clr.l	(v_screenposx).w			; clear X-camera position
		move.l	#$1000000,(v_screenposy).w		; set Y-camera position to $100

		move.b	#id_ContSonic,(v_player).w		; load continue screen Sonic object
		move.b	#id_ContScrItem,(v_continuetext).w	; load continue screen objects (text and misc elements)
		move.b	#id_ContScrItem,(v_continuelight).w	; load floor light object Sonic is laying on
		move.b	#3,(v_continuelight+obPriority).w	; set priority to be behind Sonic
		move.b	#4,(v_continuelight+obFrame).w		; set correct frame for the light
		move.b	#id_ContScrItem,(v_continueicon).w	; load continue icons object
		move.b	#4,(v_continueicon+obRoutine).w		; set to continue icons routine

		jsr	(ExecuteObjects).l			; initialize objects
		jsr	(BuildSprites).l			; build sprites
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		enable_display					; enable screen output
		bsr.w	PaletteFadeIn				; fade-in palette

; ---------------------------------------------------------------------------
; Continue screen main loop
; ---------------------------------------------------------------------------

Cont_MainLoop:
		move.b	#id_VBlank_Continue,(v_vblank_routine).w ; set VBlank routine to $16
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		cmpi.b	#6,(v_player+obRoutine).w		; has continue screen Sonic object signaled that we want to continue?
		bhs.s	Cont_NoCountdown			; if yes, stop updating countdown timer

		disable_ints					; disable interrupts
		move.w	(v_generictimer).w,d1			; get remaining time for countdown (in frames)
		divu.w	#60,d1					; divide by 60 to get remaining time in seconds
		andi.l	#$F,d1					; mask off remainder and anything except the end digit
		jsr	(ContScrCounter).l			; update countdown digits
		enable_ints					; enable interrupts again
; loc_4DF2:
Cont_NoCountdown:
		jsr	(ExecuteObjects).l			; execute continue screen objects
		jsr	(BuildSprites).l			; build sprites

		cmpi.w	#320+64,(v_player+obX).w		; has Sonic run off screen after using a continue?
		bhs.s	Cont_GotoLevel				; if yes, return to level and continue game
		cmpi.b	#6,(v_player+obRoutine).w		; has continue screen Sonic object signaled that we want to continue?
		bhs.s	Cont_MainLoop				; if yes, Sonic is still running off-screen, loop until he is gone
		tst.w	(v_generictimer).w			; has countdown run out?
		bne.w	Cont_MainLoop				; if not, loop game mode

		; Continue wasn't used. Game Over.
		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		rts						; return to MainGameLoop
; ===========================================================================

Cont_GotoLevel:
		move.b	#id_Level,(v_gamemode).w		; set screen mode to $0C (level)
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0					; clear d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		move.b	d0,(v_lastlamp).w			; clear lamppost count
		subq.b	#1,(v_continues).w			; subtract 1 from continues
		rts						; return to MainGameLoop
; End of function GM_Continue

; ===========================================================================

; >>> Objects for the continue screen
	include	"_incObj/80, 81 Continue Screen Elements and Sonic.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence in Green Hill Zone. This is essentially a stripped-down
; copy-paste of regular levels with lots of hardcoding.
; ---------------------------------------------------------------------------

; EndingSequence:
GM_Ending:
		; fading out from previous game mode
		move.b	#bgm_Stop,d0				; set stop music command
		bsr.w	QueueSound2				; stop music
		bsr.w	PaletteFadeOut				; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		clearRAM v_objspace				; clear object RAM
		clearRAM v_misc_variables			; clear various miscellaneous RAM
		clearRAM v_levelvariables			; clear level variables RAM (camera position, etc.)
		clearRAM v_timingandscreenvariables		; clear various timing and screen RAM (for animated tiles, etc.)

		disable_ints					; disable interrupts
		disable_display					; disable screen output
		bsr.w	ClearScreen				; wipe the screen
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_spritevram|(vram_sprites>>9),(a6)	; set sprite table address
		move.w	#vreg_planesize|%000001,(a6)		; 64-cell hscroll size
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_bgcolor|2<<4|0,(a6)		; set background colour (line 3; colour 0)
		move.w	#vreg_hintrate|223,(v_hblank_hreg).w	; set palette change position (for water)
		move.w	(v_hblank_hreg).w,(a6)			; write to VDP
		move.w	#30,(v_air).w				; replenish air

		move.w	#id_EndZ_good,(v_zone_act).w		; set to good ending by default (level number 600, extra flowers)
		cmpi.b	#ss_emeralds_num,(v_emeralds).w		; do you have all 6 emeralds?
		beq.s	End_LoadData				; if yes, use good ending
		move.w	#id_EndZ_bad,(v_zone_act).w		; otherwise, set to bad ending (level number 601, no extra flowers)

End_LoadData:
		moveq	#plcid_Ending,d0			; load ending sequence patterns (GHZ art, animals, etc.)
		bsr.w	QuickPLC				; execute PLCs immediately (no queue)
		jsr	(Hud_Base).l				; load basic HUD graphics (only in levels, not in the ending demos)
		bsr.w	LevelSizeLoad				; load level size and set default level boundaries
		bsr.w	DeformLayers				; initialize background deformation
		bset	#2,(v_fg_scroll_flags).w		; draw an extra column at the left side of the screen during level start
		bsr.w	LevelDataLoad				; load block mappings and palettes
		bsr.w	LoadTilesFromStart			; fully draw the foreground and background once before fade-in
		move.l	#Col_GHZ,(v_collindex).w		; load collision index (hardcoded to GHZ instead of using ColIndexLoad)
		enable_ints					; enable interrupts

		lea	(Kos_EndFlowers).l,a0			; load extra flower patterns
		lea	(v_256x256_def+$4A*chunk_size).w,a1	; set RAM address to be used as decompression buffer (this overwrites unused chunk RAM)
		bsr.w	KosDec					; decompress Kosinski-compressed chunks mappings to buffer

		moveq	#palid_Sonic,d0				; load Sonic's palette...
		bsr.w	PalLoad_Fade				; ...to fade-in buffer
		move.w	#bgm_Ending,d0				; play ending sequence music
		bsr.w	QueueSound1				; play it

	if FixBugs
		; Fix being able to enable debug mode without having entered the cheat code for it
		tst.b	(f_debugcheat).w			; has debug cheat been entered?
		beq.s	End_LoadSonic				; if not, branch
	endif
		btst	#bitA,(v_jpadhold1).w			; was button A held while entering ending sequence?
		beq.s	End_LoadSonic				; if not, branch
		move.b	#1,(f_debugmode).w			; enable debug mode

End_LoadSonic:
		move.b	#id_SonicPlayer,(v_player).w		; load Sonic object
		bset	#0,(v_player+obStatus).w		; make Sonic face left
		move.b	#1,(f_lockctrl).w			; lock controls to keep simulating D-Pad
		move.w	#(btnL<<8),(v_jpadhold2).w		; simulate holding down the left D-Pad button to move Sonic (and clear v_jpadpress2)
		move.w	#-$800,(v_player+obInertia).w		; set Sonic's initial speed (speed cap immediately limits this to -$600)

		move.b	#id_HUD,(v_hud).w			; load HUD object
		jsr	(ObjPosLoad).l				; run the object manager to load level objects
		jsr	(ExecuteObjects).l			; execute all objects in object RAM
		jsr	(BuildSprites).l			; build sprite table

		moveq	#0,d0					; set d0 to 0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.b	d0,(v_lifecount).w			; clear extra lives flags when getting 100/200 rings
		move.b	d0,(v_shield).w				; clear shield
		move.b	d0,(v_invinc).w				; clear invincibility
		move.b	d0,(v_shoes).w				; clear speed shoes
	if UnusedOptimization=0
		move.b	d0,(v_unused1).w			; clear unused flag (goggles?)
	endif
		move.w	d0,(v_debuguse).w			; exit debug mode if necessary
		move.w	d0,(f_restart).w			; clear level restart flag
		move.w	d0,(v_framecount).w			; reset frames since level start to 0
		bsr.w	OscillateNumInit			; initialize oscillation values
		move.b	#1,(f_scorecount).w			; update score counter
		move.b	#1,(f_ringcount).w			; update rings counter
		move.b	#0,(f_timecount).w			; stop time counter for the ending sequence

	if UnusedOptimization=0
		move.w	#1800,(v_generictimer).w		; set generic timer to 30 seconds (unused in ending sequence)
	endif
		move.b	#id_VBlank_Ending,(v_vblank_routine).w	; set VBlank routine to $18
		bsr.w	WaitForVBlank				; wait until VBlank has finished
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		enable_display					; enable screen output
		move.w	#$003F,(v_pfade_start).w		; set palette fade-in position and size	(redundant)
		bsr.w	PaletteFadeIn				; fade-in palette

; ---------------------------------------------------------------------------
; Ending sequence main loop
; ---------------------------------------------------------------------------

End_MainLoop:
		bsr.w	PauseGame				; allow pausing during the ending sequence
		move.b	#id_VBlank_Ending,(v_vblank_routine).w	; set VBlank routine to $18
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		addq.w	#1,(v_framecount).w			; add 1 to level timer

		bsr.w	End_MoveSonic				; control simulated button inputs for Sonic during the cutscene

		jsr	(ExecuteObjects).l			; execute all objects in object RAM
		bsr.w	DeformLayers				; scroll planes and do background deformation
		jsr	(BuildSprites).l			; build sprite table
		jsr	(ObjPosLoad).l				; run the object manager to load level objects
		bsr.w	PaletteCycle				; run palette cycles
		bsr.w	OscillateNumDo				; advance oscillation values
		bsr.w	SynchroAnimate				; advance animation timers

		cmpi.b	#id_Ending,(v_gamemode).w		; is game mode still set to ending sequence?
		beq.s	End_ChkEmerald				; if yes, branch

End_GoToCredits:
		move.b	#id_Credits,(v_gamemode).w		; change game mode to credits
		move.b	#bgm_Credits,d0				; play credits music
		bsr.w	QueueSound2				; play it
		move.w	#0,(v_creditsnum).w			; set credits page number to 0 ("Sonic Team Staff")
		rts						; return to MainGameLoop
; ===========================================================================

End_ChkEmerald:
		tst.w	(f_restart).w				; is level restart flag set? (set while emeralds are spinning in the good ending)
		beq.w	End_MainLoop				; if not, loop ending sequence game mode normally
; ---------------------------------------------------------------------------

		; prepare slow white-in as the emeralds keep spinning in good ending
		clr.w	(f_restart).w				; clear level restart flag
		move.w	#$003F,(v_pfade_start).w		; prepare fade position and size
		clr.w	(v_palchgspeed).w			; trigger the first brightening immediately
; ---------------------------------------------------------------------------


End_AllEmlds:		; during the slow white-in
		bsr.w	PauseGame				; still allow pausing the game
		move.b	#id_VBlank_Ending,(v_vblank_routine).w	; set VBlank routine to $18
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		addq.w	#1,(v_framecount).w			; add 1 to level timer

		bsr.w	End_MoveSonic				; control simulated button inputs for Sonic (redundant at this point)

		jsr	(ExecuteObjects).l			; continue executing objects during white-in
		bsr.w	DeformLayers				; continue upgrading background deformation during white-in
		jsr	(BuildSprites).l			; continue building sprites during white-in
		jsr	(ObjPosLoad).l				; continue running object manager during white-in
		bsr.w	OscillateNumDo				; continue advancing oscillation values during white-in
		bsr.w	SynchroAnimate				; continue advancing animation timers during white-in

		subq.w	#1,(v_palchgspeed).w			; decrement palette white-in delay
		bpl.s	End_SlowFade				; if time remains, branch
		move.w	#2,(v_palchgspeed).w			; reset palette white-in delay
		bsr.w	WhiteOut_ToWhite			; brighten palette further

End_SlowFade:
	if FixBugs
		; Fix a softlock if Sonic somehow dies in the Ending Sequence
		cmpi.b	#6,(v_player+obRoutine).w		; has Sonic died?
		bhs.s	End_GoToCredits				; if yes, abort sequence, go straight to credits
	endif
		tst.w	(f_restart).w				; has flag been set signaling that the emeralds have disappeared?
		beq.w	End_AllEmlds				; if not, loop
; ---------------------------------------------------------------------------

		; screen is fully white and emeralds are gone, update level layout with extra flowers and fade back in
		clr.w	(f_restart).w				; clear level restart flag
		move.w	#$2E2F,(v_lvllayout_fg+layout_row).w	; swap chunks in level layout to the variants with flowers (chunks $2E / $2F) (row 1 / column 0)

		lea	(vdp_control_port).l,a5			; set VDP control port
		lea	(vdp_data_port).l,a6			; set VDP data port
		lea	(v_screenposx).w,a3			; get current foreground X position
		lea	(v_lvllayout_fg).w,a4			; get location in level layout RAM where foreground is stored
		move.w	#$4000,d2				; set VRAM write command to vram_fg nametable start address
		bsr.w	DrawChunks				; update drawn chunks to show the new flowers

		moveq	#palid_Ending,d0			; reload ending palette...
		bsr.w	PalLoad_Fade				; ...to fade-in buffer
		bsr.w	PaletteWhiteIn				; fade-in from white

		bra.w	End_MainLoop				; return to main ending sequence loop for the rest of the scene
; End of function GM_Ending

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence.
; 
; Many aspects of the game use the concept of a state machine.
; If you are interested and want to learn more, these are Mealy and Moore machines
; which have plenty of resources to teach you! This subroutine is a Moore machine.
; Once you understand these concepts, Sonic 1's game logic will make a lot more sense to you!
; ---------------------------------------------------------------------------

End_MoveSonic:
		move.b	(v_sonicend).w,d0			; get ending cutscene routine number
		bne.s	End_MoveSon2				; if it's non-zero, branch to second script

		cmpi.w	#(320/2)-16,(v_player+obX).w		; has Sonic passed $90 on the X-axis (from the right)?
		bhs.s	End_MoveSonExit				; if not, branch

		addq.b	#2,(v_sonicend).w			; advance ending cutscene routine number
		move.b	#1,(f_lockctrl).w			; lock player's controls (redundant, already locked)
		move.w	#(btnR<<8),(v_jpadhold2).w		; simulate holding down the right D-Pad button to trigger skidding animation
		rts						; return
; ===========================================================================

End_MoveSon2:
		subq.b	#2,d0					; subtract 2 from cutscene routine number
		bne.s	End_MoveSon3				; if it's still non-zero, branch to third script

		cmpi.w	#320/2,(v_player+obX).w			; has Sonic passed $A0 on the X-axis (from the left)?
		blo.s	End_MoveSonExit				; if not, branch

		addq.b	#2,(v_sonicend).w			; advance ending cutscene routine number
		moveq	#0,d0					; clear d0
		move.b	d0,(f_lockctrl).w			; unlock controls (no effect, see below)
		move.w	d0,(v_jpadhold2).w			; clear simulated button inputs to stop Sonic moving
		move.w	d0,(v_player+obInertia).w		; clear ground speed to make Sonic stop immediately
		move.b	#$81,(f_playerctrl).w			; set control ignore and disabled object interaction flags

		move.b	#fr_Wait2,(v_player+obFrame).w		; force Sonic to a specific waiting frame
		move.w	#(id_Wait<<8)+id_Wait,(v_player+obAnim).w ; use "standing" animation and prevent it from getting immediately restarted
		move.b	#3,(v_player+obTimeFrame).w		; set a bit of an animation interval so Sonic keeps looking when he gets replaced on the next frame
		rts						; return
; ===========================================================================

End_MoveSon3:
		subq.b	#2,d0					; subtract 2 from cutscene routine number
		bne.s	End_MoveSonExit				; if it's still non-zero, the below code has already run, branch to do nothing anymore

		addq.b	#2,(v_sonicend).w			; advance ending cutscene routine number
		move.w	#320/2,(v_player+obX).w			; force Sonic to the middle of the screen
		move.b	#id_EndSonic,(v_player).w		; replace real Sonic object with a fake ending sequence Sonic object
		clr.w	(v_player+obRoutine).w			; reset routine counter to initialize fake ending Sonic

End_MoveSonExit:
		rts						; return
; End of function End_MoveSonic

; ===========================================================================

; >>> Objects on the ending sequence
	include	"_incObj/87, 88, 89 Ending Sequence Sonic, Emeralds, Logo.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Credits ending sequence. This game mode works in tandem with the regular
; demo game mode, with both redirecting to here after their respective timer
; has expired. The variable v_creditsnum for the current page is deliberately
; located near the end of RAM so it doesn't get cleared during mode change.
; ---------------------------------------------------------------------------

; CreditsScreen:
GM_Credits:
		; fading out from previous game mode (music gets already started before this)
		bsr.w	ClearPLC				; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut				; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_planesize|%000001,(a6)		; 64-cell hscroll size
		move.w	#vreg_winypos|0,(a6)			; window vertical position
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_bgcolor|2<<4|0,(a6)		; set background colour (line 3; colour 0)
		clr.b	(f_wtr_state).w				; clear water state
		bsr.w	ClearScreen				; wipe the screen

		clearRAM v_objspace				; clear object RAM

		locVRAM	ArtTile_Credits_Font*tile_size		; set target VRAM location for credits font
		lea	(Nem_CreditText).l,a0			; load credits font
		bsr.w	NemDec					; decompress Nemesis-compressed patterns directly to VRAM

		clearRAM v_palette_fading			; set palette fade-in buffer to all-black
		moveq	#palid_Sonic,d0				; load Sonic's palette...
		bsr.w	PalLoad_Fade				; ...into fade-in buffer

		move.b	#id_CreditsText,(v_credits).w		; load credits text object
		jsr	(ExecuteObjects).l			; execute objects to load credits text object
		jsr	(BuildSprites).l			; build sprites for the credits text object

		bsr.w	EndingDemoLoad				; prepare loading the next ending demo

		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get zone ID for next credits demo
		lsl.w	#4,d0					; multiply by $10 (number of bytes per level header entry)
		lea	(LevelHeaders).l,a2			; load level headers
		lea	(a2,d0.w),a2				; get relevant header for next credits demo
		moveq	#0,d0					; clear d0
		move.b	(a2),d0					; get first PLC entry
		beq.s	Cred_SkipObjGfx				; if it's null, branch (never the case)
		bsr.w	AddPLC					; load level patterns for next credits demo

Cred_SkipObjGfx:
		moveq	#plcid_Main2,d0				; load secondary standard patterns
		bsr.w	AddPLC					; (monitors, etc.)
; ---------------------------------------------------------------------------

		; fade-in palette and enter wait loop
		move.w	#120,(v_generictimer).w			; display a single credits page for 2 seconds
		bsr.w	PaletteFadeIn				; fade-in palette

; ---------------------------------------------------------------------------
; Credits page main loop (only shown for 2 seconds)
; ---------------------------------------------------------------------------

Cred_WaitLoop:		; while a credits page is displayed and graphics are getting decompressed
		move.b	#id_VBlank_Title,(v_vblank_routine).w	; set VBlank routine to $04 (uses the same one as the title screen)
		bsr.w	WaitForVBlank				; wait until VBlank has finished

		bsr.w	RunPLC					; decompress level graphics

		tst.w	(v_generictimer).w			; have at least 2 seconds elapsed?
		bne.s	Cred_WaitLoop				; if not, loop
		tst.l	(v_plc_buffer).w			; have 2 seconds elapsed but level gfx have not finished decompressing?
		bne.s	Cred_WaitLoop				; if yes, still loop until graphics are finished
; ---------------------------------------------------------------------------

		; credits page has finished displaying, go to next game mode
		cmpi.w	#9,(v_creditsnum).w			; are we past the final credits page?
		beq.w	TryAgainEnd				; if yes, go to Try Again/End screen instead
		rts						; otherwise, return to MainGameLoop to enter Demo mode
; End of function GM_Credits

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence demo loading subroutine
; ---------------------------------------------------------------------------

EndingDemoLoad:
		move.w	(v_creditsnum).w,d0			; get current credits page
		andi.w	#$F,d0					; limit to 16 possible entries (redundant)
		add.w	d0,d0					; double for word-based indexing
		move.w	EndDemo_Levels(pc,d0.w),d0		; get relevant zone and act for the next credits demo
		move.w	d0,(v_zone_act).w			; set level from level array

		addq.w	#1,(v_creditsnum).w			; increase credits page number for next time
		cmpi.w	#9,(v_creditsnum).w			; are we past the final credits page now?
		bhs.s	EndDemo_Exit				; if yes, don't load another demo

		move.w	#$8001,(f_demo).w 			; set demo mode to its credits/ending variant
		move.b	#id_Demo,(v_gamemode).w			; set game mode to demo (activates once credits page has finished)

		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0					; set d0 to 0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		move.b	d0,(v_lastlamp).w			; clear lamppost counter

		cmpi.w	#4,(v_creditsnum).w			; is specifically the 4th demo about to run? (SLZ demo)
		bne.s	EndDemo_Exit				; if not, branch
		lea	(EndDemo_LampVar).l,a1			; load special lamppost variables for SLZ demo
		lea	(v_lastlamp).w,a2			; write to lamppost buffer
		move.w	#(EndDemo_LampVar_End-EndDemo_LampVar)/4-1,d0 ; write for all entries
EndDemo_LampLoad:
		move.l	(a1)+,(a2)+				; copy lamppost variables for SLZ demo
		dbf	d0,EndDemo_LampLoad			; loop until everything is loaded

EndDemo_Exit:
		rts						; return
; End of function EndingDemoLoad

; ---------------------------------------------------------------------------
; Levels used in the end sequence demos
; ---------------------------------------------------------------------------

EndDemo_Levels:		; previously in "misc/Demo Level Order - Ending.bin"
		dc.w id_GHZ_act1
		dc.w id_MZ_act2
		dc.w id_SYZ_act3
		dc.w id_LZ_act3
		dc.w id_SLZ_act3
		dc.w id_SBZ_act1
		dc.w id_SBZ_act2
		dc.w id_GHZ_act1
		even

; ---------------------------------------------------------------------------
; Lamppost variables in the Star Light Zone credits demo
; ---------------------------------------------------------------------------
EndDemo_LampVar:
		dc.b 1,	1					; number of the last lamppost
		dc.w $A00, $62C					; x/y-axis position
		dc.w 13						; rings
		dc.l 0						; time
		dc.b 0,	0					; dynamic level event routine counter
		dc.w $800					; level bottom boundary
		dc.w $957, $5CC					; x/y axis screen position
		dc.w $4AB, $3A6, 0, $28C, 0, 0			; scroll info
		dc.w $308					; water height
		dc.b 1,	1					; water routine and state
EndDemo_LampVar_End:
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; "TRY AGAIN" screen (bad ending) and "END" screen (good ending). This is
; essentially a full game mode, although it's not called from the main
; game mode array, but rather directly from the credits.
; ---------------------------------------------------------------------------

; TryAgainScreen:
TryAgainEnd:		; fading out from previous game mode
		bsr.w	ClearPLC				; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut				; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)		; set background nametable address
		move.w	#vreg_planesize|%000001,(a6)		; 64-cell hscroll size
		move.w	#vreg_winypos|0,(a6)			; window vertical position
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_bgcolor|2<<4|0,(a6)		; set background colour (line 3; colour 0)
		clr.b	(f_wtr_state).w				; clear water state
		bsr.w	ClearScreen				; wipe the screen

		clearRAM v_objspace				; clear object RAM

		moveq	#plcid_TryAgain,d0			; load "TRY AGAIN" and "END" patterns
		bsr.w	QuickPLC				; execute PLCs immediately (no queue)

		clearRAM v_palette_fading			; set palette fade-in buffer to all-black
		moveq	#palid_Ending,d0			; load ending palette...
		bsr.w	PalLoad_Fade				; ...to fade-in buffer
		clr.w	(v_palette_fading_line_3).w		; ensure the backdrop color is black

		move.b	#id_EndEggman,(v_endeggman).w		; load end Eggman object
		jsr	(ExecuteObjects).l			; execute objects to load end objects
		jsr	(BuildSprites).l			; build sprites for end objects
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		move.w	#1800,(v_generictimer).w		; automatically return to Sega screen after 30 seconds
		bsr.w	PaletteFadeIn				; fade-in palette

; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END" screen main loop
; ---------------------------------------------------------------------------

TryAg_MainLoop:
		bsr.w	PauseGame				; allow to pause game (redundant, start exits the screen)
		move.b	#id_VBlank_Title,(v_vblank_routine).w	; set VBlank routine to $04 (uses the same one as the title screen)
		bsr.w	WaitForVBlank				; wait until VBlank has finished

		jsr	(ExecuteObjects).l			; update end objects
		jsr	(BuildSprites).l			; build sprites for end objects

		andi.b	#btnStart,(v_jpadpress1).w		; has Start button been pressed?
		bne.s	TryAg_Exit				; if yes, exit end screen
		tst.w	(v_generictimer).w			; have 30 seconds elapsed?
		beq.s	TryAg_Exit				; if yes, exit end screen
		cmpi.b	#id_Credits,(v_gamemode).w		; is game mode still set to show the end screen?
		beq.s	TryAg_MainLoop				; if yes, loop
; ---------------------------------------------------------------------------

TryAg_Exit:		; exit end screen and restart the gam
		move.b	#id_Sega,(v_gamemode).w			; set game mode to Sega screen
		rts						; return to MainGameLoop
; End of function TryAgainEnd
; ===========================================================================

; >>> Objects on final screen
	include	"_incObj/8B, 8C Try Again, End Eggman, End Emeralds.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence demos
; ---------------------------------------------------------------------------

Demo_EndGHZ1:	include	"demodata/Ending - GHZ1.asm"
Demo_EndMZ:	include	"demodata/Ending - MZ.asm"
Demo_EndSYZ:	include	"demodata/Ending - SYZ.asm"
Demo_EndLZ:	include	"demodata/Ending - LZ.asm"
Demo_EndSLZ:	include	"demodata/Ending - SLZ.asm"
Demo_EndSBZ1:	include	"demodata/Ending - SBZ1.asm"
Demo_EndSBZ2:	include	"demodata/Ending - SBZ2.asm"
Demo_EndGHZ2:	include	"demodata/Ending - GHZ2.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; >> END OF MAIN GAME LOGIC - Everything below this point is file includes <<
; ---------------------------------------------------------------------------
; ===========================================================================


; Where possible, includes to _maps and _anim were appended to the _incObj
; file includes themselves. However, in some cases this wasn't possible,
; as the developers weren't very consistent with the placement, especially
; during the early stages of production. Those includes are still here.


; ===========================================================================
; >>> Level rendering, loading, and updating
		include	"_inc/LevelSizeLoad & BgScrollSpeed.asm" ; merged with "LevelSizeLoad & BgScrollSpeed (JP1).asm"
	if Revision=0
		include	"_inc/DeformLayers (REV00).asm"
		include	"_inc/Level Drawing (REV00).asm"
	else
		include	"_inc/DeformLayers (REV01).asm"
		include	"_inc/Level Drawing (REV01).asm"
	endif
		include	"_inc/LevelLayoutLoad.asm" ; includes LevelDataLoad, LevelLayoutLoad, and LevelLayoutLoad2

		include	"_inc/DynamicLevelEvents.asm"


; ===========================================================================
; >>> Various level objects
		include	"_incObj/11 GHZ Bridge.asm"
		include	"_incObj/15 Swinging Platforms.asm" ; includes "MvSonicOnPtfm" subroutine
		include	"_incObj/17 GHZ Spiked Pole Helix.asm"
		include	"_incObj/18 Platforms.asm"
	if UnusedOptimization=0
		include	"_incObj/19 Unused - GHZ Ball.asm" ; this was the rolling GHZ ball in the prototype
	endif
Map_GBall:	include	"_maps/GHZ Ball.asm"
		include	"_incObj/1A, 53 Collapsing Ledges and Floors.asm" ; includes "SlopeObject_AssumeStoodOn" subroutine
		include	"_incObj/1C GHZ, SYZ Scenery.asm"
		include	"_incObj/1D Unused - Switch.asm"
		include	"_incObj/2A SBZ Small Door.asm"
		include	"_incObj/sub SolidWall.asm"


; ===========================================================================
; >>> Badniks, explosions, and Badnik-related objects
		include	"_incObj/1E, 20 Badnik - Ball Hog and Cannonball.asm"
	if UnusedOptimization=0
		include	"_incObj/24 Unused - Small Explosion.asm"
	endif
		include	"_incObj/27, 3F Explosions.asm"
		include	"_anim/Ball Hog.asm"
Map_Hog:	include	"_maps/Ball Hog.asm"
	if UnusedOptimization=0
Map_UnkExplode:	include	"_maps/Unused Explosion.asm"
	endif
		include	"_maps/Explosions.asm"
		include	"_incObj/28, 29 Animals and Points.asm"
		include	"_incObj/1F Badnik - Crabmeat.asm"
		include	"_incObj/22, 23 Badnik - Buzz Bomber and Missile.asm"


; ===========================================================================
; >>> Rings
		include	"_incObj/25, 37 Rings.asm"
		include	"_incObj/4B, 7C Giant Ring and Flash.asm"
		include	"_anim/Rings.asm"
Map_Ring:   if Revision=0
		include	"_maps/Rings (REV00).asm"
	    else
		; REV01 added an extra blank frame, possibly to mitigate
		; rings occasionally popping up in the sign post sparkles
		include	"_maps/Rings (REV01).asm"
	    endif
Map_GRing:	include	"_maps/Giant Ring.asm"
Map_Flash:	include	"_maps/Ring Flash.asm"


; ===========================================================================
; >>> Monitors
		include	"_incObj/26, 2E Monitors and Power-Ups.asm"


; ===========================================================================
; >>> Title screen objects (includes AnimateSprite)
		include	"_incObj/0E, 0F Title Screen - Sonic, Press Start, TM.asm"


; ===========================================================================
; >>> More Badniks and level objects
		include	"_incObj/2B Badnik - Chopper.asm"
		include	"_incObj/2C Badnik - Jaws.asm"
		include	"_incObj/2D Badnik - Burrobot.asm"
		include	"_incObj/2F, 35 MZ Large Grassy Platforms and Burning Grass.asm"
Map_Fire:	include	"_maps/Fireballs.asm"
		include	"_incObj/30 MZ Large Green Glass Blocks.asm"
		include	"_incObj/31 MZ Chained Stompers.asm"
	if UnusedOptimization=0
		include	"_incObj/45 Unused - MZ Sideways Stomper.asm"
	endif
Map_CStom:	include	"_maps/Chained Stompers.asm"
	if UnusedOptimization=0
Map_SStom:	include	"_maps/Sideways Stomper.asm"
	endif
		include	"_incObj/32 Button.asm"
		include	"_incObj/33 MZ, LZ Pushable Blocks.asm"


; ===========================================================================
; >>> Title card objects
		include	"_incObj/34 Title Cards.asm"
		include	"_incObj/39 Game Over.asm"
		include	"_incObj/3A Got Through Card.asm"
		include	"_incObj/7E, 7F Special Stage Results and Chaos Emeralds.asm"
		include	"_maps/Title Cards.asm" ; includes "Map_Card", "Map_Over", "Map_Got", and "Map_SSR"
Map_SSRC:	include	"_maps/SS Result Chaos Emeralds.asm"


; ===========================================================================
; >>> More level objects
		include	"_incObj/36 Spikes.asm"
		include	"_incObj/3B GHZ Purple Rock.asm"
		include	"_incObj/49 GHZ Waterfall Sound.asm"
Map_PRock:	include	"_maps/Purple Rock.asm"
		include	"_incObj/3C GHZ, SLZ Smashable Wall.asm" ; includes SmashObject


; ===========================================================================
; Subroutines to run, render, and update objects
		include	"_inc/Objects.asm"


; ===========================================================================
; >>> More level objects
		include	"_incObj/41 Springs.asm"
		include	"_incObj/42 Badnik - Newtron.asm"
		include	"_incObj/43 Badnik - Roller.asm"
		include	"_incObj/44 GHZ Edge Walls.asm"
		include	"_incObj/13, 14 MZ, SLZ Fire Balls and Maker.asm"
		include	"_incObj/6D SBZ Flamethrower.asm"
		include	"_incObj/46 MZ Bricks.asm"
		include	"_incObj/12 SYZ Search Light.asm"
		include	"_incObj/47 SYZ Bumper.asm"
		include	"_incObj/0D Signpost.asm" ; includes "GotThroughAct" subroutine
		include	"_incObj/4C, 4D MZ Lava Geyser and Maker.asm"
		include	"_incObj/4E MZ Wall of Lava.asm"
		include	"_incObj/54 MZ Invisible Lava Tag.asm"
		include	"_anim/Lava Geyser.asm"
		include	"_anim/Wall of Lava.asm"
Map_Geyser:	include	"_maps/Lava Geyser.asm"
Map_LWall:	include	"_maps/Wall of Lava.asm"
		include	"_incObj/40 Badnik - Moto Bug.asm" ; includes "_incObj/sub RememberState.asm" subroutine
	if UnusedOptimization=0
		include	"_incObj/4F Unused - Splats.asm" ; this was Splats in the prototype
	endif
		include	"_incObj/50 Badnik - Yadrin.asm"
		include	"_incObj/sub SolidObject.asm"
		include	"_incObj/51 MZ Smashable Green Block.asm"
		include	"_incObj/52 Moving Blocks.asm"
		include	"_incObj/55 Badnik - Basaran.asm"
		include	"_incObj/56 SYZ, SLZ Floating Blocks and LZ Doors.asm"
		include	"_incObj/57 SYZ, LZ Spiked Ball and Chain.asm"
		include	"_incObj/58 SYZ Big Spiked Ball.asm"
		include	"_incObj/59 SLZ Elevators.asm"
		include	"_incObj/5A SLZ Circling Platform.asm"
		include	"_incObj/5B SLZ Staircase.asm"
		include	"_incObj/5C SLZ Foreground Pylon.asm"
		include	"_incObj/1B LZ Water Surface.asm"
		include	"_incObj/0B LZ Pole that Breaks.asm"
		include	"_incObj/0C LZ Flapping Door.asm"
		include	"_incObj/71 Invisible Solid Barriers.asm"
		include	"_incObj/5D SLZ Fan.asm"
		include	"_incObj/5E SLZ Seesaw.asm"
		include	"_incObj/5F Badnik - Walking Bomb.asm"
		include	"_incObj/60 Badnik - Orbinaut.asm"
		include	"_incObj/16 LZ Harpoon.asm"
		include	"_incObj/61 LZ Blocks.asm"
		include	"_incObj/62 LZ Gargoyle.asm"
		include	"_incObj/63 LZ Conveyor.asm"
		include	"_incObj/64 LZ Air Bubbles.asm"
		include	"_incObj/65 LZ Waterfalls.asm"


; ===========================================================================
; >>> Main Sonic player object
		include	"_incObj/01 Sonic.asm"


; ===========================================================================
; >>> Various unique objects
		include	"_incObj/0A LZ Drowning Countdown.asm" ; includes ResumeMusic
		include	"_incObj/38 Shield and Invincibility.asm"
	if UnusedOptimization=0
		include	"_incObj/4A Unused - Special Stage Entry.asm"
	endif
		include	"_incObj/08 LZ Water Splash.asm"
		include	"_anim/Shield and Invincibility.asm"
Map_Shield:	include	"_maps/Shield and Invincibility.asm"
	if UnusedOptimization=0
		include	"_anim/Special Stage Entry (Unused).asm"
Map_Vanish:	include	"_maps/Special Stage Entry (Unused).asm"
	endif
		include	"_anim/Water Splash.asm"
Map_Splash:	include	"_maps/Water Splash.asm"


; ===========================================================================
; >>> Collision subroutines for Sonic and other objects
		include	"_inc/Collision.asm"


; ===========================================================================
; >>> SBZ level objects
		include	"_incObj/66 SBZ Rotating Junction.asm"
		include	"_incObj/67 SBZ Running Disc.asm"
		include	"_incObj/68 SBZ Conveyor Belt.asm"
		include	"_incObj/69 SBZ Spinning Platforms and Trapdoors.asm"
		include	"_incObj/6A SBZ Saws and Pizza Cutters.asm"
		include	"_incObj/6B SBZ Stomper and Sliding Door.asm"
		include	"_incObj/6C SBZ Vanishing Platforms.asm"
		include	"_incObj/6E SBZ Electrocuter.asm"
		include	"_incObj/6F SBZ Spin Platform Conveyor.asm"
		include	"_incObj/70 SBZ Girder Block.asm"
		include	"_incObj/72 SBZ Teleporter.asm"

; ===========================================================================
; >>> Misc objects
		include	"_incObj/78 Badnik - Caterkiller.asm"
		include	"_incObj/79 Lamppost.asm"
		include	"_incObj/7D Hidden Bonuses.asm"
		include	"_incObj/8A Credits and Sonic Team Presents.asm"


; ===========================================================================
; >>> Bosses and related objects
		include	"_incObj/3D, 48 Boss - GHZ Main and Wrecking Ball.asm" ; includes "BossDefeated" and "BossMove" subroutines
		include	"_anim/Eggman.asm"
Map_Eggman:	include	"_maps/Eggman.asm"
Map_BossItems:	include	"_maps/Boss Items.asm"
		include	"_incObj/77 Boss - LZ Main.asm"
		include	"_incObj/73, 74 Boss - MZ Main and Fire.asm"
		include	"_incObj/7A, 7B Boss - SLZ Main and Spike Balls.asm"
		include	"_incObj/75, 76 Boss - SYZ Main and Blocks.asm"
		include	"_incObj/82, 83 SBZ Eggman Cutscene and Crumbling Floor.asm"
		include	"_incObj/85,84,86 Boss - FZ Main, Cylinders, and Plasma Balls.asm"
		include	"_incObj/3E Prison Capsule.asm"


; ===========================================================================
; >>> Object-to-object touch response handler for Sonic
		include	"_incObj/Sonic ReactToItem.asm"


; ===========================================================================
; >>> Special Stage rendering and objects
		; The following includes "SS_ShowLayout", "SS_AniWallsRings",
		; "SS_FindFreeAnimationSlot", "SS_AniItems", and "SS_Load"
		include	"_inc/Special Stage Loading & Drawing.asm"

		include	"_inc/Special Stage Mappings & VRAM Pointers.asm"
Map_SS_Shared:	include	"_maps/SS Shared Block.asm"
Map_SS_Glass:	include	"_maps/SS Glass Block.asm"
Map_SS_Up:	include	"_maps/SS UP Block.asm"
Map_SS_Down:	include	"_maps/SS DOWN Block.asm"
Map_SS_Chaos:	include	"_maps/SS Chaos Emeralds.asm"
		include	"_incObj/09 Sonic in Special Stage.asm"


; ===========================================================================
	if UnusedOptimization=0
; >>> Deleted, blank object that is randomly mixed in here
		include	"_incObj/10 Unused - Animation Test.asm" ; this was an animation test object for Sonic in the prototype
	endif

; ===========================================================================
; >>> Subroutine for in-place level animations in VRAM
		include	"_inc/AnimateLevelGfx.asm"


; ===========================================================================
; >>> HUD objects
		include	"_incObj/21 HUD.asm"
		include	"_incObj/sub AddPoints.asm"
		include	"_inc/HUD Update.asm" ; includes "ContScrCounter" subroutine

Art_Hud:	binclude "artunc/HUD Numbers.unc" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	binclude "artunc/Lives Counter Numbers.unc" ; 8x8 pixel numbers on lives counter
		even


; ===========================================================================
; >>> Debug Mode
		include	"_incObj/DebugMode.asm"


; ===========================================================================
; >>> Level definitions
		include	"_inc/LevelHeaders.asm"
		include	"_inc/Pattern Load Cues.asm"


; ===========================================================================

; ---------------------------------------------------------------------------
; >> END OF PRIMARY INCLUDES - Everything below this point is art includes <<
; ---------------------------------------------------------------------------

		; Nem_SegaLogo has a bunch of padding before it that differs between revisions:
		; - in rev00, it starts at $1DC00, which amounts to $EE bytes
		; - in rev01/rev02, it starts at $1E700, which amounts to $48E bytes
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$200
		if Revision<>0
			dcb.b	$300,$FF
		endif
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Compressed graphics and mappings - Sega screen
; ---------------------------------------------------------------------------
	if Revision=0
Nem_SegaLogo:	binclude	"artnem/Sega Logo (REV00).nem" ; large Sega logo
		even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo (REV00).eni" ; large Sega logo (mappings)
		even
	else
Nem_SegaLogo:	binclude	"artnem/Sega Logo (REV01).nem" ; large Sega logo
		even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo (REV01).eni" ; large Sega logo (mappings)
		even
	endif

; ---------------------------------------------------------------------------
; Compressed graphics and mappings - Title screen
; ---------------------------------------------------------------------------
Eni_Title:	binclude	"tilemaps/Title Screen.eni" ; title screen foreground (mappings)
		even
Nem_TitleFg:	binclude	"artnem/Title Screen Foreground.nem"
		even
Nem_TitleSonic:	binclude	"artnem/Title Screen Sonic.nem"
		even
Nem_TitleTM:	binclude	"artnem/Title Screen TM.nem"
		even
Eni_JapNames:	binclude	"tilemaps/Hidden Japanese Credits.eni" ; Japanese credits (mappings)
		even
Nem_JapNames:	binclude	"artnem/Hidden Japanese Credits.nem"
		even

; ---------------------------------------------------------------------------
; Uncompressed graphics - Sonic
; ---------------------------------------------------------------------------
Map_Sonic:	include	"_maps/Sonic.asm"

SonicDynPLC:	include	"_maps/Sonic - Dynamic Gfx Script.asm"

Art_Sonic:	binclude	"artunc/Sonic.unc"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
	if (Revision=0)&(UnusedOptimization=0)
Nem_Smoke:	binclude	"artnem/Unused - Smoke.nem"
		even
Nem_SyzSparkle:	binclude	"artnem/Unused - SYZ Sparkles.nem"
		even
	endif

Nem_Shield:	binclude	"artnem/Shield.nem"
		even
Nem_Stars:	binclude	"artnem/Invincibility Stars.nem"
		even

	if (Revision=0)&(UnusedOptimization=0)
Nem_LzSonic:	binclude	"artnem/Unused - LZ Sonic.nem" ; Sonic holding his breath
		even
Nem_UnkFire:	binclude	"artnem/Unused - Fireball.nem" ; unused fireball
		even
Nem_Warp:	binclude	"artnem/Unused - SStage Flash.nem" ; entry to special stage flash
		even
Nem_Goggle:	binclude	"artnem/Unused - Goggles.nem" ; unused goggles
		even
	endif

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Map_SSWalls:	include	"_maps/SS Walls.asm"

Nem_SSWalls:	binclude	"artnem/Special Walls.nem" ; special stage walls
		even
Eni_SSBg1:	binclude	"tilemaps/SS Background 1.eni" ; special stage background (mappings)
		even
Nem_SSBgFish:	binclude	"artnem/Special Birds & Fish.nem" ; special stage birds and fish background
		even
Eni_SSBg2:	binclude	"tilemaps/SS Background 2.eni" ; special stage background (mappings)
		even
Nem_SSBgCloud:	binclude	"artnem/Special Clouds.nem" ; special stage clouds background
		even
Nem_SSGOAL:	binclude	"artnem/Special GOAL.nem" ; special stage GOAL block
		even
Nem_SSRBlock:	binclude	"artnem/Special R.nem" ; special stage R block
		even
Nem_SS1UpBlock:	binclude	"artnem/Special 1UP.nem" ; special stage 1UP block
		even
Nem_SSEmStars:	binclude	"artnem/Special Emerald Twinkle.nem" ; special stage stars from a collected emerald
		even
Nem_SSRedWhite:	binclude	"artnem/Special Red-White.nem" ; special stage red/white block
		even
Nem_SSZone1:	binclude	"artnem/Special ZONE1.nem" ; special stage ZONE1 block
		even
Nem_SSZone2:	binclude	"artnem/Special ZONE2.nem" ; ZONE2 block
		even
Nem_SSZone3:	binclude	"artnem/Special ZONE3.nem" ; ZONE3 block
		even
Nem_SSZone4:	binclude	"artnem/Special ZONE4.nem" ; ZONE4 block
		even
Nem_SSZone5:	binclude	"artnem/Special ZONE5.nem" ; ZONE5 block
		even
Nem_SSZone6:	binclude	"artnem/Special ZONE6.nem" ; ZONE6 block
		even
Nem_SSUpDown:	binclude	"artnem/Special UP-DOWN.nem" ; special stage UP/DOWN block
		even
Nem_SSEmerald:	binclude	"artnem/Special Emeralds.nem" ; special stage chaos emeralds
		even
Nem_SSGhost:	binclude	"artnem/Special Ghost.nem" ; special stage ghost block
		even
Nem_SSWBlock:	binclude	"artnem/Special W.nem" ; special stage W block
		even
Nem_SSGlass:	binclude	"artnem/Special Glass.nem" ; special stage destroyable glass block
		even
Nem_ResultEm:	binclude	"artnem/Special Result Emeralds.nem" ; chaos emeralds on special stage results screen
		even

; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:	binclude	"artnem/GHZ Flower Stalk.nem"
		even
Nem_Swing:	binclude	"artnem/GHZ Swinging Platform.nem"
		even
Nem_Bridge:	binclude	"artnem/GHZ Bridge.nem"
		even
	if UnusedOptimization=0
Nem_GhzUnkBlock:binclude	"artnem/Unused - GHZ Block.nem"
		even
	endif
Nem_Ball:	binclude	"artnem/GHZ Giant Ball.nem"
		even
Nem_Spikes:	binclude	"artnem/Spikes.nem"
		even
	if UnusedOptimization=0
Nem_GhzLog:	binclude	"artnem/Unused - GHZ Log.nem"
		even
	endif
Nem_SpikePole:	binclude	"artnem/GHZ Spiked Log.nem"
		even
Nem_PplRock:	binclude	"artnem/GHZ Purple Rock.nem"
		even
Nem_GhzWall1:	binclude	"artnem/GHZ Breakable Wall.nem"
		even
Nem_GhzWall2:	binclude	"artnem/GHZ Edge Wall.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
Nem_Water:	binclude	"artnem/LZ Water Surface.nem"
		even
Nem_Splash:	binclude	"artnem/LZ Water & Splashes.nem"
		even
Nem_LzSpikeBall:binclude	"artnem/LZ Spiked Ball & Chain.nem"
		even
Nem_FlapDoor:	binclude	"artnem/LZ Flapping Door.nem"
		even
Nem_Bubbles:	binclude	"artnem/LZ Bubbles & Countdown.nem"
		even
Nem_LzBlock3:	binclude	"artnem/LZ 32x16 Block.nem"
		even
Nem_LzDoor1:	binclude	"artnem/LZ Vertical Door.nem"
		even
Nem_Harpoon:	binclude	"artnem/LZ Harpoon.nem"
		even
Nem_LzPole:	binclude	"artnem/LZ Breakable Pole.nem"
		even
Nem_LzDoor2:	binclude	"artnem/LZ Horizontal Door.nem"
		even
Nem_LzWheel:	binclude	"artnem/LZ Wheel.nem"
		even
Nem_Gargoyle:	binclude	"artnem/LZ Gargoyle & Fireball.nem"
		even
Nem_LzBlock2:	binclude	"artnem/LZ Blocks.nem"
		even
Nem_LzPlatfm:	binclude	"artnem/LZ Rising Platform.nem"
		even
Nem_Cork:	binclude	"artnem/LZ Cork.nem"
		even
Nem_LzBlock1:	binclude	"artnem/LZ 32x32 Block.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	binclude	"artnem/MZ Metal Blocks.nem"
		even
Nem_MzSwitch:	binclude	"artnem/MZ Switch.nem"
		even
Nem_MzGlass:	binclude	"artnem/MZ Green Glass Block.nem"
		even
	if UnusedOptimization=0
Nem_UnkGrass:	binclude	"artnem/Unused - Grass.nem"
		even
	endif
Nem_MzFire:	binclude	"artnem/Fireballs.nem"
		even
Nem_Lava:	binclude	"artnem/MZ Lava.nem"
		even
Nem_MzBlock:	binclude	"artnem/MZ Green Pushable Block.nem"
		even
	if UnusedOptimization=0
Nem_MzUnkBlock:	binclude	"artnem/Unused - MZ Background.nem"
		even
	endif

; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	binclude	"artnem/SLZ Seesaw.nem"
		even
Nem_SlzSpike:	binclude	"artnem/SLZ Little Spikeball.nem"
		even
Nem_Fan:	binclude	"artnem/SLZ Fan.nem"
		even
Nem_SlzWall:	binclude	"artnem/SLZ Breakable Wall.nem"
		even
Nem_Pylon:	binclude	"artnem/SLZ Pylon.nem"
		even
Nem_SlzSwing:	binclude	"artnem/SLZ Swinging Platform.nem"
		even
Nem_SlzBlock:	binclude	"artnem/SLZ 32x32 Block.nem"
		even
Nem_SlzCannon:	binclude	"artnem/SLZ Cannon.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	binclude	"artnem/SYZ Bumper.nem"
		even
Nem_SyzSpike2:	binclude	"artnem/SYZ Small Spikeball.nem"
		even
Nem_LzSwitch:	binclude	"artnem/Switch.nem"
		even
Nem_SyzSpike1:	binclude	"artnem/SYZ Large Spikeball.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
Nem_SbzWheel1:	binclude	"artnem/SBZ Running Disc.nem"
		even
Nem_SbzWheel2:	binclude	"artnem/SBZ Junction Wheel.nem"
		even
Nem_Cutter:	binclude	"artnem/SBZ Pizza Cutter.nem"
		even
Nem_Stomper:	binclude	"artnem/SBZ Stomper.nem"
		even
Nem_SpinPform:	binclude	"artnem/SBZ Spinning Platform.nem"
		even
Nem_TrapDoor:	binclude	"artnem/SBZ Trapdoor.nem"
		even
Nem_SbzFloor:	binclude	"artnem/SBZ Collapsing Floor.nem"
		even
Nem_Electric:	binclude	"artnem/SBZ Electrocuter.nem"
		even
Nem_SbzBlock:	binclude	"artnem/SBZ Vanishing Block.nem"
		even
Nem_FlamePipe:	binclude	"artnem/SBZ Flaming Pipe.nem"
		even
Nem_SbzDoor1:	binclude	"artnem/SBZ Small Vertical Door.nem"
		even
Nem_SlideFloor:	binclude	"artnem/SBZ Sliding Floor Trap.nem"
		even
Nem_SbzDoor2:	binclude	"artnem/SBZ Large Horizontal Door.nem"
		even
Nem_Girder:	binclude	"artnem/SBZ Crushing Girder.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:	binclude	"artnem/Enemy Ball Hog.nem"
		even
Nem_Crabmeat:	binclude	"artnem/Enemy Crabmeat.nem"
		even
Nem_Buzz:	binclude	"artnem/Enemy Buzz Bomber.nem"
		even
	if UnusedOptimization=0
Nem_UnkExplode:	binclude	"artnem/Unused - Explosion.nem"
		even
	endif
Nem_Burrobot:	binclude	"artnem/Enemy Burrobot.nem"
		even
Nem_Chopper:	binclude	"artnem/Enemy Chopper.nem"
		even
Nem_Jaws:	binclude	"artnem/Enemy Jaws.nem"
		even
Nem_Roller:	binclude	"artnem/Enemy Roller.nem"
		even
Nem_Motobug:	binclude	"artnem/Enemy Motobug.nem"
		even
Nem_Newtron:	binclude	"artnem/Enemy Newtron.nem"
		even
Nem_Yadrin:	binclude	"artnem/Enemy Yadrin.nem"
		even
Nem_Basaran:	binclude	"artnem/Enemy Basaran.nem"
		even
	if UnusedOptimization=0
Nem_Splats:	binclude	"artnem/Enemy Splats.nem"
		even
	endif
Nem_Bomb:	binclude	"artnem/Enemy Bomb.nem"
		even
Nem_Orbinaut:	binclude	"artnem/Enemy Orbinaut.nem"
		even
Nem_Cater:	binclude	"artnem/Enemy Caterkiller.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	binclude	"artnem/Title Cards.nem"
		even
Nem_Hud:	binclude	"artnem/HUD.nem" ; HUD (rings, time, score)
		even
Nem_Lives:	binclude	"artnem/HUD - Life Counter Icon.nem"
		even
Nem_Ring:	binclude	"artnem/Rings.nem"
		even
Nem_Monitors:	binclude	"artnem/Monitors.nem"
		even
Nem_Explode:	binclude	"artnem/Explosion.nem"
		even
Nem_Points:	binclude	"artnem/Points.nem" ; points from destroyed enemy or object
		even
Nem_GameOver:	binclude	"artnem/Game Over.nem" ; game over / time over
		even
Nem_HSpring:	binclude	"artnem/Spring Horizontal.nem"
		even
Nem_VSpring:	binclude	"artnem/Spring Vertical.nem"
		even
Nem_SignPost:	binclude	"artnem/Signpost.nem" ; end of level signpost
		even
Nem_Lamp:	binclude	"artnem/Lamppost.nem"
		even
Nem_BigFlash:	binclude	"artnem/Giant Ring Flash.nem"
		even
Nem_Bonus:	binclude	"artnem/Hidden Bonuses.nem" ; hidden bonuses at end of a level
		even

; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
Nem_ContSonic:	binclude	"artnem/Continue Screen Sonic.nem"
		even
Nem_MiniSonic:	binclude	"artnem/Continue Screen Stuff.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	binclude	"artnem/Animal Rabbit.nem"
		even
Nem_Chicken:	binclude	"artnem/Animal Chicken.nem"
		even
Nem_Penguin:	binclude	"artnem/Animal Penguin.nem"
		even
Nem_Seal:	binclude	"artnem/Animal Seal.nem"
		even
Nem_Pig:	binclude	"artnem/Animal Pig.nem"
		even
Nem_Flicky:	binclude	"artnem/Animal Flicky.nem"
		even
Nem_Squirrel:	binclude	"artnem/Animal Squirrel.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	binclude	"map16/GHZ.eni"
		even
Nem_GHZ_1st:	binclude	"artnem/8x8 - GHZ1.nem" ; GHZ primary patterns
		even
Nem_GHZ_2nd:	binclude	"artnem/8x8 - GHZ2.nem" ; GHZ secondary patterns
		even
Blk256_GHZ:	binclude	"map256/GHZ.kos"
		even

Blk16_LZ:	binclude	"map16/LZ.eni"
		even
Nem_LZ:		binclude	"artnem/8x8 - LZ.nem" ; LZ primary patterns
		even
Blk256_LZ:	binclude	"map256/LZ.kos"
		even

Blk16_MZ:	binclude	"map16/MZ.eni"
		even
Nem_MZ:		binclude	"artnem/8x8 - MZ.nem" ; MZ primary patterns
		even
Blk256_MZ:
	if Revision=0
		binclude	"map256/MZ (REV00).kos"
		even
	else
		binclude	"map256/MZ (REV01).kos"
		even
	endif

Blk16_SLZ:	binclude	"map16/SLZ.eni"
		even
Nem_SLZ:	binclude	"artnem/8x8 - SLZ.nem" ; SLZ primary patterns
		even
Blk256_SLZ:	binclude	"map256/SLZ.kos"
		even

Blk16_SYZ:	binclude	"map16/SYZ.eni"
		even
Nem_SYZ:	binclude	"artnem/8x8 - SYZ.nem" ; SYZ primary patterns
		even
Blk256_SYZ:	binclude	"map256/SYZ.kos"
		even

Blk16_SBZ:	binclude	"map16/SBZ.eni"
		even
Nem_SBZ:	binclude	"artnem/8x8 - SBZ.nem" ; SBZ primary patterns
		even
Blk256_SBZ:
	if Revision=0
		binclude	"map256/SBZ (REV00).kos"
		even
	else
		binclude	"map256/SBZ (REV01).kos"
		even
	endif

; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:	binclude	"artnem/Boss - Main.nem"
		even
Nem_Weapons:	binclude	"artnem/Boss - Weapons.nem"
		even
Nem_Prison:	binclude	"artnem/Prison Capsule.nem"
		even
Nem_Sbz2Eggman:	binclude	"artnem/Boss - Eggman in SBZ2 & FZ.nem"
		even
Nem_FzBoss:	binclude	"artnem/Boss - Final Zone.nem"
		even
Nem_FzEggman:	binclude	"artnem/Boss - Eggman after FZ Fight.nem"
		even
Nem_Exhaust:	binclude	"artnem/Boss - Exhaust Flame.nem"
		even
Nem_EndEm:	binclude	"artnem/Ending - Emeralds.nem"
		even
Nem_EndSonic:	binclude	"artnem/Ending - Sonic.nem"
		even
Nem_TryAgain:	binclude	"artnem/Ending - Try Again.nem"
		even
	if (Revision=0)&(UnusedOptimization=0)
Nem_EndEggman:
		binclude	"artnem/Unused - Eggman Ending.nem"
		even
	endif
Kos_EndFlowers:	binclude	"artkos/Flowers at Ending.kos" ; ending sequence animated flowers
		even
Nem_EndFlower:	binclude	"artnem/Ending - Flowers.nem"
		even
Nem_CreditText:	binclude	"artnem/Ending - Credits.nem"
		even
Nem_EndStH:	binclude	"artnem/Ending - StH Logo.nem"
		even

; ---------------------------------------------------------------------------

		; AngleMap starts at $62900 in all revisions, which amounts
		; to $104 bytes of padding for rev00 and $40 for rev01/rev02.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		if Revision=0
			dcb.b	$104,$FF
		else
			dcb.b	$40,$FF
		endif
	endif

; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------
AngleMap:	binclude	"collide/Angle Map.bin"
		even
CollArray1:	binclude	"collide/Collision Array (Normal).bin"
		even
CollArray2:	binclude	"collide/Collision Array (Rotated).bin"
		even
Col_GHZ:	binclude	"collide/GHZ.bin" ; GHZ index
		even
Col_LZ:		binclude	"collide/LZ.bin" ; LZ index
		even
Col_MZ:		binclude	"collide/MZ.bin" ; MZ index
		even
Col_SLZ:	binclude	"collide/SLZ.bin" ; SLZ index
		even
Col_SYZ:	binclude	"collide/SYZ.bin" ; SYZ index
		even
Col_SBZ:	binclude	"collide/SBZ.bin" ; SBZ index
		even

; ---------------------------------------------------------------------------
; Special Stage layouts
; ---------------------------------------------------------------------------
SS_1:		binclude	"sslayout/1.eni"
		even
SS_2:		binclude	"sslayout/2.eni"
		even
SS_3:		binclude	"sslayout/3.eni"
		even
SS_4:		binclude	"sslayout/4.eni"
		even
	if Revision=0
SS_5:		binclude	"sslayout/5 (REV00).eni"
		even
SS_6:		binclude	"sslayout/6 (REV00).eni"
		even
	else
		; SS 5 and 6 had broken objects outside the accessible layout;
		; REV01 removes those - remaining layouts stay unchanged.
SS_5:		binclude	"sslayout/5 (REV01).eni"
		even
SS_6:		binclude	"sslayout/6 (REV01).eni"
		even
	endif

; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	binclude	"artunc/GHZ Waterfall.unc"
		even
Art_GhzFlower1:	binclude	"artunc/GHZ Flower Large.unc"
		even
Art_GhzFlower2:	binclude	"artunc/GHZ Flower Small.unc"
		even
Art_MzLava1:	binclude	"artunc/MZ Lava Surface.unc"
		even
Art_MzLava2:	binclude	"artunc/MZ Lava.unc"
		even
Art_MzTorch:	binclude	"artunc/MZ Background Torch.unc"
		even
Art_SbzSmoke:	binclude	"artunc/SBZ Background Smoke.unc"
		even

; ---------------------------------------------------------------------------
; Level layout index
; Format: foreground, background, leftover/unused
; ---------------------------------------------------------------------------
Level_Index:
		; GHZ
		dc.w Level_GHZ1-Level_Index, Level_GHZbg-Level_Index, Level_GHZ1Unk-Level_Index
		dc.w Level_GHZ2-Level_Index, Level_GHZbg-Level_Index, Level_GHZ2Unk-Level_Index
		dc.w Level_GHZ3-Level_Index, Level_GHZbg-Level_Index, Level_GHZ3Unk-Level_Index
		dc.w Level_GHZ4Unk-Level_Index, Level_GHZ4Unk-Level_Index, Level_GHZ4Unk-Level_Index
		; LZ
		dc.w Level_LZ1-Level_Index, Level_LZbg-Level_Index, Level_LZ1Unk-Level_Index
		dc.w Level_LZ2-Level_Index, Level_LZbg-Level_Index, Level_LZ2Unk-Level_Index
		dc.w Level_LZ3-Level_Index, Level_LZbg-Level_Index, Level_LZ3Unk-Level_Index
		dc.w Level_SBZ3-Level_Index, Level_LZbg-Level_Index, Level_SBZ3Unk-Level_Index
		; MZ
		dc.w Level_MZ1-Level_Index, Level_MZ1bg-Level_Index, Level_MZ1-Level_Index
		dc.w Level_MZ2-Level_Index, Level_MZ2bg-Level_Index, Level_MZ2Unk-Level_Index
		dc.w Level_MZ3-Level_Index, Level_MZ3bg-Level_Index, Level_MZ3Unk-Level_Index
		dc.w Level_MZ4Unk-Level_Index, Level_MZ4Unk-Level_Index, Level_MZ4Unk-Level_Index
		; SLZ
		dc.w Level_SLZ1-Level_Index, Level_SLZbg-Level_Index, Level_SLZ1Unk-Level_Index
		dc.w Level_SLZ2-Level_Index, Level_SLZbg-Level_Index, Level_SLZ1Unk-Level_Index
		dc.w Level_SLZ3-Level_Index, Level_SLZbg-Level_Index, Level_SLZ1Unk-Level_Index
		dc.w Level_SLZ1Unk-Level_Index, Level_SLZ1Unk-Level_Index, Level_SLZ1Unk-Level_Index
		; SYZ
		dc.w Level_SYZ1-Level_Index, Level_SYZbg-Level_Index, Level_SYZ1Unk-Level_Index
		dc.w Level_SYZ2-Level_Index, Level_SYZbg-Level_Index, Level_SYZ2Unk-Level_Index
		dc.w Level_SYZ3-Level_Index, Level_SYZbg-Level_Index, Level_SYZ3Unk-Level_Index
		dc.w Level_SYZ4Unk-Level_Index, Level_SYZ4Unk-Level_Index, Level_SYZ4Unk-Level_Index
		; SBZ
		dc.w Level_SBZ1-Level_Index, Level_SBZ1bg-Level_Index, Level_SBZ1bg-Level_Index
		dc.w Level_SBZ2-Level_Index, Level_SBZ2bg-Level_Index, Level_SBZ2bg-Level_Index
		dc.w Level_SBZ2-Level_Index, Level_SBZ2bg-Level_Index, Level_SBZ2Unk-Level_Index
		dc.w Level_SBZ4Unk-Level_Index, Level_SBZ4Unk-Level_Index, Level_SBZ4Unk-Level_Index
		zonewarning Level_Index,24
		; Ending
		dc.w Level_End-Level_Index, Level_GHZbg-Level_Index, Level_EndUnk-Level_Index
		dc.w Level_End-Level_Index, Level_GHZbg-Level_Index, Level_EndUnk-Level_Index
		dc.w Level_EndUnk-Level_Index, Level_EndUnk-Level_Index, Level_EndUnk-Level_Index
		dc.w Level_EndUnk-Level_Index, Level_EndUnk-Level_Index, Level_EndUnk-Level_Index

Level_GHZ1:	binclude	"levels/ghz1.bin"
		even
Level_GHZ1Unk:	dc.l 0
Level_GHZ2:	binclude	"levels/ghz2.bin"
		even
Level_GHZ2Unk:	dc.l 0
Level_GHZ3:	binclude	"levels/ghz3.bin"
		even
Level_GHZbg:	binclude	"levels/ghzbg.bin"
		even
Level_GHZ3Unk:	dc.l 0
Level_GHZ4Unk:	dc.l 0

Level_LZ1:	binclude	"levels/lz1.bin"
		even
Level_LZbg:	binclude	"levels/lzbg.bin"
		even
Level_LZ1Unk:	dc.l 0
Level_LZ2:	binclude	"levels/lz2.bin"
		even
Level_LZ2Unk:	dc.l 0
Level_LZ3:	binclude	"levels/lz3.bin"
		even
Level_LZ3Unk:	dc.l 0
Level_SBZ3:	binclude	"levels/sbz3.bin"
		even
Level_SBZ3Unk:	dc.l 0

Level_MZ1:	binclude	"levels/mz1.bin"
		even
Level_MZ1bg:	binclude	"levels/mz1bg.bin"
		even
Level_MZ2:	binclude	"levels/mz2.bin"
		even
Level_MZ2bg:	binclude	"levels/mz2bg.bin"
		even
Level_MZ2Unk:	dc.l 0
Level_MZ3:	binclude	"levels/mz3.bin"
		even
Level_MZ3bg:	binclude	"levels/mz3bg.bin"
		even
Level_MZ3Unk:	dc.l 0
Level_MZ4Unk:	dc.l 0

Level_SLZ1:	binclude	"levels/slz1.bin"
		even
Level_SLZbg:	binclude	"levels/slzbg.bin"
		even
Level_SLZ2:	binclude	"levels/slz2.bin"
		even
Level_SLZ3:	binclude	"levels/slz3.bin"
		even
Level_SLZ1Unk:	dc.l 0

Level_SYZ1:	binclude	"levels/syz1.bin"
		even
Level_SYZbg:
	if Revision=0
		binclude	"levels/syzbg (REV00).bin"
	else
		binclude	"levels/syzbg (REV01).bin"
	endif
		even
Level_SYZ1Unk:	dc.l 0
Level_SYZ2:	binclude	"levels/syz2.bin"
		even
Level_SYZ2Unk:	dc.l 0
Level_SYZ3:	binclude	"levels/syz3.bin"
		even
Level_SYZ3Unk:	dc.l 0
Level_SYZ4Unk:	dc.l 0

Level_SBZ1:	binclude	"levels/sbz1.bin"
		even
Level_SBZ1bg:	binclude	"levels/sbz1bg.bin"
		even
Level_SBZ2:	binclude	"levels/sbz2.bin"
		even
Level_SBZ2bg:	binclude	"levels/sbz2bg.bin"
		even
Level_SBZ2Unk:	dc.l 0
Level_SBZ4Unk:	dc.l 0
Level_End:	binclude	"levels/ending.bin"
		even
Level_EndUnk:	dc.l 0

; ---------------------------------------------------------------------------
; Uncompressed graphics - Giant Rings
; ---------------------------------------------------------------------------
Art_BigRing:	binclude	"artunc/Giant Ring.unc"
Art_BigRing_size:	equ	*-Art_BigRing
		even

; ---------------------------------------------------------------------------

		; ObjPos_Index starts at $6B000 in all revisions, which amounts
		; to $9C bytes of padding for rev00 and $DC for rev01/rev02.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$100
	endif

; ---------------------------------------------------------------------------
; Sprite locations index
; ---------------------------------------------------------------------------
ObjPos_Index:
		; GHZ
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; LZ
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SBZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; MZ
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SLZ
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SYZ
		dc.w ObjPos_SYZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SYZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SYZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SYZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SBZ
		dc.w ObjPos_SBZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SBZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_FZ-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SBZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		zonewarning ObjPos_Index,$10
		; Ending
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; --- Put extra object data here. ---
ObjPosLZPlatform_Index:
		dc.w ObjPos_LZ1pf1-ObjPos_Index, ObjPos_LZ1pf2-ObjPos_Index
		dc.w ObjPos_LZ2pf1-ObjPos_Index, ObjPos_LZ2pf2-ObjPos_Index
		dc.w ObjPos_LZ3pf1-ObjPos_Index, ObjPos_LZ3pf2-ObjPos_Index
		dc.w ObjPos_LZ1pf1-ObjPos_Index, ObjPos_LZ1pf2-ObjPos_Index
ObjPosSBZPlatform_Index:
		dc.w ObjPos_SBZ1pf1-ObjPos_Index, ObjPos_SBZ1pf2-ObjPos_Index
		dc.w ObjPos_SBZ1pf3-ObjPos_Index, ObjPos_SBZ1pf4-ObjPos_Index
		dc.w ObjPos_SBZ1pf5-ObjPos_Index, ObjPos_SBZ1pf6-ObjPos_Index
		dc.w ObjPos_SBZ1pf1-ObjPos_Index, ObjPos_SBZ1pf2-ObjPos_Index
		dc.b $FF, $FF, 0, 0, 0,	0

ObjPos_GHZ1:	binclude	"objpos/ghz1.bin"
		even
ObjPos_GHZ2:	binclude	"objpos/ghz2.bin"
		even
ObjPos_GHZ3:
	if Revision=0
		binclude	"objpos/ghz3 (REV00).bin"
		even
	else
		binclude	"objpos/ghz3 (REV01).bin"
		even
	endif

ObjPos_LZ1:
	if Revision=0
		binclude	"objpos/lz1 (REV00).bin"
		even
	else
		binclude	"objpos/lz1 (REV01).bin"
		even
	endif
ObjPos_LZ2:	binclude	"objpos/lz2.bin"
		even
ObjPos_LZ3:
	if Revision=0
		binclude	"objpos/lz3 (REV00).bin"
		even
	else
		binclude	"objpos/lz3 (REV01).bin"
		even
	endif
ObjPos_SBZ3:	binclude	"objpos/sbz3.bin"
		even

ObjPos_LZ1pf1:	binclude	"objpos/platforms/lz1pf1.bin"
		even
ObjPos_LZ1pf2:	binclude	"objpos/platforms/lz1pf2.bin"
		even
ObjPos_LZ2pf1:	binclude	"objpos/platforms/lz2pf1.bin"
		even
ObjPos_LZ2pf2:	binclude	"objpos/platforms/lz2pf2.bin"
		even
ObjPos_LZ3pf1:	binclude	"objpos/platforms/lz3pf1.bin"
		even
ObjPos_LZ3pf2:	binclude	"objpos/platforms/lz3pf2.bin"
		even

ObjPos_MZ1:
	if Revision=0
		binclude	"objpos/mz1 (REV00).bin"
		even
	else
		binclude	"objpos/mz1 (REV01).bin"
		even
	endif
ObjPos_MZ2:	binclude	"objpos/mz2.bin"
		even
ObjPos_MZ3:	binclude	"objpos/mz3.bin"
		even

ObjPos_SLZ1:	binclude	"objpos/slz1.bin"
		even
ObjPos_SLZ2:	binclude	"objpos/slz2.bin"
		even
ObjPos_SLZ3:	binclude	"objpos/slz3.bin"
		even
ObjPos_SYZ1:	binclude	"objpos/syz1.bin"
		even
ObjPos_SYZ2:	binclude	"objpos/syz2.bin"
		even
ObjPos_SYZ3:
	if Revision=0
		binclude	"objpos/syz3 (REV00).bin"
		even
	else
		binclude	"objpos/syz3 (REV01).bin"
		even
	endif

ObjPos_SBZ1:
	if Revision=0
		binclude	"objpos/sbz1 (REV00).bin"
		even
	else
		binclude	"objpos/sbz1 (REV01).bin"
		even
	endif
ObjPos_SBZ2:	binclude	"objpos/sbz2.bin"
		even
ObjPos_FZ:	binclude	"objpos/fz.bin"
		even

ObjPos_SBZ1pf1:	binclude	"objpos/platforms/sbz1pf1.bin"
		even
ObjPos_SBZ1pf2:	binclude	"objpos/platforms/sbz1pf2.bin"
		even
ObjPos_SBZ1pf3:	binclude	"objpos/platforms/sbz1pf3.bin"
		even
ObjPos_SBZ1pf4:	binclude	"objpos/platforms/sbz1pf4.bin"
		even
ObjPos_SBZ1pf5:	binclude	"objpos/platforms/sbz1pf5.bin"
		even
ObjPos_SBZ1pf6:	binclude	"objpos/platforms/sbz1pf6.bin"
		even

ObjPos_End:	binclude	"objpos/ending.bin"
		even

ObjPos_Null:	dc.b $FF, $FF, 0, 0, 0,	0

; ---------------------------------------------------------------------------

		; SoundDriver starts at $71990 in all revisions, which amounts
		; to $62A bytes of padding for rev00 and $63C for rev01/rev02.
		; It appears to be placed in such a way that the sound driver
		; ends right on the $80000 mark in the ROM in all revisions.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		if Revision=0
			dcb.b	$62A,$FF
		else
			dcb.b	$63C,$FF
		endif
	endif

; ---------------------------------------------------------------------------

SoundDriver:	include "s1.sounddriver.asm"
		even

; ---------------------------------------------------------------------------

; end of 'ROM'
EndOfRom:

		END
