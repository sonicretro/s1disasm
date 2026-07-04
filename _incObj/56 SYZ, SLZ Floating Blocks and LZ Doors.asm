; ===========================================================================
; ---------------------------------------------------------------------------
; Object 56 - floating blocks (SYZ/SLZ), large doors (LZ)
; ---------------------------------------------------------------------------

FloatingBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FBlock_Index(pc,d0.w),d1
		jmp	FBlock_Index(pc,d1.w)
; ===========================================================================
FBlock_Index:	dc.w FBlock_Main-FBlock_Index
		dc.w FBlock_Action-FBlock_Index

fb_origY:	equ objoff_30		; original y-axis position
fb_origX:	equ objoff_34		; original x-axis position
fb_moving:	equ objoff_38		; flag set if object is currently moving
fb_distance:	equ objoff_3A		; total distance to move
fb_switch:	equ objoff_3C		; switch ID that triggers action behavior
; ===========================================================================

FBlock_Var:	;     width, height
		dc.b   32/2, 32/2	; $0x/$8x - SYZ 1x1 block 
		dc.b   64/2, 64/2	; $1x/$9x - SYZ 2x2 square up/down blocks in SYZ (the annoying ones)
		dc.b   32/2, 64/2	; $2x/$Ax - SYZ 1x2 door
		dc.b   64/2, 52/2	; $3x/$Bx - SYZ special block moving right in SYZ3 
		dc.b   32/2, 78/2	; $4x/$Cx - (unused)
		dc.b   32/2, 32/2	; $5x/$Dx - SLZ rotating stairway block
		dc.b   16/2, 64/2	; $6x/$Ex - LZ small vertical door that raises on switch
		dc.b  128/2, 32/2	; $7x/$Fx - LZ large sideways 4x1 block that opens on switch
; ===========================================================================

FBlock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to FBlock_Action
		move.l	#Map_FBlock,obMap(a0)			; set mappings

		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile (SYZ/SLZ, part of level graphics)
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.continueSetup				; if not, branch
		move.w	#ArtTile_LZ_Door|Tile_Pal3,obGfx(a0)	; LZ-specific art tile

	.continueSetup:
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		lsr.w	#3,d0					; only read lower digit, multiplied by 2 bytes per entry
		andi.w	#$E,d0					; mask out upper digit
		lea	FBlock_Var(pc,d0.w),a2			; load size data for type
		move.b	(a2)+,obActWid(a0)			; set sprite display width and collision width
		move.b	(a2),obHeight(a0)			; set collision height
		lsr.w	#1,d0					; get proper lower subtype digit
		move.b	d0,obFrame(a0)				; set that as frame ID

		move.w	obX(a0),fb_origX(a0)			; remember initial X-position
		move.w	obY(a0),fb_origY(a0)			; remember initial Y-position

		moveq	#0,d0					; clear d0
		move.b	(a2),d0					; get height again
		add.w	d0,d0					; double to get height as diameter
		move.w	d0,fb_distance(a0)			; set distance object should move when triggered

	if Revision<>0
		; Hardcoded special treatment the horizontally moving block in SYZ3 (subtype $37),
		; added for REV01. In REV00, it was still possible to completely bypass the challenge
		; by moving out of range to despawn the block. That said, the implementation here
		; implies that it was a very last-minute hack, as it checks for specific numbers.
		cmpi.b	#$37,obSubtype(a0)			; is this the special, horizontally moving block in SYZ3?
		bne.s	.showBlock				; if not, branch
		
		; There are two of these special blocks in the SYZ3 objpos layout:
		; - X-pos $1BB8: the "real" block at the left entrance of the tunnel
		; - X-pos $1F38: a "fake" stationary block at the right exit of the tunnel
		; The idea is that only one of the two is ever shown, and depending on the
		; current state of the "f_obj56" flag, the respective other one is deleted.
		cmpi.w	#$1BB8,obX(a0)				; is this the real block?
		bne.s	.fakeBlock				; if not, branch

	.realBlock:
		tst.b	(f_obj56).w				; has real block already travelled to final destination?
		beq.s	.showBlock				; if not, show real block
		jmp	(DeleteObject).l			; keep block at initial position permanently deleted

	.fakeBlock:
		clr.b	obSubtype(a0)				; force FBlock_Stationary (stationary)
		tst.b	(f_obj56).w				; has real block already travelled to final destination?
		bne.s	.showBlock				; if yes, show fake block
		jmp	(DeleteObject).l			; delete block that closes off tunnel before destination is reached

	.showBlock:
	endif

		moveq	#0,d0					; clear d0
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		beq.s	.setupLZDoor				; if yes, branch
		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#$F,d0					; only read lower digit
		subq.w	#8,d0					; subtract by 8
		bcs.s	.setupLZDoor				; if subtype was less than $x8, this is not an SLZ stairway block
		lsl.w	#2,d0					; multiply by 4 bytes per oscillation value entry
		lea	(v_oscillate+$2A+2).w,a2		; target oscillation rates for entries $2A-$36
		lea	(a2,d0.w),a2				; get current oscillation rate for subtype
		tst.w	(a2)					; is current rate negative?
		bpl.s	.setupLZDoor				; if not, branch
		bchg	#0,obStatus(a0)				; invert X-flip flag

	.setupLZDoor:
		move.b	obSubtype(a0),d0			; get subtype again
		bpl.s	FBlock_Action				; is it $80 or above (LZ switch-activated doors)? if not, branch
		andi.b	#$F,d0					; limit to lower subtype digit
		move.b	d0,fb_switch(a0)			; set that as switch ID that will trigger door
		move.b	#5,obSubtype(a0)			; force action type FBlock_LZSmallDoor_Open
		cmpi.b	#7,obFrame(a0)				; is this a large sideways 4x1 door?
		bne.s	.chkState				; if not, branch
		move.b	#$C,obSubtype(a0)			; force action type FBlock_LZHorizDoor_Open
		move.w	#128,fb_distance(a0)			; set distance to move to 128px (platform width)

	.chkState:
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn index
		beq.s	FBlock_Action				; if it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag
		btst	#0,2(a2,d0.w)				; has this door already been opened?
		beq.s	FBlock_Action				; if not, branch
		addq.b	#1,obSubtype(a0)			; set LZ door to next action type to already open it
		clr.w	fb_distance(a0)				; force no more distance to travel
