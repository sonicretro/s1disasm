;  DZ80 V3.4.1 Z80 Disassembly of z80nodata.bin
;  2007/09/18 15:48
;  Sonic 1 Z80 Driver disassembly by Puto.
;  Disassembly fixed, improved and integrated into SVN by Flamewing.
;  Should be assembled with AS (though it should be easily portable to other assemblers if necessary).
;

	save
	!org	0							; z80 Align, handled by the build process
	CPU Z80
	listing purecode

zSEGA_Pitch:	equ	0Bh					; The pitch of the SEGA sound


z80_stack:		equ 1FFCh
zDAC_Status:	equ 1FFDh				; Bit 7 set if the driver is not accepting new samples, it is clear otherwise
zDAC_Sample:	equ 1FFFh				; Sample to play, the 68k will move into this locatiton whatever sample that's supposed to be played.

zYM2612_A0:		equ 4000h
zBankRegister:	equ 6000h
zROMWindow:		equ 8000h

zmake68kPtr  function addr,zROMWindow+(addr&7FFFh)
zmake68kBank function addr,(((addr&0FF8000h)/zROMWindow))

; function to decide whether an offset's full range won't fit in one byte
offsetover1byte function from,maxsize, ((from&0FFh)>(100h-maxsize))

; macro to make sure that ($ & 0FF00h) == (($+maxsize) & 0FF00h)
ensure1byteoffset macro maxsize
	if offsetover1byte($,maxsize)
startpad := $
		align 100h
	    if MOMPASS=1
endpad := $
		if endpad-startpad>=1h
			; warn because otherwise you'd have no clue why you're running out of space so fast
			message "had to insert \{endpad-startpad}h   bytes of padding before improperly located data at 0\{startpad}h in Z80 code"
		endif
	    endif
	endif
    endm

;Z80Driver_Start:
	di									; Disable interrupts. Interrupts will never be reenabled
	di									; for the z80, so that no code will be executed on V-Int.
	di									; This means that the sample loop is all the z80 does.
	ld	sp,z80_stack					; Initialize the stack pointer (unused throughout the driver)
	ld	ix,zYM2612_A0					; ix = Pointer to memory-mapped communication register with YM2612
	xor	a								; a=0
	ld	(zDAC_Status),a					; Disable DAC
	ld	(zDAC_Sample),a					; Clear sample
	ld	a,zmake68kBank(SegaPCM)&1		; least significant bit from ROM bank ID
	ld	(zBankRegister),a				; Latch it to bank register, initializing bank switch

	ld	b,8								; Number of bits to latch to ROM bank
	ld	a,zmake68kBank(SegaPCM)>>1		; Bank ID without the least significant bit
	
zBankSwitchLoop:	
	ld	(zBankRegister),a				; Latch another bit to bank register.
	rrca								; Move next bit into position
	djnz	zBankSwitchLoop				; decrement and loop if not zero

	jr	zCheckForSamples

; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================
	ensure1byteoffset 10h
zDACDecodeTbl:
	db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h

zCheckForSamples:
	ld	hl,zDAC_Sample					; Load the address of next sample.

zWaitDACLoop:	
	ld	a,(hl)							; a = next sample to play.
	or	a								; Do we have a valid sample?
	jp	p,zWaitDACLoop					; Loop until we do

	sub	81h								; Make 0-based index
	ld	(hl),a							; Store it back into sample index (i.e., mark it as being played)
	cp	6								; Is the sample 87h or higher?
	jr	nc,zPlay_SegaPCM				; If yes, branch

	ld	de,0							; de = 0
	ld	iy,zPCM_Table					; iy = pointer to PCM Table

	; Each entry on PCM table has 8 bytes in size, so multiply a by 8
	; Warning: do NOT play samples 84h-86h!
	sla	a
	sla	a
	sla	a
	ld	b,0								; b = 0
	ld	c,a								; c = a
	add	iy,bc							; iy = pointer to DAC sample entry
	ld	e,(iy+0)						; e = low byte of sample location
	ld	d,(iy+1)						; de = pointer location of DAC sample
	ld	c,(iy+2)						; c = low byte of sample size
	ld	b,(iy+3)						; bc = size of the DAC sample
	exx									; bc' = size of sample, de' = location of sample, hl' = pointer to zDAC_Sample
	ld	d,80h							; d = is an accumulator; this initializes it to 80h
	ld	hl,zDAC_Status					; hl = pointer to zDAC_Status
	ld	(hl),d							; Set flag to not accept driver input
	ld	(ix+0),2Bh						; Select enable/disable DAC register
	ld	e,2Ah							; Command to select DAC output register
	ld	c,(iy+4)						; c = pitch of the DAC sample
	ld	(ix+1),d						; Enable DAC
	ld	(hl),0							; Set flag to accept driver input
	; After the following exx, we have:
	; bc = size of sample, de = location of sample, hl = pointer to zDAC_Sample,
	; c' = pitch of sample, d' = PCM accumulator,
	; e' = command to select DAC output register, hl' = pointer to DAC status
	exx
	ld	h,(zDACDecodeTbl&0FF00h)>>8		; We set low byte of pointer below

zPlayPCMLoop:	
	ld	a,(de)							; a = byte from DAC sample
	and	0F0h							; Get upper nibble
	; Shift-right 4 times to rotate the nibble into place
	rrca
	rrca
	rrca
	rrca
	add	a,zDACDecodeTbl&0FFh			; Add in low byte of offset into decode table
	ld	l,a								; hl = pointer to nibble entry in JMan2050 table
	ld	a,(hl)							; a = JMan2050 entry for current nibble
	; After the following exx, we have:
	; bc' = size of sample, de' = location of sample, hl' = pointer to nibble entry in JMan2050 table,
	; c = pitch of sample, d = PCM accumulator,
	; e = command to select DAC output register, hl = pointer to DAC status
	exx
	add	a,d								; Add accumulator value...
	ld	d,a								; ... then store value back into accumulator
	ld	(hl),l							; Set flag to not accept driver input (l = FFh)
	ld	(ix+0),e						; Select DAC output register
	ld	(ix+1),d						; Send current data
	ld	(hl),h							; Set flag to accept driver input (h = 1Fh)

	ld	b,c								; b = sample pitch
	djnz	$							; Pitch loop

	; After the following exx, we have:
	; bc = size of sample, de = location of sample, hl = pointer to nibble entry in JMan2050 table,
	; c' = pitch of sample, d' = PCM accumulator,
	; e' = command to select DAC output register, hl' = pointer to DAC status
	exx
	ld	a,(de)							; a = byte from DAC sample
	and	0Fh								; Want only lower nibble now
	add	a,zDACDecodeTbl&0FFh			; Add in low byte of offset into decode table
	ld	l,a								; hl = pointer to nibble entry in JMan2050 table
	ld	a,(hl)							; a = JMan2050 entry for current nibble
	; After the following exx, we have:
	; bc' = size of sample, de' = location of sample, hl' = pointer to nibble entry in JMan2050 table,
	; c = pitch of sample, d = PCM accumulator,
	; e = command to select DAC output register, hl = pointer to DAC status
	exx
	add	a,d								; Add accumulator value...
	ld	d,a								; ... then store value back into accumulator
	ld	(hl),l							; Set flag to not accept driver input (l = FFh)
	ld	(ix+0),e						; Select DAC output register
	ld	(ix+1),d						; Send current data
	ld	(hl),h							; Set flag to accept driver input (h = 1Fh)

	ld	b,c								; b = sample pitch
	djnz	$							; Pitch loop

	; After the following exx, we have:
	; bc = size of sample, de = location of sample, hl = pointer to nibble entry in JMan2050 table,
	; c' = pitch of sample, d' = PCM accumulator,
	; e' = command to select DAC output register, hl' = pointer to DAC status
	exx
	ld	a,(zDAC_Sample)					; a = sample we're playing (minus 81h)
	bit	7,a								; Test bit 7 of register a
	jp	nz,zCheckForSamples				; If it is set, we need to get a new sample

	inc	de								; Point to next byte of DAC sample
	dec	bc								; Decrement remaining bytes on DAC sample
	ld	a,c								; a = low byte of remainig bytes
	or	b								; Are there any bytes left?
	jp	nz,zPlayPCMLoop					; If yes, keep playing sample

	jp	zCheckForSamples				; Sample is done; wait for new samples
; 
; Subroutine - Play_SegaPCM
;
; This subroutine plays the "SEGA" sound.
; 
zPlay_SegaPCM:	
	ld	de,zmake68kPtr(SegaPCM)			; de = bank-relative location of the SEGA sound
	ld	hl,SegaPCM_End-SegaPCM			; hl = size of the SEGA sound
	ld	c,2Ah							; c = Command to select DAC output register

zPlaySEGAPCMLoop:
	ld	a,(de)							; a = next byte from SEGA PCM
	ld	(ix+0),c						; Select DAC output register
	ld	(ix+1),a						; Send current data

	ld	b,zSEGA_Pitch					; b = pitch of the SEGA sample
	djnz	$							; Pitch loop

	inc	de								; Point to next byte of DAC sample
	dec	hl								; Decrement remaining bytes on DAC sample
	ld	a,l								; a = low byte of remainig bytes
	or	h								; Are there any bytes left?
	jp	nz,zPlaySEGAPCMLoop				; If yes, keep playing sample

	jp	zCheckForSamples				; SEGA sound is done; wait for new samples

;
; Table referencing the three PCM samples
;	
; As documented by jman2050, first two bytes are a pointer to the sample, third and fourth are the sample size, fifth is the pitch, 6-8 are unused.
;


zPCM_Table:
	dw	zDAC_Sample1	; Kick sample
	dw	(zDAC_Sample1_End-zDAC_Sample1)
	dw	0017h			; Pitch = 17h
	dw	0000h
	
	dw	zDAC_Sample2	; Snare sample
	dw	(zDAC_Sample2_End-zDAC_Sample2)
	dw	0001h			; Pitch = 1h
	dw	0000h
	
	dw	zDAC_Sample3	; Timpani sample
	dw	(zDAC_Sample3_End-zDAC_Sample3)
zSample3_Pitch:
	dw	001Bh			; Pitch = 1Bh
	dw	0000h
	


