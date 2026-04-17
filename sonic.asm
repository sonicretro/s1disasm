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
;	| See also FixMusicAndSFXDataBugs

AllOptimizations = 0
;	| If 1, enables all optimizations
SkipChecksumCheck = 0|AllOptimizations
;	| If 1, disables the slow bootup checksum calculation
ZeroOffsetOptimization = 0|AllOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
PaddingOptimization = 0|AllOptimizations
;	| If 1, removes about 3 KB of various superfluous padding

EnableSRAM = 0
;	| If 1, enable SRAM support
BackupSRAM = 1
;	| 0 = no saving (read-only SRAM); 1 = allow saving
AddressSRAM = 3
;	| 0 = odd+even; 2 = even only; 3 = odd only
;	| (odd only is the most common)

ZoneCount = 6
;	| Used for the zonewarning macro. Do not change, unless more zones get added.
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
		dc.l v_systemstack&$FFFFFF	; Initial stack pointer value
		dc.l EntryPoint			; Start of program
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error (4)
		dc.l IllegalInstr		; Illegal instruction
		dc.l ZeroDivide			; Division by zero
		dc.l ChkInstr			; CHK exception
		dc.l TrapvInstr			; TRAPV exception (8)
		dc.l PrivilegeViol		; Privilege violation
		dc.l Trace			; TRACE exception
		dc.l Line1010Emu		; Line-A emulator
		dc.l Line1111Emu		; Line-F emulator (12)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (16)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (20)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (24)
		dc.l ErrorExcept		; Spurious exception
		dc.l ErrorTrap			; IRQ level 1
		dc.l ErrorTrap			; IRQ level 2
		dc.l ErrorTrap			; IRQ level 3 (28)
		dc.l HBlank			; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap			; IRQ level 5
		dc.l VBlank			; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap			; IRQ level 7 (32)
		dc.l ErrorTrap			; TRAP #00 exception
		dc.l ErrorTrap			; TRAP #01 exception
		dc.l ErrorTrap			; TRAP #02 exception
		dc.l ErrorTrap			; TRAP #03 exception (36)
		dc.l ErrorTrap			; TRAP #04 exception
		dc.l ErrorTrap			; TRAP #05 exception
		dc.l ErrorTrap			; TRAP #06 exception
		dc.l ErrorTrap			; TRAP #07 exception (40)
		dc.l ErrorTrap			; TRAP #08 exception
		dc.l ErrorTrap			; TRAP #09 exception
		dc.l ErrorTrap			; TRAP #10 exception
		dc.l ErrorTrap			; TRAP #11 exception (44)
		dc.l ErrorTrap			; TRAP #12 exception
		dc.l ErrorTrap			; TRAP #13 exception
		dc.l ErrorTrap			; TRAP #14 exception
		dc.l ErrorTrap			; TRAP #15 exception (48)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
	if Revision<>2|FixBugs
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
	else
loc_E0:		; Relocated code from Spik_Hurt. REVXB was a nasty hex-edit.
		; See _incObj/36 Spikes.asm for more info.
		move.l	obY(a0),d3
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		jmp	(loc_D5A2).l

		dc.w ErrorTrap
		dc.l ErrorTrap
		dc.l ErrorTrap
		dc.l ErrorTrap
	endif
		dc.b "SEGA MEGA DRIVE " ; Hardware system ID (Console name)
		dc.b "(C)SEGA 1991.APR" ; Copyright holder and release date (generally year)
		dc.b "SONIC THE               HEDGEHOG                " ; Domestic name
		dc.b "SONIC THE               HEDGEHOG                " ; International name
	if Revision=0
		dc.b "GM 00001009-00"   ; Serial/version number (Rev 0)
	else
		dc.b "GM 00004049-01" ; Serial/version number (Rev non-0)
	endif
Checksum:
	if Revision=0
		dc.w $264A	; Hardcoded to make it easier to check for ROM correctness
	else
		dc.w $AFC7
	endif
		dc.b "J               " ; I/O support
		dc.l StartOfRom		; Start address of ROM
RomEndLoc:	dc.l EndOfRom-1		; End address of ROM
		dc.l $FF0000		; Start address of RAM
		dc.l $FFFFFF		; End address of RAM
	if EnableSRAM=1
		dc.b "RA", $A0+(BackupSRAM<<6)+(AddressSRAM<<3), $20 ; SRAM support
	else
		dc.l $20202020
	endif
		dc.l $20202020		; SRAM start ($200001)
		dc.l $20202020		; SRAM end ($20xxxx)
		dc.b "                                                    " ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
		dc.b "JUE             " ; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too

ErrorTrap:
		nop	
		nop	
		bra.s	ErrorTrap
; ===========================================================================

EntryPoint:
		tst.l	(port_1_control_hi).l	; test port A & B control registers
		bne.s	PortA_Ok
		tst.w	(expansion_control_hi).l ; test port C control register
PortA_Ok:	bne.s	SkipSetup		; skip the VDP and Z80 setup code if this is a soft-reset

		lea	SetupValues(pc),a5	; load setup values array address
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0	; get hardware version (from $A10001)
		andi.b	#$F,d0
		beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
		move.l	#'SEGA',$2F00(a1) ; move "SEGA" to TMSS register ($A14000)

SkipSecurity:
		move.w	(a4),d0	; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		moveq	#0,d0	; clear d0
		movea.l	d0,a6	; clear a6
		move.l	a6,usp	; set usp to $0

		moveq	#$18-1,d1
VDPInitLoop:
		move.b	(a5)+,d5	; add $8000 to value
		move.w	d5,(a4)		; move value to VDP register
		add.w	d7,d5		; next register
		dbf	d1,VDPInitLoop
		
		move.l	(a5)+,(a4)
		move.w	d0,(a3)		; clear the VRAM
		move.w	d7,(a1)		; stop the Z80
		move.w	d7,(a2)		; reset the Z80

WaitForZ80:
		btst	d0,(a1)		; has the Z80 stopped?
		bne.s	WaitForZ80	; if not, branch

		moveq	#$25,d2
Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop
		
		move.w	d0,(a2)
		move.w	d0,(a1)		; start the Z80
		move.w	d7,(a2)		; reset the Z80

ClrRAMLoop:
		move.l	d0,-(a6)	; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
		move.l	(a5)+,(a4)	; set VDP display mode and increment mode
		move.l	(a5)+,(a4)	; set VDP to CRAM write

		moveq	#$1F,d3	; set repeat times
ClrCRAMLoop:
		move.l	d0,(a3)	; clear 2 palettes
		dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
		move.l	(a5)+,(a4)	; set VDP to VSRAM write

		moveq	#$13,d4
ClrVSRAMLoop:
		move.l	d0,(a3)	; clear 4 bytes of VSRAM.
		dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
		moveq	#3,d5

PSGInitLoop:
		move.b	(a5)+,$11(a3)	; reset the PSG
		dbf	d5,PSGInitLoop	; repeat for other channels
		move.w	d0,(a2)
		movem.l	(a6),d0-a6	; clear all registers
		disable_ints

SkipSetup:
		bra.s	GameProgram	; begin game

; ===========================================================================
SetupValues:	dc.w $8000		; VDP register start number
		dc.w $3FFF		; size of RAM/4
		dc.w $100		; VDP register diff

		dc.l z80_ram		; start of Z80 RAM
		dc.l z80_bus_request	; Z80 bus request
		dc.l z80_reset		; Z80 reset
		dc.l vdp_data_port	; VDP data
		dc.l vdp_control_port	; VDP control

		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b ($C000>>10)	; VDP $82 - foreground nametable address
		dc.b ($F000>>10)	; VDP $83 - window nametable address
		dc.b ($E000>>13)	; VDP $84 - background nametable address
		dc.b ($D800>>9)		; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - HBlank register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b ($DC00>>10)	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
		dc.l $40000080		; VRAM address 0

		; Z80 instructions (not the sound driver; that gets loaded later)
		save
		CPU Z80 ; start assembling Z80 code
		phase 0 ; pretend we're at address 0
		xor	a	; clear a to 0
		ld	bc,((z80_ram_end-z80_ram)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
		ld	de,zStartupCodeEndLoc+1	; initial destination address
		ld	hl,zStartupCodeEndLoc	; initial source address
		ld	sp,hl	; set the address the stack starts at
		ld	(hl),a	; set first byte of the stack to 0
		ldir		; loop to fill the stack (entire remaining available Z80 RAM) with 0
		pop	ix	; clear ix
		pop	iy	; clear iy
		ld	i,a	; clear i
		ld	r,a	; clear r
		pop	de	; clear de
		pop	hl	; clear hl
		pop	af	; clear af
		ex	af,af'	; swap af with af'
		exx		; swap bc/de/hl with their shadow registers too
		pop	bc	; clear bc
		pop	de	; clear de
		pop	hl	; clear hl
		pop	af	; clear af
		ld	sp,hl	; clear sp
		di		; clear iff1 (for interrupt handler)
		im	1	; interrupt handling mode = 1
		ld	(hl),0E9h ; replace the first instruction with a jump to itself
		jp	(hl)	  ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
		dephase ; stop pretending
		restore
		padding off ; unfortunately our flags got reset so we have to set them again...

		dc.w $8104		; VDP display mode
		dc.w $8F02		; VDP increment
		dc.l $C0000000		; CRAM write mode
		dc.l $40000010		; VSRAM address 0

		dc.b $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================

GameProgram:
		tst.w	(vdp_control_port).l
		btst	#6,(expansion_control).l
		beq.s	CheckSumCheck
		cmpi.l	#'init',(v_init).w ; has checksum routine already run?
		beq.w	GameInit	; if yes, branch

CheckSumCheck:
	if SkipChecksumCheck=0
		movea.l	#EndOfHeader,a0	; start checking bytes after the header ($200)
		movea.l	#RomEndLoc,a1	; stop at end of ROM
		move.l	(a1),d0
		moveq	#0,d1
.loop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bhs.s	.loop
		movea.l	#Checksum,a1	; read the checksum
		cmp.w	(a1),d1		; compare checksum in header to ROM
		bne.w	CheckSumError	; if they don't match, branch
	endif

CheckSumOk:
		lea	(v_crossresetram).w,a6
		moveq	#0,d7
		move.w	#(v_ram_end-v_crossresetram)/4-1,d6
.clearRAM:
		move.l	d7,(a6)+
		dbf	d6,.clearRAM	; clear RAM ($FE00-$FFFF)

		move.b	(console_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w ; get region setting
		move.l	#'init',(v_init).w ; set flag so checksum won't run again

GameInit:
		lea	(v_ram_start).l,a6
		moveq	#0,d7
		move.w	#(v_crossresetram-v_ram_start_def)/4-1,d6
.clearRAM:
		move.l	d7,(a6)+
		dbf	d6,.clearRAM	; clear RAM ($0000-$FDFF)

		bsr.w	VDPSetupGame
		bsr.w	DACDriverLoad
		bsr.w	JoypadInit
		move.b	#id_Sega,(v_gamemode).w ; set Game Mode to Sega Screen

MainGameLoop:
		move.b	(v_gamemode).w,d0 ; load Game Mode
		andi.w	#$1C,d0	; limit Game Mode value to $1C max (change to a maximum of 7C to add more game modes)
		jsr	GameModeArray(pc,d0.w) ; jump to apt location in ROM
		bra.s	MainGameLoop	; loop indefinitely
; ===========================================================================
; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------

GameModeArray:

gmptr:		macro gamemode,{INTLABEL},{GLOBALSYMBOLS}
__LABEL__: =	(*-GameModeArray)
		bra.w	gamemode
		endm

id_Sega:	gmptr	GM_Sega		; Sega Screen ($00)
id_Title:	gmptr	GM_Title	; Title Screen ($04)
id_Demo:	gmptr	GM_Level	; Demo Mode ($08)
id_Level:	gmptr	GM_Level	; Normal Level ($0C)
id_Special:	gmptr	GM_Special	; Special Stage ($10)
id_Continue:	gmptr	GM_Continue	; Continue Screen ($14)
id_Ending:	gmptr	GM_Ending	; End of game sequence ($18)
id_Credits:	gmptr	GM_Credits	; Credits ($1C)

		rts	; redundant rts

; ===========================================================================
	if SkipChecksumCheck=0
CheckSumError:
		bsr.w	VDPSetupGame
		move.l	#$C0000000,(vdp_control_port).l ; set VDP to CRAM write
		moveq	#($80)/2-1,d7

.fillred:
		move.w	#cRed,(vdp_data_port).l ; fill palette with red
		dbf	d7,.fillred	; repeat until CRAM is filled

.endlessloop:
		bra.s	.endlessloop
	endif
; ===========================================================================

BusError:
		move.b	#2,(v_errortype).w
		bra.s	ErrorHandler_WithAddress

AddressError:
		move.b	#4,(v_errortype).w
		bra.s	ErrorHandler_WithAddress

IllegalInstr:
		move.b	#6,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorHandler_WithoutAddress

ZeroDivide:
		move.b	#8,(v_errortype).w
		bra.s	ErrorHandler_WithoutAddress

ChkInstr:
		move.b	#10,(v_errortype).w
		bra.s	ErrorHandler_WithoutAddress

TrapvInstr:
		move.b	#12,(v_errortype).w
		bra.s	ErrorHandler_WithoutAddress

PrivilegeViol:
		move.b	#14,(v_errortype).w
		bra.s	ErrorHandler_WithoutAddress

Trace:
		move.b	#16,(v_errortype).w
		bra.s	ErrorHandler_WithoutAddress

Line1010Emu:
		move.b	#18,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorHandler_WithoutAddress

Line1111Emu:
		move.b	#20,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorHandler_WithoutAddress

ErrorExcept:
		move.b	#0,(v_errortype).w
		bra.s	ErrorHandler_WithoutAddress
; ===========================================================================

; loc_43A:
ErrorHandler_WithAddress:
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_spbuffer).w
		addq.w	#2,sp
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		bsr.w	ShowErrorValue
		move.l	(v_spbuffer).w,d0
		bsr.w	ShowErrorValue
		bra.s	loc_478
; ===========================================================================

; loc_462:
ErrorHandler_WithoutAddress:
		disable_ints
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		bsr.w	ShowErrorValue

loc_478:
		bsr.w	ErrorWaitForC
		movem.l	(v_regbuffer).w,d0-a7
		enable_ints
		rte	
; ===========================================================================

ShowErrorMessage:
		lea	(vdp_data_port).l,a6
		locVRAM	ArtTile_Error_Handler_Font*tile_size
		lea	(Art_Text).l,a0
		move.w	#(Art_Text_end-Art_Text-tile_size)/2-1,d1 ; strangely, this does not load the final tile
.loadgfx:
		move.w	(a0)+,(a6)
		dbf	d1,.loadgfx

		moveq	#0,d0		; clear d0
		move.b	(v_errortype).w,d0 ; load error code
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		locVRAM	vram_fg+$604
		moveq	#19-1,d1		; number of characters (minus 1)

.showchars:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#-'0'+ArtTile_Error_Handler_Font,d0 ; rebase from ASCII to a VRAM index
		move.w	d0,(a6)
		dbf	d1,.showchars	; repeat for number of characters
		rts
; End of function ShowErrorMessage
; ===========================================================================

ErrorText:	offsetTable
		ptr .exception
		ptr .bus
		ptr .address
		ptr .illinstruct
		ptr .zerodivide
		ptr .chkinstruct
		ptr .trapv
		ptr .privilege
		ptr .trace
		ptr .line1010
		ptr .line1111

.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b "@ERO DIVIDE        " ; @ is Z due to the font arrangement
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even

; ===========================================================================

ShowErrorValue:
		move.w	#ArtTile_Error_Handler_Font+10,(a6)	; display "$" symbol
		moveq	#8-1,d2

.loop:
		rol.l	#4,d0
		bsr.s	.shownumber	; display 8 numbers
		dbf	d2,.loop
		rts
; End of function ShowErrorValue
; ===========================================================================

.shownumber:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		blo.s	.chars0to9
		addq.w	#7,d1		; add 7 for characters A-F

.chars0to9:
		addi.w	#ArtTile_Error_Handler_Font,d1
		move.w	d1,(a6)
		rts
; End of function sub_5CA
; ===========================================================================

ErrorWaitForC:
		bsr.w	ReadJoypads
		cmpi.b	#btnC,(v_jpadpress1).w ; is button C pressed?
		bne.w	ErrorWaitForC	; if not, branch
		rts
; End of function ErrorWaitForC


; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed art text for debug mode, level select, and errors
; (formerly "menutext.bin")
; ---------------------------------------------------------------------------

Art_Text:	bincludeEndMarker	"artunc/Level Select & Debug Text.bin" 


; ===========================================================================
; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------
id_VBlank_Lag:		equ $00	; (lag frame)
id_VBlank_Sega:		equ $02	; Sega Screen
id_VBlank_Title:	equ $04	; Title Screen, Credits
id_VBlank_Unused06:	equ $06	; (unused)
id_VBlank_Levels:	equ $08	; Levels, Demos
id_VBlank_SpecialStage:	equ $0A	; Special Stages
id_VBlank_TitleCards:	equ $0C	; Title Cards
id_VBlank_Unused0E:	equ $0E	; (unused)
id_VBlank_Paused:	equ $10	; Paused
id_VBlank_PaletteFade:	equ $12	; Palette Fade
id_VBlank_SegaPCM:	equ $14	; Sega Screen PCM
id_VBlank_Continue:	equ $16	; Continue Screen
id_VBlank_Ending:	equ $18	; Ending Sequence
; ---------------------------------------------------------------------------

; loc_B10: VBla:
VBlank:
		movem.l	d0-a6,-(sp)			; backup all registers except stack pointer (a7)

		tst.b	(v_vblank_routine).w		; was a VBlank routine set?
		beq.s	VBlank_Lag			; if not, this is a lag frame, branch

		move.w	(vdp_control_port).l,d0		; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		move.l	#$40000010,(vdp_control_port).l	; set VDP to VSRAM write mode
		move.l	(v_scrposy_vdp).w,(vdp_data_port).l ; send screen y-axis pos. to VSRAM

		; Wait here in a loop doing nothing for a while. This seems to be a pretty harsh attempt
		; to push CRAM dots outside of the visable view area, due to Sonic 1 not using all
		; the available screen space PAL offers, as they would otherwise be seen at the bottom.
		btst	#6,(v_megadrive).w		; is Megadrive PAL?
		beq.s	.notPAL				; if not, branch
		move.w	#$700,d0			; set to waste a bunch of cycles
	.waitPAL:
		dbf	d0,.waitPAL			; loop until cycles have been wasted

.notPAL:
		move.b	(v_vblank_routine).w,d0		; copy specified VBlank routine to d0
		move.b	#id_VBlank_Lag,(v_vblank_routine).w ; reset actual routine to lag frame (which ideally should get set again in the next frame)
		move.w	#1,(f_hblank_pal).w		; set HBlank palette swap flag (only relevant for LZ)
		andi.w	#$3E,d0				; mask out irrelevant bits in VBlank routine
		move.w	VBlank_Index(pc,d0.w),d0	; load address to relevant VBlank routine
		jsr	VBlank_Index(pc,d0.w)		; jump to VBlank routine and then return here

VBlank_Music:
		jsr	(UpdateMusic).l			; run sound driver to advance music

VBlank_Exit:
		addq.l	#1,(v_vblank_count).w		; increment VBlank counter
		movem.l	(sp)+,d0-a6			; restore all backed-up registers
		rte					; return from interrupt and resume normal operation

; ===========================================================================
; VBla_Index:
VBlank_Index:	offsetTable
		ptr VBlank_Lag		; $00 - (lag frame)
		ptr VBlank_Sega		; $02 - Sega Screen
		ptr VBlank_Title	; $04 - Title Screen, Credits, Try Again
		ptr VBlank_Unused06	; $06 - (unused)
		ptr VBlank_Levels	; $08 - Levels, Demos
		ptr VBlank_SpecialStage	; $0A - Special Stages
		ptr VBlank_TitleCards	; $0C - Title Cards
		ptr VBlank_Unused0E	; $0E - (unused)
		ptr VBlank_Paused	; $10 - Paused
		ptr VBlank_PaletteFade	; $12 - Palette Fade
		ptr VBlank_SegaPCM	; $14 - Sega Screen PCM
		ptr VBlank_Continue	; $16 - Continue Screen, SS Finish
		ptr VBlank_Ending	; $18 - Ending Sequence
; ===========================================================================

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 00 - Lag frame (VBlank occured before call to WaitForVBlank)
; ---------------------------------------------------------------------------

; loc_B88: VBla_00:
VBlank_Lag:
		cmpi.b	#$80+id_Level,(v_gamemode).w	; is pre level sequence active?
		beq.s	.islevel			; if not, just update sound driver and resume operation
		cmpi.b	#id_Level,(v_gamemode).w	; is game on a level?
		bne.w	VBlank_Music			; if not, just update sound driver and resume operation

.islevel:
		cmpi.b	#id_LZ,(v_zone).w		; is level LZ?
		bne.w	VBlank_Music			; if not, just update sound driver and resume operation

	; A lag frame has occured while in Labyrinth Zone...

		move.w	(vdp_control_port).l,d0		; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)

		; Same as in the opening block of the VBlank routine, this time during a lag frame.
		; This only happens if the level is LZ (note, Sonic 2/3/&K would change this so it runs in any level).
		btst	#6,(v_megadrive).w		; is Megadrive PAL?
		beq.s	.notPAL				; if not, branch
		move.w	#$700,d0			; set to waste a bunch of cycles
	.waitPAL:
		dbf	d0,.waitPAL			; loop until cycles have been wasted

.notPAL:
		move.w	#1,(f_hblank_pal).w		; set HBlank flag
		stopZ80
		waitZ80

		tst.b	(f_wtr_state).w			; is the screen completely underewater?
		bne.s	.waterabove 			; if not, branch
		writeCRAM	v_palette,0		; write regular palette buffer to CRAM
		bra.s	.waterbelow			; skip over
.waterabove:
		writeCRAM	v_palette_water,0	; write water palette buffer to CRAM

.waterbelow:
		move.w	(v_hblank_hreg).w,(a5)		; write HBlank trigger scan line for water palette swap to VDP
		startZ80
		bra.w	VBlank_Music			; branch back to update sound driver and resume operation

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 02 - Sega Screen
; ---------------------------------------------------------------------------

; loc_C32: VBla_02:
VBlank_Sega:
		bsr.w	VBlank_StandardTransfers
		; fall-through

; ---------------------------------------------------------------------------
; VBlank 14 - Sega Screen while the PCM sample is playing
; ---------------------------------------------------------------------------

; loc_C36: VBla_14:
VBlank_SegaPCM:
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w
.end:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 04 - Title Screen, Level Select, Credits, "Try Again" screen
; ---------------------------------------------------------------------------

; loc_C44: VBla_04:
VBlank_Title:
		bsr.w	VBlank_StandardTransfers
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w	ProcessPLC_9Tiles
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w
.end:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 06 - Unused
; ---------------------------------------------------------------------------