; ---------------------------------------------------------------------------

FBlock_Action:	; Routine 2
		move.w	obX(a0),-(sp)				; backup previous X-position before executing behavior
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#$F,d0					; read only lower digit
		add.w	d0,d0					; double for word-based indexing
		move.w	FBlock_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jsr	FBlock_TypeIndex(pc,d1.w)		; execute block movement behavior, then return here
		move.w	(sp)+,d4				; restore previous X-position as input for SolidObject

		tst.b	obRender(a0)				; is object on screen?
		bpl.s	.chkDel					; if not, skip collision check
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as collision width
		addi.w	#sonic_solid_width,d1			; add Sonic's own collision width
		moveq	#0,d2					; clear d2
		move.b	obHeight(a0),d2				; object height (initial)
		move.w	d2,d3					; object height (stood-on)
		addq.w	#1,d3					; +1px if stood-on
		bsr.w	SolidObject				; make object solid and handle squash kills

.chkDel:
	if Revision=0
		out_of_range.w	DeleteObject,fb_origX(a0)	; has object gone out of range? if yes, delete it
		bra.w	DisplaySprite				; display object
	else
		out_of_range.s	.checkSYZSpecial,fb_origX(a0)	; has object gone out of range? if yes, branch
	    .display:
		bra.w	DisplaySprite				; display object

	    .checkSYZSpecial:
		cmpi.b	#$37,obSubtype(a0)			; is this the special horizontally moving block in SYZ3?
		bne.s	.delete					; if not, branch
		tst.b	fb_moving(a0)				; is block currently moving?
		bne.s	.display				; if yes, don't delete it
	    .delete:
		jmp	(DeleteObject).l			; delete object
	endif

