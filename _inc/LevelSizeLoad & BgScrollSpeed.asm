; ---------------------------------------------------------------------------
; Subroutine to load level boundaries and start locations
; ---------------------------------------------------------------------------

LevelSizeLoad:
		moveq	#0,d0
		move.b	d0,(v_unused7).w
		move.b	d0,(v_unused8).w
		move.b	d0,(v_unused9).w
		move.b	d0,(v_unused10).w
		move.b	d0,(v_dle_routine).w
	if FixBugs
		; Fix title screen not always scrolling after a game over
		move.b	d0,(f_nobgscroll).w
	endif
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	LevelSizeArray(pc,d0.w),a0 ; load level boundaries
		move.w	(a0)+,d0
		move.w	d0,(v_unused11).w
		move.l	(a0)+,d0
		move.l	d0,(v_limitleft2).w
		move.l	d0,(v_limitleft1).w
		move.l	(a0)+,d0
		move.l	d0,(v_limittop2).w
		move.l	d0,(v_limittop1).w
		move.w	(v_limitleft2).w,d0
		addi.w	#$240,d0
		move.w	d0,(v_limitleft3).w
		move.w	#$1010,(v_fg_xblock).w ; and v_fg_yblock
		move.w	(a0)+,d0
		move.w	d0,(v_lookshift).w
		bra.w	LevSz_ChkLamp

; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------
LevelSizeArray:
		include	"_inc/LevelSizeArray.asm"

; ---------------------------------------------------------------------------
; Ending start location array
; (Previously separated into "_inc/Start Location Array - Ending.asm")
; ---------------------------------------------------------------------------
EndingStLocArray:
		binclude	"startpos/Credits Demos/ghz1 (Credits demo 1).bin"	; $0050, $03B0
		binclude	"startpos/Credits Demos/mz2 (Credits demo).bin"   	; $0EA0, $046C
		binclude	"startpos/Credits Demos/syz3 (Credits demo).bin"        ; $1750, $00BD
		binclude	"startpos/Credits Demos/lz3 (Credits demo).bin"         ; $0A00, $062C
		binclude	"startpos/Credits Demos/slz3 (Credits demo).bin"        ; $0BB0, $004C
		binclude	"startpos/Credits Demos/sbz1 (Credits demo).bin"        ; $1570, $016C
		binclude	"startpos/Credits Demos/sbz2 (Credits demo).bin"        ; $01B0, $072C
		binclude	"startpos/Credits Demos/ghz1 (Credits demo 2).bin"      ; $1400, $02AC
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Continuation from
; ---------------------------------------------------------------------------

LevSz_ChkLamp:
		tst.b	(v_lastlamp).w	; have any lampposts been hit?
		beq.s	LevSz_StartLoc	; if not, branch

		jsr	(Lamp_LoadInfo).l
		move.w	(v_player+obX).w,d1
		move.w	(v_player+obY).w,d0
		bra.s	LevSz_SkipStartPos
; ===========================================================================

LevSz_StartLoc:
	if FixBugs
		; Fix title screen position
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Title_Screen_position_in_Sonic_1#Fix_vertical_position_after_editing_GHZ1
		cmpi.b	#id_Title,(v_gamemode).w	; is this the title screen?
		bne.s	LevSz_NotTitle			; if not, branch
		move.w	#$0050,d1			; X coordinate (this also dictates the little delay before the title screen starts scrolling)
		move.w	#$03B0,d0			; Y coordinate
		move.w	d1,(v_player+obX).w		; set X coordinate
		move.w	d0,(v_player+obY).w		; set Y coordinate
		bra.s	LevSz_SkipStartPos		; skip normal logic
LevSz_NotTitle:
	endif
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartLocArray(pc,d0.w),a1 ; load Sonic's start location
		tst.w	(f_demo).w	; is ending demo mode on?
		bpl.s	LevSz_SonicPos	; if not, branch

		move.w	(v_creditsnum).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		lea	EndingStLocArray(pc,d0.w),a1 ; load Sonic's start location

LevSz_SonicPos:
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(v_player+obX).w ; set Sonic's position on x-axis
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(v_player+obY).w ; set Sonic's position on y-axis
		move.b	(v_gamemode).w,d2			; MJ: load game mode
		andi.w	#$FC,d2					; MJ: keep in range
		cmpi.b	#4,d2					; MJ: is screen mode at title?
		bne.s	SetScreen				; MJ: if not, branch
		move.w	#$50,d1					; MJ: set positions for title screen
		move.w	#$3B0,d0				; MJ: ''
		move.w	d1,(v_player+obX).w			; MJ: save to object 1 so title screen follows
		move.w	d0,(v_player+obY).w			; MJ: ''

SetScreen:
LevSz_SkipStartPos:
		subi.w	#160,d1		; is Sonic more than 160px from left edge?
		bcc.s	SetScr_WithinLeft ; if yes, branch
		moveq	#0,d1

SetScr_WithinLeft:
		move.w	(v_limitright2).w,d2
		cmp.w	d2,d1		; is Sonic inside the right edge?
		blo.s	SetScr_WithinRight ; if yes, branch
		move.w	d2,d1

SetScr_WithinRight:
		move.w	d1,(v_screenposx).w ; set horizontal screen position

		subi.w	#96,d0		; is Sonic within 96px of upper edge?
		bcc.s	SetScr_WithinTop ; if yes, branch
		moveq	#0,d0

SetScr_WithinTop:
		cmp.w	(v_limitbtm2).w,d0 ; is Sonic above the bottom edge?
		blt.s	SetScr_WithinBottom ; if yes, branch
		move.w	(v_limitbtm2).w,d0

SetScr_WithinBottom:
		move.w	d0,(v_screenposy).w ; set vertical screen position
	if Revision=0
		bsr.w	BgScrollSpeed
		bra.w	LevSz_LoadScrollBlockSize
	else
		bra.w	BgScrollSpeed
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic start location array
; (Previously separated into "_inc/Start Location Array - Levels.asm")
; ---------------------------------------------------------------------------

; All unused acts default to the same starting location of x=$80, y=$A8
unused_startloc: macro
	dc.w	$0080,$00A8
	endm

StartLocArray:
		binclude	"startpos/ghz1.bin"
		binclude	"startpos/ghz2.bin"
		binclude	"startpos/ghz3.bin"
		unused_startloc
		binclude	"startpos/lz1.bin"
		binclude	"startpos/lz2.bin"
		binclude	"startpos/lz3.bin"
		binclude	"startpos/sbz3.bin"	; SBZ3 is LZ4 internally
		binclude	"startpos/mz1.bin"
		binclude	"startpos/mz2.bin"
		binclude	"startpos/mz3.bin"
		unused_startloc
		binclude	"startpos/slz1.bin"
		binclude	"startpos/slz2.bin"
		binclude	"startpos/slz3.bin"
		unused_startloc
		binclude	"startpos/syz1.bin"
		binclude	"startpos/syz2.bin"
		binclude	"startpos/syz3.bin"
		unused_startloc
		binclude	"startpos/sbz1.bin"
		binclude	"startpos/sbz2.bin"
		binclude	"startpos/fz.bin"	; FZ is SBZ3 internally
		unused_startloc
		zonewarning StartLocArray,$10
		binclude	"startpos/end1.bin"
		binclude	"startpos/end2.bin"
		unused_startloc
		unused_startloc
		even
; ===========================================================================

	if Revision=0
; ---------------------------------------------------------------------------
; Old (and mostly unused) scroll block definition system used in REV00.
; Each word represents a scroll block size, for example GHZ has $70 pixels
; for the first scroll block (clouds/top mountains), followed by $100 pixels
; for the rest of the bottom mountains and water. The majority of this
; information is unused, since most of REV00's backgrounds are not scrolled
; in any special way, and GHZ is the only real zone that uses this system.
; This was deleted entirely for REV01 when each zone got unique deformation.
; ---------------------------------------------------------------------------

; LevSz_Unk:
LevSz_LoadScrollBlockSize:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#3,d0
		lea	BGScrollBlockSizes(pc,d0.w),a1
		lea	(v_scroll_block_1_size).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		rts
; End of function LevSz_LoadScrollBlockSize
; ---------------------------------------------------------------------------

