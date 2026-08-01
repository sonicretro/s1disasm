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

		; REV01 added a third scroll block, though, technically,
		; the RAM for it was already there in REV00
		lea	(v_bg3_scroll_flags_dup).w,a2		; load background block 3 draw flags
		lea	(v_bg3screenposx_dup).w,a3		; load background block 3 position data
		bsr.w	DrawBG_Block3				; draw the third block of the BG

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
		bsr.w	DrawBlocks_LR				; draw a horizontal line of blocks above the screen

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
		bsr.w	DrawBlocks_LR				; draw a horizontal line of blocks below the screen

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
		bsr.w	DrawBlocks_TB				; draw a vertical line of blocks to the left of the screen

	; --- BG Right (Top Section) ---

; loc_69BE:
.checkRight:
		bclr	#3,(a2)					; clear right draw flag
		beq.s	.checkTopAll				; if it wasn't set, branch

		; Draw new tiles on the right
		moveq	#-16,d4					; set X and Y positions to top right of screen
		move.w	#320,d5					; ''
		bsr.w	Calc_VRAM_Pos				; get the plane position
		moveq	#-16,d4					; set X and Y positions to top right of screen
		move.w	#320,d5					; ''
		bsr.w	DrawBlocks_TB				; draw a vertical line of blocks to the right of the screen

	; locj_6D70:
	.checkTopAll:
		bclr	#4,(a2)					; clear top-all draw flag
		beq.s	.checkBottomAll				; if it wasn't set, branch

		; Draw entire row at the top
		moveq	#-16,d4					; Y coordinate = 16px (size of block) above top
		moveq	#0,d5					; clear X position (start at very left of screen)
		bsr.w	Calc_VRAM_Pos_2				; get the plane position (ignore d5 = X width)
		moveq	#-16,d4					; set Y position to top of screen
		moveq	#0,d5					; clear X position (start at very left of screen)
		moveq	#(512/16)-1,d6				; set number of blocks to draw horizontally (entire plane's width)
		bsr.w	DrawBlocks_LR_3				; draw a horizontal line of blocks above the screen

	; locj_6D88:
	.checkBottomAll:
		bclr	#5,(a2)					; clear bottom-all draw flag
		beq.s	.return					; if it wasn't set, branch

		; Draw entire row at the bottom
		move.w	#224,d4					; y coordinate - bottom of screen
		moveq	#0,d5					; clear X position (start at very left of screen)
		bsr.w	Calc_VRAM_Pos_2				; get the plane position (ignore d5 = X width)
		move.w	#224,d4					; set Y position to bottom of screen
		moveq	#0,d5					; clear X position (start at very left of screen)
		moveq	#(512/16)-1,d6				; set number of blocks to draw horizontally (entire plane's width)
		bsr.w	DrawBlocks_LR_3				; draw a horizontal line of blocks below the screen

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

		cmpi.b	#id_SBZ,(v_zone).w			; is current Zone SBZ?
		beq.w	Draw_SBZ				; if yes, branch

		bclr	#0,(a2)					; clear flag for redraw left (REV01 uses bit 0 for redraw left flag)
		beq.s	.checkRight				; branch if already clear

		; Draw new tiles on the left
		move.w	#224/2,d4				; draw the bottom half of the screen
		moveq	#-16,d5					; x coordinate - left of screen
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	#224/2,d4				; draw the bottom half of the screen
		moveq	#-16,d5					; x coordinate - left of screen
		moveq	#3-1,d6					; draw three rows... could this be a repurposed version of the above unused code?
		bsr.w	DrawBlocks_TB_2				; draw three blocks vertically to the left of the screen

; locj_6DD2:
.checkRight:
		bclr	#1,(a2)					; clear flag for redraw right (REV01 uses bit 0 for redraw right flag)
		beq.s	.return					; branch if already clear

		; Draw new tiles on the right
		move.w	#224/2,d4				; draw the bottom half of the screen
		move.w	#320,d5					; x coordinate - right of screen
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	#224/2,d4				; draw the bottom half of the screen
		move.w	#320,d5					; x coordinate - right of screen
		moveq	#3-1,d6					; draw three Blocks
		bsr.w	DrawBlocks_TB_2				; draw three blocks vertically to the right of the screen