; ===========================================================================
FBlock_TypeIndex:
		dc.w FBlock_Stationary-FBlock_TypeIndex		; 0
		dc.w FBlock_LeftRight_Small-FBlock_TypeIndex	; 1
		dc.w FBlock_LeftRight_Large-FBlock_TypeIndex	; 2
		dc.w FBlock_UpDown_Small-FBlock_TypeIndex	; 3
		dc.w FBlock_UpDown_Large-FBlock_TypeIndex	; 4
		dc.w FBlock_LZSmallDoor_Open-FBlock_TypeIndex	; 5
		dc.w FBlock_LZSmallDoor_Close-FBlock_TypeIndex	; 6
		dc.w FBlock_HorizontalSYZ3-FBlock_TypeIndex	; 7
		dc.w FBlock_SLZStair_Smallest-FBlock_TypeIndex	; 8
		dc.w FBlock_SLZStair_Small-FBlock_TypeIndex	; 9
		dc.w FBlock_SLZStair_Large-FBlock_TypeIndex	; A
		dc.w FBlock_SLZStair_Largest-FBlock_TypeIndex	; B
		dc.w FBlock_LZHorizDoor_Open-FBlock_TypeIndex	; C
		dc.w FBlock_LZHorizDoor_Close-FBlock_TypeIndex	; D
; ===========================================================================

; Type 0 - stationary
FBlock_Stationary:
		rts						; do nothing
; ===========================================================================

; Type 1 - moves side-to-side (small distance)
FBlock_LeftRight_Small:
		move.w	#$20*2,d1				; keep in same range if movement is reversed
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$A).w,d0			; get oscillation value (frequency 2, middle value $20)
		bra.s	FBlock_MoveLR				; move platform left and right
; ===========================================================================

; Type 2 - moves side-to-side (big distance)
FBlock_LeftRight_Large:
		move.w	#$40*2,d1				; keep in same range if movement is reversed
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$1E).w,d0			; get oscillation value (frequency 4, middle value $40)
; ---------------------------------------------------------------------------

FBlock_MoveLR:
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.updateX				; if not, branch
		neg.w	d0					; reverse movement direction
		add.w	d1,d0					; keep in the same general range

	.updateX:
		move.w	fb_origX(a0),d1				; get initial X-position
		sub.w	d0,d1					; adjust by current oscillation value
		move.w	d1,obX(a0)				; move object horizontally
		rts						; return
; ===========================================================================

; Type 3 - moves up/down (small distance)
FBlock_UpDown_Small:
		move.w	#$20*2,d1				; keep in same range if movement is reversed
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$A).w,d0			; get oscillation value (frequency 2, middle value $20)
		bra.s	FBlock_MoveUD
; ===========================================================================

; Type 4 - moves up/down (big distance)
FBlock_UpDown_Large:
		move.w	#$40*2,d1				; keep in same range if movement is reversed
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$1E).w,d0			; get oscillation value (frequency 4, middle value $40)
; ---------------------------------------------------------------------------

FBlock_MoveUD:
		btst	#0,obStatus(a0)				; is object X-flipped?
		beq.s	.updateY				; if not, branch
		neg.w	d0					; reverse movement direction
		add.w	d1,d0					; keep in the same general range

	.updateY:
		move.w	fb_origY(a0),d1				; get initial Y-position
		sub.w	d0,d1					; adjust by current oscillation value
		move.w	d1,obY(a0)				; move object vertically
		rts						; return
; ===========================================================================

; Type 5 - opens up when respective switch is pressed
FBlock_LZSmallDoor_Open:
		tst.b	fb_moving(a0)				; is door already set to open?
		bne.s	.opening				; if yes, branch

		cmpi.w	#id_LZ_act1,(v_zone_act).w		; is level LZ1?
		bne.s	.checkSwitch				; if not, branch
		cmpi.b	#3,fb_switch(a0)			; is this the door before the first wind tunnel?
		bne.s	.checkSwitch				; if not, branch
		clr.b	(f_wtunneldisallow).w			; enable wind tunnel by default
		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		cmp.w	obX(a0),d0				; is Sonic right of the door?
		bhs.s	.checkSwitch				; if not, branch
		move.b	#1,(f_wtunneldisallow).w		; disable wind tunnel while left of door

	.checkSwitch:
		lea	(f_switch).w,a2				; load switch status array
		moveq	#0,d0					; clear d0
		move.b	fb_switch(a0),d0			; get switch ID that will trigger this door
		btst	#0,(a2,d0.w)				; is respective switch currently pressed?
		beq.s	.updatePosition				; if not, branch

		cmpi.w	#id_LZ_act1,(v_zone_act).w		; is level LZ1?
		bne.s	.startOpen				; if not, branch
		cmpi.b	#3,d0					; is this the door before the first wind tunnel? (again)
		bne.s	.startOpen				; if not, branch
		clr.b	(f_wtunneldisallow).w			; allow wind tunnel to suck Sonic into it

	.startOpen:
		move.b	#1,fb_moving(a0)			; open door

	.opening:
		tst.w	fb_distance(a0)				; has door fully moved up?
		beq.s	.fullyOpened				; if yes, stop moving it further
		subq.w	#2,fb_distance(a0)			; move door up at 2px/frame

	.updatePosition:
		move.w	fb_distance(a0),d0			; get remaining distance to travel
		btst	#0,obStatus(a0)				; is door X-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; move door down instead
	.setY:	move.w	fb_origY(a0),d1				; get initial Y-position
		add.w	d0,d1					; add current travel distance
		move.w	d1,obY(a0)				; update door Y-position
		rts						; return
