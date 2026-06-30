; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate level graphics
; ---------------------------------------------------------------------------

AnimateLevelGfx:
		tst.w	(f_pause).w				; is the game paused?
		bne.s	.isPaused				; if yes, branch

		lea	(vdp_data_port).l,a6			; prepare VDP data port (shared by all gfx routines)
		bsr.w	AniArt_GiantRing			; load giant ring graphics, if necessary

		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current zone ID
		add.w	d0,d0					; double for word-based indexing
		move.w	AniArt_Index(pc,d0.w),d0		; find entry in jump table
		jmp	AniArt_Index(pc,d0.w)			; jump to animation routine for current Zone
; ---------------------------------------------------------------------------

	.isPaused:
		rts						; don't animate level gfx while paused
; End of function AnimateLevelGfx

; ===========================================================================
AniArt_Index:	dc.w AniArt_GHZ-AniArt_Index			; GHZ
		dc.w AniArt_none-AniArt_Index			; LZ (empty)
		dc.w AniArt_MZ-AniArt_Index			; MZ
		dc.w AniArt_none-AniArt_Index			; SLZ (empty)
		dc.w AniArt_none-AniArt_Index			; SYZ (empty)
		dc.w AniArt_SBZ-AniArt_Index			; SBZ
		zonewarning AniArt_Index,2
		dc.w AniArt_Ending-AniArt_Index			; Ending Sequence
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Green Hill
; ---------------------------------------------------------------------------

AniArt_GHZ:

AniArt_GHZ_Waterfall:
		.size:	= 8					; number of tiles per frame

		subq.b	#1,(v_lani0_time).w			; decrement timer
		bpl.s	AniArt_GHZ_Bigflower			; if time remains, branch 

		move.b	#6-1,(v_lani0_time).w			; time to display each frame
		lea	(Art_GhzWater).l,a1			; load waterfall patterns
		move.b	(v_lani0_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani0_frame).w			; increment frame counter
		andi.w	#1,d0					; there are only 2 frames
		beq.s	.isFrame0				; branch if frame 0
		lea	.size*tile_size(a1),a1			; use graphics for frame 1
	.isFrame0:
		locVRAM	ArtTile_GHZ_Waterfall*tile_size		; VRAM address
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ===========================================================================

AniArt_GHZ_Bigflower:
		.size:	= 16					; number of tiles per frame

		subq.b	#1,(v_lani1_time).w			; decrement timer
		bpl.s	AniArt_GHZ_Smallflower			; if time remains, branch

		move.b	#16-1,(v_lani1_time).w			; time to display each frame
		lea	(Art_GhzFlower1).l,a1			; load big flower patterns
		move.b	(v_lani1_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani1_frame).w			; increment frame counter
		andi.w	#1,d0					; there are only 2 frames
		beq.s	.isFrame0				; branch if frame 0
		lea	.size*tile_size(a1),a1			; use graphics for frame 1
	.isFrame0:
		locVRAM	ArtTile_GHZ_Big_Flower_1*tile_size	; VRAM address
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ===========================================================================

AniArt_GHZ_Smallflower:
		.size:	= 12					; number of tiles per frame

		subq.b	#1,(v_lani2_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.b	#8-1,(v_lani2_time).w			; time to display each frame
		move.b	(v_lani2_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani2_frame).w			; increment frame counter
		andi.w	#3,d0					; there are 4 frames
		move.b	.flowerSeq(pc,d0.w),d0			; get current flower frame (0-2)
		btst	#0,d0					; is frame 0 or 2? (actual frame, not frame counter)
		bne.s	.isFrame1				; if not, branch
		move.b	#128-1,(v_lani2_time).w			; set longer duration for frames 0 and 2
	.isFrame1:
		lsl.w	#7,d0					; multiply frame num by $80
		move.w	d0,d1					; multiply that by 3 (i.e. frame num times 12 * $20)
		add.w	d0,d0					; ''
		add.w	d1,d0					; ''
		locVRAM	ArtTile_GHZ_Small_Flower*tile_size	; VRAM address
		lea	(Art_GhzFlower2).l,a1			; load small flower patterns
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#.size-1,d1				; number of 8x8 tiles
		bsr.w	LoadTiles				; transfer tiles to VRAM

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.flowerSeq:	; Sequence of frame offsets for small flowers
		dc.b 0,	1, 2, 1

