; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0D - signpost at the end of a level
; ---------------------------------------------------------------------------

Signpost:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sign_Index(pc,d0.w),d1
		jsr	Sign_Index(pc,d1.w)
		lea	(Ani_Sign).l,a1
		bsr.w	AnimateSprite
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================
Sign_Index:	dc.w Sign_Main-Sign_Index
		dc.w Sign_Touch-Sign_Index
		dc.w Sign_Spin-Sign_Index
		dc.w Sign_SonicRun-Sign_Index
		dc.w Sign_Exit-Sign_Index

spintime:	equ objoff_30		; time for signpost to spin
sparkletime:	equ objoff_32		; time between sparkles
sparkle_id:	equ objoff_34		; counter to keep track of sparkles
; ===========================================================================

Sign_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Sign_Touch
		move.l	#Map_Sign,obMap(a0)			; set mappings
		move.w	#ArtTile_Signpost,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield positioning mode
		move.b	#48/2,obActWid(a0)			; set display width
		move.b	#4,obPriority(a0)			; set sprite priority

Sign_Touch:	; Routine 2
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; subtract signpost's X-position
		blo.s	.notouch				; if Sonic is to the left of signpost, branch
		cmpi.w	#32,d0					; is Sonic within 32 pixels of the signpost?
		bhs.s	.notouch				; if not, branch

		; Touched
		move.w	#sfx_Signpost,d0			; set signpost sound
		jsr	(QueueSound1).l				; play play it
		clr.b	(f_timecount).w				; stop time counter
		move.w	(v_limitright2).w,(v_limitleft2).w	; lock screen position
		addq.b	#2,obRoutine(a0)			; advance to Sign_Spin

	.notouch:
		rts						; return
; ===========================================================================

Sign_Spin:	; Routine 4
		subq.w	#1,spintime(a0)				; subtract 1 from spin time
		bpl.s	.chksparkle				; if time remains, branch

		move.w	#60,spintime(a0)			; set spin cycle time to 1 second
		addq.b	#1,obAnim(a0)				; next spin cycle
		cmpi.b	#3,obAnim(a0)				; have 3 spin cycles completed?
		bne.s	.chksparkle				; if not, branch
		addq.b	#2,obRoutine(a0)			; advance to Sign_SonicRun

	.chksparkle:
		subq.w	#1,sparkletime(a0)			; subtract 1 from time delay
		bpl.s	.return					; if time remains, branch
		move.w	#12-1,sparkletime(a0)			; set time between sparkles

		moveq	#0,d0					; clear d0 (sparkle_id is a byte)
		move.b	sparkle_id(a0),d0			; get sparkle id
		addq.b	#2,sparkle_id(a0)			; increment sparkle counter
		andi.b	#$E,sparkle_id(a0)			; limit to entries in Sign_SparkPos
		lea	Sign_SparkPos(pc,d0.w),a2		; load sparkle position data

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.return					; if object RAM is full, branch
		_move.b	#id_Rings,obID(a1)			; load rings object to use as sparkle effect
		move.b	#6,obRoutine(a1)			; set to Ring_Sparkle routine

		move.b	(a2)+,d0				; get next X-position from Sign_SparkPos
		ext.w	d0					; extend position delta to word
		add.w	obX(a0),d0				; add signposts's base X-position
		move.w	d0,obX(a1)				; set result as X-position for sparkle
		move.b	(a2)+,d0				; get next Y-position from Sign_SparkPos
		ext.w	d0					; extend position delta to word
		add.w	obY(a0),d0				; add signposts's base Y-position
		move.w	d0,obY(a1)				; set result as Y-position for sparkle

		move.l	#Map_Ring,obMap(a1)			; set sparkle mappings
		move.w	#ArtTile_Ring|Tile_Pal2,obGfx(a1)	; set sparkle art tile
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield positioning mode
		move.b	#2,obPriority(a1)			; set sprite priority
		move.b	#8,obActWid(a1)				; set display width

	.return:
		rts						; return to display

; ===========================================================================
Sign_SparkPos:	; x-pos, y-pos
		dc.b -$18,-$10	; $0
		dc.b	8,   8	; $2
		dc.b -$10,   0	; $4
		dc.b  $18,  -8	; $6
		dc.b	0,  -8	; $8
		dc.b  $10,   0	; $A
		dc.b -$18,   8	; $C
		dc.b  $18, $10	; $E
; ===========================================================================

