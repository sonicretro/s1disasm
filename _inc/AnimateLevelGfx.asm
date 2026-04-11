; ---------------------------------------------------------------------------
; Subroutine to animate level graphics
; ---------------------------------------------------------------------------

AnimateLevelGfx:
		tst.w	(f_pause).w	; is the game paused?
		bne.s	.ispaused	; if yes, branch
		lea	(vdp_data_port).l,a6
		bsr.w	AniArt_GiantRing
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	AniArt_Index(pc,d0.w),d0
		jmp	AniArt_Index(pc,d0.w)

.ispaused:
		rts

; ===========================================================================
AniArt_Index:	dc.w AniArt_GHZ-AniArt_Index	; GHZ
		dc.w AniArt_none-AniArt_Index	; LZ (unused)
		dc.w AniArt_MZ-AniArt_Index	; MZ
		dc.w AniArt_none-AniArt_Index	; SLZ (unused)
		dc.w AniArt_none-AniArt_Index	; SYZ (unused)
		dc.w AniArt_SBZ-AniArt_Index	; SBZ
		zonewarning AniArt_Index,2
		dc.w AniArt_Ending-AniArt_Index	; ending sequence

; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Green Hill
; ---------------------------------------------------------------------------

AniArt_GHZ:

AniArt_GHZ_Waterfall:

.size		= 8	; number of tiles per frame

		subq.b	#1,(v_lani0_time).w ; decrement timer
		bpl.s	AniArt_GHZ_Bigflower ; branch if not 0

		move.b	#6-1,(v_lani0_time).w ; time to display each frame
		lea	(Art_GhzWater).l,a1 ; load waterfall patterns
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,(v_lani0_frame).w ; increment frame counter
		andi.w	#1,d0		; there are only 2 frames
		beq.s	.isframe0	; branch if frame 0
		lea	.size*tile_size(a1),a1 ; use graphics for frame 1

.isframe0:
		locVRAM	ArtTile_GHZ_Waterfall*tile_size		; VRAM address
		move.w	#.size-1,d1	; number of 8x8 tiles
		bra.w	LoadTiles
; ===========================================================================

AniArt_GHZ_Bigflower:

.size		= 16	; number of tiles per frame

		subq.b	#1,(v_lani1_time).w
		bpl.s	AniArt_GHZ_Smallflower

		move.b	#$10-1,(v_lani1_time).w
		lea	(Art_GhzFlower1).l,a1 ; load big flower patterns
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w
		andi.w	#1,d0
		beq.s	.isframe0
		lea	.size*tile_size(a1),a1

.isframe0:
		locVRAM	ArtTile_GHZ_Big_Flower_1*tile_size
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================

AniArt_GHZ_Smallflower:

.size		= 12	; number of tiles per frame

		subq.b	#1,(v_lani2_time).w
		bpl.s	.end

		move.b	#8-1,(v_lani2_time).w
		move.b	(v_lani2_frame).w,d0
		addq.b	#1,(v_lani2_frame).w ; increment frame counter
		andi.w	#3,d0		; there are 4 frames
		move.b	.sequence(pc,d0.w),d0
		btst	#0,d0		; is frame 0 or 2? (actual frame, not frame counter)
		bne.s	.isframe1	; if not, branch
		move.b	#$7F,(v_lani2_time).w ; set longer duration for frames 0 and 2

.isframe1:
		lsl.w	#7,d0		; multiply frame num by $80
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0		; multiply that by 3 (i.e. frame num times 12 * $20)
		locVRAM	ArtTile_GHZ_Small_Flower*tile_size
		lea	(Art_GhzFlower2).l,a1 ; load small flower patterns
		lea	(a1,d0.w),a1	; jump to appropriate tile
		move.w	#.size-1,d1
		bsr.w	LoadTiles

.end:
		rts

.sequence:	dc.b 0,	1, 2, 1
; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Marble
; ---------------------------------------------------------------------------

AniArt_MZ:

AniArt_MZ_Lava:

.size		= 8	; number of tiles per frame

		subq.b	#1,(v_lani0_time).w ; decrement timer
		bpl.s	AniArt_MZ_Magma	; branch if not 0

		move.b	#$14-1,(v_lani0_time).w ; time to display each frame
		lea	(Art_MzLava1).l,a1 ; load lava surface patterns
		moveq	#0,d0
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,d0		; increment frame counter
		cmpi.b	#3,d0		; there are 3 frames
		bne.s	.frame01or2	; branch if frame 0, 1 or 2
		moveq	#0,d0

