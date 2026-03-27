; DZ80 V3.4.1 Z80 Disassembly of z80nodata.bin
; 2007/09/18 15:48
; Sonic 1 Z80 Driver disassembly by Puto.
;
; Disassembly fixed, improved and integrated into SVN by Flamewing.
; Patched to be compiled with WLA-Z80


.DEFINE	z80_stack $1FFC
.DEFINE zDAC_Status $1FFD	; Bit 7 set if the driver is not accepting new samples, it is clear otherwise
.DEFINE zDAC_Sample $1FFF	;  Sample to play, the 68k will move into this locatiton whatever sample that's supposed to be played.

.DEFINE zYM2612_A0 $4000
.DEFINE zBankRegister $6000
.DEFINE zROMWindow $8000

.DEFINE Master_Clock 53693175
.DEFINE Z80_Clock Master_Clock/15

.FUNCTION zmake68kPtr(address) zROMWindow+(address&$7FFF)
.FUNCTION zmake68kBank(address) (address&$0FF8000)/zROMWindow

; turn a sample rate into a djnz loop counter
.FUNCTION pcmLoopCounterBase(sampleRate,baseCycles) 1+(Z80_Clock/(sampleRate)-(baseCycles)+(13/2))/13
.FUNCTION pcmLoopCounter(sampleRate) pcmLoopCounterBase(sampleRate,90) ; 90 is the number of cycles zPlaySEGAPCMLoop takes to deliver one sample.
.FUNCTION dpcmLoopCounter(sampleRate) pcmLoopCounterBase(sampleRate,301/2) ; 301 is the number of cycles zPlayPCMLoop takes to deliver two samples.

.MACRO ensure_offset_fits_byte ARGS max_size
	START:
	.ALIGN $100
	END:
	.IF END-START>0
	.PRINT "Inserted ",(END-START)," bytes of padding before data at ",START,"\n"
	.ENDIF
.ENDM


.MACRO zPCMMetadata ARGS label,size,sample_rate
	.DW	label					; Start
	.DW	size					; Length
	.DW	dpcmLoopCounter(sample_rate)		; Pitch
	.DW	0					; Padding
.ENDM


	.ROMBANKSIZE z80_stack

	.MEMORYMAP
	DEFAULTSLOT 0
	SLOTSIZE z80_stack
	SLOT 0 $0000
	.ENDME

	.ROMBANKS 1
	.BANK 0 SLOT 0
	.ORGA $0000

.SECTION "Init"

	di					; Disable interrupts. Interrupts will never be reenabled
	di					; for the z80, so that no code will be executed on V-Int.
	di					; This means that the sample loop is all the z80 does.
	ld	sp,z80_stack			; Initialize the stack pointer (unused throughout the driver)
	ld	ix,zYM2612_A0			; ix = Pointer to memory-mapped communication register with YM2612
	xor	a				; a=0
	ld	(zDAC_Status),a			; Disable DAC
	ld	(zDAC_Sample),a			; Clear sample
	ld	a,zmake68kBank(SegaPCM)&1	; least significant bit from ROM bank ID
	ld	(zBankRegister),a		; Latch it to bank register, initializing bank switch

	ld	b,8				; Number of bits to latch to ROM bank
	ld	a,zmake68kBank(SegaPCM)>>1	; Bank ID without the least significant bit

zBankSwitchLoop:
	ld	(zBankRegister),a		; Latch another bit to bank register.
	rrca					; Move next bit into position
	djnz	zBankSwitchLoop			; decrement and loop if not zero

	jr	zCheckForSamples

.ENDS ; End of section 'Init'

; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================

	ensure_offset_fits_byte($10)


.SECTION "DPCM Lookup Table"

zDACDecodeTbl:
	.INCBIN "sound/dac/dpcm/deltas.bin"

.ENDS ; End of section 'DPCM Lookup Table'

.SECTION "DAC Processing"

zCheckForSamples:
	ld	hl,zDAC_Sample			; Load the address of next sample.

