; ===========================================================================
; ---------------------------------------------------------------------------
; Object 64 - air bubbles (LZ)
; ---------------------------------------------------------------------------

Bubble:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bub_Index(pc,d0.w),d1
		jmp	Bub_Index(pc,d1.w)
; ===========================================================================
Bub_Index:	dc.w Bub_Main-Bub_Index		; 0
		dc.w Bub_Inflate-Bub_Index	; 2
		dc.w Bub_ChkWater-Bub_Index	; 4
		dc.w Bub_Bursting-Bub_Index	; 6
		dc.w Bub_BurstDelete-Bub_Index	; 8
		dc.w Bub_BubbleMaker-Bub_Index	; A

bub_inhalable:	equ objoff_2E	; flag set when bubble is collectable
bub_origX: 	equ objoff_30	; original x-axis position
bub_time:	equ objoff_32	; time until next large bubble spawn
bub_timebase:	equ objoff_33	; base time to reset bub_time to after bubble spawn

bub_minicount:	equ objoff_34	; number of smaller bubbles to spawn
bub_bubbleflag:	equ objoff_36	; 1 = bubbles currently spawning; +$4000 = large bubble spawned; +$8000 = allow large bubble
bub_randomtime:	equ objoff_38	; randomised time between mini bubble spawns
bub_typelist:	equ objoff_3C	; address of bubble type list
; ===========================================================================

Bub_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Bub_Inflate
		move.l	#Map_Bub,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Bubbles|Tile_Prio,obGfx(a0)	; set art tile and priority flag
		move.b	#sprite_rendered|sprite_cam_field,obRender(a0) ; set to playfield-positioned mode and set rendered flag (avoid immediate deletion)
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)

		move.b	obSubtype(a0),d0			; get bubble type
		bpl.s	.bubble					; is this a bubble maker? (subtype $80 or above)
		addq.b	#8,obRoutine(a0)			; goto Bub_BubbleMaker next
		andi.w	#$7F,d0					; read only last 7 bits (deduct $80)
		move.b	d0,bub_time(a0)				; set bubble frequency (current)
		move.b	d0,bub_timebase(a0)			; set bubble frequency (base)
		move.b	#6,obAnim(a0)				; set to bubble maker animation
		bra.w	Bub_BubbleMaker				; go straight to bubble maker logic
; ===========================================================================

.bubble:
		move.b	d0,obAnim(a0)				; set bubble size from subtype (0 = small, 1 = medium, 2 = large)
		move.w	obX(a0),bub_origX(a0)			; remember original X-position
		move.w	#-$88,obVelY(a0)			; slowly float bubble upwards
		jsr	(RandomNumber).l			; get a random number
		move.b	d0,obAngle(a0)				; set random start angle for wobble effect
; ---------------------------------------------------------------------------

Bub_Inflate:	; Routine 2
		lea	(Ani_Bub).l,a1				; all animation scripts for individual bubbles increase obRoutine on finish
		jsr	(AnimateSprite).l			; (i.e. they advance to Bub_ChkWater)

		cmpi.b	#6,obFrame(a0)				; is bubble full-size?
		bne.s	Bub_ChkWater				; if not, branch
		move.b	#1,bub_inhalable(a0)			; set "inhalable" flag
; ---------------------------------------------------------------------------

Bub_ChkWater:	; Routine 4
		move.w	(v_waterpos1).w,d0			; get current water height including surface sway
		cmp.w	obY(a0),d0				; is bubble still underwater?
		blo.s	.wobble					; if yes, branch

.burst:
		move.b	#6,obRoutine(a0)			; goto Bub_Bursting next
		addq.b	#3,obAnim(a0)				; run "bursting" animation
		bra.w	Bub_Bursting				; display bursting bubble
; ===========================================================================

