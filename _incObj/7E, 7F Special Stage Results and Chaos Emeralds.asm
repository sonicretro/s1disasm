; ===========================================================================
; ---------------------------------------------------------------------------
; Object 7E - Special Stage results screen
; ---------------------------------------------------------------------------

SSResult:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SSR_Index(pc,d0.w),d1
		jmp	SSR_Index(pc,d1.w)
; ===========================================================================
SSR_Index:	dc.w SSR_ChkPLC-SSR_Index	; 0
		dc.w SSR_Move-SSR_Index		; 2
		dc.w SSR_Wait-SSR_Index		; 4
		dc.w SSR_RingBonus-SSR_Index	; 6
		dc.w SSR_Wait-SSR_Index		; 8
		dc.w SSR_Exit-SSR_Index		; A
	
		; Extra continue acquired:
		dc.w SSR_Wait-SSR_Index		; C
		dc.w SSR_Continue-SSR_Index	; E
		dc.w SSR_Wait-SSR_Index		; 10
		dc.w SSR_Exit-SSR_Index		; 12
		dc.w SSR_ContAni-SSR_Index	; 14

ssr_mainX:	equ	objoff_30		; target X-position for card while moving in
; ===========================================================================

SSR_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w			; have title card patterns in PLC finished decompressing?
		beq.s	SSR_Main				; if yes, branch
		rts						; otherwise, wait until PLC queue is empty
; ===========================================================================

SSR_Main:
		movea.l	a0,a1					; set this root object to become the header text object

		lea	(SSR_ItemData).l,a2			; load card item data
		moveq	#4-1,d1					; load header text text, Score tally, Ring Bonus tally, and Blue oval
		cmpi.w	#ss_continue_rings,(v_rings).w		; do you have 50 or more rings?
		blo.s	SSR_Loop				; if no, branch
		addq.w	#1,d1					; if yes, also load Continue tally

SSR_Loop:
		_move.b	#id_SSResult,obID(a1)			; load next end-of-level title card element
		move.w	(a2)+,obX(a1)				; load start x-position
		move.w	(a2)+,ssr_mainX(a1)			; load target x-position
		move.w	(a2)+,obScreenY(a1)			; load y-position
		move.b	(a2)+,obRoutine(a1)			; load routine number
		move.b	(a2)+,obFrame(a1)			; load frame ID
		move.l	#Map_SSR,obMap(a1)			; set mappings
		move.w	#ArtTile_Title_Card|Tile_Prio,obGfx(a1)	; set art tile and sprite priority flag
		move.b	#0,obRender(a1)				; set to screen-positioned sprite mode
		lea	object_size(a1),a1			; advance to next card object (all elements are back-to-back in RAM)
		dbf	d1,SSR_Loop				; repeat sequence 3 or 4 times

		moveq	#7,d0					; use "SPECIAL STAGE" text by default
		move.b	(v_emeralds).w,d1			; get number of collected emeralds
		beq.s	.setFrame				; if you have zero emeralds, branch
		moveq	#0,d0					; use "CHAOS EMERALDS" text
		cmpi.b	#ss_emeralds_num,d1			; do you have all chaos emeralds?
		bne.s	.setFrame				; if not, branch
		moveq	#8,d0					; use "SONIC GOT THEM ALL" text
		move.w	#$18,obX(a0)				; set alternate start position
		move.w	#$118,ssr_mainX(a0)			; use alternate target position
	; loc_C842:
	.setFrame:
		move.b	d0,obFrame(a0)				; set specified frame ID for text object
; ---------------------------------------------------------------------------

SSR_Move:	; Routine 2
		moveq	#$10,d1					; set horizontal move-in speed
		move.w	ssr_mainX(a0),d0			; get target moving in X-position
		cmp.w	obX(a0),d0				; has item reached its target position?
		beq.s	.reachedXTarget				; if yes, branch
		bge.s	.updateXPos				; is item moving in from the left? if yes, branch
		neg.w	d1					; negate move-in direction if coming from the right
	; SSR_ChgPos:
	.updateXPos:
		add.w	d1,obX(a0)				; change item's position

	; loc_C85A:
	.checkOffScreen:
		move.w	obX(a0),d0				; get current x-position of card
		bmi.s	.return					; if it's negative, don't display
		cmpi.w	#$80+320+64,d0				; has item moved beyond $200 on x-axis?
	if FixBugs
		; See the fix at Card_NoMove
		bgt.s	.return					; if yes, branch
		cmpi.w	#$80-64+16,d0				; has card moved beyond $50 on the x-axis (to the left)?
		bgt.w	DisplaySprite				; if not, display card
	else
		bhs.s	.return					; if yes, branch
		bra.w	DisplaySprite				; display card
	endif

	; locret_C86A:
	.return:
		rts						; return
