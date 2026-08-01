; ===========================================================================
; ---------------------------------------------------------------------------
; Special stage	background mappings loading subroutine
; ---------------------------------------------------------------------------

SS_BGLoad:
	; --- Load mappings for the birds and fish ---
		ssbg_animalsize:	equ 8

		lea	(v_ram_start).l,a1			; buffer
		lea	(Eni_SSBg1).l,a0			; load mappings for the birds and fish
		move.w	#ArtTile_SS_Background_Fish|Tile_Pal3,d0 ; add this to each tile
		bsr.w	EniDec					; decompress fish/bird mappings to RAM

		locVRAM	ArtTile_SS_Plane_1*tile_size+$1000,d3	; d3 = VDP address for $5000 in VRAM
		lea	(v_ram_start+(ssbg_animalsize*ssbg_animalsize*2)).l,a2
		moveq	#7-1,d7					; number of canvases for frames of bird/fish and in-between

; Each frame of bird/fish animation is stored as a canvas in VRAM. The game switches between them by changing the BG nametable register.
.loop_canvas:
		move.l	d3,d0					; copy VDP command
		moveq	#4-1,d6					; number of rows visible
		moveq	#0,d4					; first square is blank (i.e. blank-bird-blank-bird-etc.)
		cmpi.w	#4-1,d7
		bhs.s	.loop_rows				; branch if canvas is bird
		moveq	#1,d4					; first square is fish (i.e. fish-blank-fish-blank-etc.)

.loop_rows:
		moveq	#8-1,d5					; number of squares in a row

.loop_birdfish:
		movea.l	a2,a1					; get address of tilemap as stored in RAM
		eori.b	#1,d4					; switch between blank square and bird/fish
		bne.s	.is_birdfish				; branch if set to bird/fish
		cmpi.w	#7-1,d7
		bne.s	.skip_birdfish				; branch if not first frame
		lea	(v_ram_start).l,a1			; use tilemap for checkerboard pattern

	.is_birdfish:
		movem.l	d0-d4,-(sp)
		moveq	#ssbg_animalsize-1,d1
		moveq	#ssbg_animalsize-1,d2
		bsr.w	TilemapToVRAM				; copy tilemap for 1 bird or fish from RAM to VRAM
		movem.l	(sp)+,d0-d4

	.skip_birdfish:
		addi.l	#(ssbg_animalsize*2)<<16,d0		; skip 8 cells ($10 bytes)
		dbf	d5,.loop_birdfish			; repeat for all squares in 1 row

		addi.l	#((ssbg_animalsize-1)*$80)<<16,d0	; skip 7 rows ($380 byes)
		eori.b	#1,d4					; stagger blank/birdfish pattern
		dbf	d6,.loop_rows				; repeat for all rows (4 in total)

		addi.l	#$1000<<16,d3				; add $1000 to VRAM address
		bpl.s	.vdp_ok					; branch if valid VDP command
		swap	d3
		addi.l	#$C000,d3				; fix VDP command
		swap	d3

	.vdp_ok:
		adda.w	#ssbg_animalsize*ssbg_animalsize*2,a2	; read from next tilemap
		dbf	d7,.loop_canvas				; repeat for all canvases

	; --- Load mappings for the bubbles and clouds ---
		lea	(v_ram_start).l,a1
		lea	(Eni_SSBg2).l,a0			; load mappings for clouds/bubbles
		move.w	#ArtTile_SS_Background_Clouds|Tile_Pal3,d0
		bsr.w	EniDec					; decompress to buffer in RAM

		copyTilemap	v_ram_start,ArtTile_SS_Plane_5*tile_size,64,32		; copy tilemap for bubbles to VRAM
		copyTilemap	v_ram_start,ArtTile_SS_Plane_5*tile_size+$1000,64,64	; copy tilemap for clouds to VRAM

		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Special stage palette cycling and background canvas updating routine
; ---------------------------------------------------------------------------

