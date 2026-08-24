;  =========================================================================
; |           Sonic the Hedgehog Disassembly for Sega Mega Drive            |
;  =========================================================================
;
; Disassembly created by Hivebrain
; thanks to drx, Stealth and Esrael L.G. Neto
; Patched to be compiled with WLA-Z80

; ---------------------------------------------------------------------------
; WARNING:
; this disassembly will not generate an accurate result!

; ---------------------------------------------------------------------------
; NOTE:
; Set your editor's tab width to 8 characters wide for viewing this file.

; ===========================================================================
; ASSEMBLY OPTIONS:

.DEFINE Revision 1
; Sets the disassembly to build a specific version of the game
; REVXB has been ommited in favour of readability
;	| 0 -> Original version, REV00
;	| 1 -> Updated release, REV01
; Changes: Major improvements for most of the codebase & some visual touches.

.DEFINE ChecksumSkip 0
; 0 -> Preserves checksum, used in all revisions.
; 1 -> Removes slow checksum at a hard reset.

.DEFINE ZoneCount = 6
; Used for the zonewarning macro. Reflects playable zones
; (GHZ, LZ, MZ, SLZ, SYZ & SBZ)

; ===========================================================================
; Simplifying macros and functions
.INCLUDE "Libraries/Macros.asm"
; ===========================================================================
; Equates section - Names for variables
.INCLUDE "Variables.asm"

; ===========================================================================
; Expressing sprite mappings and DPLCs in a portable and human-readable form
.INCLUDE "Libraries/Map Macros.asm"

; ===========================================================================
; start of ROM



.MDVECTORS
	INITIALSP v_systemstack&$FFFFFF 
	RESET	EntryPoint
	DEFAULT ErrorExcept ; SPURIOUS
	BUSERROR BusError
	ADDRERROR AddressError
	ILLEGAL IllegalInstr
	DIVZERO ZeroDivide
	CHK ChkInstr
	TRAPV TrapvInstr
	PRIVILEGE PrivilegeViol
	TRACE Trace
	LINE1010 Line1010Emu ; aka. Line A
	LINE1111 Line1111Emu ; aka, Line F
	LEVEL1 ErrorTrap
	EXTERNAL ErrorTrap ; Level 2 IRQ
	LEVEL3 ErrorTrap
	HBLANK  HBlank ; Level 4 IRQ
	LEVEL5 ErrorTrap
	VBLANK  VBlank ; Level 6 IRQ
	LEVEL7 ErrorTrap
	TRAP0 ErrorTrap
	TRAP1 ErrorTrap
	TRAP2 ErrorTrap
	TRAP3 ErrorTrap
	TRAP4 ErrorTrap
	TRAP5 ErrorTrap
	TRAP6 ErrorTrap
	TRAP7 ErrorTrap
	TRAP8 ErrorTrap
	TRAP9 ErrorTrap
	TRAP10 ErrorTrap
	TRAP11 ErrorTrap
	TRAP12 ErrorTrap
	TRAP13 ErrorTrap
	TRAP14 ErrorTrap
	TRAP15 ErrorTrap
.ENDMDVECTORS

.DEFINE SerialNumber "GM 00001009-00"   ; Serial/version number (Rev 0)

.IF Revision == 1
	.REDEFINE SerialNumber "GM 00004049-01" ; Serial/version number (Rev non-0)
.ENDIF

.SMDHEADER
	COPYRIGHT	"(C)SEGA 1991.APR" ; Copyright holder and release date (generally year)
	TITLEDOMESTIC	"SONIC THE               HEDGEHOG                " ; Domestic name
	TITLEOVERSEAS	"SONIC THE               HEDGEHOG                " ; International name
	SERIALNUMBER	SerialNumber
	DEVICESUPPORT	"J            "
	RAMADDRESSRANGE $FF0000, $FFFFFF
	EXTRAMEMORY	"RA", $A0, $20, 0, 0
	REGIONSUPPORT	"JUE"
.ENDSMD

