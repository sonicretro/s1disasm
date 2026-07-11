; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw the level's "background" graphics in strips as the screen moves.
; Background only - used by title screen.
; ---------------------------------------------------------------------------

; sub_6886: DrawLevel_Strips_BG: DrawTilesWhenMoving_BGOnly:
LoadTilesAsYouMove_BGOnly:
		lea	(vdp_control_port).l,a5			; load VDP control port
		lea	(vdp_data_port).l,a6			; load VDP data port

		lea	(v_bg1_scroll_flags).w,a2		; load background draw flags
		lea	(v_bgscreenposx).w,a3			; load background position data
		lea	(v_lvllayout_bg).w,a4			; load background layout
		move.w	#$6000,d2				; prepare VDP $E000 (BG plane) VRAM setting
		bsr.w	DrawBG_Top				; draw the top section of the BG

		lea	(v_bg2_scroll_flags).w,a2		; load background draw flags
		lea	(v_bg2screenposx).w,a3			; load background position data
		bra.w	DrawBG_Bottom				; draw the bottom section of the BG
; End of function LoadTilesAsYouMove_BGOnly


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw the level's graphics in strips as the screen moves.
; Foreground and background - used by levels.
; ---------------------------------------------------------------------------

; DrawLevel_Strips: DrawTilesWhenMoving:
LoadTilesAsYouMove:
		lea	(vdp_control_port).l,a5			; load VDP control port
		lea	(vdp_data_port).l,a6			; load VDP data port

		; First, update the background
		lea	(v_bg1_scroll_flags_dup).w,a2		; load background draw flags
		lea	(v_bgscreenposx_dup).w,a3		; load background position data
		lea	(v_lvllayout_bg).w,a4			; load background layout
		move.w	#$6000,d2				; prepare VDP $E000 (BG plane) VRAM setting
		bsr.w	DrawBG_Top				; draw the top section of the BG

		lea	(v_bg2_scroll_flags_dup).w,a2		; load background draw flags
		lea	(v_bg2screenposx_dup).w,a3		; load background position data
		bsr.w	DrawBG_Bottom				; draw the bottom section of the BG

		; Then, update the foreground
		lea	(v_fg_scroll_flags_dup).w,a2		; load foreground draw flags
		lea	(v_screenposx_dup).w,a3			; load foreground position data
		lea	(v_lvllayout_fg).w,a4			; load foreground layout
		move.w	#$4000,d2				; prepare VDP $C000 (FG plane) VRAM setting

; ---------------------------------------------------------------------------
; Drawing FG block strips
; (Note that 16 is the size of a block in pixels, this goes for all cases)
; ---------------------------------------------------------------------------

		tst.b	(a2)					; have any of the FG draw flags been set?
		beq.s	.return					; if not, branch (no drawing is required)

	; --- FG Top ---

		bclr	#0,(a2)					; clear up draw flag
		beq.s	.checkDown				; if it wasn't set, branch

		; Draw new tiles at the top
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		bsr.w	DrawBlocks_LR				; draw a horizontal line of blocks above the screen

	; --- FG Bottom ---

; loc_6908:
.checkDown:
		bclr	#1,(a2)					; clear down draw flag
		beq.s	.checkLeft				; if it wasn't set, branch

		; Draw new tiles at the bottom
		move.w	#224,d4					; set X and Y positions to bottom left of screen
		moveq	#-16,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	#224,d4					; set X and Y positions to bottom left of screen
		moveq	#-16,d5					; ''
		bsr.w	DrawBlocks_LR				; draw a horizontal line of blocks below the screen

	; --- FG Left ---

; loc_6922:
.checkLeft:
		bclr	#2,(a2)					; clear left draw flag
		beq.s	.checkRight				; if it wasn't set, branch

		; Draw new tiles on the left
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		bsr.w	DrawBlocks_TB				; draw a vertical line of blocks to the left of the screen

	; --- FG Right ---

; loc_6938:
.checkRight:
		bclr	#3,(a2)					; clear right draw flag
		beq.s	.return					; if it wasn't set, branch

		; Draw new tiles on the right
		moveq	#-16,d4					; set X and Y positions to top right of screen
		move.w	#320,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top right of screen
		move.w	#320,d5					; ''
		bsr.w	DrawBlocks_TB				; draw a vertical line of blocks to the right of the screen

