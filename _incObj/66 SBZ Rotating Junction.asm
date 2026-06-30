; ===========================================================================
; ---------------------------------------------------------------------------
; Object 66 - rotating disc junction that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------

Junction:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Jun_Index(pc,d0.w),d1
		jmp	Jun_Index(pc,d1.w)
; ===========================================================================
Jun_Index:	dc.w Jun_Main-Jun_Index
		dc.w Jun_Action-Jun_Index
		dc.w Jun_Display-Jun_Index
		dc.w Jun_Inside-Jun_Index

jun_direction:	equ objoff_34		; current rotation direction (1 = clockwise, -1 = counterclockwise)
jun_switchdown:	equ objoff_36		; flag set while reversal switch is pressed down by Sonic
jun_switchid:	equ objoff_38		; which switch ID will reverse the disc
jun_unused:	equ objoff_30		; (set to 60, but unused)
jun_grabframe:	equ objoff_32		; frame ID that triggered Sonic getting grabbed by junction
; ===========================================================================

Jun_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Jun_Action
		move.w	#2-1,d1					; create two objects
		movea.l	a0,a1					; write first object to current RAM location
		bra.s	.makeitem				; keep first obejct at obRoutine 2
; ---------------------------------------------------------------------------

	.loop:
		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.next					; if object RAM is full, branch
		_move.b	#id_Junction,obID(a1)			; load circular cover-up filler sprites object
		addq.b	#4,obRoutine(a1)			; set to Jun_Display (do nothing but display)
		move.w	obX(a0),obX(a1)				; copy parent X-position
		move.w	obY(a0),obY(a1)				; copy parent Y-position
		move.b	#3,obPriority(a1)			; set sprite priority (above parent)
		move.b	#$10,obFrame(a1)			; use large circular sprite
	.makeitem:
		move.l	#Map_Jun,obMap(a1)			; set mappings
		move.w	#ArtTile_SBZ_Junction|Tile_Pal3,obGfx(a1) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#112/2,obActWid(a1)			; set sprite display width
	.next:
		dbf	d1,.loop				; spawn one more object

		move.b	#96/2,obActWid(a0)			; set small sprite display width for parent
		move.b	#4,obPriority(a0)			; set sprite priority for parent (behind circle)
		move.w	#60,jun_unused(a0)			; unused leftover (judging by the value of 60, probably once a 1-second timer)
		move.b	#1,jun_direction(a0)			; set default rotation to clockwise
		move.b	obSubtype(a0),jun_switchid(a0)		; store which switch ID can trigger reversing the direction
; ---------------------------------------------------------------------------

Jun_Action:	; Routine 2
		bsr.w	Jun_Rotate				; rotate and animate junction, reverse if switch is pressed

		tst.b	obRender(a0)				; is junction on screen?
		bpl.w	Jun_Display				; if not, skip collision checks (probably optimization)

		move.w	#74/2+sonic_solid_width,d1		; collision width
		move.w	d1,d2					; collision height (initial)
		move.w	d2,d3					; collision height (stood-on)
		addq.w	#1,d3					; +1px for stood-on
		move.w	obX(a0),d4				; X-position (stood-on)
		bsr.w	SolidObject				; make object solid and check if Sonic is pushing against it
		btst	#5,obStatus(a0)				; is Sonic pushing the disc?
		beq.w	Jun_Display				; if not, branch

		lea	(v_player).w,a1				; load Sonic player object
		moveq	#$E,d1					; junction frame ID to check against from the left
		move.w	obX(a1),d0				; get Sonic's current X-position
		cmp.w	obX(a0),d0				; is Sonic to the left of the disc?
		blo.s	.chkSonicEnter				; if yes, branch
		moveq	#7,d1					; junction frame ID to check against from the right
	.chkSonicEnter:
		cmp.b	obFrame(a0),d1				; is the gap next to Sonic?
		bne.s	Jun_Display				; if not, branch

		move.b	d1,jun_grabframe(a0)			; remember which frame ID caused the grab ($E or 7)
		addq.b	#4,obRoutine(a0)			; advance to Jun_Inside
		move.b	#1,(f_playerctrl).w			; lock Sonic's controls
		move.b	#id_Roll,obAnim(a1)			; make Sonic use "rolling" animation
		move.w	#$800,obInertia(a1)			; force fast ground speed for fast rolling animation
		move.w	#0,obVelX(a1)				; stop Sonic moving horizontally
		move.w	#0,obVelY(a1)				; stop Sonic moving vertically
		bclr	#5,obStatus(a0)				; clear "object pushed against" flag
		bclr	#5,obStatus(a1)				; clear Sonic' pushing flag
		bset	#1,obStatus(a1)				; set Sonic in air

		move.w	obX(a1),d2				; backup Sonic's X/Y-positions before calling Jun_ChgPos
		move.w	obY(a1),d3				; ''
		bsr.w	Jun_ChgPos				; snap Sonic to junction
		add.w	d2,obX(a1)				; add Sonic's X/Y-position before snapping
		add.w	d3,obY(a1)				; ''
		asr.w	obX(a1)					; halve X/Y-positions (smooth in-between frame)
		asr.w	obY(a1)					; ''
