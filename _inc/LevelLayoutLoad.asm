; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

LevelDataLoad:
	; --- Load Level Header ---
		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get zone ID to load
		lsl.w	#4,d0					; multiply by $10 (size per level header entry)
		lea	(LevelHeaders).l,a2			; load level header data
		lea	(a2,d0.w),a2				; advance to level header for current zone
		move.l	a2,-(sp)				; remember header address for later
		addq.l	#4,a2					; skip 1st PLC and level gfx entry (handled in GM_Level)

	; --- 16x16 Block Mappings ---
		movea.l	(a2)+,a0				; get 16x16 data pointer from level header
		lea	(v_16x16).w,a1				; set target RAM buffer for 16x16 mappings
		move.w	#ArtTile_Level,d0			; set base art tile (0)
		bsr.w	EniDec					; decompress Enigma-compressed block data to buffer

	; --- 256x256 Chunk Mappings ---
		movea.l	(a2)+,a0				; get 256x256 chunk data pointer from level header
		lea	(v_256x256).l,a1			; set target RAM buffer for 256x256 mappings
		bsr.w	KosDec					; decompress Kosinski-compressed chunk data to buffer

	; --- Level Layout (FG/BG) ---
		bsr.w	LevelLayoutLoad				; load FG and BG layout

	; --- Music (unused) ---
		move.w	(a2)+,d0				; load music (unused)

	; --- Palette ---
		move.w	(a2),d0					; load palette ID
		andi.w	#$FF,d0					; only use lower byte (palette ID is duplicated in headers)

		cmpi.w	#id_LZ_act4,(v_zone_act).w		; is level SBZ3 (LZ4)?
		bne.s	.notSBZ3				; if not, branch
		moveq	#palid_SBZ3,d0				; use SB3 palette instead
	.notSBZ3:
		cmpi.w	#id_SBZ_act2,(v_zone_act).w		; is level SBZ2?
		beq.s	.isSBZorFZ				; if yes, branch
		cmpi.w	#id_FZ,(v_zone_act).w			; is level FZ?
		bne.s	.normalpal				; if not, branch
	.isSBZorFZ:
		moveq	#palid_SBZ2,d0				; use SBZ2/FZ palette instead
	.normalpal:
		bsr.w	PalLoad_Fade				; load specified palette into fade-in buffer

	; --- 2nd PLC ---
		movea.l	(sp)+,a2				; restore base level header pointer
		addq.w	#4,a2					; advance to 2nd PLC entry
		moveq	#0,d0
		move.b	(a2),d0					; load 2nd PLC entry from level headers
		beq.s	.skipPLC				; if 2nd PLC is 0 (i.e. the ending sequence), branch
		bsr.w	AddPLC					; load secondary pattern load cues
	.skipPLC:
		rts
; End of function LevelDataLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Level layout loading subroutine
; ---------------------------------------------------------------------------

LevelLayoutLoad:
		lea	(v_lvllayout).w,a3
	if FixBugs
		move.w	#(v_lvllayout_end-v_lvllayout)/4-1,d1
	else
		; ; v_lvllayout is only $400 bytes, but this clears $800...
		; In Sonic 2, this function was corrected to only clear the layout buffer.
		move.w	#(v_lvllayout_end-v_lvllayout)/2-1,d1
	endif
		moveq	#0,d0
	.clear:	move.l	d0,(a3)+
		dbf	d1,.clear				; loop until buffer is cleared ($A400-A7FF)

		lea	(v_lvllayout_fg).w,a3			; target RAM address for level foreground layout
		moveq	#0,d1					; offset in Level_Index (0 = FG layout)
		bsr.w	LevelLayoutLoad2			; load FG level layout into RAM

		lea	(v_lvllayout_bg).w,a3			; target RAM address for background layout
		moveq	#2,d1					; offset in Level_Index (2 = BG layout)
		; fall-through for second run...
; ---------------------------------------------------------------------------

; "LevelLayoutLoad2" is run twice for (once for the FG and BG layouts each)
LevelLayoutLoad2:
		move.w	(v_zone_act).w,d0			; get current zone and act
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0					; d0 = Level_Index row for current zone and act
		add.w	d1,d0					; add pre-specified offset to get either FG or BG layout
		lea	(Level_Index).l,a1			; get layout index
		move.w	(a1,d0.w),d0				; advance to desired layout pointer in index
		lea	(a1,d0.w),a1				; load layout pointer from index

		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1				; load level width (in chunks)
		move.b	(a1)+,d2				; load level height (in chunks)
	.loopAllRows:
		move.w	d1,d0					; reset row length (width)
		movea.l	a3,a0					; set next target layout row in RAM
	.loopRow:
		move.b	(a1)+,(a0)+				; copy next chunk ID byte
		dbf	d0,.loopRow				; loop for one whole row
		lea	layout_row(a3),a3			; advance to next (skip over other plane)
		dbf	d2,.loopAllRows				; repeat for number of rows

		rts
; End of function LevelLayoutLoad