zWaitDACLoop:
	ld	a,(hl)				; a = next sample to play.
	or	a				; Do we have a valid sample?
	jp	p,zWaitDACLoop			; Loop until we do

	sub	81h				; Make 0-based index
	ld	(hl),a				; Store it back into sample index (i.e., mark it as being played)
	cp	6				; Is the sample 87h or higher?
	jr	nc,zPlay_SegaPCM		; If yes, branch

	ld	de,0				; de = 0
	ld	iy,zPCM_Table			; iy = pointer to PCM Table

	; Each entry on PCM table has 8 bytes in size, so multiply a by 8
	; Warning: do NOT play samples 84h-86h!
	sla	a
	sla	a
	sla	a
	ld	b,0				; b = 0
	ld	c,a				; c = a
	add	iy,bc				; iy = pointer to DAC sample entry
	ld	e,(iy+0)			; e = low byte of sample location
	ld	d,(iy+1)			; de = pointer location of DAC sample
	ld	c,(iy+2)			; c = low byte of sample size
	ld	b,(iy+3)			; bc = size of the DAC sample
	exx					; bc' = size of sample, de' = location of sample, hl' = pointer to zDAC_Sample
	ld	d,80h				; d = is an accumulator; this initializes it to 80h
	ld	hl,zDAC_Status			; hl = pointer to zDAC_Status
	ld	(hl),d				; Set flag to not accept driver input
	ld	(ix+0),2Bh			; Select enable/disable DAC register
	ld	e,2Ah				; Command to select DAC output register
	ld	c,(iy+4)			; c = pitch of the DAC sample
	ld	(ix+1),d			; Enable DAC
	ld	(hl),0				; Set flag to accept driver input
	; After the following exx, we have:
	; bc = size of sample, de = location of sample, hl = pointer to zDAC_Sample,
	; c' = pitch of sample, d' = PCM accumulator,
	; e' = command to select DAC output register, hl' = pointer to DAC status
	exx
	ld	h,(zDACDecodeTbl&0FF00h)>>8	; We set low byte of pointer below

zPlayPCMLoop:
	ld	a,(de)			; 7	; a = byte from DAC sample
	and	0F0h			; 7	; Get upper nibble
	; Shift-right 4 times to rotate the nibble into place
	rrca				; 4
	rrca				; 4
	rrca				; 4
	rrca				; 4
	add	a,zDACDecodeTbl&0FFh	; 7	; Add in low byte of offset into decode table
	ld	l,a			; 4	; hl = pointer to nibble entry in JMan2050 table
	ld	a,(hl)			; 7	; a = JMan2050 entry for current nibble
	; After the following exx, we have:
	; bc' = size of sample, de' = location of sample, hl' = pointer to nibble entry in JMan2050 table,
	; c = pitch of sample, d = PCM accumulator,
	; e = command to select DAC output register, hl = pointer to DAC status
	exx				; 4
	add	a,d			; 4	; Add accumulator value...
	ld	d,a			; 4	; ... then store value back into accumulator
	ld	(hl),l			; 7	; Set flag to not accept driver input (l = FFh)
	ld	(ix+0),e		; 19	; Select DAC output register
	ld	(ix+1),d		; 19	; Send current data
	ld	(hl),h			; 7	; Set flag to accept driver input (h = 1Fh)

	ld	b,c			; 4	; b = sample pitch
	djnz	$			; 8	; Pitch loop

	; After the following exx, we have:
	; bc = size of sample, de = location of sample, hl = pointer to nibble entry in JMan2050 table,
	; c' = pitch of sample, d' = PCM accumulator,
	; e' = command to select DAC output register, hl' = pointer to DAC status
	exx				; 4
	ld	a,(de)			; 7	; a = byte from DAC sample
	and	0Fh			; 7	; Want only lower nibble now
	add	a,zDACDecodeTbl&0FFh	; 7	; Add in low byte of offset into decode table
	ld	l,a			; 4	; hl = pointer to nibble entry in JMan2050 table
	ld	a,(hl)			; 7	; a = JMan2050 entry for current nibble
	; After the following exx, we have:
	; bc' = size of sample, de' = location of sample, hl' = pointer to nibble entry in JMan2050 table,
	; c = pitch of sample, d = PCM accumulator,
	; e = command to select DAC output register, hl = pointer to DAC status
	exx				; 4
	add	a,d			; 4	; Add accumulator value...
	ld	d,a			; 4	; ... then store value back into accumulator
	ld	(hl),l			; 7	; Set flag to not accept driver input (l = FFh)
	ld	(ix+0),e		; 19	; Select DAC output register
	ld	(ix+1),d		; 19	; Send current data
	ld	(hl),h			; 7	; Set flag to accept driver input (h = 1Fh)

	ld	b,c			; 4	; b = sample pitch
	djnz	$			; 8	; Pitch loop

	; After the following exx, we have:
	; bc = size of sample, de = location of sample, hl = pointer to nibble entry in JMan2050 table,
	; c' = pitch of sample, d' = PCM accumulator,
	; e' = command to select DAC output register, hl' = pointer to DAC status
	exx				; 4
	ld	a,(zDAC_Sample)		; 13	; a = sample we're playing (minus 81h)
	bit	7,a			; 8	; Test bit 7 of register a
	jp	nz,zCheckForSamples	; 10	; If it is set, we need to get a new sample

	inc	de			; 6	; Point to next byte of DAC sample
	dec	bc			; 6	; Decrement remaining bytes on DAC sample
	ld	a,c			; 4	; a = low byte of remainig bytes
	or	b			; 4	; Are there any bytes left?
	jp	nz,zPlayPCMLoop		; 10	; If yes, keep playing sample
					; 301 in total
	jp	zCheckForSamples		; Sample is done; wait for new samples
