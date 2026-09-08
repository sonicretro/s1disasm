; ===========================================================================
; ---------------------------------------------------------------------------
; Nemesis decompression subroutine, decompresses art directly to VRAM
; 
; inputs:
; 	a0 = art address
; 
; For format explanation see http://info.sonicretro.org/Nemesis_compression
; ---------------------------------------------------------------------------

NemDec:
		movem.l	d0-a1/a3-a5,-(sp)
		lea	(NemPCD_WriteRowToVDP).l,a3		; write all data to the same location
		lea	(vdp_data_port).l,a4			; specifically, to the VDP data port
		bra.s	NemDecMain
; ===========================================================================

; ---------------------------------------------------------------------------
; Nemesis decompression subroutine, decompresses art to RAM
; 
; input:
; 	a0 = art address
; 	a4 = destination RAM address
; ---------------------------------------------------------------------------

NemDecToRAM:
		movem.l	d0-a1/a3-a5,-(sp)
		lea	(NemPCD_WriteRowToRAM).l,a3		; advance to the next location after each write
; ---------------------------------------------------------------------------

NemDecMain:
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2				; get number of patterns
		lsl.w	#1,d2
		bcc.s	NemDecM_ModeNoXOR			; branch if the sign bit isn't set
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3 ; otherwise the file uses XOR mode

NemDecM_ModeNoXOR:
		lsl.w	#2,d2					; get number of 8-pixel rows in the uncompressed data
		movea.w	d2,a5					; and store it in a5 because there aren't any spare data registers
		moveq	#8,d3					; 8 pixels in a pattern row
		moveq	#0,d2
		moveq	#0,d4
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5				; get first byte of compressed data
		asl.w	#8,d5					; shift up by a byte
		move.b	(a0)+,d5				; get second byte of compressed data
		move.w	#$10,d6					; set initial shift value
		bsr.s	NemDec_ProcessCompressedData
		movem.l	(sp)+,d0-a1/a3-a5
		rts
; End of function NemDec

; ===========================================================================
; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, processes the actual compressed data
; ---------------------------------------------------------------------------

NemDec_ProcessCompressedData:
		move.w	d6,d7
		subq.w	#8,d7					; get shift value
		move.w	d5,d1
		lsr.w	d7,d1					; shift so that high bit of the code is in bit position 7
		cmpi.b	#%11111100,d1				; are the high 6 bits set?
		bhs.s	NemPCD_InlineData			; if they are, it signifies inline data
		andi.w	#$FF,d1
		add.w	d1,d1
		move.b	(a1,d1.w),d0				; get the length of the code in bits
		ext.w	d0
		sub.w	d0,d6					; subtract from shift value so that the next code is read next time around
		cmpi.w	#9,d6					; does a new byte need to be read?
		bhs.s	NemPCD_NoLoadField01			; if not, branch
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5				; read next byte

NemPCD_NoLoadField01:
		move.b	1(a1,d1.w),d1
		move.w	d1,d0
		andi.w	#$F,d1					; get palette index for pixel
		andi.w	#$F0,d0

NemPCD_ProcessCompressedData:
		lsr.w	#4,d0					; get repeat count

NemPCD_WritePixel:
		lsl.l	#4,d4					; shift up by a nybble
		or.b	d1,d4					; write pixel
		subq.w	#1,d3					; has an entire 8-pixel row been written?
		bne.s	NemPCD_WritePixel_Loop			; if not, loop

		; This is a dynamic jump to NemPCD_WriteRowToVDP, NemDec_WriteAndAdvance,
		; NemPCD_WriteRowToVDP_XOR, or NemDec_WriteAndAdvance_XOR
		jmp	(a3)					; write the row to its destination
; End of function NemDec_ProcessCompressedData
; ===========================================================================

NemPCD_NewRow:
		moveq	#0,d4					; reset row
		moveq	#8,d3					; reset nybble counter

NemPCD_WritePixel_Loop:
		dbf	d0,NemPCD_WritePixel
		bra.s	NemDec_ProcessCompressedData
; ===========================================================================

NemPCD_InlineData:
		subq.w	#6,d6					; 6 bits needed to signal inline data
		cmpi.w	#9,d6
		bhs.s	NemPCD_NoLoadField02
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