; End of function AniArt_GHZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Marble
; ---------------------------------------------------------------------------

AniArt_MZ:

AniArt_MZ_Lava:
		.size:	= 8					; number of tiles per frame

		subq.b	#1,(v_lani0_time).w			; decrement timer
		bpl.s	AniArt_MZ_Magma				; if time remains, branch

		move.b	#20-1,(v_lani0_time).w			; time to display each frame
		lea	(Art_MzLava1).l,a1			; load lava surface patterns
		moveq	#0,d0					; clear d0
		move.b	(v_lani0_frame).w,d0			; get current frame ID
		addq.b	#1,d0					; increment frame counter
		cmpi.b	#3,d0					; there are 3 frames
		bne.s	.notFrame3				; branch if frame 0, 1 or 2
		moveq	#0,d0					; clear d0
	.notFrame3:
		move.b	d0,(v_lani0_frame).w			; set new frame
		mulu.w	#.size*tile_size,d0			; multiply frame by size of tiles in VRAM
		adda.w	d0,a1					; jump to appropriate tile
		locVRAM	ArtTile_MZ_Animated_Lava*tile_size	; VRAM address
		move.w	#.size-1,d1				; number of 8x8 tiles
		bsr.w	LoadTiles				; transfer tiles to VRAM
; ---------------------------------------------------------------------------

AniArt_MZ_Magma:
		subq.b	#1,(v_lani1_time).w			; decrement timer
		bpl.s	AniArt_MZ_Torch				; if time remains, branch
		
		move.b	#2-1,(v_lani1_time).w			; time between each gfx change
		moveq	#0,d0					; clear d0
		move.b	(v_lani0_frame).w,d0			; get surface lava frame number
		lea	(Art_MzLava2).l,a4			; load magma gfx
		ror.w	#7,d0					; multiply frame num by $200
		adda.w	d0,a4					; jump to appropriate tile
		locVRAM	ArtTile_MZ_Animated_Magma*tile_size	; VRAM address
		moveq	#0,d3					; clear d3
		move.b	(v_lani1_frame).w,d3			; get current frame ID
		addq.b	#1,(v_lani1_frame).w			; increment frame counter (unused)
		move.b	(v_oscillate+$A).w,d3			; get oscillating value
		move.w	#4-1,d2					; number of frames to animate in the level
	.loop:
		move.w	d3,d0					; copy sinewave sync position
		add.w	d0,d0					; multiply by 2 (size of word from jump table)
		andi.w	#$1E,d0					; keep in multiples of $10 bytes of art ($10 routines each)
		lea	(AniArt_MZMagma).l,a3			; load magma routines list
		move.w	(a3,d0.w),d0				; load correct relative address
		lea	(a3,d0.w),a3				; add and jump to correct address (correct pixel/byte position)
		movea.l	a4,a1					; load uncompressed art ($20x$20 pixel tile)
		move.w	#$20-1,d1				; set number of 8 pixel lines to write in a column (4 bytes each)
		jsr	(a3)					; draw the column correctly in the 8 pixels of this column
		addq.w	#4,d3					; increase sinewave position right by 4 bytes (a single tile)
		dbf	d2,.loop				; repeat for all four columns of tiles

		rts						; return
; ===========================================================================