PalCycle_SS:
		tst.w	(f_pause).w				; is game paused?
		bne.s	.exit					; if yes, branch
		subq.w	#1,(v_palss_time).w			; decrement timer
		bpl.s	.exit					; branch if time remains

		lea	(vdp_control_port).l,a6
		move.w	(v_palss_num).w,d0			; get cycle index counter
		addq.w	#1,(v_palss_num).w			; increment
		andi.w	#$1F,d0					; read only bits 0-4
		lsl.w	#2,d0					; multiply by 4
		lea	(SS_Timing_Values).l,a0
		adda.w	d0,a0

		; Time
		move.b	(a0)+,d0				; get time byte
		bpl.s	.use_time				; branch if not -1
		move.w	#$200-1,d0				; use $1FF if -1

	.use_time:
		move.w	d0,(v_palss_time).w			; set time until next palette change

		; Anim
		moveq	#0,d0
		move.b	(a0)+,d0				; get BG mode byte
		move.w	d0,(v_ssbganim).w
		lea	(SS_BG_Modes).l,a1
		lea	(a1,d0.w),a1				; jump to mode data

		; FG VRAM
		move.w	#$8200,d0				; VDP register - FG nametable address
		move.b	(a1)+,d0				; apply address from mode data
		move.w	d0,(a6)					; send VDP instruction

		; Y coordinate
		move.b	(a1),(v_scrposy_vdp).w			; get byte to send to VSRAM

		; BG VRAM
		move.w	#$8400,d0				; VDP register - BG nametable address
		move.b	(a0)+,d0				; apply address from list
		move.w	d0,(a6)					; send VDP instruction
		move.l	#$40000010,(vdp_control_port).l		; set VDP to VSRAM write mode
		move.l	(v_scrposy_vdp).w,(vdp_data_port).l	; update VSRAM

		; Palette cycle index
		moveq	#0,d0
		move.b	(a0)+,d0				; get palette offset
		bmi.s	PalCycle_SS_2				; branch if $80+
		lea	(Pal_SSCyc1).l,a1			; use palette cycle set 1
		adda.w	d0,a1
		lea	(v_palette_line_3+$E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+				; write palette

	.exit:
		rts
; ===========================================================================

PalCycle_SS_2:	; usepalcycle2 flag set
		move.w	(v_palss_index).w,d1			; get SS palette index ID (unused, this is always 0)
		cmpi.w	#$80|$A,d0				; is offset $80-$89?
		blo.s	.offset_80_89				; if yes, branch
		addq.w	#1,d1

	.offset_80_89:
		mulu.w	#$2A,d1					; d1 = always 0 or $2A
		lea	(Pal_SSCyc2).l,a1			; use palette cycle set 2
		adda.w	d1,a1
		andi.w	#$7F,d0					; ignore bit 7
		bclr	#0,d0					; clear bit 0
		beq.s	.offset_even				; branch if already clear

		; extrapalline4 flag set
		lea	(v_palette_line_4+$E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+				; write palette

	.offset_even:
		adda.w	#$C,a1
		lea	(v_palette_line_3+$1A).w,a2
		cmpi.w	#$A,d0					; is offset 0-8?
		blo.s	.offset_0_8				; if yes, branch
		subi.w	#$A,d0
		lea	(v_palette_line_4+$1A).w,a2

	.offset_0_8:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0					; multiply d0 by 3
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+				; write palette
		rts

; ===========================================================================
SSTimingData:	macro time,anim,vram,index,usepalcycle2,extrapalline4
		dc.b	(time-1), (anim), ((vram)*tile_size)>>13
		dc.b	(index)|(usepalcycle2<<7)|(extrapalline4)
		endm

SS_Timing_Values:
		; Time until next, BG mode index, BG namespace address in VRAM, palette offset
		; Flags (if true): use PalCycle_SS_2, affect some extra colors on palette line 4
		SSTimingData  4,  0, ArtTile_SS_Plane_6, $12, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6, $10, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,  $E, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,  $C, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,  $A, TRUE,  TRUE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,   0, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,   2, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,   4, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,   6, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_6,   8, TRUE,  FALSE
		SSTimingData  8,  8, ArtTile_SS_Plane_6,   0, FALSE, FALSE
		SSTimingData  8, $A, ArtTile_SS_Plane_6,  $C, FALSE, FALSE
		SSTimingData  0, $C, ArtTile_SS_Plane_6, $18, FALSE, FALSE
		SSTimingData  0, $C, ArtTile_SS_Plane_6, $18, FALSE, FALSE
		SSTimingData  8, $A, ArtTile_SS_Plane_6,  $C, FALSE, FALSE
		SSTimingData  8,  8, ArtTile_SS_Plane_6,   0, FALSE, FALSE

		SSTimingData  4,  0, ArtTile_SS_Plane_5,   8, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,   6, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,   4, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,   2, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,   0, TRUE,  TRUE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,  $A, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,  $C, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5,  $E, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5, $10, TRUE,  FALSE
		SSTimingData  4,  0, ArtTile_SS_Plane_5, $12, TRUE,  FALSE
		SSTimingData  8,  2, ArtTile_SS_Plane_5, $24, FALSE, FALSE
		SSTimingData  8,  4, ArtTile_SS_Plane_5, $30, FALSE, FALSE
		SSTimingData  0,  6, ArtTile_SS_Plane_5, $3C, FALSE, FALSE
		SSTimingData  0,  6, ArtTile_SS_Plane_5, $3C, FALSE, FALSE
		SSTimingData  8,  4, ArtTile_SS_Plane_5, $30, FALSE, FALSE
		SSTimingData  8,  2, ArtTile_SS_Plane_5, $24, FALSE, FALSE
		even

; ---------------------------------------------------------------------------

SSBGData:	macro vram,yscroll
		dc.b ((vram)*tile_size)>>10, yscroll
		endm

SS_BG_Modes:
		; FG VRAM, Y scroll direction
		SSBGData ArtTile_SS_Plane_1, 1	;  0 - grid
		SSBGData ArtTile_SS_Plane_2, 0	;  2 - fish morph 1
		SSBGData ArtTile_SS_Plane_2, 1	;  4 - fish morph 2
		SSBGData ArtTile_SS_Plane_3, 0	;  6 - fish
		SSBGData ArtTile_SS_Plane_3, 1	;  8 - bird morph 1
		SSBGData ArtTile_SS_Plane_4, 0	; $A - bird morph 2
		SSBGData ArtTile_SS_Plane_4, 1	; $C - bird
		even

; ===========================================================================

Pal_SSCyc1:	binclude	"palette/Cycle - Special Stage 1.bin"
		even

Pal_SSCyc2:	binclude	"palette/Cycle - Special Stage 2.bin"
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Special stage background animation subroutine
; ---------------------------------------------------------------------------

SS_BGAnimate:
		move.w	(v_ssbganim).w,d0			; get frame for fish/bird animation
		bne.s	.not_0					; branch if not 0
		move.w	#0,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w	; reset vertical scroll for bubble/cloud layer

	.not_0:
		cmpi.w	#8,d0
		bhs.s	SS_BGBirdCloud				; branch if d0 is 8-$C (birds and clouds)
		cmpi.w	#6,d0
		bne.s	.not_6					; branch if d0 isn't 6
		addq.w	#1,(v_bg3screenposx).w
		addq.w	#1,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w	; scroll bubble layer

	.not_6:
		moveq	#0,d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		swap	d0
		lea	(SS_Bubble_WobbleData).l,a1
		lea	(v_ss_scroll_bubbles).w,a3
		moveq	#10-1,d3				; entry count for SS_Bubble_WobbleData

SS_BGWobbleLoop:
		move.w	2(a3),d0				; get next value from buffer
		bsr.w	CalcSine				; convert to sine
		moveq	#0,d2
		move.b	(a1)+,d2				; read 1st byte
		muls.w	d2,d0					; multiply by sine
		asr.l	#8,d0					; divide by $10
		move.w	d0,(a3)+				; write to 1st word of buffer
		move.b	(a1)+,d2				; read 2nd byte
		ext.w	d2
		add.w	d2,(a3)+				; add to 2nd word of buffer
		dbf	d3,SS_BGWobbleLoop

		lea	(v_ss_scroll_bubbles).w,a3
		lea	(SS_Bubble_ScrollBlocks).l,a2
		bra.s	SS_Scroll_CloudsBubbles
; ===========================================================================

SS_BGBirdCloud:
		cmpi.w	#$C,d0
		bne.s	.not_C					; branch if d0 isn't $C
		subq.w	#1,(v_bg3screenposx).w
		lea	(v_ss_scroll_clouds).w,a3
		move.l	#$18000,d2
		moveq	#7-1,d1					; entry count for SS_Cloud_ScrollBlocks

	.loop:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,.loop

	.not_C:
		lea	(v_ss_scroll_clouds).w,a3
		lea	(SS_Cloud_ScrollBlocks).l,a2

SS_Scroll_CloudsBubbles:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(v_bgscreenposy).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

	.loop_block:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

	.loop_line:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,.loop_line
		dbf	d3,.loop_block
		rts
; End of function SS_BGAnimate

; ===========================================================================
SS_Bubble_ScrollBlocks:
		dc.b 10-1
		dc.b $28, $18, $10, $28, $18, $10, $30, $18, 8, $10
		even

SS_Cloud_ScrollBlocks:
		dc.b 7-1
		dc.b $30, $30, $30, $28, $18, $18, $18
		even

SS_Bubble_WobbleData:
		dc.b 8, 2
		dc.b 4, -1
		dc.b 2, 3
		dc.b 8, -1
		dc.b 4, 2
		dc.b 2, 3
		dc.b 8, -3
		dc.b 4, 2
		dc.b 2, 3
		dc.b 2, -1
		even
; ===========================================================================