; locret_6952:
.return:
		rts						; return
; End of function LoadTilesAsYouMove


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw BG block strips - Top scroll section (scroll block A)
; ---------------------------------------------------------------------------

; sub_6954: DrawBGScrollBlock1:
DrawBG_Top:
		tst.b	(a2)					; have any of the BG top section draw flags been set?
		beq.w	.return					; if not, branch (no drawing is required)

	; --- BG Top ---

		bclr	#0,(a2)					; clear up draw flag
		beq.s	.checkDown				; if it wasn't set, branch

		; Draw new tiles at the top
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		moveq	#(512/16)-1,d6				; prepare number of blocks to draw (entire plane's width, 512 pixels)
		bsr.w	DrawBlocks_LR_2				; draw a horizontal line of blocks above the screen

	; --- BG Bottom ---

; loc_6972:
.checkDown:
		bclr	#1,(a2)					; clear down draw flag
		beq.s	.checkLeft				; if it wasn't set, branch

		; Draw new tiles at the bottom
		move.w	#224,d4					; set X and Y positions to bottom left of screen
		moveq	#-16,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	#224,d4					; set X and Y positions to bottom left of screen
		moveq	#-16,d5					; ''
		moveq	#(512/16)-1,d6				; prepare number of blocks to draw (entire plane's width, 512 pixels)
		bsr.w	DrawBlocks_LR_2				; draw a horizontal line of blocks below the screen

	; --- BG Left (Top Section) ---

; loc_698E:
.checkLeft:
		bclr	#2,(a2)					; clear left draw flag
		beq.s	.checkRight				; if it wasn't set, branch

		; Draw new tiles on the left
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top left of screen
		moveq	#-16,d5					; ''
		move.w	(v_scroll_block_1_size).w,d6		; load scroll block size A
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d6					; get size of scroll block section to draw
		blt.s	.checkRight				; if the scroll block A is above and off of the screen, branch
		lsr.w	#4,d6					; divide by 16 (block size)
		cmpi.w	#((224+16+16)/16)-1,d6			; is the scroll block section larger than the plane?
		blo.s	.drawLeft				; if not, branch
		moveq	#((224+16+16)/16)-1,d6			; set to maximum plane size

	; loc_69BA:
	.drawLeft:
		bsr.w	DrawBlocks_TB_2				; draw a vertical line of blocks to the left of the screen

	; --- BG Right (Top Section) ---

; loc_69BE:
.checkRight:
		bclr	#3,(a2)					; clear right draw flag
		beq.s	.return					; if it wasn't set, branch

		; Draw new tiles on the right
		moveq	#-16,d4					; set X and Y positions to top right of screen
		move.w	#320,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top right of screen
		move.w	#320,d5					; ''
		move.w	(v_scroll_block_1_size).w,d6		; load scroll block size A
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d6					; get size of scroll block section to draw
		blt.s	.return					; if the scroll block A is above and off of the screen, branch
		lsr.w	#4,d6					; divide by 16 (block size)
		cmpi.w	#((224+16+16)/16)-1,d6			; is the scroll block section larger than the plane?
		blo.s	.drawRight				; if not, branch
		moveq	#((224+16+16)/16)-1,d6			; set to maximum plane size

	; loc_69EE:
	.drawRight:
		bsr.w	DrawBlocks_TB_2				; draw a vertical line of blocks to the right of the screen

; locret_69F2:
.return:
		rts						; return
; End of function DrawBG_Top


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw BG block strips - Bottom scroll section (below scroll block A)
; ---------------------------------------------------------------------------

