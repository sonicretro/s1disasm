; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to show the special stage layout
; ---------------------------------------------------------------------------

SS_ShowLayout:
		bsr.w	SS_AnimateBlocks			; animate walls, rings, and other blocks
		bsr.w	SS_ExecuteAnimationQueue		; animate queued events for touched blocks
; ---------------------------------------------------------------------------

	; --- Calculate the rotated position of the layout grid ---
		move.w	d5,-(sp)				; backup sprites rendered in BuildSprites (which is called before SS_ShowLayout)

		lea	(v_ss_rotationmatrix).w,a1		; set start of rotation buffer (each entry is two words per cell, X/Y axis)
		move.b	(v_ssangle).w,d0			; get current angle of the special stage rotation
		andi.b	#$FC,d0					; snap to nearest multiple of 4 to match stage rotation
		jsr	(CalcSine).l				; get sine and cosine values based on angle
		move.w	d0,d4					; backup sine result
		move.w	d1,d5					; backup cosine result
		muls.w	#ss_blocksize,d4			; d4 = X-rotation delta after each cell
		muls.w	#ss_blocksize,d5			; d5 = Y-rotation delta after each cell

		moveq	#0,d2					; clear d2
		move.w	(v_screenposx).w,d2			; get current camera X-position
		divu.w	#ss_blocksize,d2			; divide camera X-position by block size
		swap	d2					; get remainder (modulo part)
		neg.w	d2					; make remainder negative
		addi.w	#-(ss_matrixsize-1)*ss_blocksize/2,d2	; d2 = base X-offset for all cells (-$B4)

		moveq	#0,d3					; clear d3
		move.w	(v_screenposy).w,d3			; get current camera Y-position
		divu.w	#ss_blocksize,d3			; divide camera X-position by block size
		swap	d3					; get remainder (modulo part)
		neg.w	d3					; make remainder negative
		addi.w	#-(ss_matrixsize-1)*ss_blocksize/2,d3	; d3 = base Y-offset for all cells (-$B4)

		move.w	#ss_matrixsize-1,d7			; calculate rotated positions for all rows
	.rotateRows:
		movem.w	d0-d2,-(sp)				; backup sine, cosine, and X offset per row

		movem.w	d0-d1,-(sp)				; backup sine and cosine
		neg.w	d0					; negate sine for X-rotation term
		muls.w	d2,d1					; X * cos
		muls.w	d3,d0					; Y * -sin
		move.l	d0,d6					; copy
		add.l	d1,d6					; d6 = rotated X-position
		movem.w	(sp)+,d0-d1				; restore sine and cosine
		muls.w	d2,d0					; X * sin
		muls.w	d3,d1					; Y * cos
		add.l	d0,d1					; d1 = rotated Y-position
		move.l	d6,d2					; d2 = rotated X-position

		move.w	#ss_matrixsize-1,d6			; calculate rotated positions for all cells in this row
	.rotateCellsInRow:
		move.l	d2,d0					; get X-position
		asr.l	#8,d0					; shift down a byte
		move.w	d0,(a1)+				; write rotated X-position for cell
		move.l	d1,d0					; get Y-position
		asr.l	#8,d0					; shift down a byte
		move.w	d0,(a1)+				; write rotated Y-position for cell
		add.l	d5,d2					; increase Y-position by cosine Y-delta for next cell
		add.l	d4,d1					; increase Y-position by sine X-delta for next cell
		dbf	d6,.rotateCellsInRow			; loop until all cells for this row have been calculated

		movem.w	(sp)+,d0-d2				; restore sine, cosine, and X offset for next row

		addi.w	#ss_blocksize,d3			; increase base Y-position by block height
		dbf	d7,.rotateRows				; loop until all rows have been calculated

		move.w	(sp)+,d5				; restore number of rendered sprites in BuildSprites

	; --- Insert block types into rotated grid and render them as sprites ---
		lea	(v_sslayout_base).l,a0			; get base pointer for stage layout

		moveq	#0,d0					; clear d0
		move.w	(v_screenposy).w,d0			; get current camera Y-position
		divu.w	#ss_blocksize,d0			; divide camera Y-position by block size
		mulu.w	#ss_layout_rowlength,d0			; multiply by length of rows
		adda.l	d0,a0					; a0 = first row to be rendered

		moveq	#0,d0					; clear d0
		move.w	(v_screenposx).w,d0			; get current camera X-position
		divu.w	#ss_blocksize,d0			; divide camera X-position by block size
		adda.w	d0,a0					; a0 = first row and cell to be rendered

		lea	(v_ss_rotationmatrix).w,a4		; get calculated results in rotation matrix
		move.w	#ss_matrixsize-1,d7			; render 16 rows
	.loopAllRows:
		move.w	#ss_matrixsize-1,d6			; render 16 blocks per row
	.loopRow:
		moveq	#0,d0					; clear d0
		move.b	(a0)+,d0				; get next block ID
		beq.s	.nextBlock				; if it's a blank block, branch
		cmpi.b	#id_SS_Glass_Ani4,d0			; is block ID greater than the last possible one? ($4E)
		bhi.s	.nextBlock				; if yes, render empty block instead

		move.w	(a4),d3					; get rotated X-position for this cell
		addi.w	#128+(320/2),d3				; d3 = sprite X-position
		cmpi.w	#128-16,d3				; is sprite offscreen to the left?
		blo.s	.nextBlock				; if yes, skip drawing
		cmpi.w	#128+320+16,d3				; is sprite offscreen to the right?
		bhs.s	.nextBlock				; if yes, skip drawing

		move.w	2(a4),d2				; get rotated Y-position for this cell
		addi.w	#128+(224/2),d2				; d2 = sprite Y-position
		cmpi.w	#128-16,d2				; is sprite offscreen to the top?
		blo.s	.nextBlock				; if yes, skip drawing
		cmpi.w	#128+224+16,d2				; is sprite offscreen to the bottom?
		bhs.s	.nextBlock				; if yes, skip drawing

		lea	(v_ss_spritesettings).l,a5		; load block definitions array
		lsl.w	#3,d0					; multiply by 8 bytes per entry
		lea	(a5,d0.w),a5				; get data for block ID
		movea.l	(a5)+,a1				; get mappings pointer
		move.w	(a5)+,d1				; get frame ID
		add.w	d1,d1					; double for word-based indexing
		adda.w	(a1,d1.w),a1				; get mappings for current frame
		movea.w	(a5)+,a3				; get art tile / VRAM settings
		moveq	#1-1,d1					; write 1 sprite piece by default
		move.b	(a1)+,d1				; get number of sprite pieces in frame
		subq.b	#1,d1					; subtract 1 for dbf
		bmi.s	.nextBlock				; if result underflowed, this is was blank frame mapping, branch
		jsr	(BuildSpr_Normal).l			; write data from sprite pieces to buffer (never flipped)

	.nextBlock:
		addq.w	#4,a4					; advance to next entry in rotation matrix
		dbf	d6,.loopRow				; loop until all blocks in row have been rendered
		lea	spritelayer_size-ss_matrixsize(a0),a0	; advance to next row ($80 bytes - 16 bytes that were already advanced)
		dbf	d7,.loopAllRows				; loop until all rows were rendered

		move.b	d5,(v_spritecount).w			; write total number of rendered sprites to debug value

		cmpi.b	#sprites_max,d5				; check sprite limit (Mega Drive can only handle 80 at a time)
		beq.s	.spriteLimit				; if all sprite slots are taken up, abort process

		move.l	#0,(a2)					; unlink last sprite
		rts						; return
