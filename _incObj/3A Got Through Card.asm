; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3A - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------

GotThroughCard:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Got_Index(pc,d0.w),d1
		jmp	Got_Index(pc,d1.w)
; ===========================================================================
Got_Index:	dc.w Got_ChkPLC-Got_Index		; 0
		dc.w Got_MoveIn-Got_Index		; 2
		dc.w Got_Wait-Got_Index			; 4
		dc.w Got_Bonus-Got_Index		; 6
		dc.w Got_Wait-Got_Index			; 8
		dc.w Got_NextLevel-Got_Index		; A

		; SBZ2 post-level cutscene:
		dc.w Got_Wait-Got_Index			; C
		dc.w Got_SBZ2_MoveOut-Got_Index		; E
		dc.w Got_SBZ2_Boundary-Got_Index	; 10

got_mainX:	equ	objoff_30	; target X-position for card while moving in
got_finalX:	equ	objoff_32	; target X-position for card while moving out (SBZ2 cutscene only)
; ===========================================================================

Got_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w			; have title card patterns in PLC finished decompressing?
		beq.s	Got_Main				; if yes, branch
		rts						; otherwise, wait until PLC queue is empty
; ===========================================================================

Got_Main:
		movea.l	a0,a1					; set this root object to become the level name card

		lea	(Got_ItemData).l,a2			; load card item data
		moveq	#7-1,d1					; set to affect all seven end-of-level card objects

Got_Loop:
		_move.b	#id_GotThroughCard,obID(a1)		; load next end-of-level title card element
		move.w	(a2),obX(a1)				; load start x-position
		move.w	(a2)+,got_finalX(a1)			; load finish x-position (same as start)
		move.w	(a2)+,got_mainX(a1)			; load main x-position
		move.w	(a2)+,obScreenY(a1)			; load y-position
		move.b	(a2)+,obRoutine(a1)			; load routine number
		move.b	(a2)+,d0				; load frame ID

		cmpi.b	#6,d0					; is this the act 1/2/3 element?
		bne.s	.setFrame				; if not, branch
		add.b	(v_act).w,d0				; add act number to frame ID
	; loc_C5CA:
	.setFrame:
		move.b	d0,obFrame(a1)				; set final frame ID for object

		move.l	#Map_Got,obMap(a1)			; set mappings pointer
		move.w	#ArtTile_Title_Card|Tile_Prio,obGfx(a1)	; set art tile and sprite priority flag
		move.b	#sprite_cam_screen,obRender(a1)		; set to screen-positioned sprite mode
		lea	object_size(a1),a1			; advance to next card object (all elements are back-to-back in RAM)
		dbf	d1,Got_Loop				; repeat sequence another 6 times
; ---------------------------------------------------------------------------

; Got_Move:
Got_MoveIn:
		; Routine 2
		moveq	#$10,d1					; set horizontal move-in speed
		move.w	got_mainX(a0),d0			; get target moving in X-position
		cmp.w	obX(a0),d0				; has item reached its target position?
		beq.s	.reachedXTarget				; if yes, branch
		bge.s	.updateXPos				; is item moving in from the left? if yes, branch
		neg.w	d1					; negate move-in direction if coming from the right
	; Got_ChgPos:
	.updateXPos:
		add.w	d1,obX(a0)				; change item's x-position

	; loc_C5FE:
	.checkOffScreen:
		move.w	obX(a0),d0				; get current x-position of card
		bmi.s	.return					; if it's negative, don't display
		cmpi.w	#$80+320+64,d0				; has card moved beyond $200 on x-axis (to the right)?
	if FixBugs
		; See the fix at Card_NoMove
		bgt.s	.return					; if yes, branch
		cmpi.w	#$80-64+16,d0				; has card moved beyond $50 on the x-axis (to the left)?
		bgt.w	DisplaySprite				; if not, display card
	else
		bhs.s	.return					; if yes, branch
		bra.w	DisplaySprite				; display card
	endif

	; locret_C60E:
	.return:
		rts						; return
; ===========================================================================

	.startSBZ2Cutscene:
		move.b	#$E,obRoutine(a0)			; set to Got_SBZ2_MoveOut
		bra.w	Got_SBZ2_MoveOut			; go there