NemPCD_NoLoadField02:
		subq.w	#7,d6					; and 7 bits needed for the inline data itself
		move.w	d5,d1
		lsr.w	d6,d1					; shift so that low bit of the code is in bit position 0
		move.w	d1,d0
		andi.w	#$F,d1					; get palette index for pixel
		andi.w	#$70,d0					; high nybble is repeat count for pixel
		cmpi.w	#9,d6
		bhs.s	NemPCD_ProcessCompressedData
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5
		bra.s	NemPCD_ProcessCompressedData
; End of function NemPCD_NewRow
; ===========================================================================

NemPCD_WriteRowToVDP:
		move.l	d4,(a4)					; write 8-pixel row
		subq.w	#1,a5
		move.w	a5,d4					; have all the 8-pixel rows been written?
		bne.s	NemPCD_NewRow				; if not, branch
		rts						; otherwise the decompression is finished
; ===========================================================================

NemPCD_WriteRowToVDP_XOR:
		eor.l	d4,d2					; XOR the previous row by the current row
		move.l	d2,(a4)					; and write the result
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemPCD_NewRow
		rts
; ===========================================================================

NemPCD_WriteRowToRAM:
		move.l	d4,(a4)+
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemPCD_NewRow
		rts
; ===========================================================================

NemPCD_WriteRowToRAM_XOR:
		eor.l	d4,d2
		move.l	d2,(a4)+
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemPCD_NewRow
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, builds the code table (in RAM)
; ---------------------------------------------------------------------------


NemDec_BuildCodeTable:
		move.b	(a0)+,d0				; read first byte

NemBCT_ChkEnd:
		cmpi.b	#$FF,d0					; has the end of the code table description been reached?
		bne.s	NemBCT_NewPALIndex			; if not, branch
		rts						; otherwise, this subroutine's work is done
; ===========================================================================

NemBCT_NewPALIndex:
		move.w	d0,d7

NemBCT_Loop:
		move.b	(a0)+,d0				; read next byte
		cmpi.b	#$80,d0					; sign bit being set signifies a new palette index
		bhs.s	NemBCT_ChkEnd				; a bmi could have been used instead of a compare and bcc

		move.b	d0,d1
		andi.w	#$F,d7					; get palette index
		andi.w	#$70,d1					; get repeat count for palette index
		or.w	d1,d7					; combine the two
		andi.w	#$F,d0					; get the length of the code in bits
		move.b	d0,d1
		lsl.w	#8,d1
		or.w	d1,d7					; combine with palette index and repeat count to form code table entry
		moveq	#8,d1
		sub.w	d0,d1					; is the code 8 bits long?
		bne.s	NemBCT_ShortCode			; if not, a bit of extra processing is needed
		move.b	(a0)+,d0				; get code
		add.w	d0,d0					; each code gets a word-sized entry in the table
		move.w	d7,(a1,d0.w)				; store the entry for the code
		bra.s	NemBCT_Loop				; repeat
; ===========================================================================

; the Nemesis decompressor uses prefix-free codes (no valid code is a prefix of a longer code)
; e.g. if 10 is a valid 2-bit code, 110 is a valid 3-bit code but 100 isn't
; also, when the actual compressed data is processed the high bit of each code is in bit position 7
; so the code needs to be bit-shifted appropriately over here before being used as a code table index
; additionally, the code needs multiple entries in the table because no masking is done during compressed data processing
; so if 11000 is a valid code then all indices of the form 11000XXX need to have the same entry
NemBCT_ShortCode:
		move.b	(a0)+,d0				; get code
		lsl.w	d1,d0					; get index into code table
		add.w	d0,d0					; shift so that high bit is in bit position 7
		moveq	#1,d5
		lsl.w	d1,d5
		subq.w	#1,d5					; d5 = 2^d1 - 1

NemBCT_ShortCode_Loop:
		move.w	d7,(a1,d0.w)				; store entry
		addq.w	#2,d0					; increment index
		dbf	d5,NemBCT_ShortCode_Loop		; repeat for required number of entries
		bra.s	NemBCT_Loop
; End of function NemDec_BuildCodeTable

; ===========================================================================
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
		movem.l	a1-a2,-(sp)				; store register data
		lea	(ArtLoadCues).l,a1			; load PLC list address
		add.w	d0,d0					; double for word-based indexing
		move.w	(a1,d0.w),d0				; load correct relative add address
		lea	(a1,d0.w),a1				; add and load actual address of list
		lea	(v_plc_buffer).w,a2			; load PLC process list