; ---------------------------------------------------------------------------

	.spriteLimit:
		move.b	#0,-5(a2)				; unlink penultimate sprite
		rts						; return
; End of function SS_ShowLayout


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate blocks (walls, rings, etc.) in the Special Stage
; ---------------------------------------------------------------------------

; SS_AniWallsRings:
SS_AnimateBlocks:
	; --- Rotate square walls ---
		lea	(v_ss_spritesettings+8+5-1).l,a1	; load sprite settings array, skip blank and target frame ID (word, +5-1)
		moveq	#0,d0					; clear d0
		move.b	(v_ssangle).w,d0			; get current rotation angle
		lsr.b	#2,d0					; divide by 4 (walls are snapped to multiples of 4 degrees)
		andi.w	#$F,d0					; limit to 16 rotations
		moveq	#id_SS_WallGreen_8-1,d1			; rotate all wall blocks (id_SS_WallGreen_8 = last one = $24)
	.rotateWalls:
		move.w	d0,(a1)					; set new frame ID to rotated one
		addq.w	#8,a1					; advance to next wall sprite setting
		dbf	d1,.rotateWalls				; loop until all walls have been rotated

	; --- Animate rings (8 frames) ---
		lea	(v_ss_spritesettings+5).l,a1		; load sprite settings array, target frame ID (byte, +5)
		subq.b	#1,(v_ani1_time).w			; decrement delay until ring animation needs to update
		bpl.s	.updateRingFrame			; if time remains, branch
		move.b	#8-1,(v_ani1_time).w			; reset delay
		addq.b	#1,(v_ani1_frame).w			; advance frame ID
		andi.b	#3,(v_ani1_frame).w			; wrap around every 8 frames
	.updateRingFrame:
		move.b	(v_ani1_frame).w,8*id_SS_Ring(a1)	; set new ring frame ID

	; --- Animate various other blocks (2 frames) ---
		subq.b	#1,(v_ani2_time).w			; decrement delay until frames need to update
		bpl.s	.updateAlternatingFrames		; if time remains, branch
		move.b	#8-1,(v_ani2_time).w			; reset delay
		addq.b	#1,(v_ani2_frame).w			; advance frame ID
		andi.b	#1,(v_ani2_frame).w			; alternate between only two frames
	.updateAlternatingFrames:
		move.b	(v_ani2_frame).w,d0			; get current alternating frame ID
		move.b	d0,8*id_SS_GOAL(a1)			; animate goal blocks
		move.b	d0,8*id_SS_RedWhite(a1)			; animate red/white blocks
		move.b	d0,8*id_SS_UP(a1)			; animate UP blocks
		move.b	d0,8*id_SS_DOWN(a1)			; animate DOWN blocks
		move.b	d0,8*id_SS_Emerald1_Blue(a1)		; animate emerald 1 (blue)
		move.b	d0,8*id_SS_Emerald2_Yellow(a1)		; animate emerald 2 (yellow)
		move.b	d0,8*id_SS_Emerald3_Pink(a1)		; animate emerald 3 (pink)
		move.b	d0,8*id_SS_Emerald4_Green(a1)		; animate emerald 4 (green)
		move.b	d0,8*id_SS_Emerald5_Red(a1)		; animate emerald 5 (red)
		move.b	d0,8*id_SS_Emerald6_Grey(a1)		; animate emerald 6 (grey)

	; --- Animate glass blocks (8 frames) ---
		subq.b	#1,(v_ani3_time).w			; decrement delay until glass frames needs to update
		bpl.s	.updateGlassFrames			; if time remains, branch
		move.b	#5-1,(v_ani3_time).w			; reset delay
		addq.b	#1,(v_ani3_frame).w			; advance frame ID
		andi.b	#3,(v_ani3_frame).w			; wrap around every 8 frames
	.updateGlassFrames:
		move.b	(v_ani3_frame).w,d0			; get current glass frame ID
		move.b	d0,8*id_SS_Glass1_Blue(a1)		; update glass block 1 (blue)
		move.b	d0,8*id_SS_Glass2_Green(a1)		; update glass block 2 (green)
		move.b	d0,8*id_SS_Glass3_Yellow(a1)		; update glass block 3 (yellow)
		move.b	d0,8*id_SS_Glass4_Pink(a1)		; update glass block 4 (pink)

	; ---  Animate wall palette cycle (unlike the other animations above, this affects VRAM settings instead of frame ID) ---
		subq.b	#1,(v_ani0_time).w			; decrement delay until wall palettes need to update
		bpl.s	.updateWallPalettes			; if time remains, branch
		move.b	#8-1,(v_ani0_time).w			; reset delay
		subq.b	#1,(v_ani0_frame).w			; advance frame ID (backwards)
		andi.b	#7,(v_ani0_frame).w			; wrap around every 8 frames
	.updateWallPalettes:
		lea	(v_ss_spritesettings+8+8+6).l,a1	; load sprite settings array, skip blank, first wall, and target VRAM settings (word, +6)
		lea	(SS_Wall_Palettes_VRAM).l,a0		; load wall VRAM settings, containing the palette line bits
		moveq	#0,d0					; clear d0
		move.b	(v_ani0_frame).w,d0			; get current frame
		add.w	d0,d0					; double for word-based indexing
		lea	(a0,d0.w),a0				; jump to current start in VRAM settings array

	rept 4	; Repeated four times to account for the four sets of walls (blue, yellow, green, pink)
		move.w	$0(a0),8*0(a1)				; update wall 1
		move.w	$2(a0),8*1(a1)				; update wall 2
		move.w	$4(a0),8*2(a1)				; update wall 3
		move.w	$6(a0),8*3(a1)				; update wall 4
		move.w	$8(a0),8*4(a1)				; update wall 5
		move.w	$A(a0),8*5(a1)				; update wall 6
		move.w	$C(a0),8*6(a1)				; update wall 7
		move.w	$E(a0),8*7(a1)				; update wall 8

		adda.w	#2*$10,a0				; advance to next set of VRAM settings for next wall set
		adda.w	#8*9,a1					; advance to next set of walls (0 walls are skipped, thus never changing palette)
	endr

		rts						; return