; loc_C5E: VBla_06:
VBlank_Unused06:
		bsr.w	VBlank_StandardTransfers
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 10 - While game is paused
; ---------------------------------------------------------------------------

; loc_C64: VBla_10:
VBlank_Paused:
		cmpi.b	#id_Special,(v_gamemode).w	; is game on special stage?
		beq.w	VBlank_SpecialStage		; if yes, branch
		; fall-through...

; ---------------------------------------------------------------------------
; VBlank 08 - Levels and Demos
; ---------------------------------------------------------------------------

; loc_C6E: VBla_08:
VBlank_Levels:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads

		tst.b	(f_wtr_state).w
		bne.s	.waterabove
		writeCRAM	v_palette,0
		bra.s	.waterbelow

.waterabove:
		writeCRAM	v_palette_water,0

.waterbelow:
		move.w	(v_hblank_hreg).w,(a5)

		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		writeVRAM	v_spritetablebuffer,vram_sprites

		tst.b	(f_sonframechg).w		; has Sonic's sprite changed?
		beq.s	.nochg				; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		startZ80
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w

		; The following code handles an awkward visual glitch for the LZ water surface.
		; If the surface is near the top of the screen (within 96 pixels), the VDP would not have
		; enough time to do all the transfers in VBlank_UpdateScreen before the palette needs to get
		; changed for the water. Without this special check, the water surface would violently flicker
		; whenever it's near the top of the screen. It's a rather dirty workaround, but it works.
		cmpi.b	#96,(v_hblank_line).w		; is LZ water surface within 96 pixels of the top of the screen?
		bhs.s	VBlank_UpdateScreen		; if not, do screen updates now
		move.b	#1,(f_doupdatesinhblank).w	; otherwise, we don't have enough time to do them now before HBlank hits, defer updates to then
		addq.l	#4,sp				; skip return address (i.e. postpone updating the sound driver as well)
		bra.w	VBlank_Exit			; go straight back to to the VBlank exit

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update various screen elements during interrupts.
; Also deducts the generic timer that controls the length of a Demo.
; ---------------------------------------------------------------------------

; Demo_Time: VBla_UpdateScreen:
VBlank_UpdateScreen:
		bsr.w	LoadTilesAsYouMove		; update level tiles while screen is moving
		jsr	(AnimateLevelGfx).l		; updated animated tiles
		jsr	(HUD_Update).l			; update HUD data
		bsr.w	ProcessPLC_3Tiles		; run a bit of PLC decompression

		tst.w	(v_generictimer).w		; is there time left in the generic timer left?
		beq.w	.end				; if not, branch
		subq.w	#1,(v_generictimer).w		; subtract 1 from time left
.end:
		rts
; End of function VBlank_UpdateScreen

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0A - Special Stages
; ---------------------------------------------------------------------------

; loc_DA6: VBla_0A:
VBlank_SpecialStage:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		bsr.w	PalCycle_SS

		tst.b	(f_sonframechg).w		; has Sonic's sprite changed?
		beq.s	.nochg				; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		tst.w	(v_generictimer).w		; is there time left on the demo?
		beq.w	.end				; if not, return
		subq.w	#1,(v_generictimer).w		; subtract 1 from time left in demo
.end:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0C - While title cards are displayed (Levels and SS Results)
; VBlank 18 - During the Ending Sequence
; ---------------------------------------------------------------------------

; loc_E72: VBla_0C: VBla_18:
VBlank_TitleCards:
VBlank_Ending:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).w
		bne.s	.waterabove

		writeCRAM	v_palette,0
		bra.s	.waterbelow

.waterabove:
		writeCRAM	v_palette_water,0

.waterbelow:
		move.w	(v_hblank_hreg).w,(a5)
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		writeVRAM	v_spritetablebuffer,vram_sprites

		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size
		move.b	#0,(f_sonframechg).w

.nochg:
		startZ80
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		bsr.w	ProcessPLC_9Tiles
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0E - Unused (possibly once uses as a lag frame counter?)
; ---------------------------------------------------------------------------

; loc_F8A: VBla_0E:
VBlank_Unused0E:
		bsr.w	VBlank_StandardTransfers
		addq.b	#1,(v_vblank_0e_counter).w	; unused besides this one write...
		move.b	#id_VBlank_Unused0E,(v_vblank_routine).w ; set itself to land back here again if not further altered
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 12 - During palette fades
; ---------------------------------------------------------------------------

; loc_F9A: VBla_12:
VBlank_PaletteFade:
		bsr.w	VBlank_StandardTransfers
		move.w	(v_hblank_hreg).w,(a5)
		bra.w	ProcessPLC_9Tiles
		

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 16 - Continue Screen and Special Stage finish loop
; ---------------------------------------------------------------------------

; loc_FA6: VBla_16:
VBlank_Continue:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80

		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size
		move.b	#0,(f_sonframechg).w

.nochg:
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w

.end:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform standard VRAM transfers (palette, sprites, H-scroll)
; ---------------------------------------------------------------------------

; sub_106E:
VBlank_StandardTransfers:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads

		tst.b	(f_wtr_state).w			; is the screen completely underwater?
		bne.s	.underwater			; if yes, branch
		writeCRAM	v_palette,0		; write full regular palette buffer to CRAM
		bra.s	.rest

.underwater:
		writeCRAM	v_palette_water,0	; write full water palette buffer to CRAM

.rest:
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		rts
; End of function VBlank_StandardTransfers

; ===========================================================================
; ---------------------------------------------------------------------------
; Horizontal interrupt (exclusively used for the LZ water palette effect)
; ---------------------------------------------------------------------------

; PalToCRAM: <-- old misnomer
HBlank:
		disable_ints				; disable interrupts (VBlank in this context)
		tst.w	(f_hblank_pal).w		; is palette set to change?
		beq.s	.nochg				; if not, branch
		move.w	#0,(f_hblank_pal).w		; clear palette change flag

		movem.l	a0-a1,-(sp)			; backup a0 and a1 registers
		lea	(vdp_data_port).l,a1		; load VDP data port to a1
		lea	(v_palette_water).w,a0		; get water palette from RAM
		move.l	#$C0000000,4(a1)		; set VDP to CRAM write
		rept (4*$10)/2				; overwrite full palette (4 rows, 2 colors per move)
			move.l	(a0)+,(a1)		; move water palette to CRAM
		endr					; repeat at assembly time
		move.w	#$8A00+223,4(a1)		; reset horizontal interrupt counter
		movem.l	(sp)+,a0-a1			; restore a0 and a1

		tst.b	(f_doupdatesinhblank).w		; was frame update delayed by water surface being near the top of the screen?
		bne.s	.delayed_transfer		; if yes, resume transfer now

.nochg:
		rte					; return from horizontal interrupt and resume normal operation
; ===========================================================================

; loc_119E:
.delayed_transfer:
		clr.b	(f_doupdatesinhblank).w		; clear delayed updates flag
		movem.l	d0-a6,-(sp)			; backup all registers except stack pointer (a7)
		bsr.w	VBlank_UpdateScreen		; do all the screen updates that were skipped during VBlank now
		jsr	(UpdateMusic).l			; update the sound driver
		movem.l	(sp)+,d0-a6			; restore registers
		rte					; return from horizontal interrupt and resume normal operation
; End of function HBlank


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to initialise joypads (run once during boot)
; ---------------------------------------------------------------------------

JoypadInit:
		stopZ80					; request Z80 stop on
		waitZ80					; wait until it has stopped
		moveq	#$40,d0				; prepare intialise value
		move.b	d0,(port_1_control).l		; init port 1 (joypad 1)
		move.b	d0,(port_2_control).l		; init port 2 (joypad 2)
		move.b	d0,(expansion_control).l	; init port 3 (expansion/extra)
		startZ80				; request Z80 stop off
		rts					; return
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to read joypad input, and send it to the RAM (read every VBlank)
; ---------------------------------------------------------------------------

ReadJoypads:
		lea	(v_jpadhold1).w,a0		; address where joypad states are written
		lea	(port_1_data).l,a1		; first joypad port
		bsr.s	.read				; do the first joypad
		addq.w	#2,a1				; do the second joypad (port_2_data)

.read:
		move.b	#0,(a1)				; read A and Start input (TH poll low)
		nop					; wait a bit
		nop					; ''
		move.b	(a1),d0				; write A and Start input states to d0

		lsl.b	#2,d0				; move A and Start to topmost bits
		andi.b	#%11000000,d0			; clear all other inputs from the poll

		move.b	#$40,(a1)			; read D-Pad, B, and C input (TH poll high)
		nop					; wait a bit
		nop					; ''
		move.b	(a1),d1				; write D-Pad, B, and C input states to d1

		andi.b	#%00111111,d1			; clear all other inputs from the poll
		or.b	d1,d0				; merge but poll results into d0
		not.b	d0				; flip bits so that 0=released and 1=pressed

		move.b	(a0),d1				; get buttons pressed the previous frame
		eor.b	d0,d1				; XOR with buttons pressed this frame

		move.b	d0,(a0)+			; write HELD buttons
		and.b	d0,d1				; find buttons pressed this frame
		move.b	d1,(a0)+			; write PRESSED buttons
		rts					; return to VBlank routine
; End of function ReadJoypads


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup the VDP with values used for the game itself
; ---------------------------------------------------------------------------

VDPSetupGame:
		lea	(vdp_control_port).l,a0		; load VDP control port
		lea	(vdp_data_port).l,a1		; load VDP data port
		lea	(VDPSetupArray).l,a2		; load address of register values
		moveq	#(VDPSetupArray_End-VDPSetupArray)/2-1,d7 ; set repeat times
.setreg:
		move.w	(a2)+,(a0)			; save register value to VDP
		dbf	d7,.setreg			; repeat until all register values have been sent

		move.w	(VDPSetupArray+2).l,d0		; get second entry of VDPSetupArray
		move.w	d0,(v_vdp_buffer1).w		; buffer register $81 (used for enabling/disabling display)

		move.w	#$8A00+223,(v_hblank_hreg).w	; HBlank every 224th scanline

		moveq	#cBlack,d0			; set d0 to 0 (black)
		move.l	#$C0000000,(vdp_control_port).l	; set VDP to CRAM write
		move.w	#($80)/2-1,d7			; set repeat times to cover full CRAM
.clrCRAM:
		move.w	d0,(a1)				; clear colours
		dbf	d7,.clrCRAM                     ; repeat until the entire palette is clear (black)

		clr.l	(v_scrposy_vdp).w		; clear single vertical scroll buffer
		clr.l	(v_scrposx_vdp).w		; clear single horizontal scroll buffer
		move.l	d1,-(sp)			; store d1 data in the stack for now
		fillVRAM	0,0,$10000		; clear the entirety of VRAM
		move.l	(sp)+,d1			; reload d1 data back out of the stack
		rts					; return
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
		dc.w $8000|%00000100			; 8-color mode
		dc.w $8100|%00110100			; vertical interrupts, DMA, Mega Drive display
		dc.w $8200|(vram_fg>>10)		; foreground nametable address
		dc.w $8300|($A000>>10)			; window nametable address
		dc.w $8400|(vram_bg>>13)		; background nametable address
		dc.w $8500|(vram_sprites>>9)		; sprite table address
		dc.w $8600				; (unused, only relevant for 128KB VRAM mode)
		dc.w $8700|$00				; background colour (palette line 0, entry 0)
		dc.w $8800				; (unused, only relevant for Master System)
		dc.w $8900				; (unused, only relevant for Master System)
		dc.w $8A00|$00				; horizontal interrupt register
		dc.w $8B00|%00000000			; full-screen vertical scrolling
		dc.w $8C00|%10000001			; 40-cell display mode
		dc.w $8D00|(vram_hscroll>>10)		; background H-scroll address
		dc.w $8E00				; (unused, only relevant for 128KB VRAM mode)
		dc.w $8F00|$02				; VDP auto-increment size (2)
		dc.w $9000|%00000001			; 64-cell H-scroll size
		dc.w $9100				; window horizontal position
		dc.w $9200				; window vertical position
VDPSetupArray_End:


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to clear the screen (plane mappings, sprites, and scroll data)
; ---------------------------------------------------------------------------

ClearScreen:
		fillVRAM	0, vram_fg, vram_fg+plane_size_64x32 ; clear foreground namespace
		fillVRAM	0, vram_bg, vram_bg+plane_size_64x32 ; clear background namespace

	if Revision=0
		move.l	#0,(v_scrposy_vdp).w		; clear single vertical scroll buffer
		move.l	#0,(v_scrposx_vdp).w		; clear single horizontal scroll buffer
	else
		; REV01 changed this from moving 0 to clears, but functionally identical
		clr.l	(v_scrposy_vdp).w		; clear single vertical scroll buffer
		clr.l	(v_scrposx_vdp).w		; clear single horizontal scroll buffer
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

		rts
; End of function ClearScreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load the DAC driver
; ---------------------------------------------------------------------------

; SoundDriverLoad: <--- old misnomer
DACDriverLoad:
		nop					; delay
		stopZ80                                 ; request Z80 stop on
		deassertZ80Reset                        ; request Z80 reset off
		lea	(DACDriver).l,a0                ; load compressed DAC driver address as source
		lea	(z80_ram).l,a1	                ; set Z80 RAM address as target
		bsr.w	KosDec		                ; decompress the DAC driver into Z80 RAM
		assertZ80Reset                          ; request Z80 reset on
		nop	                                ; delay (while the Z80 resets)
		nop	                                ; ''
		nop	                                ; ''
		nop	                                ; ''
		deassertZ80Reset                        ; request Z80 reset off
		startZ80                                ; request Z80 stop off
		rts                                     ; return
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
		lea	(vdp_data_port).l,a6		; load VDP data port address
		move.l	#$800000,d4			; prepare plane width size for VDP address advancing (row)

Tilemap_Line:
		move.l	d0,4(a6)			; set the VDP the VRAM write mode with address
		move.w	d1,d3				; load width of rectangle

Tilemap_Cell:
		move.w	(a1)+,(a6)			; copy tile map to VRAM plane space
		dbf	d3,Tilemap_Cell			; repeat for the entire width
		add.l	d4,d0				; advance VDP value address to the next row
		dbf	d2,Tilemap_Line			; repeat for the entire height
		rts					; return
; End of function TilemapToVRAM

; ===========================================================================
; >>> Nemesis decompression algorithm, primarily (but not exclusively) used for PLCs
	include	"_inc/Decompression/Nemesis Decompression.asm"

; ---------------------------------------------------------------------------
; Subroutine to add entries from a given Pattern Load Cue list ID to the
; PLC decompression queue (decompressed later during VBlank)
; ---------------------------------------------------------------------------
; ARGUMENTS
; d0 = index of PLC list
; ---------------------------------------------------------------------------
; NOTICE: This subroutine does not check for buffer overruns. The programmer
;         (or hacker) is responsible for making sure that no more than
;         16 load requests are copied into the buffer.
;         _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/plc_slot_size)
; ---------------------------------------------------------------------------

; LoadPLC:
AddPLC:
		movem.l	a1-a2,-(sp)			; store register data
		lea	(ArtLoadCues).l,a1		; load PLC list address
		add.w	d0,d0				; double for word-based indexing
		move.w	(a1,d0.w),d0			; load correct relative add address
		lea	(a1,d0.w),a1			; add and load actual address of list
		lea	(v_plc_buffer).w,a2		; load PLC process list
		
.findspace:		
		tst.l	(a2)				; is this slot taken?
		beq.s	.copytoRAM			; if not, branch
		addq.w	#plc_slot_size,a2		; advance to next slot
		bra.s	.findspace			; recheck
; ===========================================================================

.copytoRAM:
		move.w	(a1)+,d0			; load size of list
		bmi.s	.return				; if there is no list, branch
		
.loop:		
		move.l	(a1)+,(a2)+			; copy Nemesis art address
		move.w	(a1)+,(a2)+			; copy VRAM location to dump to
		dbf	d0,.loop			; repeat for all entries
		
.return:		
		movem.l	(sp)+,a1-a2			; restore register data
		rts					; return
; End of function AddPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Identical to AddPLC, but also stops the current PLC process, and loads
; a brand new queue. (The same 16th entry warning as above applies!)
; ---------------------------------------------------------------------------

; LoadPLC2:
NewPLC:
		movem.l	a1-a2,-(sp)			; store register data
		lea	(ArtLoadCues).l,a1		; load PLC list address
		add.w	d0,d0				; double for word-based indexing
		move.w	(a1,d0.w),d0			; load correct relative add address
		lea	(a1,d0.w),a1			; add and load actual address of list
		bsr.s	ClearPLC			; clear the current PLC entries first
		lea	(v_plc_buffer).w,a2		; load PLC process list
		move.w	(a1)+,d0			; load size of list
		bmi.s	.return				; if there is no list, branch
		
.loop:		
		move.l	(a1)+,(a2)+			; copy Nemesis art address
		move.w	(a1)+,(a2)+			; copy VRAM location to dump to
		dbf	d0,.loop			; repeat for all entries
		
.return:		
		movem.l	(sp)+,a1-a2			; restore register data
		rts					; return
; End of function NewPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to clear the pattern load cues
; Clear the pattern load queue ($FFF680 - $FFF700)
; ---------------------------------------------------------------------------

ClearPLC:
		lea	(v_plc_buffer).w,a2		; load PLC process list
		moveq	#(v_plc_buffer_end-v_plc_buffer)/4-1,d0 ; set size of list
		
.loop:		
		clr.l	(a2)+				; clear PLC process list
		dbf	d0,.loop			; repeat until entire list is cleared
		rts					; return
; End of function ClearPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	check the PLC buffer and begin decompression if it contains
; anything. ProcessPLC handles the actual decompression during VBlank
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(v_plc_buffer).w		; are there any PLC entries left to process?
		beq.s	.return				; if not, branch
		tst.w	(v_plc_patternsleft).w		; is a section counter already set (is art already being decompressed)?
		bne.s	.return				; if so, branch

		movea.l	(v_plc_buffer).w,a0		; load address of first entry's art
		lea	(NemPCD_WriteRowToVDP).l,a3	; load address of dumping routine to use (VDP variant)
		lea	(v_ngfx_buffer).w,a1		; load RLE huffman buffer
		move.w	(a0)+,d2			; load number of sections to decompress (Each section is $20 bytes)
		bpl.s	.skipXor			; if this data doesn't use XOR variant, branch
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3 ; advance to XOR variant
; loc_160E:
.skipXor:
		andi.w	#$7FFF,d2			; clear XOR flag

	if FixBugs=0
		; Relocated to bugfix below
		move.w	d2,(v_plc_patternsleft).w	; save section counter
	endif
		bsr.w	NemDec_BuildCodeTable		; decompress the huffman tree RLE table
		move.b	(a0)+,d5			; load lookup field
		asl.w	#8,d5				; ''
		move.b	(a0)+,d5			; ''
		moveq	#$10,d6				; prepare bit shift counter (shifting up to a word in size)
		moveq	#0,d0				; clear d0
		move.l	a0,(v_plc_buffer).w		; store current entry address
		move.l	a3,(v_plc_ptrnemcode).w		; store dumping routine (XOR/Non-XOR)
		move.l	d0,(v_plc_repeatcount).w	; clear RLE dump counter
		move.l	d0,(v_plc_paletteindex).w	; clear RLE dump nybble
		move.l	d0,(v_plc_previousrow).w	; clear previous XOR dump
		move.l	d5,(v_plc_dataword).w		; store lookup field
		move.l	d6,(v_plc_shiftvalue).w		; store bit shift counter
	if FixBugs
		; Fix a race condition with Pattern Load Cues
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_race_condition_with_Pattern_Load_Cues
		move.w	d2,(v_plc_patternsleft).w	; save section counter
	endif

.return:
		rts					; return
; End of function RunPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to decompress and dump a specified number of Nemesis-compressed
; PLC tiles from the PLC process list to VRAM. These are called from VBlank,
; probably done to smooth out level loading because of how slow Nemesis is.
; (Note: Process"D"PLC is an old misnomer!)
; ---------------------------------------------------------------------------

; sub_1642: ProcessDPLC_9Tiles:
ProcessPLC_9Tiles:
		tst.w	(v_plc_patternsleft).w		; is a section counter set (is art being decompressed)?
		beq.w	ProcessPLC_Return		; if not, branch (nothing to decompress)
		
		move.w	#9,(v_plc_framepatternsleft).w	; set tile counter to 9 (number of tiles to decompress in a frame)
		moveq	#0,d0				; clear d0
		move.w	(v_plc_buffer_dest).w,d0	; load VRAM address for this frame
		addi.w	#9*tile_size,(v_plc_buffer_dest).w ; increase address for next frame
		bra.s	ProcessPLC			; continue
; ===========================================================================

; sub_165E: ProcessDPLC2: ProcessPLC_3Tiles:
ProcessPLC_3Tiles:
		tst.w	(v_plc_patternsleft).w		; is a section counter set (is art being decompressed)?
		beq.s	ProcessPLC_Return		; if not, branch (nothing to decompress)
		
		move.w	#3,(v_plc_framepatternsleft).w	; set tile counter to 3 (number of tiles to decompress in a frame)
		moveq	#0,d0				; clear d0
		move.w	(v_plc_buffer_dest).w,d0	; load VRAM address for this frame
		addi.w	#3*tile_size,(v_plc_buffer_dest).w ; increase address for next frame
		; fall-through to ProcessPLC...
; ---------------------------------------------------------------------------

; loc_1676: ProcessPLC:
ProcessPLC:
		lea	(vdp_control_port).l,a4		; load VDP control port address
		lsl.l	#2,d0				; get address MSB bits and send to LSB of long-word
		lsr.w	#2,d0				; send rest back
		ori.w	#$4000,d0			; set mode bits
		swap	d0				; align for VDP port
		move.l	d0,(a4)				; set VDP address/mode
		subq.w	#4,a4				; move a4 down to VDP data port
		movea.l	(v_plc_buffer).w,a0		; load current entry address
		movea.l	(v_plc_ptrnemcode).w,a3		; load dumping routine to use (XOR/Non-XOR)
		move.l	(v_plc_repeatcount).w,d0	; load RLE dump counter
		move.l	(v_plc_paletteindex).w,d1	; load RLE dump nybble
		move.l	(v_plc_previousrow).w,d2	; load previous XOR dump
		move.l	(v_plc_dataword).w,d5		; load lookup field
		move.l	(v_plc_shiftvalue).w,d6		; load bit shift counter
		lea	(v_ngfx_buffer).w,a1		; load RLE huffman buffer

; loc_16AA:
.loop:
		movea.w	#8,a5				; set size of data to decompress (20 bytes, 1 tile)
		bsr.w	NemPCD_NewRow			; continue the decompression
		subq.w	#1,(v_plc_patternsleft).w	; decrease section count by 1
		beq.s	ProcessPLC_ShiftCue		; if decompression is finished, branch
		subq.w	#1,(v_plc_framepatternsleft).w	; decrease tile counter
		bne.s	.loop				; if still running, branch to decompress another tile
		
		move.l	a0,(v_plc_buffer).w		; store current entry address
		move.l	a3,(v_plc_ptrnemcode).w		; store dumping routine to use (XOR/Non-XOR)
		move.l	d0,(v_plc_repeatcount).w	; store RLE dump counter
		move.l	d1,(v_plc_paletteindex).w	; store RLE dump nybble
		move.l	d2,(v_plc_previousrow).w	; store previous XOR dump
		move.l	d5,(v_plc_dataword).w		; store lookup field
		move.l	d6,(v_plc_shiftvalue).w		; store bit shift counter