.findspace:
		tst.l	(a2)					; is this slot taken?
		beq.s	.copytoRAM				; if not, branch
		addq.w	#plc_slot_size,a2			; advance to next slot
		bra.s	.findspace				; recheck
; ===========================================================================

.copytoRAM:
		move.w	(a1)+,d0				; load size of list
		bmi.s	.return					; if there is no list, branch

.loop:
		move.l	(a1)+,(a2)+				; copy Nemesis art address
		move.w	(a1)+,(a2)+				; copy VRAM location to dump to
		dbf	d0,.loop				; repeat for all entries

.return:
		movem.l	(sp)+,a1-a2				; restore register data
		rts						; return
; End of function AddPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Identical to AddPLC, but also stops the current PLC process, and loads
; a brand new queue. (The same 16th entry warning as above applies!)
; ---------------------------------------------------------------------------

; LoadPLC2:
NewPLC:
		movem.l	a1-a2,-(sp)				; store register data
		lea	(ArtLoadCues).l,a1			; load PLC list address
		add.w	d0,d0					; double for word-based indexing
		move.w	(a1,d0.w),d0				; load correct relative add address
		lea	(a1,d0.w),a1				; add and load actual address of list
		bsr.s	ClearPLC				; clear the current PLC entries first
		lea	(v_plc_buffer).w,a2			; load PLC process list
		move.w	(a1)+,d0				; load size of list
		bmi.s	.return					; if there is no list, branch

.loop:
		move.l	(a1)+,(a2)+				; copy Nemesis art address
		move.w	(a1)+,(a2)+				; copy VRAM location to dump to
		dbf	d0,.loop				; repeat for all entries

.return:
		movem.l	(sp)+,a1-a2				; restore register data
		rts						; return
; End of function NewPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to clear the pattern load cues
; Clear the pattern load queue ($FFF680 - $FFF700)
; ---------------------------------------------------------------------------

ClearPLC:
		lea	(v_plc_buffer).w,a2			; load PLC process list
		moveq	#(v_plc_buffer_end-v_plc_buffer)/4-1,d0	; set size of list

.loop:
		clr.l	(a2)+					; clear PLC process list
		dbf	d0,.loop				; repeat until entire list is cleared
		rts						; return
; End of function ClearPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	check the PLC buffer and begin decompression if it contains
; anything. ProcessPLC handles the actual decompression during VBlank
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(v_plc_buffer).w			; are there any PLC entries left to process?
		beq.s	.return					; if not, branch
		tst.w	(v_plc_patternsleft).w			; is a section counter already set (is art already being decompressed)?
		bne.s	.return					; if so, branch

		movea.l	(v_plc_buffer).w,a0			; load address of first entry's art
		lea	(NemPCD_WriteRowToVDP).l,a3		; load address of dumping routine to use (VDP variant)
		lea	(v_ngfx_buffer).w,a1			; load RLE huffman buffer
		move.w	(a0)+,d2				; load number of sections to decompress (Each section is $20 bytes)
		bpl.s	.skipXor				; if this data doesn't use XOR variant, branch
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3 ; advance to XOR variant
; loc_160E:
.skipXor:
		andi.w	#$7FFF,d2				; clear XOR flag

	if FixBugs=0
		; Relocated to bugfix below
		move.w	d2,(v_plc_patternsleft).w		; save section counter
	endif
		bsr.w	NemDec_BuildCodeTable			; decompress the huffman tree RLE table
		move.b	(a0)+,d5				; load lookup field
		asl.w	#8,d5					; ''
		move.b	(a0)+,d5				; ''
		moveq	#$10,d6					; prepare bit shift counter (shifting up to a word in size)
		moveq	#0,d0					; clear d0
		move.l	a0,(v_plc_buffer).w			; store current entry address
		move.l	a3,(v_plc_ptrnemcode).w			; store dumping routine (XOR/Non-XOR)
		move.l	d0,(v_plc_repeatcount).w		; clear RLE dump counter
		move.l	d0,(v_plc_paletteindex).w		; clear RLE dump nybble
		move.l	d0,(v_plc_previousrow).w		; clear previous XOR dump
		move.l	d5,(v_plc_dataword).w			; store lookup field
		move.l	d6,(v_plc_shiftvalue).w			; store bit shift counter
	if FixBugs
		; Fix a race condition with Pattern Load Cues
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_race_condition_with_Pattern_Load_Cues
		move.w	d2,(v_plc_patternsleft).w		; save section counter
	endif