; ===========================================================================

	; loc_C86C:
	.reachedXTarget:
		cmpi.b	#2,obFrame(a0)				; is this the ring bonus element? (only one element can control)
		bne.s	.checkOffScreen				; if not, branch
		addq.b	#2,obRoutine(a0)			; set to SSR_Wait (4)
		move.w	#3*60,obTimeFrame(a0)			; set time delay before tally to 3 seconds
		move.b	#id_SSRChaos,(v_ssresemeralds).w	; load collected chaos emeralds object
; ---------------------------------------------------------------------------

SSR_Wait:	; Routine 4, 8, $C, $10
		subq.w	#1,obTimeFrame(a0)			; subtract 1 from time delay
		bne.s	.display				; if time remains, branch
		addq.b	#2,obRoutine(a0)			; advance to whatever the next routine is

	; SSR_Display:
	.display:
		bra.w	DisplaySprite				; display card sprites
; ===========================================================================

SSR_RingBonus:	; Routine 6
		bsr.w	DisplaySprite				; keep displaying card sprites
		move.b	#1,(f_endactbonus).w			; set time/ring bonus HUD update flag

		tst.w	(v_ringbonus).w				; is any ring bonus left?
		beq.s	.finished				; if not, branch
		subi.w	#10,(v_ringbonus).w			; subtract 100 points from remaining ring bonus
		moveq	#10,d0					; set to add 100 points to score
		jsr	(AddPoints).l				; add d0 points to score

		move.b	(v_vblank_byte).w,d0			; get current VBlank byte
		andi.b	#3,d0					; only play blip sound every 4th frame
		bne.s	.return					; on other frames, branch
		move.w	#sfx_Switch,d0				; set "blip" sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

	; loc_C8C4:
	.finished:
		move.w	#sfx_Cash,d0				; set "ka-ching" sound
		jsr	(QueueSound2).l				; play it

		addq.b	#2,obRoutine(a0)			; set to SSR_Wait (8, before SSR_Exit A)
		move.w	#3*60,obTimeFrame(a0)			; set post summing-up time delay to 3 seconds

		cmpi.w	#ss_continue_rings,(v_rings).w		; do you have at least 50 rings?
		blo.s	.return					; if not, branch
		move.w	#1*60,obTimeFrame(a0)			; set time delay before continue animation to 1 second
		addq.b	#4,obRoutine(a0)			; set to SSR_Wait (C, before SSR_Continue)

	; locret_C8EA:
	.return:
		rts						; return
; ===========================================================================

SSR_Exit:	; Routine $A, $12
		move.w	#1,(f_restart).w			; signal to SS_NormalExit that it should exit
		bra.w	DisplaySprite				; keep displaying cards during fade-out
; ===========================================================================

SSR_Continue:	; Routine $E
		move.b	#4,(v_ssrescontinue+obFrame).w		; set Continue tally to frame ID (show mini-Sonic)
		move.b	#$14,(v_ssrescontinue+obRoutine).w	; set Continue tally it to SSR_ContAni
		move.w	#sfx_Continue,d0			; set continue jingle
		jsr	(QueueSound2).l				; play it
		addq.b	#2,obRoutine(a0)			; set to SSR_Wait (10, before SSR_Exit 12)
		move.w	#6*60,obTimeFrame(a0)			; set time delay to exit after continue animation to 6 seconds
		bra.w	DisplaySprite				; keep displaying sprite
; ===========================================================================

; loc_C91A:
SSR_ContAni:	; Routine $14
		move.b	(v_vblank_byte).w,d0			; get current VBlank frame byte
		andi.b	#$F,d0					; make mini-Sonic change sprite every 16 frames
		bne.s	.display				; branch on other frames
		bchg	#0,obFrame(a0)				; make mini-Sonic alternate between frame 4 and 5 (foot tapping)

	; SSR_Display2:
	.display:
		bra.w	DisplaySprite				; display mini-Sonic