AniArt_MZ_Torch:
		.size:	= 6					; number of tiles per frame

		subq.b	#1,(v_lani2_time).w			; decrement timer
		bpl.w	.return					; if time remains, branch
		
		move.b	#8-1,(v_lani2_time).w			; time to display each frame
		lea	(Art_MzTorch).l,a1			; load torch patterns
		moveq	#0,d0					; clear d0
		move.b	(v_lani3_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani3_frame).w			; increment frame counter
		andi.b	#3,(v_lani3_frame).w			; there are 3 frames
		mulu.w	#.size*tile_size,d0			; multiply frame by size of tiles in VRAM
		adda.w	d0,a1					; jump to appropriate tile
		locVRAM	ArtTile_MZ_Torch*tile_size		; VRAM address
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ---------------------------------------------------------------------------

	.return:
		rts						; return
; End of function AniArt_MZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Scrap Brain
; ---------------------------------------------------------------------------

AniArt_SBZ:

AniArt_SBZ_Pollution:
		.size:	= 12					; number of tiles per frame

.check_smokePuff1:
		tst.b	(v_lani2_frame).w			; check primary smokepuff timer
		beq.s	.smokePuff1				; branch if counter hit 0
		
		subq.b	#1,(v_lani2_frame).w			; decrement counter
		bra.s	.check_smokePuff2			; check secondary smoke puff
; ---------------------------------------------------------------------------

	.smokePuff1:
		subq.b	#1,(v_lani0_time).w			; decrement timer
		bpl.s	.check_smokePuff2			; if time remains, branch
		
		move.b	#8-1,(v_lani0_time).w			; time to display each frame
		lea	(Art_SbzSmoke).l,a1			; load smoke patterns
		locVRAM	ArtTile_SBZ_Smoke_Puff_1*tile_size	; VRAM address
		move.b	(v_lani0_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani0_frame).w			; increment frame counter
		andi.w	#7,d0					; there are 8 frames
		beq.s	.untilNextPuff1				; branch if frame 0

		subq.w	#1,d0					; make frame 0-based
		mulu.w	#.size*tile_size,d0			; multiply frame by size of tiles in VRAM
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ---------------------------------------------------------------------------

	.untilNextPuff1:
		move.b	#3*60,(v_lani2_frame).w			; time between smoke puffs (3 seconds)
; ---------------------------------------------------------------------------

.clearSky:
		move.w	#(.size/2)-1,d1				; number of 8x8 tiles
		bsr.w	LoadTiles				; transfer tiles to VRAM

		lea	(Art_SbzSmoke).l,a1			; load start of tiles (blank)
		move.w	#(.size/2)-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; load blank tiles for no smoke puff
; ===========================================================================

.check_smokePuff2:
		tst.b	(v_lani2_time).w			; check secondary smokepuff timer
		beq.s	.smokePuff2				; branch if counter hits 0
		
		subq.b	#1,(v_lani2_time).w			; decrement counter
		bra.s	.return					; exit
; ---------------------------------------------------------------------------

	.smokePuff2:
		subq.b	#1,(v_lani1_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch
		
		move.b	#8-1,(v_lani1_time).w			; time to display each frame
		lea	(Art_SbzSmoke).l,a1			; load smoke patterns
		locVRAM	ArtTile_SBZ_Smoke_Puff_2*tile_size	; VRAM address
		move.b	(v_lani1_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani1_frame).w			; increment frame counter
		andi.w	#7,d0					; there are 8 frames
		beq.s	.untilNextPuff2				; branch if frame 0

		subq.w	#1,d0					; make frame 0-based
		mulu.w	#.size*tile_size,d0			; multiply frame by size of tiles in VRAM
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ---------------------------------------------------------------------------

	.untilNextPuff2:
		move.b	#2*60,(v_lani2_time).w			; time between smoke puffs (2 seconds)
		bra.s	.clearSky				; clear the skies
; ---------------------------------------------------------------------------

	.return:
		rts						; return
; End of function AniArt_SBZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - ending sequence
; ---------------------------------------------------------------------------

AniArt_Ending:

AniArt_Ending_BigFlower:
		.size:	= 16					; number of tiles per frame

		subq.b	#1,(v_lani1_time).w			; decrement timer
		bpl.s	AniArt_Ending_SmallFlower		; if time remains, branch
		
		move.b	#8-1,(v_lani1_time).w			; time to display each frame
		lea	(Art_GhzFlower1).l,a1			; load big flower patterns
		lea	(v_256x256_def+$4A*chunk_size).w,a2	; load 2nd big flower from RAM (overwriting unused chunk RAM)
		move.b	(v_lani1_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani1_frame).w			; increment frame counter
		andi.w	#1,d0					; there are only 2 frames
		beq.s	.isFrame0				; branch if frame 0
		lea	.size*tile_size(a1),a1			; load second frame
		lea	.size*tile_size(a2),a2			; ''
	.isFrame0:
		locVRAM	ArtTile_GHZ_Big_Flower_1*tile_size	; VRAM address
		move.w	#.size-1,d1				; number of 8x8 tiles
		bsr.w	LoadTiles				; transfer tiles to VRAM

		movea.l	a2,a1					; load sunflower (wall) art address
		locVRAM	ArtTile_GHZ_Big_Flower_2*tile_size	; VRAM address
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ===========================================================================

AniArt_Ending_SmallFlower:
		.size:	= 12					; number of tiles per frame

		subq.b	#1,(v_lani2_time).w			; decrement timer
		bpl.s	AniArt_Ending_Flower3			; if time remains, branch
		
		move.b	#8-1,(v_lani2_time).w			; time to display each frame
		move.b	(v_lani2_frame).w,d0			; get current frame ID3
		addq.b	#1,(v_lani2_frame).w			; increment frame counter
		andi.w	#7,d0					; there are 8 frames
		move.b	AniArt_Ending_Flower2_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#7,d0					; multiply frame num by $80
		move.w	d0,d1					; multiply that by 3 (i.e. frame num times 12 * $20)
		add.w	d0,d0					; ''
		add.w	d1,d0					; ''
		locVRAM	ArtTile_GHZ_Small_Flower*tile_size	; VRAM address
		lea	(Art_GhzFlower2).l,a1			; load small flower patterns
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ===========================================================================
AniArt_Ending_Flower2_sequence:
		dc.b 0, 0, 0, 1, 2, 2, 2, 1
; ===========================================================================

AniArt_Ending_Flower3:
		.size:	= 16					; number of tiles per frame

		subq.b	#1,(v_lani4_time).w			; decrement timer
		bpl.s	AniArt_Ending_Flower4			; if time remains, branch
		
		move.b	#15-1,(v_lani4_time).w			; time to display each frame
		move.b	(v_lani4_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani4_frame).w			; increment frame counter
		andi.w	#3,d0					; there are 4 frames
		move.b	AniArt_Ending_Flower3_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#8,d0					; multiply by $100
		add.w	d0,d0					; multiply by 2
		locVRAM	ArtTile_GHZ_Flower_3*tile_size		; VRAM address
		lea	(v_256x256_def+$4C*chunk_size).w,a1	; load special flower patterns from RAM (overwriting unused chunk RAM)
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; ===========================================================================
AniArt_Ending_Flower3_sequence:
AniArt_Ending_Flower4_sequence:
		dc.b 0,	1, 2, 1
; ===========================================================================

AniArt_Ending_Flower4:
		.size:	= 16					; number of tiles per frame

		subq.b	#1,(v_lani5_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch
		
		move.b	#12-1,(v_lani5_time).w			; time to display each frame
		move.b	(v_lani5_frame).w,d0			; get current frame ID
		addq.b	#1,(v_lani5_frame).w			; increment frame counter
		andi.w	#3,d0					; there are 4 frames
		move.b	AniArt_Ending_Flower4_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#8,d0					; multiply by $100
		add.w	d0,d0					; multiply by 2
		locVRAM	ArtTile_GHZ_Flower_4*tile_size		; VRAM address
		lea	(v_256x256_def+$4F*chunk_size).w,a1	; load special flower patterns from RAM (overwriting unused chunk RAM)
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM

	.return:
		rts						; return
; End of function AniArt_Ending


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - zones without animated gfx (LZ, SLZ, SYZ)
; ---------------------------------------------------------------------------

AniArt_none:
		rts						; do nothing
; End of function AniArt_none


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to transfer raw tile data to VRAM
; 
; input:
; 	a1 = source address
; 	a6 = vdp_data_port ($C00000)
; 	d1 = number of tiles to transfer (minus one)
; ---------------------------------------------------------------------------

LoadTiles:
	rept 8							; 1 tile requires 8 longword transfers
		move.l	(a1)+,(a6)				; transfer 1/8th of a tile and advance source pointer
	endr
		dbf	d1,LoadTiles				; loop for number of tiles
		rts						; return
; End of function LoadTiles


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Marble Zone (Magma byte precision write)
; ---------------------------------------------------------------------------
AniArt_MZMagma:	dc.w	.magma_0123-AniArt_MZMagma		; 0 1 2 3
		dc.w	.magma_1234-AniArt_MZMagma		; 1 2 3 4
		dc.w	.magma_2345-AniArt_MZMagma		; 2 3 4 5
		dc.w	.magma_3456-AniArt_MZMagma		; 3 4 5 6
		dc.w	.magma_4567-AniArt_MZMagma		; 4 5 6 7
		dc.w	.magma_5678-AniArt_MZMagma		; 5 6 7 8
		dc.w	.magma_6789-AniArt_MZMagma		; 6 7 8 9
		dc.w	.magma_789A-AniArt_MZMagma		; 7 8 9 A
		dc.w	.magma_89AB-AniArt_MZMagma		; 8 9 A B
		dc.w	.magma_9ABC-AniArt_MZMagma		; 9 A B C
		dc.w	.magma_ABCD-AniArt_MZMagma		; A B C D
		dc.w	.magma_BCDE-AniArt_MZMagma		; B C D E
		dc.w	.magma_CDEF-AniArt_MZMagma		; C D E F
		dc.w	.magma_DEF0-AniArt_MZMagma		; D E F 0
		dc.w	.magma_EF01-AniArt_MZMagma		; E F 0 1
		dc.w	.magma_F012-AniArt_MZMagma		; F 0 1 2

