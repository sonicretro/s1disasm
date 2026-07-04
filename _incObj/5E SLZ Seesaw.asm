; ===========================================================================
; ---------------------------------------------------------------------------
; Object 5E - seesaws (SLZ)
; 
; Note: Throughout these comments, "ascending" means sloping upwards from
; left to right, and "descending" means going down from left to right.
; ---------------------------------------------------------------------------

Seesaw:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	See_Index(pc,d0.w),d1
		jsr	See_Index(pc,d1.w)
		out_of_range.w	DeleteObject,see_origX(a0),1 ; contains a (redundant) bmi check
		bra.w	DisplaySprite
; ===========================================================================
See_Index:	dc.w See_Main-See_Index			; 0
		dc.w See_Seesaw_Platform-See_Index	; 2
		dc.w See_Seesaw_StoodOn-See_Index	; 4
		dc.w See_Spikeball_Setup-See_Index	; 6
		dc.w See_Spikeball_Action-See_Index	; 8
		dc.w See_Spikeball_InAir-See_Index	; A

see_origX:	equ objoff_30		; initial X-position
see_origY:	equ objoff_34		; initial Y-position
see_landspeed:	equ objoff_38		; stored Y-speed at which Sonic landed on seesaw
see_state_see:	equ objoff_3A		; 0 = descending, 1 = flat, 2 = ascending
see_state_ball:	equ objoff_3A		; 0 = ball on right side, 2 = ball on left side (can't be 1)
see_parent:	equ objoff_3C		; RAM address of parent seesaw object
; ===========================================================================

See_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to See_Seesaw_Platform
		move.l	#Map_Seesaw,obMap(a0)			; set mappings
		move.w	#ArtTile_SLZ_Seesaw,obGfx(a0)		; set art tile
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#96/2,obActWid(a0)			; set sprite display width
		move.w	obX(a0),see_origX(a0)			; remember initial X-position

		tst.b	obSubtype(a0)				; is seesaw meant to spawn spike ball?
		bne.s	.checkXFlip				; if not, branch (seesaws for boss fight)

		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.checkXFlip				; if object RAM is full, branch
		_move.b	#id_Seesaw,obID(a1)			; load spikeball object
		addq.b	#6,obRoutine(a1)			; set to See_Spikeball routine
		move.w	obX(a0),obX(a1)				; copy parent X-position
		move.w	obY(a0),obY(a1)				; copy parent Y-position
		move.b	obStatus(a0),obStatus(a1)		; copy parent X/Y-flip flags
		move.l	a0,see_parent(a1)			; remember RAM location of parent

	.checkXFlip:
		btst	#0,obStatus(a0)				; is seesaw X-flipped? (it never is anywhere the game)
		beq.s	.setState				; if not, branch
		move.b	#2,obFrame(a0)				; use different sloped frame (ascending)

	.setState:
		move.b	obFrame(a0),see_state_see(a0)		; set initial seesaw state (always 0 because seesaws aren't ever flipped)
; ---------------------------------------------------------------------------

See_Seesaw_Platform: ; Routine 2
		move.b	see_state_see(a0),d1			; get current seesaw state (can be changed from spikeball)
		bsr.w	See_ChgFrame				; update seesaw frame if spikeball lands on other side

		lea	(See_DataSlope).l,a2			; load sloped collision data
		btst	#0,obFrame(a0)				; is seesaw flat? (frame1 and 3)
		beq.s	.slopeObject				; if not, branch
		lea	(See_DataFlat).l,a2			; load flat collision data instead

	.slopeObject:
		lea	(v_player).w,a1				; load Sonic player object
		move.w	obVelY(a1),see_landspeed(a0)		; remember Y-speed at which Sonic landed on seesaw

		move.w	#96/2,d1				; width of seesaw for SlopeObject
		jsr	(SlopeObject).l				; handle platform (sets obRoutine to 4 = See_Seesaw_StoodOn if stood on)
		rts						; return
; ===========================================================================

See_Seesaw_StoodOn: ; Routine 4
		bsr.w	See_ChkSide				; update seesaw frame and state based on Sonic's X-position

		lea	(See_DataSlope).l,a2			; load sloped collision data
		btst	#0,obFrame(a0)				; is seesaw flat? (frame1 and 3)
		beq.s	.slopeObject				; if not, branch
		lea	(See_DataFlat).l,a2			; load flat collision data instead

	.slopeObject:
		move.w	#96/2,d1				; width of seesaw for ExitPlatform
		jsr	(ExitPlatform).l			; allow Sonic walking off (sets obRoutine 2 = See_Seesaw_Platform on exit)

		move.w	#96/2,d1				; width of seesaw for SlopeObject_AssumeStoodOn
		move.w	obX(a0),d2				; get platform X-position for SlopeObject_AssumeStoodOn input
		jsr	(SlopeObject_AssumeStoodOn).l		; (part of Object 1A - Collapsing GHZ Ledges)
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set the seesaw tilt based on what side Sonic is on
; ---------------------------------------------------------------------------

See_ChkSide:
		moveq	#2,d1					; set ascending state
		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a0),d0				; get Seesaw's X-position
		sub.w	obX(a1),d0				; calculate difference to seesaw center's X-position
		bcc.s	.checkCenter				; is Sonic on the left side of the seesaw? if yes, branch
		neg.w	d0					; make X-difference positive for check
		moveq	#0,d1					; set descending state

	.checkCenter:
		cmpi.w	#8,d0					; is Sonic within 8px of seesaw center?
		bhs.s	See_ChgFrame				; if not, branch
		moveq	#1,d1					; set flat state
		; continue to See_ChgFrame...
; ---------------------------------------------------------------------------

See_ChgFrame:	; Called from the spikeball to change seesaw tilt without Sonic
		move.b	obFrame(a0),d0				; get current seesaw frame
		cmp.b	d1,d0					; does frame need to change?
		beq.s	.return					; if not, branch
		bcc.s	.setNewSeeFrame				; is new frame ID greater than previous one? if yes, branch
		addq.b	#2,d0					; go to ascending slope frames

	.setNewSeeFrame:
		subq.b	#1,d0					; make frames 0-based
		move.b	d0,obFrame(a0)				; set new seesaw frame 
		move.b	d1,see_state_see(a0)			; update seesaw state (0/1/2)
		bclr	#sprite_xflip_bit,obRender(a0)		; make seesaw descending by default
		btst	#1,obFrame(a0)				; is Sonic standing on the left side of the seesaw?
		beq.s	.return					; if not, branch
		bset	#sprite_xflip_bit,obRender(a0)		; make seesaw ascending instead

	.return:
		rts						; return
; ===========================================================================

; See_Spikeball:
See_Spikeball_Setup: ; Routine 6
		addq.b	#2,obRoutine(a0)			; advance to See_Spikeball_Action
		move.l	#Map_SSawBall,obMap(a0)			; set spikeball mappings
		move.w	#ArtTile_SLZ_Spikeball,obGfx(a0)	; set spikeball art tile
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority (same as seesaw, but always behind due to RAM location)
		move.b	#col_16x16|col_hurt,obColType(a0)	; make spikeball harmful on touch
		move.b	#24/2,obActWid(a0)			; set sprite display width

		move.w	obX(a0),see_origX(a0)			; remember initial X-position
		addi.w	#40,obX(a0)				; adjust spikeball to the right by 40px
		move.w	obY(a0),see_origY(a0)			; remember initial Y-position
		move.b	#1,obFrame(a0)				; initialize to silver spikeball frame
		btst	#0,obStatus(a0)				; is seesaw X-flipped?
		beq.s	See_Spikeball_Action			; if not, branch
		subi.w	#40*2,obX(a0)				; move spikeball to the left side instead
		move.b	#2,see_state_ball(a0)			; set ball state to "on right side"
; ---------------------------------------------------------------------------

; See_MoveSpike:
See_Spikeball_Action: ; Routine 8
		movea.l	see_parent(a0),a1			; get parent seesaw object
		moveq	#0,d0					; clear d0
		move.b	see_state_ball(a0),d0			; get current spikeball state
		sub.b	see_state_see(a1),d0			; check if seesaw state matches it
		beq.s	See_Spikeball_Action_Align		; if yes, branch (don't catapult spike ball)
		bcc.s	.getCatapultSpeed			; if state difference is already positive, branch
		neg.b	d0					; make state difference positive

	.getCatapultSpeed:
		move.w	#-$818,d1				; use slow spikeball catapulting speed
		move.w	#-$114,d2				; X-speed for catapulting

		cmpi.b	#1,d0					; has Sonic landed on the middle of the seesaw to catapult spikeball?
		beq.s	.catapultBall				; if yes, always use slowest speed
		move.w	#-$AF0,d1				; use faster catapulting speed if Sonic landed on side
		move.w	#-$CC,d2				; adjusted X-speed

		cmpi.w	#$A00,see_landspeed(a1)			; has Sonic landed on seesaw with at least $A00 Y-speed? (very fast)
		blt.s	.catapultBall				; if not, branch
		move.w	#-$E00,d1				; use fastest spikeball catapulting speed
		move.w	#-$A0,d2				; adjusted X-speed

	.catapultBall:
		move.w	d1,obVelY(a0)				; catapult spikeball upwards
		move.w	d2,obVelX(a0)				; move spikeball horizontally to the left
		move.w	obX(a0),d0				; get spikeball X-position
		sub.w	see_origX(a0),d0			; is spikeball to the left of the seesaw center?
		bcc.s	.setInAir				; if not, branch
		neg.w	obVelX(a0)				; move spikeball to the right instead

	.setInAir:
		addq.b	#2,obRoutine(a0)			; advance to See_Spikeball_InAir
		bra.s	See_Spikeball_InAir			; go there immediately
; ---------------------------------------------------------------------------

See_Spikeball_Action_Align:
		lea	(See_Spikeball_YOffsets).l,a2		; load spikeball Y-offset array
		moveq	#0,d0					; clear d0
		move.b	obFrame(a1),d0				; use seesaw frame as index for Y-offset array
		move.w	#40,d2					; align spikeball to the right side
		move.w	obX(a0),d1				; get spikeball X-position
		sub.w	see_origX(a0),d1			; calculate difference to seesaw center
		bcc.s	.doAlign				; if ball is on the right side of center, branch
		neg.w	d2					; align ball to the left side instead
		addq.w	#2,d0					; use left-side Y-offset values

	.doAlign:
		add.w	d0,d0					; double for word-based indexing
		move.w	see_origY(a0),d1			; get initial seesaw Y-position
		add.w	(a2,d0.w),d1				; add relative spikeball Y-offset for current seesaw frame
		move.w	d1,obY(a0)				; vertically align spikeball with seesaw tilt

		add.w	see_origX(a0),d2			; add initial X-position to left/right X-offset
		move.w	d2,obX(a0)				; horizontally align spikeball with seesaw

		clr.w	obSubpixelY(a0)				; clear ball Y-subpixel portion
		clr.w	obSubpixelX(a0)				; clear ball X-subpixel portion
		rts						; return
; ===========================================================================

; See_SpikeFall:
See_Spikeball_InAir: ; Routine $A
		tst.w	obVelY(a0)				; is spikeball falling down?
		bpl.s	See_Spikeball_InAir_FallingDown		; if yes, branch

		; Ball is still going up
		bsr.w	ObjectFall				; update spikeball position and make it fall faster
		move.w	see_origY(a0),d0			; get initial Y-position
		subi.w	#47,d0					; check 47px above
		cmp.w	obY(a0),d0				; is spikeball more than 47px above seesaw?
		bgt.s	.return					; if not, branch
		bsr.w	ObjectFall				; double gravity while above threshold

	.return:
		rts						; no landing check while still going up
; ---------------------------------------------------------------------------

See_Spikeball_InAir_FallingDown:
		bsr.w	ObjectFall				; update spikeball position and make it fall faster

		movea.l	see_parent(a0),a1			; get seesaw parent object
		lea	(See_Spikeball_YOffsets).l,a2		; load spikeball Y-offset array
		moveq	#0,d0					; clear d0
		move.b	obFrame(a1),d0				; use seesaw frame as index for Y-offset array
		move.w	obX(a0),d1				; get spikeball's current X-position while in air
		sub.w	see_origX(a0),d1			; calculate difference to seesaw center
		bcc.s	.checkLanded				; if ball is on the right side of center, branch
		addq.w	#2,d0					; use left-side Y-offset values

	.checkLanded:
		add.w	d0,d0					; double for word-based indexing
		move.w	see_origY(a0),d1			; get initial seesaw Y-position
		add.w	(a2,d0.w),d1				; add relative spikeball Y-offset for current seesaw frame
		cmp.w	obY(a0),d1				; has spikeball landed on the seesaw again?
		bgt.s	.return					; if not, branch

		movea.l	see_parent(a0),a1			; reload parent seesaw object (redundant)
		moveq	#2,d1					; bounce if spikeball landed on left side
		tst.w	obVelX(a0)				; is spikeball moving to the right?
		bmi.s	.checkBounce				; if not, branch
		moveq	#0,d1					; bounce if spikeball landed on right side

	.checkBounce:
		move.b	d1,see_state_see(a1)			; update seesaw state
		move.b	d1,see_state_ball(a0)			; update spike ball state
		cmp.b	obFrame(a1),d1				; is seesaw lowered on the side the ball landed on?
		beq.s	.resetBall				; if yes, don't bounce Sonic (because that wouldn't make sense)

		; Make Sonic bounce as spikeball lands again
		bclr	#3,obStatus(a1)				; clear seesaw's stood-on flag
		beq.s	.resetBall				; was Sonic standing on seesaw as ball landed? if not, branch
		clr.b	obSolid(a1)				; clear seesaw's solidity flags
		move.b	#2,obRoutine(a1)			; reset seesaw back to See_Seesaw_Platform
		lea	(v_player).w,a2				; load Sonic player object
		move.w	obVelY(a0),obVelY(a2)			; bounce Sonic based on seesaw speed
		neg.w	obVelY(a2)				; bounce Sonic upwards
		bset	#1,obStatus(a2)				; set Sonic's in-air flag
		bclr	#3,obStatus(a2)				; clear Sonic's on-platform flag
		clr.b	jumping(a2)				; clear Sonic's jumping flag
		move.b	#id_Spring,obAnim(a2)			; change Sonic's animation to "spring" ($10)
		move.b	#2,obRoutine(a2)			; force Sonic to Sonic_Control routine
		move.w	#sfx_Spring,d0				; set spring sound
		jsr	(QueueSound2).l				; play it

	.resetBall:
		clr.w	obVelX(a0)				; stop ball moving horizontally
		clr.w	obVelY(a0)				; stop ball falling
		subq.b	#2,obRoutine(a0)			; reset ball back to See_Spikeball_Action

	.return:
		rts						; return

; ===========================================================================
; Relative Y-distances to align spikeball with seesaw
See_Spikeball_YOffsets:
		dc.w	 -8		; ball right, seesaw descending
		dc.w	-28		; ball right, seesaw flat
		dc.w	-47		; ball right, seesaw ascending  (shared)
					; ball left,  seesaw descending (shared)
		dc.w	-28		; ball left,  seesaw flat
		dc.w	 -8		; ball left,  seesaw ascending
; ===========================================================================

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for seesaws (SLZ)
; ---------------------------------------------------------------------------

See_DataSlope:
		dcb.b	  2,$24		; flat
		range	$26,$2C,+2	; ascending
		range	$2A,$24,-2	; descending
		range	$23,$03,-1	; descending
		dcb.b	  5,$02		; flat
		even

See_DataFlat:
		dcb.b	 48,$15		; flat
		even

; ===========================================================================

Map_Seesaw:	include	"_maps/Seesaw.asm"
Map_SSawBall:	include	"_maps/Seesaw Ball.asm"
