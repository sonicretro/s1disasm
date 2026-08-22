
.MEMORYMAP
DEFAULTSLOT 0
	SLOT 0 START 0 SIZE   $2000 NAME "ZRAM"  ; 8KB Z80 RAM
.ENDME

.ROMBANKSIZE $25 ; Original size in Sonic 1
.ROMBANKS 1

.SECTION "Boot"
		ld	bc,($2000-zStartupEnd.w)-1 ; prepare to loop this many times
		ld	de,zStartupEnd.w+1	; initial destination address
		ld	hl,zStartupEnd.w	; initial source address
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
zStartupEnd:
.ENDS ; End of section 'Boot'