; sub_69F4: DrawBGScrollBlock2:
DrawBG_Bottom:
		tst.b	(a2)					; have any of the BG bottom section draw flags been set?
		beq.w	.return					; if not, branch (no drawing is required)

	; --- BG Left (Bottom Section) ---

		bclr	#2,(a2)					; clear left draw flag
		beq.s	.checkRight				; if it wasn't set, branch

		; Draw new tiles on the left
		cmpi.w	#16,(a3)				; is the section's X position at $0000?
		blo.s	.checkRight				; if so, branch (cannot draw a line of blocks before $0000 on the X axis)
		move.w	(v_scroll_block_1_size).w,d4		; load scroll block size A
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d4					; get size/position of top scroll block to draw
		move.w	d4,-(sp)				; store inside the stack
		moveq	#-16,d5					; set X position to the left of the screen
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	(sp)+,d4				; restore Y plane position
		moveq	#-16,d5					; reset X position to the left of the screen
		move.w	(v_scroll_block_1_size).w,d6		; load scroll block size A
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d6					; get size of top scroll block to draw
		blt.s	.checkRight				; if the scroll block section is below and off of the screen, branch
		lsr.w	#4,d6					; divide by 16 (block size)
		subi.w	#((224+16)/16)-1,d6			; minus screen block size
		bhs.s	.checkRight				; if there is no bottom scroll block section to draw, branch
		neg.w	d6					; reverse size to get the remaining bottom section size
		bsr.w	DrawBlocks_TB_2				; draw a vertical line of blocks to the left of the screen

	; --- BG Right (Bottom Section) ---

; loc_6A3E:
.checkRight:
		bclr	#3,(a2)					; clear right draw flag
		beq.s	.return					; if it wasn't set, branch

		; Draw new tiles on the right
		move.w	(v_scroll_block_1_size).w,d4		; load scroll block size A
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d4					; get size/position of top scroll block to draw
		move.w	d4,-(sp)				; store inside the stack
		move.w	#320,d5					; set X position to the right of the screen
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	(sp)+,d4				; restore Y plane position
		move.w	#320,d5					; set X position to the right of the screen
		move.w	(v_scroll_block_1_size).w,d6		; load scroll block size A
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d6					; get size of top scroll block to draw
		blt.s	.return					; if the scroll block section is below and off of the screen, branch
		lsr.w	#4,d6					; divide by 16 (block size)
		subi.w	#((224+16)/16)-1,d6			; minus screen block size
		bhs.s	.return					; if there is no bottom scroll block section to draw, branch
		neg.w	d6					; reverse size to get the remaining bottom section size
		bsr.w	DrawBlocks_TB_2				; draw a vertical line of blocks to the right of the screen

; locret_6A80:
.return:
		rts						; return
; End of function DrawBG_Bottom


; ===========================================================================
; ---------------------------------------------------------------------------
; Abandoned, unused scroll block code to draw 3 vertical blocks in a fixed area.
; ---------------------------------------------------------------------------
; This would have drawn a scroll block that started at 208 pixels down,
; and was 48 pixels long. See Calc_VRAM_Pos_PlaneZ for more information.
; ---------------------------------------------------------------------------

; DrawUnknown: DrawBGScrollBlock_PlaneZ: DrawBGScrollBlock2_Unused:
DrawBG_Unused_PlaneZ:
		tst.b	(a2)					; have any of the draw flags been set?
		beq.s	.return					; if not, branch

	; --- Left ---

		bclr	#2,(a2)					; clear left draw flag
		beq.s	.checkRight				; if it wasn't set, branch

		; Draw new tiles on the left
		move.w	#224-16,d4				; set Y position in the level to draw the section (near bottom of screen at top of position)
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d4					; get size/position of scroll block to draw
		move.w	d4,-(sp)				; store inside the stack
		moveq	#-16,d5					; set X position to the left of the screen
		bsr.w	Calc_VRAM_Pos_PlaneZ			; get the plane position
		move.w	(sp)+,d4				; restore Y plane position
		moveq	#-16,d5					; set X position to the left of the screen
		moveq	#3-1,d6					; set number of blocks to draw (3 blocks)
		bsr.w	DrawBlocks_TB_2				; draw a vertical line of blocks to the left of the screen

	; --- Right ---