; ---------------------------------------------------------------------------
; Palette cycle data for square blocks in Special Stages.
; - Four sets for the four wall types. Each set has same blinking pattern:
;   nBnnnnnB twice (n = normal palette, B = blinking palette)
; - Blinking palette line is the one before the normal one (i.e. -1)
; - All values are technically complete VRAM settings with the art tile,
;   but the only difference between each value is the palette line
; ---------------------------------------------------------------------------

sswallpal: macro paletteline
	normal: = ArtTile_SS_Wall|(paletteline<<13)
	blink:  = ArtTile_SS_Wall|(((paletteline-1)&3)<<13)
	rept 2
		dc.w normal,  blink, normal, normal
		dc.w normal, normal, normal,  blink
	endr
	endm

; SS_WaRiVramSet:
SS_Wall_Palettes_VRAM:
		sswallpal 0	; blue walls
		sswallpal 1	; yellow walls
		sswallpal 2	; green walls
		sswallpal 3	; pink walls
		even
; End of function SS_AnimateBlocks


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a free slot in the Special Stage sprite update list,
; used to animate blocks collected/touched by Sonic.
; ---------------------------------------------------------------------------

; SS_RemoveCollectedItem: <-- old misnomer
SS_FindFreeAnimationSlot:
		lea	(v_ss_animations).l,a2			; address of sprite update list
		move.w	#(v_ss_animations_end-v_ss_animations)/8-1,d0 ; up to $20 slots

	.loop:
		tst.b	(a2)					; is slot free?
		beq.s	.return					; if yes, exit with it
		addq.w	#8,a2					; go to next slot
		dbf	d0,.loop				; try again

	.return:
		rts						; return with slot in a2