.ORGA $200

; Data from here is named AC.SN1 in Sonic Jam (Devon's finding in SSRG)
; (All code is in AC.SN1)
.SECTION "Interrupts"	ALIGN $200 

; ===========================================================================
; Crash/Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too
ErrorTrap:
		nop	
		nop	
		bra.b	ErrorTrap

; ===========================================================================

EntryPoint:
		tst.l	(port_1_control_hi).l	; test port A & B control registers
		bne.b	PortA_Ok
		tst.w	(expansion_control_hi).l ; test port C control register
PortA_Ok:	bne.b	SkipSetup		; skip the VDP and Z80 setup code if this is a soft-reset

		lea	SetupValues(pc),a5	; load setup values array address
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0	; get hardware version (from $A10001)
		andi.b	#$F,d0
		beq.b	SkipSecurity	; If the console has no TMSS, skip the security stuff.
		move.l	#('S'<<24)|('E'<<16)|('G'<<8)|'A',$2F00(a1) ; move "SEGA" to TMSS register ($A14000)

SkipSecurity:
		move.w	(a4),d0	; clear write-pending flag in VDP to prevent issues if the 68k has been reset in the middle of writing a command long word to the VDP.
		moveq	#0,d0	; clear d0
		movea.l	d0,a6	; clear a6
		move.l	a6,usp	; set usp to $0

		moveq	#$17,d1
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
		bne.b	WaitForZ80	; if not, branch

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
		movem.l	(a6),d0-d7/a0-a6	; clear all registers
		disable_ints

SkipSetup:
		bra.b	GameProgram	; begin game

; ===========================================================================
SetupValues:	.DW $8000		; VDP register start number
		.DW $3FFF		; size of RAM/4
		.DW $100		; VDP register diff

		.DD z80_ram		; start of Z80 RAM
		.DD z80_bus_request	; Z80 bus request
		.DD z80_reset		; Z80 reset
		.DD vdp_data_port	; VDP data
		.DD vdp_control_port	; VDP control

		.DB 4			; VDP $80 - 8-colour mode
		.DB $14			; VDP $81 - Megadrive mode, DMA enable
		.DB ($C000>>10)		; VDP $82 - foreground nametable address
		.DB ($F000>>10)		; VDP $83 - window nametable address
		.DB ($E000>>13)		; VDP $84 - background nametable address
		.DB ($D800>>9)		; VDP $85 - sprite table address
		.DB 0			; VDP $86 - unused
		.DB 0			; VDP $87 - background colour
		.DB 0			; VDP $88 - unused
		.DB 0			; VDP $89 - unused
		.DB 255			; VDP $8A - Scanlines until next HBlank
		.DB 0			; VDP $8B - full screen scroll
		.DB $81			; VDP $8C - 40 cell display
		.DB ($DC00>>10)		; VDP $8D - hscroll table address
		.DB 0			; VDP $8E - unused
		.DB 1			; VDP $8F - VDP increment
		.DB 1			; VDP $90 - 64 cell hscroll size
		.DB 0			; VDP $91 - window h position
		.DB 0			; VDP $92 - window v position
		.DW $FFFF		; VDP $93/94 - DMA length
		.DW 0			; VDP $95/96 - DMA source
		.DB $80		; VDP $97 - DMA fill VRAM
		.DD $40000080		; VRAM address 0

		.INCBIN "Build/z80_boot.z80" FSIZE z80_Boot_Routine_Size

		.DW $8104		; VDP display mode
		.DW $8F02		; VDP increment
		.DD $C0000000		; CRAM write mode
		.DD $40000010		; VSRAM address 0

		.DB $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================
.ENDS  ; End of section 'Interrupt'

GameProgram: ; (TODO)
BusError:
AddressError:
IllegalInstr:
ZeroDivide:
ChkInstr:
TrapvInstr:
PrivilegeViol:
Trace:
Line1010Emu:
Line1111Emu:
ErrorExcept:
HBlank:
VBlank:
