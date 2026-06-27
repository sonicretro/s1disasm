; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0A - drowning countdown numbers and small bubbles that float out of
; Sonic's mouth (LZ)
; ---------------------------------------------------------------------------

DrownCount:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Drown_Index(pc,d0.w),d1
		jmp	Drown_Index(pc,d1.w)
; ===========================================================================
Drown_Index:	dc.w Drown_Main-Drown_Index		; 0
		dc.w Drown_Animate-Drown_Index		; 2
		dc.w Drown_ChkWater-Drown_Index		; 4
		dc.w Drown_Display-Drown_Index		; 6
		dc.w Drown_Delete-Drown_Index		; 8
		dc.w Drown_Countdown-Drown_Index	; A
		dc.w Drown_AirLeft-Drown_Index		; C
		dc.w Drown_Display-Drown_Index		; E
		dc.w Drown_Delete-Drown_Index		; 10

drown_restarttime:	equ objoff_2C	; time to restart after Sonic drowns
drown_origX:		equ objoff_30	; original x-axis position
drown_displaytime:	equ objoff_32	; time to display each number
drown_type:		equ objoff_33	; bubble type
drown_extrabubbles:	equ objoff_34	; number of extra bubbles to create
drown_extrabubflag:	equ objoff_36	; flags for extra bubbles
drown_numtime:		equ objoff_38	; time between each number changes
drown_delaytime:	equ objoff_3A	; delay between bubbles
; ===========================================================================

Drown_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Drown_Animate
		move.l	#Map_Bub,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Bubbles|Tile_Prio,obGfx(a0)	; set art tile and priority flag
		move.b	#sprite_rendered|sprite_cam_field,obRender(a0) ; rendered flag to prevent immediate deletion and playfield-positioned mode
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)

		move.b	obSubtype(a0),d0			; get bubble type
		bpl.s	.numberBubble				; is this the special countdown object (set from Obj01_InWater)? if not, branch
		addq.b	#8,obRoutine(a0)			; advance to Drown_Countdown
		move.l	#Map_Drown,obMap(a0)			; set drown numbers mappings
		move.w	#ArtTile_LZ_Sonic_Drowning,obGfx(a0)	; set drown numbers art tile
		andi.w	#$7F,d0					; clear drown countdown bit from subtype
		move.b	d0,drown_type(a0)			; set bubble type
		bra.w	Drown_Countdown				; skip directly to countdown logic
; ===========================================================================

	.numberBubble:
		move.b	d0,obAnim(a0)				; set "appear" animation from subtype (0-5)
		move.w	obX(a0),drown_origX(a0)			; remember base X-position for wobble effect
		move.w	#-$88,obVelY(a0)			; slowly move bubbles upwards
; ---------------------------------------------------------------------------

Drown_Animate:	; Routine 2
		lea	(Ani_Drown).l,a1			; load animation scripts
		jsr	(AnimateSprite).l			; (scripts will advance obRoutine to Drown_ChkWater on finish)
; ---------------------------------------------------------------------------

Drown_ChkWater:	; Routine 4
		move.w	(v_waterpos1).w,d0			; get current water height
		cmp.w	obY(a0),d0				; has bubble reached the water surface?
		blo.s	.wobble					; if not, branch

		move.b	#6,obRoutine(a0)			; goto Drown_Display next
		addq.b	#7,obAnim(a0)				; advance number bubble to "flashing" animation ()

	if FixBugs
		; Fixes a graphical glitch with bubbles hitting the surface
		cmpi.b	#$E,obAnim(a0)				; is this the "mediumbubble" animation?
		blo.s	Drown_Display				; if not, branch
		move.b	#$D,obAnim(a0)				; force back to "blank" animation
		bra.s	Drown_Display				; display number and animate
	else
		cmpi.b	#$D,obAnim(a0)				; is this the "blank" animation?
		beq.s	Drown_Display				; if yes, branch
		bra.s	Drown_Display				; if not... also branch (what?)
	endif
; ===========================================================================

.wobble:
		tst.b	(f_wtunnelmode).w			; is Sonic in a wind tunnel?
		beq.s	.notunnel				; if not, branch
		addq.w	#4,drown_origX(a0)			; move bubbles to the right at 4px/frame

	.notunnel:
		move.b	obAngle(a0),d0				; get current wobble data offset
		addq.b	#1,obAngle(a0)				; increment offset for next frame
		andi.w	#$7F,d0					; limit to $80 bytes
		lea	(Drown_WobbleData).l,a1			; load wobble pixel offset data
		move.b	(a1,d0.w),d0				; find offset for current angle value
		ext.w	d0					; extend to word-size
		add.w	drown_origX(a0),d0			; add initial X-position
		move.w	d0,obX(a0)				; set wobbled X-position

		bsr.s	Drown_ShowNumber			; handle number bubbles

		jsr	(SpeedToPos).l				; update bubble position
		tst.b	obRender(a0)				; has bubble gone offscreen?
		bpl.s	.delete					; if yes, delete it
		jmp	(DisplaySprite).l			; display bubble

	.delete:
		jmp	(DeleteObject).l			; delete bubble
; ===========================================================================

Drown_Display:	; Routine 6, Routine $E
		bsr.s	Drown_ShowNumber			; handle number bubbles

		lea	(Ani_Drown).l,a1			; load animation scripts
		jsr	(AnimateSprite).l			; (note: all bubble animations advance obRoutine)
		jmp	(DisplaySprite).l			; display bubble
; ===========================================================================

Drown_Delete:	; Routine 8, Routine $10
		jmp	(DeleteObject).l			; delete object
; ===========================================================================

Drown_AirLeft:	; Routine $C
		cmpi.w	#12,(v_air).w				; has countdown music started? (less than 12 seconds of air left)
		bhi.s	.delete					; if not, don't show number bubbles

		subq.w	#1,drown_numtime(a0)			; decrement time before advancing number bubble routine
		bne.s	.display				; if time remains, branch
		move.b	#$E,obRoutine(a0)			; goto Drown_Display next (second one, $E)
		addq.b	#7,obAnim(a0)				; advance to "flashing number bubble" animation
		bra.s	Drown_Display				; display number bubble
; ---------------------------------------------------------------------------

	.display:
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l
		tst.b	obRender(a0)				; has bubble gone offscreen?
		bpl.s	.delete					; if yes, delete it
		jmp	(DisplaySprite).l			; display bubble

	.delete:	
		jmp	(DeleteObject).l			; delete bubble
; ===========================================================================

Drown_ShowNumber:
		tst.w	drown_numtime(a0)			; is a delay set?
		beq.s	.return					; if not, branch
		subq.w	#1,drown_numtime(a0)			; decrement delay before changing number bubble
		bne.s	.return					; if time remains, branch
		cmpi.b	#7,obAnim(a0)				; is bubble already set to "flashing" animation?
		bhs.s	.return					; if yes, branch

		move.w	#15,drown_numtime(a0)			; reset delay to 15 frames
		clr.w	obVelY(a0)				; stop bubble from moving
		move.b	#sprite_rendered,obRender(a0)		; change bubble to screen-fixed positioning mode

		move.w	obX(a0),d0				; get playfield X-position 
		sub.w	(v_screenposx).w,d0			; subtract camera X-position
		addi.w	#$80,d0					; add $80px sprite offscreen offset
		move.w	d0,obX(a0)				; set as new screen-fixed X-position

		move.w	obY(a0),d0				; get playfield Y-position 
		sub.w	(v_screenposy).w,d0			; subtract camera Y-position
		addi.w	#$80,d0					; add $80px sprite offscreen offset
		move.w	d0,obScreenY(a0)			; set as new screen-fixed Y-position

		move.b	#$C,obRoutine(a0)			; goto Drown_AirLeft next

	.return:
		rts						; return
; End of function Drown_ShowNumber

; ===========================================================================
Drown_WobbleData:
	; In REV01, this data is repeated once for the water ripple effect,
	; and the "4" at the start of the third line has been changed to a "3".
	if Revision=0
		dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
		dc.b 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
		dc.b 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
		dc.b 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
		dc.b 0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -3, -3, -3, -3, -3
		dc.b -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4
		dc.b -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3
		dc.b -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1
	else
	    rept 2
		dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
		dc.b 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
		dc.b 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
		dc.b 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
		dc.b 0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -3, -3, -3, -3, -3
		dc.b -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4
		dc.b -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3
		dc.b -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1
	    endr
	endif
; ===========================================================================

Drown_Countdown:; Routine $A
		tst.w	drown_restarttime(a0)			; has Sonic already in drowning state?
		bne.w	.sonicIsDrowning			; if yes, go to drowning handler

		cmpi.b	#6,(v_player+obRoutine).w		; has Sonic already died?
		bhs.w	.return					; if yes, branch
		btst	#6,(v_player+obStatus).w		; is Sonic underwater?
		beq.w	.return					; if not, branch

		subq.w	#1,drown_numtime(a0)			; decrement timer until next "decrement seconds of air"
		bpl.w	.checkSpawnExtraBubbles			; branch if time remains
		move.w	#60-1,drown_numtime(a0)			; reset timer to one second (60 frames)

		move.w	#1,drown_extrabubflag(a0)		; trigger extra bubbles to start spawning
		jsr	(RandomNumber).l			; get a random number in d0
		andi.w	#1,d0					; limit to 0 or 1
		move.b	d0,drown_extrabubbles(a0)		; spawn 0 or 1 extra bubbles

		move.w	(v_air).w,d0				; check seconds of air remaining
		cmpi.w	#25,d0					; 25 seconds left?
		beq.s	.warningSound				; if yes, play sound
		cmpi.w	#20,d0					; 20 seconds left?
		beq.s	.warningSound				; if yes, play sound
		cmpi.w	#15,d0					; 15 seconds left?
		beq.s	.warningSound				; if yes, play sound
		cmpi.w	#12,d0					; 12 seconds left?
		bhi.s	.reduceAir				; if air is above 12, branch
		bne.s	.countdown				; is air EXACTLY 12 seconds? if not, branch
		move.w	#bgm_Drowning,d0			; set countdown music
		jsr	(QueueSound1).l				; play it

	.countdown:
		subq.b	#1,drown_displaytime(a0)		; decrement timer until next number bubble
		bpl.s	.reduceAir				; if time remains, branch
		move.b	drown_type(a0),drown_displaytime(a0)	; reset timer until next number bubble
		bset	#7,drown_extrabubflag(a0)		; trigger a new number bubble to spawn
		bra.s	.reduceAir				; don't play warning sound again
; ---------------------------------------------------------------------------

	.warningSound:
		move.w	#sfx_Warning,d0				; set "ding-ding" warning sound
		jsr	(QueueSound2).l				; play it 

.reduceAir:
		subq.w	#1,(v_air).w				; subtract 1 second from air remaining
		bhs.w	.gotoSpawnExtraBubbles			; if air is above 0, branch (and always spawn a bubble)

		; Sonic drowns here
		bsr.w	ResumeMusic				; restart level music
		move.b	#$81,(f_playerctrl).w			; lock controls and disable object interaction
		move.w	#sfx_Drown,d0				; set drowning sound
		jsr	(QueueSound2).l				; play it
		move.b	#10,drown_extrabubbles(a0)		; spawn 10 extra bubbles on drown
		move.w	#1,drown_extrabubflag(a0)		; trigger extra bubbles to start spawning
		move.w	#2*60,drown_restarttime(a0)		; wait 2 seconds before changing to Sonic_Death state

		move.l	a0,-(sp)				; backup current object
		lea	(v_player).w,a0				; load Sonic player object
		bsr.w	Sonic_ResetOnFloor			; reset Sonic's state to grounded
		move.b	#id_Drown,obAnim(a0)			; use Sonic's drowning animation
		bset	#1,obStatus(a0)				; set Sonic to in-air
		bset	#7,obGfx(a0)				; make Sonic's sprite high priority
		move.w	#0,obVelY(a0)				; cancel Y-speed
		move.w	#0,obVelX(a0)				; cancel X-speed
		move.w	#0,obInertia(a0)			; cancel ground speed
		move.b	#1,(f_nobgscroll).w			; disable plane scrolling while drowning
	if FixBugs
		; Correct Drowning Bugs
		move.b	#2,obRoutine(a0)			; make sure Sonic is in his default state (Sonic_Control)
		clr.b	(f_timecount).w				; also stop the timer immediately to avoid double deaths from Time Overs
	endif
		movea.l	(sp)+,a0				; restore current object
		rts						; return
; ===========================================================================

.sonicIsDrowning:
		subq.w	#1,drown_restarttime(a0)		; decrement timer before triggering actual death
		bne.s	.sinking				; if time remains, branch
		move.b	#6,(v_player+obRoutine).w		; set Sonic to Sonic_Death to deduct life and restart level
		rts						; return
; ---------------------------------------------------------------------------

	.sinking:
		move.l	a0,-(sp)				; backup current object
		lea	(v_player).w,a0				; load Sonic player object
		jsr	(SpeedToPos).l				; update Sonic's position
		addi.w	#$10,obVelY(a0)				; make Sonic sink faster
		movea.l	(sp)+,a0				; restore current object
		bra.s	.checkSpawnExtraBubbles
; ===========================================================================