; End of function SS_FindFreeAnimationSlot


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate special stage items when you touch them.
; This system uses a buffer of animation events that are added through the
; above SS_FindFreeAnimationSlot subroutine.
; 
; Each slot is 8 bytes in size, broken down like so:
;	0   - animation ID (1-based; zero implies empty slot)
;	1   - (unused)
;	2   - frame delay between animation advancements
;	3   - current index ID in animation script
;	4-7 - RAM location of target block in stage layout
; ---------------------------------------------------------------------------
ss_ani_id:	equ 0
ss_ani_delay:	equ 2
ss_ani_frame:	equ 3
ss_ani_block:	equ 4
; ---------------------------------------------------------------------------

; SS_AniItems:
SS_ExecuteAnimationQueue:
		lea	(v_ss_animations).l,a0			; load start address of animation event buffer
		move.w	#(v_ss_animations_end-v_ss_animations)/8-1,d7 ; set to iterate through all slots

	.loop:
		moveq	#0,d0					; clear d0
		move.b	ss_ani_id(a0),d0			; get potential animation event
		beq.s	.nextslot				; if slot has none, branch
		lsl.w	#2,d0					; multiply ID by 4 for long-based indexing
		movea.l	SS_AniIndex-4(pc,d0.w),a1		; get animation entry in jump table (-4 because these IDs are 1-based)
		jsr	(a1)					; execute animation and return

	.nextslot:
		addq.w	#8,a0					; go to next animation event slot
		dbf	d7,.loop				; loop until all event slots were checked
		rts						; return