; locj_6DF2:
.return:
		rts						; return
; End of function DrawBG_Bottom


; ===========================================================================
; ---------------------------------------------------------------------------
; Special drawing logic for SBZ background (REV01)
; ---------------------------------------------------------------------------

; locj_6DF4:
BG_ScrollBlockMap_SBZ:
		; Offsets to retrieve BG X-positions in DrawBG_XPos_Ptrs and DrawBG_XPosCopy_Ptrs (0/2/4/6)
		dc.b 0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,4	; $00-$F
		dc.b 4,4,4,4,4,4,2,2,2,2,2,2,2,2,2,2	; $10-$1F
		dc.b 2,0				; $20-21
; ===========================================================================

Draw_SBZ:
		moveq	#-16,d4					; draw 16px above top of screen
		bclr	#0,(a2)					; clear flag for redraw top
		bne.s	.drawTopOrBottom			; branch if it was set
		bclr	#1,(a2)					; clear flag for redraw bottom
		beq.s	.checkMore				; branch if already clear
		move.w	#224,d4					; draw at bottom of screen

; locj_6E28:
.drawTopOrBottom:
		lea	(BG_ScrollBlockMap_SBZ+1).l,a0		; +1 to offset -16
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		add.w	d4,d0					; d0 = v_bgscreenposy + (-16 or +224)
		andi.w	#$1F0,d0				; round down to nearest 16
		lsr.w	#4,d0					; divide by 16
		move.b	(a0,d0.w),d0				; retrieve offset value from input BG_ScrollBlockMap (0/2/4/6)
		lea	(DrawBG_XPosCopy_Ptrs).l,a3		; dc.w v_bg1_x_pos_copy, v_bg1_x_pos_copy, v_bg2_x_pos_copy, v_bg3_x_pos_copy
		movea.w	(a3,d0.w),a3				; get pointer to bg block 1/2/3 x pos
		beq.s	.bgXPos0				; branch if 0
		moveq	#-16,d5					; x coordinate - left of screen
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	Calc_VRAM_Pos				; d0 = VDP command for bg nametable
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		bsr.w	DrawBlocks_LR				; draw full row on top or bottom of screen
		bra.s	.checkMore				; check for more work to do

	; locj_6E5E:
	.bgXPos0:
		moveq	#0,d5					; clear X position (start at very left of screen)
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	Calc_VRAM_Pos_2				; get the plane position (ignore d5 = X width)
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		moveq	#(512/16)-1,d6				; draw entire row
		bsr.w	DrawBlocks_LR_3				; draw a horizontal line of blocks above or below the screen
; ---------------------------------------------------------------------------

; locj_6E72:
.checkMore:
		tst.b	(a2)					; are any other redraw flags set?
		bne.s	.more					; if yes, branch
		rts						; return

; locj_6E78:
.more:
		moveq	#-16,d4					; y coordinate - top of screen
		moveq	#-16,d5					; x coordinate - left of screen
		move.b	(a2),d0					; get remaining redraw flag bits
		andi.b	#%10101000,d0				; read bits 7, 5 and 3 only ($A8)
		beq.s	.doMore					; if none are set, branch
		lsr.b	#1,d0					; shift into bits 6, 4 and 2 respectively
		move.b	d0,(a2)					; set as new draw flag bits
		move.w	#320,d5					; x coordinate - right of screen

	; locj_6E8C:
	.doMore:
		lea	(BG_ScrollBlockMap_SBZ).l,a0		; load BG scroll map data for SBZ
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		andi.w	#$1F0,d0				; round down to nearest 16
		lsr.w	#4,d0					; divide by 16
		lea	(a0,d0.w),a0				; advance pointer inside scroll map data for current BG Y position
		bra.w	DrawBG_ColumnForBGIndex		; draw column
; ===========================================================================