.wobble:
		move.b	obAngle(a0),d0				; get current wobble angle
		addq.b	#1,obAngle(a0)				; increment next wobble angle
		andi.w	#$7F,d0					; limit wobble angle to $80 positions
		lea	(Drown_WobbleData).l,a1			; load wobble offset array
		move.b	(a1,d0.w),d0				; read wobble offset for current angle
		ext.w	d0					; make word-based
		add.w	bub_origX(a0),d0			; add base X-position
		move.w	d0,obX(a0)				; set change bubble's X-position with wobble offset

		; Logic for large, inhalable bubbles
		tst.b	bub_inhalable(a0)			; is this a large, inhalable bubble?
		beq.s	.display				; if not, branch
	if FixBugs
		; Fix air bubbles being inhalable while in debug mode
		tst.w	(v_debuguse).w				; is debug mode active?
		bne.s	.display				; if yes, branch
	endif
		bsr.w	Bub_ChkSonic				; has Sonic touched the bubble?
		beq.s	.display				; if not, branch

		bsr.w	ResumeMusic				; cancel countdown music (if necessary)
		move.w	#sfx_Bubble,d0
		jsr	(QueueSound2).l				; play collecting bubble sound

		lea	(v_player).w,a1				; load Sonic player object
		clr.w	obVelX(a1)				; stop Sonic horizontally
		clr.w	obVelY(a1)				; stop Sonic vertically
		clr.w	obInertia(a1)				; stop Sonic's ground speed
		move.b	#id_GetAir,obAnim(a1)			; make Sonic use bubble-collecting animation
		move.w	#35,locktime(a1)			; disable D-Pad input for 35 frames
		move.b	#0,jumping(a1)				; clear jumping flag
		bclr	#5,obStatus(a1)				; clear pushing flag
		bclr	#4,obStatus(a1)				; clear roll-jump flag

		btst	#2,obStatus(a1)				; was Sonic rolling as he touched the bubble?
		beq.w	.burst					; if not, branch
		bclr	#2,obStatus(a1)				; clear Sonic's rolling flag
		move.b	#sonic_height,obHeight(a1)		; reset height to standing
		move.b	#sonic_width,obWidth(a1)		; reset width to standing
		subq.w	#sonic_height-sonic_roll_height,obY(a1)	; undo Y-offset from rolling
		bra.w	.burst					; make the bubble burst
; ===========================================================================

.display:
		bsr.w	SpeedToPos				; update bubble's position
		tst.b	obRender(a0)				; has bubble gone offscreen?
		bpl.s	.delete					; if yes, delete it
		jmp	(DisplaySprite).l			; display bubble

	.delete:
		jmp	(DeleteObject).l			; delete bubble
; ===========================================================================

Bub_Bursting:	; Routine 6
		lea	(Ani_Bub).l,a1				; bursting animation will increase obRoutine on finish
		jsr	(AnimateSprite).l			; (i.e. advance to Bub_BurstDelete)

		tst.b	obRender(a0)				; has bubble gone offscreen?
		bpl.s	.delete					; if yes, delete it
		jmp	(DisplaySprite).l			; display bubble

	.delete:
		jmp	(DeleteObject).l			; delete bubble
; ===========================================================================

Bub_BurstDelete: ; Routine 8
		bra.w	DeleteObject				; delete bubble

; ===========================================================================
; ---------------------------------------------------------------------------
; Bubble maker that sits on the floor and spawns bubbles at random intervals
; ---------------------------------------------------------------------------

Bub_BubbleMaker: ; Routine $A
		tst.w	bub_bubbleflag(a0)			; is a bubble currently getting spawned?
		bne.s	.waitForBubble				; if yes, branch

		move.w	(v_waterpos1).w,d0			; get current water height including sway
		cmp.w	obY(a0),d0				; is bubble maker underwater?
		bhs.w	.display				; if not, don't spawn bubbles
		tst.b	obRender(a0)				; is bubble maker on screen?
		bpl.w	.display				; if not, don't spawn bubbles

		subq.w	#1,bub_randomtime(a0)			; decrement time until next bubble spawn
		bpl.w	.animate				; if time remains, branch
		move.w	#1,bub_bubbleflag(a0)			; set to bubble spawning mode

	.tryAgain:
		jsr	(RandomNumber).l			; get random number in d0
		move.w	d0,d1					; backup random result
		andi.w	#7,d0					; limit to 0-7
		cmpi.w	#6,d0					; is random number result 6 or 7?
		bhs.s	.tryAgain				; if yes, loop until it's less than 6
		move.b	d0,bub_minicount(a0)			; set number of small bubbles to be spawned (0-5)

		andi.w	#$C,d1					; limit random result to multiples of 4, up to 12
		lea	(Bub_BblTypes).l,a1			; load bubble creation sequence
		adda.w	d1,a1					; add random result as starting offset
		move.l	a1,bub_typelist(a0)			; set start position for bubble spawn sequence

		subq.b	#1,bub_time(a0)				; decrement large bubble fallback timer
		bpl.s	.goSpawn				; if time remains, branch
		move.b	bub_timebase(a0),bub_time(a0)		; reset timer
		bset	#7,bub_bubbleflag(a0)			; set flag to load a large bubble
	.goSpawn:
		bra.s	.spawnBubble				; skip over timer to spawn bubble immediately
; ===========================================================================

.waitForBubble:
		subq.w	#1,bub_randomtime(a0)			; decrement time until next bubble spawn
		bpl.w	.animate				; if time remains, branch