.gotoSpawnExtraBubbles:
		bra.s	.spawnExtraBubbles			; (kind of a superfluous redirect...)
; ---------------------------------------------------------------------------

.checkSpawnExtraBubbles:
		tst.w	drown_extrabubflag(a0)			; are extra bubbles set to be spawned?
		beq.w	.return					; if not, branch
		subq.w	#1,drown_delaytime(a0)			; decrement timer until next bubble spawn
		bpl.w	.return					; if time remains, branch

.spawnExtraBubbles:
		jsr	(RandomNumber).l			; get a random number in d0
		andi.w	#$F,d0					; limit to 0-15
		move.w	d0,drown_delaytime(a0)			; spawn next extra bubble in 0-15 frames

		jsr	(FindFreeObj).l				; find a free object slot
		bne.w	.return					; if object RAM is full, branch
		_move.b	#id_DrownCount,obID(a1)			; load an extra bubble object

		move.w	(v_player+obX).w,obX(a1)		; match X-position to Sonic
		moveq	#6,d0					; offset it 6px to the right
		btst	#0,(v_player+obStatus).w		; is Sonic flipped horizontally?
		beq.s	.noflip					; if not, branch
		neg.w	d0					; offset it 6px to the left instead
		move.b	#$40,obAngle(a1)			; use alternate start offset for wobble data
	.noflip:
		add.w	d0,obX(a1)				; offset bubble +/- 6px horizontally
		move.w	(v_player+obY).w,obY(a1)		; match Y-position to Sonic
		move.b	#6,obSubtype(a1)			; set to "small bubble"

		tst.w	drown_restarttime(a0)			; is Sonic currently drowning?
		beq.w	.checkNumberBubble			; if not, branch
		andi.w	#7,drown_delaytime(a0)			; make next extra bubble spawn in no more than 0-7 frames
		addi.w	#0,drown_delaytime(a0)			; (pointless zero addition, probably a leftover)
		move.w	(v_player+obY).w,d0			; get Sonic's current Y-position
		subi.w	#12,d0					; spawn bubbles 12px higher (to match Sonic's mouth)
		move.w	d0,obY(a1)				; set bubble Y-position while drowning
		jsr	(RandomNumber).l			; get a random number in d0
		move.b	d0,obAngle(a1)				; use random wobble data start index
		move.w	(v_framecount).w,d0			; get current level frame counter
		andi.b	#3,d0					; 1/4 chance to spawn a big bubble
		bne.s	.decrementExtraBubbles			; branch in other cases
		move.b	#$E,obSubtype(a1)			; set to "medium bubble" instead of small
		bra.s	.decrementExtraBubbles			; skip over
; ===========================================================================

.checkNumberBubble:
		btst	#7,drown_extrabubflag(a0)		; is a number bubble flagged to be spawned?
		beq.s	.decrementExtraBubbles			; if not, branch
		move.w	(v_air).w,d2				; get remaining air in seconds
		lsr.w	#1,d2					; d2 = animation ID for number bubble (0-5)
		jsr	(RandomNumber).l			; get a random number in d0
		andi.w	#3,d0					; 1/4 chance
		bne.s	.secondTry				; branch on other random numbers
		bset	#6,drown_extrabubflag(a0)		; set flag that number bubble was spawned
		bne.s	.decrementExtraBubbles			; was flag already set? if yes, branch
		move.b	d2,obSubtype(a1)			; set bubble to be a number bubble instead
		move.w	#28,drown_numtime(a1)			; delay for 28 frames before showing number bubble
	.secondTry:
		tst.b	drown_extrabubbles(a0)			; are more extra bubbles meant to be spawned?
		bne.s	.decrementExtraBubbles			; if yes, branch
		bset	#6,drown_extrabubflag(a0)		; set flag that number bubble was spawned
		bne.s	.decrementExtraBubbles			; was flag already set? if yes, branch
		move.b	d2,obSubtype(a1)			; set bubble to be a number bubble instead
		move.w	#28,drown_numtime(a1)			; delay for 28 frames before showing number bubble

.decrementExtraBubbles:
		subq.b	#1,drown_extrabubbles(a0)		; decrement number of remaining extra bubbles to spawn
		bpl.s	.return					; if more are left, branch
		clr.w	drown_extrabubflag(a0)			; stop spawning extra bubbles

	.return:
		rts						; return
; ===========================================================================

		include	"_incObj/sub ResumeMusic.asm"

; ===========================================================================

		include	"_anim/Drowning Countdown.asm"
Map_Drown:	include	"_maps/Drowning Countdown.asm"