; locj_6EA4: DrawBGScrollBlock3:
DrawBG_Block3:
		tst.b	(a2)					; are any redraw flags set?
		beq.w	.return					; if not, branch

		cmpi.b	#id_MZ,(v_zone).w			; is current zone MZ?
		beq.w	Draw_MZ					; if yes, branch

		bclr	#0,(a2)					; clear flag for redraw left
		beq.s	.checkRight				; branch if already clear

		; Draw new tiles on the left
		move.w	#64,d4					; y coordinate - fourth line from top of screen
		moveq	#-16,d5					; x coordinate - left of screen
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	#64,d4					; y coordinate - fourth line from top of screen
		moveq	#-16,d5					; x coordinate - left of screen
		moveq	#3-1,d6					; draw three blocks
		bsr.w	DrawBlocks_TB_2				; draw three blocks vertically to the left of the screen

; locj_6ED0:
.checkRight:
		bclr	#1,(a2)					; clear flag for redraw right
		beq.s	.return					; branch if already clear

		; Draw new tiles on the right
		move.w	#64,d4					; y coordinate - fourth line from top of screen
		move.w	#320,d5					; x coordinate - right of screen
		bsr.w	Calc_VRAM_Pos				; get the plane position
		move.w	#64,d4					; y coordinate - fourth line from top of screen
		move.w	#320,d5					; x coordinate - right of screen
		moveq	#3-1,d6					; draw three blocks
		bsr.w	DrawBlocks_TB_2				; draw three blocks vertically to the right of the screen

; locj_6EF0:
.return:
		rts						; return
; End of function Draw_SBZ

; ===========================================================================
; ---------------------------------------------------------------------------
; Special drawing logic for MZ background (REV01)
; ---------------------------------------------------------------------------

; locj_6EF2:
BG_ScrollBlockMap_MZ:
		; Offsets to retrieve BG X-positions in DrawBG_XPos_Ptrs and DrawBG_XPosCopy_Ptrs (0/2/4/6)
		dc.b 0,0,0,0,0,0,6,6,4,4,4,4,4,4,4,4	; $00-$0F
		dc.b 4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2	; $10-$1F
		dc.b 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2	; $20-$2F
		dc.b 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2	; $30-$3F
		dc.b 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2	; $40-$4F
		dc.b 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2	; $50-$5F
		dc.b 2,0				; $60-$61

; ===========================================================================

Draw_MZ:
		moveq	#-16,d4					; draw 16px above top of screen
		bclr	#0,(a2)					; clear flag for redraw top
		bne.s	.drawTopOrBottom			; branch if it was set
		bclr	#1,(a2)					; clear flag for redraw bottom
		beq.s	.checkMore				; branch if already clear
		move.w	#224,d4					; draw at bottom of screen

; locj_6F66:
.drawTopOrBottom:
		lea	(BG_ScrollBlockMap_MZ+1).l,a0		; +1 to offset -16
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		subi.w	#$200,d0				; minus 512
		add.w	d4,d0					; d0 = v_bgscreenposy - 512 + (-16 or +224)
		andi.w	#$7F0,d0				; limit to multiples of $10
		lsr.w	#4,d0					; divide by 16
		move.b	(a0,d0.w),d0				; retrieve offset value from input BG_ScrollBlockMap (0/2/4/6)
		movea.w	DrawBG_XPosCopy_Ptrs(pc,d0.w),a3	; use that value to retrieve relevant BG screen position data
		beq.s	.bgXPos0				; branch if 0
		moveq	#-16,d5					; x coordinate - left of screen
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	Calc_VRAM_Pos				; get the plane position
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		bsr.w	DrawBlocks_LR				; draw full row on top or bottom of screen
		bra.s	.checkMore				; check for more work to do

	; locj_6F9A:
	.bgXPos0:
		moveq	#0,d5					; clear X position (start at very left of screen)
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	Calc_VRAM_Pos_2				; get the plane position (ignore d5 = X width)
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		moveq	#(512/16)-1,d6				; set number of blocks to draw horizontally (entire plane's width)
		bsr.w	DrawBlocks_LR_3				; draw a horizontal line of blocks above or below the screen
; ---------------------------------------------------------------------------

; locj_6FAE:
.checkMore:
		tst.b	(a2)					; are any other redraw flags set?
		bne.s	.more					; if yes, branch
		rts						; return