zDAC_Sample1:
	db	 90h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 91h, 3Bh,0C7h,0FDh, 52h,0DDh, 53h
	db	0BFh, 7Dh, 0Fh, 76h,0EDh, 7Eh,0FEh, 8Dh, 64h,0EEh, 77h,0E9h, 6Eh, 65h, 3Dh, 54h, 2Dh, 50h, 00h, 00h
	db	 00h, 0Dh, 4Bh, 2Eh,0EDh,0C4h,0FDh, 5Dh,0DDh,0ECh,0CBh, 90h, 00h, 00h, 4Ah,0B2h, 59h,0B3h, 4Ch, 32h
	db	 44h,0BAh, 43h, 44h, 49h, 51h, 44h, 34h, 53h, 42h, 44h, 43h, 44h, 42h, 43h, 24h, 34h, 2Bh, 43h, 19h
	db	 3Bh, 3Ah, 4Ch, 03h,0BBh, 2Ch, 1Bh,0BBh,0ABh,0BBh,0CBh,0ABh,0CBh,0BCh,0CBh,0BCh,0BCh,0BCh,0BBh,0BCh
	db	0CAh,0CAh,0BBh,0BCh,0B9h,0ABh,0BBh, 0Ah,0B9h, 0Ah, 19h, 0Ah, 32h, 00h, 33h, 02h, 32h, 23h, 33h, 33h
	db	 13h, 33h, 33h, 33h, 33h, 33h, 23h, 32h, 34h, 3Bh, 24h, 23h, 22h, 21h, 32h, 11h, 12h, 21h, 11h, 09h
	db	 03h, 9Ah,0A2h, 2Ah, 9Ah, 10h, 0Ah,0A0h, 09h,0A9h,0ABh, 09h, 0Bh,0AAh, 9Bh, 2Ah,0BAh, 10h,0BAh, 01h
	db	0CAh, 3Ah, 09h,0AAh, 02h,0A9h, 90h, 92h,0A0h, 20h,0A0h, 1Ah, 21h,0A2h,0B2h, 13h,0BAh, 3Ah, 12h,0B9h
	db	 93h,0AAh, 00h, 9Ah, 00h,0B2h,0AAh, 29h,0B1h,0ABh, 01h,0A9h,0ABh, 31h,0BCh, 22h, 09h, 20h,0BAh, 42h
	db	0B1h, 21h, 10h, 23h,0B0h, 43h,0ABh, 32h, 4Ah, 2Bh, 43h, 3Ch, 34h, 2Ah, 40h, 90h, 4Ah, 22h, 03h,0A2h
	db	 11h,0A3h,0A0h,0A3h, 2Bh,0C3h, 10h, 00h,0ABh, 21h,0B9h, 20h,0AAh, 2Ah,0B3h, 9Bh,0B2h, 3Bh,0B0h, 9Bh
	db	 90h, 2Bh,0C9h, 4Bh,0B9h, 1Ah, 90h, 1Ah,0A0h, 39h,0B2h, 00h,0B2h, 22h,0CAh, 49h,0B9h,0B0h, 29h,0AAh
	db	 22h,0A9h, 12h, 12h, 21h, 0Bh, 4Ah, 22h,0A0h, 31h, 01h, 09h, 22h, 13h, 9Ah, 03h, 29h, 92h, 3Bh,0A2h
	db	 3Ah,0A2h,0A9h, 10h, 91h, 9Ah, 30h,0A9h, 21h,0B1h, 3Ah,0AAh, 30h, 1Ah, 90h, 39h, 19h, 3Ah, 92h, 20h
	db	 21h, 00h, 01h,0A2h, 3Bh, 0Ah, 20h, 91h, 9Ah, 99h, 1Bh, 02h,0A9h, 90h, 01h,0AAh, 12h,0A9h, 99h, 2Bh
	db	 21h,0BAh, 11h, 9Bh,0A2h, 0Bh, 12h,0AAh,0A3h, 0Ah, 2Ah, 02h, 91h,0A1h, 2Ah,0A2h, 0Ah, 22h,0A9h, 22h
	db	0A3h, 00h, 00h, 22h, 99h, 00h, 29h, 1Bh, 23h,0B1h,0A3h,0B2h, 2Ah, 22h, 1Ah, 13h,0A1h, 20h, 11h,0A1h
	db	 92h, 90h, 93h,0ABh, 24h,0BAh,0A3h, 0Ah, 31h,0A1h, 1Ah, 2Ah, 92h,0A0h, 09h, 9Ah,0A4h,0BBh,0B3h, 23h
	db	0B2h,0A2h, 19h,0B2h, 3Ah,0A1h, 0Ah,0A0h, 3Bh,0AAh, 19h, 0Ah,0B2h, 0Ah,0A9h, 04h,0CBh, 33h,0BAh, 00h
	db	 93h, 9Ah,0A2h, 29h, 92h, 0Ah, 30h,0A9h, 33h,0C3h, 39h,0A3h, 2Bh, 02h, 11h, 00h, 92h, 0Ah, 21h,0AAh
	db	 32h,0B9h, 3Bh, 20h,0A1h,0A2h, 3Ah,0C2h, 4Ch,0A3h, 1Ah,0A3h, 10h,0B2h, 29h, 22h, 9Bh, 12h, 4Bh,0B0h
	db	 32h, 02h, 0Ah, 33h, 99h, 93h, 31h,0B0h, 02h, 13h,0B0h, 00h,0A9h, 90h, 0Bh, 09h, 09h, 1Ch,0A3h, 2Ah
	db	0AAh, 92h,0A0h, 2Ah,0A0h, 22h,0ABh, 12h,0ABh, 21h,0AAh, 2Bh, 10h, 1Ah, 99h, 19h, 0Ah, 19h, 91h,0A2h
	db	 1Ah, 9Ah, 20h, 11h,0A0h,0A2h, 3Bh, 12h, 0Ah, 22h,0A1h, 11h,0A2h, 29h, 10h, 22h,0A1h, 39h, 01h, 11h
	db	0A1h, 39h, 2Ah, 33h, 1Bh, 33h, 0Ah, 32h, 92h,0A1h, 09h,0A2h, 99h, 90h,0BAh, 03h, 9Bh,0A2h,0A2h, 3Bh
	db	 92h, 3Bh,0A3h, 3Bh,0A2h, 9Bh, 02h,0ABh, 10h,0B0h, 09h, 92h, 90h,0A2h, 20h,0C3h, 30h, 00h,0B9h, 91h
	db	 2Ah,0B1h, 1Ah,0B2h, 29h,0A3h,0AAh, 31h,0A0h, 00h, 01h, 92h,0A9h, 13h,0AAh, 02h, 09h, 11h,0AAh, 22h
	db	 99h, 19h, 01h, 20h,0A1h, 12h,0A0h, 99h, 12h,0AAh, 12h, 1Ah,0A3h, 00h, 20h, 02h, 12h, 29h, 93h, 12h
	db	 01h, 01h, 02h, 2Ah, 01h, 11h, 9Ah, 1Ah, 20h, 2Ah, 90h, 09h, 00h, 90h,0A1h, 9Ah, 91h,0A2h,0A9h,0A0h
	db	 19h,0A1h, 0Ah, 91h, 9Ah, 00h, 2Ah,0AAh, 2Ah, 99h, 0Ah, 02h,0A0h, 91h, 09h, 01h, 90h, 92h, 09h, 19h
	db	 00h, 19h, 01h, 10h,0A1h, 00h, 02h, 0Ah, 10h, 00h, 19h, 01h, 09h, 10h, 21h,0A1h, 21h, 11h, 00h, 11h
	db	 20h, 01h, 02h, 00h, 11h, 91h, 19h, 11h, 00h, 10h, 01h, 00h, 00h, 10h, 90h, 00h, 91h, 91h, 90h, 00h
	db	 00h, 99h, 10h, 09h, 99h, 00h, 99h, 1Ah, 90h, 09h, 90h, 09h, 00h, 91h, 09h, 00h, 00h, 90h, 00h, 00h
	db	 09h, 19h, 01h, 09h, 91h, 01h,0A0h, 00h, 00h, 90h, 90h, 09h, 00h, 91h, 90h, 10h, 91h, 09h, 10h, 00h
	db	 00h, 00h, 01h, 90h, 00h, 00h, 10h, 00h, 29h, 10h, 10h, 01h, 00h, 10h, 01h, 00h, 10h, 01h, 00h, 10h
	db	 10h, 01h, 00h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 01h, 09h, 00h, 00h, 00h, 09h, 00h
	db	 19h, 00h, 00h, 09h, 19h, 00h, 00h, 91h, 90h, 00h, 90h, 00h, 09h, 19h, 00h, 00h, 00h, 90h, 00h, 00h
	db	 00h, 90h, 00h, 00h, 09h, 00h, 09h, 19h, 00h, 00h, 00h, 00h, 00h, 09h, 10h, 91h, 00h, 00h, 00h, 01h
	db	 00h, 00h, 01h, 00h, 00h, 01h, 00h, 00h, 00h, 10h, 00h, 00h, 00h, 10h, 00h, 01h, 91h, 00h, 00h, 00h
	db	 10h, 91h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h
	db	 00h, 09h, 00h, 00h, 09h, 00h, 00h, 90h, 00h, 00h, 00h, 90h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 01h, 91h, 00h, 00h
zDAC_Sample1_End:

zDAC_Sample2:
	db	 9Ah, 19h,0A9h,0BDh,0EEh,0D6h, 56h, 55h, 56h, 7Fh, 47h, 1Fh, 2Eh, 7Dh, 2Dh,0DDh,0EDh,0CDh,0DAh,0D5h
	db	 5Fh,0D7h,0F2h, 77h,0FDh, 84h,0FFh, 66h, 6Eh,0D7h,0FFh, 56h, 6Dh,0D6h,0F5h, 66h,0E5h, 46h,0AEh, 6Ch
	db	0D6h,0F6h, 5Eh, 64h,0E3h, 47h, 58h, 25h, 7Dh,0C6h, 34h, 3Dh,0EFh, 71h, 0Ch,0DCh, 0Dh, 4Dh,0BCh,0B1h
	db	0AAh, 02h, 90h, 10h,0ACh,0EEh,0C3h, 55h, 54h, 55h, 55h, 51h, 43h, 34h, 04h, 56h, 54h,0EDh,0DEh,0DDh
	db	0EEh, 47h,0EDh, 72h,0E5h, 6Ch,0E6h, 6Eh, 49h, 2Eh, 75h,0ADh,0DEh, 1Dh,0CCh,0BCh,0CCh,0E4h, 5Dh,0DEh
	db	 67h, 5Eh,0CBh,0E5h, 64h,0C4h, 53h,0EBh, 66h,0EAh, 47h,0DFh, 56h,0DEh, 42h, 53h, 45h, 65h,0E3h, 66h
	db	0CDh,0E4h,0DDh,0DDh,0DEh, 4Ch,0D5h, 4Dh,0E5h,0DEh,0D4h, 67h, 53h, 6Ch, 6Ch, 6Ah,0FCh, 4Eh,0D4h, 4Eh
	db	0DBh, 73h,0E4h, 6Dh, 46h, 45h,0A3h, 4Eh, 3Dh, 49h, 14h,0B5h,0E5h,0BDh,0DEh,0BEh, 46h, 53h, 65h, 5Ch
	db	0ECh, 6Ch,0DDh, 5Ch,0EDh, 6Ch,0DEh, 66h, 4Dh,0EDh, 4Dh,0C5h, 55h, 43h,0EDh, 5Dh, 66h,0CDh, 30h, 54h
	db	 44h, 45h,0C5h, 54h, 4Eh, 06h,0EDh,0D5h, 5Eh,0EDh, 6Dh,0ECh, 61h, 55h, 6Bh, 4Ah,0AEh,0D4h, 54h,0ECh
	db	 3Bh,0BDh,0C6h,0DDh,0DBh,0E3h, 4Ch, 52h, 56h, 5Dh, 55h, 57h, 3Eh,0D4h, 0Ch,0CEh,0CDh,0DBh, 52h,0DDh
	db	0BBh, 25h, 7Dh,0DCh, 5Ch, 55h,0D6h, 6Eh,0C5h, 16h,0DEh,0D5h,0D1h,0E5h, 5Eh,0C4h,0E4h,0BCh, 75h, 6Dh
	db	0E2h, 6Eh,0BAh,0E4h, 14h,0B4h,0DCh,0E4h, 5Dh,0C6h, 3Dh, 56h, 69h, 14h, 6Bh,0DEh, 64h,0ECh,0CEh,0DDh
	db	0F7h, 54h,0CEh, 7Ch,0E7h,0CBh,0CEh,0B5h,0A7h,0DDh, 66h,0EDh,0C6h,0EEh,0DDh, 34h,0BCh,0DDh, 56h,0EAh
	db	 6Ch, 55h,0C5h, 5Eh, 64h,0DDh,0CDh, 46h, 5Dh, 55h, 5Ch,0EDh, 36h,0E4h, 4Eh,0BDh, 52h,0BDh, 4Ch,0C3h
	db	 7Eh,0EAh, 43h, 6Dh, 2Dh, 46h,0DDh, 65h,0BBh, 4Ah,0D4h,0AEh,0BDh, 4Bh,0EDh, 4Ch, 35h, 6Bh,0C6h, 6Eh
	db	 5Ch,0CEh, 53h,0BDh, 46h, 24h,0C9h, 4Dh,0D5h,0C5h, 4Eh, 44h, 13h,0E5h, 6Ah,0DEh, 4Dh, 46h,0CCh, 4Eh
	db	0C4h, 35h, 35h, 5Ch, 53h,0A4h, 0Eh, 3Bh,0E1h, 55h, 5Ch,0DBh,0D5h,0DDh,0B5h,0C5h,0EAh, 5Dh, 6Dh, 62h
	db	0DCh, 56h, 5Eh,0D4h, 44h,0CCh,0CAh, 6Bh, 1Dh,0D6h, 4Eh, 4Dh, 5Ch, 4Dh, 25h, 6Bh,0DCh, 3Eh, 3Ch,0CAh
	db	 4Ch,0EEh,0A5h, 66h, 5Bh,0C2h, 63h, 6Ch, 5Eh,0D6h, 6Eh,0DCh, 5Eh,0E6h, 4Bh,0DDh,0C0h,0F6h, 66h,0EEh
	db	 55h,0D5h, 65h,0C3h, 64h, 6Eh,0DCh,0CDh, 53h,0BDh, 4Dh,0D5h, 5Dh, 4Ch,0ECh, 5Dh,0E6h,0C5h, 4Bh, 4Ch
	db	 36h,0C5h,0D3h,0BCh, 64h, 44h,0AEh, 5Ch,0D3h, 0Bh,0B4h,0E5h,0BDh, 51h,0DCh, 36h,0CDh, 55h, 5Dh,0DCh
	db	 4Dh,0E3h, 5Ch, 45h, 00h, 16h, 65h,0CEh,0C5h, 43h,0D4h,0D3h, 4Ch,0EBh, 2Ah, 4Dh, 3Dh,0CCh,0EAh, 56h
	db	 5Ch, 44h, 4Bh, 66h, 23h,0CDh,0E2h, 55h,0EEh,0D9h, 4Ah, 2Eh,0B4h,0C4h, 1Dh, 61h, 30h, 56h, 53h,0D5h
	db	 34h, 55h,0DCh,0C1h, 4Dh, 4Dh,0ECh,0DDh,0CCh,0CEh, 56h, 91h, 35h, 6Dh, 95h, 6Ch,0C6h,0D4h, 42h,0ACh
	db	0BCh,0CDh,0CDh,0A4h,0DDh, 24h, 56h,0E9h, 51h, 54h,0BDh, 44h,0ACh, 34h,0CDh,0ADh, 4Ah,0D4h,0A6h, 5Dh
	db	0C5h,0D3h,0D4h, 44h, 44h, 4Bh,0BDh, 35h,0E4h,0E6h,0DBh,0DDh, 55h,0DDh,0ADh, 66h,0CCh, 56h,0E2h, 42h
	db	 45h, 4Bh, 24h,0D0h,0C2h, 5Bh, 3Dh,0CDh, 4Eh,0CCh, 2Bh, 90h,0DBh, 56h, 44h,0D3h, 55h, 33h, 15h,0BCh
	db	0C3h, 4Dh,0DEh, 65h,0DDh,0C0h,0CBh, 24h, 6Ch,0DEh,0B7h,0B3h, 1Ch, 4Dh,0C5h, 5Ch,0EDh, 2Ch, 29h,0D4h
	db	 5Ch, 35h, 35h,0C5h,0A6h, 54h,0CDh,0C9h,0E6h,0BDh,0CDh,0E5h, 4Dh, 33h, 32h,0CAh, 45h,0D4h, 45h, 49h
	db	 4Bh, 34h, 25h,0DDh,0CCh,0CCh, 5Dh,0EBh, 64h,0ADh, 4Ch,0B4h, 54h,0BBh,0CCh, 45h,0CDh, 36h, 4Ch, 4Dh
	db	0DAh, 4Ch, 35h, 4Eh, 90h, 4Bh,0DEh, 26h, 64h, 4Dh, 3Ah, 3Bh, 53h,0AAh, 42h,0CDh,0BDh, 3Ch, 4Ah,0CDh
	db	 5Ch, 40h, 4Bh, 94h, 45h, 4Dh,0CCh,0DDh, 5Dh,0D4h, 55h, 6Dh,0CBh, 52h,0B5h, 1Bh, 3Ch, 53h,0CBh,0CCh
	db	 04h, 4Dh,0DEh, 56h,0BEh,0BAh,0CDh, 53h,0B4h, 55h,0D0h, 46h, 0Dh,0A3h, 55h, 45h,0BDh,0CAh, 32h, 5Ch
	db	0DEh,0C1h,0D4h,0B1h,0CCh, 51h,0C3h, 43h, 42h, 55h,0CDh,0CDh, 5Bh, 04h,0CDh,0C4h, 43h,0B4h, 6Dh,0A5h
	db	0DBh, 59h,0CCh,0B0h,0BCh,0C5h,0A3h, 4Bh,0B1h,0B6h, 54h,0ECh, 4Dh,0CCh, 56h,0DCh, 44h, 9Bh,0DDh, 50h
	db	0DCh,0A4h,0BBh, 34h, 4Ch,0C4h,0CDh, 6Ah,0CDh, 24h,0CCh, 46h,0A4h,0C3h,0A5h,0B1h,0D4h,0C3h, 34h,0BBh
	db	0CAh,0C4h, 4Dh,0ACh,0B4h, 3Bh, 3Bh, 4Bh,0D5h, 59h,0C5h,0A2h,0C4h, 55h,0DDh, 4Dh, 3Ch,0CCh, 54h,0DDh
	db	 5Ah,0C3h,0B2h, 34h,0CDh, 49h,0CAh,0D5h, 3Bh, 63h,0C4h,0CBh, 41h,0ABh,0A4h,0CDh,0CDh,0A6h, 4Bh, 1Bh
	db	 03h, 45h, 23h,0CBh, 63h,0DDh,0C3h, 3Dh,0C4h,0DCh, 53h,0DCh, 45h, 40h, 0Ah, 5Bh,0CCh, 55h, 94h,0CDh
	db	0C4h,0CDh,0DAh, 34h,0AAh, 3Bh, 50h,0B2h, 44h,0CEh, 95h, 5Dh,0C4h, 45h, 13h, 4Dh,0B5h,0ADh, 1Ch, 59h
	db	0D4h, 03h, 54h,0C3h, 0Ch, 42h,0D4h, 5Dh,0C9h,0DCh, 02h,0CBh,0CAh, 45h,0B1h, 04h, 13h,0C0h, 5Ch, 45h
	db	 5Dh,0E4h, 53h,0ABh,0A4h,0ACh, 0Ch,0B4h, 2Ch,0AAh, 3Bh, 43h, 9Bh,0B3h, 54h, 4Bh,0BEh, 3Ch, 15h, 4Ah
	db	0BCh, 41h,0D4h, 4Ch,0B0h, 2Dh, 43h, 12h,0ACh, 10h, 34h, 54h,0DDh, 44h,0BCh,0BDh, 9Bh, 23h,0C4h, 54h
	db	 3Ch, 23h, 5Ch,0D5h, 5Dh,0D4h, 93h, 59h,0C4h,0C4h, 32h,0DDh, 4Dh, 54h, 30h,0ADh,0B2h, 2Dh, 04h, 33h
	db	0AAh,0CDh,0B4h, 03h, 12h, 3Ch, 45h,0AAh, 42h, 32h, 35h,0CBh,0B4h,0DBh,0BBh,0B4h, 4Bh,0D4h,0D2h, 40h
	db	0D3h, 44h, 4Ch, 52h, 12h,0CBh, 04h,0CCh, 49h,0BCh, 14h,0A2h, 33h, 3Ch,0B3h, 4Bh,0CBh, 34h, 9Bh,0DCh
	db	0C2h,0CAh,0CCh, 44h,0C5h, 64h, 2Ch, 34h,0CBh,0C5h, 5Bh,0D4h,0CCh, 43h,0A2h, 2Ah, 2Dh,0D2h, 53h, 04h
	db	 3Ah,0C2h,0C3h, 45h, 2Ch,0CCh, 09h,0ADh,0C5h,0CBh,0BDh, 15h, 25h, 44h,0DAh, 5Ch,0DCh, 14h,0C0h,0CBh
	db	 45h, 54h, 3Bh,0DBh, 5Bh,0C3h,0BCh,0A4h,0A1h, 54h,0CCh, 94h, 0Ch, 22h, 24h, 9Ch,0BAh, 25h, 5Ch,0C4h
	db	0BCh, 9Ch,0CBh, 2Bh,0DDh, 32h,0C4h, 34h,0BCh, 45h, 53h, 41h,0CDh, 34h,0C4h,0BCh, 14h,0CBh,0CBh,0A4h
	db	0A4h, 3Ch, 33h, 23h, 44h, 2Bh,0A3h, 4Bh,0DBh,0BCh,0DCh, 34h, 45h, 3Bh, 4Ch, 33h, 1Bh, 2Bh,0BBh, 33h
	db	 5Ch,0C9h, 14h,0CCh, 3Ch,0B5h, 3Ch,0CCh,0A3h,0BCh,0B3h,0BCh, 53h,0C2h, 43h,0CCh,0B5h, 53h,0DDh, 25h
	db	 54h,0C9h, 43h,0B2h, 0Ch,0BDh, 34h, 41h, 3Ah, 49h,0DDh, 40h,0CCh,0CBh,0B4h, 53h, 54h,0BBh,0AAh, 2Bh
	db	 1Bh,0C2h, 3Ch, 1Ch,0C5h, 04h, 3Ch, 44h,0CBh, 39h,0CDh, 4Bh, 45h,0BCh,0DBh, 45h,0CBh, 44h, 10h, 23h
	db	 3Ch, 0Bh, 34h, 4Bh, 29h, 2Bh,0CCh,0D2h, 92h,0CAh, 34h, 1Bh, 33h, 25h, 2Bh,0BCh,0B1h, 0Ch, 45h,0BBh
	db	0CCh, 53h,0ABh,0CCh, 9Bh,0C4h, 34h, 5Ch, 44h,0CBh, 45h,0C4h,0B4h, 2Ah,0CCh,0BBh,0DCh,0CBh, 3Bh, 24h
	db	 44h, 2Ch, 34h, 2Bh,0C5h, 5Ah,0DCh, 44h, 33h,0ACh,0CCh,0ACh, 34h,0CBh,0B2h,0B5h, 3Ah,0B0h, 4Ch,0BBh
	db	0A2h, 44h, 05h,0CDh, 0Bh, 25h, 4Bh,0BDh, 30h, 3Bh,0D4h, 5Bh,0A4h,0B4h, 3Ah,0C3h, 94h, 4Ch,0CAh, 2Bh
	db	0BCh,0ACh, 33h, 94h,0A3h, 4Ah, 3Ch,0BBh, 4Bh,0CAh,0B4h, 34h, 2Ch, 30h,0BDh, 34h, 43h,0ABh,0C1h, 44h
	db	 39h, 9Ch,0D9h, 44h, 9Ah, 0Bh, 30h, 03h, 2Bh, 10h,0CBh, 12h,0BCh, 45h, 43h,0CCh, 0Ch, 53h,0CCh, 02h
	db	0BCh, 02h, 43h,0CBh,0AAh, 49h,0B4h, 2Ah,0ACh, 42h,0B1h, 43h, 1Ah, 3Bh,0CBh, 4Ah, 1Bh, 92h, 0Bh, 0Ch
	db	 93h,0A2h, 23h, 33h, 50h, 3Ch, 2Ah,0A4h, 1Bh,0BBh,0CCh,0D5h, 4Ah,0C3h, 45h,0B3h, 2Dh,0CAh,0B2h, 30h
	db	 02h, 22h,0A9h,0A9h, 9Bh,0B4h,0BBh,0BBh, 43h, 23h,0CCh, 3Ah, 34h,0A4h, 0Ch, 1Ch, 15h, 39h,0B3h,0B3h
	db	 3Ah, 31h, 9Bh, 44h, 3Bh,0CBh,0BBh, 32h,0BBh, 33h, 4Bh,0CAh, 20h,0CCh, 04h, 1Bh, 23h, 3Bh,0CCh, 44h
	db	 4Bh,0BCh,0B4h, 22h, 33h,0BCh, 32h, 3Bh,0CBh,0BAh, 32h, 3Bh,0B4h,0B4h, 43h,0B2h,0AAh,0C2h, 4Ch, 0Bh
	db	 30h, 93h,0B9h,0B0h, 53h,0BBh, 33h,0BBh,0C4h, 2Ch, 29h, 34h,0BBh, 99h, 2Ah, 1Bh, 24h,0B1h, 2Bh,0B4h
	db	 9Bh,0ABh, 3Ch, 3Bh,0B3h,0B0h, 0Ch, 14h, 34h, 3Bh,0BAh, 03h, 2Bh,0C3h, 23h,0B4h, 13h, 3Ah,0BCh,0A2h
	db	 1Ah, 9Ch,0B0h,0A2h, 41h,0C1h, 33h, 0Bh, 22h, 04h, 93h, 42h,0A1h,0CBh, 3Ch, 24h, 9Ch,0B2h,0BBh, 90h
	db	 93h, 20h, 99h, 03h,0CAh, 3Ah,0A4h,0CAh, 4Ah, 24h, 40h,0B4h, 1Ah, 4Ah,0CAh,0ABh, 3Bh,0CAh, 43h, 3Bh
	db	0C0h, 4Ah, 10h,0CCh,0C2h, 1Ah, 94h, 44h, 3Ah, 21h,0BCh,0B5h, 0Ch,0ABh,0B2h, 90h, 23h, 43h, 03h, 0Bh
	db	0CCh, 41h, 3Ch,0C1h, 33h, 29h, 33h, 32h, 32h,0BAh,0BCh, 3Ah,0CBh,0A3h, 2Ah,0A4h,0BBh,0ABh, 43h, 0Bh
	db	0B3h, 34h, 11h, 24h, 13h, 9Ah,0B0h,0A0h, 2Bh,0CBh, 20h,0CBh,0A3h, 1Bh, 94h,0BBh, 93h, 53h, 1Ch,0CBh
	db	 32h, 02h, 2Bh,0A3h, 22h, 44h, 13h,0CBh, 93h, 2Bh,0C0h, 12h, 1Ch,0CAh, 9Bh, 92h, 20h,0B2h, 2Ah, 23h
	db	0A1h, 43h, 2Bh,0A1h, 3Bh, 00h, 13h, 2Ah, 1Ah,0B9h, 40h,0ABh, 33h, 2Ah, 22h,0BAh,0C9h, 0Ah,0A0h, 3Ah
	db	0BBh, 2Bh,0B3h, 34h, 3Ch,0B3h, 23h, 51h,0BBh, 3Bh, 09h,0BCh,0CBh,0A0h,0C2h, 44h,0CBh, 11h, 23h, 34h
	db	 3Bh,0B4h, 23h,0CBh, 3Bh, 2Ah,0A1h, 91h, 1Ah, 93h, 3Ch,0A2h, 99h, 34h, 20h,0B3h, 2Ah, 1Ah,0B2h, 3Ah
	db	0B0h,0BBh,0ABh, 92h, 4Ch,0CBh, 34h,0A9h, 19h, 23h,0A4h, 59h,0CBh, 33h,0BCh, 32h, 9Bh, 19h,0A4h, 9Bh
	db	0C9h,0BBh,0B4h, 49h,0C2h, 42h, 34h, 2Ah, 02h,0ACh, 94h, 1Ch,0B2h, 32h,0ACh,0B2h, 43h,0B0h, 1Bh,0BAh
	db	 43h, 20h, 9Ah, 92h, 3Ah, 09h, 0Ah,0CAh, 20h, 9Bh, 10h, 1Bh, 13h,0C3h, 45h,0ABh, 04h, 30h,0ABh, 02h
	db	 21h,0BCh,0BAh,0ABh,0B2h, 32h,0BAh, 39h,0B2h, 43h, 30h,0A3h, 0Bh,0B3h, 9Bh,0BAh,0B9h, 22h, 39h, 30h
	db	0A9h, 9Bh,0A3h, 49h,0A0h,0A9h, 43h,0B0h, 12h, 0Ch,0ACh, 03h, 20h, 20h,0B1h, 34h, 9Ah, 2Ah,0AAh, 24h
	db	 3Bh,0B0h, 0Ah, 39h,0A3h, 0Ch,0A2h,0BBh, 32h, 22h,0ACh,0BAh, 93h, 19h, 23h, 20h,0B0h, 19h,0A2h,0A1h
	db	0A3h, 3Bh,0B2h, 20h,0B1h, 9Ah,0B0h, 9Ah, 22h, 21h,0B3h, 3Ah,0A1h, 93h,0A9h, 00h,0A1h, 32h,0A1h,0ABh
	db	 02h, 22h, 1Ch, 93h, 33h, 3Bh, 23h, 3Ah, 01h,0BCh,0A1h,0BBh, 2Ah,0B9h,0B9h, 03h, 42h, 49h, 9Ah, 1Bh
	db	0B4h, 3Ah,0A9h, 33h, 22h, 0Bh, 34h,0ABh,0CBh, 02h, 2Bh, 01h, 4Bh,0A2h, 2Ah,0A2h, 01h,0BBh,0A2h, 2Ah
	db	0A2h, 39h, 39h,0AAh, 10h, 19h, 0Ah,0A0h, 02h, 01h, 23h, 42h,0B2h, 3Bh,0A1h, 3Ah,0CBh, 93h,0ABh, 22h
	db	 0Bh, 93h, 21h, 01h,0CAh, 02h, 02h, 3Ah, 03h, 29h,0AAh, 21h,0AAh, 22h,0BAh,0A1h, 2Ah, 01h, 9Ah, 9Ah
	db	 9Ah,0B3h, 23h, 2Bh, 13h,0BAh, 3Ah,0B3h, 32h,0B0h, 3Ah,0A0h, 32h,0BAh,0B9h, 33h, 2Ah, 02h, 20h,0C0h
	db	 32h,0B2h, 29h,0AAh, 30h, 92h, 23h, 1Bh, 39h, 1Ch,0B3h, 31h, 2Ah, 01h,0ABh,0BAh, 31h,0A9h, 9Bh,0A0h
	db	 01h, 11h, 29h, 91h, 23h, 29h, 9Bh, 3Ah,0B3h, 3Ah,0B3h,0ABh,0A1h, 91h, 0Ah, 3Ah,0A3h, 31h,0CBh, 34h
	db	 0Bh,0A9h, 9Bh,0B1h, 22h, 11h,0B0h, 29h, 31h, 22h,0A2h, 3Ah,0B0h, 11h, 20h, 00h, 21h, 2Ah, 92h, 22h
	db	 02h, 9Ch, 23h, 31h,0BBh, 13h, 09h, 21h, 99h, 91h, 10h, 21h,0B0h, 49h,0AAh,0ABh, 0Ah, 23h, 39h,0B1h
	db	 2Ah, 22h,0ABh, 92h,0A0h, 90h, 9Ah, 22h, 12h, 00h, 02h, 29h,0A9h,0B2h, 2Bh, 92h, 92h, 91h,0B9h, 19h
	db	 1Bh,0B0h, 10h, 02h,0A2h, 32h,0A0h,0A3h, 0Ah,0B2h,0B2h, 3Ah,0B9h, 90h, 21h, 1Ah, 2Bh,0B2h, 39h, 00h
	db	 13h, 2Bh, 92h, 12h