Sign_SonicRun:	; Routine 6
		tst.w	(v_debuguse).w				; is debug mode in use?
		bne.w	Sign_Return				; if yes, don't load end cards until debug mode was exited

	if FixBugs
		; This function's checks are a mess, creating an edge case where it's
		; possible for the player to avoid having their controls locked by
		; jumping at the right side of the screen just as the score tally
		; appears.
		tst.b	(v_player+obID).w			; has Sonic's object been deleted (because he entered the giant ring)?
		beq.s	Sign_LoadEndCards			; if yes, skip all other checks
		btst	#1,(v_player+obStatus).w		; is Sonic airborne?
		bne.w	Sign_Return				; if yes, don't do anything until he has landed
		move.b	#1,(f_lockctrl).w			; lock controls
		move.w	#btnR<<8,(v_jpadhold2).w		; make Sonic run to the right
	else
		btst	#1,(v_player+obStatus).w		; is Sonic airborne?
		bne.s	.airborne				; if yes, don't lock controls
		move.b	#1,(f_lockctrl).w			; lock controls
		move.w	#btnR<<8,(v_jpadhold2).w		; make Sonic run to the right
	; loc_EC70:
	.airborne:
		tst.b	(v_player+obID).w			; has Sonic's object been deleted (because he entered the giant ring)?
		beq.s	Sign_LoadEndCards			; if yes, skip right-side position check
	endif

		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		move.w	(v_limitright2).w,d1			; get right level boundary
		addi.w	#320-24,d1				; add screen width minus 24px of leeway (see Sonic_LevelBound)
		cmp.w	d1,d0					; has Sonic crossed the right side including leeway?
		blo.s	Sign_Return				; if not, don't load end cards yet

; loc_EC86:
Sign_LoadEndCards:
		addq.b	#2,obRoutine(a0)			; advance to Sign_Exit (GotThroughAct is only run once)
		; continue to GotThroughAct...

; ---------------------------------------------------------------------------
; Subroutine to set up bonuses at the end of an act
; ---------------------------------------------------------------------------

GotThroughAct:
		tst.b	(v_endcard).w				; are end cards already loaded?
		bne.s	Sign_Return				; if yes, don't load them again

		; Setup end card sequence
		move.w	(v_limitright2).w,(v_limitleft2).w	; set left level boundary to be the same as the right one
		clr.b	(v_invinc).w				; disable invincibility
		clr.b	(f_timecount).w				; stop time counter
		move.b	#id_GotThroughCard,(v_endcard).w	; load end card object (and prevent this routine from running again)
		moveq	#plcid_TitleCard,d0			; get title cards PLC entry
		jsr	(NewPLC).l				; queue title cards patterns for PLC
		move.b	#1,(f_endactbonus).w			; update bonus HUD for pre-tally display

	; Time Bonus
	if FixBugs
		; Time doesn't update while Debug Mode is enabled, which always results
		; in an annoying, unskippable 50,000 points time bonus with it enabled.
		tst.w	(f_debugmode).w				; is debug mode enabled?
		bne.s	.ringBonus				; if yes, skip time bonus
	endif
		moveq	#0,d0					; clear d0 (minutes are a byte)
		move.b	(v_timemin).w,d0			; get minutes part of time counter
		mulu.w	#60,d0					; convert minutes to seconds
		moveq	#0,d1					; clear d1 (seconds are a byte)
		move.b	(v_timesec).w,d1			; get seconds part of time counter
		add.w	d1,d0					; d0 = total time in seconds level took to beat
		divu.w	#15,d0					; divide by 15 seconds per time bonus entry, d0 is now an index
		moveq	#(NoTimeBonus-TimeBonuses)/2,d1		; get number of time bonus array entries (=20)
		cmp.w	d1,d0					; did level take more than 5 minutes to beat?
		blo.s	.getTimeBonus				; if not, branch
		move.w	d1,d0					; use last time bonus entry (0 points)
	.getTimeBonus:
		add.w	d0,d0					; double for word-based indexing
		move.w	TimeBonuses(pc,d0.w),(v_timebonus).w	; retrieve time bonus value

	; Ring Bonus
	.ringBonus:
		move.w	(v_rings).w,d0				; load number of rings
		mulu.w	#10,d0					; multiply by 10
		move.w	d0,(v_ringbonus).w			; set ring bonus

		; SFX
		move.w	#bgm_GotThrough,d0			; set "Sonic got through" music
		jsr	(QueueSound2).l				; play it

; locret_ECEE:
Sign_Return:
		rts						; return to display
; End of function GotThroughAct

; ===========================================================================
TimeBonuses:	dc.w 5000	; 0:00 - 0:14
		dc.w 5000	; 0:15 - 0:29
		dc.w 1000	; 0:30 - 0:44
		dc.w 500	; 0:45 - 0:59
		dc.w 400	; 1:00 - 1:14
		dc.w 400	; 1:15 - 1:29
		dc.w 300	; 1:30 - 1:44
		dc.w 300	; 1:45 - 1:59
		dc.w 200	; 2:00 - 2:14
		dc.w 200	; 2:15 - 2:29
		dc.w 200	; 2:30 - 2:44
		dc.w 200	; 2:45 - 2:59
		dc.w 100	; 3:00 - 3:14
		dc.w 100	; 3:15 - 3:29
		dc.w 100	; 3:30 - 3:44
		dc.w 100	; 3:45 - 3:59
		dc.w 50		; 4:00 - 4:14
		dc.w 50		; 4:15 - 4:29
		dc.w 50		; 4:30 - 4:44
		dc.w 50		; 4:45 - 4:59
NoTimeBonus:	dc.w 0		; 5:00 - 9:59 (no points)
; ===========================================================================

Sign_Exit:	; Routine 8
		rts						; return to display
; ===========================================================================

		include	"_anim/Signpost.asm"
Map_Sign:	include	"_maps/Signpost.asm"