; locj_6FB4:
.more:
		moveq	#-16,d4					; y coordinate - top of screen
		moveq	#-16,d5					; x coordinate - left of screen
		move.b	(a2),d0					; get remaining redraw flag bits
		andi.b	#%10101000,d0				; read bits 7, 5 and 3 only ($A8)
		beq.s	.doMore					; if none are set, branch
		lsr.b	#1,d0					; shift into bits 6, 4 and 2 respectively
		move.b	d0,(a2)					; set as new draw flag bits
		move.w	#320,d5					; x coordinate - right of screen

	; locj_6FC8:
	.doMore:
		lea	(BG_ScrollBlockMap_MZ).l,a0		; load BG scroll map data for MZ
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		subi.w	#$200,d0				; minus 512
		andi.w	#$7F0,d0				; limit to multiples of $10
		lsr.w	#4,d0					; divide by 16
		lea	(a0,d0.w),a0				; advance pointer inside scroll map data for current BG Y position
		bra.w	DrawBG_ColumnForBGIndex		; draw column
; End of function Draw_MZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw a full column for given BG camera positions (REV01)
;
; input:
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
;	a0.l = pointer inside given BG_ScrollBlockMap to retrieve DrawBG_XPosCopy_Ptrs values
;	a2.l = v_bg2_scroll_flags
; ---------------------------------------------------------------------------

; locj_6FE4:
DrawBG_XPosCopy_Ptrs:
		dc.w v_bgscreenposx_dup		; 0
		dc.w v_bgscreenposx_dup		; 2
		dc.w v_bg2screenposx_dup	; 4
		dc.w v_bg3screenposx_dup	; 6
; ===========================================================================

; locj_6FEC:
DrawBG_ColumnForBGIndex:
		moveq	#((224+16+16)/16)-1,d6			; prepare number of blocks (entire height of the screen + two extra rows)
		move.l	#$800000,d7				; prepare plane row advance rate ($80 bytes per row for *512 plane width)

; locj_6FF4:
.nextBlock:
		moveq	#0,d0					; clear d0
		move.b	(a0)+,d0				; retrieve next offset value from input BG_ScrollBlockMap (0/2/4/6)
		btst	d0,(a2)					; is matching redraw flag set?
		beq.s	.skipDraw				; if not, branch
		movea.w	DrawBG_XPosCopy_Ptrs(pc,d0.w),a3	; use that value to retrieve relevant BG screen position data
		movem.l	d4-d5/a0,-(sp)				; store X and Y positions, and BG_ScrollBlockMap pointer
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	GetBlockData				; load block
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		bsr.w	Calc_VRAM_Pos				; get the plane position
		bsr.w	DrawBlock				; draw the tiles from the block correctly
		movem.l	(sp)+,d4-d5/a0				; restore X and Y positions, and BG_ScrollBlockMap pointer

	; locj_701C:
	.skipDraw:
		addi.w	#16,d4					; advance Y position down by 1 block
		dbf	d6,.nextBlock				; repeat for number of blocks in the strip
		clr.b	(a2)					; clear all redraw flags
		rts						; return
; End of function DrawBG_ColumnForBGIndex


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


; ---------------------------------------------------------------------------
; Alternate version of DrawBlocks_LR_2 introduced in REV01,
; calling GetBlockData_2 instead (ignore d5 = screen X draw offset)
; ---------------------------------------------------------------------------

; DrawTiles_LR_3: DrawRow_IgnoreX:
DrawBlocks_LR_3:
		move.l	#$800000,d7				; prepare plane row advance rate ($80 bytes per row for *512 plane width)
		move.l	d0,d1					; store VDP plane address

	.nextBlock:
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	GetBlockData_2				; load block (skip d5 = X draw offset)
		move.l	d1,d0					; load VDP plane address
		bsr.w	DrawBlock				; draw the tiles from the block correctly
		addq.b	#4,d1					; increase VDP plane address to the right by 2 tiles (1 block)
		andi.b	#$7F,d1					; wrap if necessary
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		addi.w	#16,d5					; advance X position right by 1 block
		dbf	d6,.nextBlock				; repeat for number of blocks in the strip
		rts						; return