; ===========================================================================
SS_AniIndex:	dc.l SS_AniRingSparks				; animation ID 1
		dc.l SS_AniBumper				; animation ID 2
		dc.l SS_Ani1Up					; animation ID 3
		dc.l SS_AniReverse				; animation ID 4
		dc.l SS_AniEmeraldSparks			; animation ID 5
		dc.l SS_AniGlassBlock				; animation ID 6
; ===========================================================================

SS_AniRingSparks:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#5,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0					; clear d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniRingData(pc,d0.w),d0		; retrieve new block ID from animation script
		move.b	d0,(a1)					; update block in layout
		bne.s	.return					; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

	.return:
		rts						; return
; ===========================================================================
SS_AniRingData:	dc.b id_SS_Ring_Ani1, id_SS_Ring_Ani2, id_SS_Ring_Ani3, id_SS_Ring_Ani4, 0
		even
; ===========================================================================

SS_AniBumper:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#7,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0					; clear d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniBumpData(pc,d0.w),d0		; retrieve new block ID from animation script
		bne.s	.animating				; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

		move.b	#id_SS_Bumper,(a1)			; reset bumper block to default idle one
		rts						; return
; ---------------------------------------------------------------------------

	.animating:
		move.b	d0,(a1)					; update block in layout

	.return:
		rts						; return
; ===========================================================================
SS_AniBumpData:	dc.b id_SS_Bumper_Ani1, id_SS_Bumper_Ani2, id_SS_Bumper_Ani1, id_SS_Bumper_Ani2, 0
		even
; ===========================================================================

SS_Ani1Up:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#5,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0					; clear d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_Ani1UpData(pc,d0.w),d0		; retrieve new block ID from animation script
		move.b	d0,(a1)					; update block in layout
		bne.s	.return					; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

	.return:
		rts						; return
; ===========================================================================
SS_Ani1UpData:	dc.b id_SS_Emerald_Ani1, id_SS_Emerald_Ani2, id_SS_Emerald_Ani3, id_SS_Emerald_Ani4, 0
		even
; ===========================================================================

SS_AniReverse:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#7,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0					; clear d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniRevData(pc,d0.w),d0		; retrieve new block ID from animation script
		bne.s	.animating				; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

		move.b	#id_SS_R,(a1)				; reset R block to default idle one
		rts
; ---------------------------------------------------------------------------

	.animating:
		move.b	d0,(a1)					; update block in layout

	.return:
		rts						; return
; ===========================================================================
SS_AniRevData:	dc.b id_SS_R, id_SS_R_Ani, id_SS_R, id_SS_R_Ani, 0
		even
; ===========================================================================

