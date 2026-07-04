; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to initialize oscillating numbers
; ---------------------------------------------------------------------------

OscillateNumInit:
		lea	(v_oscillate).w,a1
		lea	(.baselines).l,a2
		moveq	#((.baselines_end-.baselines)/2)-1,d1
	.loop:	move.w	(a2)+,(a1)+				; copy baseline values to RAM
		dbf	d1,.loop
		rts
; End of function OscillateNumInit

; ===========================================================================
.baselines:	dc.w %0000000001111100				;   0 - direction bitfield (0 = up; 1 = down)

		; start value, start rate
		dc.w   $80,    0				;   2 - LZ water height, MZ grass platforms
		dc.w   $80,    0				;   6 - MZ grass platforms, SBZ saws
		dc.w   $80,    0				;  $A - MZ magma animation, MZ grass platforms, SYZ/SLZ floating blocks
		dc.w   $80,    0				;  $E - MZ grass platforms, MZ/LZ moving blocks, GHZ/SYZ/SLZ platforms, SBZ saws, SYZ large spikeball
		dc.w   $80,    0				; $12 - MZ glass block, MZ purple block
		dc.w   $80,    0				; $16 - MZ purple block
		dc.w   $80,    0				; $1A - GHZ/MZ/SLZ/SBZ swinging platforms, GHZ/SYZ/SLZ platforms
		dc.w   $80,    0				; $1E - MZ/LZ moving blocks, SYZ/SLZ floating blocks
		dc.w   $80,    0				; $22 - SLZ circling platforms
		dc.w $50F0, $11E				; $26 - SLZ circling platforms
		dc.w $2080,  $B4				; $2A - SYZ/SLZ floating blocks
		dc.w $3080, $10E				; $2E - SYZ/SLZ floating blocks
		dc.w $5080, $1C2				; $32 - SYZ/SLZ floating blocks
		dc.w $7080, $276				; $36 - SYZ/SLZ floating blocks
		dc.w   $80,    0				; $3A - unused
		dc.w   $80,    0				; $3E - unused
	.baselines_end:
		even
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to run oscillating numbers
; ---------------------------------------------------------------------------

OscillateNumDo:
		cmpi.b	#6,(v_player+obRoutine).w		; has Sonic just died?
		bhs.s	.end					; if yes, branch

		lea	(v_oscillate).w,a1
		lea	(.settings).l,a2
		move.w	(a1)+,d3				; get oscillation direction bitfield
		moveq	#((.settings_end-.settings)/4)-1,d1	; loop counter (also the bit to test/store direction)

.loop:
		move.w	(a2)+,d2				; get frequency
		move.w	(a2)+,d4				; get amplitude
		btst	d1,d3					; check oscillation direction
		bne.s	.down					; branch if 1

	.up:
		move.w	2(a1),d0				; get current rate
		add.w	d2,d0					; add frequency
		move.w	d0,2(a1)				; update rate
		_add.w	d0,0(a1)				; add rate to value
		_cmp.b	0(a1),d4
		bhi.s	.next					; branch if value is below middle value
		bset	d1,d3					; set direction to down
		bra.s	.next

	.down:
		move.w	2(a1),d0				; get current rate
		sub.w	d2,d0					; subtract frequency
		move.w	d0,2(a1)				; update rate
		_add.w	d0,0(a1)				; add rate to value
		_cmp.b	0(a1),d4
		bls.s	.next					; branch if value is above middle value
		bclr	d1,d3					; set direction to up

	.next:
		addq.w	#4,a1					; next value/rate
		dbf	d1,.loop				; repeat for all bits in direction bitfield
		move.w	d3,(v_oscillate).w			; update direction bitfield

.end:
		rts
; End of function OscillateNumDo

; ===========================================================================
.settings:	; frequency, middle value
								;   0 - (direction bitfield, not read from outside)
		dc.w 2,	$10					;   2 - LZ water height, MZ grass platforms
		dc.w 2,	$18					;   6 - MZ grass platforms, SBZ saws
		dc.w 2,	$20					;  $A - MZ magma animation, MZ grass platforms, SYZ/SLZ floating blocks
		dc.w 2,	$30					;  $E - MZ grass platforms, MZ/LZ moving blocks, GHZ/SYZ/SLZ platforms, SBZ saws, SYZ large spikeball
		dc.w 4,	$20					; $12 - MZ glass block, MZ purple block
		dc.w 8,	  8					; $16 - MZ purple block
		dc.w 8,	$40					; $1A - GHZ/MZ/SLZ/SBZ swinging platforms, GHZ/SYZ/SLZ platforms
		dc.w 4,	$40					; $1E - MZ/LZ moving blocks, SYZ/SLZ floating blocks
		dc.w 2,	$50					; $22 - SLZ circling platforms
		dc.w 2,	$50					; $26 - SLZ circling platforms
		dc.w 2,	$20					; $2A - SYZ/SLZ floating blocks
		dc.w 3,	$30					; $2E - SYZ/SLZ floating blocks
		dc.w 5,	$50					; $32 - SYZ/SLZ floating blocks
		dc.w 7,	$70					; $36 - SYZ/SLZ floating blocks
		dc.w 2,	$10					; $3A - unused
		dc.w 2,	$10					; $3E - unused
	.settings_end:
		even
; ===========================================================================