; ===========================================================================
; ---------------------------------------------------------------------------
; SSR title card element setup data. Format:
; - start X-position, target X-position
; - Y-position
; - base routine number
; - frame ID
; ---------------------------------------------------------------------------
; SSR_Config:
SSR_ItemData:
		; Header text
		dc.w $020, $120
		dc.w $C4
		dc.b 2
		dc.b 0	; dynamic frame ID (see SSR_Loop)

		; Score tally
		dc.w $320, $120
		dc.w $118
		dc.b 2
		dc.b 1

		; Ring Bonus tally
		dc.w $360, $120
		dc.w $128
		dc.b 2
		dc.b 2

		; Blue oval
		dc.w $1EC, $11C
		dc.w $C4
		dc.b 2
		dc.b 3

		; Continue tally
		dc.w $3A0, $120
		dc.w $138
		dc.b 2
		dc.b 6
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 7F - Chaos Emeralds from the Special Stage results screen
; ---------------------------------------------------------------------------

SSRChaos:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SSRC_Index(pc,d0.w),d1
		jmp	SSRC_Index(pc,d1.w)
; ===========================================================================
SSRC_Index:	dc.w SSRC_Main-SSRC_Index
		dc.w SSRC_Flash-SSRC_Index

; ===========================================================================
; --- X-positions for Chaos Emeralds in order of collection ---
; These values are pseudo-interlaced instead of going left-to-right,
; keeping consecutively collected emeralds overall centered (roughly).
SSRC_PosData:	dc.w $110 ; 1st
		dc.w $128 ; 2nd
		dc.w  $F8 ; 3rd
		dc.w $140 ; 4th
		dc.w  $E0 ; 5th
		dc.w $158 ; 6th

	if ((*-SSRC_PosData)/2<>ss_emeralds_num)&(MOMPASS=1)
		warning "SSRC_PosData does not match expected emerald count!"
	endif

; ===========================================================================

SSRC_Main:	; Routine 0
		movea.l	a0,a1					; set this root object to become the first emerald

		lea	(SSRC_PosData).l,a2			; load emerald X-position data
		moveq	#0,d2					; start at first entry in v_emldlist
		moveq	#0,d1					; clear d1 (v_emeralds is a byte, we need a word)
		move.b	(v_emeralds).w,d1			; d1 = number of collected emeralds to display
		subq.b	#1,d1					; subtract 1 for dbf
		bcs.w	DeleteObject				; if you have no emeralds, delete emerald object

SSRC_Loop:
		_move.b	#id_SSRChaos,obID(a1)			; load next chaos emerald object
		move.w	(a2)+,obX(a1)				; get next x-position from SSRC_PosData
		move.w	#$F0,obScreenY(a1)			; set fixed y-position

		lea	(v_emldlist).w,a3			; check which emeralds you have
		move.b	(a3,d2.w),d3				; get next entry from array of collected emeralds
		move.b	d3,obFrame(a1)				; set that emerald's frame
		move.b	d3,obAnim(a1)				; set that emerald's animation
		addq.b	#1,d2					; go to next entry in v_emldlist

		addq.b	#2,obRoutine(a1)			; set to SSRC_Flash
		move.l	#Map_SSRC,obMap(a1)			; set mappings
		move.w	#ArtTile_SS_Results_Emeralds|Tile_Prio,obGfx(a1) ; set art tile and sprite priority flag
		move.b	#0,obRender(a1)				; set to screen-positioned sprite mode
		lea	object_size(a1),a1			; advance to next card object (all elements are back-to-back in RAM)
		dbf	d1,SSRC_Loop				; loop for d1 number of emeralds
; ---------------------------------------------------------------------------

SSRC_Flash:	; Routine 2
		move.b	obFrame(a0),d0				; get currently displayed frame
		move.b	#ss_emeralds_num,obFrame(a0)		; load 6th frame (blank)
		cmpi.b	#ss_emeralds_num,d0			; was frame already set to blank previously?
		bne.s	.display				; if not, branch
		move.b	obAnim(a0),obFrame(a0)			; load visible frame instead

	; SSRC_Display:
	.display:
		bra.w	DisplaySprite				; display emerald sprite

; ===========================================================================

; Mappings for the SSR chaos emeralds are located after all title card mappings in ROM.
includes_ssrchaos: macro {GLOBALSYMBOLS}
Map_SSRC:	include	"_maps/SS Result Chaos Emeralds.asm"
	endm