ProcessPLC_Return:
		rts					; return
; ===========================================================================

; loc_16DC:
ProcessPLC_ShiftCue:
		lea	(v_plc_buffer).w,a0		; load PLC process list
		moveq	#(v_plc_buffer_only_end-v_plc_buffer-plc_slot_size)/4-1,d0 ; set size of list

; loc_16E2:
.loop:
		move.l	plc_slot_size(a0),(a0)+		; shift contents of PLC buffer up 6 bytes
		dbf	d0,.loop			; repeat til done

	if FixBugs
		; The above code does not properly 'pop' the 16th PLC entry.
		; Because of this, occupying the 16th slot will cause it to
		; be repeatedly decompressed infinitely.
		; Granted, this could be considered more of an optimisation
		; than a bug: treating the 16th entry as a dummy that
		; should never be occupied makes this code unnecessary.
		; Still, the overhead of this code is minimal.
		if (v_plc_buffer_only_end-v_plc_buffer-plc_slot_size)&2
			move.w	plc_slot_size(a0),(a0)
		endif
		clr.l	(v_plc_buffer_only_end-plc_slot_size).w
	endif

		rts					; return
; End of function ProcessPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Like AddPLC, but instead of adding entries to a queue to be processed later,
; this will decompress and transfer all entries of the given PLC ID's list
; immediately, blocking until it is done. Does not use or affect the queue.
; ---------------------------------------------------------------------------

QuickPLC:
		lea	(ArtLoadCues).l,a1		; load PLC list address
		add.w	d0,d0				; double for word-based indexing
		move.w	(a1,d0.w),d0			; load correct relative add address
		lea	(a1,d0.w),a1			; add and load actual address of list
		move.w	(a1)+,d1			; load size of list

.loop:
		movea.l	(a1)+,a0			; load Nemesis art address
		moveq	#0,d0				; clear d0
		move.w	(a1)+,d0			; load VRAM dump address
		lsl.l	#2,d0				; get address MSB bits and send to LSB of long-word
		lsr.w	#2,d0				; send rest back
		ori.w	#$4000,d0			; set mode bits
		swap	d0				; align for VDP port
		move.l	d0,(vdp_control_port).l		; set VDP address/mode
		bsr.w	NemDec				; decompress the entire entry
		dbf	d1,.loop			; repeat for all entries in the list
		rts					; return
; End of function QuickPLC

; ===========================================================================
; >>> Other decompression algorithms
	include	"_inc/Decompression/Enigma Decompression.asm"
	include	"_inc/Decompression/Kosinski Decompression.asm"


; ===========================================================================
; >>> Palette logic routines
	include	"_inc/PaletteCycle.asm"
	include	"_inc/Palette Fading.asm" ; includes "PaletteFadeIn", "PaletteFadeOut", "PaletteWhiteIn", and "PaletteWhiteOut"


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

PalCycle_Sega:
		tst.b	(v_pcyc_time+1).w		; is light scanning effect done?
		bne.s	PCycSega_FadeIn			; if yes, branch

; ---------------------------------------------------------------------------
; First part of the Sega screen palette cycle (the "light scan effect")
; ---------------------------------------------------------------------------

		lea	(v_palette_line_2).w,a1		; set target start palette line (affects line 2-4 overall)
		lea	(Pal_Sega1).l,a0		; get palette cycle colors for the light scanning effect
		moveq	#(Pal_Sega1_end-Pal_Sega1)/2-1,d1 ; set size of colors to write (6 in total)
		move.w	(v_pcyc_num).w,d0		; load current palcycle position (initialized to -$A)

; loc_2020:
.findScanStart:
		bpl.s	.doLightScan			; has start position been found? if yes, branch (d0 >= 0)
		addq.w	#2,a0				; get next color in Pal_Sega1
		subq.w	#1,d1				; set to load one less color
		addq.w	#2,d0				; go to next starting color for light effect
		bra.s	.findScanStart			; loop until current position has been found
; ===========================================================================

; loc_202A:
.doLightScan:
		move.w	d0,d2				; get current target position
		andi.w	#$1E,d2				; limit to one palette line ($20 bytes)
		bne.s	.notTransparent1		; is it the first (transparent) color? if not, branch
		addq.w	#2,d0				; skip over transparent color

; loc_2034:
.notTransparent1:
		cmpi.w	#v_palette_line_4-v_palette_line_1,d0 ; (=$60) would we write past the last palette entry?
		bhs.s	.writeNoMore			; if yes, do not write new color
		move.w	(a0)+,(a1,d0.w)			; write current light scan color to palette buffer

; loc_203E:
.writeNoMore:
		addq.w	#2,d0				; go to next starting color for light effect
		dbf	d1,.doLightScan			; loop until all colors have been written

		; Palette dumping is done, update next offset or set to next part
		move.w	(v_pcyc_num).w,d0		; load current palcycle position
		addq.w	#2,d0				; go to next starting color
		move.w	d0,d2				; get current target position
		andi.w	#$1E,d2				; limit to one palette line ($20 bytes)
		bne.s	.notTransparent2		; is it the first (transparent) color? if not, branch
		addq.w	#2,d0				; skip over transparent color

; loc_2054:
.notTransparent2:
		cmpi.w	#v_palette_line_4-v_palette_line_1+4,d0 ; (=$64) has light scan effect finished?
		blt.s	.scanNotDone			; if not, branch
		move.w	#(4<<8)+1,(v_pcyc_time).w	; set delay between fade-in increments (high byte) and "light scan done" flag (low byte)
		moveq	#-6*2,d0			; set starting offset for fade-in palette (gets set to 0 for first fade-in step)

; loc_2062:
.scanNotDone:
		move.w	d0,(v_pcyc_num).w
		moveq	#1,d0				; clear Z-flag (possibly for a return signal, but now unsued)
		rts					; return
; ===========================================================================

; ---------------------------------------------------------------------------
; Second part of the Sega screen palette cycle (the fade-in)
; ---------------------------------------------------------------------------

; loc_206A:
PCycSega_FadeIn:
		subq.b	#1,(v_pcyc_time).w		; decrement delay until next brightess increase
		bpl.s	.delayFadeIn			; does delay time remain? if yes, branch

		move.b	#4,(v_pcyc_time).w		; reset delay between fade-in increments
		move.w	(v_pcyc_num).w,d0		; get current fade-in position
		addi.w	#6*2,d0				; go to next set of colors 
		cmpi.w	#(6*2)*4,d0			; have four color sets been done?
		blo.s	.doFadeIn			; if not, do next fade-in step

		moveq	#0,d0				; set Z-flag (possibly for a return signal, but now unsued)
		rts					; return
; ===========================================================================

; loc_2088:
.doFadeIn:
		move.w	d0,(v_pcyc_num).w		; remember position for next fade-in increment
		lea	(Pal_Sega2).l,a0		; get palette cycle colors for the fade-in effect
		lea	(a0,d0.w),a0			; go to relevant color data
		lea	(v_palette_line_1+$04).w,a1	; set to write past transparent and pure-white color
		move.l	(a0)+,(a1)+			; write colors 1 and 2 to buffer
		move.l	(a0)+,(a1)+			; write colors 3 and 4 to buffer
		move.w	(a0)+,(a1)			; write color 5 to buffer

		; Main palette dumping is done, fill remaining palette buffer with 6th color
		lea	(v_palette_line_2).w,a1		; start from second palette line (up to fourth one)
		moveq	#0,d0				; clear d0
		moveq	#((v_palette_line_4-v_palette_line_1)/2)-3-1,d1 ; (=$2C) write 3 lines, minus skipped transparent colors, minus 1

; loc_20A8:
.fillRest:
		move.w	d0,d2				; get current target position
		andi.w	#$1E,d2				; limit to one palette line ($20 bytes)
		bne.s	.notTransparent3		; is it the first (transparent) color? if not, branch
		addq.w	#2,d0				; skip over transparent color

; loc_20B2:
.notTransparent3:
		move.w	(a0),(a1,d0.w)			; write fill color to current palette slot (and don't advance index)
		addq.w	#2,d0				; go to next palette target
		dbf	d1,.fillRest			; loop until remaining palette has been filled completely

; loc_20BC:
.delayFadeIn:
		moveq	#1,d0				; clear Z-flag (possibly for a return signal, but now unsued)
		rts					; return
; End of function PalCycle_Sega

; ===========================================================================
; >>> Palette cycle data used for Sega screen
Pal_Sega1:	bincludeEndMarker	"palette/Sega1.bin" ; used during the light scanning effect
Pal_Sega2:	bincludeEndMarker	"palette/Sega2.bin" ; used during the fade-in (three color sets, 5+1 colors each)


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load main palettes into the fading buffer.
; These get displayed once PaletteFadeIn/PaletteWhiteIn is called.

; input:
; d0 = index number for palette
; ---------------------------------------------------------------------------

PalLoad_Fade:
		lea	(Pal_Index).l,a1		; get palette pointers
		lsl.w	#3,d0				; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1				; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2			; get palette data address
		movea.w	(a1)+,a3			; get target RAM address
		adda.w	#v_palette_fading-v_palette,a3	; load to palette fade-in buffer instead of active palette buffer (+$80)
		move.w	(a1)+,d7			; get length of palette data

.loop:
		move.l	(a2)+,(a3)+			; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop			; loop until all colors are loaded
		rts					; return
; End of function PalLoad_Fade

; ---------------------------------------------------------------------------
; Subroutine to directly load main palettes to the active palette.
; Same as PalLoad_Fade, but without adding $80.
; ---------------------------------------------------------------------------

PalLoad:
		lea	(Pal_Index).l,a1		; get palette pointers
		lsl.w	#3,d0				; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1				; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2			; get palette data address
		movea.w	(a1)+,a3			; get target RAM address
		move.w	(a1)+,d7			; get length of palette data

.loop:
		move.l	(a2)+,(a3)+			; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop			; loop until all colors are loaded
		rts					; return
; End of function PalLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load underwater palettes into the water fading buffer.
; These get displayed once PaletteFadeIn/PaletteWhiteIn is called.
; ---------------------------------------------------------------------------

PalLoad_Fade_Water:
		lea	(Pal_Index).l,a1		; get palette pointers
		lsl.w	#3,d0				; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1				; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2			; get palette data address
		movea.w	(a1)+,a3			; get target RAM address
		suba.w	#v_palette-v_palette_water,a3	; load to (water) palette fade-in buffer instead of active palette buffer
		move.w	(a1)+,d7			; get length of palette data

.loop:
		move.l	(a2)+,(a3)+			; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop			; loop until all colors are loaded
		rts					; return
; End of function PalLoad_Fade_Water

; ---------------------------------------------------------------------------
; Subroutine to directly load underwater palettes to the active palette.
; Same as PalLoad_Fade_Water, but writing $80 before it.
; ---------------------------------------------------------------------------

PalLoad_Water:
		lea	(Pal_Index).l,a1		; get palette pointers
		lsl.w	#3,d0				; multiply input ID by 8 (size of one palette index entry)
		adda.w	d0,a1				; add to palette index pointer to get relevant palette entry
		movea.l	(a1)+,a2			; get palette data address
		movea.w	(a1)+,a3			; get target RAM address
		suba.w	#v_palette-v_palette_water_fading,a3 ; load to active (water) palette buffer instead of main active palette buffer
		move.w	(a1)+,d7			; get length of palette data

.loop:
		move.l	(a2)+,(a3)+			; move two colors from palette data to palette buffer RAM
		dbf	d7,.loop			; loop until all colors are loaded
		rts					; return
; End of function PalLoad_Water

; ===========================================================================
; >>> Palette pointers and palette binary includes
	include	"_inc/Palette Index.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to wait for VBlank routines to complete
; ---------------------------------------------------------------------------

; DelayProgram: <--- old misnomer
; WaitForVBla: <--- old name
WaitForVBlank:
		enable_ints				; enable interrupts so vertical interrupts can occur

.wait:
		tst.b	(v_vblank_routine).w		; has VBlank routine finished?
		bne.s	.wait				; if not, loop until it has
		rts					; resume normal operation
; End of function WaitForVBlank

; ===========================================================================
; >>> Subroutines for generic calculations
	include	"_incObj/sub RandomNumber.asm"
	include	"_incObj/sub CalcSine.asm"
    if Revision=0
	; Only in REV00, and even there it was never used
	include	"_incObj/sub CalcSqrt.asm"
    endif
	include	"_incObj/sub CalcAngle.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

; SegaScreen:
GM_Sega:
		; fading out from previous game mode
		move.b	#bgm_Stop,d0			; set stop music command
		bsr.w	QueueSound2			; stop music
		bsr.w	ClearPLC			; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut			; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8004,(a6)			; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$8700,(a6)			; set background colour (palette entry 0)
		move.w	#$8B00,(a6)			; full-screen vertical scrolling
		clr.b	(f_wtr_state).w			; clear water state

		disable_ints				; disable interrupts
		disable_display				; disable screen output
		bsr.w	ClearScreen			; wipe the screen

		locVRAM	ArtTile_Sega_Tiles*tile_size	; set target VRAM location for Sega logo pattenrs
		lea	(Nem_SegaLogo).l,a0		; load Sega logo patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		lea	(v_ram_start).l,a1		; set start of RAM to be used as decompression buffer
		lea	(Eni_SegaLogo).l,a0		; load Sega logo mappings
		move.w	#ArtTile_Sega_Tiles,d0		; set art tile for Sega screen mappings
		bsr.w	EniDec				; decompress Enigma-compressed mappings to RAM buffer
		copyTilemap	v_ram_start,vram_bg+$510,24,8 ; transfer decompressed patterns to VRAM (BG plane, light scanning effect)
		copyTilemap	v_ram_start+24*8*2,vram_fg,40,28 ; transfer decompressed patterns to VRAM (FG plane, Sega logo cutout)

	if Revision<>0
		tst.b	(v_megadrive).w			; is console Japanese?
		bmi.s	.loadpal			; if not, branch
		copyTilemap	v_ram_start+$A40,vram_fg+$53A,3,2 ; hide "TM" with a white rectangle
.loadpal:
	endif

		moveq	#palid_SegaBG,d0		; load Sega screen palette...
		bsr.w	PalLoad				; ...directly to active palette (not fade-in buffer)
		move.w	#-$A,(v_pcyc_num).w		; light scanning palette cycle effect start offset
		move.w	#0,(v_pcyc_time).w		; clear palette fade-in counter
		move.w	#0,(v_pal_buffer+$12).w		; clear some palcycle buffer (unused?)
		move.w	#0,(v_pal_buffer+$10).w		; clear some palcycle buffer (unused?)
		enable_display				; enable screen output
; ---------------------------------------------------------------------------

Sega_WaitPal:	; while light scanning effect is active
		move.b	#id_VBlank_Sega,(v_vblank_routine).w ; set VBlank routine to $02
		bsr.w	WaitForVBlank			; wait for VBlank to finish
		bsr.w	PalCycle_Sega			; advance light scanning palette cycle effect
		bne.s	Sega_WaitPal			; loop until it's finished
; ---------------------------------------------------------------------------

		; while "SEGA" sound is playing
		move.b	#sfx_Sega,d0			; set "SEGA" sound
		bsr.w	QueueSound2			; queue it
		move.b	#id_VBlank_SegaPCM,(v_vblank_routine).w ; set VBlank routine to $14
		bsr.w	WaitForVBlank			; wait for VBlank to play the sound (CPU is frozen here until sound finished playing)
; ---------------------------------------------------------------------------

		; after sound has finished playing
		move.w	#30,(v_generictimer).w		; wait 30 frames before automatic fade-out

Sega_WaitEnd:
		move.b	#id_VBlank_Sega,(v_vblank_routine).w ; set VBlank routine to $02
		bsr.w	WaitForVBlank			; wait for VBlank to finish
		tst.w	(v_generictimer).w		; has post-chant timer expired?
		beq.s	Sega_GotoTitle			; if yes, go to title screen
		andi.b	#btnStart,(v_jpadpress1).w	; is Start button pressed?
		beq.s	Sega_WaitEnd			; if not, loop post-chant routine
; ---------------------------------------------------------------------------

Sega_GotoTitle:	; transition to title screen
		move.b	#id_Title,(v_gamemode).w	; go to title screen
		rts
; End of function GM_Sega


; ===========================================================================
; ---------------------------------------------------------------------------
; Title screen
; ---------------------------------------------------------------------------

; TitleScreen:
GM_Title:	; fading out from previous game mode
		move.b	#bgm_Stop,d0			; set stop music command
		bsr.w	QueueSound2			; stop music
		bsr.w	ClearPLC			; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut			; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading "SONIC TEAM PRESENTS" (STP) patterns
		disable_ints				; disable ints while accessing the VDP
		bsr.w	DACDriverLoad			; load Z80 driver
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8004,(a6)			; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$9001,(a6)			; 64-cell hscroll size
		move.w	#$9200,(a6)			; window vertical position
		move.w	#$8B03,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#$8720,(a6)			; set background colour (palette line 2, entry 0)
		clr.b	(f_wtr_state).w			; clear water state
		bsr.w	ClearScreen			; wipe the screen
		clearRAM v_objspace			; clear object RAM

		locVRAM	ArtTile_Title_Japanese_Text*tile_size ; set target VRAM location for hidden Japanese credits
		lea	(Nem_JapNames).l,a0		; load hidden Japanese credits
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Sonic_Team_Font*tile_size ; set target VRAM location for "SONIC TEAM PRESENTS" font
		lea	(Nem_CreditText).l,a0		; load STP font (same as the credits font)
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		lea	(v_ram_start).l,a1		; set start of RAM to be used as decompression buffer
		lea	(Eni_JapNames).l,a0		; load mappings for Japanese credits
		move.w	#ArtTile_Title_Japanese_Text,d0	; set art tile for hidden credits
		bsr.w	EniDec				; decompress Enigma-compressed mappings to RAM buffer
		copyTilemap	v_ram_start,vram_fg,40,28 ; transfer decompressed patterns from RAM buffer to VRAM

		clearRAM v_palette_fading		; set palette fade-in buffer to all-black
		moveq	#palid_Sonic,d0			; load Sonic's palette...
		bsr.w	PalLoad_Fade			; ...into fade-in buffer
		move.b	#id_CreditsText,(v_sonicteam).w	; load "SONIC TEAM PRESENTS" object
		jsr	(ExecuteObjects).l		; execute objects to load STP object
		jsr	(BuildSprites).l		; build sprites for the STP object
		bsr.w	PaletteFadeIn			; fade-in STP screen
; ---------------------------------------------------------------------------

		; load main title screen patterns while "SONIC TEAM PRESENTS" screen is shown
		disable_ints				; display is frozen during the STP screen

		locVRAM	ArtTile_Title_Foreground*tile_size ; set target VRAM location title screen foreground emblem
		lea	(Nem_TitleFg).l,a0		; load title screen foreground emblem patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Title_Sonic*tile_size	; set target VRAM location big Sonic object
		lea	(Nem_TitleSonic).l,a0		; load big Sonic title screen patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Title_Trademark*tile_size ; set target VRAM location for "TM" patterns
		lea	(Nem_TitleTM).l,a0		; load "TM" patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		lea	(vdp_data_port).l,a6		; load VDP data transfer port
		locVRAM	ArtTile_Level_Select_Font*tile_size,4(a6) ; set target VRAM location for level select font
		lea	(Art_Text).l,a5			; load uncompressed level select font
		move.w	#(Art_Text_end-Art_Text)/2-1,d1	; set loop count for level select 
Tit_LoadText:
		move.w	(a5)+,(a6)			; write one row of the level select font to VRAM
		dbf	d1,Tit_LoadText			; loop until it's fully loaded

		move.b	#0,(v_lastlamp).w		; clear lamppost counter
		move.w	#0,(v_debuguse).w		; exit debug mode if necessary
		move.w	#0,(f_demo).w			; disable demo mode
		move.w	#0,(v_unused2).w		; unused variable
		move.w	#id_GHZ_act1,(v_zone).w		; set level to GHZ1 (000)
		move.w	#0,(v_pcyc_time).w		; disable palette cycling
		bsr.w	LevelSizeLoad			; load level size (will use GHZ1's sizes)
		bsr.w	DeformLayers			; initialize background deformation before fade-in (redundant here)

		lea	(v_16x16).w,a1			; set target buffer for blocks mappings
		lea	(Blk16_GHZ).l,a0		; load GHZ 16x16 blocks mappings
		move.w	#ArtTile_Level,d0		; set to target VRAM address $0000
		bsr.w	EniDec				; decompress Enigma-compressed blocks mappings to buffer

		lea	(Blk256_GHZ).l,a0		; load GHZ 256x256 mappings
		lea	(v_256x256).l,a1		; set target buffer for chunks mappings
		bsr.w	KosDec				; decompress Kosinski-compressed chunks mappings to buffer

		bsr.w	LevelLayoutLoad			; load level layout for the background
		bsr.w	PaletteFadeOut			; fade-out "SONIC TEAM PRESENtS" screen
; ---------------------------------------------------------------------------

		; "SONIC TEAM PRESENTS" screen has faded out, load remaining patterns and fade in
		disable_ints				; disable interrupts again after the fade-out
		bsr.w	ClearScreen			; wipe screen

		lea	(vdp_control_port).l,a5		; set VDP control port
		lea	(vdp_data_port).l,a6		; set VDP data port
		lea	(v_bgscreenposx).w,a3		; get current background X position
		lea	(v_lvllayout_bg).w,a4		; get location in level layout RAM where background is stored
		move.w	#$4000+(vram_bg-vram_fg),d2	; =$6000 (VRAM write command $4000 + nametable start address relative to vram_fg)
		bsr.w	DrawChunks			; draw initial background layer

		lea	(v_ram_start).l,a1		; set start of RAM to be used as decompression buffer (this overwrites unused chunk RAM)
		lea	(Eni_Title).l,a0		; load title screen emblem mappings
		move.w	#ArtTile_Level,d0		; =$0000 (emblem mappings are themselves set up with a +$2000 offset per tile)
		bsr.w	EniDec				; decompress Enigma-compressed emblem mappings to buffer
	if FixBugs
		; Fix title screen position
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Title_Screen_position_in_Sonic_1
		copyTilemap	v_ram_start,vram_fg+$208,34,22 ; transfer decompressed patterns from RAM buffer to VRAM (correctly centered)
	else
		copyTilemap	v_ram_start,vram_fg+$206,34,22 ; transfer decompressed patterns from RAM buffer to VRAM (off-center)
	endif

		locVRAM	ArtTile_Level*tile_size		; set target VRAM location for level patterns
		lea	(Nem_GHZ_1st).l,a0		; load first half of GHZ patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		moveq	#palid_Title,d0			; load title screen palette...
		bsr.w	PalLoad_Fade			; ...to fade-in buffer
		move.b	#bgm_Title,d0			; set title screen music
		bsr.w	QueueSound2			; play title screen music
		move.b	#0,(f_debugmode).w		; disable debug mode (cheat remains active though)
		move.w	#376,(v_generictimer).w		; run title screen for 376 frames (6 seconds plus some change)
		
	if FixBugs
		; Fix the Press Start Button text
		; https://info.sonicretro.org/SCHG_How-to:Display_the_Press_Start_Button_text
		clearRAM v_sonicteam,v_sonicteam+object_size ; delete RAM used by "SONIC TEAM PRESENTS" object (fully)
	else
		; Bug: this only clears half of the "SONIC TEAM PRESENTS" slot.
		; This is responsible for why the "PRESS START BUTTON" text doesn't
		; show up, as the routine ID isn't reset.
		clearRAM v_sonicteam,v_sonicteam+object_size/2 ; delete RAM used by "SONIC TEAM PRESENTS" object (partially)
	endif

		move.b	#id_TitleSonic,(v_titlesonic).w	; load big Sonic object
		move.b	#id_PSBTM,(v_pressstart).w	; load "PRESS START BUTTON" object
		;clr.b	(v_pressstart+obRoutine).w	; The 'Mega Games 10' version of Sonic 1 added this line to fix the 'PRESS START BUTTON' object not appearing

	if Revision<>0
		tst.b	(v_megadrive).w			; is console Japanese?
		bpl.s	.isjap				; if yes, don't load TM object
	endif
		move.b	#id_PSBTM,(v_titletm).w		; load title screen HUD object
		move.b	#3,(v_titletm+obFrame).w	; set it to the "TM" frame

.isjap:
		move.b	#id_PSBTM,(v_ttlsonichide).w	; load title screen HUD object
		move.b	#2,(v_ttlsonichide+obFrame).w	; load object which hides part of Sonic's torse behind the emblem

		jsr	(ExecuteObjects).l		; load title screen objects
		bsr.w	DeformLayers			; initialize background deformation before fade-in
		jsr	(BuildSprites).l		; build sprites for the title screen objects before fade-in
		moveq	#plcid_Main,d0			; load main patterns (rings, etc.) 
		bsr.w	NewPLC				; (these get loaded once for the title screen and then never again, except when exiting Special Stages)

		move.w	#0,(v_title_dcount).w		; clear D-Pad counter for title screen cheats
		move.w	#0,(v_title_ccount).w		; clear C counter for title screen cheats
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		enable_display				; enable display
		bsr.w	PaletteFadeIn			; fade-in title screen

; ---------------------------------------------------------------------------
; Title screen main loop and cheat checks
; ---------------------------------------------------------------------------

Tit_MainLoop:
		move.b	#id_VBlank_Title,(v_vblank_routine).w ; set VBlank routine to $04
		bsr.w	WaitForVBlank			; wait for VBlank to finish
		jsr	(ExecuteObjects).l		; execute title screen objects
		bsr.w	DeformLayers			; run background deformation
		jsr	(BuildSprites).l		; display sprites
		bsr.w	PalCycle_Title			; run title screen palette cycle
		bsr.w	RunPLC				; run any potential PLC

		move.w	(v_player+obX).w,d0		; get current title screen position (big Sonic object)
		addq.w	#2,d0				; move it 2px to the right
		move.w	d0,(v_player+obX).w		; write new X position
		cmpi.w	#$1C00,d0			; has Sonic object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion			; if not, branch
		; Will never happen due to the short title screen generic timer.
		; This likely was an old failsafe before Demos were introduced.
		move.b	#id_Sega,(v_gamemode).w		; return to Sega screen
		rts
; ===========================================================================

Tit_ChkRegion:
		tst.b	(v_megadrive).w			; check if the machine is US or Japanese
		bpl.s	Tit_RegionJap			; if Japanese, branch
		lea	(LevSelCode_US).l,a0		; load US code
		bra.s	Tit_EnterCheat			; skip over

Tit_RegionJap:
		lea	(LevSelCode_J).l,a0		; load J code

Tit_EnterCheat:
		move.w	(v_title_dcount).w,d0		; get number of successful D-Pad cheat inputs
		adda.w	d0,a0				; add to loaded code to find current cheat input requirement
		move.b	(v_jpadpress1).w,d0		; get buttons pressed this frame
		andi.b	#btnDir,d0			; read only D-Pad buttons (UDLR)
		cmp.b	(a0),d0				; does button press match current cheat entry?
		bne.s	Tit_ResetCheat			; if not, branch and reset cheat
		addq.w	#1,(v_title_dcount).w		; increment number of successful D-Pad cheat inputs
		tst.b	d0				; has end of cheat code been reached? (0-entry in cheat)
		bne.s	Tit_CountC			; if not, branch
		
Tit_ActivateCheat:
		; (On JAPANESE consoles only) Activated cheat depends on the amount of times C was pressed:
		; 0-1 level select -- 2-3 slow motion -- 4-5 debug mode -- 6-7: hidden Japanese credits / sound test skips
		; For any other regions, pressing C twice or more will ALWAYS result in slow motion and debug mode.
		lea	(f_levselcheat).w,a0		; get base cheat index
		move.w	(v_title_ccount).w,d1		; get number of tiles C was pressed
		lsr.w	#1,d1				; half pressed amount
		andi.w	#3,d1				; only four cheats are possible
		beq.s	Tit_PlayRing			; if C was not pressed, only activate level select
		tst.b	(v_megadrive).w			; check if the machine is US or Japanese
		bpl.s	Tit_PlayRing			; if Japanese, branch
		moveq	#1,d1				; on non-Japanese console, force index to slow motion cheat
		move.b	d1,1(a0,d1.w)			; enable debug mode first (and slow motion in the next line)

Tit_PlayRing:
		move.b	#1,(a0,d1.w)			; activate cheat depending on C-press count
		move.b	#sfx_Ring,d0			; set ring sound when code is entered
		bsr.w	QueueSound2			; play it
		bra.s	Tit_CountC			; skip over cheat reset 
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0				; has D-Pad been pressed?
		beq.s	Tit_CountC			; if yes, branch
		cmpi.w	#9,(v_title_dcount).w		; has cheat reached index 9? (impossible condition)
		beq.s	Tit_CountC			; if yes, don't reset D-Pad counter
		move.w	#0,(v_title_dcount).w		; reset cheat index counter

Tit_CountC:
		move.b	(v_jpadpress1).w,d0		; get currently pressed buttons
		andi.b	#btnC,d0			; is C button pressed?
		beq.s	Tit_ChkStartOrDemo		; if not, branch
		addq.w	#1,(v_title_ccount).w		; increment C counter

; loc_3230:
Tit_ChkStartOrDemo:
		tst.w	(v_generictimer).w		; has title screen timer expired?
		beq.w	GotoDemo			; if yes, launch Demo mode
		andi.b	#btnStart,(v_jpadpress1).w	; check if Start is pressed
		beq.w	Tit_MainLoop			; if not, continue looping title screen

Tit_ChkLevSel:
		tst.b	(f_levselcheat).w		; check if level select code is on
		beq.w	PlayLevel			; if not, begin game by playing normal level
		btst	#bitA,(v_jpadhold1).w		; check if A was held while pressing Start
		beq.w	PlayLevel			; if not, begin game by playing normal level
; ---------------------------------------------------------------------------

Tit_EnterLevelSelect:
	if FixBugs
		; Fix the level selects graphics bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Level_Select_graphics_bug
		move.b	#id_VBlank_Title,(v_vblank_routine).w ; set VBlank routine to $04
		bsr.w	WaitForVBlank			; run VBlank one extra frame to prevent graphical glitches
	endif
		moveq	#palid_LevelSel,d0		; load level select palette...
		bsr.w	PalLoad				; ...directly to active palette

		clearRAM v_hscrolltablebuffer		; clear H-Scroll buffer
		move.l	d0,(v_scrposy_vdp).w		; clear VSRAM (d0 is still 0)
		disable_ints				; disable interrupts

		lea	(vdp_data_port).l,a6		; prepare VDP data write
		locVRAM	vram_bg				; write to background nametable
		move.w	#plane_size_64x32/4-1,d1	; write full screen
.LevSelClearBG:	move.l	d0,(a6)				; clear background plane
		dbf	d1,.LevSelClearBG		; loop until plane is fully cleared

		bsr.w	LevSelTextLoad			; load level select text before entering main loop

; ---------------------------------------------------------------------------
; Level Select main loop
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#id_VBlank_Title,(v_vblank_routine).w ; set VBlank routine to $04
		bsr.w	WaitForVBlank			; wait for VBlank to finish
		bsr.w	LevSelControls			; update selected line if necessary
		bsr.w	RunPLC				; run any potential PLC
		tst.l	(v_plc_buffer).w		; are any patterns in the PLC still left to be loaded?
		bne.s	LevelSelect			; if yes, block quitting level select until finished
		andi.b	#btnABC+btnStart,(v_jpadpress1).w ; is A, B, C, or Start pressed?
		beq.s	LevelSelect			; if not, loop level select

LevSel_SelectionMade:
		move.w	(v_levselitem).w,d0		; get currently selected line
		cmpi.w	#levsel_sndtest_row,d0		; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS			; if not, go to Level/SS subroutine
		move.w	(v_levselsound).w,d0		; get currently selected sound test entry
		addi.w	#$80,d0				; make it $80-based
		tst.b	(f_creditscheat).w		; is Japanese Credits cheat on?
		beq.s	LevSel_NoCheat			; if not, branch
		cmpi.w	#$9F,d0				; is sound $9F being played?
		beq.s	LevSel_Ending			; if yes, branch
		cmpi.w	#$9E,d0				; is sound $9E being played?
		beq.s	LevSel_Credits			; if yes, branch
LevSel_NoCheat:
	if FixBugs=0
		; This is a workaround for a bug (see PlaySoundID in the sound driver for more info)
		cmpi.w	#bgm__Last+1,d0			; is sound $80-$93 being played?
		blo.s	LevSel_PlaySnd			; if yes, branch
		cmpi.w	#sfx__First,d0			; is sound $94-$9F being played?
		blo.s	LevelSelect			; if yes, branch
LevSel_PlaySnd:
	endif
		bsr.w	QueueSound2			; play selected sound
		bra.s	LevelSelect			; loop level select
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).w 	; set screen mode to $18 (Ending)
		move.w	#id_EndZ_good,(v_zone).w  	; set level to 0600 (good Ending)
		rts
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).w	; set screen mode to $1C (Credits)
		move.b	#bgm_Credits,d0			; set credits music
		bsr.w	QueueSound2			; play it
		move.w	#0,(v_creditsnum).w		; start at the first credits page
		rts
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0				; double selected line for word-based indexing
		move.w	LevSel_Ptrs(pc,d0.w),d0		; find relevant level pointer from table
		bmi.w	LevelSelect			; if it's an invalid entry, branch back to main loop
		cmpi.w	#id_SS<<8,d0			; check if selected level Special Stage (0700 is used as dummy value)
		bne.s	LevSel_Level			; if not, branch
		move.b	#id_Special,(v_gamemode).w	; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w			; clear level
		move.b	#3,(v_lives).w			; set lives to 3
		moveq	#0,d0				; set d0 to 0
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.l	d0,(v_score).w			; clear score
	if Revision<>0
		move.l	#5000,(v_scorelife).w		; extra life is awarded at 50000 points
	endif
		rts