.frame01or2:
		move.b	d0,(v_lani0_frame).w
		mulu.w	#.size*tile_size,d0
		adda.w	d0,a1		; jump to appropriate tile
		locVRAM	ArtTile_MZ_Animated_Lava*tile_size
		move.w	#.size-1,d1
		bsr.w	LoadTiles

AniArt_MZ_Magma:
		subq.b	#1,(v_lani1_time).w ; decrement timer
		bpl.s	AniArt_MZ_Torch	; branch if not 0
		
		move.b	#2-1,(v_lani1_time).w ; time between each gfx change
		moveq	#0,d0
		move.b	(v_lani0_frame).w,d0 ; get surface lava frame number
		lea	(Art_MzLava2).l,a4 ; load magma gfx
		ror.w	#7,d0		; multiply frame num by $200
		adda.w	d0,a4		; jump to appropriate tile
		locVRAM	ArtTile_MZ_Animated_Magma*tile_size
		moveq	#0,d3
		move.b	(v_lani1_frame).w,d3
		addq.b	#1,(v_lani1_frame).w ; increment frame counter (unused)
		move.b	(v_oscillate+$A).w,d3 ; get oscillating value
		move.w	#3,d2

.loop:
		move.w	d3,d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	(AniArt_MZextra).l,a3
		move.w	(a3,d0.w),d0
		lea	(a3,d0.w),a3
		movea.l	a4,a1
		move.w	#$1F,d1
		jsr	(a3)
		addq.w	#4,d3
		dbf	d2,.loop
		rts
; ===========================================================================

AniArt_MZ_Torch:

.size		= 6	; number of tiles per frame

		subq.b	#1,(v_lani2_time).w ; decrement timer
		bpl.w	.end		; branch if not 0
		
		move.b	#8-1,(v_lani2_time).w ; time to display each frame
		lea	(Art_MzTorch).l,a1 ; load torch patterns
		moveq	#0,d0
		move.b	(v_lani3_frame).w,d0
		addq.b	#1,(v_lani3_frame).w ; increment frame counter
		andi.b	#3,(v_lani3_frame).w ; there are 3 frames
		mulu.w	#.size*tile_size,d0
		adda.w	d0,a1		; jump to appropriate tile
		locVRAM	ArtTile_MZ_Torch*tile_size
		move.w	#.size-1,d1
		bra.w	LoadTiles

.end:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Scrap Brain
; ---------------------------------------------------------------------------

AniArt_SBZ:

.size		= 12	; number of tiles per frame

		tst.b	(v_lani2_frame).w
		beq.s	.smokepuff	; branch if counter hits 0
		
		subq.b	#1,(v_lani2_frame).w ; decrement counter
		bra.s	.chk_smokepuff2
; ===========================================================================

.smokepuff:
		subq.b	#1,(v_lani0_time).w ; decrement timer
		bpl.s	.chk_smokepuff2 ; branch if not 0
		
		move.b	#8-1,(v_lani0_time).w ; time to display each frame
		lea	(Art_SbzSmoke).l,a1 ; load smoke patterns
		locVRAM	ArtTile_SBZ_Smoke_Puff_1*tile_size
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,(v_lani0_frame).w ; increment frame counter
		andi.w	#7,d0
		beq.s	.untilnextpuff	; branch if frame 0
		subq.w	#1,d0
		mulu.w	#.size*tile_size,d0
		lea	(a1,d0.w),a1
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================

.untilnextpuff:
		move.b	#180,(v_lani2_frame).w ; time between smoke puffs (3 seconds)

.clearsky:
		move.w	#(.size/2)-1,d1
		bsr.w	LoadTiles
		lea	(Art_SbzSmoke).l,a1
		move.w	#(.size/2)-1,d1
		bra.w	LoadTiles	; load blank tiles for no smoke puff
; ===========================================================================

.chk_smokepuff2:
		tst.b	(v_lani2_time).w
		beq.s	.smokepuff2	; branch if counter hits 0
		
		subq.b	#1,(v_lani2_time).w ; decrement counter
		bra.s	.end
; ===========================================================================