zDAC_Sample2_End:

zDAC_Sample3:
	db	0ABh,0B2h, 45h, 4Dh,0E0h, 54h, 34h, 4Ch,0DEh, 6Eh,0ECh,0B3h, 4Bh, 56h, 66h, 55h, 63h, 03h, 32h,0DEh
	db	0FEh, 57h,0DEh,0DEh,0DCh, 15h, 3Dh,0EBh,0B5h, 76h, 66h, 43h, 5Eh,0FCh,0ADh,0CCh,0EBh, 44h,0BBh, 73h
	db	0C0h, 2Dh,0DCh, 13h, 21h,0BCh,0CCh,0A3h, 64h, 25h, 65h, 66h, 50h, 0Ah,0DDh,0CCh, 25h, 3Dh,0DDh,0C6h
	db	0AEh,0FEh,0DDh, 42h, 30h, 63h,0DDh, 56h,0CEh,0B5h,0DCh, 45h, 45h, 54h, 34h, 54h,0BBh, 43h, 3Ah,0BCh
	db	0CCh,0CCh,0DCh, 3Bh,0DCh,0DCh, 55h, 51h, 56h, 65h, 45h, 5Ah, 2Ch,0EAh, 33h, 9Bh, 3Dh,0D0h, 3Ch,0DBh
	db	 9Bh,0EEh,0DAh, 0Ch,0ECh, 43h, 44h, 45h, 5Ch,0D9h, 64h,0DCh, 1Ch, 44h, 66h, 46h, 6Ch,0D4h, 53h,0DEh
	db	0EEh,0BBh,0D3h, 55h, 55h, 33h, 23h,0CCh,0A5h, 59h, 24h, 3Dh,0CAh,0BBh,0BEh,0CCh,0A5h, 4Bh, 44h, 4Dh
	db	0D9h,0CCh,0DCh,0DDh,0CEh, 46h, 5Bh,0BAh, 44h, 44h, 43h, 13h, 65h, 55h, 3Bh,0B9h, 35h, 1Bh,0B3h, 42h
	db	0BCh,0DBh, 3Ch,0DEh,0DCh, 46h, 54h, 5Bh,0EDh, 40h,0DCh,0DAh, 3Ch, 44h, 33h, 52h,0DBh, 55h,0CDh,0DDh
	db	0B2h, 49h,0EDh,0A5h, 6Ch, 25h,0DCh, 66h, 45h, 3Dh, 24h, 34h, 52h, 25h, 4Bh,0BAh,0DBh, 49h,0D2h, 3Ch
	db	 42h,0BBh,0CCh,0EEh, 24h, 3Ch,0BCh, 34h, 93h, 4Ah,0CDh,0DCh, 2Ch, 45h, 49h,0C4h, 55h, 44h, 5Ch,0DCh
	db	0BBh, 03h,0BDh,0A5h, 5Ah, 45h, 35h, 2Bh,0CBh, 65h,0CAh, 2Bh, 9Ch,0DDh, 54h,0C3h, 52h,0DCh,0D4h, 50h
	db	0DDh,0CCh,0DCh, 2Ch,0CDh,0BBh,0B4h, 54h,0ADh,0A5h,0BCh, 55h,0B4h, 43h, 49h,0C4h, 44h, 54h,0DAh, 63h
	db	0C4h,0DDh,0C9h,0ABh, 45h, 5Ch,0B4h, 5Ch,0DCh, 54h,0EDh,0CCh,0C3h,0B9h, 54h,0B3h,0BAh, 64h,0CDh,0DDh
	db	0E3h,0A0h,0BAh, 30h, 3Ah, 4Ah, 24h,0CAh, 55h, 43h, 1Bh, 19h, 0Ch, 44h, 95h, 49h, 43h,0B4h, 49h, 5Ch
	db	0E4h, 5Dh, 04h,0DCh, 0Bh,0D5h, 0Eh, 45h, 3Bh,0CBh, 33h,0DCh,0DCh, 54h,0CCh, 35h,0ADh, 56h, 3Eh,0CAh
	db	0DAh,0CAh, 44h, 03h, 53h, 15h, 42h,0B3h, 32h, 4Bh, 24h,0CDh, 24h, 4Ch,0A1h, 03h, 50h, 45h,0CDh,0D9h
	db	0CDh, 14h, 2Dh,0D2h, 3Dh, 45h, 3Ch,0C3h,0B2h,0B1h,0BBh,0B3h, 44h, 4Ch,0D9h, 33h, 53h,0D3h, 5Ch,0A4h
	db	 40h, 32h,0BCh,0AAh, 23h, 25h, 5Ch,0CAh, 15h, 5Dh,0CBh,0DCh, 40h,0C5h, 4Dh, 95h,0BCh,0A3h, 33h,0CCh
	db	0CDh, 43h,0ECh, 53h,0D2h, 45h, 33h,0CCh, 04h, 3Ch, 9Ah,0B3h, 40h,0B5h, 4Bh, 35h, 42h, 2Bh,0D1h,0A1h
	db	 53h,0C9h, 9Ch,0C3h, 3Bh, 33h,0CBh, 3Ch,0A5h,0CCh, 2Bh,0C3h, 31h, 9Bh,0C2h,0B2h, 43h, 4Ah,0CCh,0D2h
	db	 54h,0CCh, 3Bh,0DBh, 54h, 32h, 14h, 43h,0CCh,0C5h, 4Ch,0C2h,0BAh, 45h, 4Bh,0CCh, 94h, 50h,0AAh,0B4h
	db	 3Dh,0C0h, 3Ch,0CBh, 44h,0BAh,0A1h, 4Bh,0CBh,0ABh,0BBh, 42h,0DAh, 43h,0C3h, 50h,0B9h,0C3h, 1Ch, 34h
	db	 33h, 29h, 3Ch,0B4h, 42h, 94h,0BCh, 24h, 44h, 1Dh,0CAh,0BCh, 45h,0B9h,0CCh, 44h, 32h,0CBh, 4Bh,0B0h
	db	0BCh,0ABh, 9Ah,0DBh, 43h, 45h,0ACh,0B0h, 2Ch, 44h, 1Ch,0ABh,0B2h, 44h,0C0h, 40h, 9Ch, 35h, 4Ch,0C4h
	db	 2Ch,0C3h, 33h, 32h, 04h,0ACh, 3Ah, 29h,0CBh, 34h,0B2h,0ACh,0B4h, 3Bh,0C2h,0BCh, 94h, 4Ah,0CBh, 2Ch
	db	0C2h, 32h,0ACh, 02h, 24h, 23h,0BCh, 45h,0B0h, 2Bh,0B1h, 13h, 3Ah,0A4h, 3Bh,0C3h, 45h, 4Bh,0A4h,0CDh
	db	0A3h, 22h,0BCh,0DAh, 39h,0B4h, 54h,0DDh,0B1h, 43h, 9Bh,0BBh,0BAh, 04h, 2Ch, 34h, 39h, 29h,0C0h, 4Bh
	db	0C4h, 39h,0BBh, 45h,0CDh, 34h, 02h, 4Ch,0C3h, 43h, 03h,0A0h, 3Ah,0CAh, 5Ah,0CAh, 43h, 32h,0ABh,0BCh
	db	 2Bh,0C9h, 41h,0CDh, 24h, 3Bh,0CAh, 04h, 2Bh, 14h, 4Ch,0DBh,0A0h, 19h,0A2h, 31h, 24h, 44h, 30h, 3Ch
	db	0B3h, 39h, 33h,0BBh, 34h, 30h,0DCh, 55h,0CDh,0C4h, 4Ch,0B4h,0BDh,0C4h, 53h,0BBh,0CCh, 33h,0A0h, 2Ah
	db	0CBh, 33h,0B1h, 1Ch, 13h, 42h,0C1h, 3Ah, 90h, 31h, 24h, 2Bh,0CCh, 92h, 33h, 34h, 3Ch,0B4h, 43h, 0Ah
	db	0C9h, 30h, 33h, 3Ch,0DCh, 93h, 33h, 33h,0B2h, 44h,0BAh,0CDh,0DBh, 44h, 2Ah,0B3h,0ACh,0C4h, 49h,0ABh
	db	0B1h,0A0h, 43h, 43h,0BDh,0C3h, 54h, 10h, 13h, 90h, 22h, 01h, 23h, 2Ah,0A1h, 21h,0B9h, 32h,0BCh, 93h
	db	0BAh, 1Bh,0C9h, 43h,0BCh, 2Bh,0B2h, 4Bh,0BAh, 20h,0A3h, 2Bh,0CAh,0A3h, 39h, 21h, 13h, 3Bh, 34h, 2Ah
	db	0BBh, 34h, 21h,0BCh, 11h,0BBh, 43h,0A2h, 34h, 0Ch,0B9h, 2Ah, 33h, 90h, 31h,0ABh,0B0h, 3Ah,0CCh, 44h
	db	 2Ch,0B0h,0BBh, 13h,0ACh,0CBh, 14h, 42h, 00h,0CCh, 22h, 22h, 99h,0B4h, 5Ah, 13h,0BBh, 33h,0A3h, 21h
	db	 20h, 32h, 4Ah,0CAh, 10h,0A4h, 0Ch,0B9h,0A2h, 2Ah,0B2h,0BBh, 3Ah,0CCh, 13h, 32h,0BBh, 9Ah, 99h, 23h
	db	 3Ah,0C3h, 40h,0CBh, 32h, 24h, 2Ah, 24h, 2Ch,0BAh, 10h,0A2h, 4Ah,0BBh, 33h, 49h,0B9h, 12h, 39h, 32h
	db	0BBh,0A1h,0A9h, 9Ah, 23h, 10h, 1Bh,0A3h, 10h,0BCh,0BAh,0BAh, 93h, 3Ah, 2Bh,0BAh, 9Ah,0BAh, 44h, 91h
	db	 12h, 20h,0A0h, 29h, 00h, 03h, 23h, 43h, 9Bh, 0Bh, 24h, 3Ch,0A3h, 43h,0ACh,0A9h,0A0h,0ABh, 12h,0BCh
	db	 29h,0A2h,0ACh,0B2h,0A2h, 33h,0A1h, 1Bh,0B2h, 22h, 3Ah,0BAh,0BCh, 34h, 32h, 30h, 22h,0AAh, 33h, 9Ah
	db	 33h, 9Bh,0BAh, 33h, 0Ah, 1Ch, 04h, 42h,0CCh, 13h, 39h, 23h,0ABh,0AAh,0B3h, 4Bh,0CCh, 03h, 43h,0ABh
	db	0BAh,0BBh, 21h,0CBh, 93h, 3Bh, 14h, 1Ch,0B9h, 33h,0ABh, 04h, 53h,0ABh,0A9h, 91h, 33h, 09h, 34h, 30h
	db	0AAh, 9Bh,0B1h, 22h, 1Ah,0C0h, 32h,0BCh,0A3h, 2Bh,0CBh, 34h,0BCh,0B1h,0A2h, 20h, 0Ah, 11h, 00h, 92h
	db	 22h, 2Bh,0A3h, 11h, 20h, 00h, 23h, 20h, 32h,0ABh,0A9h, 33h, 00h,0ABh,0B2h, 43h,0ABh,0CBh, 34h, 19h
	db	 22h,0BCh,0A4h, 31h, 1Ah,0BAh, 09h,0AAh,0ABh,0B9h, 33h, 1Bh,0A0h,0AAh,0ABh,0BBh, 94h, 43h, 3Bh, 23h
	db	 0Bh,0C2h, 44h, 3Ah, 12h, 12h, 39h,0A0h, 2Ah,0B9h, 33h, 23h, 2Bh,0BBh,0A0h,0AAh,0B9h, 30h,0BCh, 12h
	db	 10h, 2Bh,0CCh, 93h, 21h, 21h, 90h, 00h, 13h, 29h, 9Bh, 14h, 30h, 90h, 10h, 00h, 22h, 1Bh,0B0h, 34h
	db	 2Ah, 02h,0BBh, 93h, 99h, 21h, 2Ah,0B0h, 21h, 09h, 00h, 01h, 1Ah, 12h,0BBh, 9Ah, 13h, 2Bh,0CAh,0ABh
	db	 93h, 1Ah,0A2h, 32h,0AAh,0A0h,0ABh, 03h, 32h, 02h, 33h, 12h, 21h, 00h,0BBh, 34h, 30h, 12h, 2Bh, 91h
	db	0A0h, 30h,0ABh, 92h,0AAh, 2Ah,0BBh,0ABh,0B0h,0B2h, 30h,0BBh, 93h, 32h,0BBh, 99h, 21h, 92h, 22h, 29h
	db	0A3h, 32h, 0Ah,0A1h, 32h, 32h,0A9h, 09h, 0Ah,0B3h, 39h, 10h,0A0h, 99h, 43h,0BBh, 21h,0CBh, 11h, 02h
	db	 29h, 09h, 12h, 0Ah, 21h,0BBh,0BBh, 12h, 92h, 31h,0BCh,0AAh, 20h,0A9h, 21h, 92h, 11h, 22h, 09h, 21h
	db	0A9h, 34h, 23h, 33h, 0Ah, 9Ah, 13h,0AAh,0A0h, 33h, 0Bh,0AAh,0BAh, 1Ah,0AAh,0B9h, 30h, 02h, 9Bh,0BCh
	db	0A1h, 10h, 00h, 10h, 90h, 22h, 33h, 9Bh, 91h,0A1h, 33h, 30h, 0Bh, 02h, 31h, 91h, 2Ah,0A0h, 32h, 01h
	db	 2Ah,0BAh,0A9h, 01h, 22h, 21h,0BBh, 91h, 32h,0BBh, 12h, 19h, 12h, 90h, 9Ah, 9Ah, 9Ah,0BBh, 22h, 99h
	db	0ABh, 02h, 21h, 1Ah,0BAh, 02h, 23h, 33h, 32h, 9Ah, 23h, 19h, 00h, 91h, 33h, 3Ah,0A9h, 23h, 9Ah,0AAh
	db	0A9h,0AAh, 32h,0ABh,0BBh,0AAh,0A9h, 11h, 09h, 0Ah,0A0h, 10h,0A0h, 1Ah,0A0h, 12h, 31h, 99h, 12h, 33h
	db	 22h, 19h,0A9h, 92h, 33h, 19h,0AAh,0B9h, 22h, 99h, 11h, 12h, 00h, 09h,0BAh,0A2h, 21h, 90h, 99h, 13h
	db	 19h, 0Ah,0BBh, 91h, 0Bh, 92h, 2Ah, 00h,0ABh, 91h, 10h, 10h,0ABh, 12h, 32h, 1Ah, 90h, 91h, 32h, 23h
	db	 33h, 21h, 01h, 90h, 21h,0ABh,0A2h, 33h, 19h,0BBh,0ABh, 00h,0A1h, 0Ah,0A0h, 9Ah,0AAh,0A0h,0ABh, 99h
	db	0A9h, 33h, 21h, 9Ah, 02h, 21h, 22h,0A0h, 09h, 13h, 49h, 91h, 9Ah, 22h, 90h,0A9h, 22h, 22h,0AAh, 00h
	db	0A0h, 10h, 00h, 09h, 92h, 20h,0ABh,0B9h, 01h, 23h, 0Ah,0A1h, 22h, 9Ah,0BAh, 9Ah,0B0h, 00h, 90h, 12h
	db	 29h,0ABh,0A1h, 22h, 22h, 20h, 01h, 22h, 11h, 22h, 19h,0A0h, 43h, 32h, 0Ah, 9Ah,0A9h, 20h,0ABh, 90h
	db	0A9h,0AAh, 99h,0ABh,0BAh, 03h, 10h, 2Ah,0B9h, 9Ah, 12h, 22h,0ABh,0B3h, 33h, 22h, 0Ah,0A1h, 23h, 11h
	db	 19h, 01h, 22h, 11h, 0Ah,0A0h, 29h, 99h, 22h, 9Ah,0A2h, 20h, 9Ah,0B9h, 00h, 22h, 01h, 19h, 90h,0AAh
	db	0AAh, 12h, 0Ah, 90h, 01h, 11h,0ABh,0BBh, 92h, 20h, 99h, 12h, 01h, 22h, 10h,0A0h, 32h, 12h, 22h, 23h
	db	 29h,0A9h, 12h, 22h, 00h, 9Ah, 01h, 19h,0AAh,0BAh,0BAh, 99h, 99h, 90h, 91h, 00h, 9Ah,0B0h, 19h, 92h
	db	 20h,0AAh, 12h, 02h, 31h, 90h, 91h, 33h, 20h, 11h,0AAh, 12h, 39h, 9Ah, 90h, 10h, 01h, 21h, 99h,0ABh
	db	 91h, 22h, 0Ah,0AAh, 22h, 09h, 99h, 09h, 10h, 91h, 22h,0ABh,0B9h,0AAh, 02h, 21h,0AAh,0A9h, 22h, 0Bh
	db	0A9h, 11h, 22h, 22h, 22h, 21h, 90h, 22h, 21h, 01h, 12h, 21h, 01h, 09h,0AAh, 01h, 11h,0A0h, 29h,0BBh
	db	0AAh,0ABh,0AAh,0AAh,0A0h, 23h, 00h, 9Ah, 90h, 12h, 10h, 0Ah, 03h, 21h, 00h, 00h, 02h, 32h, 22h, 0Ah
	db	 91h, 20h, 00h, 09h,0AAh,0A0h, 33h, 1Ah,0AAh, 02h, 10h, 9Ah,0BAh, 02h, 32h, 9Ah, 99h, 10h, 9Ah, 99h
	db	 99h, 11h, 29h,0A9h, 09h,0ABh, 00h, 00h, 11h, 12h, 09h,0A0h, 22h, 01h, 12h, 12h, 22h, 22h, 11h, 10h
	db	 01h, 22h, 09h, 09h,0A0h, 19h, 9Ah,0ABh, 99h, 91h, 1Ah,0ABh,0AAh,0B9h, 90h, 12h, 99h, 01h, 12h, 22h
	db	 00h, 90h, 92h, 32h, 00h, 99h, 00h, 22h, 21h, 00h, 11h, 22h, 19h,0AAh,0BAh, 23h, 19h,0AAh, 90h, 12h
	db	 29h,0AAh, 00h, 10h, 9Ah, 00h, 00h, 01h, 99h, 00h, 9Ah, 90h, 99h, 00h, 11h, 09h,0A9h, 09h,0AAh, 02h
	db	 20h, 91h, 23h, 33h, 09h, 91h, 12h, 22h, 21h, 12h, 19h,0A9h, 00h, 9Ah, 01h, 09h, 99h,0AAh,0AAh, 0Ah
	db	 9Ah,0A9h,0AAh, 12h, 00h,0AAh,0A0h, 02h, 22h, 1Ah, 02h, 22h, 22h, 29h, 99h, 91h, 32h, 19h, 91h, 10h
	db	 01h, 90h, 01h, 90h, 11h, 10h, 9Ah,0AAh, 01h, 0Ah, 90h, 00h, 00h, 21h, 29h, 9Ah, 09h, 90h, 00h, 00h
	db	 9Ah, 90h, 9Ah, 99h, 99h, 91h, 12h, 12h, 10h, 00h, 9Ah, 00h, 12h, 23h, 22h, 22h, 10h, 19h, 00h, 21h
	db	 11h, 11h, 0Ah, 9Ah,0AAh,0AAh, 99h, 99h, 09h, 00h, 9Ah,0ABh,0AAh, 11h, 09h, 00h, 12h, 12h, 09h,0A0h
	db	 12h, 22h, 21h, 11h, 01h, 11h, 11h, 09h, 90h, 11h, 10h, 09h,0AAh, 91h, 10h, 99h, 00h, 22h, 19h, 9Ah
	db	 91h, 10h, 9Ah,0A9h, 01h, 00h, 00h, 11h, 9Ah, 00h, 99h,0AAh, 00h, 19h, 00h, 00h, 99h, 90h, 21h, 01h
	db	 22h, 22h, 00h, 09h, 12h, 32h, 90h, 12h, 22h, 19h, 09h, 99h, 90h, 00h,0A9h,0AAh,0AAh,0A9h, 99h,0A9h
	db	 91h, 90h, 01h, 0Ah,0AAh, 09h, 12h, 11h, 22h, 22h, 11h, 01h, 10h, 01h, 00h, 01h, 20h, 09h, 00h, 00h
	db	 00h, 10h, 00h, 90h, 10h,0AAh, 01h, 09h, 90h, 91h, 11h, 10h, 09h,0A9h, 99h, 90h, 10h, 09h, 90h, 11h
	db	 00h, 99h,0AAh,0A0h, 11h, 99h, 01h, 21h, 09h, 00h, 22h, 11h, 22h, 22h, 21h, 10h,0AAh, 92h, 22h, 01h
	db	 10h, 00h, 09h,0AAh,0ABh,0AAh, 99h, 99h, 99h, 9Ah, 99h, 10h, 01h, 00h, 11h, 20h, 9Ah, 90h, 22h, 20h
	db	 01h, 12h, 22h, 22h, 09h, 90h, 09h, 00h, 10h, 00h, 90h, 09h, 00h, 10h, 9Ah, 00h, 09h, 01h, 90h, 09h
	db	 99h, 12h, 20h, 09h, 99h, 00h, 09h,0A9h, 90h, 09h, 90h, 11h, 09h, 00h, 00h, 90h,0A9h, 01h, 01h, 22h
	db	 22h, 01h, 12h, 12h, 21h, 12h, 11h, 0Ah, 9Ah, 99h, 90h, 01h, 00h, 00h, 99h,0AAh,0BAh,0A9h,0A9h, 00h
	db	 00h, 01h, 9Ah, 91h, 12h, 01h, 10h, 12h, 21h, 10h, 91h, 00h, 02h, 22h, 21h, 09h, 00h, 90h, 90h, 99h
	db	0A9h, 01h, 20h, 00h, 99h, 90h, 00h, 01h, 09h, 99h, 11h, 00h, 09h, 00h, 00h, 00h, 09h, 90h, 99h, 99h
	db	 00h, 99h, 90h, 00h, 11h, 11h, 19h, 01h, 01h, 10h, 01h, 11h, 22h, 21h, 11h, 00h, 21h, 90h, 01h, 09h
	db	 99h, 9Ah,0AAh, 99h, 90h, 09h, 0Ah,0A9h, 99h,0A9h, 09h, 09h, 91h, 22h, 21h, 01h, 01h, 00h, 01h, 23h
	db	 20h, 09h, 00h, 10h, 19h, 00h, 01h, 00h, 00h, 0Ah, 9Ah, 00h, 10h, 09h, 00h, 10h, 01h, 09h,0A9h, 00h
	db	 11h, 00h, 90h, 10h, 09h, 99h,0A0h, 10h, 09h, 00h, 09h, 09h, 00h, 09h, 99h, 01h, 11h, 22h, 11h, 00h
	db	 01h, 11h, 11h, 21h, 01h, 11h, 10h, 00h, 0Ah, 99h, 02h, 09h,0AAh,0AAh,0AAh,0A9h,0A9h, 90h, 01h, 10h
	db	 00h, 09h, 90h, 01h, 11h, 21h, 10h, 11h, 11h, 10h, 19h, 01h, 11h, 12h, 00h, 09h,0A9h, 00h, 00h, 09h
	db	 90h, 00h, 00h, 99h, 00h, 01h, 10h, 09h, 90h, 01h, 09h, 99h, 00h, 11h, 00h, 09h, 00h, 00h, 9Ah, 90h
	db	 99h, 01h, 00h, 09h, 09h, 10h, 11h, 11h, 01h, 11h, 22h, 12h, 11h, 00h, 10h, 09h, 00h, 11h, 99h, 99h
	db	 00h, 99h,0AAh, 99h, 09h, 99h,0A9h, 9Ah, 99h, 01h, 00h, 12h, 10h, 11h, 10h, 10h, 00h, 02h, 12h, 01h
	db	 01h, 01h, 10h, 00h, 09h, 00h, 10h, 00h, 99h, 99h, 99h, 00h, 09h, 00h, 11h, 00h, 00h, 99h, 11h, 00h
	db	 09h, 09h, 10h, 01h, 90h, 99h, 90h, 90h, 10h, 09h, 99h, 90h, 09h, 01h, 21h, 00h, 10h, 10h, 11h, 11h
	db	 10h, 11h, 12h, 11h, 00h, 00h, 90h, 09h, 00h, 90h, 09h, 99h,0AAh, 9Ah, 99h, 99h, 00h, 90h, 90h, 90h
	db	 00h, 00h, 01h, 21h, 22h, 11h, 01h, 10h, 00h, 00h, 11h, 11h, 09h, 00h, 00h, 10h, 09h, 99h, 00h, 09h
	db	 09h, 99h, 99h, 00h, 21h, 10h, 00h, 11h, 19h, 0Ah, 99h, 99h, 01h, 10h, 00h, 00h, 09h, 09h, 00h, 90h
	db	 99h, 00h, 10h, 00h, 00h, 90h, 11h, 12h, 11h, 11h, 11h, 11h, 10h, 10h, 90h, 11h, 00h, 99h, 90h, 09h
	db	 99h,0A9h, 99h, 99h, 99h, 99h, 90h, 90h, 00h, 00h, 00h, 10h, 11h, 11h, 01h, 11h, 21h, 20h, 01h, 01h
	db	 00h, 09h, 99h, 09h, 00h, 01h, 10h, 00h, 90h, 00h, 00h, 99h, 99h, 09h, 00h, 00h, 00h, 21h, 00h, 10h
	db	 00h, 00h, 99h, 99h, 00h, 91h, 00h, 09h, 09h, 90h, 00h, 09h, 01h, 01h, 00h, 11h, 00h, 01h, 01h, 11h
	db	 22h, 11h, 10h, 90h, 01h, 00h, 90h, 90h, 10h, 99h,0AAh,0AAh, 90h, 99h, 99h, 90h, 01h, 00h, 09h, 09h
	db	 01h, 11h, 21h, 10h, 00h, 01h, 11h, 00h, 12h, 11h, 01h, 00h, 00h, 99h, 99h, 90h, 90h, 09h, 01h, 00h
	db	 10h, 90h, 99h, 00h, 10h, 00h, 00h, 09h, 00h, 11h, 09h, 00h, 10h, 00h, 90h, 09h, 99h, 99h, 00h, 00h
	db	 00h, 00h, 00h, 01h, 00h, 11h, 10h, 11h, 11h, 11h, 10h, 00h, 00h, 11h, 10h, 09h, 90h, 09h, 09h, 99h
	db	 99h, 99h, 09h, 9Ah, 99h, 99h, 00h, 01h, 01h, 00h, 01h, 10h, 10h, 10h, 21h, 11h, 01h, 00h, 10h, 00h
	db	 01h, 01h, 00h, 09h, 90h, 99h, 09h, 99h, 00h, 10h, 00h, 00h, 00h, 01h, 00h, 90h, 91h, 00h, 10h, 00h
	db	 90h, 90h, 01h, 09h, 00h, 00h, 09h, 00h, 99h, 90h, 00h, 00h, 00h, 01h, 11h, 11h, 00h, 10h, 11h, 11h
	db	 10h, 00h, 00h, 10h, 00h, 00h, 00h, 00h, 09h, 9Ah, 9Ah, 9Ah, 99h, 09h, 00h, 90h, 99h, 00h, 00h, 11h
	db	 11h, 11h, 11h, 11h, 00h, 01h, 00h, 10h, 01h, 00h, 10h, 19h, 09h, 09h, 00h, 90h, 09h, 09h, 09h, 00h
	db	 00h, 00h, 10h, 00h, 00h, 10h, 00h, 00h, 09h, 09h, 01h, 01h, 90h, 99h, 00h, 00h, 00h, 09h, 00h, 00h
	db	 00h, 90h, 99h, 00h, 11h, 12h, 11h, 11h, 11h, 10h, 00h, 01h, 00h, 00h, 00h, 90h, 09h, 90h, 90h, 09h
	db	 99h, 99h, 99h, 99h, 99h, 09h, 01h, 01h, 01h, 00h, 10h, 11h, 02h, 11h, 11h, 01h, 00h, 09h, 00h, 00h
	db	 10h, 01h, 09h, 00h, 90h, 99h, 90h, 00h, 00h, 00h, 90h, 90h, 10h, 01h, 00h, 00h, 10h, 00h, 00h, 90h
	db	 10h, 09h, 00h, 90h, 09h, 09h, 09h, 00h, 00h, 00h, 01h, 00h, 00h, 00h, 00h, 10h, 11h, 12h, 11h, 10h
	db	 10h, 10h, 09h, 00h, 09h, 09h, 00h, 90h, 99h,0A9h, 99h, 00h, 00h, 90h, 99h, 90h, 90h, 09h, 10h, 11h
	db	 11h, 12h, 01h, 10h, 10h, 10h, 11h, 00h, 00h, 00h, 99h, 90h, 00h, 00h, 00h, 09h, 09h, 00h, 09h, 00h
	db	 90h, 01h, 10h, 10h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 90h, 90h, 99h, 00h, 00h, 00h, 00h
	db	 00h, 01h, 00h, 10h, 10h, 11h, 01h, 00h, 10h, 11h, 10h, 10h, 00h, 10h, 09h, 09h, 90h, 99h, 99h, 99h
	db	 90h, 99h,0A9h, 90h, 00h, 11h, 10h, 00h, 00h, 00h, 01h, 01h, 11h, 11h, 21h, 01h, 00h, 00h, 00h, 00h
	db	 90h, 09h, 09h, 99h, 09h, 00h, 00h, 10h, 00h, 00h, 09h, 00h, 10h, 01h, 01h, 00h, 09h, 09h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 99h, 09h, 09h, 90h, 00h, 01h, 00h, 00h, 01h, 01h, 01h, 11h, 11h, 01h, 11h, 00h
	db	 19h, 00h, 00h, 00h, 00h, 90h, 00h, 99h, 99h, 99h, 9Ah, 09h, 99h, 09h, 00h, 01h, 00h, 10h, 11h, 11h
	db	 11h, 00h, 00h, 01h, 00h, 11h, 01h, 10h, 00h, 00h, 90h, 90h, 99h, 00h, 90h, 00h, 90h, 09h, 00h, 00h
	db	 11h, 01h, 00h, 01h, 00h, 00h, 90h, 00h, 00h, 09h, 00h, 00h, 90h, 90h, 00h, 09h, 09h, 09h, 00h, 00h
	db	 00h, 01h, 01h, 11h, 11h, 01h, 01h, 10h, 11h, 00h, 00h, 10h, 00h, 09h, 99h, 09h, 00h, 09h, 90h, 99h
	db	 99h, 99h, 90h, 90h, 90h, 10h, 10h, 11h, 00h, 10h, 11h, 10h, 11h, 10h, 00h, 00h, 00h, 00h, 01h, 00h
	db	 00h, 90h, 90h, 90h, 99h, 09h, 00h, 10h, 00h, 00h, 00h, 01h, 01h, 10h, 10h, 00h, 00h, 09h, 90h, 90h
	db	 09h, 00h, 90h, 00h, 90h, 09h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 11h, 10h, 11h, 11h, 11h, 00h, 00h
	db	 00h, 10h, 90h, 09h, 09h, 09h, 09h, 09h, 90h, 99h, 90h, 99h, 09h, 09h, 00h, 90h, 10h, 11h, 11h, 11h
	db	 01h, 11h, 00h, 10h, 01h, 00h, 00h, 00h, 09h, 00h, 99h, 00h, 00h, 00h, 90h, 90h, 00h, 00h, 09h, 10h
	db	 01h, 01h, 00h, 00h, 01h, 01h, 00h, 00h, 09h, 09h, 09h, 99h, 90h, 90h, 00h, 00h, 00h, 00h, 00h, 00h
	db	 10h, 01h, 00h, 10h, 11h, 01h, 01h, 11h, 01h, 10h, 01h, 90h, 09h, 00h, 99h, 09h, 99h, 99h, 90h, 90h
	db	 90h, 90h, 90h, 00h, 00h, 00h, 01h, 00h, 11h, 10h, 11h, 11h, 01h, 00h, 10h, 00h, 00h, 00h, 00h, 90h
	db	 90h, 90h, 99h, 09h, 00h, 10h, 01h, 00h, 00h, 00h, 00h, 10h, 00h, 00h, 01h, 00h, 00h, 00h, 00h, 00h
	db	 09h, 09h, 99h, 99h, 90h, 90h, 00h, 10h, 01h, 00h, 10h, 01h, 01h, 11h, 01h, 11h, 00h, 10h, 00h, 00h
	db	 01h, 00h, 01h, 90h, 99h, 09h, 99h, 99h, 99h, 09h, 09h, 09h, 00h, 00h, 00h, 10h, 01h, 01h, 10h, 11h
	db	 00h, 10h, 01h, 10h, 01h, 00h, 00h, 00h, 90h, 09h, 09h, 00h, 09h, 09h, 09h, 00h, 00h, 01h, 01h, 01h
	db	 01h, 00h, 00h, 00h, 09h, 00h, 01h, 00h, 00h, 90h, 90h, 09h, 09h, 09h, 09h, 09h, 00h, 90h, 00h, 10h
	db	 11h, 10h, 11h, 11h, 01h, 10h, 10h, 10h, 00h, 90h, 00h, 00h, 09h, 00h, 00h, 90h, 99h, 99h, 09h, 99h
	db	 90h, 90h, 00h, 00h, 10h, 00h, 01h, 10h, 11h, 10h, 10h, 10h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 09h
	db	 09h, 90h, 90h, 00h, 09h, 00h, 00h, 01h, 00h, 10h, 10h, 10h, 01h, 00h, 00h, 09h, 00h, 90h, 90h, 00h
	db	 00h, 90h, 90h, 90h, 09h, 09h, 00h, 01h, 00h, 00h, 01h, 01h, 01h, 11h, 11h, 11h, 10h, 00h, 00h, 00h
	db	 09h, 09h, 09h, 00h, 09h, 09h, 09h, 09h, 09h, 90h, 90h, 90h, 09h, 00h, 01h, 01h, 01h, 10h, 10h, 11h
	db	 01h, 00h, 10h, 00h, 00h, 00h, 09h, 00h, 09h, 00h, 00h, 09h, 00h, 90h, 09h, 00h, 01h, 00h, 01h, 01h
	db	 00h, 01h, 00h, 01h, 00h, 09h, 00h, 90h, 00h, 90h, 90h, 90h, 09h, 00h, 09h, 00h, 90h, 10h, 00h, 01h
	db	 00h, 11h, 01h, 01h, 10h, 11h, 10h, 10h, 00h, 00h, 00h, 90h, 99h, 09h, 09h, 90h, 90h, 90h, 90h, 00h
	db	 09h, 00h, 00h, 90h, 10h, 00h, 10h, 01h, 01h, 11h, 01h, 00h, 10h, 00h, 00h, 00h, 00h, 90h, 09h, 09h
	db	 00h, 00h, 90h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 10h, 01h, 00h, 10h, 00h, 09h, 00h, 09h, 00h, 90h
	db	 90h, 90h, 09h, 09h, 09h, 00h, 10h, 00h, 10h, 00h, 10h, 10h, 11h, 01h, 01h, 01h, 01h, 00h, 01h, 00h
	db	 09h, 00h, 90h, 99h, 90h, 99h, 09h, 09h, 00h, 90h, 09h, 01h, 00h, 10h, 00h, 10h, 00h, 01h, 00h, 01h
	db	 00h, 11h, 01h, 00h, 00h, 00h, 00h, 90h, 09h, 00h, 90h, 90h, 09h, 00h, 00h, 10h, 10h, 00h, 01h, 00h
	db	 00h, 10h, 00h, 00h, 00h, 00h, 09h, 00h, 09h, 00h, 09h, 09h, 90h, 90h, 00h, 00h, 00h, 00h, 01h, 01h
	db	 01h, 10h, 10h, 10h, 10h, 01h, 00h, 10h, 00h, 00h, 09h, 00h, 09h, 09h, 09h, 09h, 99h, 09h, 00h, 90h
	db	 09h, 00h, 10h, 00h, 10h, 10h, 10h, 10h, 10h, 00h, 00h, 00h, 00h, 00h, 10h, 01h, 00h, 90h, 09h, 00h
	db	 90h, 09h, 00h, 00h, 09h, 01h, 00h, 01h, 01h, 01h, 00h, 10h, 09h, 00h, 00h, 09h, 00h, 00h, 90h, 09h
	db	 09h, 00h, 90h, 00h, 09h, 00h, 00h, 00h, 10h, 01h, 01h, 01h, 10h, 11h, 01h, 00h, 00h, 10h, 00h, 00h
	db	 90h, 09h, 09h, 00h, 90h, 99h, 09h, 09h, 00h, 90h, 00h, 00h, 00h, 01h, 00h, 10h, 10h, 10h, 10h, 00h
	db	 10h, 00h, 00h, 00h, 91h, 90h, 00h, 00h, 00h, 00h, 09h, 00h, 09h, 00h, 00h, 00h, 00h, 01h, 00h, 01h
	db	 01h, 00h, 10h, 00h, 09h, 00h, 90h, 09h, 00h, 90h, 90h, 00h, 90h, 00h, 90h, 00h, 10h, 00h, 00h, 10h
	db	 10h, 10h, 10h, 11h, 01h, 00h, 01h, 00h, 09h, 00h, 09h, 00h, 90h, 09h, 09h, 09h, 09h, 09h, 00h, 00h
	db	 09h, 00h, 00h, 10h, 01h, 01h, 01h, 00h, 10h, 00h, 10h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 90h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 10h, 00h, 01h, 00h, 00h, 00h, 00h, 00h, 90h, 90h, 99h
	db	 00h, 90h, 00h, 90h, 00h, 01h, 00h, 01h, 00h, 10h, 01h, 00h, 10h, 10h, 10h, 10h, 00h, 00h, 00h, 00h
	db	 09h, 00h, 90h, 90h, 90h, 90h, 90h, 09h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 01h, 00h, 10h, 10h, 01h
	db	 00h, 00h, 00h, 00h, 90h, 00h, 00h, 90h, 00h, 00h, 00h, 90h, 00h, 01h, 00h, 00h, 00h, 10h, 00h, 00h
	db	 00h, 00h, 10h, 00h, 90h, 00h, 00h, 00h, 09h, 00h, 90h, 99h, 09h, 00h, 00h, 00h, 10h, 01h, 00h, 11h
	db	 01h, 00h, 10h, 00h, 10h, 00h, 01h, 00h, 00h, 09h, 00h, 09h, 00h, 99h, 00h, 90h, 90h, 90h, 00h, 00h
	db	 00h, 00h, 01h, 00h, 01h, 00h, 10h, 00h, 01h, 00h, 00h, 10h, 00h, 00h, 09h, 00h, 00h, 90h, 00h, 00h
	db	 09h, 00h, 00h, 10h, 00h, 00h, 00h, 10h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 90h, 09h, 00h
	db	 00h, 09h, 00h, 90h, 00h, 90h, 01h, 00h, 10h, 10h, 11h, 01h, 01h, 00h, 01h, 00h, 09h, 00h, 00h, 09h
	db	 00h, 00h, 90h, 09h, 00h, 90h, 09h, 00h, 90h, 00h, 00h, 01h, 00h, 00h, 10h, 01h, 00h, 01h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 09h, 00h, 00h, 00h, 10h, 00h, 00h, 10h, 00h, 00h
	db	 01h, 00h, 09h, 00h, 00h, 90h, 00h, 00h, 09h, 00h, 90h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 10h
	db	 01h, 01h, 10h, 10h, 01h, 00h, 00h, 00h, 90h, 09h, 09h, 00h, 90h, 00h, 09h, 00h, 00h, 90h, 00h, 00h
	db	 09h, 00h, 01h, 00h, 01h, 01h, 00h, 10h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 10h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 09h, 00h, 00h
	db	 90h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 01h, 00h, 01h, 01h, 00h, 10h, 00h, 00h, 00h, 00h, 00h
	db	 90h, 90h, 09h, 09h, 09h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 00h, 10h, 00h, 10h, 00h
	db	 10h, 00h, 90h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 10h, 00h, 00h
	db	 00h, 00h, 00h, 00h, 00h, 90h, 00h, 09h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 10h, 00h, 00h, 10h
	db	 01h, 00h, 10h, 00h, 01h, 00h, 00h, 00h, 00h, 09h, 00h, 90h, 09h, 09h, 00h, 90h, 00h, 90h, 00h, 10h
	db	 00h, 10h, 00h, 01h, 00h, 00h, 00h, 00h, 00h, 01h, 00h, 00h, 10h, 90h, 00h, 00h, 09h, 00h, 00h, 09h
	db	 00h, 00h, 10h, 00h, 00h, 10h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 09h, 00h, 00h
	db	 09h, 00h, 00h, 00h, 00h, 00h, 10h, 00h, 10h, 00h, 10h, 00h, 01h, 00h, 10h, 00h, 00h, 09h, 00h, 00h
	db	 00h, 90h, 09h, 09h, 00h, 09h, 00h, 00h, 09h, 00h, 10h, 00h, 10h, 01h, 00h, 01h, 00h, 00h, 00h, 00h
	db	 00h, 90h, 01h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 09h, 00h, 01h, 00h, 00h, 00h, 10h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 90h, 00h, 00h, 00h, 09h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 01h, 00h, 00h, 10h, 01h
	db	 00h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 90h, 09h, 00h, 09h, 00h, 00h, 90h, 00h, 00h, 00h
	db	 00h, 00h, 10h, 00h, 10h, 00h, 10h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 01h, 90h
	db	 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 10h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 90h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 09h, 01h, 00h, 00h, 01h, 00h, 01h, 00h, 00h, 10h, 00h, 00h, 00h, 00h, 00h, 00h, 90h
	db	 00h, 09h, 00h, 90h, 00h, 00h, 90h, 00h, 00h, 00h, 00h, 01h, 00h, 00h, 10h, 00h, 10h, 00h, 00h, 00h
	db	 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
zDAC_Sample3_End:

	if MOMPASS==2
		if $ > z80_stack
			fatal "The driver is too big; the maximum size it can take is \{z80_stack}h. It currently takes \{$}h bytes. You won't be able to use this thing."
		else
			message "Uncompressed driver size: \{$}h bytes."
		endif
	endif

	restore
	padding off
	!org (Kos_Z80+Size_of_DAC_driver_guess)