; ===========================================================================

LevSel_Level:
		andi.w	#$3FFF,d0			; mask out invalid bits of level number
		move.w	d0,(v_zone).w			; set new level number (zone and act)

PlayLevel:
		move.b	#id_Level,(v_gamemode).w	; set screen mode to $0C (level)
		move.b	#3,(v_lives).w			; set lives to 3
		moveq	#0,d0				; set d0 to 0
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.l	d0,(v_score).w			; clear score
		move.b	d0,(v_lastspecial).w		; clear special stage number
		move.b	d0,(v_emeralds).w		; clear emeralds
		move.l	d0,(v_emldlist).w		; clear emeralds
		move.l	d0,(v_emldlist+4).w		; clear emeralds
		move.b	d0,(v_continues).w		; clear continues
	if Revision<>0
		move.l	#5000,(v_scorelife).w		; extra life is awarded at 50000 points
	endif
		move.b	#bgm_Fade,d0			; set music fade-out command
		bsr.w	QueueSound2			; fade out music
		rts					; return to MainGameLoop to start level
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
		dc.w id_LZ_act4		; Scrap Brain Zone 3
		dc.w id_FZ		; Final Zone
		dc.w id_SS<<8		; Special Stage (dummy value)
		dc.w $8000		; Sound Test
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
		move.w	#30,(v_generictimer).w		; set timeout to 30 frames

; loc_33B6:
GotoDemo_PreDelayLoop:
		move.b	#id_VBlank_Title,(v_vblank_routine).w ; set VBlank routine to $04
		bsr.w	WaitForVBlank			; wait for VBlank to finish
		bsr.w	DeformLayers			; run background deformation
		bsr.w	PaletteCycle			; run normal palette cycle routine (this briefly uses GHZ's cycle)
		bsr.w	RunPLC				; run any potential PLC

		move.w	(v_player+obX).w,d0		; get current title screen position (big Sonic object)
		addq.w	#2,d0				; move it 2px to the right
		move.w	d0,(v_player+obX).w		; write new X position
		cmpi.w	#$1C00,d0			; has Sonic object passed $1C00 on x-axis?
		blo.s	GotoDemo_ChkLoop		; if not, branch
		; Will never happen due to the short title screen generic timer.
		; This likely was an old failsafe before Demos were introduced.
		move.b	#id_Sega,(v_gamemode).w		; return to Sega screen
		rts
; ===========================================================================

; loc_33E4:
GotoDemo_ChkLoop:
		andi.b	#btnStart,(v_jpadpress1).w	; has Start button been pressed during pre-delay?
		bne.w	Tit_ChkLevSel			; if yes, abort loading demo and load normal level instead
		tst.w	(v_generictimer).w		; has pre-delay timer expired?
		bne.w	GotoDemo_PreDelayLoop		; if not, branch
; ---------------------------------------------------------------------------

		; start loading demo now
		move.b	#bgm_Fade,d0			; set music fade-out command
		bsr.w	QueueSound2			; fade out music

		move.w	(v_demonum).w,d0		; load demo number
		andi.w	#7,d0				; limit to four demo entries
		add.w	d0,d0				; double for word-based indexing
		move.w	Demo_Levels(pc,d0.w),d0		; load level number for demo
		move.w	d0,(v_zone).w			; set level for demo

		addq.w	#1,(v_demonum).w		; add 1 to demo number
		cmpi.w	#4,(v_demonum).w		; is demo number less than 4?
		blo.s	GotoDemo_NoReset		; if yes, branch
		move.w	#0,(v_demonum).w		; reset demo number to 0

; loc_3422:
GotoDemo_NoReset:
		move.w	#1,(f_demo).w			; turn demo mode on
		move.b	#id_Demo,(v_gamemode).w		; set game mode to 08 (demo)

		cmpi.w	#$600,d0			; is level number 0600 (Special Stage dummy value)?
		bne.s	GotoDemo_NotSS			; if not, branch
		move.b	#id_Special,(v_gamemode).w	; set game mode to $10 (Special Stage)
		clr.w	(v_zone).w			; clear level number
		clr.b	(v_lastspecial).w		; clear special stage number to play demo in stage 1

; Demo_Level:
GotoDemo_NotSS:
		move.b	#3,(v_lives).w			; set lives to 3
		moveq	#0,d0				; clear d0
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.l	d0,(v_score).w			; clear score
	if Revision<>0
		move.l	#5000,(v_scorelife).w		; extra life is awarded at 50000 points
	endif
		rts					; return to MainGameLoop to start demo
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
		move.b	(v_jpadpress1).w,d1		; get current button presses
		andi.b	#btnUp+btnDn,d1			; is up/down pressed this frame?
		bne.s	LevSel_UpDown			; if yes, branch
		subq.w	#1,(v_levseldelay).w		; if held, subtract 1 from delay until next move
		bpl.s	LevSel_SndTest			; if time remains, branch

LevSel_UpDown:
		move.w	#12-1,(v_levseldelay).w		; reset time delay
		move.b	(v_jpadhold1).w,d1		; get currently held buttons
		andi.b	#btnUp+btnDn,d1			; is up/down held?
		beq.s	LevSel_SndTest			; if not, branch
		move.w	(v_levselitem).w,d0		; get currently selected line
		btst	#bitUp,d1			; is up held?
		beq.s	LevSel_Down			; if not, branch
		subq.w	#1,d0				; move up 1 selection
		bhs.s	LevSel_Down			; if entry is still valid, branch
		moveq	#levsel_line_count-1,d0		; if selection moves below 0, jump to selection last row

LevSel_Down:
		btst	#bitDn,d1			; is down held?
		beq.s	LevSel_Refresh			; if not, branch
		addq.w	#1,d0				; move down 1 selection
		cmpi.w	#levsel_line_count,d0		; is selection past the last one now?
		blo.s	LevSel_Refresh			; if not, branch
		moveq	#0,d0				; if selection moves past the last row, jump to selection 0

LevSel_Refresh:
		move.w	d0,(v_levselitem).w		; set new selection
		bsr.w	LevSelTextLoad			; refresh text
		rts
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#levsel_sndtest_row,(v_levselitem).w ; is sound test row selected?
		bne.s	LevSel_NoMove			; if not, branch
		move.b	(v_jpadpress1).w,d1		; get currently pressed buttons
		andi.b	#btnR+btnL,d1			; is left/right pressed?
		beq.s	LevSel_NoMove			; if not, branch

		move.w	(v_levselsound).w,d0		; get currently selected sound test number
		btst	#bitL,d1			; is left pressed?
		beq.s	LevSel_Right			; if not, branch
		subq.w	#1,d0				; subtract 1 from sound test
		bhs.s	LevSel_Right			; is result still positive? if yes, branch
		moveq	#sfx__Last-$80,d0 		; if sound test moves below 0, set to last entry (non-$80 based)

LevSel_Right:
		btst	#bitR,d1			; is right pressed?
		beq.s	LevSel_Refresh2			; if not, branch
		addq.w	#1,d0				; add 1 to sound test
		cmpi.w	#sfx__Last-$80+1,d0		; is result now past the last entry?
		blo.s	LevSel_Refresh2			; if not, branch
		moveq	#0,d0				; if sound test moves above last entry, set to 0

LevSel_Refresh2:
		move.w	d0,(v_levselsound).w		; set sound test number
		bsr.w	LevSelTextLoad			; refresh text

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
		lea	(LevelMenuText).l,a1		; load menu text offset
		lea	(vdp_data_port).l,a6		; prepare VDP data write
		locVRAM	levsel_vram_main,d4		; prepare base VRAM nametable location in d4
		move.w	#levsel_white,d3		; VRAM setting
		moveq	#levsel_line_count-1,d1		; number of lines of text to write
.DrawAll:	move.l	d4,4(a6)			; write to VDP
		bsr.w	LevSel_ChgLine			; draw line of text
		addi.l	#$00800000,d4			; jump to next line
		dbf	d1,.DrawAll			; repeat until all lines are drawn

		; Draw currently selected line in yellow
		moveq	#0,d0				; clear d0
		move.w	(v_levselitem).w,d0		; get currently selected line
		move.w	d0,d1				; back up selected line
		locVRAM	levsel_vram_main,d4		; prepare base VRAM nametable location in d4
		lsl.w	#7,d0				; times $80
		swap	d0				; swap so that line now becomes VRAM nametable offset
		add.l	d0,d4				; add that to base VRAM location
		lea	(LevelMenuText).l,a1		; load menu text offset
	if levsel_line_length=24
		lsl.w	#3,d1				; times 8
		move.w	d1,d0				; copy result
		add.w	d1,d1				; times...
		add.w	d0,d1				; ...3 (because default line length 8 x 3 = 24)
	else
		; The above calculation assumes 24 as line length, we need a different approach if it changes.
		mulu.w	#levsel_line_length,d1		; multiply selected line index by line length
	endif
		adda.w	d1,a1				; add to menu text offset
		move.w	#levsel_yellow,d3 		; prepare selected-line VRAM setting
		move.l	d4,4(a6)			; write to VDP
		bsr.w	LevSel_ChgLine			; recolour selected line

		; Write sound test numbers
		move.w	#levsel_white,d3		; draw numbers in white by default
		cmpi.w	#levsel_sndtest_row,(v_levselitem).w ; is currently selected line the sound test?
		bne.s	LevSel_DrawSnd			; if not, branch
		move.w	#levsel_yellow,d3		; draw numbers in yellow
LevSel_DrawSnd:
		locVRAM	levsel_vram_sndtestnum		; write sound test number position to VRAM
		move.w	(v_levselsound).w,d0		; get currently selected sound test number
		addi.w	#$80,d0				; make sound ID to be drawn $80-based
		move.b	d0,d2				; backup number
		lsr.b	#4,d0				; move first digit to lower nybble 
		bsr.w	LevSel_ChgSnd			; draw 1st digit
		move.b	d2,d0				; restore backup
		bsr.w	LevSel_ChgSnd			; draw 2nd digit
		rts
; ===========================================================================

LevSel_ChgSnd:
		andi.w	#$F,d0				; mask out upper nybble
		cmpi.b	#$A,d0				; is digit $A-$F?
		blo.s	.DrawNum			; if not, branch
		addi.b	#7,d0				; use letter characters
.DrawNum:	add.w	d3,d0				; combine number with VRAM setting (white or yellow)
		move.w	d0,(a6)				; send to VRAM
		rts
; ===========================================================================

LevSel_ChgLine:
		moveq	#levsel_line_length-1,d2	; number of characters per line

.LineLoop:	moveq	#0,d0				; clear d0
		move.b	(a1)+,d0			; get current character
		bpl.s	.CharOk				; is it a valid ASCII character? if yes, branch
		move.w	#0,(a6)				; draw a blank character
		dbf	d2,.LineLoop			; loop until all characters are drawn
		rts

.CharOk:	add.w	d3,d0				; combine char with VRAM setting (white or yellow)
		move.w	d0,(a6)				; send to VRAM
		dbf	d2,.LineLoop			; loop until all characters are drawn
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
	;charset '>', $0E ; there are two right arrows in the font for some reason
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
		dc.b bgm_GHZ	; GHZ
		dc.b bgm_LZ	; LZ
		dc.b bgm_MZ	; MZ
		dc.b bgm_SLZ	; SLZ
		dc.b bgm_SYZ	; SYZ
		dc.b bgm_SBZ	; SBZ
		zonewarning MusicList,1
		dc.b bgm_FZ	; Ending
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

; Level:
GM_Level:	; fading out from previous game mode
		bset	#7,(v_gamemode).w		; add $80 to screen mode (for pre level sequence)

		tst.w	(f_demo).w			; is an ending sequence demo running?
		bmi.s	Level_NoMusicFade		; if yes, don't fade out music
		move.b	#bgm_Fade,d0			; queue music fade-out command
		bsr.w	QueueSound2			; fade out music

Level_NoMusicFade:
		bsr.w	ClearPLC			; clear any remaining PLC entries
		bsr.w	PaletteFadeOut			; fade out from the previous screen
; ---------------------------------------------------------------------------

		; load title cards, queue PLCs, setup screen, play music
		tst.w	(f_demo).w			; is an ending sequence demo running?
		bmi.s	Level_ClrRam			; if yes, don't load title screen or main level patterns

		disable_ints				; disable interrupts
		locVRAM	ArtTile_Title_Card*tile_size	; set VRAM target location for title cards
		lea	(Nem_TitleCard).l,a0		; load title card patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM
		enable_ints				; enable interrupts again

		moveq	#0,d0				; clear d0
		move.b	(v_zone).w,d0			; get current Zone ID
		lsl.w	#4,d0				; multiply by $10 (number of bytes per level header entry)
		lea	(LevelHeaders).l,a2		; load level headers
		lea	(a2,d0.w),a2			; get relevant header for current level
		moveq	#0,d0				; clear d0
		move.b	(a2),d0				; get first PLC entry
		beq.s	Level_NoPLC			; if it's null, branch (never the case)
		bsr.w	AddPLC				; load level patterns for current Zone
; loc_37FC:
Level_NoPLC:
		moveq	#plcid_Main2,d0			; load secondary standard patterns (monitors, etc.)
		bsr.w	AddPLC				; (these can be overwritten by stuff like the sign post art)

Level_ClrRam:
		clearRAM v_objspace			; clear object RAM
		clearRAM v_misc_variables		; clear various miscellaneous RAM
		clearRAM v_levelvariables		; clear level variables RAM (camera position, etc.)
		clearRAM v_timingandscreenvariables	; clear various timing and screen RAM (for animated tiles, etc.)

		disable_ints				; disable interrupts
		bsr.w	ClearScreen			; wipe the screen
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8B03,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6)	; set sprite table address
		move.w	#$9001,(a6)			; 64-cell hscroll size
		move.w	#$8004,(a6)			; 8-colour mode
		move.w	#$8720,(a6)			; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_hblank_hreg).w	; set palette change position (for water)
		move.w	(v_hblank_hreg).w,(a6)		; write to VDP

		cmpi.b	#id_LZ,(v_zone).w		; is level LZ?
		bne.s	Level_LoadPal			; if not, branch
		move.w	#$8014,(a6)			; enable horizontal interrupts (HBlank)
		moveq	#0,d0				; clear d0
		move.b	(v_act).w,d0			; get current LZ act
		add.w	d0,d0				; double for word-based indexing
		lea	(WaterHeight).l,a1		; load water height array
		move.w	(a1,d0.w),d0			; get water height entries for current LZ act
		move.w	d0,(v_waterpos1).w		; set water height (actual)
		move.w	d0,(v_waterpos2).w		; set water height (ignoring surface sway)
		move.w	d0,(v_waterpos3).w		; set water height (target)
		clr.b	(v_wtr_routine).w		; clear water routine counter
		clr.b	(f_wtr_state).w			; clear water state
		move.b	#1,(f_water).w			; enable water