.spawnBubble:
		jsr	(RandomNumber).l			; get random number in d0
		andi.w	#$1F,d0					; limit random time to $20 frames
		move.w	d0,bub_randomtime(a0)			; set new random time

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.chkReset				; if object RAM is full, branch
		_move.b	#id_Bubble,obID(a1)			; load bubble object
		move.w	obX(a0),obX(a1)				; horizontally spawn bubble at bubble maker
		jsr	(RandomNumber).l			; get random number in d0
		andi.w	#$F,d0					; limit to 16px
		subq.w	#8,d0					; balance around -8px and +8px
		add.w	d0,obX(a1)				; add random X-offset for bubble
		move.w	obY(a0),obY(a1)				; vertically spawn bubble at bubble maker

		moveq	#0,d0					; clear d0
		move.b	bub_minicount(a0),d0			; get number of small bubbles left to spawn
		movea.l	bub_typelist(a0),a2			; get random start index in Bub_BblTypes
		move.b	(a2,d0.w),obSubtype(a1)			; set bubble size to small or medium

		btst	#7,bub_bubbleflag(a0)			; is a large/inhalable set to be spawned?
		beq.s	.chkReset				; if not, branch
		jsr	(RandomNumber).l			; get random number in d0
		andi.w	#3,d0					; 1/4 chance for large bubble
		bne.s	.chkFallback				; branch in other cases
		bset	#6,bub_bubbleflag(a0)			; set flag that large bubble has been spawned
		bne.s	.chkReset				; was flag already set? if yes, branch
		move.b	#2,obSubtype(a1)			; set bubble to large/inhalable

	.chkFallback:
		tst.b	bub_minicount(a0)			; have all small bubbles been spawned?
		bne.s	.chkReset				; if not, branch
		bset	#6,bub_bubbleflag(a0)			; set flag that large bubble has been spawned
		bne.s	.chkReset				; was flag already set? if yes, branch
		move.b	#2,obSubtype(a1)			; set bubble to large/inhalable

	.chkReset:
		subq.b	#1,bub_minicount(a0)			; decrement number of small bubbles to spawn
		bpl.s	.animate				; if more remain, branch
		jsr	(RandomNumber).l			; get random number in d0
		andi.w	#$7F,d0					; limit to 0-127
		addi.w	#$80,d0					; add 128
		add.w	d0,bub_randomtime(a0)			; set new random time to 128-255 frames (roughly 2-4 seconds)
		clr.w	bub_bubbleflag(a0)			; reset bubble spawning flag
; ---------------------------------------------------------------------------

.animate:
		lea	(Ani_Bub).l,a1				; load animation scripts
		jsr	(AnimateSprite).l			; animate bubble maker

.display:
		out_of_range.w	DeleteObject			; has bubble maker gone offscreen? if yes, delete it
		move.w	(v_waterpos1).w,d0			; get current water height including sway
		cmp.w	obY(a0),d0				; is bubble maker underwater?
		blo.w	DisplaySprite				; if yes, display it
		rts						; otherwise, keep it hidden

; ===========================================================================

; Non-inhalable bubbles production sequence: 0 = small, 1 = medium
Bub_BblTypes:	dc.b 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if Sonic is within range of a large, inhalable bubble
; ---------------------------------------------------------------------------

Bub_ChkSonic:
		tst.b	(f_playerctrl).w			; is Sonic's object interaction currently disabled?
		bmi.s	.dontCollectBubble			; if yes, branch

		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a1),d0				; get Sonic's current X-position
		move.w	obX(a0),d1				; get bubble's current X-position
		subi.w	#16,d1					; check left
		cmp.w	d0,d1					; is Sonic within left edge of bubble?
		bhs.s	.dontCollectBubble			; if not, branch
		addi.w	#16*2,d1				; check right
		cmp.w	d0,d1					; is Sonic wtihin right edge of bubble?
		blo.s	.dontCollectBubble			; if not, branch

		move.w	obY(a1),d0				; get Sonic's current Y-position
		move.w	obY(a0),d1				; get bubble's current Y-position
		cmp.w	d0,d1					; is Sonic within top edge of bubble? (top-leaning for his head)
		bhs.s	.dontCollectBubble			; if not, branch
		addi.w	#16,d1					; check bottom
		cmp.w	d0,d1					; is Sonic within bottom edge of bubble?
		blo.s	.dontCollectBubble			; if not, branch

	.collectBubble:
		moveq	#1,d0					; set flag (bubble in range)
		rts						; return with result in CCR

	.dontCollectBubble:
		moveq	#0,d0					; clear flag (bubble not in range)
		rts						; return with result in CCR
; End of function Bub_ChkSonic

; ===========================================================================

		include	"_anim/Bubbles.asm"
Map_Bub:	include	"_maps/Bubbles.asm"