; ===========================================================================

	; loc_C61A:
	.reachedXTarget:
		cmpi.b	#$E,(v_endcardring+obRoutine).w		; is post-SBZ2 cutscene meant to start?
		beq.s	.startSBZ2Cutscene			; if yes, branch

		cmpi.b	#4,obFrame(a0)				; is this the ring bonus element? (only one element can control)
		bne.s	.checkOffScreen				; if not, branch
		addq.b	#2,obRoutine(a0)			; set to Got_Wait (4)
		move.w	#3*60,obTimeFrame(a0)			; set time delay before tally to 3 seconds
; ---------------------------------------------------------------------------

Got_Wait:	; Routine 4, 8, $C
		subq.w	#1,obTimeFrame(a0)			; subtract 1 from time delay
		bne.s	.display				; if time remains, branch
		addq.b	#2,obRoutine(a0)			; advance to whatever the next routine is

	; Got_Display:
	.display:
		bra.w	DisplaySprite				; display card sprites
; ===========================================================================

; Got_TimeBonus: <- old misnomer
Got_Bonus:	; Routine 6
		bsr.w	DisplaySprite				; keep displaying card sprites
		move.b	#1,(f_endactbonus).w			; set time/ring bonus HUD update flag
		moveq	#0,d0					; set ticked-down bonus points to 0 by default

	.timeBonus:
		tst.w	(v_timebonus).w				; is any time bonus left?
		beq.s	.ringBonus				; if not, branch
		addi.w	#10,d0					; add 100 to score
		subi.w	#10,(v_timebonus).w			; subtract 100 points from remaining time bonus

	; Got_RingBonus:
	.ringBonus:
		tst.w	(v_ringbonus).w				; is any ring bonus left?
		beq.s	.checkFinished				; if not, branch
		addi.w	#10,d0					; add 100 to score
		subi.w	#10,(v_ringbonus).w			; subtract 100 points from remaining ring bonus

	; Got_ChkBonus:
	.checkFinished:
		tst.w	d0					; have any bonuses been ticked down this frame?
		bne.s	.addBonusPoints				; if yes, branch

	.finished:
		move.w	#sfx_Cash,d0				; set "ka-ching" sound
		jsr	(QueueSound2).l				; play it

		addq.b	#2,obRoutine(a0)			; set to Got_Wait (8, before Got_NextLevel)
		cmpi.w	#id_SBZ_act2,(v_zone_act).w		; is level SBZ2?
		bne.s	.setPostDelay				; if not, branch
		addq.b	#4,obRoutine(a0)			; set to Got_Wait (C, before Got_SBZ2_MoveOut)

	; Got_SetDelay:
	.setPostDelay:
		move.w	#3*60,obTimeFrame(a0)			; set post summing-up time delay to 3 seconds

	; locret_C692:
	.return:
		rts						; return
; ---------------------------------------------------------------------------

	; Got_AddBonus:
	.addBonusPoints:
		jsr	(AddPoints).l				; add d0 points to score

		move.b	(v_vblank_byte).w,d0			; get current VBlank byte
		andi.b	#3,d0					; only play blip sound every 4th frame
		bne.s	.return					; on other frames, branch
		move.w	#sfx_Switch,d0				; set "blip" sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

Got_NextLevel:	; Routine $A
		move.b	(v_zone).w,d0				; get current zone ID
		andi.w	#7,d0					; mask out unrelated bits
		lsl.w	#3,d0					; multiply by 8 (size per zone block in LevelOrder array)
		move.b	(v_act).w,d1				; get current act number
		andi.w	#3,d1					; limit to acts 1-4
		add.w	d1,d1					; double act number for word-based indexing
		add.w	d1,d0					; d0 = index in LevelOrder for current level

		move.w	LevelOrder(pc,d0.w),d0			; load next level from LevelOrder array
		move.w	d0,(v_zone_act).w			; set new zone ID and act number

		; If an ID is set to 0 in the next level array (GHZ1 internally), instead of
		; going to the next level, the entire game will go back to the Sega screen.
		; This was probably used during development, but it no longer serves any function.
		tst.w	d0					; is new level number 0? (GHZ1)
		bne.s	.validLevelNumber			; if not, branch
		move.b	#id_Sega,(v_gamemode).w			; otherwise, instantly return to the Sega screen
		bra.s	.display				; display sprite