; End of function DrawBlocks_LR_3


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
; Subroutine to obtain the block data and address
;
; input:
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position (skipped for GetBlockData_2)
; 	a3.l = Screen position data
; 	a4.l = Layout address
;
; output:
; 	a0.l = Address of block ID in chunk RAM
; 	a1.l = Address of block
; ---------------------------------------------------------------------------

; DrawBlocks:
GetBlockData:
		add.w	(a3),d5					; add Screen X position

GetBlockData_2:
		add.w	4(a3),d4				; add Screen Y position
		lea	(v_16x16).w,a1				; load block RAM

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
		beq.s	.return					; if the chunk is 0, branch (chunk 0 is empty, no drawing necessary)

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
; 	d5.w = Screen X draw position (skipped for Calc_VRAM_Pos_2)
; 	a3.l = Screen position data
;
; output:
; 	d0.l = VDP control port address of plane position (words swapped for convenience)
; ---------------------------------------------------------------------------

; CalcPlaneC000:
Calc_VRAM_Pos:
		add.w	(a3),d5					; add Screen X position

Calc_VRAM_Pos_2:
		add.w	4(a3),d4				; add Screen Y position

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

		tst.b	(v_zone).w				; is current zone GHZ? (zone ID = 0)
		beq.w	Draw_GHZ_BG				; if yes, branch
		cmpi.b	#id_MZ,(v_zone).w			; is current zone MZ?
		beq.w	Draw_MZ_BG				; if yes, branch
		cmpi.w	#id_SBZ_act1,(v_zone_act).w		; is current level SBZ act 1?
		beq.w	Draw_SBZ_act1_BG			; if yes, branch
		cmpi.b	#id_EndZ,(v_zone).w			; is current zone the ending sequenc?
		beq.w	Draw_GHZ_BG				; if yes, branch (use GHZ)

		; fall-through to DrawChunks to draw level data to BG plane ($E000)...

; End of function LoadTilesFromStart


; ---------------------------------------------------------------------------
; Drawing an entire plane's worth of level graphics
; ---------------------------------------------------------------------------

; DrawLevel_FullPlane:
DrawChunks:
		moveq	#-16,d4					; start Y position at -16 (outside of screen)
		moveq	#((224+16+16)/16)-1,d6			; prepare number of blocks (entire height of the screen + two extra rows)

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


; ===========================================================================
; ---------------------------------------------------------------------------
; Initialize GHZ background on level start (REV01)
; ---------------------------------------------------------------------------

Draw_GHZ_BG:
		moveq	#0,d4					; start Y position at 0 (top of screen)
		moveq	#((224+16+16)/16)-1,d6			; prepare number of blocks (entire height of the screen + two extra rows)

	; locj_7224:
	.nextRow:
		movem.l	d4-d6,-(sp)				; store X position and "strip counter" data
		lea	(BG_ScrollBlockMap_GHZ).l,a0		; load BG scroll map data for GHZ
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		add.w	d4,d0					; d0 = v_bgscreenposy + (-16 or +224)
		andi.w	#$F0,d0					; limit to multiples of $10, up to one chunk
		bsr.w	DrawBG_RowForBGIndex			; draw row for BG index from scroll block data
		movem.l	(sp)+,d4-d6				; restore X position and "strip counter" data
		addi.w	#16,d4					; advance down to next row
		dbf	d6,.nextRow				; repeat for all horizontal row strips
		rts						; return
; ===========================================================================

; locj_724a:
BG_ScrollBlockMap_GHZ:
		; Offsets to retrieve BG X-positions in DrawBG_XPos_Ptrs and DrawBG_XPosCopy_Ptrs (0/2/4/6)
		dc.b 0,0,0,0,6,6,6,4,4,4,0,0,0,0,0,0	; $00-$0F
; End of function Draw_GHZ_BG


; ===========================================================================
; ---------------------------------------------------------------------------
; Initialize MZ background on level start (REV01)
; ---------------------------------------------------------------------------