; ---------------------------------------------------------------------------

; .loc_104C8:
.fullyOpened:
		addq.b	#1,obSubtype(a0)			; advance to FBlock_LZSmallDoor_Close type
		clr.b	fb_moving(a0)				; stop door moving any further

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn index
		beq.s	.updatePosition				; if it doesn't have one, branch
		bset	#0,2(a2,d0.w)				; globally remember that this door has been opened
		bra.s	.updatePosition				; update Y-position once more
; ===========================================================================

; Type 6 (set from Type 5) - closes when respective switch is pressed (kinda unused... see notes)
FBlock_LZSmallDoor_Close:
		tst.b	fb_moving(a0)				; is door already set to close?
		bne.s	.closing				; if yes, branch

		; This check will close the previously opened door again when a respective switch with
		; the "alternate flag for bit 7" is pressed. However, switches with that flag don't exist
		; anywhere in the game, essentially turning this into a stationary type for opened doors.
		; However, there is one hardcoded exception in DynWater_LZ1_Routine0, where one specific
		; door in LZ1 (for switch ID 05, at coordinates X=1118/Y=5A0) will get closed up through
		; this code here again if Sonic moved right of it, likely to block off some air bubbles.
		lea	(f_switch).w,a2				; load switch status array
		moveq	#0,d0					; clear d0
		move.b	fb_switch(a0),d0			; get switch ID that will trigger this door
		tst.b	(a2,d0.w)				; has switch been pressed AND bit 7 been set? ("alternate flag")
		bpl.s	.updatePosition				; if not, branch
		move.b	#1,fb_moving(a0)			; close door again

	.closing:
		moveq	#0,d0					; clear d0
		move.b	obHeight(a0),d0				; get half-height of door
		add.w	d0,d0					; double to get full height
		cmp.w	fb_distance(a0),d0			; has door fully closed again?
		beq.s	.fullyClosed				; if yes, stop moving it further
		addq.w	#2,fb_distance(a0)			; move door down at 2px/frame

	.updatePosition:
		move.w	fb_distance(a0),d0			; get remaining distance to travel
		btst	#0,obStatus(a0)				; is door X-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; move door down instead
	.setY:	move.w	fb_origY(a0),d1				; get initial Y-position
		add.w	d0,d1					; add current travel distance
		move.w	d1,obY(a0)				; update door Y-position
		rts						; return
; ---------------------------------------------------------------------------

; .loc_1052C:
.fullyClosed:
		subq.b	#1,obSubtype(a0)			; go back to FBlock_LZSmallDoor_Open
		clr.b	fb_moving(a0)				; stop door moving any further

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn index
		beq.s	.updatePosition				; if it doesn't have one, branch
		bclr	#0,2(a2,d0.w)				; clear global flag that this door has been opened
		bra.s	.updatePosition				; update Y-position once more
; ===========================================================================

; Type 7 - special horizontally moving block in SYZ3
FBlock_HorizontalSYZ3:
		tst.b	fb_moving(a0)				; is block already moving?
		bne.s	.moveRight				; if yes, branch

		tst.b	(f_switch+$F).w				; has switch number $F been pressed?
		beq.s	.return					; if not, branch
		move.b	#1,fb_moving(a0)			; start moving block
		clr.w	fb_distance(a0)				; reset tracker for pixels block has moved

	.moveRight:
		addq.w	#1,obX(a0)				; move block to the right at 1px/frame
		move.w	obX(a0),fb_origX(a0)			; overwrite initial X-position
		addq.w	#1,fb_distance(a0)			; track one extra pixel travelled
		cmpi.w	#$380,fb_distance(a0)			; has block reached final destination? ($1BB8 + $380 = $1F38)
		bne.s	.return					; if not, branch

	if Revision<>0
		move.b	#1,(f_obj56).w				; don't allow closed-off tunnel from reopening
		clr.b	fb_moving(a0)				; stop block moving
	endif
		clr.b	obSubtype(a0)				; change to FBlock_Stationary (stationary)

	.return:
		rts						; return