; ---------------------------------------------------------------------------

Jun_Display:	; Routine 4
		bra.w	RememberState				; display object, or delete it if out of range
; ===========================================================================

; Jun_Release:
Jun_Inside:	; Routine 6
		move.b	obFrame(a0),d0				; get current junction rotation frame
		cmpi.b	#4,d0					; is gap pointing down?
		beq.s	.checkRelease				; if yes, branch
		cmpi.b	#7,d0					; is gap pointing right?
		bne.s	.updateInside				; if not, branch
	.checkRelease:
		cmp.b	jun_grabframe(a0),d0			; is current junction frame matching grab frame ID?
		beq.s	.updateInside				; if yes, branch (don't exit from original entrance, 7 or $E)

		lea	(v_player).w,a1				; load Sonic player object
		move.w	#0,obVelX(a1)				; cancel Sonic's X-speed
		move.w	#$800,obVelY(a1)			; shoot Sonic down
		cmpi.b	#4,d0					; has Sonic exited to the bottom?
		beq.s	.release				; if yes, branch
		move.w	#$800,obVelX(a1)			; shoot Sonic to the right
		move.w	#$800,obVelY(a1)			; shoot Sonic down

	.release:
		clr.b	(f_playerctrl).w			; unlock Sonic's controls
		subq.b	#4,obRoutine(a0)			; go back to Jun_Action
; ---------------------------------------------------------------------------

.updateInside:
		bsr.s	Jun_Rotate				; keep rotating and animating junction
		bsr.s	Jun_ChgPos				; align Sonic's position while inside junction
		bra.w	RememberState				; display object, or delete it if out of range

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to rotate the junction every 8 frames, depending on direction.
; ---------------------------------------------------------------------------

; Jun_ChkSwitch:
Jun_Rotate:
		lea	(f_switch).w,a2				; load switch state array
		moveq	#0,d0					; clear d0
		move.b	jun_switchid(a0),d0			; get switch ID that can trigger reversal
		btst	#0,(a2,d0.w)				; is Sonic currently standing on switch? (checked every frame)
		beq.s	.unpressed				; if not, branch

		tst.b	jun_switchdown(a0)			; has switch already been pressed the previous frame?
		bne.s	.rotateJunction				; if yes, branch
		neg.b	jun_direction(a0)			; reverse junction circling direction
		move.b	#1,jun_switchdown(a0)			; set to "previously pressed"
		bra.s	.rotateJunction				; don't alter direction until switch is pressed again
; ---------------------------------------------------------------------------

	.unpressed:
		clr.b	jun_switchdown(a0)			; set to "not yet pressed"
; ---------------------------------------------------------------------------

.rotateJunction:
		subq.b	#1,obTimeFrame(a0)			; decrement frame timer until next junction frame
		bpl.s	.return					; if time remains, branch
		move.b	#8-1,obTimeFrame(a0)			; reset timer to 8 frames
		move.b	jun_direction(a0),d1			; get current circling direction (+1 or -1)
		move.b	obFrame(a0),d0				; get current junction frame
		add.b	d1,d0					; add circling direction
		andi.b	#$F,d0					; limit to frame IDs $0-$F
		move.b	d0,obFrame(a0)				; update junction frame

	.return:
		rts						; return
; End of function Jun_Rotate

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to align Sonic to the junction as it moves around
; ---------------------------------------------------------------------------

Jun_ChgPos:
		lea	(v_player).w,a1				; load Sonic player object
		moveq	#0,d0					; clear d0
		move.b	obFrame(a0),d0				; get current junction frame (rotation, 0-$F)
		add.w	d0,d0					; double for word-based indexing
		lea	.xyOffset(pc,d0.w),a2			; go to X/Y position offsets for current junction frame
		move.b	(a2)+,d0				; get X-position offset
		ext.w	d0					; extend to word-size
		add.w	obX(a0),d0				; add junction's base X-position
		move.w	d0,obX(a1)				; update Sonic's X-position
		move.b	(a2)+,d0				; get Y-position offset
		ext.w	d0					; extend to word size
		add.w	obY(a0),d0				; add junction's base Y-position
		move.w	d0,obY(a1)				; update Sonic's Y-position
		rts						; return
; End of functioon Jun_ChgPos

; ---------------------------------------------------------------------------

.xyOffset:	;   x-pos, y-pos	; frame ID
		dc.b -$20,    0		; 0
		dc.b -$1E,   $E		; 1
		dc.b -$18,  $18		; 2
		dc.b  -$E,  $1E		; 3
		dc.b    0,  $20		; 4
		dc.b   $E,  $1E		; 5
		dc.b  $18,  $18		; 6
		dc.b  $1E,   $E		; 7
		dc.b  $20,    0		; 8
		dc.b  $1E,  -$E		; 9
		dc.b  $18, -$18		; A
		dc.b   $E, -$1E		; B
		dc.b    0, -$20		; C
		dc.b  -$E, -$1E		; D
		dc.b -$18, -$18		; E
		dc.b -$1E,  -$E		; F

; ===========================================================================

Map_Jun:	include	"_maps/Rotating Junction.asm"