;
; Subroutine - Play_SegaPCM
;
; This subroutine plays the "SEGA" sound.
;
zPlay_SegaPCM:
	ld	de,zmake68kPtr(SegaPCM)		; de = bank-relative location of the SEGA sound
	ld	hl,SegaPCM.size			; hl = size of the SEGA sound
	ld	c,2Ah				; c = Command to select DAC output register

zPlaySEGAPCMLoop:
	ld	a,(de)			; 7	; a = next byte from SEGA PCM
	ld	(ix+0),c		; 19	; Select DAC output register
	ld	(ix+1),a		; 19	; Send current data

	ld	b,pcmLoopCounter(16000)	; 7	; b = pitch of the SEGA sample
	djnz	$			; 8	; Pitch loop

	inc	de			; 6	; Point to next byte of DAC sample
	dec	hl			; 6	; Decrement remaining bytes on DAC sample
	ld	a,l			; 4	; a = low byte of remainig bytes
	or	h			; 4	; Are there any bytes left?
	jp	nz,zPlaySEGAPCMLoop	; 10	; If yes, keep playing sample
					; 90 in total
	jp	zCheckForSamples		; SEGA sound is done; wait for new samples


.ENDS ; End of section 'DAC Processing'



.SECTION "PCM Data"

; DPCM metadata
zPCM_Table:
	zPCMMetadata zDAC_Kick,zDAC_Kick_Size,8250
	zPCMMetadata zDAC_Snare,zDAC_Snare_Size,24000
; zTimpani_Pitch = $+4
	zPCMMetadata zDAC_Timpani,zDAC_Timpani_Size,7375

; DPCM data
zDAC_Kick:	.INCBIN "sound/dac/dpcm/kick.dpcm" FSIZE zDAC_Kick_Size
zDAC_Snare:	.INCBIN "sound/dac/dpcm/snare.dpcm" FSIZE zDAC_Snare_Size
zDAC_Timpani:	.INCBIN "sound/dac/dpcm/timpani.dpcm" FSIZE zDAC_Timpani_Size

.ENDS ; End of section 'PCM Data'

; 	if MOMPASS==2
; 		if $ > z80_stack
; 			fatal "The driver is too big; the maximum size it can take is \{z80_stack}h. It currently takes \{$}h bytes. You won't be able to use this thing."
; 		else
; 			message "Uncompressed driver size: \{$}h bytes."
; 		endif
; 	endif