Level_LoadPal:
		move.w	#30,(v_air).w			; set Sonic's air timer to 30 seconds
		enable_ints				; enable interrupts

		moveq	#palid_Sonic,d0			; load Sonic's palette...
		bsr.w	PalLoad				; ...directly to active palette (for title cards)
		cmpi.b	#id_LZ,(v_zone).w		; is level LZ?
		bne.s	Level_GetBgm			; if not, branch
		moveq	#palid_LZSonWater,d0		; palette number $F (LZ)
		cmpi.b	#act4,(v_act).w			; check if on act 4 (for SBZ3/LZ4)?
		bne.s	Level_WaterPal			; if not, branch
		moveq	#palid_SBZ3SonWat,d0		; palette number $10 (SBZ3)

Level_WaterPal:
		bsr.w	PalLoad_Fade_Water		; load underwater palette
		tst.b	(v_lastlamp).w			; are we respawning from a checkpoint?
		beq.s	Level_GetBgm			; if not, branch
		move.b	(v_lamp_wtrstat).w,(f_wtr_state).w ; restore water state from checkpoint

Level_GetBgm:
		tst.w	(f_demo).w			; is this a credits demo?
		bmi.s	Level_SkipTtlCard		; if yes, don't load title cards or change music

		moveq	#0,d0				; clear d0
		move.b	(v_zone).w,d0			; get current Zone ID
		cmpi.w	#id_LZ_act4,(v_zone).w		; is level SBZ3 (LZ4)?
		bne.s	Level_BgmNotLZ4			; if not, branch
		moveq	#5,d0				; use 5th music (SBZ)

Level_BgmNotLZ4:
		cmpi.w	#id_FZ,(v_zone).w		; is level FZ?
		bne.s	Level_PlayBgm			; if not, branch
		moveq	#6,d0				; use 6th music (FZ)

Level_PlayBgm:
		lea	(MusicList).l,a1		; load music playlist
		move.b	(a1,d0.w),d0			; get music ID for current level
		bsr.w	QueueSound1			; play music
		move.b	#id_TitleCard,(v_titlecard).w	; load title card object
; ---------------------------------------------------------------------------

Level_TtlCardLoop: ; move in title cards, stay on them until PLCs have finished
		move.b	#id_VBlank_TitleCards,(v_vblank_routine).w ;set VBlank routine to $0C
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		jsr	(ExecuteObjects).l		; execute title cards object
		jsr	(BuildSprites).l		; build sprites to show title cards
		bsr.w	RunPLC				; decompress level graphics
	if FixBugs=0
		move.w	(v_ttlcardact+obX).w,d0		; get current position of the "ACT" element of the title cards
		cmp.w	(v_ttlcardact+card_mainX).w,d0	; has "ACT" element reached its target position?
		bne.s	Level_TtlCardLoop		; if not, loop until it has
	else
		; Check if *every* title card element has reached their target position.
		; Decompression is normally slow enough that every element is able
		; to reach their target position before it's finished, but if
		; decompression is upgraded with something faster, then the risk
		; of decompression finishing and exiting this loop before all of the title
		; card is finished moving into place is increased.
		lea	(v_titlecard).w,a0		; get title card elements
		moveq	#4-1,d0				; number of title card elements

Level_CheckTtlCard:
		move.w	obX(a0),d0			; get current position of a title card element
		cmp.w	card_mainX(a0),d0		; has this title card element reached its target position?
		bne.s	Level_TtlCardLoop		; if not, loop until it has
		lea	object_size(a0),a0		; next title card element
		dbf	d0,Level_CheckTtlCard		; loop until every element has reached its target position
	endif
		tst.l	(v_plc_buffer).w		; have patterns been fully decompressed and loaded?
		bne.s	Level_TtlCardLoop		; if not, loop until they have
; ---------------------------------------------------------------------------

		; PLCs have finished, load/initialize remaining data

	if FixBugs
		; Do VBlank for one extra frame to provide enough processing time
		; for the remaining data initialization below. Without it, it's 
		; possible for VBlank to interrupt in the middle of a transfer,
		; resulting in visual corruption. This will also make title cards
		; smoother should decompression get upgraded with something faster.
		move.b	#id_VBlank_TitleCards,(v_vblank_routine).w ; set VBlank routine to $0C
		bsr.w	WaitForVBlank			; wait until VBlank has finished
	endif

		jsr	(Hud_Base).l			; load basic HUD graphics (only in levels, not in the ending demos)