.smokepuff2:
		subq.b	#1,(v_lani1_time).w ; decrement timer
		bpl.s	.end		; branch if not 0
		
		move.b	#8-1,(v_lani1_time).w ; time to display each frame
		lea	(Art_SbzSmoke).l,a1 ; load smoke patterns
		locVRAM	ArtTile_SBZ_Smoke_Puff_2*tile_size
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w ; increment frame counter
		andi.w	#7,d0
		beq.s	.untilnextpuff2	; branch if frame 0
		subq.w	#1,d0
		mulu.w	#.size*tile_size,d0
		lea	(a1,d0.w),a1
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================

.untilnextpuff2:
		move.b	#120,(v_lani2_time).w ; time between smoke puffs (2 seconds)
		bra.s	.clearsky
; ===========================================================================

.end:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - ending sequence
; ---------------------------------------------------------------------------

AniArt_Ending:

AniArt_Ending_BigFlower:

.size		= 16	; number of tiles per frame

		subq.b	#1,(v_lani1_time).w ; decrement timer
		bpl.s	AniArt_Ending_SmallFlower ; branch if not 0
		
		move.b	#8-1,(v_lani1_time).w
		lea	(Art_GhzFlower1).l,a1 ; load big flower patterns
		lea	(v_128x128+$20*chunk_size_128).l,a2 ; load 2nd big flower from RAM (overwriting unused chunk RAM)
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w ; increment frame counter
		andi.w	#1,d0		; only 2 frames
		beq.s	.isframe0	; branch if frame 0
		lea	.size*tile_size(a1),a1
		lea	.size*tile_size(a2),a2

.isframe0:
		locVRAM	ArtTile_GHZ_Big_Flower_1*tile_size
		move.w	#.size-1,d1
		bsr.w	LoadTiles
		movea.l	a2,a1
		locVRAM	ArtTile_GHZ_Big_Flower_2*tile_size
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================

AniArt_Ending_SmallFlower:

.size		= 12	; number of tiles per frame

		subq.b	#1,(v_lani2_time).w ; decrement timer
		bpl.s	AniArt_Ending_Flower3 ; branch if not 0
		
		move.b	#8-1,(v_lani2_time).w
		move.b	(v_lani2_frame).w,d0
		addq.b	#1,(v_lani2_frame).w ; increment frame counter
		andi.w	#7,d0		; max 8 frames
		move.b	.sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#7,d0		; multiply by $80
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0		; multiply by 3
		locVRAM	ArtTile_GHZ_Small_Flower*tile_size
		lea	(Art_GhzFlower2).l,a1 ; load small flower patterns
		lea	(a1,d0.w),a1	; jump to appropriate tile
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================
.sequence:	dc.b 0,	0, 0, 1, 2, 2, 2, 1
; ===========================================================================

AniArt_Ending_Flower3:

.size		= 16	; number of tiles per frame

		subq.b	#1,(v_lani4_time).w ; decrement timer
		bpl.s	AniArt_Ending_Flower4 ; branch if not 0
		
		move.b	#$F-1,(v_lani4_time).w
		move.b	(v_lani4_frame).w,d0
		addq.b	#1,(v_lani4_frame).w ; increment frame counter
		andi.w	#3,d0		; max 4 frames
		move.b	AniArt_Ending_Flower3_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#8,d0		; multiply by $100
		add.w	d0,d0		; multiply by 2
		locVRAM	ArtTile_GHZ_Flower_3*tile_size
		lea	(v_128x128+$28*chunk_size_128).l,a1 ; load special flower patterns from RAM (overwriting unused chunk RAM)
		lea	(a1,d0.w),a1	; jump to appropriate tile
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================
AniArt_Ending_Flower3_sequence:	dc.b 0,	1, 2, 1
; ===========================================================================

AniArt_Ending_Flower4:

.size		= 16	; number of tiles per frame

		subq.b	#1,(v_lani5_time).w ; decrement timer
		bpl.s	.end		; branch if not 0
		
		move.b	#$C-1,(v_lani5_time).w
		move.b	(v_lani5_frame).w,d0
		addq.b	#1,(v_lani5_frame).w ; increment frame counter
		andi.w	#3,d0
		move.b	AniArt_Ending_Flower3_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#8,d0		; multiply by $100
		add.w	d0,d0		; multiply by 2
		locVRAM	ArtTile_GHZ_Flower_4*tile_size
		lea	(v_128x128+$34*chunk_size_128).l,a1 ; load special flower patterns from RAM (overwriting unused chunk RAM)
		lea	(a1,d0.w),a1	; jump to appropriate tile
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================

.end:
		rts
; ===========================================================================

AniArt_none:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to transfer graphics to VRAM