.return:
		rts						; return
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
		tst.w	(v_plc_patternsleft).w			; is a section counter set (is art being decompressed)?
		beq.w	ProcessPLC_Return			; if not, branch (nothing to decompress)

		move.w	#9,(v_plc_framepatternsleft).w		; set tile counter to 9 (number of tiles to decompress in a frame)
		moveq	#0,d0					; clear d0
		move.w	(v_plc_buffer_dest).w,d0		; load VRAM address for this frame
		addi.w	#9*tile_size,(v_plc_buffer_dest).w	; increase address for next frame
		bra.s	ProcessPLC				; continue
; ===========================================================================

; sub_165E: ProcessDPLC2: ProcessPLC_3Tiles:
ProcessPLC_3Tiles:
		tst.w	(v_plc_patternsleft).w			; is a section counter set (is art being decompressed)?
		beq.s	ProcessPLC_Return			; if not, branch (nothing to decompress)

		move.w	#3,(v_plc_framepatternsleft).w		; set tile counter to 3 (number of tiles to decompress in a frame)
		moveq	#0,d0					; clear d0
		move.w	(v_plc_buffer_dest).w,d0		; load VRAM address for this frame
		addi.w	#3*tile_size,(v_plc_buffer_dest).w	; increase address for next frame
		; fall-through to ProcessPLC...
; ---------------------------------------------------------------------------

; loc_1676: ProcessPLC:
ProcessPLC:
		lea	(vdp_control_port).l,a4			; load VDP control port address
		lsl.l	#2,d0					; get address MSB bits and send to LSB of long-word
		lsr.w	#2,d0					; send rest back
		ori.w	#$4000,d0				; set mode bits
		swap	d0					; align for VDP port
		move.l	d0,(a4)					; set VDP address/mode
		subq.w	#4,a4					; move a4 down to VDP data port
		movea.l	(v_plc_buffer).w,a0			; load current entry address
		movea.l	(v_plc_ptrnemcode).w,a3			; load dumping routine to use (XOR/Non-XOR)
		move.l	(v_plc_repeatcount).w,d0		; load RLE dump counter
		move.l	(v_plc_paletteindex).w,d1		; load RLE dump nybble
		move.l	(v_plc_previousrow).w,d2		; load previous XOR dump
		move.l	(v_plc_dataword).w,d5			; load lookup field
		move.l	(v_plc_shiftvalue).w,d6			; load bit shift counter
		lea	(v_ngfx_buffer).w,a1			; load RLE huffman buffer

; loc_16AA:
.loop:
		movea.w	#8,a5					; set size of data to decompress (20 bytes, 1 tile)
		bsr.w	NemPCD_NewRow				; continue the decompression
		subq.w	#1,(v_plc_patternsleft).w		; decrease section count by 1
		beq.s	ProcessPLC_ShiftCue			; if decompression is finished, branch
		subq.w	#1,(v_plc_framepatternsleft).w		; decrease tile counter
		bne.s	.loop					; if still running, branch to decompress another tile

		move.l	a0,(v_plc_buffer).w			; store current entry address
		move.l	a3,(v_plc_ptrnemcode).w			; store dumping routine to use (XOR/Non-XOR)
		move.l	d0,(v_plc_repeatcount).w		; store RLE dump counter
		move.l	d1,(v_plc_paletteindex).w		; store RLE dump nybble
		move.l	d2,(v_plc_previousrow).w		; store previous XOR dump
		move.l	d5,(v_plc_dataword).w			; store lookup field
		move.l	d6,(v_plc_shiftvalue).w			; store bit shift counter

ProcessPLC_Return:
		rts						; return
; ===========================================================================

; loc_16DC:
ProcessPLC_ShiftCue:
		lea	(v_plc_buffer).w,a0			; load PLC process list
		moveq	#(v_plc_buffer_only_end-v_plc_buffer-plc_slot_size)/4-1,d0 ; set size of list

; loc_16E2:
.loop:
		move.l	plc_slot_size(a0),(a0)+			; shift contents of PLC buffer up 6 bytes
		dbf	d0,.loop				; repeat til done

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

		rts						; return