; loc_6AAC:
.checkRight:
		bclr	#3,(a2)					; clear right draw flag
		beq.s	.return					; if it wasn't set, branch

		; Draw new tiles on the right
		move.w	#224-16,d4				; set Y position in the level to draw the section (near bottom of screen at top of position)
		move.w	4(a3),d1				; load Y position
		andi.w	#$FFF0,d1				; keep in multiples of blocks (16 pixels)
		sub.w	d1,d4					; get size/position of scroll block to draw
		move.w	d4,-(sp)				; store inside the stack
		move.w	#320,d5					; set X position to the right of the screen
		bsr.w	Calc_VRAM_Pos_PlaneZ			; get the plane position
		move.w	(sp)+,d4				; restore Y plane position
		move.w	#320,d5					; set X position to the right of the screen
		moveq	#3-1,d6					; set number of blocks to draw (3 blocks)
		bsr.w	DrawBlocks_TB_2				; draw a vertical line of blocks to the right of the screen

; locret_6AD6:
.return:
		rts						; return
; End of function DrawBG_Unused_PlaneZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw a horizontal row of blocks
;
; input:
; 	d0.l = VDP control port address of plane position (words swapped for convenience)
; 	d2.w = VRAM address of plane to use (usually $C000 or $E000)
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
; 	d6.w = Blocks to draw (DrawBlocks_LR_2 only)
; 	a3.l = Screen position data
; 	a4.l = Layout address
; 	a5.l = VDP control port
; 	a6.l = VDP data port
; ---------------------------------------------------------------------------

; Don't be fooled by the name: this function's for drawing from left to right
; when the camera's moving up or down!

; DrawBlocks_X: DrawRow:
DrawBlocks_LR:
		moveq	#((320+16+16)/16)-1,d6			; prepare number of blocks (entire width of the screen + two extra columns)

; DrawBlocks_X_Alt: DrawRow_Partial:
DrawBlocks_LR_2:
		move.l	#$800000,d7				; prepare plane row advance rate ($80 bytes per row for *512 plane width)
		move.l	d0,d1					; store VDP plane address

	.nextBlock:
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	GetBlockData				; load block
		move.l	d1,d0					; load VDP plane address
		bsr.w	DrawBlock				; draw the tiles from the block correctly
		addq.b	#4,d1					; increase VDP plane address to the right by 2 tiles (1 block)
		andi.b	#$7F,d1					; wrap if necessary
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		addi.w	#16,d5					; advance X position right by 1 block
		dbf	d6,.nextBlock				; repeat for number of blocks in the strip
		rts						; return
; End of function DrawBlocks_LR


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw a vertical column of blocks
;
; input:
; 	d0.l = VDP control port address of plane position (words swapped for convenience)
; 	d2.w = VRAM address of plane to use (usually $C000 or $E000)
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
; 	d6.w = Blocks to draw (DrawBlocks_TB_2 only)
; 	a3.l = Screen position data
; 	a4.l = Layout address
; 	a5.l = VDP control port
; 	a6.l = VDP data port
; ---------------------------------------------------------------------------

; Don't be fooled by the name: this function's for drawing from top to bottom
; when the camera's moving left or right!

; DrawBlocks_Y: DrawColumn:
DrawBlocks_TB:
		moveq	#((224+16+16)/16)-1,d6			; prepare number of blocks (entire height of the screen + two extra rows)

; DrawBlocks_Y_Alt: DrawColumn_Partial:
DrawBlocks_TB_2:
		move.l	#$800000,d7				; prepare plane row advance rate ($80 bytes per row for * 512 plane width)
		move.l	d0,d1					; store VDP plane address

	.nextBlock:
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	GetBlockData				; load block
		move.l	d1,d0					; load VDP plane address
		bsr.w	DrawBlock				; draw the tiles from the block correctly
		addi.w	#$100,d1				; increase VDP plane address down by 2 rows (1 block)
		andi.w	#$FFF,d1				; wrap if necessary
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		addi.w	#16,d4					; advance Y position down by 1 block
		dbf	d6,.nextBlock				; repeat for number of blocks in the strip
		rts						; return
; End of function DrawBlocks_TB


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw tiles from a block correctly
;
; input:
; 	d0.l = VDP control port address of plane position (words swapped for convenience)
; 	d2.w = VRAM address of plane to use (usually $C000 or $E000)
; 	a0.l = Address of block to draw
; 	a5.l = VDP control port
; 	a6.l = VDP data port
; 	d7.l = plane row advance rate (usually $800000 ($80 per row))
; ---------------------------------------------------------------------------