SS_AniEmeraldSparks:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#5,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0					; clear d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniEmerData(pc,d0.w),d0		; retrieve new block ID from animation script
		move.b	d0,(a1)					; update block in layout
		bne.s	.return					; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

		move.b	#4,(v_player+obRoutine).w		; set object 09 to SonicSS_ExitStage (this triggers the actual exit)
		move.w	#sfx_SSGoal,d0				; set special stage GOAL sound
		jsr	(QueueSound2).l				; play it

	.return:
		rts						; return
; ===========================================================================
SS_AniEmerData:	dc.b id_SS_Emerald_Ani1, id_SS_Emerald_Ani2, id_SS_Emerald_Ani3, id_SS_Emerald_Ani4, 0
		even
; ===========================================================================

SS_AniGlassBlock:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#1,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0					; clear d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniGlassData(pc,d0.w),d0		; retrieve new block ID from animation script
		move.b	d0,(a1)					; update block in layout
		bne.s	.return					; if animation isn't finished, branch

		move.b	ss_ani_block(a0),(a1)			; update glass with weaker version (see SonicSS_GlassUpdate)

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

	.return:
		rts						; return
; ===========================================================================
SS_AniGlassData:dc.b id_SS_Glass_Ani1, id_SS_Glass_Ani2, id_SS_Glass_Ani3, id_SS_Glass_Ani4
		dc.b id_SS_Glass_Ani1, id_SS_Glass_Ani2, id_SS_Glass_Ani3, id_SS_Glass_Ani4, 0
		even
; ===========================================================================

; End of function SS_AniItems


; ===========================================================================
; ---------------------------------------------------------------------------
; Special stage layout pointers
; ---------------------------------------------------------------------------
SS_LayoutIndex:
		dc.l SS_1
		dc.l SS_2
		dc.l SS_3
		dc.l SS_4
		dc.l SS_5
		dc.l SS_6

	if ((*-SS_LayoutIndex)/4<>ss_emeralds_num)
		warning "SS_LayoutIndex does not match expected emerald count!"
	endif

		even

; ---------------------------------------------------------------------------
; Special stage start locations
; (Previously separated into "_inc/Start Location Array - Special Stages.asm")
; ---------------------------------------------------------------------------

SS_StartLoc:
		binclude	"startpos/Special Stages/ss1.bin"
		binclude	"startpos/Special Stages/ss2.bin"
		binclude	"startpos/Special Stages/ss3.bin"
		binclude	"startpos/Special Stages/ss4.bin"
		binclude	"startpos/Special Stages/ss5.bin"
		binclude	"startpos/Special Stages/ss6.bin"

	if ((*-SS_StartLoc)/4<>ss_emeralds_num)
		warning "SS_StartLoc does not match expected emerald count!"
	endif

		even

; ---------------------------------------------------------------------------
; Subroutine to load special stage layout
; ---------------------------------------------------------------------------

SS_Load:
		moveq	#0,d0					; clear d0
		move.b	(v_lastspecial).w,d0			; load number of last special stage entered (0-5)
		addq.b	#1,(v_lastspecial).w			; remember new last-visited special stage number
		cmpi.b	#ss_emeralds_num,(v_lastspecial).w	; has it wrapped over the maximum?
		blo.s	SS_FindUnbeatenStage			; if not, branch
		move.b	#0,(v_lastspecial).w			; reset if higher than 6

SS_FindUnbeatenStage:
		; Skip special stages whose emerald has already been collected. The game cycles through stage IDs
		; using v_lastspecial: If the selected stage matches an entry in v_emldlist, execution branches
		; back to SS_Load and the next stage is selected. This repeats until an unbeaten stage is found.
		cmpi.b	#ss_emeralds_num,(v_emeralds).w		; do you already have all emeralds?
		beq.s	SS_LoadData				; if yes, load stage anyway (should not happen, probably a failsafe)
		moveq	#0,d1					; clear d1
		move.b	(v_emeralds).w,d1			; get number of already collected emeralds
		subq.b	#1,d1					; subtract 1 for dbf
		blo.s	SS_LoadData				; if it underflowed, no emeralds have been collected so far
		lea	(v_emldlist).w,a3			; load array of already collected emeralds
	.chkEmldLoop:
		cmp.b	(a3,d1.w),d0				; does this collected emerald belong to the selected stage?
		bne.s	.chkNext				; if not, check the next entry
		bra.s	SS_Load					; repeat SS_Load, increase v_lastspecial, try another stage
	.chkNext:
		dbf	d1,.chkEmldLoop				; check all collected emeralds