; End of function ProcessPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Like AddPLC, but instead of adding entries to a queue to be processed later,
; this will decompress and transfer all entries of the given PLC ID's list
; immediately, blocking until it is done. Does not use or affect the queue.
; ---------------------------------------------------------------------------

QuickPLC:
		lea	(ArtLoadCues).l,a1			; load PLC list address
		add.w	d0,d0					; double for word-based indexing
		move.w	(a1,d0.w),d0				; load correct relative add address
		lea	(a1,d0.w),a1				; add and load actual address of list
		move.w	(a1)+,d1				; load size of list

.loop:
		movea.l	(a1)+,a0				; load Nemesis art address
		moveq	#0,d0					; clear d0
		move.w	(a1)+,d0				; load VRAM dump address
		lsl.l	#2,d0					; get address MSB bits and send to LSB of long-word
		lsr.w	#2,d0					; send rest back
		ori.w	#$4000,d0				; set mode bits
		swap	d0					; align for VDP port
		move.l	d0,(vdp_control_port).l			; set VDP address/mode
		bsr.w	NemDec					; decompress the entire entry
		dbf	d1,.loop				; repeat for all entries in the list
		rts						; return
; End of function QuickPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Enigma decompression algorithm
; 
; input:
;	d0 = starting art tile (added to each 8x8 before writing to destination)
;	a0 = source address
;	a1 = destination address
; 
; usage:
;	lea	(source).l,a0
;	lea	(destination).l,a1
;	move.w	#arttile,d0
;	bsr.w	EniDec
; 
; See http://www.segaretro.org/Enigma_compression for format description
; ---------------------------------------------------------------------------

EniDec:
		movem.l	d0-d7/a1-a5,-(sp)
		movea.w	d0,a3					; store starting art tile
		move.b	(a0)+,d0
		ext.w	d0
		movea.w	d0,a5					; store number of bits in inline copy value
		move.b	(a0)+,d4
		lsl.b	#3,d4					; store PCCVH flags bitfield
		movea.w	(a0)+,a2
		adda.w	a3,a2					; store incremental copy word
		movea.w	(a0)+,a4
		adda.w	a3,a4					; store literal copy word
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5				; get first word in format list
		moveq	#16,d6					; initial shift value
; loc_173E:
Eni_Loop:
		moveq	#7,d0					; assume a format list entry is 7 bits
		move.w	d6,d7
		sub.w	d0,d7
		move.w	d5,d1
		lsr.w	d7,d1
		andi.w	#$7F,d1					; get format list entry
		move.w	d1,d2					; and copy it
		cmpi.w	#$40,d1					; is the high bit of the entry set?
		bhs.s	.sevenbitentry
		moveq	#6,d0					; if it isn't, the entry is actually 6 bits
		lsr.w	#1,d2
; loc_1758:
.sevenbitentry:
		bsr.w	EniDec_FetchByte
		andi.w	#$F,d2					; get repeat count
		lsr.w	#4,d1
		add.w	d1,d1
		jmp	EniDec_Index(pc,d1.w)
; End of function EniDec

; ===========================================================================
; loc_1768:
EniDec_00:
.loop:		move.w	a2,(a1)+				; copy incremental copy word
		addq.w	#1,a2					; increment it
		dbf	d2,.loop				; repeat
		bra.s	Eni_Loop
; ===========================================================================
; loc_1772:
EniDec_01:
.loop:		move.w	a4,(a1)+				; copy literal copy word
		dbf	d2,.loop				; repeat
		bra.s	Eni_Loop
; ===========================================================================
; loc_177A:
EniDec_100:
		bsr.w	EniDec_FetchInlineValue
; loc_177E:
.loop:		move.w	d1,(a1)+				; copy inline value
		dbf	d2,.loop				; repeat

		bra.s	Eni_Loop
; ===========================================================================
; loc_1786:
EniDec_101:
		bsr.w	EniDec_FetchInlineValue
; loc_178A:
.loop:		move.w	d1,(a1)+				; copy inline value
		addq.w	#1,d1					; increment
		dbf	d2,.loop				; repeat

		bra.s	Eni_Loop
; ===========================================================================
; loc_1794:
EniDec_110:
		bsr.w	EniDec_FetchInlineValue