; dword_61B4:
BGScrollBlockSizes:
		dc.w	$70,$100,$100,$100	; GHZ
		dc.w	$800,$100,$100,0	; LZ
		dc.w	$800,$100,$100,0	; MZ
		dc.w	$800,$100,$100,0	; SLZ
		dc.w	$800,$100,$100,0	; SYZ
		dc.w	$800,$100,$100,0	; SBZ
		zonewarning BGScrollBlockSizes,8
		dc.w	$70,$100,$100,$100	; Ending (same as GHZ)
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup scroll positions (mostly to set the backgrounds in the right place)
; ---------------------------------------------------------------------------

BgScrollSpeed:
		tst.b	(v_lastlamp).w
		bne.s	loc_6206
		move.w	d0,(v_bgscreenposy).w
		move.w	d0,(v_bg2screenposy).w
		move.w	d1,(v_bgscreenposx).w
		move.w	d1,(v_bg2screenposx).w
		move.w	d1,(v_bg3screenposx).w

loc_6206:
		moveq	#0,d2
		move.b	(v_zone).w,d2
		add.w	d2,d2
		move.w	BgScroll_Index(pc,d2.w),d2
		jmp	BgScroll_Index(pc,d2.w)
; End of function BgScrollSpeed

; ===========================================================================
BgScroll_Index:	dc.w BgScroll_GHZ-BgScroll_Index
		dc.w BgScroll_LZ-BgScroll_Index
		dc.w BgScroll_MZ-BgScroll_Index
		dc.w BgScroll_SLZ-BgScroll_Index
		dc.w BgScroll_SYZ-BgScroll_Index
		dc.w BgScroll_SBZ-BgScroll_Index
		zonewarning BgScroll_Index,2
		dc.w BgScroll_End-BgScroll_Index
; ===========================================================================

BgScroll_GHZ:
	if Revision=0
		bra.w	Deform_GHZ
	else
		clr.l	(v_bgscreenposx).w
		clr.l	(v_bgscreenposy).w
		clr.l	(v_bg2screenposy).w
		clr.l	(v_bg3screenposy).w
		lea	(v_bgscroll_buffer).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
	endif
; ===========================================================================

BgScroll_LZ:
		asr.l	#1,d0
		move.w	d0,(v_bgscreenposy).w
		rts
; ===========================================================================

BgScroll_MZ:
		rts
; ===========================================================================

BgScroll_SLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0
		move.w	d0,(v_bgscreenposy).w
	if Revision<>0
		clr.l	(v_bgscreenposx).w
	endif
		rts
; ===========================================================================

BgScroll_SYZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
	if Revision=0
		move.w	d0,(v_bgscreenposy).w
		move.w	d0,(v_bg2screenposy).w
	else
		addq.w	#1,d0
		move.w	d0,(v_bgscreenposy).w
		clr.l	(v_bgscreenposx).w
	endif
		rts
; ===========================================================================

BgScroll_SBZ:
	if Revision=0
		asl.l	#4,d0
		asl.l	#1,d0
		asr.l	#8,d0
	else
		andi.w	#$7F8,d0
		asr.w	#3,d0
		addq.w	#1,d0
	endif
		move.w	d0,(v_bgscreenposy).w
		rts
; ===========================================================================

BgScroll_End:
	if Revision=0
		move.w	#$1E,(v_bgscreenposy).w
		move.w	#$1E,(v_bg2screenposy).w
		rts
		; dead code
		move.w	#$A8,(v_bgscreenposx).w
		move.w	#$1E,(v_bgscreenposy).w
		move.w	#-$40,(v_bg2screenposx).w
		move.w	#$1E,(v_bg2screenposy).w
		rts
	else
		move.w	(v_screenposx).w,d0
		asr.w	#1,d0
		move.w	d0,(v_bgscreenposx).w
		move.w	d0,(v_bg2screenposx).w
		asr.w	#2,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,(v_bg3screenposx).w
		clr.l	(v_bgscreenposy).w
		clr.l	(v_bg2screenposy).w
		clr.l	(v_bg3screenposy).w
		lea	(v_bgscroll_buffer).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
	endif