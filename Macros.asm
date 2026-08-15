; ===========================================================================
; ---------------------------------------------------------------------------
; Macros (game-specific)
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Align and pad
; input: length to align to, value to use as padding (default is $FF)
; ---------------------------------------------------------------------------

align:	macro
	if (narg=1)
	dcb.b (\1-(*%\1))%\1,$FF
	else
	dcb.b (\1-(*%\1))%\1,\2
	endif
	endm

; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($40000000+(((\loc)&$3FFF)<<16)+(((\loc)&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($40000000+(((\loc)&$3FFF)<<16)+(((\loc)&$C000)>>14)),\controlport
		endif
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro source,destination
		lea	(vdp_control_port).l,a5
		move.l	#vreg_dmalen|((((\source\_end-\source)>>1)&$FF00)<<8)|(((\source\_end-\source)>>1)&$FF),(a5)
		move.l	#vreg_dmasrc|((((\source)>>1)&$FF00)<<8)|(((\source)>>1)&$FF),(a5)
		move.w	#vreg_dmamode|(((((\source)>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+((\destination)&$3FFF),(a5)
		move.w	#$80+(((\destination)&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro source,destination
		lea	(vdp_control_port).l,a5
		move.l	#vreg_dmalen|((((\source\_end-\source)>>1)&$FF00)<<8)|(((\source\_end-\source)>>1)&$FF),(a5)
		move.l	#vreg_dmasrc|((((\source)>>1)&$FF00)<<8)|(((\source)>>1)&$FF),(a5)
		move.w	#vreg_dmamode|(((((\source)>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+((\destination)&$3FFF),(a5)
		move.w	#$80+(((\destination)&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro byte,start,end
		lea	(vdp_control_port).l,a5
		move.w	#vreg_autoinc|1,(a5) ; Set increment to 1, since DMA fill writes bytes
		move.l	#vreg_dmalen|((((\end)-(\start)-1)&$FF00)<<8)|(((\end)-(\start)-1)&$FF),(a5)
		move.w	#vreg_dmamode|%10<<6,(a5)
		move.l	#$40000080+(((\start)&$3FFF)<<16)+(((\start)&$C000)>>14),(a5)
		move.w	#(\byte)|(\byte)<<8,(vdp_data_port).l
.wait\@:	move.w	(a5),d1
		btst	#1,d1
		bne.s	.wait\@
		move.w	#vreg_autoinc|2,(a5) ; Set increment back to 2, since the VDP usually operates on words
		endm

; ---------------------------------------------------------------------------
; Fill portion of RAM with 0
; input: start, end
; ---------------------------------------------------------------------------

clearRAM:	macro startAddress,endAddress
	if narg=2
		.length\@: equ (\endAddress)-(\startAddress)
	else
		.length\@: equ \startAddress\_end-\startAddress
	endif
		lea	(\startAddress).w,a1
		moveq	#0,d0
		move.w	#.length\@/4-1,d1

.loop\@:
		move.l	d0,(a1)+
		dbf	d1,.loop\@

	if (\endAddress-\startAddress)&2
		move.w	d0,(a1)+
	endif

	if (\endAddress-\startAddress)&1
		move.b	d0,(a1)+
	endif
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,destination,width,height
		lea	(\source).l,a1
		locVRAM	\destination,d0
		moveq	#(\width)-1,d1
		moveq	#(\height)-1,d2
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
.wait\@:	btst	#0,(z80_bus_request).l
		bne.s	.wait\@
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
		move.w	#$2700,sr				; disable interrupts
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move.w	#$2300,sr				; enable interrupts
		endm

; ---------------------------------------------------------------------------
; disable display
; ---------------------------------------------------------------------------

disable_display:	macro
		move.w	(v_vdp_buffer1).w,d0			; get buffered copy of vreg_mode2
		andi.b	#%10111111,d0				; clear bit 6 (disable display; fill with background color)
		move.w	d0,(vdp_control_port).l			; write to VDP
		endm

; ---------------------------------------------------------------------------
; enable display
; ---------------------------------------------------------------------------

enable_display:	macro
		move.w	(v_vdp_buffer1).w,d0			; get buffered copy of vreg_mode2
		ori.b	#%01000000,d0				; set bit 6 (enable display)
		move.w	d0,(vdp_control_port).l			; write to VDP
		endm

; ---------------------------------------------------------------------------
; long conditional jumps
; ---------------------------------------------------------------------------

jhi:		macro loc
		bls.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jls:		macro loc
		bhi.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jcc:		macro loc
		bcs.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jhs:		macro loc
		jcc	\loc
		endm

jcs:		macro loc
		bcc.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jlo:		macro loc
		jcs	\loc
		endm

jne:		macro loc
		beq.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jeq:		macro loc
		bne.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jvc:		macro loc
		bvs.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jvs:		macro loc
		bvc.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jpl:		macro loc
		bmi.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jmi:		macro loc
		bpl.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jge:		macro loc
		blt.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jlt:		macro loc
		bge.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jgt:		macro loc
		ble.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

jle:		macro loc
		bgt.s	.nojump\@
		jmp	loc
	.nojump\@:
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default), optional bmi exit
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos,bmicheck
	if (narg>=2)
		move.w	pos,d0		; get object position (if specified as not obX)
	else
		move.w	obX(a0),d0	; get object position
	endif
		andi.w	#$FF80,d0	; round down to nearest $80
		move.w	(v_screenposx).w,d1 ; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0		; approx distance between object and screen
	if (narg=3)
		; This bmi is in a few out_of_range calls (albeit redundant)
		bmi.\0	exit
	endif
		cmpi.w	#128+320+192,d0
		bhi.\0	exit
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
; macro to simplify editing the demo scripts
; (taken from the Sonic 2 disassembly, adapted for ASM68K)
; ---------------------------------------------------------------------------

demoinput:	macro buttons,duration
	btns_mask: = 0

	i:   = 1
	len: = strlen("\buttons")
	while (i<=len)
		btn:	substr i,i,"\buttons"
		i: = i+1

		; If anyone reads this in the future and knows how to get
		; switch-cases to work in ASM68K, please submit a PR...
		if "\btn"="U"
			btns_mask: = btns_mask|btnUp
		elseif "\btn"="D"
			btns_mask: = btns_mask|btnDn
		elseif "\btn"="L"
			btns_mask: = btns_mask|btnL
		elseif "\btn"="R"
			btns_mask: = btns_mask|btnR
		elseif "\btn"="A"
			btns_mask: = btns_mask|btnA
		elseif "\btn"="B"
			btns_mask: = btns_mask|btnB
		elseif "\btn"="C"
			btns_mask: = btns_mask|btnC
		elseif "\btn"="S"
			btns_mask: = btns_mask|btnStart
		endif
	endw
	dc.b	btns_mask,\duration-1
    endm

abs: macro val
	endm
; ---------------------------------------------------------------------------
; macro to emit a linear range of bytes [first..last] inclusive
; input: start, end, increment, (optional) repeat each single step
; ---------------------------------------------------------------------------

range: macro first,last,step,repeat
	.rep: = 1
	if (narg=4)
		.rep: = repeat
	endif

	.r: = first-last
	if (.r<0) ; abs
		.r: = .r*-1
	endif

	.s: = step
	if (.s<0) ; abs
		.s: = .s*-1
	endif
	
	.val: = first
	rept 1+(.r/.s)
		rept .rep
			dc.b .val
		endr
		.val: = .val+(step)
	endr
	endm

; ---------------------------------------------------------------------------
; compare the size of an index with ZoneCount constant
; (should be used immediately after the index)
; input: index address, element size
; ---------------------------------------------------------------------------

zonewarning:	macro loc,elementsize
	.end:
	if (.end-loc)-(ZoneCount*elementsize)<>0
		inform 1,"Size of \loc ($%h) does not match ZoneCount ($\#ZoneCount).",(.end-loc)/elementsize
	endif
		endm

; ---------------------------------------------------------------------------
; binclude compatibility macro for asm68k
; ---------------------------------------------------------------------------

binclude:	macro path,offset,length
	if offset<>0|length<>0
		if length<>0
			incbin \path,\offset,\length
		else
			incbin \path,\offset
		endif
	else
		incbin \path
	endif
		endm

; ---------------------------------------------------------------------------
; Macro to binclude something with an end marker
; ---------------------------------------------------------------------------

bincludeEndMarker: macro *,path
\*:
		binclude \path
\*_end:
		endm