; loc_1798:
.loop:		move.w	d1,(a1)+				; copy inline value
		subq.w	#1,d1					; decrement
		dbf	d2,.loop				; repeat

		bra.s	Eni_Loop
; ===========================================================================
; loc_17A2:
EniDec_111:
		cmpi.w	#$F,d2
		beq.s	EniDec_Done
; loc_17A8:
.loop:		bsr.w	EniDec_FetchInlineValue			; fetch new inline value
		move.w	d1,(a1)+				; copy it
		dbf	d2,.loop				; and repeat

		bra.s	Eni_Loop
; ===========================================================================
; loc_17B4:
EniDec_Index:
		bra.s	EniDec_00
		bra.s	EniDec_00
		bra.s	EniDec_01
		bra.s	EniDec_01
		bra.s	EniDec_100
		bra.s	EniDec_101
		bra.s	EniDec_110
		bra.s	EniDec_111
; ===========================================================================
; loc_17C4:
EniDec_Done:
		subq.w	#1,a0					; go back by one byte
		cmpi.w	#16,d6					; were we going to start on a completely new byte?
		bne.s	.notnewbyte				; if not, branch
		subq.w	#1,a0					; and another one if needed
; loc_17CE:
.notnewbyte:
		move.w	a0,d0
		lsr.w	#1,d0					; are we on an odd byte?
		bcc.s	.evenbyte				; if not, branch
		addq.w	#1,a0					; ensure we're on an even byte
; loc_17D6:
.evenbyte:
		movem.l	(sp)+,d0-d7/a1-a5
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Part of the Enigma decompressor
; Fetches an inline copy value and stores it in d1
; ---------------------------------------------------------------------------

; loc_17DC:
EniDec_FetchInlineValue:
		move.w	a3,d3					; copy starting art tile
		move.b	d4,d1					; copy PCCVH bitfield
		add.b	d1,d1					; is the priority bit set?
		bcc.s	.skippriority				; if not, branch
		subq.w	#1,d6
		btst	d6,d5					; is the priority bit set in the inline render flags?
		beq.s	.skippriority				; if not, branch
		ori.w	#$8000,d3				; otherwise set priority bit in art tile
; loc_17EE:
.skippriority:
		add.b	d1,d1					; is the high palette line bit set?
		bcc.s	.skiphighpal				; if not, branch
		subq.w	#1,d6
		btst	d6,d5
		beq.s	.skiphighpal
		addi.w	#$4000,d3				; set second palette line bit
; loc_17FC:
.skiphighpal:
		add.b	d1,d1					; is the low palette line bit set?
		bcc.s	.skiplowpal				; if not, branch
		subq.w	#1,d6
		btst	d6,d5
		beq.s	.skiplowpal
		addi.w	#$2000,d3				; set first palette line bit
; loc_180A:
.skiplowpal:
		add.b	d1,d1					; is the vertical flip flag set?
		bcc.s	.skipyflip				; if not, branch
		subq.w	#1,d6
		btst	d6,d5
		beq.s	.skipyflip
		ori.w	#$1000,d3				; set Y-flip bit
; loc_1818:
.skipyflip:
		add.b	d1,d1					; is the horizontal flip flag set?
		bcc.s	.skipxflip				; if not, branch
		subq.w	#1,d6
		btst	d6,d5
		beq.s	.skipxflip
		ori.w	#$800,d3				; set X-flip bit
; loc_1826:
.skipxflip:
		move.w	d5,d1
		move.w	d6,d7
		sub.w	a5,d7					; subtract length in bits of inline copy value
		bcc.s	.enoughbits				; branch if a new word doesn't need to be read
		move.w	d7,d6
		addi.w	#16,d6
		neg.w	d7					; calculate bit deficit
		lsl.w	d7,d1					; and make space for that many bits
		move.b	(a0),d5					; get next byte
		rol.b	d7,d5					; and rotate the required bits into the lowest positions
		add.w	d7,d7
		and.w	EniDec_Masks-2(pc,d7.w),d5
		add.w	d5,d1					; combine upper bits with lower bits
; loc_1844:
.maskvalue:
		move.w	a5,d0					; get length in bits of inline copy value
		add.w	d0,d0
		and.w	EniDec_Masks-2(pc,d0.w),d1		; mask value appropriately
		add.w	d3,d1					; add starting art tile
		move.b	(a0)+,d5
		lsl.w	#8,d5
		move.b	(a0)+,d5				; get next word
		rts
