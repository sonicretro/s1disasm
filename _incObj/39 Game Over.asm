; ===========================================================================
; ---------------------------------------------------------------------------
; Object 39 - "GAME OVER" and "TIME OVER"
; ---------------------------------------------------------------------------

GameOverCard:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Over_Index(pc,d0.w),d1
		jmp	Over_Index(pc,d1.w)
; ===========================================================================
Over_Index:	dc.w Over_ChkPLC-Over_Index
		dc.w Over_MoveIn-Over_Index
		dc.w Over_Wait-Over_Index
; ===========================================================================

Over_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w			; have game over patterns in PLC finished decompressing?
		beq.s	Over_Main				; if yes, branch
		rts						; otherwise, wait until PLC queue is empty
; ===========================================================================

Over_Main:
		addq.b	#2,obRoutine(a0)			; advance to Over_MoveIn
		move.w	#$80-48,obX(a0)				; set start X-position for "GAME"/"TIME" object (offscreen left)
		btst	#0,obFrame(a0)				; is this the "OVER" object?
		beq.s	.moreSetup				; if not, branch
		move.w	#$80+320+48,obX(a0)			; set start X-position for "OVER" object (offscreen right)
	.moreSetup:
		move.w	#$80+(224/2),obScreenY(a0)		; set Y-position to be vertically centered on screen
		move.l	#Map_Over,obMap(a0)			; set mappings
		move.w	#ArtTile_Game_Over|Tile_Prio,obGfx(a0)	; set art tile and priority flag
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen-positioned mode
		move.b	#0,obPriority(a0)			; set to max sprite priority
; ---------------------------------------------------------------------------

Over_MoveIn:	; Routine 2
		moveq	#$10,d1					; set horizontal move-in speed
		cmpi.w	#$80+(320/2),obX(a0)			; has item reached its target position? (middle of screen)
		beq.s	.conjoined				; if yes, branch
		blo.s	.updateXPos				; is item moving in from the left? if yes, branch
		neg.w	d1
	.updateXPos:
		add.w	d1,obX(a0)				; change item's position
		bra.w	DisplaySprite				; display sprite while moving in
; ===========================================================================

.conjoined:
		move.w	#12*60,obTimeFrame(a0)			; set time delay to 12 seconds
		addq.b	#2,obRoutine(a0)			; advance to Over_Wait
	if FixBugs=0
		; This causes the text to briefly flicker when conjoining.
		rts						; return on conjoining frame
	endif
; ===========================================================================

Over_Wait:	; Routine 4
		move.b	(v_jpadpress1).w,d0			; get butteons pressed this frame
		andi.b	#btnABC,d0				; was button A, B, or C pressed?
		bne.s	.changeMode				; if yes, branch

		btst	#0,obFrame(a0)				; is this the "OVER" object?
		bne.s	.display				; if yes, branch
		tst.w	obTimeFrame(a0)				; has time delay reached zero?
		beq.s	.changeMode				; if yes, branch
		subq.w	#1,obTimeFrame(a0)			; subtract 1 from time delay
		bra.w	DisplaySprite				; keep displaying sprites
; ---------------------------------------------------------------------------

.changeMode:
		tst.b	(f_timeover).w				; is time over flag set? (only set if remaining lives are non-zero)
		bne.s	.restartLevel				; if yes, always restart level
		move.b	#id_Continue,(v_gamemode).w		; set mode to $14 (continue screen)
		tst.b	(v_continues).w				; do you have any continues?
		bne.s	.display				; if yes, branch to enter continue mode
		move.b	#id_Sega,(v_gamemode).w			; set mode to 0 (Sega screen)
		bra.s	.display				; keep displaying sprites during fade-out
; ---------------------------------------------------------------------------

.restartLevel:
	if Revision<>0
		; REV01 added this fix to avoid causing potential softlocks
		; from checkpoints that were collected late into a timer
		clr.l	(v_lamp_time).w				; clear stored lamppost time
	endif
		move.w	#1,(f_restart).w			; restart level
	.display:
		bra.w	DisplaySprite				; display sprites