; ===========================================================================

; Type C - big 4x1 sideways-moving door, opens when switch is pressed
FBlock_LZHorizDoor_Open:
		tst.b	fb_moving(a0)				; is door already set to open?
		bne.s	.opening				; if yes, branch

		lea	(f_switch).w,a2				; load switch status array
		moveq	#0,d0					; clear d0
		move.b	fb_switch(a0),d0			; get switch ID that will trigger this door
		btst	#0,(a2,d0.w)				; is respective switch currently pressed?
		beq.s	.updatePosition				; if not, branch
		move.b	#1,fb_moving(a0)			; open door

	.opening:
		tst.w	fb_distance(a0)				; has door fully moved left?
		beq.s	.fullyOpened				; if yes, stop moving it further
		subq.w	#2,fb_distance(a0)			; move door left at 2px/frame

	.updatePosition:
		move.w	fb_distance(a0),d0			; get remaining distance to travel
		btst	#0,obStatus(a0)				; is door X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; move door right instead
		addi.w	#128,d0					; keep in same general range
	.setX:	move.w	fb_origX(a0),d1				; get initial X-position
		add.w	d0,d1					; add current travel distance
		move.w	d1,obX(a0)				; update door X-position
		rts						; return
; ---------------------------------------------------------------------------

; .loc_105C0:
.fullyOpened:
		addq.b	#1,obSubtype(a0)			; advance to FBlock_LZHorizDoor_Close type
		clr.b	fb_moving(a0)				; stop door moving any further

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn index
		beq.s	.updatePosition				; if it doesn't have one, branch
		bset	#0,2(a2,d0.w)				; globally remember that this door has been opened
		bra.s	.updatePosition				; update X-position once more
; ===========================================================================

; Type D - 
FBlock_LZHorizDoor_Close:
		tst.b	fb_moving(a0)				; is door already set to close?
		bne.s	.closing				; if yes, branch

		; Same story as described in FBlock_LZSmallDoor_Close, only this time
		; this check truly goes 100% unused, with no hardcoded exceptions either.
		lea	(f_switch).w,a2				; load switch status array
		moveq	#0,d0					; clear d0
		move.b	fb_switch(a0),d0			; get switch ID that will trigger this door
		tst.b	(a2,d0.w)				; has switch been pressed AND bit 7 been set? ("alternate flag")
		bpl.s	.updatePosition				; if not, branch
		move.b	#1,fb_moving(a0)			; close door again

	.closing:
		move.w	#128,d0					; set maximum travel distance (door width)
		cmp.w	fb_distance(a0),d0			; has door fully closed again?
		beq.s	.fullyClosed				; if yes, stop moving it further
		addq.w	#2,fb_distance(a0)			; move door right at 2px/frame

	; .wtf:
	.updatePosition:
		move.w	fb_distance(a0),d0			; get remaining distance to travel
		btst	#0,obStatus(a0)				; is door X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; move door left instead
		addi.w	#128,d0					; keep in same general range
	.setX:	move.w	fb_origX(a0),d1				; get initial X-position
		add.w	d0,d1					; add current travel distance
		move.w	d1,obX(a0)				; update door X-position
		rts						; return
; ---------------------------------------------------------------------------

; .loc_10624:
.fullyClosed:
		subq.b	#1,obSubtype(a0)			; go back to FBlock_LZHorizDoor_Open
		clr.b	fb_moving(a0)				; stop door moving any further

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn index
		beq.s	.updatePosition				; if it doesn't have one, branch
		bclr	#0,2(a2,d0.w)				; clear global flag that this door has been opened
		bra.s	.updatePosition				; update X-position once more
; ===========================================================================

; Type 8 - square-moving block in SLZ, smallest range
FBlock_SLZStair_Smallest:
		move.w	#$10,d1					; set fixed half-range
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$2A).w,d0			; get oscillation value (frequency 2, middle value $20)
		lsr.w	#1,d0					; divide by 2 (middle value is now $10)
		move.w	(v_oscillate+$2C).w,d3			; get current oscillation rate for corner check
		bra.s	FBlock_SLZStair_MoveSquare		; update block position