; ===========================================================================
; loc_1856:
.enoughbits:
		beq.s	.justenough				; if the word has been exactly exhausted, branch
		lsr.w	d7,d1					; get inline copy value
		move.w	a5,d0
		add.w	d0,d0
		and.w	EniDec_Masks-2(pc,d0.w),d1		; and mask it appropriately
		add.w	d3,d1					; add starting art tile
		move.w	a5,d0
		bra.s	EniDec_FetchByte
; ===========================================================================
; loc_1868:
.justenough:
		moveq	#16,d6					; reset shift value
		bra.s	.maskvalue
; ===========================================================================
; word_186C:
EniDec_Masks:
		dc.w	 1,    3,    7,   $F
		dc.w   $1F,  $3F,  $7F,  $FF
		dc.w  $1FF, $3FF, $7FF, $FFF
		dc.w $1FFF,$3FFF,$7FFF,$FFFF
; ===========================================================================

; sub_188C:
EniDec_FetchByte:
		sub.w	d0,d6					; subtract length of current entry from shift value so that next entry is read next time around
		cmpi.w	#9,d6					; does a new byte need to be read?
		bhs.s	.locret					; if not, branch
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5
.locret:
		rts
; End of function EniDec_FetchByte

; ===========================================================================
; ---------------------------------------------------------------------------
; Kosinski decompression algorithm
; 
; input:
;	a0 = source address
;	a1 = destination address
; 
; usage:
;	lea	(source).l,a0
;	lea	(destination).l,a1
;	bsr.w	KosDec
; ---------------------------------------------------------------------------

KosDec:
		subq.l	#2,sp					; make space for 2 bytes on the stack
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5					; get first description field
		moveq	#$F,d4					; set to loop for 16 bits

Kos_Loop:
		lsr.w	#1,d5					; shift bit into the c flag
		move.w	sr,d6
		dbf	d4,.chkbit
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

.chkbit:
		move.w	d6,ccr					; was the bit set?
		bcc.s	Kos_RLE					; if not, branch

		move.b	(a0)+,(a1)+				; copy byte as-is
		bra.s	Kos_Loop
; ===========================================================================

Kos_RLE:
		moveq	#0,d3
		lsr.w	#1,d5					; get next bit
		move.w	sr,d6
		dbf	d4,.chkbit
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

.chkbit:
		move.w	d6,ccr					; was the bit set?
		bcs.s	Kos_SeparateRLE				; if yes, branch

		lsr.w	#1,d5					; shift bit into the x flag
		dbf	d4,.loop1
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

.loop1:
		roxl.w	#1,d3					; get high repeat count bit
		lsr.w	#1,d5
		dbf	d4,.loop2
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

.loop2:
		roxl.w	#1,d3					; get low repeat count bit
		addq.w	#1,d3					; increment repeat count
		moveq	#-1,d2
		move.b	(a0)+,d2				; calculate offset
		bra.s	Kos_RLELoop
; ===========================================================================

Kos_SeparateRLE:
		move.b	(a0)+,d0				; get first byte
		move.b	(a0)+,d1				; get second byte
		moveq	#-1,d2
		move.b	d1,d2
		lsl.w	#5,d2
		move.b	d0,d2					; calculate offset
		andi.w	#7,d1					; does a third byte need to be read?
		beq.s	Kos_SeparateRLE2			; if yes, branch
		move.b	d1,d3					; copy repeat count
		addq.w	#1,d3					; increment

Kos_RLELoop:
		move.b	(a1,d2.w),d0				; copy appropriate byte
		move.b	d0,(a1)+				; repeat
		dbf	d3,Kos_RLELoop
		bra.s	Kos_Loop
; ===========================================================================

Kos_SeparateRLE2:
		move.b	(a0)+,d1
		beq.s	Kos_Done				; 0 indicates end of compressed data
		cmpi.b	#1,d1
		beq.w	Kos_Loop				; 1 indicates new description to be read
		move.b	d1,d3					; otherwise, copy repeat count
		bra.s	Kos_RLELoop
; ===========================================================================

Kos_Done:
		addq.l	#2,sp					; restore stack pointer
		rts
; End of function KosDec
