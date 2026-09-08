; ===========================================================================
; ---------------------------------------------------------------------------
; Unused/dead subroutine that was likely used during development.
; 
; This subroutine takes 'raw' bitmap-like collision block data as input and
; converts it into the proper collision arrays (ColArray and ColArray2).
; Pointers to said raw data are dummied out.
; Curiously, an example of the original 'raw' data that this was intended
; to process can be found in the J2ME version, in a file called 'blkcol.bct'.
; ---------------------------------------------------------------------------
RawColBlocks:		equ CollArray1
ConvRowColBlocks:	equ CollArray1
; ---------------------------------------------------------------------------

ConvertCollisionArray:
		rts						; immediately return
; ---------------------------------------------------------------------------

		; The raw format stores the collision data column by column for the normal collision array.
		; This makes a copy of the data, but stored row by row, for the rotated collision array.
		lea	(RawColBlocks).l,a1			; source location of raw collision block data
		lea	(ConvRowColBlocks).l,a2			; destination location for row-converted collision block data
		move.w	#$100-1,d3				; number of blocks in collision data
.blockLoop:
		moveq	#16,d5					; start on the 16th bit (the leftmost pixel)
		move.w	#16-1,d2				; width of a block in pixels
.columnLoop:
		moveq	#0,d4
		move.w	#16-1,d1				; height of a block in pixels
.rowLoop:
		move.w	(a1)+,d0				; get row of collision bits
		lsr.l	d5,d0					; push the selected bit of this row into the 'eXtend' flag
		addx.w	d4,d4					; shift d4 to the left, and insert the selected bit into bit 0
		dbf	d1,.rowLoop				; loop for each row of pixels in a block
		move.w	d4,(a2)+				; store column of collision bits
		suba.w	#2*16,a1				; back to the start of the block
		subq.w	#1,d5					; get next bit in the row
		dbf	d2,.columnLoop				; loop for each column of pixels in a block
		adda.w	#2*16,a1				; next block
		dbf	d3,.blockLoop				; loop for each block in the raw collision block data

		; This then converts the collision data into the final collision arrays
		lea	(ConvRowColBlocks).l,a1
		lea	(CollArray2).l,a2			; convert the row-converted collision block data into final rotated collision array
		bsr.s	.convertArray
		lea	(RawColBlocks).l,a1
		lea	(CollArray1).l,a2			; convert the raw collision block data into final normal collision array
.convertArray:
		move.w	#$1000-1,d3				; size of the collision array
.processLoop:
		moveq	#0,d2
		move.w	#$F,d1
		move.w	(a1)+,d0				; get current column of collision pixels
		beq.s	.noCollision				; branch if there's no collision in this column
		bmi.s	.topPixelSolid				; branch if top pixel of collision is solid

		; Here we count, starting from the bottom, how many pixels tall
		; the collision in this column is.
.processColumnLoop1:
		lsr.w	#1,d0
		bhs.s	.pixelNotSolid1
		addq.b	#1,d2
.pixelNotSolid1:
		dbf	d1,.processColumnLoop1
		bra.s	.columnProcessed
; ---------------------------------------------------------------------------

.topPixelSolid:
		cmpi.w	#$FFFF,d0				; is entire column solid?
		beq.s	.entireColumnSolid			; branch if so

		; Here we count, starting from the top, how many pixels tall
		; the collision in this column is (the resulting number is negative).
.processColumnLoop2:
		lsl.w	#1,d0
		bhs.s	.pixelNotSolid2
		subq.b	#1,d2
.pixelNotSolid2:
		dbf	d1,.processColumnLoop2
		bra.s	.columnProcessed
; ---------------------------------------------------------------------------

.entireColumnSolid:
		move.w	#$10,d0
.noCollision:
		move.w	d0,d2
.columnProcessed:
		move.b	d2,(a2)+				; store column collision height
		dbf	d3,.processLoop
		rts
; End of function ConvertCollisionArray
; ===========================================================================