; ---------------------------------------------------------------------------

; d0 = special stage to load (0-5)
SS_LoadData:
	; --- Load start positions for Sonic ---
		lsl.w	#2,d0					; multiply by 4 for long-based indexing
		lea	SS_StartLoc(pc,d0.w),a1			; load Sonic's start location for this stage
		move.w	(a1)+,(v_player+obX).w			; set start X-position
		move.w	(a1)+,(v_player+obY).w			; set start Y-position

	; --- Decompress Enigma-compressed special stage layout to a temporary buffer ---
		movea.l	SS_LayoutIndex(pc,d0.w),a0		; load compressed special stage layout
		lea	(v_sslayout_decompress).l,a1		; set decompression buffer for layout
		move.w	#0,d0					; no added art tile settings
		jsr	(EniDec).l				; decompress special stage layout to buffer

	; --- Fully clear target layout buffer ---
		lea	(v_sslayout_base).l,a1			; set start address of layout RAM
		move.w	#(v_sslayout_decompress-v_sslayout_base)/4-1,d0 ; clear the entire layout buffer
	.clearLayoutBuffer:
		clr.l	(a1)+					; clear four bytes
		dbf	d0,.clearLayoutBuffer			; loop until buffer has been cleared

	; --- Copy decompressed layout to the final buffer, inserting $40 bytes of padding per row ---
		lea	(v_sslayout_actual).l,a1		; set target layout destination after padding
		lea	(v_sslayout_decompress).l,a0		; load decompressed layout data
		moveq	#(v_sslayout_end-v_sslayout_actual)/ss_layout_rowlength-1,d1 ; transfer the full layout
	.copyAllRows:
		moveq	#(ss_layout_rowlength/2)-1,d2		; set to transfer one row ($40 bytes of actual data)
	.copyRow:
		move.b	(a0)+,(a1)+				; transfer one cell to final layout buffer
		dbf	d2,.copyRow				; loop until row has been transferred
		lea	ss_layout_rowlength/2(a1),a1		; advance to next row ($40 bytes of padding)
		dbf	d1,.copyAllRows				; loop until all rows have been transferred

	; --- Load all sprite settings from SS_MapIndex into v_ss_spritesettings ---
		lea	(v_ss_spritesettings+8).l,a1		; skip first entry (for block $00 / blank)
		lea	(SS_MapIndex).l,a0			; load block sprite info definitions
		moveq	#(SS_MapIndex_End-SS_MapIndex)/6-1,d1	; load all entries in definitions list
	.loadSpriteSettings:
		move.l	(a0)+,(a1)+				; copy frame ID and mappings pointer
		move.w	#0,(a1)+				; prepare two empty bytes (upper one remains unused)
		move.b	-4(a0),-1(a1)				; copy frame ID to lower byte
		move.w	(a0)+,(a1)+				; load VRAM settings (palette and art tile)
		dbf	d1,.loadSpriteSettings			; loop until all sprite settings have been loaded

	; --- Fully clear animations processing queue ---
		lea	(v_ss_animations).l,a1			; set start address of animations queue
		move.w	#(v_ss_animations_end-v_ss_animations)/4-1,d1 ; clear the entire queue
	.clearAnimationQueue:
		clr.l	(a1)+					; clear four bytes
		dbf	d1,.clearAnimationQueue			; loop until queue has been cleared

		rts						; return
; End of function SS_Load