Level_SkipTtlCard:
		moveq	#palid_Sonic,d0			; load Sonic's palette...
		bsr.w	PalLoad_Fade			; ...to fade-in buffer (just to avoid it turning black, it won't actually fade)
		bsr.w	LevelSizeLoad			; load level size and set default level boundaries
		bsr.w	DeformLayers			; initialize background deformation
		bset	#2,(v_fg_scroll_flags).w	; draw an extra column at the left side of the screen during level start
		bsr.w	LevelDataLoad			; load block mappings and palettes
		bsr.w	LoadTilesFromStart		; fully draw the foreground and background once before fade-in
		jsr	(ConvertCollisionArray).l	; call a routine that immediately returns (this is a disabled development function) 
		bsr.w	ColIndexLoad			; set collision index for current zone
		bsr.w	LZWaterFeatures			; initialize water features if zone is LZ

		move.b	#id_SonicPlayer,(v_player).w	; load Sonic object

		tst.w	(f_demo).w			; is this a credits demo?
		bmi.s	Level_ChkDebug			; if yes, don't load HUD
		move.b	#id_HUD,(v_hud).w		; load HUD object

Level_ChkDebug:
		tst.b	(f_debugcheat).w		; has debug cheat been entered?
		beq.s	Level_ChkWater			; if not, branch
		btst	#bitA,(v_jpadhold1).w		; is A button held?
		beq.s	Level_ChkWater			; if not, branch
		move.b	#1,(f_debugmode).w		; enable debug mode

Level_ChkWater:
		move.w	#0,(v_jpadhold2).w		; clear button input states for Sonic player object
		move.w	#0,(v_jpadhold1).w		; clear actual button input states for controller 1

		cmpi.b	#id_LZ,(v_zone).w		; is level LZ?
		bne.s	Level_LoadObj			; if not, branch
		move.b	#id_WaterSurface,(v_watersurface1).w ; load water surface object A
		move.w	#$60,(v_watersurface1+obX).w	; set base X-position for surface A
		move.b	#id_WaterSurface,(v_watersurface2).w ; load water surface object B
		move.w	#$120,(v_watersurface2+obX).w	; set base X-position for surface B

Level_LoadObj:
		jsr	(ObjPosLoad).l			; initialize object manager
		jsr	(ExecuteObjects).l		; load objects that are already visible during fade-in
		jsr	(BuildSprites).l		; build sprites for objects before fade-in

		moveq	#0,d0				; clear d0
		tst.b	(v_lastlamp).w			; are we starting from a lamppost?
		bne.s	Level_SkipClr			; if yes, branch
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.b	d0,(v_lifecount).w		; clear extra lives flags when getting 100/200 rings

Level_SkipClr:
		move.b	d0,(f_timeover).w		; clear time over flag
		move.b	d0,(v_shield).w			; clear shield
		move.b	d0,(v_invinc).w			; clear invincibility
		move.b	d0,(v_shoes).w			; clear speed shoes
		move.b	d0,(v_unused1).w		; clear unused flag (goggles?)
		move.w	d0,(v_debuguse).w		; exit debug mode if necessary
		move.w	d0,(f_restart).w		; clear level restart flag
		move.w	d0,(v_framecount).w		; reset frames since level start to 0
		bsr.w	OscillateNumInit		; initialize oscillation values
		move.b	#1,(f_scorecount).w		; update score counter
		move.b	#1,(f_ringcount).w		; update rings counter
		move.b	#1,(f_timecount).w		; update time counter

		move.w	#0,(v_btnpushtime1).w		; clear button push counters for demos
		lea	(DemoDataPtr).l,a1		; load demo data
		moveq	#0,d0				; clear d0
		move.b	(v_zone).w,d0			; get current Zone ID
		lsl.w	#2,d0				; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1			; get demo pointer for current level
		tst.w	(f_demo).w			; are we in a regular (not-credits) demo?
		bpl.s	Level_Demo			; if yes, branch
		lea	(DemoEndDataPtr).l,a1		; load ending demo data
		move.w	(v_creditsnum).w,d0		; get current credits page
		subq.w	#1,d0				; subtract by 1
		lsl.w	#2,d0				; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1			; get demo pointer for current credits page

Level_Demo:
		move.b	1(a1),(v_btnpushtime2).w	; load initial demo key press duration
		subq.b	#1,(v_btnpushtime2).w		; subtract 1 from demo key pressduration
		move.w	#1800,(v_generictimer).w	; run regular demos for 30 seconds
		tst.w	(f_demo).w			; is this a regular (not-credits) demo?
		bpl.s	Level_ChkWaterPal		; if not, branch
		move.w	#540,(v_generictimer).w		; run credits demos for 9 seconds each
		cmpi.w	#4,(v_creditsnum).w		; is this credits demo 4? (Labyrint)
		bne.s	Level_ChkWaterPal		; if not, branch
		move.w	#510,(v_generictimer).w		; run this specific demo for 0.5 seconds less

Level_ChkWaterPal:
		cmpi.b	#id_LZ,(v_zone).w		; is level LZ/SBZ3?
		bne.s	Level_Delay			; if not, branch
		moveq	#palid_LZWater,d0		; palette $B (LZ underwater)
		cmpi.b	#act4,(v_act).w			; check if on act 4 (for SBZ3/LZ4)
		bne.s	Level_WtrNotSbz			; if not, branch
		moveq	#palid_SBZ3Water,d0		; palette $D (SBZ3 underwater)

Level_WtrNotSbz:
		bsr.w	PalLoad_Water			; load underwater palette to active palette

Level_Delay:
		move.w	#4-1,d1				; run 4 extra frames of VBlank to do palette transfers

Level_DelayLoop:
		move.b	#id_VBlank_Levels,(v_vblank_routine).w ; set VBlank routine to $08
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		dbf	d1,Level_DelayLoop		; repeat for 4 frames in total

		move.w	#$202F,(v_pfade_start).w	; set to fade in 2nd, 3rd & 4th palette lines
		bsr.w	PalFadeIn_Alt			; fade-in main palette
; ---------------------------------------------------------------------------

		; level has faded in, make title cards move and enter main loop
		tst.w	(f_demo).w			; is an ending sequence demo running?
		bmi.s	Level_ClrCardArt		; if yes, load explosion and animal graphics now
		addq.b	#2,(v_ttlcardname+obRoutine).w	; make title card move (name)
		addq.b	#4,(v_ttlcardzone+obRoutine).w	; make title card move ("ZONE")
		addq.b	#4,(v_ttlcardact+obRoutine).w	; make title card move ("ACT")
		addq.b	#4,(v_ttlcardoval+obRoutine).w	; make title card move (blue oval)
		bra.s	Level_StartGame
; ===========================================================================

Level_ClrCardArt:
		; This portion is only for the credits demos to loads explosions
		; and animal graphics right now, as normally they get loaded by
		; the title cards (which aren't loaded for credits demos).
		moveq	#plcid_Explode,d0		; load explosion graphics
		jsr	(AddPLC).l			; queue PLC
		moveq	#0,d0				; clear d0
		move.b	(v_zone).w,d0			; get current Zone ID
		addi.w	#plcid_GHZAnimals,d0		; add offset to animal patterns (+$15)
		jsr	(AddPLC).l			; load animal patterns

Level_StartGame:
		bclr	#7,(v_gamemode).w		; subtract $80 from mode to end pre-level stuff
		; enter main loop...

; ---------------------------------------------------------------------------
; Main level loop (when all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame			; handle pausing the game when pressing start
		move.b	#id_VBlank_Levels,(v_vblank_routine).w ; set VBlank routine to $08
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		addq.w	#1,(v_framecount).w		; add 1 to level timer

		bsr.w	MoveSonicInDemo			; simulate controls in demos (immediately returns outside demos)
		bsr.w	LZWaterFeatures			; apply water features if in Labyrinth Zone
		jsr	(ExecuteObjects).l		; execute all objects in object RAM

	if Revision<>0
		; For REV01, this code has been relocated from below to also restart levels
		; if Sonic dies in demos, rather than returning to the Sega screen.
		tst.w	(f_restart).w			; is the level set to restart?
		bne.w	GM_Level			; if yes, restart level
	endif
		tst.w	(v_debuguse).w			; is debug mode being used?
		bne.s	Level_DoScroll			; if yes, continue plane scrolling even when dying
		cmpi.b	#6,(v_player+obRoutine).w	; has Sonic just died?
		bhs.s	Level_SkipScroll		; if yes, don't do plane scrolling

Level_DoScroll:
		bsr.w	DeformLayers			; scroll planes and do background deformation

Level_SkipScroll:
		jsr	(BuildSprites).l		; build sprite table
		jsr	(ObjPosLoad).l			; run the object manager to load level objects
		bsr.w	PaletteCycle			; run palette cycles
		bsr.w	RunPLC				; run PLC, if any
		bsr.w	OscillateNumDo			; advance oscillation values
		bsr.w	SynchroAnimate			; advance animation timers
		bsr.w	SignpostArtLoad			; check if sign post art needs to be loaded and lock left boundary

		cmpi.b	#id_Demo,(v_gamemode).w		; are we in a demo?
		beq.s	Level_ChkDemo			; if yes, branch
	if Revision=0
		tst.w	(f_restart).w			; is the level set to restart?
		bne.w	GM_Level			; if yes, restart leve
	endif
		cmpi.b	#id_Level,(v_gamemode).w	; is game mode still set to level?
		beq.w	Level_MainLoop			; if yes, loop level game mode
		rts					; if game mode changed, return to MainGameLoop
; ===========================================================================

Level_ChkDemo:
		tst.w	(f_restart).w			; is level set to restart?
		bne.s	Level_EndDemo			; if yes, branch
		tst.w	(v_generictimer).w		; is there time left on the demo?
		beq.s	Level_EndDemo			; if not, branch
		cmpi.b	#id_Demo,(v_gamemode).w		; is game mode still demo?
		beq.w	Level_MainLoop			; if yes, loop level game mode
		move.b	#id_Sega,(v_gamemode).w		; otherwise, return to Sega screen
		rts					; return to MainGameLoop
; ===========================================================================

Level_EndDemo:
		cmpi.b	#id_Demo,(v_gamemode).w		; is game mode sstill demo?
		bne.s	Level_FadeDemo			; if not, slowly fade-out demo
		move.b	#id_Sega,(v_gamemode).w		; return to Sega screen
		tst.w	(f_demo).w			; is demo mode on & not ending sequence?
		bpl.s	Level_FadeDemo			; if yes, branch
		move.b	#id_Credits,(v_gamemode).w	; return to credits game mode (next credits page)

Level_FadeDemo:
		move.w	#60,(v_generictimer).w		; run fade-out for one second
		move.w	#$003F,(v_pfade_start).w	; set palette fade-out position and size
		clr.w	(v_palchgspeed).w		; do first palette dimming immediately

Level_FDLoop:
		move.b	#id_VBlank_Levels,(v_vblank_routine).w ; set VBlank routine to $08
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		bsr.w	MoveSonicInDemo			; continue updating demo controls during fade-out
		jsr	(ExecuteObjects).l		; continue executing objects during fade-out
		jsr	(BuildSprites).l		; continue building sprites during fade-out
		jsr	(ObjPosLoad).l			; continue running object manager during fade-out

		subq.w	#1,(v_palchgspeed).w		; decrement palette fade-out delay
		bpl.s	Level_FDLoop_NoDim		; if time remains, branch
		move.w	#2,(v_palchgspeed).w		; reset palette fade-out delay
		bsr.w	FadeOut_ToBlack			; dim palette further

; loc_3BC8:
Level_FDLoop_NoDim:
		tst.w	(v_generictimer).w		; has fade-out loop finished?
		bne.s	Level_FDLoop			; if not, loop
		rts					; return to MainGameLoop
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
		moveq	#0,d0				; clear d0
		move.b	(v_zone).w,d0			; get current zone ID
		lsl.w	#2,d0				; multiply by 4 for long-based indexing
		move.l	ColPointers(pc,d0.w),(v_collindex).w ; set collision index pointer for current zone
		rts					; return
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
		; The ending doesn't get an entry, it's hardcoded to Col_GHZ
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
		subq.b	#1,(v_ani0_time).w		; has first timer reached 0?
		bpl.s	Sync2				; if not, branch
		move.b	#12-1,(v_ani0_time).w		; reset first timer to 12 frames
		subq.b	#1,(v_ani0_frame).w		; go to next frame (backwards)
		andi.b	#7,(v_ani0_frame).w 		; limit to frames 0-7

; Used for rings and giant rings
Sync2:
		subq.b	#1,(v_ani1_time).w		; has second timer reached 0?
		bpl.s	Sync3				; if not, branch
		move.b	#8-1,(v_ani1_time).w		; reset second timer to 8 frames
		addq.b	#1,(v_ani1_frame).w		; go to next frame
		andi.b	#3,(v_ani1_frame).w		; limit to frames 0-3

; Used for nothing
Sync3:
		subq.b	#1,(v_ani2_time).w		; has third timer reached 0?
		bpl.s	Sync4				; if not, branch
		move.b	#8-1,(v_ani2_time).w		; reset third timer to 8 frames
		addq.b	#1,(v_ani2_frame).w		; go to next frame
		cmpi.b	#6,(v_ani2_frame).w		; limit to frames 0-5
		blo.s	Sync4				; if still frame 0-5, branch
		move.b	#0,(v_ani2_frame).w		; set to frame 0 when it reached frame 6

; Used for bouncing rings
Sync4:
		tst.b	(v_ani3_time).w			; is ring loss timer active at all?
		beq.s	SyncEnd				; if not, don't advance animation
		moveq	#0,d0				; clear d0
		move.b	(v_ani3_time).w,d0		; get remaining ring loss timer
		add.w	(v_ani3_buf).w,d0		; add buffered timer value
		move.w	d0,(v_ani3_buf).w		; set that as new buffered timer
		rol.w	#7,d0				; align for speed
		andi.w	#3,d0				; limit to frames 0-3
		move.b	d0,(v_ani3_frame).w		; set as current frame for lost rings
		subq.b	#1,(v_ani3_time).w		; decrease ring loss timer

SyncEnd:
		rts					; return
; End of function SynchroAnimate

; ===========================================================================
; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine. Also locks left boundary.
; ---------------------------------------------------------------------------

SignpostArtLoad:
		tst.w	(v_debuguse).w			; is debug mode being used?
		bne.w	.return				; if yes, do not lock screen or load art
		cmpi.b	#act3,(v_act).w			; is this a third act?
		beq.s	.return				; if yes, don't load art (due to the boss fight)

		move.w	(v_screenposx).w,d0		; get current X-camera position
		move.w	(v_limitright2).w,d1		; get right level boundary
		subi.w	#$100,d1			; check for $100 pixels before the right boundary
		cmp.w	d1,d0				; has Sonic reached the right edge of the level?
		blt.s	.return				; if not, branch

		tst.b	(f_timecount).w			; has time already stopped from touching the signpost?
		beq.s	.return				; if yes, branch
		cmp.w	(v_limitleft2).w,d1		; has left boundary already been locked?
		beq.s	.return				; if yes, branch
		move.w	d1,(v_limitleft2).w		; lock left level boundary to current screen position
		moveq	#plcid_Signpost,d0		; load signpost, hidden points, giant ring flash patterns
		bra.w	NewPLC				; add to new PLC queue

.return:
		rts					; return
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
GM_Special:	; white fade-out from previous game mode
		move.w	#sfx_EnterSS,d0			; set special stage entry sound
		bsr.w	QueueSound2			; play it
		bsr.w	PaletteWhiteOut			; fade-out to white
; ---------------------------------------------------------------------------

		; load special stage patterns
		disable_ints				; disable interrupts
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8B03,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#$8004,(a6)			; 8-colour mode
		move.w	#$8A00+175,(v_hblank_hreg).w	; set HBlank counter to scanline 175 (even though horizontal interrupts aren'tused here...)
		move.w	#$9011,(a6)			; 128-cell hscroll size
		disable_display				; disable screen output
		bsr.w	ClearScreen			; wipe screen
		enable_ints				; enable interrupts

		fillVRAM	0, ArtTile_SS_Plane_1*tile_size+plane_size_64x32, ArtTile_SS_Plane_5*tile_size ; clear nametables
		bsr.w	SS_BGLoad			; load background clouds/bubbles/birds/fish mappings
		moveq	#plcid_SpecialStage,d0		; load special stage patterns
		bsr.w	QuickPLC			; execute PLCs immediately (no queue)

		clearRAM v_objspace			; clear object RAM space
		clearRAM v_levelvariables		; clear various level variables
		clearRAM v_timingvariables		; clear various timing variables
		clearRAM v_ngfx_buffer			; clear Nemesis decompression buffer

		clr.b	(f_wtr_state).w			; clear water state
		clr.w	(f_restart).w			; clear level restart flag
		moveq	#palid_Special,d0		; load special stage palette...
		bsr.w	PalLoad_Fade			; ...into the palette fade-in buffer
		jsr	(SS_Load).l			; load SS layout data (based on last stage entered and collected emeralds)
		move.l	#0,(v_screenposx).w		; reset X-camera position
		move.l	#0,(v_screenposy).w		; reset Y-camera position
		move.b	#id_SonicSpecial,(v_player).w	; load special stage Sonic object
		bsr.w	PalCycle_SS			; initialize palette cycle and background for fade-in
		clr.w	(v_ssangle).w			; set stage angle to "upright"
		move.w	#$40,(v_ssrotate).w		; set stage rotation speed
		move.w	#bgm_SS,d0			; play special stage BG music
		bsr.w	QueueSound1			; play it

		move.w	#0,(v_btnpushtime1).w		; clear button push counters for demos
		lea	(DemoDataPtr).l,a1		; load demo data
		moveq	#6,d0				; hardcoded to load the entry for the Special Stage demo
		lsl.w	#2,d0				; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1			; get demo pointer for current level
		move.b	1(a1),(v_btnpushtime2).w	; load initial demo key press duration
		subq.b	#1,(v_btnpushtime2).w		; subtract 1 from demo key pressduration

		clr.w	(v_rings).w			; clear rings
		clr.b	(v_lifecount).w			; clear extra lives flags when getting 100/200 rings

		move.w	#0,(v_debuguse).w		; exit debug mode if necessary
		move.w	#1800,(v_generictimer).w	; run regular demos for 30 seconds
		tst.b	(f_debugcheat).w		; has debug cheat been entered?
		beq.s	SS_NoDebug			; if not, branch
		btst	#bitA,(v_jpadhold1).w		; is A button held?
		beq.s	SS_NoDebug			; if not, branch
		move.b	#1,(f_debugmode).w		; enable debug mode

SS_NoDebug:
		enable_display				; enable screen out-put
		bsr.w	PaletteWhiteIn			; fade-in from white

; ---------------------------------------------------------------------------
; Special Stage main loop
; ---------------------------------------------------------------------------

SS_MainLoop:
		bsr.w	PauseGame			; handle pausing the game when pressing start
		move.b	#id_VBlank_SpecialStage,(v_vblank_routine).w ; set VBlank routine to $0A
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		bsr.w	MoveSonicInDemo			; simulate controls in demos (immediately returns outside demos)
		move.w	(v_jpadhold1).w,(v_jpadhold2).w	; copy controller 1 inputs to Sonic player object inputs

		jsr	(ExecuteObjects).l		; execute Special Stage object
		jsr	(BuildSprites).l		; build sprites
		jsr	(SS_ShowLayout).l		; render Special Stage layout
		bsr.w	SS_BGAnimate			; animate Special Stage background

		tst.w	(f_demo).w			; is demo mode on?
		beq.s	SS_ChkEnd			; if not, branch
		tst.w	(v_generictimer).w		; is there time left on the demo?
		beq.w	SS_ToSegaScreen			; if not, return to Sega screen

SS_ChkEnd:
		cmpi.b	#id_Special,(v_gamemode).w	; is game mode still the Special Stage?
		beq.w	SS_MainLoop			; if yes, loop game mode
; ---------------------------------------------------------------------------

		; Exiting Special Stage...
		tst.w	(f_demo).w			; are we exiting from a demo?
	if Revision=0
		bne.w	SS_ToSegaScreen			; if yes, return to Sega Screen
	else
		; REV01 added a small convenience improvement by returning straight
		; to the title screen when pressing start during the Special Stage demo,
		; rather than always being forced back to the Sega screen.
		bne.w	SS_ToNextScreen			; if yes, return to next game mode
	endif

		move.b	#id_Level,(v_gamemode).w	; set screen mode to $0C (level)
		cmpi.w	#id_FZ+1,(v_zone).w		; is level number higher than FZ (0502)?
		blo.s	SS_Finish			; if not, branch
		clr.w	(v_zone).w			; set to GHZ1 (possibly as a failsafe)


SS_Finish:
		move.w	#60,(v_generictimer).w		; run fade-out for one second
		move.w	#$003F,(v_pfade_start).w	; set palette fade-out position and size
		clr.w	(v_palchgspeed).w		; do first palette brightening immediately

SS_FinLoop:
		move.b	#id_VBlank_Continue,(v_vblank_routine).w ; set VBlank routine to $16 (uses the same one as the continue screen)
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		bsr.w	MoveSonicInDemo			; continue updating demo controls during fade-out
		move.w	(v_jpadhold1).w,(v_jpadhold2).w	; continue copying 1P inputs to Sonic object (even though controls are locked...)
		jsr	(ExecuteObjects).l		; continue executing objects during fade-oout
		jsr	(BuildSprites).l		; continue building sprites during fade-out
		jsr	(SS_ShowLayout).l		; continue rendering Special Stage layout
		bsr.w	SS_BGAnimate			; continue to animate background

		subq.w	#1,(v_palchgspeed).w		; decrement palette fade-out delay
		bpl.s	SS_FinLoop_NoBrighten		; if time remains, branch
		move.w	#2,(v_palchgspeed).w		; reset palette fade-out delay
		bsr.w	WhiteOut_ToWhite		; brighten palette further

; loc_47D4:
SS_FinLoop_NoBrighten:
		tst.w	(v_generictimer).w		; has fade-out loop finished?
		bne.s	SS_FinLoop			; if not, loop
; ---------------------------------------------------------------------------

		; Fade-out done, load Special Stage Results screen
		disable_ints				; disable interrupts
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$9001,(a6)			; 64-cell hscroll size
		bsr.w	ClearScreen			; wipe screen

		locVRAM	ArtTile_Title_Card*tile_size	; set VRAM location for title card font
		lea	(Nem_TitleCard).l,a0		; load title card patterns
		bsr.w	NemDec				; decompress Nemesis-compressed graphics directly to VRAM

		jsr	(Hud_Base).l			; load basic HUD graphics
		enable_ints				; enable interrupts

		moveq	#palid_SSResult,d0		; load Special Stage results screen palette...
		bsr.w	PalLoad				; ...directly to active palette
		moveq	#plcid_Main,d0			; load main patterns (rings, etc.) 
		bsr.w	NewPLC				; add to new PLC queue
		moveq	#plcid_SSResult,d0		; load Special Stage results screen patterns
		bsr.w	AddPLC				; add to PLC queue

		move.b	#1,(f_scorecount).w		; update score counter
		move.b	#1,(f_endactbonus).w		; update ring bonus counter
		move.w	(v_rings).w,d0			; get rings collected in Special Stage
		mulu.w	#10,d0				; award 100 bonus points per collected ring
		move.w	d0,(v_ringbonus).w		; set rings bonus

		move.w	#bgm_GotThrough,d0		; play end-of-level music
		jsr	(QueueSound2).l	 		; play it

		clearRAM v_objspace			; clear object RAM

		move.b	#id_SSResult,(v_ssrescard).w	; load Special Stage Results screen object
; ---------------------------------------------------------------------------

SS_NormalExit:	; Special Stage results screen loop
		bsr.w	PauseGame			; allow pausing during the results screen
		move.b	#id_VBlank_TitleCards,(v_vblank_routine).w ; set VBlank routine to $0C
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		jsr	(ExecuteObjects).l		; execute SSR objects
		jsr	(BuildSprites).l		; build sprites
		bsr.w	RunPLC				; load SSR patterns
		tst.w	(f_restart).w			; has the SSR object signaled that we can exit?
		beq.s	SS_NormalExit			; if not, loop results screen
		tst.l	(v_plc_buffer).w		; is PLC buffer empty?
		bne.s	SS_NormalExit			; if not, loop (pointless here, SSR object has its own check)
; ---------------------------------------------------------------------------

		; Exit Special Stage normally
		move.w	#sfx_EnterSS,d0			; play special stage exit sound
		bsr.w	QueueSound2 			; play it
		bsr.w	PaletteWhiteOut			; fade-out to white
		rts					; return to MainGameLoop
; ===========================================================================

SS_ToSegaScreen:
		move.b	#id_Sega,(v_gamemode).w		; set game mode to Sega screen
		rts					; return to MainGameLoop
; ===========================================================================

	if Revision<>0
; SS_ToLevel: <-- old misnomer
SS_ToNextScreen:
		cmpi.b	#id_Level,(v_gamemode).w	; was demo exited with the instruction to go to a level next?
		beq.s	SS_ToSegaScreen			; if yes, return to the Sega screen instead (if demo finished)
		rts					; otherwise, go to new game mode (which is the title screen, if demo was aborted)
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
		bsr.w	PaletteFadeOut			; fade-out palette from previous game mode

		disable_ints				; disable interrupts
		disable_display				; disable screen output
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8004,(a6)			; 8 colour mode
		move.w	#$8700,(a6)			; background colour
		bsr.w	ClearScreen			; wipe screen

		clearRAM v_objspace			; clear object RAM

		locVRAM	ArtTile_Title_Card*tile_size	; set VRAM location for title card patterns
		lea	(Nem_TitleCard).l,a0		; load title card patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Continue_Sonic*tile_size ; set VRAM location for Sonic on the continue screen
		lea	(Nem_ContSonic).l,a0		; load Sonic patterns
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		locVRAM	ArtTile_Mini_Sonic*tile_size	; set VRAM location for the mini Sonic icons
		lea	(Nem_MiniSonic).l,a0		; load mini Sonic icons
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		moveq	#10,d1				; draw continue screen countdown to start with digits 10
		jsr	(ContScrCounter).l		; initialize countdown

		moveq	#palid_Continue,d0		; load continue screen palette...
		bsr.w	PalLoad_Fade			; ...into fade-in buffer
		move.b	#bgm_Continue,d0		; play continue screen music
		bsr.w	QueueSound1			; play it

		move.w	#659,(v_generictimer).w		; show continue screen for 11 seconds in total

		clr.l	(v_screenposx).w		; clear X-camera position
		move.l	#$1000000,(v_screenposy).w	; set Y-camera position to $100

		move.b	#id_ContSonic,(v_player).w	; load continue screen Sonic object
		move.b	#id_ContScrItem,(v_continuetext).w ; load continue screen objects (text and misc elements)
		move.b	#id_ContScrItem,(v_continuelight).w ; load floor light object Sonic is laying on
		move.b	#3,(v_continuelight+obPriority).w ; set priority to be behind Sonic
		move.b	#4,(v_continuelight+obFrame).w	; set correct frame for the light
		move.b	#id_ContScrItem,(v_continueicon).w ; load continue icons object
		move.b	#4,(v_continueicon+obRoutine).w	; set to continue icons routine

		jsr	(ExecuteObjects).l		; initialize objects
		jsr	(BuildSprites).l		; build sprites
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		enable_display				; enable screen output
		bsr.w	PaletteFadeIn			; fade-in palette

; ---------------------------------------------------------------------------
; Continue screen main loop
; ---------------------------------------------------------------------------

Cont_MainLoop:
		move.b	#id_VBlank_Continue,(v_vblank_routine).w ; set VBlank routine to $16
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		cmpi.b	#6,(v_player+obRoutine).w	; has continue screen Sonic object signaled that we want to continue?
		bhs.s	Cont_NoCountdown		; if yes, stop updating countdown timer

		disable_ints				; disable interrupts
		move.w	(v_generictimer).w,d1		; get remaining time for countdown (in frames)
		divu.w	#60,d1				; divide by 60 to get remaining time in seconds
		andi.l	#$F,d1				; mask off remainder and anything except the end digit
		jsr	(ContScrCounter).l		; update countdown digits
		enable_ints				; enable interrupts again
; loc_4DF2:
Cont_NoCountdown:
		jsr	(ExecuteObjects).l		; execute continue screen objects
		jsr	(BuildSprites).l		; build sprites

		cmpi.w	#320+64,(v_player+obX).w	; has Sonic run off screen after using a continue?
		bhs.s	Cont_GotoLevel			; if yes, return to level and continue game
		cmpi.b	#6,(v_player+obRoutine).w	; has continue screen Sonic object signaled that we want to continue?
		bhs.s	Cont_MainLoop			; if yes, Sonic is still running off-screen, loop until he is gone
		tst.w	(v_generictimer).w		; has countdown run out?
		bne.w	Cont_MainLoop			; if not, loop game mode

		; Continue wasn't used. Game Over.
		move.b	#id_Sega,(v_gamemode).w		; go to Sega screen
		rts					; return to MainGameLoop
; ===========================================================================

Cont_GotoLevel:
		move.b	#id_Level,(v_gamemode).w	; set screen mode to $0C (level)
		move.b	#3,(v_lives).w			; set lives to 3
		moveq	#0,d0				; clear d0
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.l	d0,(v_score).w			; clear score
		move.b	d0,(v_lastlamp).w		; clear lamppost count
		subq.b	#1,(v_continues).w		; subtract 1 from continues
		rts					; return to MainGameLoop
; End of function GM_Continue

; ===========================================================================

; >>> Objects for the continue screen
	include	"_incObj/80 & 81 Continue Screen Elements and Sonic.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence in Green Hill Zone. This is essentially a stripped-down
; copy-paste of regular levels with lots of hardcoding.
; ---------------------------------------------------------------------------

; EndingSequence:
GM_Ending:
		; fading out from previous game mode
		move.b	#bgm_Stop,d0			; set stop music command
		bsr.w	QueueSound2			; stop music
		bsr.w	PaletteFadeOut			; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		clearRAM v_objspace			; clear object RAM
		clearRAM v_misc_variables		; clear various miscellaneous RAM
		clearRAM v_levelvariables		; clear level variables RAM (camera position, etc.)
		clearRAM v_timingandscreenvariables	; clear various timing and screen RAM (for animated tiles, etc.)

		disable_ints				; disable interrupts
		disable_display				; disable screeen output
		bsr.w	ClearScreen			; wipe the screen
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8B03,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6)	; set sprite table address
		move.w	#$9001,(a6)			; 64-cell hscroll size
		move.w	#$8004,(a6)			; 8-colour mode
		move.w	#$8720,(a6)			; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_hblank_hreg).w	; set palette change position (for water)
		move.w	(v_hblank_hreg).w,(a6)		; write to VDP
		move.w	#30,(v_air).w			; replenish air

		move.w	#id_EndZ_good,(v_zone).w	; set to good ending by default (level number 600, extra flowers)
		cmpi.b	#6,(v_emeralds).w		; do you have all 6 emeralds?
		beq.s	End_LoadData			; if yes, use good ending
		move.w	#id_EndZ_bad,(v_zone).w		; otherwise, set to bad ending (level number 601, no extra flowers)

End_LoadData:
		moveq	#plcid_Ending,d0		; load ending sequence patterns (GHZ art, animals, etc.)
		bsr.w	QuickPLC			; execute PLCs immediately (no queue)
		jsr	(Hud_Base).l			; load basic HUD graphics (only in levels, not in the ending demos)
		bsr.w	LevelSizeLoad			; load level size and set default level boundaries
		bsr.w	DeformLayers			; initialize background deformation
		bset	#2,(v_fg_scroll_flags).w	; draw an extra column at the left side of the screen during level start
		bsr.w	LevelDataLoad			; load block mappings and palettes
		bsr.w	LoadTilesFromStart		; fully draw the foreground and background once before fade-in
		move.l	#Col_GHZ,(v_collindex).w	; load collision index (hardcoded to GHZ instead of using ColIndexLoad)
		enable_ints				; enable interrupts

		lea	(Kos_EndFlowers).l,a0		; load extra flower patterns
		lea	(v_256x256_def+$4A*chunk_size).w,a1 ; set RAM address to be used as decompression buffer (this overwrites unused chunk RAM)
		bsr.w	KosDec				; decompress Kosinski-compressed chunks mappings to buffer

		moveq	#palid_Sonic,d0			; load Sonic's palette...
		bsr.w	PalLoad_Fade			; ...to fade-in buffer
		move.w	#bgm_Ending,d0			; play ending sequence music
		bsr.w	QueueSound1			; play it

	if FixBugs
		; Fix being able to enable debug mode without having entered the cheat code for it
		tst.b	(f_debugcheat).w		; has debug cheat been entered?
		beq.s	End_LoadSonic			; if not, branch
	endif
		btst	#bitA,(v_jpadhold1).w		; was button A held while entering ending sequence?
		beq.s	End_LoadSonic			; if not, branch
		move.b	#1,(f_debugmode).w		; enable debug mode

End_LoadSonic:
		move.b	#id_SonicPlayer,(v_player).w	; load Sonic object
		bset	#0,(v_player+obStatus).w	; make Sonic face left
		move.b	#1,(f_lockctrl).w		; lock controls to keep simulating D-Pad
		move.w	#(btnL<<8),(v_jpadhold2).w	; simulate holding down the left D-Pad button to move Sonic
		move.w	#-$800,(v_player+obInertia).w	; set Sonic's initial speed (speed cap immediately limits this to -$600)

		move.b	#id_HUD,(v_hud).w		; load HUD object
		jsr	(ObjPosLoad).l			; run the object manager to load level objects
		jsr	(ExecuteObjects).l		; execute all objects in object RAM
		jsr	(BuildSprites).l		; build sprite table

		moveq	#0,d0				; set d0 to 0
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.b	d0,(v_lifecount).w		; clear extra lives flags when getting 100/200 rings
		move.b	d0,(v_shield).w			; clear shield
		move.b	d0,(v_invinc).w			; clear invincibility
		move.b	d0,(v_shoes).w			; clear speed shoes
		move.b	d0,(v_unused1).w		; clear unused flag (goggles?)
		move.w	d0,(v_debuguse).w		; exit debug mode if necessary
		move.w	d0,(f_restart).w		; clear level restart flag
		move.w	d0,(v_framecount).w		; reset frames since level start to 0
		bsr.w	OscillateNumInit		; initialize oscillation values
		move.b	#1,(f_scorecount).w		; update score counter
		move.b	#1,(f_ringcount).w		; update rings counter
		move.b	#0,(f_timecount).w		; stop time counter for the ending sequence

		move.w	#1800,(v_generictimer).w	; set generic timer to 30 seconds (unused in ending sequence)
		move.b	#id_VBlank_Ending,(v_vblank_routine).w ; set VBlank routine to $18
		bsr.w	WaitForVBlank			; wait until VBlank has finished
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		enable_display				; enable screen output
		move.w	#$003F,(v_pfade_start).w	; set palette fade-in position and size	(redundant)
		bsr.w	PaletteFadeIn			; fade-in palette

; ---------------------------------------------------------------------------
; Ending sequence main loop
; ---------------------------------------------------------------------------

End_MainLoop:
		bsr.w	PauseGame			; allow pausing during the ending sequence
		move.b	#id_VBlank_Ending,(v_vblank_routine).w ; set VBlank routine to $18
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		addq.w	#1,(v_framecount).w		; add 1 to level timer

		bsr.w	End_MoveSonic			; control simulated button inputs for Sonic during the cutscene

		jsr	(ExecuteObjects).l		; execute all objects in object RAM
		bsr.w	DeformLayers			; scroll planes and do background deformation
		jsr	(BuildSprites).l		; build sprite table
		jsr	(ObjPosLoad).l			; run the object manager to load level objects
		bsr.w	PaletteCycle			; run palette cycles
		bsr.w	OscillateNumDo			; advance oscillation values
		bsr.w	SynchroAnimate			; advance animation timers

		cmpi.b	#id_Ending,(v_gamemode).w	; is game mode still set to ending sequence?
		beq.s	End_ChkEmerald			; if yes, branch

		move.b	#id_Credits,(v_gamemode).w	; change game mode to credits
		move.b	#bgm_Credits,d0			; play credits music
		bsr.w	QueueSound2			; play it
		move.w	#0,(v_creditsnum).w		; set credits page number to 0 ("Sonic Team Staff")
		rts					; return to MainGameLoop
; ===========================================================================

End_ChkEmerald:
		tst.w	(f_restart).w			; is level restart flag set? (set while emeralds are spinning in th egood ending)
		beq.w	End_MainLoop			; if not, loop ending sequence game mode normally
; ---------------------------------------------------------------------------

		; prepare slow white-in as the emeralds keep spinning in good ending
		clr.w	(f_restart).w			; clear level restart flag
		move.w	#$003F,(v_pfade_start).w	; prepare fade position and size
		clr.w	(v_palchgspeed).w		; trigger the first brightening immediately
; ---------------------------------------------------------------------------

		
End_AllEmlds:	; during the slow white-in
		bsr.w	PauseGame			; still allow pausing the game
		move.b	#id_VBlank_Ending,(v_vblank_routine).w ; set VBlank routine to $18
		bsr.w	WaitForVBlank			; wait until VBlank has finished
		addq.w	#1,(v_framecount).w		; add 1 to level timer

		bsr.w	End_MoveSonic			; control simulated button inputs for Sonic (redundant at this point)

		jsr	(ExecuteObjects).l		; continue executing objects during white-in
		bsr.w	DeformLayers			; continue upgrading background deformation during white-in
		jsr	(BuildSprites).l		; continue building sprites during white-in
		jsr	(ObjPosLoad).l			; continue running object manager during white-in
		bsr.w	OscillateNumDo			; continue advancing oscillation values during white-in
		bsr.w	SynchroAnimate			; continue advancing animation timers during white-in

		subq.w	#1,(v_palchgspeed).w		; decrement palette white-in delay
		bpl.s	End_SlowFade			; if time remains, branch
		move.w	#2,(v_palchgspeed).w		; reset palette white-in delay
		bsr.w	WhiteOut_ToWhite		; brighten palette further

End_SlowFade:
		tst.w	(f_restart).w			; has flag been set signaling that the emeralds have disappeared?
		beq.w	End_AllEmlds			; if not, loop
; ---------------------------------------------------------------------------

		; screen is fully white and emeralds are gone, update level layout with extra flowers and fade back in
		clr.w	(f_restart).w			; clear level restart flag
		move.w	#$2E2F,(v_lvllayout_fg+layout_row).w ; swap chunks in level layout to the variants with flowers (chunks $2E / $2F) (row 1 / column 0)

		lea	(vdp_control_port).l,a5		; set VDP control port
		lea	(vdp_data_port).l,a6		; set VDP data port
		lea	(v_screenposx).w,a3		; get current foreground X position
		lea	(v_lvllayout_fg).w,a4		; get location in level layout RAM where foreground is stored
		move.w	#$4000,d2			; set VRAM write command to vram_fg nametable start address
		bsr.w	DrawChunks			; update drawn chunks to show the new flowers

		moveq	#palid_Ending,d0		; reload ending palette...
		bsr.w	PalLoad_Fade			; ...to fade-in buffer
		bsr.w	PaletteWhiteIn			; fade-in from white

		bra.w	End_MainLoop			; return to main ending sequence loop for the rest of the scene
; End of function GM_Ending

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence
; ---------------------------------------------------------------------------

End_MoveSonic:
		move.b	(v_sonicend).w,d0		; get ending cutscene routine number
		bne.s	End_MoveSon2			; if it's non-zero, branch to second script

		cmpi.w	#$90,(v_player+obX).w		; has Sonic passed $90 on the X-axis (from the right)?
		bhs.s	End_MoveSonExit			; if not, branch

		addq.b	#2,(v_sonicend).w		; advance ending cutscene routine number
		move.b	#1,(f_lockctrl).w		; lock player's controls (redundant, already locked)
		move.w	#(btnR<<8),(v_jpadhold2).w	; simulate holding down the right D-Pad button to trigger skidding animation
		rts					; return
; ===========================================================================

End_MoveSon2:
		subq.b	#2,d0				; subtract 2 from cutscene routine number
		bne.s	End_MoveSon3			; if it's still non-zero, branch to third script

		cmpi.w	#$A0,(v_player+obX).w		; has Sonic passed $A0 on the X-axis (from the left)?
		blo.s	End_MoveSonExit			; if not, branch

		addq.b	#2,(v_sonicend).w		; advance ending cutscene routine number
		moveq	#0,d0				; clear d0
		move.b	d0,(f_lockctrl).w		; unlock controls (no effect, see below)
		move.w	d0,(v_jpadhold2).w		; clear simulated button inputs to stop Sonic moving
		move.w	d0,(v_player+obInertia).w	; clear ground speed to make Sonic stop immediately
		move.b	#$81,(f_playerctrl).w		; set control ignore and disabled object interaction flags

		move.b	#fr_Wait2,(v_player+obFrame).w	; force Sonic to a specific waiting frame
		move.w	#(id_Wait<<8)+id_Wait,(v_player+obAnim).w ; use "standing" animation and prevent it from getting immediately restarted
		move.b	#3,(v_player+obTimeFrame).w	; set a bit of an animation interval so Sonic keeps looking when he gets replaced on the next frame
		rts					; return
; ===========================================================================

End_MoveSon3:
		subq.b	#2,d0				; subtract 2 from cutscene routine number
		bne.s	End_MoveSonExit			; if it's still non-zero, the below code has already run, branch to do nothing anymore

		addq.b	#2,(v_sonicend).w		; advance ending cutscene routine number
		move.w	#$A0,(v_player+obX).w		; force Sonic to the middle of the screen
		move.b	#id_EndSonic,(v_player).w	; replace real Sonic object with a fake ending sequence Sonic object
		clr.w	(v_player+obRoutine).w		; reset routine counter to initialize fake ending Sonic

End_MoveSonExit:
		rts					; return
; End of function End_MoveSonic

; ===========================================================================

; >>> Objects on the ending sequence
	include	"_incObj/87, 88 & 89 Ending Sequence Sonic, Emeralds, Logo.asm"


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
		bsr.w	ClearPLC			; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut			; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8004,(a6)			; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$9001,(a6)			; 64-cell hscroll size
		move.w	#$9200,(a6)			; window vertical position
		move.w	#$8B03,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#$8720,(a6)			; set background colour (line 3; colour 0)
		clr.b	(f_wtr_state).w			; clear water state
		bsr.w	ClearScreen			; wipe the screen

		clearRAM v_objspace			; clear object RAM

		locVRAM	ArtTile_Credits_Font*tile_size	; set target VRAM location for credits font
		lea	(Nem_CreditText).l,a0		; load credits font
		bsr.w	NemDec				; decompress Nemesis-compressed patterns directly to VRAM

		clearRAM v_palette_fading		; set palette fade-in buffer to all-black
		moveq	#palid_Sonic,d0			; load Sonic's palette...
		bsr.w	PalLoad_Fade			; ...into fade-in buffer

		move.b	#id_CreditsText,(v_credits).w	; load credits text object
		jsr	(ExecuteObjects).l		; execute objects to load credits text object
		jsr	(BuildSprites).l		; build sprites for the credits text object

		bsr.w	EndingDemoLoad			; prepare loading the next ending demo

		moveq	#0,d0				; clear d0
		move.b	(v_zone).w,d0			; get zone ID for next credits demo
		lsl.w	#4,d0				; multiply by $10 (number of bytes per level header entry)
		lea	(LevelHeaders).l,a2		; load level headers
		lea	(a2,d0.w),a2			; get relevant header for next credits demo
		moveq	#0,d0				; clear d0
		move.b	(a2),d0				; get first PLC entry
		beq.s	Cred_SkipObjGfx			; if it's null, branch (never the case)
		bsr.w	AddPLC				; load level patterns for next credits demo

Cred_SkipObjGfx:
		moveq	#plcid_Main2,d0			; load secondary standard patterns
		bsr.w	AddPLC				; (monitors, etc.)
; ---------------------------------------------------------------------------

		; fade-in palette and enter wait loop
		move.w	#120,(v_generictimer).w		; display a single credits page for 2 seconds
		bsr.w	PaletteFadeIn			; fade-in palette

; ---------------------------------------------------------------------------
; Credits page main loop (only shown for 2 seconds)
; ---------------------------------------------------------------------------

Cred_WaitLoop:	; while a credits page is displayed and graphics are getting decompressed
		move.b	#id_VBlank_Title,(v_vblank_routine).w ; set VBlank routine to $04 (uses the same one as the title screen)
		bsr.w	WaitForVBlank			; wait until VBlank has finished

		bsr.w	RunPLC				; decompress level graphics

		tst.w	(v_generictimer).w		; have at least 2 seconds elapsed?
		bne.s	Cred_WaitLoop			; if not, loop
		tst.l	(v_plc_buffer).w		; have 2 seconds elapsed but level gfx have not finished decompressing?
		bne.s	Cred_WaitLoop			; if yes, still loop until graphics are finished
; ---------------------------------------------------------------------------

		; credits page has finished displaying, go to next game mode
		cmpi.w	#9,(v_creditsnum).w		; are we past the final credits page?
		beq.w	TryAgainEnd			; if yes, go to Try Again/End screen instead
		rts					; otherwise, return to MainGameLoop to enter Demo mode
; End of function GM_Credits

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence demo loading subroutine
; ---------------------------------------------------------------------------

EndingDemoLoad:
		move.w	(v_creditsnum).w,d0		; get current credits page
		andi.w	#$F,d0				; limit to 16 possible entries (redundant)
		add.w	d0,d0				; double for word-based indexing
		move.w	EndDemo_Levels(pc,d0.w),d0	; get relevant zone and act for the next credits demo
		move.w	d0,(v_zone).w			; set level from level array

		addq.w	#1,(v_creditsnum).w		; increase credits page number for next time
		cmpi.w	#9,(v_creditsnum).w		; are we past the final credits page now?
		bhs.s	EndDemo_Exit			; if yes, don't load another demo

		move.w	#$8001,(f_demo).w 		; set demo mode to its credits/ending variant
		move.b	#id_Demo,(v_gamemode).w		; set game mode to demo (activates once credits page has finished)

		move.b	#3,(v_lives).w			; set lives to 3
		moveq	#0,d0				; set d0 to 0
		move.w	d0,(v_rings).w			; clear rings
		move.l	d0,(v_time).w			; clear time
		move.l	d0,(v_score).w			; clear score
		move.b	d0,(v_lastlamp).w		; clear lamppost counter

		cmpi.w	#4,(v_creditsnum).w		; is specifically the 4th demo about to run? (SLZ demo)
		bne.s	EndDemo_Exit			; if not, branch
		lea	(EndDemo_LampVar).l,a1		; load special lamppost variables for SLZ demo
		lea	(v_lastlamp).w,a2		; write to lamppost buffer
		move.w	#(EndDemo_LampVar_End-EndDemo_LampVar)/4-1,d0 ; write for all entries
EndDemo_LampLoad:
		move.l	(a1)+,(a2)+			; copy lamppost variables for SLZ demo
		dbf	d0,EndDemo_LampLoad		; loop until everything is loaded

EndDemo_Exit:
		rts					; return
; End of function EndingDemoLoad

; ---------------------------------------------------------------------------
; Levels used in the end sequence demos
; ---------------------------------------------------------------------------

EndDemo_Levels:	; previously in "misc/Demo Level Order - Ending.bin"
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
		dc.b 1,	1				; number of the last lamppost
		dc.w $A00, $62C				; x/y-axis position
		dc.w 13					; rings
		dc.l 0					; time
		dc.b 0,	0				; dynamic level event routine counter
		dc.w $800				; level bottom boundary
		dc.w $957, $5CC				; x/y axis screen position
		dc.w $4AB, $3A6, 0, $28C, 0, 0		; scroll info
		dc.w $308				; water height
		dc.b 1,	1				; water routine and state
EndDemo_LampVar_End:
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; "TRY AGAIN" screen (bad ending) and "END" screen (good ending). This is
; essentially a full game mode, although it's not called from the main
; game mode array, but rather directly from the credits.
; ---------------------------------------------------------------------------

; TryAgainScreen:
TryAgainEnd:	; fading out from previous game mode
		bsr.w	ClearPLC			; stop any potential in-progress PLC
		bsr.w	PaletteFadeOut			; fade-out previous game mode
; ---------------------------------------------------------------------------

		; screen setup and loading patterns
		lea	(vdp_control_port).l,a6		; load VDP control port
		move.w	#$8004,(a6)			; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6)	; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)	; set background nametable address
		move.w	#$9001,(a6)			; 64-cell hscroll size
		move.w	#$9200,(a6)			; window vertical position
		move.w	#$8B03,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#$8720,(a6)			; set background colour (line 3; colour 0)
		clr.b	(f_wtr_state).w			; clear water state
		bsr.w	ClearScreen			; wipe the screen

		clearRAM v_objspace			; clear object RAM

		moveq	#plcid_TryAgain,d0		; load "TRY AGAIN" and "END" patterns
		bsr.w	QuickPLC			; execute PLCs immediately (no queue)

		clearRAM v_palette_fading		; set palette fade-in buffer to all-black
		moveq	#palid_Ending,d0		; load ending palette...
		bsr.w	PalLoad_Fade			; ...to fade-in buffer
		clr.w	(v_palette_fading_line_3).w	; ensure the backdrop color is black

		move.b	#id_EndEggman,(v_endeggman).w	; load end Eggman object
		jsr	(ExecuteObjects).l		; execute objects to load end objects
		jsr	(BuildSprites).l		; build sprites for end objects
; ---------------------------------------------------------------------------

		; fade-in palette and enter main loop
		move.w	#1800,(v_generictimer).w	; automatically return to Sega screen after 30 seconds
		bsr.w	PaletteFadeIn			; fade-in palette

; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END" screen main loop
; ---------------------------------------------------------------------------

TryAg_MainLoop:
		bsr.w	PauseGame			; allow to pause game (redundant, start exits the screen)
		move.b	#id_VBlank_Title,(v_vblank_routine).w ; set VBlank routine to $04 (uses the same one as the title screen)
		bsr.w	WaitForVBlank			; wait until VBlank has finished

		jsr	(ExecuteObjects).l		; update end objects
		jsr	(BuildSprites).l		; build sprites for end objects

		andi.b	#btnStart,(v_jpadpress1).w	; has Start button been pressed?
		bne.s	TryAg_Exit			; if yes, exit end screen
		tst.w	(v_generictimer).w		; have 30 seconds elapsed?
		beq.s	TryAg_Exit			; if yes, exit end screen
		cmpi.b	#id_Credits,(v_gamemode).w	; is game mode still set to show the end screen?
		beq.s	TryAg_MainLoop			; if yes, loop
; ---------------------------------------------------------------------------

TryAg_Exit:	; exit end screen and restart the gam
		move.b	#id_Sega,(v_gamemode).w		; set game mode to Sega screen
		rts					; return to MainGameLoop
; End of function TryAgainEnd
; ===========================================================================

; >>> Objects on final screen
	include	"_incObj/8B & 8C Try Again, End Eggman, End Emeralds.asm"


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
		include	"_incObj/11 Bridge.asm"
Map_Bri:	include	"_maps/Bridge.asm"
		include	"_incObj/15 Swinging Platforms.asm"
Map_Swing_GHZ:	include	"_maps/Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:	include	"_maps/Swinging Platforms (SLZ).asm"
		include	"_incObj/17 Spiked Pole Helix.asm"
Map_Hel:	include	"_maps/Spiked Pole Helix.asm"
		include	"_incObj/18 Platforms.asm"
Map_Plat_Unused:include	"_maps/Platforms (unused).asm"
Map_Plat_GHZ:	include	"_maps/Platforms (GHZ).asm"
Map_Plat_SYZ:	include	"_maps/Platforms (SYZ).asm"
Map_Plat_SLZ:	include	"_maps/Platforms (SLZ).asm"
		include	"_incObj/19.asm" ; this was the rolling GHZ ball in the prototype
Map_GBall:	include	"_maps/GHZ Ball.asm"
		include	"_incObj/1A Collapsing Ledge.asm"
		include	"_incObj/53 Collapsing Floors.asm"	; includes "Ledge_Fragment" and "SlopeObject2" subroutines
Map_Ledge:	include	"_maps/Collapsing Ledge.asm"
Map_CFlo:	include	"_maps/Collapsing Floors.asm"
		include	"_incObj/1C Scenery.asm"
Map_Scen:	include	"_maps/Scenery.asm"
		include	"_incObj/1D Unused Switch.asm"
Map_Swi:	include	"_maps/Unused Switch.asm"
		include	"_incObj/2A SBZ Small Door.asm"
		include	"_anim/SBZ Small Door.asm"
Map_ADoor:	include	"_maps/SBZ Small Door.asm"
		include	"_incObj/44 GHZ Edge Walls (part 2).asm"


; ===========================================================================
; >>> Badniks, explosions, and Badnik-related objects
		include	"_incObj/1E Ball Hog.asm"
		include	"_incObj/20 Cannonball.asm"
		include	"_incObj/24, 27 & 3F Explosions.asm"
		include	"_anim/Ball Hog.asm"
Map_Hog:	include	"_maps/Ball Hog.asm"
Map_UnkExplode:	include	"_maps/Unused Explosion.asm"
		include	"_maps/Explosions.asm"
		include	"_incObj/28 Animals.asm"
		include	"_incObj/29 Points.asm"
Map_Animal1:	include	"_maps/Animals 1.asm"
Map_Animal2:	include	"_maps/Animals 2.asm"
Map_Animal3:	include	"_maps/Animals 3.asm"
Map_Poi:	include	"_maps/Points.asm"
		include	"_incObj/1F Crabmeat.asm"
		include	"_anim/Crabmeat.asm"
Map_Crab:	include	"_maps/Crabmeat.asm"
		include	"_incObj/22 Buzz Bomber.asm"
		include	"_incObj/23 Buzz Bomber Missile.asm"
		include	"_anim/Buzz Bomber.asm"
		include	"_anim/Buzz Bomber Missile.asm"
Map_Buzz:	include	"_maps/Buzz Bomber.asm"
Map_Missile:	include	"_maps/Buzz Bomber Missile.asm"


; ===========================================================================
; >>> Rings and monitors
		include	"_incObj/25 & 37 Rings.asm"
		include	"_incObj/4B Giant Ring.asm"
		include	"_incObj/7C Ring Flash.asm"
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
		include	"_incObj/26 Monitor.asm"
		include	"_incObj/2E Monitor Content Power-Up.asm"
		include	"_incObj/26 Monitor (SolidSides subroutine).asm"
		include	"_anim/Monitor.asm"
Map_Monitor:	include	"_maps/Monitor.asm"


; ===========================================================================
; >>> Title screen objects
		include	"_incObj/0E Title Screen Sonic.asm"
		include	"_incObj/0F Press Start and TM.asm"
		include	"_anim/Title Screen Sonic.asm"
		include	"_anim/Press Start and TM.asm"
		include	"_incObj/sub AnimateSprite.asm"
Map_PSB:	include	"_maps/Press Start and TM.asm"
Map_TSon:	include	"_maps/Title Screen Sonic.asm"


; ===========================================================================
; >>> More Badniks and level objects
		include	"_incObj/2B Chopper.asm"
		include	"_anim/Chopper.asm"
Map_Chop:	include	"_maps/Chopper.asm"
		include	"_incObj/2C Jaws.asm"
		include	"_anim/Jaws.asm"
Map_Jaws:	include	"_maps/Jaws.asm"
		include	"_incObj/2D Burrobot.asm"
		include	"_anim/Burrobot.asm"
Map_Burro:	include	"_maps/Burrobot.asm"
		include	"_incObj/2F MZ Large Grassy Platforms.asm"
		include	"_incObj/35 Burning Grass.asm"
		include	"_anim/Burning Grass.asm"
Map_LGrass:	include	"_maps/MZ Large Grassy Platforms.asm"
Map_Fire:	include	"_maps/Fireballs.asm"
		include	"_incObj/30 MZ Large Green Glass Blocks.asm"
Map_Glass:	include	"_maps/MZ Large Green Glass Blocks.asm"
		include	"_incObj/31 Chained Stompers.asm"
		include	"_incObj/45 Sideways Stomper.asm"
Map_CStom:	include	"_maps/Chained Stompers.asm"
Map_SStom:	include	"_maps/Sideways Stomper.asm"
		include	"_incObj/32 Button.asm"
Map_But:	include	"_maps/Button.asm"
		include	"_incObj/33 Pushable Blocks.asm"
Map_Push:	include	"_maps/Pushable Blocks.asm"


; ===========================================================================
; >>> Title card objects
		include	"_incObj/34 Title Cards.asm"
		include	"_incObj/39 Game Over.asm"
		include	"_incObj/3A Got Through Card.asm"
		include	"_incObj/7E Special Stage Results.asm"
		include	"_incObj/7F SS Result Chaos Emeralds.asm"
		include	"_maps/Title Cards.asm"	; includes "Map_Card", "Map_Over", "Map_Got", and "Map_SSR"
Map_SSRC:	include	"_maps/SS Result Chaos Emeralds.asm"


; ===========================================================================
; >>> More level objects
		include	"_incObj/36 Spikes.asm"
Map_Spike:	include	"_maps/Spikes.asm"
		include	"_incObj/3B Purple Rock.asm"
		include	"_incObj/49 Waterfall Sound.asm"
Map_PRock:	include	"_maps/Purple Rock.asm"
		include	"_incObj/3C Smashable Wall.asm"
		include	"_incObj/sub SmashObject.asm"
Map_Smash:	include	"_maps/Smashable Walls.asm"


; ===========================================================================
; Subroutines to run, render, and update objects
		include	"_inc/ExecuteObjects.asm"
		include	"_inc/Object Pointers.asm" ; includes Obj_Index
		include	"_incObj/sub ObjectFall.asm"
		include	"_incObj/sub SpeedToPos.asm"
		include	"_incObj/sub DisplaySprite.asm"
		include	"_incObj/sub DeleteObject.asm"
		include	"_inc/BuildSprites.asm"
		include	"_incObj/sub ChkObjectVisible.asm"
		include	"_inc/ObjPosLoad.asm"
		include	"_incObj/sub FindFreeObj.asm"


; ===========================================================================
; >>> More level obejcts
		include	"_incObj/41 Springs.asm"
		include	"_anim/Springs.asm"
Map_Spring:	include	"_maps/Springs.asm"
		include	"_incObj/42 Newtron.asm"
		include	"_anim/Newtron.asm"
Map_Newt:	include	"_maps/Newtron.asm"
		include	"_incObj/43 Roller.asm"
		include	"_anim/Roller.asm"
Map_Roll:	include	"_maps/Roller.asm"
		include	"_incObj/44 GHZ Edge Walls (part 1).asm"
Map_Edge:	include	"_maps/GHZ Edge Walls.asm"
		include	"_incObj/13 Lava Ball Maker.asm"
		include	"_incObj/14 Lava Ball.asm"
		include	"_anim/Fireballs.asm"
		include	"_incObj/6D Flamethrower.asm"
		include	"_anim/Flamethrower.asm"
Map_Flame:	include	"_maps/Flamethrower.asm"
		include	"_incObj/46 MZ Bricks.asm"
Map_Brick:	include	"_maps/MZ Bricks.asm"
		include	"_incObj/12 Light.asm"
Map_Light	include	"_maps/Light.asm"
		include	"_incObj/47 Bumper.asm"
		include	"_anim/Bumper.asm"
Map_Bump:	include	"_maps/Bumper.asm"
		include	"_incObj/0D Signpost.asm" ; includes "GotThroughAct" subroutine
		include	"_anim/Signpost.asm"
Map_Sign:	include	"_maps/Signpost.asm"
		include	"_incObj/4C & 4D Lava Geyser Maker.asm"
		include	"_incObj/4E Wall of Lava.asm"
		include	"_incObj/54 Lava Tag.asm"
Map_LTag:	include	"_maps/Lava Tag.asm"
		include	"_anim/Lava Geyser.asm"
		include	"_anim/Wall of Lava.asm"
Map_Geyser:	include	"_maps/Lava Geyser.asm"
Map_LWall:	include	"_maps/Wall of Lava.asm"
		include	"_incObj/40 Moto Bug.asm" ; includes "_incObj/sub RememberState.asm" subroutine
		include	"_anim/Moto Bug.asm"
Map_Moto:	include	"_maps/Moto Bug.asm"
		include	"_incObj/4F.asm" ; this was Splats in the prototype
		include	"_incObj/50 Yadrin.asm"
		include	"_anim/Yadrin.asm"
Map_Yad:	include	"_maps/Yadrin.asm"
		include	"_incObj/sub SolidObject.asm"
		include	"_incObj/51 Smashable Green Block.asm"
Map_Smab:	include	"_maps/Smashable Green Block.asm"
		include	"_incObj/52 Moving Blocks.asm"
Map_MBlock:	include	"_maps/Moving Blocks (MZ and SBZ).asm"
Map_MBlockLZ:	include	"_maps/Moving Blocks (LZ).asm"
		include	"_incObj/55 Basaran.asm"
		include	"_anim/Basaran.asm"
Map_Bas:	include	"_maps/Basaran.asm"
		include	"_incObj/56 Floating Blocks and Doors.asm"
Map_FBlock:	include	"_maps/Floating Blocks and Doors.asm"
		include	"_incObj/57 Spiked Ball and Chain.asm"
Map_SBall:	include	"_maps/Spiked Ball and Chain (SYZ).asm"
Map_SBall2:	include	"_maps/Spiked Ball and Chain (LZ).asm"
		include	"_incObj/58 Big Spiked Ball.asm"
Map_BBall:	include	"_maps/Big Spiked Ball.asm"
		include	"_incObj/59 SLZ Elevators.asm"
Map_Elev:	include	"_maps/SLZ Elevators.asm"
		include	"_incObj/5A SLZ Circling Platform.asm"
Map_Circ:	include	"_maps/SLZ Circling Platform.asm"
		include	"_incObj/5B Staircase.asm"
Map_Stair:	include	"_maps/Staircase.asm"
		include	"_incObj/5C Pylon.asm"
Map_Pylon:	include	"_maps/Pylon.asm"
		include	"_incObj/1B Water Surface.asm"
Map_Surf:	include	"_maps/Water Surface.asm"
		include	"_incObj/0B Pole that Breaks.asm"
Map_Pole:	include	"_maps/Pole that Breaks.asm"
		include	"_incObj/0C Flapping Door.asm"
		include	"_anim/Flapping Door.asm"
Map_Flap:	include	"_maps/Flapping Door.asm"
		include	"_incObj/71 Invisible Barriers.asm"
Map_Invis:	include	"_maps/Invisible Barriers.asm"
		include	"_incObj/5D Fan.asm"
Map_Fan:	include	"_maps/Fan.asm"
		include	"_incObj/5E Seesaw.asm"
Map_Seesaw:	include	"_maps/Seesaw.asm"
Map_SSawBall:	include	"_maps/Seesaw Ball.asm"
		include	"_incObj/5F Bomb Enemy.asm"
		include	"_anim/Bomb Enemy.asm"
Map_Bomb:	include	"_maps/Bomb Enemy.asm"
		include	"_incObj/60 Orbinaut.asm"
		include	"_anim/Orbinaut.asm"
Map_Orb:	include	"_maps/Orbinaut.asm"
		include	"_incObj/16 Harpoon.asm"
		include	"_anim/Harpoon.asm"
Map_Harp:	include	"_maps/Harpoon.asm"
		include	"_incObj/61 LZ Blocks.asm"
Map_LBlock:	include	"_maps/LZ Blocks.asm"
		include	"_incObj/62 Gargoyle.asm"
Map_Gar:	include	"_maps/Gargoyle.asm"
		include	"_incObj/63 LZ Conveyor.asm"
Map_LConv:	include	"_maps/LZ Conveyor.asm"
		include	"_incObj/64 Bubbles.asm"
		include	"_anim/Bubbles.asm"
Map_Bub:	include	"_maps/Bubbles.asm"
		include	"_incObj/65 Waterfalls.asm"
		include	"_anim/Waterfalls.asm"
Map_WFall:	include	"_maps/Waterfalls.asm"


; ===========================================================================
; >>> Main Sonic player object
		include	"_incObj/01 Sonic.asm"


; ===========================================================================
; >>> Various unique objects
		include	"_incObj/0A Drowning Countdown.asm"
		include	"_incObj/sub ResumeMusic.asm"
		include	"_anim/Drowning Countdown.asm"
Map_Drown:	include	"_maps/Drowning Countdown.asm"
		include	"_incObj/38 Shield and Invincibility.asm"
		include	"_incObj/4A Special Stage Entry (Unused).asm"
		include	"_incObj/08 Water Splash.asm"
		include	"_anim/Shield and Invincibility.asm"
Map_Shield:	include	"_maps/Shield and Invincibility.asm"
		include	"_anim/Special Stage Entry (Unused).asm"
Map_Vanish:	include	"_maps/Special Stage Entry (Unused).asm"
		include	"_anim/Water Splash.asm"
Map_Splash:	include	"_maps/Water Splash.asm"


; ===========================================================================
; >>> Collision subroutines for Sonic and other objects
		include	"_incObj/Sonic AnglePos.asm"
		include	"_incObj/sub FindNearestTile.asm"
		include	"_incObj/sub FindFloor.asm"
		include	"_incObj/sub FindWall.asm"
		include "_incObj/sub ConvertCollisionArray (Unused).asm"
		include	"_incObj/Sonic Collision.asm"


; ===========================================================================
; >>> More level objects
		include	"_incObj/66 Rotating Junction.asm"
Map_Jun:	include	"_maps/Rotating Junction.asm"
		include	"_incObj/67 Running Disc.asm"
Map_Disc:	include	"_maps/Running Disc.asm"
		include	"_incObj/68 Conveyor Belt.asm"
		include	"_incObj/69 SBZ Spinning Platforms.asm"
		include	"_anim/SBZ Spinning Platforms.asm"
Map_Trap:	include	"_maps/Trapdoor.asm"
Map_Spin:	include	"_maps/SBZ Spinning Platforms.asm"
		include	"_incObj/6A Saws and Pizza Cutters.asm"
Map_Saw:	include	"_maps/Saws and Pizza Cutters.asm"
		include	"_incObj/6B SBZ Stomper and Door.asm"
Map_Stomp:	include	"_maps/SBZ Stomper and Door.asm"
		include	"_incObj/6C SBZ Vanishing Platforms.asm"
		include	"_anim/SBZ Vanishing Platforms.asm"
Map_VanP:	include	"_maps/SBZ Vanishing Platforms.asm"
		include	"_incObj/6E Electrocuter.asm"
		include	"_anim/Electrocuter.asm"
Map_Elec:	include	"_maps/Electrocuter.asm"
		include	"_incObj/6F SBZ Spin Platform Conveyor.asm"
		include	"_incObj/70 Girder Block.asm"
Map_Gird:	include	"_maps/Girder Block.asm"
		include	"_incObj/72 Teleporter.asm"
		include	"_incObj/78 Caterkiller.asm"
		include	"_anim/Caterkiller.asm"
Map_Cat:	include	"_maps/Caterkiller.asm"
		include	"_incObj/79 Lamppost.asm"
Map_Lamp:	include	"_maps/Lamppost.asm"
		include	"_incObj/7D Hidden Bonuses.asm"
Map_Bonus:	include	"_maps/Hidden Bonuses.asm"
		include	"_incObj/8A Credits.asm"
Map_Cred:	include	"_maps/Credits.asm"


; ===========================================================================
; >>> Bosses and related objects
		include	"_incObj/3D Boss - Green Hill.asm"	; includes "BossDeafeated" and "BossMove" subroutines
		include	"_incObj/48 Eggman's Swinging Ball.asm"
		include	"_anim/Eggman.asm"
Map_Eggman:	include	"_maps/Eggman.asm"
Map_BossItems:	include	"_maps/Boss Items.asm"
		include	"_incObj/77 Boss - Labyrinth.asm"
		include	"_incObj/73 Boss - Marble.asm"
		include	"_incObj/74 MZ Boss Fire.asm"
		include	"_incObj/7A Boss - Star Light.asm"
		include	"_incObj/7B SLZ Boss Spikeball.asm"
Map_BSBall:	include	"_maps/SLZ Boss Spikeball.asm"
		include	"_incObj/75 Boss - Spring Yard.asm"
		include	"_incObj/76 SYZ Boss Blocks.asm"
Map_BossBlock:	include	"_maps/SYZ Boss Blocks.asm"
		include	"_incObj/82 Eggman - Scrap Brain 2.asm"
		include	"_anim/Eggman - Scrap Brain 2 & Final.asm"
Map_SEgg:	include	"_maps/Eggman - Scrap Brain 2.asm"
		include	"_incObj/83 SBZ Eggman's Crumbling Floor.asm"
Map_FFloor:	include	"_maps/SBZ Eggman's Crumbling Floor.asm"
		include	"_incObj/85 Boss - Final.asm"
		include	"_anim/FZ Eggman in Ship.asm"
Map_FZDamaged:	include	"_maps/FZ Damaged Eggmobile.asm"
Map_FZLegs:	include	"_maps/FZ Eggmobile Legs.asm"
		include	"_incObj/84 FZ Eggman's Cylinders.asm"
Map_EggCyl:	include	"_maps/FZ Eggman's Cylinders.asm"
		include	"_incObj/86 FZ Plasma Ball Launcher.asm"
		include	"_anim/Plasma Ball Launcher.asm"
Map_PLaunch:	include	"_maps/Plasma Ball Launcher.asm"
		include	"_anim/Plasma Balls.asm"
Map_Plasma:	include	"_maps/Plasma Balls.asm"
		include	"_incObj/3E Prison Capsule.asm"
		include	"_anim/Prison Capsule.asm"
Map_Pri:	include	"_maps/Prison Capsule.asm"


; ===========================================================================
; >>> Object-to-object touch response handler for Sonic
		include	"_incObj/sub ReactToItem.asm"


; ===========================================================================
; >>> Special Stage rendering and objects
		include	"_inc/Special Stage Loading & Drawing.asm" ; includes the subroutines "SS_ShowLayout", "SS_AniWallsRings", 
								   ; "SS_RemoveCollectedItem", "SS_AniItems", and "SS_Load"
SS_MapIndex:	include	"_inc/Special Stage Mappings & VRAM Pointers.asm"
SS_MapIndex_End:
Map_SS_R:	include	"_maps/SS R Block.asm"
Map_SS_Glass:	include	"_maps/SS Glass Block.asm"
Map_SS_Up:	include	"_maps/SS UP Block.asm"
Map_SS_Down:	include	"_maps/SS DOWN Block.asm"
		include	"_maps/SS Chaos Emeralds.asm"
		include	"_incObj/09 Sonic in Special Stage.asm"

; ===========================================================================
; >>> Deleted, blank object that is randomly mixed in here
		include	"_incObj/10.asm" ; this was an animation test object for Sonic in the prototype


; ===========================================================================
; >>> Subroutine for in-place level animations in VRAM
		include	"_inc/AnimateLevelGfx.asm"


; ===========================================================================
; >>> HUD objects
		include	"_incObj/21 HUD.asm"
Map_HUD:	include	"_maps/HUD.asm"
		include	"_incObj/sub AddPoints.asm"
		include	"_inc/HUD Update.asm"	; includes "ContScrCounter" subroutine

Art_Hud:	binclude "artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	binclude "artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
		even


; ===========================================================================
; >>> Debug Mode
		include	"_incObj/DebugMode.asm"
		include	"_inc/DebugList.asm"


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
			dc.b	[$300]$FF
		endif
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Compressed graphics and mappings - Sega screen
; ---------------------------------------------------------------------------
	if Revision=0
Nem_SegaLogo:	binclude	"artnem/Sega Logo (REV00).nem"	; large Sega logo
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

Art_Sonic:	binclude	"artunc/Sonic.bin"	; Sonic
		even

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
	if Revision=0
Nem_Smoke:	binclude	"artnem/Unused - Smoke.nem"
		even
Nem_SyzSparkle:	binclude	"artnem/Unused - SYZ Sparkles.nem"
		even
	endif

Nem_Shield:	binclude	"artnem/Shield.nem"
		even
Nem_Stars:	binclude	"artnem/Invincibility Stars.nem"
		even

	if Revision=0
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
Nem_SSRBlock:	binclude	"artnem/Special R.nem"	; special stage R block
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
Nem_SSWBlock:	binclude	"artnem/Special W.nem"	; special stage W block
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
Nem_GhzUnkBlock:binclude	"artnem/Unused - GHZ Block.nem"
		even
Nem_Ball:	binclude	"artnem/GHZ Giant Ball.nem"
		even
Nem_Spikes:	binclude	"artnem/Spikes.nem"
		even
Nem_GhzLog:	binclude	"artnem/Unused - GHZ Log.nem"
		even
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
Nem_UnkGrass:	binclude	"artnem/Unused - Grass.nem"
		even
Nem_MzFire:	binclude	"artnem/Fireballs.nem"
		even
Nem_Lava:	binclude	"artnem/MZ Lava.nem"
		even
Nem_MzBlock:	binclude	"artnem/MZ Green Pushable Block.nem"
		even
Nem_MzUnkBlock:	binclude	"artnem/Unused - MZ Background.nem"
		even

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
Nem_UnkExplode:	binclude	"artnem/Unused - Explosion.nem"
		even
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
Nem_Splats:	binclude	"artnem/Enemy Splats.nem"
		even
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
Nem_Hud:	binclude	"artnem/HUD.nem"	; HUD (rings, time, score)
		even
Nem_Lives:	binclude	"artnem/HUD - Life Counter Icon.nem"
		even
Nem_Ring:	binclude	"artnem/Rings.nem"
		even
Nem_Monitors:	binclude	"artnem/Monitors.nem"
		even
Nem_Explode:	binclude	"artnem/Explosion.nem"
		even
Nem_Points:	binclude	"artnem/Points.nem"	; points from destroyed enemy or object
		even
Nem_GameOver:	binclude	"artnem/Game Over.nem"	; game over / time over
		even
Nem_HSpring:	binclude	"artnem/Spring Horizontal.nem"
		even
Nem_VSpring:	binclude	"artnem/Spring Vertical.nem"
		even
Nem_SignPost:	binclude	"artnem/Signpost.nem"	; end of level signpost
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
Nem_GHZ_1st:	binclude	"artnem/8x8 - GHZ1.nem"	; GHZ primary patterns
		even
Nem_GHZ_2nd:	binclude	"artnem/8x8 - GHZ2.nem"	; GHZ secondary patterns
		even
Blk256_GHZ:	binclude	"map256/GHZ.kos"
		even

Blk16_LZ:	binclude	"map16/LZ.eni"
		even
Nem_LZ:		binclude	"artnem/8x8 - LZ.nem"	; LZ primary patterns
		even
Blk256_LZ:	binclude	"map256/LZ.kos"
		even

Blk16_MZ:	binclude	"map16/MZ.eni"
		even
Nem_MZ:		binclude	"artnem/8x8 - MZ.nem"	; MZ primary patterns
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
Nem_SLZ:	binclude	"artnem/8x8 - SLZ.nem"	; SLZ primary patterns
		even
Blk256_SLZ:	binclude	"map256/SLZ.kos"
		even

Blk16_SYZ:	binclude	"map16/SYZ.eni"
		even
Nem_SYZ:	binclude	"artnem/8x8 - SYZ.nem"	; SYZ primary patterns
		even
Blk256_SYZ:	binclude	"map256/SYZ.kos"
		even

Blk16_SBZ:	binclude	"map16/SBZ.eni"
		even
Nem_SBZ:	binclude	"artnem/8x8 - SBZ.nem"	; SBZ primary patterns
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
	if Revision=0
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
			dc.b	[$104]$FF
		else
			dc.b	[$40]$FF
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
Col_GHZ:	binclude	"collide/GHZ.bin"	; GHZ index
		even
Col_LZ:		binclude	"collide/LZ.bin"	; LZ index
		even
Col_MZ:		binclude	"collide/MZ.bin"	; MZ index
		even
Col_SLZ:	binclude	"collide/SLZ.bin"	; SLZ index
		even
Col_SYZ:	binclude	"collide/SYZ.bin"	; SYZ index
		even
Col_SBZ:	binclude	"collide/SBZ.bin"	; SBZ index
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
Art_GhzWater:	binclude	"artunc/GHZ Waterfall.bin"
		even
Art_GhzFlower1:	binclude	"artunc/GHZ Flower Large.bin"
		even
Art_GhzFlower2:	binclude	"artunc/GHZ Flower Small.bin"
		even
Art_MzLava1:	binclude	"artunc/MZ Lava Surface.bin"
		even
Art_MzLava2:	binclude	"artunc/MZ Lava.bin"
		even
Art_MzTorch:	binclude	"artunc/MZ Background Torch.bin"
		even
Art_SbzSmoke:	binclude	"artunc/SBZ Background Smoke.bin"
		even

; ---------------------------------------------------------------------------
; Level layout index
; Format: foreground, background, leftover/unused
; ---------------------------------------------------------------------------
Level_Index:	offsetTable
		ptr	Level_GHZ1,	Level_GHZbg,	Level_GHZ1Unk	; GHZ1
		ptr	Level_GHZ2,	Level_GHZbg,	Level_GHZ2Unk	; GHZ2
		ptr	Level_GHZ3,	Level_GHZbg,	Level_GHZ3Unk	; GHZ3
		ptr	Level_GHZ4Unk,	Level_GHZ4Unk,	Level_GHZ4Unk	; GHZ4 (unused)

		ptr	Level_LZ1,	Level_LZbg,	Level_LZ1Unk	; LZ1
		ptr	Level_LZ2,	Level_LZbg,	Level_LZ2Unk	; LZ2
		ptr	Level_LZ3,	Level_LZbg,	Level_LZ3Unk	; LZ3
		ptr	Level_SBZ3,	Level_LZbg,	Level_SBZ3Unk	; LZ4 (Scrap Brain Zone act 3)

		ptr	Level_MZ1,	Level_MZ1bg,	Level_MZ1	; MZ1
		ptr	Level_MZ2,	Level_MZ2bg,	Level_MZ2Unk	; MZ2
		ptr	Level_MZ3,	Level_MZ3bg,	Level_MZ3Unk	; MZ3
		ptr	Level_MZ4Unk,	Level_MZ4Unk,	Level_MZ4Unk	; MZ4 (unused)

		ptr	Level_SLZ1,	Level_SLZbg,	Level_SLZ1Unk	; SLZ1
		ptr	Level_SLZ2,	Level_SLZbg,	Level_SLZ1Unk	; SLZ2
		ptr	Level_SLZ3,	Level_SLZbg,	Level_SLZ1Unk	; SLZ3
		ptr	Level_SLZ1Unk,	Level_SLZ1Unk,	Level_SLZ1Unk	; SLZ4 (unused)

		ptr	Level_SYZ1,	Level_SYZbg,	Level_SYZ1Unk	; SYZ1
		ptr	Level_SYZ2,	Level_SYZbg,	Level_SYZ2Unk	; SYZ2
		ptr	Level_SYZ3,	Level_SYZbg,	Level_SYZ3Unk	; SYZ3
		ptr	Level_SYZ4Unk,	Level_SYZ4Unk,	Level_SYZ4Unk	; SYZ4 (unused)

		ptr	Level_SBZ1,	Level_SBZ1bg,	Level_SBZ1bg	; SBZ1
		ptr	Level_SBZ2,	Level_SBZ2bg,	Level_SBZ2bg	; SBZ2
		ptr	Level_SBZ2,	Level_SBZ2bg,	Level_SBZ2Unk	; SBZ3 (Final Zone)
		ptr	Level_SBZ4Unk,	Level_SBZ4Unk,	Level_SBZ4Unk	; SBZ4 (unused)

		zonewarning Level_Index,24

		ptr	Level_End,	Level_GHZbg,	Level_EndUnk	; good ending
		ptr	Level_End,	Level_GHZbg,	Level_EndUnk	; bad ending
		ptr	Level_EndUnk,	Level_EndUnk,	Level_EndUnk	; (unused)
		ptr	Level_EndUnk,	Level_EndUnk,	Level_EndUnk	; (unused)


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
Art_BigRing:	binclude	"artunc/Giant Ring.bin"
		even

; ---------------------------------------------------------------------------

	; ObjPos_Index starts at $6B000 in all revisions, which amounts
	; to $9C bytes of padding for rev00 and $DC for rev01/rev02.
	; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$100
	endif
	
; ---------------------------------------------------------------------------
; Level object locations index
; ---------------------------------------------------------------------------
ObjPos_Index:	offsetTable
		ptr	ObjPos_GHZ1,	ObjPos_Null	; GHZ1
		ptr	ObjPos_GHZ2,	ObjPos_Null	; GHZ2
		ptr	ObjPos_GHZ3,	ObjPos_Null	; GHZ3
		ptr	ObjPos_GHZ1,	ObjPos_Null	; GHZ4 (unused)

		ptr	ObjPos_LZ1,	ObjPos_Null	; LZ1
		ptr	ObjPos_LZ2,	ObjPos_Null	; LZ2
		ptr	ObjPos_LZ3,	ObjPos_Null	; LZ3
		ptr	ObjPos_SBZ3,	ObjPos_Null	; LZ4 (Scrap Brain Zone act 3)

		ptr	ObjPos_MZ1,	ObjPos_Null	; MZ1
		ptr	ObjPos_MZ2,	ObjPos_Null	; MZ2
		ptr	ObjPos_MZ3,	ObjPos_Null	; MZ3
		ptr	ObjPos_MZ1,	ObjPos_Null	; MZ4 (unused)

		ptr	ObjPos_SLZ1,	ObjPos_Null	; SLZ1
		ptr	ObjPos_SLZ2,	ObjPos_Null	; SLZ2
		ptr	ObjPos_SLZ3,	ObjPos_Null	; SLZ3
		ptr	ObjPos_SLZ1,	ObjPos_Null	; SLZ4 (unused)

		ptr	ObjPos_SYZ1,	ObjPos_Null	; SYZ1
		ptr	ObjPos_SYZ2,	ObjPos_Null	; SYZ2
		ptr	ObjPos_SYZ3,	ObjPos_Null	; SYZ3
		ptr	ObjPos_SYZ1,	ObjPos_Null	; SYZ4 (unused)

		ptr	ObjPos_SBZ1,	ObjPos_Null	; SBZ1
		ptr	ObjPos_SBZ2,	ObjPos_Null	; SBZ2
		ptr	ObjPos_FZ,	ObjPos_Null	; SBZ3 (Final Zone)
		ptr	ObjPos_SBZ1,	ObjPos_Null	; SBZ4 (unused)

		zonewarning ObjPos_Index,$10

		ptr	ObjPos_End,	ObjPos_Null	; good ending
		ptr	ObjPos_End,	ObjPos_Null	; bad ending
		ptr	ObjPos_End,	ObjPos_Null	; (unused)
		ptr	ObjPos_End,	ObjPos_Null	; (unused)

		; --- Put extra object data here... ---

ObjPosLZPlatform_Index:
		ptr	ObjPos_LZ1pf1,	ObjPos_LZ1pf2
		ptr	ObjPos_LZ2pf1,	ObjPos_LZ2pf2
		ptr	ObjPos_LZ3pf1,	ObjPos_LZ3pf2
		ptr	ObjPos_LZ1pf1,	ObjPos_LZ1pf2

ObjPosSBZPlatform_Index:
		ptr	ObjPos_SBZ1pf1,	ObjPos_SBZ1pf2
		ptr	ObjPos_SBZ1pf3,	ObjPos_SBZ1pf4
		ptr	ObjPos_SBZ1pf5,	ObjPos_SBZ1pf6
		ptr	ObjPos_SBZ1pf1,	ObjPos_SBZ1pf2


ObjPos_PreNull:	dc.b $FF, $FF, 0, 0, 0,	0

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
			dc.b	[$62A]$FF
		else
			dc.b	[$63C]$FF
		endif
	endif
		
; ---------------------------------------------------------------------------

SoundDriver:	include "s1.sounddriver.asm"
		even

; ---------------------------------------------------------------------------

; end of 'ROM'
EndOfRom:

		END