; ---------------------------------------------------------------------------
.magma_0123:	; ****------------
		move.l	(a1),(a6)				; write art starting from 0 (0, 1, 2, 3)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_0123				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_1234:	; -****-----------
		move.l	2(a1),d0				; load art starting from 2
		move.b	1(a1),d0				; load art from 1 at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from 1, 2, 3, 4
		move.l	d0,(a6)					; write art starting from 1 (1, 2, 3, 4)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_1234				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_2345:	; --****----------
		move.l	2(a1),(a6)				; write art starting from 2 (2, 3, 4, 5)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_2345				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_3456:	; ---****---------
		move.l	4(a1),d0				; load art starting from 4
		move.b	3(a1),d0				; load art from 3 at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from 3, 4, 5, 6
		move.l	d0,(a6)					; write art starting from 3 (3, 4, 5, 6)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_3456				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_4567:	; ----****--------
		move.l	4(a1),(a6)				; write art starting from 4 (4, 5, 6, 7)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_4567				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_5678:	; -----****-------
		move.l	6(a1),d0				; load art starting from 6
		move.b	5(a1),d0				; load art from 5 at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from 5, 6, 7, 8
		move.l	d0,(a6)					; write art starting from 5 (5, 6, 7, 8)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_5678				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_6789:	; ------****------
		move.l	6(a1),(a6)				; write art starting from 6 (6, 7, 8, 9)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_6789				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_789A:	; -------****-----
		move.l	8(a1),d0				; load art starting from 8
		move.b	7(a1),d0				; load art from 7 at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from 7, 8, 9, A
		move.l	d0,(a6)					; write art starting from 7 (7, 8, 9, A)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_789A				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_89AB:	; --------****----
		move.l	8(a1),(a6)				; write art starting from 8 (8, 9, A, B)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_89AB				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_9ABC:	; ---------****---
		move.l	$A(a1),d0				; load art starting from A
		move.b	9(a1),d0				; load art from 9 at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from 9, A, B, C
		move.l	d0,(a6)					; write art starting from 9 (9, A, B, C)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_9ABC				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_ABCD:	; ----------****--
		move.l	$A(a1),(a6)				; write art starting from A (A, B, C, D)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_ABCD				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_BCDE:	; -----------****-
		move.l	$C(a1),d0				; load art starting from C
		move.b	$B(a1),d0				; load art from B at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from B, C, D, E
		move.l	d0,(a6)					; write art starting from B (B, C, D, E)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_BCDE				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_CDEF:	; ------------****
		move.l	$C(a1),(a6)				; write art starting from C (C, D, E, F)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_CDEF				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_DEF0:	; *------------***
		move.l	$C(a1),d0				; load art starting from C
		rol.l	#8,d0					; move it up (start from D)
		_move.b	0(a1),d0				; load art from 0 on the end
		move.l	d0,(a6)					; write art starting from D (D, E, F, 0)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_DEF0				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_EF01:	; **------------**
		move.w	$E(a1),(a6)				; write art starting from E (E, F)
		_move.w	0(a1),(a6)				; write art ending at 1 (0, 1) (E, F, 0, 1)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_EF01				; repeat until the column is written
		rts						; return
; ---------------------------------------------------------------------------
.magma_F012:	; ***------------*
		_move.l	0(a1),d0				; load art starting from 0
		move.b	$F(a1),d0				; load art from F at the end
		ror.l	#8,d0					; rotate so that a long-word is loaded from F, 0, 1, 2
		move.l	d0,(a6)					; write art starting from F (F, 0, 1, 2)
		lea	$10(a1),a1				; advance to next line
		dbf	d1,.magma_F012				; repeat until the column is written
		rts						; return
; End of function AniArt_MZMagma


; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - load uncompressed Giant Ring patterns
; The graphics are loaded incrementally at 14 tiles per frame.
; This gets triggered from GRing_Okay by setting v_gfxbigring to:
; Art_BigRing_size = 98 tiles * tile_size = $C40
; ---------------------------------------------------------------------------

AniArt_GiantRing:
		tst.w	(v_gfxbigring).w			; are giant ring graphics set to be loaded?
		bne.s	.loadTiles				; if so, get to work
		rts						; nothing to do
; ---------------------------------------------------------------------------

	.loadTiles:
		.size:	= 14					; number of tiles to load per frame

		subi.w	#.size*tile_size,(v_gfxbigring).w	; count-down the 14 tiles we're going to load now
		lea	(Art_BigRing).l,a1			; load uncompressed giant ring patterns
		moveq	#0,d0					; clear d0
		move.w	(v_gfxbigring).w,d0			; load current tile offset for giant ring patterns
		lea	(a1,d0.w),a1				; jump to appropriate tile in patterns

		; Turn VRAM address into VDP command
		addi.w	#ArtTile_Giant_Ring*tile_size,d0	; advance to starting VRAM address of giant ring
		lsl.l	#2,d0					; push upper address bits into upper word
		lsr.w	#2,d0					; send rest back
		ori.w	#$4000,d0				; set VDP mode bits (VRAM write mode)
		swap	d0					; align for VDP in order
		move.l	d0,4(a6)				; send VDP command (write to VRAM at address contained in v_gfxbigring)

		move.w	#.size-1,d1				; number of 8x8 tiles
		bra.w	LoadTiles				; transfer tiles to VRAM
; End of function AniArt_GiantRing