; DrawTiles:
DrawBlock:
		or.w	d2,d0					; save VRAM plane address to VDP control port plane position
		swap	d0					; align correctly for VDP
		btst	#4,(a0)					; is the block flipped vertically (+$1000)?
		bne.s	.drawFlipY				; if so, branch
		btst	#3,(a0)					; is the block mirrored horizontally (+$800)?
		bne.s	.drawFlipX				; if so, branch
; ---------------------------------------------------------------------------

.drawNoFlip:

	; --- Normal block ---

		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.l	(a1)+,(a6)				; dump top two tiles
		add.l	d7,d0					; advance to next row
		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.l	(a1)+,(a6)				; dump bottom two tiles
		rts						; return
; ---------------------------------------------------------------------------

.drawFlipX:

	; --- Mirrored block ---

		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.l	(a1)+,d4				; load top two tiles
		eori.l	#$8000800,d4				; mirror the tiles
		swap	d4					; swap them over
		move.l	d4,(a6)					; dump top two tiles (reversed)
		add.l	d7,d0					; advance to next row
		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.l	(a1)+,d4				; load bottom two tiles
		eori.l	#$8000800,d4				; mirror the tiles
		swap	d4					; swap them over
		move.l	d4,(a6)					; dump bottom two tiles (reversed)
		rts						; return
; ---------------------------------------------------------------------------

.drawFlipY:
		btst	#3,(a0)					; is the block also mirrored horizontally (with flip vertical +$1800)?
		bne.s	.drawFlipXY				; if so, branch

	; --- Flipped block ---

		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.l	(a1)+,d5				; load top two tiles
		move.l	(a1)+,d4				; load bottom two tiles
		eori.l	#$10001000,d4				; flip bottom two tiles
		move.l	d4,(a6)					; dump bottom two tiles first so they draw at top
		add.l	d7,d0					; advance to next row
		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		eori.l	#$10001000,d5				; flip top two tiles
		move.l	d5,(a6)					; dump top two tiles last so they draw at bottom
		rts						; return
; ---------------------------------------------------------------------------

.drawFlipXY:

	; --- Flipped & Mirrored block ---

		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.l	(a1)+,d5				; load top two tiles
		move.l	(a1)+,d4				; load bottom two tiles
		eori.l	#$18001800,d4				; flip and mirror the bottom two tiles
		swap	d4					; swap them over
		move.l	d4,(a6)					; dump bottom two tiles first so they draw at top
		add.l	d7,d0					; advance to next row
		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		eori.l	#$18001800,d5				; flip and mirror the top two tiles
		swap	d5					; swap them over
		move.l	d5,(a6)					; dump top two tiles last so they draw at bottom
		rts						; return
; End of function DrawBlocks


; ===========================================================================
; ---------------------------------------------------------------------------
; Abandoned, unused block draw routine that also advances palette line.
; ---------------------------------------------------------------------------
; This is interesting. It draws a block, but not before incrementing its
; palette lines by 1. This may have been a debug function to discolor
; mirrored tiles, to test if they're loading properly.
; ---------------------------------------------------------------------------

DrawBlock_Unused_NextPal:
		rts						; return (would have been used to null this routine out)
		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.w	#$2000,d5				; prepare palette line advance value (advances to next palette line)
		move.w	(a1)+,d4				; load tile
		add.w	d5,d4					; increase palette line
		move.w	d4,(a6)					; dump to tile to VRAM plane
		move.w	(a1)+,d4				; load tile
		add.w	d5,d4					; increase palette line
		move.w	d4,(a6)					; dump to tile to VRAM plane
		add.l	d7,d0					; advance to next row
		move.l	d0,(a5)					; set VDP to VRAM write mode with plane address
		move.w	(a1)+,d4				; load tile
		add.w	d5,d4					; increase palette line
		move.w	d4,(a6)					; dump to tile to VRAM plane
		move.w	(a1)+,d4				; load tile
		add.w	d5,d4					; increase palette line
		move.w	d4,(a6)					; dump to tile to VRAM plane
		rts						; return
