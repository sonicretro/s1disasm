; ===========================================================================
; ---------------------------------------------------------------------------
; Error handler
; ---------------------------------------------------------------------------

	if SkipChecksumCheck=0
CheckSumError:
		bsr.w	VDPSetupGame				; restore all VDP registers
		move.l	#$C0000000,(vdp_control_port).l		; set VDP to CRAM write
		moveq	#(v_palette_end-v_palette)/2-1,d7	; write to entire palette
.fillred:	move.w	#cRed,(vdp_data_port).l			; fill palette with red
		dbf	d7,.fillred				; repeat until CRAM is filled
		bra.s	*					; endless loop to itself
	endif
; ===========================================================================

BusError:	move.b	#2,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithAddress		; continue to handler (with pc value)
; ---------------------------------------------------------------------------
AddressError:	move.b	#4,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithAddress		; continue to handler (with pc value)
; ---------------------------------------------------------------------------
IllegalInstr:	move.b	#6,(v_errortype).w			; set error code
		addq.l	#2,2(sp)				; skip over illegal instruction on recovery
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
ZeroDivide:	move.b	#8,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
ChkInstr:	move.b	#$A,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
TrapvInstr:	move.b	#$C,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
PrivilegeViol:	move.b	#$E,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
Trace:		move.b	#$10,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
Line1010Emu:	move.b	#$12,(v_errortype).w			; set error code
		addq.l	#2,2(sp)				; skip over illegal instruction on recovery
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
Line1111Emu:	move.b	#$14,(v_errortype).w			; set error code
		addq.l	#2,2(sp)				; skip over illegal instruction on recovery
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
ErrorExcept:	move.b	#0,(v_errortype).w			; set error code (generic fallback error)
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ===========================================================================

; loc_43A:
ErrorHandler_WithAddress:
		disable_ints					; disable interrupts so we stay here
		addq.w	#2,sp					; skip sr value
		move.l	(sp)+,(v_spbuffer).w			; retrieve pc value from before the crash
		addq.w	#2,sp					; skip second sr value
		movem.l	d0-a7,(v_regbuffer).w			; backup all registers values from before the crash

		bsr.w	ShowErrorMessage			; write error text to screen
		move.l	2(sp),d0				; get error address
		bsr.w	ShowErrorValue				; write value to screen
		move.l	(v_spbuffer).w,d0			; get origin pc value
		bsr.w	ShowErrorValue				; write value to screen
		bra.s	ErrorHandler_TryRecovery		; skip over
; ===========================================================================

; loc_462:
ErrorHandler_WithoutAddress:
		disable_ints					; disable interrupts so we stay here
		movem.l	d0-a7,(v_regbuffer).w			; backup all registers values from before the crash

		bsr.w	ShowErrorMessage			; write error text to screen
		move.l	2(sp),d0				; load error address
		bsr.w	ShowErrorValue				; write value to screen
; ---------------------------------------------------------------------------

; loc_478:
ErrorHandler_TryRecovery:
		bsr.w	ErrorWaitForC				; loop until C has been pressed
		movem.l	(v_regbuffer).w,d0-a7			; restore registers before exception
		enable_ints					; enable ints
		rte						; try resuming normal operation (may or may not work, depending on type of crash)
; ===========================================================================

ShowErrorMessage:
		lea	(vdp_data_port).l,a6			; set VDP data port
		locVRAM	ArtTile_Error_Handler_Font*tile_size	; set target VRAM location for error text font
		lea	(Art_Text).l,a0				; load error text font
		move.w	#(Art_Text_end-Art_Text-tile_size)/2-1,d1 ; load font (strangely, this does not load the final tile)
.loadgfx:	move.w	(a0)+,(a6)				; dump graphics to VRAM
		dbf	d1,.loadgfx				; loop until font has been loaded

		moveq	#0,d0					; clear d0
		move.b	(v_errortype).w,d0			; load error code
		move.w	ErrorText(pc,d0.w),d0			; find offset in error texts array
		lea	ErrorText(pc,d0.w),a0			; load error text for error code
		locVRAM	vram_fg+(12*$80)+(2*2)			; write error message directly to plane A nametable (row 12 + column 2 = $C04)
		moveq	#19-1,d1				; number of characters in error text message (minus 1)
.showchars:	moveq	#0,d0					; clear d0
		move.b	(a0)+,d0				; get next character from error text
		addi.w	#-'0'+ArtTile_Error_Handler_Font,d0	; rebase from ASCII to a VRAM index
		move.w	d0,(a6)					; write to VRAM
		dbf	d1,.showchars				; repeat for number of characters
		rts						; return
; End of function ShowErrorMessage
; ===========================================================================

ErrorText:	dc.w .exception-ErrorText			; 0
		dc.w .bus-ErrorText				; 2
		dc.w .address-ErrorText				; 4
		dc.w .illinstruct-ErrorText			; 6
		dc.w .zerodivide-ErrorText			; 8
		dc.w .chkinstruct-ErrorText			; $A
		dc.w .trapv-ErrorText				; $C
		dc.w .privilege-ErrorText			; $E
		dc.w .trace-ErrorText				; $10
		dc.w .line1010-ErrorText			; $12
		dc.w .line1111-ErrorText			; $14

.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b "@ERO DIVIDE        "			; Note: @ is Z due to the font arrangement
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even

; ===========================================================================

; Input: d0 = number to write (8 digits)
ShowErrorValue:
		move.w	#ArtTile_Error_Handler_Font+$A,(a6)	; display "$" symbol
		moveq	#8-1,d2					; write 8 digits
	.loop:	rol.l	#4,d0					; shift to next digit
		bsr.s	.writeDigit				; write number to VRAM
		dbf	d2,.loop				; loop until done
		rts						; return
; ---------------------------------------------------------------------------

.writeDigit:
		move.w	d0,d1					; make a copy (need to preserve d0 for the loop)
		andi.w	#$F,d1					; limit digit to one nybble
		cmpi.w	#$A,d1					; is digit $A-$F?
		blo.s	.write					; if not, branch
		addq.w	#7,d1					; adjust tile offset for hex letters
	.write:	addi.w	#ArtTile_Error_Handler_Font,d1		; add art tile offset
		move.w	d1,(a6)					; write to VRAM nametable
		rts						; return
; End of function ShowErrorValue
; ===========================================================================

ErrorWaitForC:
		bsr.w	ReadJoypads				; keep reading joypads
		cmpi.b	#btnC,(v_jpadpress1).w			; has button C been pressed?
		bne.w	ErrorWaitForC				; if not, keep looping
		rts						; return to try recovering execution
; End of function ErrorWaitForC
; End of error handler (as a whole)
