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
	binclude "sound/dac/kick.dpcm"
zDAC_Sample1_End:

zDAC_Sample2:
	binclude "sound/dac/snare.dpcm"
zDAC_Sample2_End:

zDAC_Sample3:
	binclude "sound/dac/timpani.dpcm"
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