; input:
; a1 = source address
; a6 = vdp_data_port ($C00000)
; d1 = number of tiles to load (minus one)
; ---------------------------------------------------------------------------


LoadTiles:
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		dbf	d1,LoadTiles
		rts
; End of function LoadTiles

; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - more Marble Zone
; ---------------------------------------------------------------------------
AniArt_MZextra:	dc.w AniArt_MZ_Magma_Shift0_Col0-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift1_Col0-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift2_Col0-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift3_Col0-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift0_Col1-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift1_Col1-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift2_Col1-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift3_Col1-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift0_Col2-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift1_Col2-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift2_Col2-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift3_Col2-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift0_Col3-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift1_Col3-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift2_Col3-AniArt_MZextra
		dc.w AniArt_MZ_Magma_Shift3_Col3-AniArt_MZextra
; ===========================================================================

; loc_1C3EE:
AniArt_MZ_Magma_Shift0_Col0:
		move.l	(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col0
		rts
; ===========================================================================

; loc_1C3FA:
AniArt_MZ_Magma_Shift1_Col0:
		move.l	2(a1),d0
		move.b	1(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col0
		rts
; ===========================================================================

; loc_1C410:
AniArt_MZ_Magma_Shift2_Col0:
		move.l	2(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col0
		rts
; ===========================================================================

; loc_1C41E:
AniArt_MZ_Magma_Shift3_Col0:
		move.l	4(a1),d0
		move.b	3(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col0
		rts
; ===========================================================================

; loc_1C434:
AniArt_MZ_Magma_Shift0_Col1:
		move.l	4(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col1
		rts
; ===========================================================================

; loc_1C442:
AniArt_MZ_Magma_Shift1_Col1:
		move.l	6(a1),d0
		move.b	5(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col1
		rts
; ===========================================================================

; loc_1C458:
AniArt_MZ_Magma_Shift2_Col1:
		move.l	6(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col1
		rts
; ===========================================================================

; loc_1C466:
AniArt_MZ_Magma_Shift3_Col1:
		move.l	8(a1),d0
		move.b	7(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col1
		rts
; ===========================================================================

; loc_1C47C:
AniArt_MZ_Magma_Shift0_Col2:
		move.l	8(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col2
		rts
; ===========================================================================

; loc_1C48A:
AniArt_MZ_Magma_Shift1_Col2:
		move.l	$A(a1),d0
		move.b	9(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col2
		rts
; ===========================================================================

; loc_1C4A0:
AniArt_MZ_Magma_Shift2_Col2:
		move.l	$A(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col2
		rts
; ===========================================================================

; loc_1C4AE:
AniArt_MZ_Magma_Shift3_Col2:
		move.l	$C(a1),d0
		move.b	$B(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col2
		rts
; ===========================================================================

; loc_1C4C4:
AniArt_MZ_Magma_Shift0_Col3:
		move.l	$C(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col3
		rts
; ===========================================================================

; loc_1C4D2:
AniArt_MZ_Magma_Shift1_Col3:
		move.l	$C(a1),d0
		rol.l	#8,d0
		_move.b	0(a1),d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col3
		rts
; ===========================================================================

; loc_1C4E8:
AniArt_MZ_Magma_Shift2_Col3:
		move.w	$E(a1),(a6)
		_move.w	0(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col3
		rts
; ===========================================================================

; loc_1C4FA:
AniArt_MZ_Magma_Shift3_Col3:
		_move.l	0(a1),d0
		move.b	$F(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col3
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - giant ring
; ---------------------------------------------------------------------------

AniArt_GiantRing:

.size		= 14

		tst.w	(v_gfxbigring).w	; Is there any of the art left to load?
		bne.s	.loadTiles		; If so, get to work
		rts
; ===========================================================================
; loc_1C518:
.loadTiles:
		subi.w	#.size*tile_size,(v_gfxbigring).w	; Count-down the 14 tiles we're going to load now
		lea	(Art_BigRing).l,a1 ; load giant ring patterns
		moveq	#0,d0
		move.w	(v_gfxbigring).w,d0
		lea	(a1,d0.w),a1
		; Turn VRAM address into VDP command
		addi.w	#ArtTile_Giant_Ring*tile_size,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		; Send VDP command (write to VRAM at address contained in v_gfxbigring)
		move.l	d0,4(a6)

		move.w	#.size-1,d1
		bra.w	LoadTiles

; End of function AniArt_GiantRing
