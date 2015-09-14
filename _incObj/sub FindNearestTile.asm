; ---------------------------------------------------------------------------
; Subroutine to	find which tile	the object is standing on

; input:
;	d2 = y-position of object's bottom edge
;	d3 = x-position of object

; output:
;	a1 = address within 128x128 mappings where object is standing
;	     (refers to a 16x16 tile number)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindNearestTile:
		move.w	d2,d0			; MJ: load Y position
		andi.w	#$780,d0		; MJ: get within 780 (E00 pixels) in multiples of 80
		add.w	d0,d0			; MJ: multiply by 2
		move.w	d3,d1			; MJ: load X position
		lsr.w	#7,d1			; MJ: shift to right side
		andi.w	#$7F,d1			; MJ: get within 7F
		add.w	d1,d0			; MJ: add calc'd Y to calc'd X
		moveq	#-1,d1			; MJ: prepare FFFF in d3
		movea.l	(v_lvllayoutfg).w,a1	; MJ: load address of Layout to a1
		move.b	(a1,d0.w),d1		; MJ: collect correct chunk ID based on the X and Y position
		andi.w	#$FF,d1			; MJ: keep within FF
		lsl.w	#7,d1			; MJ: multiply by 80
		move.w	d2,d0			; MJ: load Y position
		andi.w	#$70,d0			; MJ: keep Y within 80 pixels
		add.w	d0,d1			; MJ: add to ror'd chunk ID
		move.w	d3,d0			; MJ: load X position
		lsr.w	#3,d0			; MJ: divide by 8
		andi.w	#$E,d0			; MJ: keep X within 10 pixels
		add.w	d0,d1			; MJ: add to ror'd chunk ID

		movea.l	d1,a1			; MJ: set address (Chunk to read)
		rts				; MJ: return
; End of function FindNearestTile