; ---------------------------------------------------------------------------

	; Got_ChkSS:
	.validLevelNumber:
		clr.b	(v_lastlamp).w				; clear lamppost counter
		tst.b	(f_bigring).w				; has Sonic jumped into a giant ring?
		beq.s	.restartLevel				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set game mode to Special Stage (10)
		bra.s	.display				; do not set level restart flag
; ===========================================================================

	; loc_C6EA:
	.restartLevel:
		move.w	#1,(f_restart).w			; trigger level restart to load next level

	; Got_Display2:
	.display:
		bra.w	DisplaySprite				; keep displaying card during fade-out

; ===========================================================================
; ---------------------------------------------------------------------------
; Level order array
; ---------------------------------------------------------------------------
LevelOrder:
		include	"_inc/LevelOrder.asm"

; ===========================================================================

; ---------------------------------------------------------------------------
; Scrap Brain Zone act 2 post-level cutscene start
; ---------------------------------------------------------------------------

; Got_Move2: Got_MoveBack:
Got_SBZ2_MoveOut: ; Routine $E
		moveq	#2*$10,d1				; set horizontal move-out speed (twice as fast as moving in)
		move.w	got_finalX(a0),d0			; get target moving-out X-position
		cmp.w	obX(a0),d0				; has card reached its finish position?
		beq.s	Got_SBZ2_StartCutscene			; if yes, branch
		bge.s	.updateXPos				; is item moving out to the right? if yes, branch
		neg.w	d1					; negate move-out direction if exiting to the left
	; Got_ChgPos2:
	.updateXPos:
		add.w	d1,obX(a0)				; change card's x-position

	; .checkOffScreen:
		move.w	obX(a0),d0				; get current x-position of card
		bmi.s	.return					; if it's negative, don't display
		cmpi.w	#$80+320+64,d0				; has card moved beyond $200 on x-axis (to the right)?
	if FixBugs
		; See the fix at Card_NoMove
		bgt.s	.return					; if yes, branch
		cmpi.w	#$80-64+16,d0				; has card moved beyond $50 on the x-axis (to the left)?
		bgt.w	DisplaySprite				; if not, display card
	else
		bhs.s	.return					; if yes, branch
		bra.w	DisplaySprite				; display card
	endif

	; locret_C748:
	.return:
		rts						; don't display card
; ---------------------------------------------------------------------------

	; Got_SBZ2:
	Got_SBZ2_StartCutscene:
		cmpi.b	#4,obFrame(a0)				; is this the ring bonus element? (use ring bonus to control cutscene)
		bne.w	DeleteObject				; if not, delete card element immediately

		addq.b	#2,obRoutine(a0)			; set to Got_SBZ2_Boundary
		clr.b	(f_lockctrl).w				; unlock controls
		move.w	#bgm_FZ,d0				; set FZ music
		jmp	(QueueSound1).l				; play it
; ===========================================================================

; loc_C766: Got_Boundary:
Got_SBZ2_Boundary: ; Routine $10
		addq.w	#2,(v_limitright2).w			; move right screen boundary 2px ahead
		cmpi.w	#boss_sbz2_x+$B0,(v_limitright2).w	; has right boundary reached target position? ($2100)
		beq.w	DeleteObject				; if yes, stop moving boundary, delete ring bonus object
		rts						; otherwise, keep advancing boundary but don't display sprite
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; End title card element setup data. Format:
; - start X-position, target X-position
; - Y-position
; - base routine number
; - frame ID
; ---------------------------------------------------------------------------
; Got_Config:
Got_ItemData:
		; "SONIC HAS"
		dc.w $004, $124
		dc.w $BC
		dc.b 2
		dc.b 0

		; "PASSED"
		dc.w -$120, $120
		dc.w $D0			
		dc.b 2
		dc.b 1

		; "ACT" 1/2/3
		dc.w $40C, $14C
		dc.w $D6			
		dc.b 2
		dc.b 6	; dynamic frame ID (see Got_Loop)

		; Score tally
		dc.w $520, $120
		dc.w $EC			
		dc.b 2
		dc.b 2

		; Time Bonus tally
		dc.w $540, $120
		dc.w $FC			
		dc.b 2
		dc.b 3

		; Ring Bonus tally
		dc.w $560, $120
		dc.w $10C			
		dc.b 2
		dc.b 4

		; Blue oval
		dc.w $20C, $14C
		dc.w $CC			
		dc.b 2
		dc.b 5
; ===========================================================================
