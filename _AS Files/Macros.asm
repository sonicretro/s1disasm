; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is (vdp_control_port).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport=(vdp_control_port).l
		move.l	#($40000000+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14)),controlport
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro source,destination
		lea	(vdp_control_port).l,a5
		move.l	#$94000000+((((source_end-source)>>1)&$FF00)<<8)+$9300+(((source_end-source)>>1)&$FF),(a5)
		move.l	#$96000000+(((source>>1)&$FF00)<<8)+$9500+((source>>1)&$FF),(a5)
		move.w	#$9700+((((source>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+((destination)&$3FFF),(a5)
		move.w	#$80+(((destination)&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro source,destination
		lea	(vdp_control_port).l,a5
		move.l	#$94000000+((((source_end-source)>>1)&$FF00)<<8)+$9300+(((source_end-source)>>1)&$FF),(a5)
		move.l	#$96000000+(((source>>1)&$FF00)<<8)+$9500+((source>>1)&$FF),(a5)
		move.w	#$9700+((((source>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+(destination&$3FFF),(a5)
		move.w	#$80+((destination&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro byte,start,end
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5) ; Set increment to 1, since DMA fill writes bytes
		move.l	#$94000000+((((end)-(start)-1)&$FF00)<<8)+$9300+(((end)-(start)-1)&$FF),(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080+(((start)&$3FFF)<<16)+(((start)&$C000)>>14),(a5)
		move.w	#(byte)|(byte)<<8,(vdp_data_port).l
.wait:		move.w	(a5),d1
		btst	#1,d1
		bne.s	.wait
		move.w	#$8F02,(a5) ; Set increment back to 2, since the VDP usually operates on words
		endm

; ---------------------------------------------------------------------------
; Fill portion of RAM with 0
; input: start, end
; ---------------------------------------------------------------------------

clearRAM:	macro startAddress,endAddress
	if "endAddress"<>""
		.length: := (endAddress)-(startAddress)
	else
		.length: := startAddress_end-startAddress
	endif
		lea	(startAddress).w,a1
		moveq	#0,d0
		move.w	#.length/4-1,d1

.loop:
		move.l	d0,(a1)+
		dbf	d1,.loop

	if (endAddress-startAddress)&2
		move.w	d0,(a1)+
	endif

	if (endAddress-startAddress)&1
		move.b	d0,(a1)+
	endif
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,destination,width,height
		lea	(source).l,a1
		locVRAM	destination,d0
		moveq	#(width)-1,d1
		moveq	#(height)-1,d2
		bsr.w	TilemapToVRAM
		endm

; ---------------------------------------------------------------------------
; stop the Z80
; ---------------------------------------------------------------------------

stopZ80:	macro
		move.w	#$100,(z80_bus_request).l
		endm

; ---------------------------------------------------------------------------
; wait for Z80 to stop
; ---------------------------------------------------------------------------

waitZ80:	macro
.wait:		btst	#0,(z80_bus_request).l
		bne.s	.wait
		endm

; ---------------------------------------------------------------------------
; reset the Z80
; ---------------------------------------------------------------------------

deassertZ80Reset:	macro
		move.w	#$100,(z80_reset).l
		endm

assertZ80Reset:	macro
		move.w	#0,(z80_reset).l
		endm

; ---------------------------------------------------------------------------
; start the Z80
; ---------------------------------------------------------------------------

startZ80:	macro
		move.w	#0,(z80_bus_request).l
		endm

; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macro
		move.w	#$2700,sr
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move.w	#$2300,sr
		endm

; ---------------------------------------------------------------------------
; disable display
; ---------------------------------------------------------------------------

disable_display:	macro
		move.w	(v_vdp_buffer1).w,d0		; get buffered copy of VDP register $81
		andi.b	#%10111111,d0			; clear bit 6 (disable display; fill with background color)
		move.w	d0,(vdp_control_port).l		; write to VDP
		endm

; ---------------------------------------------------------------------------
; enable display
; ---------------------------------------------------------------------------

enable_display:	macro
		move.w	(v_vdp_buffer1).w,d0		; get buffered copy of VDP register $81
		ori.b	#%01000000,d0			; set bit 6 (enable display)
		move.w	d0,(vdp_control_port).l		; write to VDP
		endm

; ---------------------------------------------------------------------------
; long conditional jumps
; ---------------------------------------------------------------------------

jhi:		macro loc
		bls.s	.nojump
		jmp	loc
.nojump:
		endm

jcc:		macro loc
		bcs.s	.nojump
		jmp	loc
.nojump:
		endm

jhs:		macro loc
		jcc	loc
		endm

jls:		macro loc
		bhi.s	.nojump
		jmp	loc
.nojump:
		endm

jcs:		macro loc
		bcc.s	.nojump
		jmp	loc
.nojump:
		endm

jlo:		macro loc
		jcs	loc
		endm

jeq:		macro loc
		bne.s	.nojump
		jmp	loc
.nojump:
		endm

jne:		macro loc
		beq.s	.nojump
		jmp	loc
.nojump:
		endm

jgt:		macro loc
		ble.s	.nojump
		jmp	loc
.nojump:
		endm

jge:		macro loc
		blt.s	.nojump
		jmp	loc
.nojump:
		endm

jle:		macro loc
		bgt.s	.nojump
		jmp	loc
.nojump:
		endm

jlt:		macro loc
		bge.s	.nojump
		jmp	loc
.nojump:
		endm

jpl:		macro loc
		bmi.s	.nojump
		jmp	loc
.nojump:
		endm

jmi:		macro loc
		bpl.s	.nojump
		jmp	loc
.nojump:
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
	if ("pos"<>"")
		move.w	pos,d0		; get object position (if specified as not obX)
	else
		move.w	obX(a0),d0	; get object position
	endif
		andi.w	#$FF80,d0	; round down to nearest $80
		move.w	(v_screenposx).w,d1 ; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0		; approx distance between object and screen
		cmpi.w	#128+320+192,d0
		bhi.ATTRIBUTE	exit
		endm

; ---------------------------------------------------------------------------
; bankswitch between SRAM and ROM
; (remember to enable SRAM in the header first!)
; ---------------------------------------------------------------------------

gotoSRAM:	macro
		move.b	#1,(sram_port).l
		endm

gotoROM:	macro
		move.b	#0,(sram_port).l
		endm

; ---------------------------------------------------------------------------
; compare the size of an index with ZoneCount constant
; (should be used immediately after the index)
; input: index address, element size
; ---------------------------------------------------------------------------

zonewarning:	macro loc,elementsize
    if (MOMPASS=1)
._end:
	if (._end-loc)-(ZoneCount*elementsize)<>0
		warning "Size of loc (\{(._end-loc)/elementsize}) does not match ZoneCount (\{ZoneCount})."
	endif
    endif
		endm

; ---------------------------------------------------------------------------
; produce a packed art-tile
; ---------------------------------------------------------------------------

make_art_tile function addr,pal,pri,((pri&1)<<15)|((pal&3)<<13)|addr

; ---------------------------------------------------------------------------
; incbin compatibility macro for AS
; ---------------------------------------------------------------------------

incbin:		macro path
		binclude path
		endm

; ---------------------------------------------------------------------------
; Macro to binclude something with an end marker
; ---------------------------------------------------------------------------

bincludeEndMarker macro path,{INTLABEL},{GLOBALSYMBOLS}
__LABEL__:	binclude	path
__LABEL___end:
	endm