; locj_725a:
Draw_MZ_BG:
		moveq	#-16,d4					; start Y position at -16 (outside of screen)
		moveq	#((224+16+16)/16)-1,d6			; prepare number of blocks (entire height of the screen + two extra rows)

	; locj_725E:
	.nextRow:
		movem.l	d4-d6,-(sp)				; store X position and "strip counter" data
		lea	(BG_ScrollBlockMap_MZ+1).l,a0		; +1 to offset -16
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		subi.w	#$200,d0				; minus 512
		add.w	d4,d0					; d0 = v_bgscreenposy - 512 + (-16 or +224)
		andi.w	#$7F0,d0				; limit to multiples of $10
		bsr.w	DrawBG_RowForBGIndex			; draw row for BG index from scroll block data
		movem.l	(sp)+,d4-d6				; restore X position and "strip counter" data
		addi.w	#16,d4					; advance down to next row
		dbf	d6,.nextRow				; repeat for all horizontal row strips
		rts						; return
; End of function Draw_MZ_BG


; ---------------------------------------------------------------------------
; Initialize SBZ act 1 background on level start (REV01)
; ---------------------------------------------------------------------------

; locj_7288: Draw_SBZ_BG:
Draw_SBZ_act1_BG:
		moveq	#-16,d4					; start Y position at -16 (outside of screen)
		moveq	#((224+16+16)/16)-1,d6			; prepare number of blocks (entire height of the screen + two extra rows)

	; locj_728C:
	.nextRow:
		movem.l	d4-d6,-(sp)				; store X position and "strip counter" data
		lea	(BG_ScrollBlockMap_SBZ+1).l,a0		; +1 to offset -16
		move.w	(v_bgscreenposy).w,d0			; get current BG Y position
		add.w	d4,d0					; d0 = v_bgscreenposy + (-16 or +224)
		andi.w	#$1F0,d0				; round down to nearest 16
		bsr.w	DrawBG_RowForBGIndex			; draw row for BG index from scroll block data
		movem.l	(sp)+,d4-d6				; restore X position and "strip counter" data
		addi.w	#16,d4					; advance down to next row
		dbf	d6,.nextRow				; repeat for all horizontal row strips
		rts						; return
; End of function Draw_SBZ_act1_BG


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to draw a full row for given BG camera positions (REV01)
;
; input:
; 	d0.w = v_bgscreenposy rounded down to multiples of $10 (may be limited)
; 	d4.w = Screen Y draw position
; 	d5.w = Screen X draw position
;	a0.l = base pointer to BG_ScrollBlockMap for zone (may be +1)
; ---------------------------------------------------------------------------

; locj_72B2:
DrawBG_XPos_Ptrs:
		dc.w v_bgscreenposx	; 0
		dc.w v_bgscreenposx	; 2
		dc.w v_bg2screenposx	; 4
		dc.w v_bg3screenposx	; 6
; ---------------------------------------------------------------------------

; locj_72Ba:
DrawBG_RowForBGIndex:
		lsr.w	#4,d0					; divide input camera Y position by 16
		move.b	(a0,d0.w),d0				; retrieve offset value from input BG_ScrollBlockMap (0/2/4/6)
		movea.w	DrawBG_XPos_Ptrs(pc,d0.w),a3		; use that value to retrieve relevant BG screen position data
		beq.s	.bgXPos0				; branch if 0
		moveq	#-16,d5					; x coordinate - left of screen
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	Calc_VRAM_Pos				; get the plane position
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		bsr.w	DrawBlocks_LR				; draw full row on top or bottom of screen
		bra.s	.return					; return

	; locj_72da:
	.bgXPos0:
		moveq	#0,d5					; clear X position (start at very left of screen)
		movem.l	d4-d5,-(sp)				; store X and Y positions
		bsr.w	Calc_VRAM_Pos_2				; get the plane position (ignore d5 = X width)
		movem.l	(sp)+,d4-d5				; restore X and Y positions
		moveq	#(512/16)-1,d6				; set number of blocks to draw horizontally (entire plane's width)
		bsr.w	DrawBlocks_LR_3				; draw a horizontal line of blocks above or below the screen

; locj_72EE:
.return:
		rts						; return
; End of function DrawBG_RowForBGIndex