; End of function DrawBlock_Unused_NextPal


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to obtain the block data and address
;
; input:
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
; 	a3.l = Screen position data
; 	a4.l = Layout address
;
; output:
; 	a0.l = Address of block ID in chunk RAM
; 	a1.l = Address of block
; ---------------------------------------------------------------------------

; DrawBlocks:
GetBlockData:
		lea	(v_16x16).w,a1				; load block RAM
		add.w	4(a3),d4				; add Screen Y position
		add.w	(a3),d5					; add Screen X position

		; Turn Y coordinate into index into level layout
		move.w	d4,d3					; copy X position to d3
		lsr.w	#1,d3					; divide by 2
		andi.w	#$380,d3				; keep in range of layout's Y size ($400 per plane) in multiples of 1 row ($80 per row, $40 per plane)

		; Turn X coordinate into index into level layout
		lsr.w	#3,d5					; divide X by 8
		move.w	d5,d0					; copy to d0
		lsr.w	#5,d0					; divide by $20 (/$100)
		andi.w	#$7F,d0					; keep in range of layout's X size ($80 per row, $40 per plane)

		; Get chunk from level layout
		add.w	d3,d0					; fuse Y and X together (d0 = layout position of chunk)
		moveq	#$FFFFFFFF,d3				; prepare RAM address ($FFFF???? for layout)
		move.b	(a4,d0.w),d3				; load correct chunk ID from layout
		beq.s	.return					; if the chunk is $00, branch (chunk $00 is empty, no drawing necessary)

		; Turn chunk ID into index into chunk table
		subq.b	#1,d3					; minus 1 (01 = 00 | 02 = 01 | 03 = 02, etc)
		andi.w	#$7F,d3					; clear upper byte and keep within $80 chunks ($FFFF0000 to $FFFF007F)
		ror.w	#7,d3					; multiply by 512 (d3 = correct chunk's RAM address)

		; Turn Y coordinate into index into chunk
		add.w	d4,d4					; multiply Y position by 2
		andi.w	#$1E0,d4				; keep in range of chunk's Y size (512 per chunk) in multiples of $20 (16 blocks, 2 bytes each)

		; Turn X coordinate into index into chunk
		andi.w	#$1E,d5					; keep in range of chunk's X size (16 blocks, 2 bytes each) in multiples of 2 (2 bytes per block)

		; Get block metadata from chunk
		add.w	d4,d3					; add block's Y position to the chunk address in d3
		add.w	d5,d3					; add block's X position to the chunk address in d3
		movea.l	d3,a0					; copy chunk/block address to a0
		move.w	(a0),d3					; load block ID from chunk

		; Turn block ID into address
		andi.w	#$3FF,d3				; get only block ID
		lsl.w	#3,d3					; multiply by 8 (8 bytes per block)
		adda.w	d3,a1					; advance block RAM to correct block location

	; locret_6C1E:
	.return:
		rts						; return
; End of function GetBlockData


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to calculate the plane position for VRAM $C000 - $FFFF
;
; input:
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
; 	a3.l = Screen position data
;
; output:
; 	d0.l = VDP control port address of plane position (words swapped for convenience)
; ---------------------------------------------------------------------------

; CalcPlaneC000:
Calc_VRAM_Pos:
		add.w	4(a3),d4				; add Screen Y position
		add.w	(a3),d5					; add Screen X position

		; Floor the coordinates to the nearest pair of tiles (the size of a block).
		; Also note that this wraps the value to the size of the plane:
		; The plane is 64*8 wide, so wrap at $100, and it's 32*8 tall, so wrap at $200
		andi.w	#$F0,d4					; keep in range of plane Y size ($100) in multiples of 16 pixels (block size)
		andi.w	#$1F0,d5				; keep in range of plane X size ($200) in multiples of 16 pixels (block size)

		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4					; multiply Y by 16 (multiples of $100)
		lsr.w	#2,d5					; divide X by 4 (multiples of 4)
		add.w	d5,d4					; fuse X to Y
		moveq	#3,d0					; prepare VDP setting $C000+ address
		swap	d0					; send to upper word
		move.w	d4,d0					; load calculated plane position
		rts						; return (d0 contains VDP control port address)