; ===========================================================================

; Type 9 - square-moving block in SLZ, small range
FBlock_SLZStair_Small:
		move.w	#$30,d1					; set fixed half-range
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$2E).w,d0			; get oscillation value (frequency 3, middle value $30)
		move.w	(v_oscillate+$30).w,d3			; get current oscillation rate for corner check
		bra.s	FBlock_SLZStair_MoveSquare		; update block position
; ===========================================================================

; Type A - square-moving block in SLZ, large range
FBlock_SLZStair_Large:
		move.w	#$50,d1					; set fixed half-range
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$32).w,d0			; get oscillation value (frequency 5, middle value $50)
		move.w	(v_oscillate+$34).w,d3			; get current oscillation rate for corner check
		bra.s	FBlock_SLZStair_MoveSquare		; update block position
; ===========================================================================

; Type B - square-moving block in SLZ, largest range
FBlock_SLZStair_Largest:
		move.w	#$70,d1					; set fixed half-range
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$36).w,d0			; get oscillation value (frequency 7, middle value $70)
		move.w	(v_oscillate+$38).w,d3			; get current oscillation rate for corner check
		; continue to FBlock_SLZStair_MoveSquare...
; ---------------------------------------------------------------------------

FBlock_SLZStair_MoveSquare:
		tst.w	d3					; is current oscillation rate 0? (at a corner)
		bne.s	.checkFlipped				; if not, branch
		addq.b	#1,obStatus(a0)				; cycle through X-flipped, Y-flipped, XY-flipped, and not flipped
		andi.b	#3,obStatus(a0)				; limit to those four possible states

	.checkFlipped:
		move.b	obStatus(a0),d2				; get current status flags
		andi.b	#3,d2					; limit to X/Y-flip flags only
		bne.s	.xFlipped				; is block X-flipped and/or Y-flipped? if yes, branch

		; Move right along the top edge
		sub.w	d1,d0					; move block horizontally within desired range
		add.w	fb_origX(a0),d0				; add initial X-position
		move.w	d0,obX(a0)				; update X-position
		neg.w	d1					; keep block fixed at the top edge
		add.w	fb_origY(a0),d1				; add initial Y-position
		move.w	d1,obY(a0)				; update Y-position
		rts						; return
; ---------------------------------------------------------------------------

	.xFlipped:
		subq.b	#1,d2					; is block just X-flipped?
		bne.s	.yFlipped				; if not, branch

		; Move down along the right edge
		subq.w	#1,d1					; skip the shared corner pixel
		sub.w	d1,d0					; move block vertically within desired range
		neg.w	d0					; negate to move down
		add.w	fb_origY(a0),d0				; add initial Y-position
		move.w	d0,obY(a0)				; update Y-position
		addq.w	#1,d1					; keep block fixed at right edge
		add.w	fb_origX(a0),d1				; add initial X-position
		move.w	d1,obX(a0)				; update X-position
		rts						; return
; ---------------------------------------------------------------------------

	.yFlipped:
		subq.b	#1,d2					; is block just Y-flipped?
		bne.s	.xyFlipped				; if not, branch

		; Move left along the bottom edge
		subq.w	#1,d1					; skip the shared corner pixel
		sub.w	d1,d0					; move block horizontally within desired range
		neg.w	d0					; negate to move left
		add.w	fb_origX(a0),d0				; add initial X-position
		move.w	d0,obX(a0)				; update X-position
		addq.w	#1,d1					; keep block fixed at bottom edge
		add.w	fb_origY(a0),d1				; add initial Y-position
		move.w	d1,obY(a0)				; update Y-position
		rts						; return
; ---------------------------------------------------------------------------

	.xyFlipped:
		; Move up along the left edge
		sub.w	d1,d0					; move block vertically within desired range
		add.w	fb_origY(a0),d0				; add initial Y-position
		move.w	d0,obY(a0)				; update Y-position
		neg.w	d1					; keep block fixed at the left edge
		add.w	fb_origX(a0),d1				; add initial X-position
		move.w	d1,obX(a0)				; update X-position
		rts						; return

; ===========================================================================

Map_FBlock:	include	"_maps/Floating Blocks and Doors.asm"