; End of function Calc_VRAM_Pos


; ===========================================================================
; ---------------------------------------------------------------------------
; Abandoned, unused rroutine to calculate the plane position for VRAM $8000 - $BFFF
;
; input:
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
; 	a3.l = Screen position data
;
; output:
; 	d0.l = VDP control port address of plane position (words swapped for convenience)
; ---------------------------------------------------------------------------
; What this does is swap the background nametable with the window layer in order
; to create a third scrolling layer that appears above the foreground. However,
; this comes at the cost of the background becoming garbled at the bottom of the
; screen, which was likely what contributed in its removal. Internally, it was
; known as "Plane Z", and was also the intended use of the third layout entry.
; Presumably, this (alongside bit 3 of obRender) was what was used to achieve the
; foreground effect seen in the Tokyo Toy Show '90. Ultimately, Sonic 2 repurposed
; this code to draw player 2's foreground in multiplayer.
; ---------------------------------------------------------------------------

; sub_6C3C: Calc_VRAM_Pos_Unknown: CalcPlane8000:
Calc_VRAM_Pos_PlaneZ:
		add.w	4(a3),d4				; add Screen Y position
		add.w	(a3),d5					; add Screen X position
		andi.w	#$F0,d4					; keep in range of plane Y size ($100) in multiples of 16 pixels (block size)
		andi.w	#$1F0,d5				; keep in range of plane X size ($200) in multiples of 16 pixels (block size)
		lsl.w	#4,d4					; multiply Y by 16 (multiples of $100)
		lsr.w	#2,d5					; divide X by 4 (multiples of 4)
		add.w	d5,d4					; fuse X to Y
		moveq	#2,d0					; prepare VDP setting $8000+ address
		swap	d0					; send to upper word
		move.w	d4,d0					; load calculated plane position
		rts						; return (d0 contains VDP control port address)
; End of function Calc_VRAM_Pos_PlaneZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	draw the current level graphics to the entire screen,
; used to load tiles as soon as the level appears
; ---------------------------------------------------------------------------

; DrawLevel_Full: DrawTilesAtStart:
LoadTilesFromStart:
		lea	(vdp_control_port).l,a5			; load VDP control port address
		lea	(vdp_data_port).l,a6			; load VDP data port address

	; --- Foreground ---

		lea	(v_screenposx).w,a3			; load foreground position data
		lea	(v_lvllayout_fg).w,a4			; load foreground layout
		move.w	#$4000,d2				; prepare VDP $C000 (FG plane) VRAM setting
		bsr.s	DrawChunks				; draw level data to FG plane ($C000)

	; --- Background ---

		lea	(v_bgscreenposx).w,a3			; load background position data
		lea	(v_lvllayout_bg).w,a4			; load background layout
		move.w	#$6000,d2				; prepare VDP $E000 (BG plane) VRAM setting
		; fall-through to DrawChunks to draw level data to BG plane ($E000)...
; End of function LoadTilesFromStart

; ---------------------------------------------------------------------------
; Drawing an entire plane's worth of level graphics
; ---------------------------------------------------------------------------

; DrawLevel_FullPlane:
DrawChunks:
		moveq	#-16,d4					; start Y position at -16 (outside of screen)
		moveq	#((224+16+16)/16)-1,d6			; set number of blocks strips to draw

	.nextRow:
		movem.l	d4-d6,-(sp)				; store X position and "strip counter" data
		moveq	#0,d5					; clear X position (start at very left of screen)
		move.w	d4,d1					; store Y position in d1
		bsr.w	Calc_VRAM_Pos				; get plane/VRAM address
		move.w	d1,d4					; reload Y position back to d4
		moveq	#0,d5					; reclear X position (start at very left of screen)
		moveq	#(512/16)-1,d6				; set number of blocks to draw horizontally (entire plane's width)
		bsr.w	DrawBlocks_LR_2				; draw the horizontal strip
		movem.l	(sp)+,d4-d6				; restore X position and "strip counter" data
		addi.w	#16,d4					; advance down to next row
		dbf	d6,.nextRow				; repeat for all horizontal row strips
		rts						; return
; End of function DrawChunks

