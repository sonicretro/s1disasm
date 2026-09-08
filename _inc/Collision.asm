; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to change Sonic's angle & position as he walks along the floor
; ---------------------------------------------------------------------------

Sonic_AnglePos:
		btst	#3,obStatus(a0)
		beq.s	.not_on_platform			; branch if Sonic isn't on a platform
		moveq	#0,d0
		move.b	d0,(v_anglebuffer).w			; clear angle hotspots
		move.b	d0,(v_anglebuffer2).w
		rts
; ===========================================================================

; loc_14602:
.not_on_platform:
		moveq	#3,d0
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		move.b	obAngle(a0),d0				; get last angle
		addi.b	#$20,d0
		bpl.s	.floor_or_left				; branch if angle is (generally) flat or left vertical
		move.b	obAngle(a0),d0
		bpl.s	.angle_pos				; branch if angle is between $60 and $7F
		subq.b	#1,d0					; subtract 1 if $80-$DF

	; loc_1461E:
	.angle_pos:
		addi.b	#$20,d0					; d0 = angle + ($1F or $20)
		bra.s	.chk_surface
; ===========================================================================

; loc_14624:
.floor_or_left:
		move.b	obAngle(a0),d0
		bpl.s	.angle_pos_				; branch if angle is between 0 and $60
		addq.b	#1,d0					; add 1 if $E0-$FF

	; loc_1462C:
	.angle_pos_:
		addi.b	#$1F,d0					; d0 = angle + ($1F or $20)

; loc_14630:
.chk_surface:
		andi.b	#$C0,d0					; read only bits 6-7 of angle
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL				; branch if on left vertical
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling			; branch if on ceiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR				; branch if on right vertical

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of bottom edge of Sonic
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of right edge of Sonic
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save d1 (distance to floor) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of bottom edge of Sonic
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3					; d3 = x pos of left edge of Sonic
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindFloor				; d1 = distance to floor left side
		move.w	(sp)+,d0				; d0 = distance to floor right side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	.on_floor				; branch if Sonic is 0px from floor
		bpl.s	.above_floor				; branch if Sonic is above floor
		cmpi.w	#-$E,d1
		blt.s	Sonic_BelowFloor			; branch if Sonic is > 14px below floor
		add.w	d1,obY(a0)				; align to floor

	; locret_146BE:
	.on_floor:
		rts
; ===========================================================================

; loc_146C0:
.above_floor:
		cmpi.w	#$E,d1
		bgt.s	.in_air					; branch if Sonic is > 14px above floor

; loc_146C6:
.on_disc:
		add.w	d1,obY(a0)				; align to floor
		rts
; ===========================================================================

; loc_146CC:
.in_air:
		tst.b	sticktoconvex(a0)
		bne.s	.on_disc				; branch if Sonic is on a SBZ disc
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)			; restart Sonic's animation
		rts
; ===========================================================================

; locret_146E6:
Sonic_BelowFloor:
		rts

; ===========================================================================
	if UnusedOptimization=0
		; dead code
		move.l	obX(a0),d2
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,obX(a0)
		move.w	#gravity,d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obY(a0)
		rts
	endif
; ===========================================================================

; locret_1470A:
Sonic_InsideWall:
		rts

; ===========================================================================
	if UnusedOptimization=0
		; dead code
		move.l	obY(a0),d3
		move.w	obVelY(a0),d0
		subi.w	#gravity,d0
		move.w	d0,obVelY(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obY(a0)
		rts
		rts

; ===========================================================================
		; dead code
		move.l	obX(a0),d2
		move.l	obY(a0),d3
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,obX(a0)
		move.l	d3,obY(a0)
		rts
	endif
; End of function Sonic_AnglePos

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	update Sonic's angle
; 
; input:
;	d0 = distance to floor right side
;	d1 = distance to floor left side
; 
; output:
;	d1 = shortest distance to floor (either side)
;	d2 = angle
; ---------------------------------------------------------------------------

Sonic_Angle:
		move.b	(v_anglebuffer2).w,d2			; use left side angle
		cmp.w	d0,d1
		ble.s	.left_nearer				; branch if floor is nearer on left side
		move.b	(v_anglebuffer).w,d2			; use right side angle
		move.w	d0,d1					; use distance of right side

	; loc_1475E:
	.left_nearer:
		btst	#0,d2
		bne.s	.snap_angle				; branch if bit 0 of angle is set
		move.b	d2,obAngle(a0)				; update angle
		rts
; ===========================================================================

; loc_1476A:
.snap_angle:
		move.b	obAngle(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2					; snap to nearest 90 degree angle
		move.b	d2,obAngle(a0)				; update angle
		rts
; End of function Sonic_Angle

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to his right
; ---------------------------------------------------------------------------

Sonic_WalkVertR:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2					; d2 = y pos of upper edge of Sonic (i.e. his front or back)
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#$10,a3					; tile width
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindWall
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of lower edge of Sonic (i.e. his front or back)
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#$10,a3					; tile width
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindWall				; d1 = distance to wall lower side
		move.w	(sp)+,d0				; d0 = distance to wall upper side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	.on_wall				; branch if Sonic is 0px from wall
		bpl.s	.outside_wall				; branch if Sonic is outside wall
		cmpi.w	#-$E,d1
		blt.w	Sonic_InsideWall			; branch if Sonic is > 14px inside wall
		add.w	d1,obX(a0)				; align to wall

	; locret_147F0:
	.on_wall:
		rts
; ===========================================================================

; loc_147F2:
.outside_wall:
		cmpi.w	#$E,d1
		bgt.s	.in_air					; branch if Sonic is > 14px outside wall

; loc_147F8:
.on_disc:
		add.w	d1,obX(a0)				; align to wall
		rts
; ===========================================================================

; loc_147FE:
.in_air:
		tst.b	sticktoconvex(a0)
		bne.s	.on_disc				; branch if Sonic is on a SBZ disc
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)			; restart Sonic's animation
		rts
; End of function Sonic_WalkVertR

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk upside-down
; ---------------------------------------------------------------------------

Sonic_WalkCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of top edge of Sonic (i.e. his feet)
		eori.w	#$F,d2					; add some amount
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of right edge of Sonic
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$1000,d6				; yflip tile
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save d1 (distance to ceiling) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of top edge of Sonic (i.e. his feet)
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos of left edge of Sonic
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$1000,d6				; yflip tile
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindFloor				; d1 = distance to ceiling left side
		move.w	(sp)+,d0				; d0 = distance to ceiling right side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	.on_ceiling				; branch if Sonic is 0px from ceiling
		bpl.s	.below_ceiling				; branch if Sonic is below ceiling
		cmpi.w	#-$E,d1
		blt.w	Sonic_BelowFloor			; branch if Sonic is > 14px inside ceiling
		sub.w	d1,obY(a0)				; align to ceiling

	; locret_14892:
	.on_ceiling:
		rts
; ===========================================================================

; loc_14894:
.below_ceiling:
		cmpi.w	#$E,d1
		bgt.s	.in_air					; branch if Sonic is > 14px below ceiling

; loc_1489A:
.on_disc:
		sub.w	d1,obY(a0)				; align to ceiling
		rts
; ===========================================================================

; loc_148A0:
.in_air:
		tst.b	sticktoconvex(a0)
		bne.s	.on_disc				; branch if Sonic is on a SBZ disc
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)			; restart Sonic's animation
		rts
; End of function Sonic_WalkCeiling

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to his left
; ---------------------------------------------------------------------------

Sonic_WalkVertL:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of upper edge of Sonic (i.e. his front or back)
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		eori.w	#$F,d3					; add some amount
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; tile width
		move.w	#$800,d6				; xflip tile
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindWall
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of lower edge of Sonic (i.e. his front or back)
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#-$10,a3				; tile width
		move.w	#$800,d6				; xflip tile
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindWall				; d1 = distance to wall lower side
		move.w	(sp)+,d0				; d0 = distance to wall upper side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	.on_wall				; branch if Sonic is 0px from wall
		bpl.s	.outside_wall				; branch if Sonic is outside wall
		cmpi.w	#-$E,d1
		blt.w	Sonic_InsideWall			; branch if Sonic is > 14px inside wall
		sub.w	d1,obX(a0)				; align to wall

	; locret_14934:
	.on_wall:
		rts
; ===========================================================================

; loc_14936:
.outside_wall:
		cmpi.w	#$E,d1
		bgt.s	.in_air					; branch if Sonic is > 14px outside wall

; loc_1493C:
.on_disc:
		sub.w	d1,obX(a0)				; align to wall
		rts
; ===========================================================================

; loc_14942:
.in_air:
		tst.b	sticktoconvex(a0)
		bne.s	.on_disc				; branch if Sonic is on a SBZ disc
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0)			; restart Sonic's animation
		rts
; End of function Sonic_WalkVertL

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find which 16x16 block tile the object is standing on
; 
; input:
;	d2.w = y-position of object's bottom edge
;	d3.w = x-position of object
; 
; output:
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
; ---------------------------------------------------------------------------

FindNearestTile:
		move.w	d2,d0					; get Y-position of bottom edge of object
		lsr.w	#1,d0					; divide Y-position by 2 (because layout alternates between level and bg lines)
		andi.w	#$380,d0				; read only high byte of Y-position (because each level chunk is 256px tall)
		move.w	d3,d1					; get X-position of object
		lsr.w	#8,d1
		andi.w	#$7F,d1					; read only high byte of X-position
		add.w	d1,d0					; combine for position within layout
		moveq	#$FFFFFFFF,d1				; d1 = $FFFFFFFF (used to make a RAM address)
		lea	(v_lvllayout_fg).w,a1
		move.b	(a1,d0.w),d1				; get 256x256 chunk number
		beq.s	.blanktile				; branch if 0 (blank chunk)
		bmi.s	.specialtile				; branch if > $7F

		subq.b	#1,d1					; make chunks start at 0
		ext.w	d1					; d1 = $FFFF00xx
		ror.w	#7,d1					; d1 = $FFFFxx00 where xx is multiplied by 2
		move.w	d2,d0
		add.w	d0,d0					; d0 = Y-position * 2 (because each 16x16 block is represented by 2 bytes)
		andi.w	#$1E0,d0				; read only high nybble of low byte (for Y-position within 256x256 chunk)
		add.w	d0,d1					; add to base address
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0					; d0 = high nybble of low byte of X-position, multiplied by 2
		add.w	d0,d1					; add to base address

	if FixBugs
		movea.l	d1,a1
		rts

		; The regular branch to .blanktile will result in d1 being set to $FFFFFF00,
		; which will be returned in a1 and subsequently be used as the RAM location
		; for blank chunk collision. By luck, that address (v_chunk0collision) is
		; never changed from 0, so it doesn't cause any trouble in the final game,
		; but it is still incredibly dangerous and requires RAM to be laid out in a
		; specific way so it doesn't break, which is why it has an assembly check.
		; With this fix, blank chunks instead use a fixed ROM location that always
		; contains a 0 word. This will also remove the need for that assembly check.

	    .blanktile:
		lea	.chunk0(pc),a1
		rts

	    .chunk0:
		dc.w 0
	else
	    .blanktile:
		movea.l	d1,a1
		rts
	endif

; ===========================================================================

.specialtile:
		andi.w	#$7F,d1
		btst	#sprite_looping_bit,obRender(a0)	; is object "behind a loop"?
		beq.s	.treatasnormal				; if not, branch
		addq.w	#1,d1
		cmpi.w	#$29,d1					; is 256x256 chunk number $28?
		bne.s	.treatasnormal				; if not, branch
		move.w	#$51,d1					; replace with $51

	.treatasnormal:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts
; End of function FindNearestTile


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find the floor
; 
; input:
;	d2.w = y-position of object's bottom edge
;	d3.w = x-position of object
;	d5.l = bit to test for solidness: $D = top solid; $E = left/right/bottom solid
;	d6.w = eor bitmask for 16x16 block
;	a3.w = height of 16x16 blocks: $10 or -$10 if object is inverted
;	a4 = RAM address to write angle byte
; 
; output:
;	d1.w = distance to the floor
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 block number, x/yflip, solidness
;	(a4).b = floor angle
; ---------------------------------------------------------------------------

FindFloor:
		bsr.s	FindNearestTile				; a1 = address within 256x256 mappings of 16x16 block being stood on
		move.w	(a1),d0					; get value for solidness, orientation and 16x16 block number
		move.w	d0,d4
		andi.w	#$7FF,d0				; ignore solid/orientation bits
		beq.s	.isblank				; branch if block is blank
		btst	d5,d4					; is the block solid?
		bne.s	.issolid				; if yes, branch

.isblank:
		add.w	a3,d2
		bsr.w	FindFloor2				; try block below the nearest
		sub.w	a3,d2
		addi.w	#$10,d1					; return distance to floor
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0				; get collision heightmap id
		andi.w	#$FF,d0					; heightmap id is 1 byte
		beq.s	.isblank				; branch if 0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)				; get collision angle value
		lsl.w	#4,d0					; d0 = heightmap id * $10 (the width of a heightmap for 1 block)
		move.w	d3,d1					; get X-position of object
		btst	#$B,d4					; is block flipped horizontally?
		beq.s	.no_xflip				; if not, branch
		not.w	d1
		neg.b	(a4)					; xflip angle

	.no_xflip:
		btst	#$C,d4					; is block flipped vertically?
		beq.s	.no_yflip				; if not, branch
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)				; yflip angle

	.no_yflip:
		andi.w	#$F,d1					; read only low nybble of X-position (i.e. X-position within 16x16 block)
		add.w	d0,d1					; (id * $10) + X-position. = place in heightmap data
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0				; get actual height value from heightmap
		ext.w	d0
		eor.w	d6,d4					; apply x/yflip (allows for double-flip cancellation)
		btst	#$C,d4					; is block flipped vertically?
		beq.s	.no_yflip2				; if not, branch
		neg.w	d0

	.no_yflip2:
		tst.w	d0
		beq.s	.isblank				; branch if height is 0
		bmi.s	.negfloor				; branch if height is negative
		cmpi.b	#$10,d0
		beq.s	.maxfloor				; branch if height is $10 (max)
		move.w	d2,d1					; get Y-position of object
		andi.w	#$F,d1					; read only low nybble for Y-position within 16x16 block
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1					; return distance to floor
		rts
; ===========================================================================

.negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank

.maxfloor:
		sub.w	a3,d2
		bsr.w	FindFloor2				; try block above the nearest
		add.w	a3,d2
		subi.w	#$10,d1					; return distance to floor
		rts
; End of function FindFloor

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find the floor above/below the current 16x16 block
; ---------------------------------------------------------------------------

FindFloor2:
	if FixBugs
		move.w	d4,-(sp)
	endif
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	.isblank2
		btst	d5,d4
		bne.s	.issolid

.isblank2:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
	if FixBugs
		move.w	(sp)+,d4
	endif
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	.isblank2
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	.no_xflip
		not.w	d1
		neg.b	(a4)

	.no_xflip:
		btst	#$C,d4
		beq.s	.no_yflip
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

	.no_yflip:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	.no_yflip2
		neg.w	d0

	.no_yflip2:
		tst.w	d0
		beq.s	.isblank2
		bmi.s	.negfloor
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; ===========================================================================

.negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank2
		not.w	d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; End of function FindFloor2


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a wall
; 
; input:
;	d2.w = Y-position of object's bottom edge
;	d3.w = X-position of object
;	d5.l = bit to test for solidness: $D = top solid; $E = left/right/bottom solid
;	d6.w = eor bitmask for 16x16 block
;	a3.w = height of 16x16 blocks: $10 or -$10 if object is inverted
;	a4 = RAM address to write angle byte
; 
; output:
;	d1.w = distance to the wall
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 block number, x/yflip, solidness
;	(a4).b = floor angle
; ---------------------------------------------------------------------------

FindWall:
		bsr.w	FindNearestTile				; a1 = address within 256x256 mappings of 16x16 block being stood on
		move.w	(a1),d0					; get value for solidness, orientation and 16x16 block number
		move.w	d0,d4
		andi.w	#$7FF,d0				; ignore solid/orientation bits
		beq.s	.isblank				; branch if block is blank
		btst	d5,d4					; is the block solid?
		bne.s	.issolid				; if yes, branch

.isblank:
		add.w	a3,d3
		bsr.w	FindWall2				; try block to the right
		sub.w	a3,d3
		addi.w	#$10,d1					; return distance to wall
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0				; get collision heightmap id
		andi.w	#$FF,d0					; heightmap id is 1 byte
		beq.s	.isblank				; branch if 0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)				; get collision angle value
		lsl.w	#4,d0					; d0 = heightmap id * $10 (the width of a heightmap for 1 block)
		move.w	d2,d1					; get Y-position of object
		btst	#$C,d4					; is block flipped vertically?
		beq.s	.no_yflip				; if not, branch
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)				; yflip angle

	.no_yflip:
		btst	#$B,d4					; is block flipped horizontally?
		beq.s	.no_xflip				; if not, branch
		neg.b	(a4)					; xflip angle

	.no_xflip:
		andi.w	#$F,d1					; read only low nybble of X-position (i.e. X-position within 16x16 block)
		add.w	d0,d1					; (id * $10) + X-position. = place in heightmap data
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0				; get actual height value from heightmap
		ext.w	d0
		eor.w	d6,d4					; apply x/yflip (allows for double-flip cancellation)
		btst	#$B,d4					; is block flipped horizontally?
		beq.s	.no_xflip2				; if not, branch
		neg.w	d0

	.no_xflip2:
		tst.w	d0
		beq.s	.isblank				; branch if height is 0
		bmi.s	.negfloor				; branch if height is negative
		cmpi.b	#$10,d0
		beq.s	.maxfloor				; branch if height is $10 (max)
		move.w	d3,d1					; get X-position of object
		andi.w	#$F,d1					; read only low nybble for X-position within 16x16 block
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1					; return distance to wall
		rts
; ===========================================================================

.negfloor:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank

.maxfloor:
		sub.w	a3,d3
		bsr.w	FindWall2				; try block to the left
		add.w	a3,d3
		subi.w	#$10,d1					; return distance to wall
		rts
; End of function FindWall

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a wall left/right of the current 16x16 block
; ---------------------------------------------------------------------------

FindWall2:
	if FixBugs
		move.w	d4,-(sp)
	endif
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	.isblank
		btst	d5,d4
		bne.s	.issolid

.isblank:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
	if FixBugs
		move.w	(sp)+,d4
	endif
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	.isblank
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	.no_yflip
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

	.no_yflip:
		btst	#$B,d4
		beq.s	.no_xflip
		neg.b	(a4)

	.no_xflip:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	.no_xflip2
		neg.w	d0

	.no_xflip2:
		tst.w	d0
		beq.s	.isblank
		bmi.s	.negfloor
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; ===========================================================================

.negfloor:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank
		not.w	d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; End of function FindWall2

; ===========================================================================
	if UnusedOptimization=0
; ---------------------------------------------------------------------------
; Unused/dead subroutine that was likely used during development.
; 
; This subroutine takes 'raw' bitmap-like collision block data as input and
; converts it into the proper collision arrays (ColArray and ColArray2).
; Pointers to said raw data are dummied out.
; Curiously, an example of the original 'raw' data that this was intended
; to process can be found in the J2ME version, in a file called 'blkcol.bct'.
; ---------------------------------------------------------------------------
RawColBlocks:		equ CollArray1
ConvRowColBlocks:	equ CollArray1
; ---------------------------------------------------------------------------

ConvertCollisionArray:
		rts						; immediately return
; ---------------------------------------------------------------------------

		; The raw format stores the collision data column by column for the normal collision array.
		; This makes a copy of the data, but stored row by row, for the rotated collision array.
		lea	(RawColBlocks).l,a1			; source location of raw collision block data
		lea	(ConvRowColBlocks).l,a2			; destination location for row-converted collision block data
		move.w	#$100-1,d3				; number of blocks in collision data
.blockLoop:
		moveq	#16,d5					; start on the 16th bit (the leftmost pixel)
		move.w	#16-1,d2				; width of a block in pixels
.columnLoop:
		moveq	#0,d4
		move.w	#16-1,d1				; height of a block in pixels
.rowLoop:
		move.w	(a1)+,d0				; get row of collision bits
		lsr.l	d5,d0					; push the selected bit of this row into the 'eXtend' flag
		addx.w	d4,d4					; shift d4 to the left, and insert the selected bit into bit 0
		dbf	d1,.rowLoop				; loop for each row of pixels in a block
		move.w	d4,(a2)+				; store column of collision bits
		suba.w	#2*16,a1				; back to the start of the block
		subq.w	#1,d5					; get next bit in the row
		dbf	d2,.columnLoop				; loop for each column of pixels in a block
		adda.w	#2*16,a1				; next block
		dbf	d3,.blockLoop				; loop for each block in the raw collision block data

		; This then converts the collision data into the final collision arrays
		lea	(ConvRowColBlocks).l,a1
		lea	(CollArray2).l,a2			; convert the row-converted collision block data into final rotated collision array
		bsr.s	.convertArray
		lea	(RawColBlocks).l,a1
		lea	(CollArray1).l,a2			; convert the raw collision block data into final normal collision array
.convertArray:
		move.w	#$1000-1,d3				; size of the collision array
.processLoop:
		moveq	#0,d2
		move.w	#$F,d1
		move.w	(a1)+,d0				; get current column of collision pixels
		beq.s	.noCollision				; branch if there's no collision in this column
		bmi.s	.topPixelSolid				; branch if top pixel of collision is solid

		; Here we count, starting from the bottom, how many pixels tall
		; the collision in this column is.
.processColumnLoop1:
		lsr.w	#1,d0
		bhs.s	.pixelNotSolid1
		addq.b	#1,d2
.pixelNotSolid1:
		dbf	d1,.processColumnLoop1
		bra.s	.columnProcessed
; ---------------------------------------------------------------------------

.topPixelSolid:
		cmpi.w	#$FFFF,d0				; is entire column solid?
		beq.s	.entireColumnSolid			; branch if so

		; Here we count, starting from the top, how many pixels tall
		; the collision in this column is (the resulting number is negative).
.processColumnLoop2:
		lsl.w	#1,d0
		bhs.s	.pixelNotSolid2
		subq.b	#1,d2
.pixelNotSolid2:
		dbf	d1,.processColumnLoop2
		bra.s	.columnProcessed
; ---------------------------------------------------------------------------

.entireColumnSolid:
		move.w	#$10,d0
.noCollision:
		move.w	d0,d2
.columnProcessed:
		move.b	d2,(a2)+				; store column collision height
		dbf	d3,.processLoop
		rts
; End of function ConvertCollisionArray
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic to the wall in front of him
; 
; input:
;	d0 = Sonic's floor angle rotated 90 degrees (i.e. angle of wall ahead)
; 
; output:
;	d1 = distance to wall
; ---------------------------------------------------------------------------

; Sonic_WalkSpeed: <-- old misnomer
Sonic_CalcRoomAhead:
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3					; d3 = predicted x pos. at next frame
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2					; d2 = predicted y pos. at next frame
		swap	d2
		swap	d3
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		move.b	d0,d1
		addi.b	#$20,d0
		bpl.s	.floor_or_left				; branch if angle is floor or left vertical
		move.b	d1,d0
		bpl.s	.angle_pos
		subq.b	#1,d0

	; loc_14D14:
	.angle_pos:
		addi.b	#$20,d0
		bra.s	.find_wall
; ===========================================================================

; loc_14D1A:
.floor_or_left:
		move.b	d1,d0
		bpl.s	.angle_pos_
		addq.b	#1,d0

	; loc_14D20:
	.angle_pos_:
		addi.b	#$1F,d0

; loc_14D24:
.find_wall:
		andi.b	#$C0,d0
		beq.w	Sonic_FindFloor_Quick
		cmpi.b	#$80,d0
		beq.w	Sonic_FindCeiling_Quick
		andi.b	#$38,d1
		bne.s	.find_wall_lr
		addq.w	#8,d2
	if FixBugs
		; Fix push sensor position while rolling
		btst	#2,obStatus(a0)				; is Sonic rolling?
		beq.s	.find_wall_lr				; if not, branch
		subq.w	#5,d2					; if so, move push sensor up a bit
	endif

	; loc_14D3C:
	.find_wall_lr:
		cmpi.b	#$40,d0
		beq.w	Sonic_FindWallLeft_Quick
		bra.w	Sonic_FindWallRight_Quick
; End of function Sonic_CalcRoomAhead

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic's head to the ceiling
; 
; input:
;	d0 = Sonic's floor angle inverted
; 
; output:
;	d1 = distance to ceiling
; ---------------------------------------------------------------------------

; sub_14D48:
Sonic_CalcHeadroom:
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		addi.b	#$20,d0
		andi.b	#$C0,d0					; read only bits 6 and 7 of angle
		cmpi.b	#$40,d0					; is Sonic on a left-facing wall?
		beq.w	Sonic_FindWallLeft			; ceiling is to the left
		cmpi.b	#$80,d0					; is Sonic on the ground?
		beq.w	Sonic_FindCeiling			; ceiling is directly above
		cmpi.b	#$C0,d0					; is Sonic on a right-facing wall?
		beq.w	Sonic_FindWallRight			; ceiling is to the right
; End of function Sonic_CalcHeadroom

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor
; 
; output:
;	d0 = distance to floor (larger if on a slope)
;	d1 = distance to floor (smaller if on a slope)
;	d3 = floor angle
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; Sonic_HitFloor: <-- old misnomer
Sonic_FindFloor:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottom edge
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's right edge
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindFloor
	if FixBugs
		move.w	d4,-(sp)
	endif
		move.w	d1,-(sp)				; save d1 (distance to floor) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottom edge
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's left edge
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness (top solid)
		bsr.w	FindFloor				; d1 = distance to floor left side
		move.w	(sp)+,d0				; d0 = distance to floor right side
	if FixBugs
		move.w	(sp)+,d5
	endif
		move.b	#0,d2

; loc_14DD0:
Sonic_FindSmaller:
		move.b	(v_anglebuffer2).w,d3
		cmp.w	d0,d1					; compare the output distances
		ble.s	.no_swap				; branch if d0 > d1
		move.b	(v_anglebuffer).w,d3
		exg	d0,d1					; d1 is always the smaller distance
	if FixBugs
		exg.l	d5,d4
	endif

	; loc_14DDE:
	.no_swap:
		btst	#0,d3					; is bit 0 of angle set?
		beq.s	.no_angle_snap				; if not, branch
		move.b	d2,d3					; clear d3 (this is copied to ost_angle)

	; locret_14DE6:
	.no_angle_snap:
		rts
; End of function Sonic_FindFloor

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor, no width/height checks
; 
; input:
;	d2 = y position of Sonic
;	d3 = x position of Sonic
; 
; output:
;	d1 = distance to floor
;	d3 = floor angle
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindFloor_Quick_UsePos: ; not called from anywhere
		move.w	obY(a0),d2				; unused
		move.w	obX(a0),d3				; unused

; loc_14DF0:
Sonic_FindFloor_Quick:
		addi.w	#sonic_quick_size,d2
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor
		move.b	#0,d2

; loc_14E0A:
Sonic_SnapAngle:
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	.no_angle_snap				; branch if bit 0 of angle is clear
		move.b	d2,d3					; snap angle to 0, $40, $80 or $C0

	; locret_14E16:
	.no_angle_snap:
		rts
; End of function Sonic_FindFloor_Quick
; ===========================================================================

		include	"_incObj/sub ObjFloorDist.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to right wall when Sonic is moving vertically
; 
; output:
;	d0 = distance to wall (larger if on a slope)
;	d1 = distance to wall (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; sub_14E50:
Sonic_FindWallRight:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's upper edge (his left/right)
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's rightmost edge (his feet/head)
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
	if FixBugs
		move.w	d4,-(sp)
	endif
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's lower edge (his right/left)
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's rightmost edge (his feet/head)
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall				; d1 = distance to wall upper side
		move.w	(sp)+,d0				; d0 = distance to wall lower side
	if FixBugs
		move.w	(sp)+,d5
	endif

		move.b	#$C0,d2
		bra.w	Sonic_FindSmaller			; make d1 the smaller distance
; End of function Sonic_FindWallRight

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to right wall when moving vertically,
; no width/height checks
; 
; input:
;	d2 = y position of Sonic (Sonic_FindWallRight_Quick only)
;	d3 = x position of Sonic (Sonic_FindWallRight_Quick only)
; 
; output:
;	d1 = distance to wall
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; sub_14EB4:
Sonic_FindWallRight_Quick_UsePos:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

; loc_14EBC:
Sonic_FindWallRight_Quick:
		addi.w	#sonic_quick_size,d3
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	Sonic_SnapAngle				; check for snap to 90 degrees
; End of function Sonic_FindWallRight_Quick

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its right.
; Runs FindWall without the need for inputs, using object RAM instead.
; 
; input:
;	d3.w = x radius of object, right side
; 
; output:
;	d1.w = distance to the wall
;	d3.b = wall angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = wall angle
; ---------------------------------------------------------------------------

; FindWallRightObj:
ObjHitWallRight:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_anglebuffer).w,a4			; write angle here
		move.b	#0,(a4)
		movea.w	#$10,a3					; width of a 16x16 tile
		move.w	#0,d6
		moveq	#$E,d5					; bit to test for solidness
		bsr.w	FindWall
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#$C0,d3					; snap to flat right wall

	; locret_14F06:
	.no_snap:
		rts
; End of function ObjHitWallRight

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling, used to prevent Sonic from
; running on walls and ceilings when he touches them
; 
; output:
;	d0 = distance to ceiling (larger if on a slope)
;	d1 = distance to ceiling (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; Sonic_DontRunOnWalls: <-- old misnomer
Sonic_FindCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's top edge
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's right edge
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$1000,d6				; yflip tile
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor
	if FixBugs
		move.w	d4,-(sp)
	endif
		move.w	d1,-(sp)				; save d1 (distance to ceiling) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's top edge
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's left edge
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$1000,d6				; yflip tile
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor				; d1 = distance to ceiling on left side
		move.w	(sp)+,d0				; d0 = distance to ceiling on right side
	if FixBugs
		move.w	(sp)+,d5
	endif

		move.b	#$80,d2
		bra.w	Sonic_FindSmaller			; make d1 the smaller distance
; End of function Sonic_FindCeiling

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling, no width/height checks
; 
; input:
;	d2 = y position of Sonic
;	d3 = x position of Sonic
; 
; output:
;	d1 = distance to ceiling
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindCeiling_Quick_UsePos: ; not called from anywhere
		move.w	obY(a0),d2				; unused
		move.w	obX(a0),d3				; unused

; loc_14F7C:
Sonic_FindCeiling_Quick:
		subi.w	#sonic_quick_size,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$1000,d6				; yflip tile
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor
		move.b	#-$80,d2
		bra.w	Sonic_SnapAngle				; check for snap to 90 degrees
; End of function Sonic_FindCeiling_Quick

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the ceiling.
; Runs FindFloor without the need for inputs, using object RAM instead.
; 
; output:
;	d1.w = distance to the ceiling
;	d3.b = ceiling angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = ceiling angle
; ---------------------------------------------------------------------------

; FindCeilingObj:
ObjHitCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of top edge
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; height of a 16x16 tile
		move.w	#$1000,d6				; eor mask
		moveq	#$E,d5					; bit to test for solidness
		bsr.w	FindFloor
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#$80,d3					; snap to flat ceiling

	; locret_14FD4:
	.no_snap:
		rts
; End of function ObjHitCeiling

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find distance to left wall when Sonic is moving vertically
; 
; output:
;	d0 = distance to wall (larger if on a slope)
;	d1 = distance to wall (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; loc_14FD6:
Sonic_FindWallLeft:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's upper edge (his left/right)
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's leftmost edge (his feet/head)
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$800,d6				; xflip tile
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
	if FixBugs
		move.w	d4,-(sp)
	endif
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack

		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's lower edge (his right/left)
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's leftmost edge (his feet/head)
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$800,d6				; xflip tile
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall				; d1 = distance to wall lower side
		move.w	(sp)+,d0				; d0 = distance to wall upper side
	if FixBugs
		move.w	(sp)+,d5
	endif

		move.b	#$40,d2
		bra.w	Sonic_FindSmaller			; make d1 the smaller distance
; End of function Sonic_FindWallLeft

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to left wall when moving vertically,
; no width/height checks
; 
; input:
;	d2 = y position of Sonic (Sonic_FindWallLeft_Quick only)
;	d3 = x position of Sonic (Sonic_FindWallLeft_Quick only)
; 
; output:
;	d1 = distance to wall
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; Sonic_HitWall: <-- old misnomer
Sonic_FindWallLeft_Quick_UsePos:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

; loc_1504A:
Sonic_FindWallLeft_Quick:
		subi.w	#sonic_quick_size,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#$800,d6				; xflip tile
		moveq	#$E,d5					; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	Sonic_SnapAngle				; check for snap to 90 degrees
; End of function Sonic_FindWallLeft_Quick

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its left
; Runs FindWall without the need for inputs, taking inputs from local OST variables
; 
; input:
;	d3.w = x radius of object, left side (negative)
; 
; output:
;	d1.w = distance to the wall
;	d3.b = wall angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = wall angle
; ---------------------------------------------------------------------------

; FindWallLeftObj:
ObjHitWallLeft:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
	if FixBugs
		; Engine bug: colliding with left walls is erratic with this function.
		; The cause is this: a missing instruction to flip collision on the found
		; 16x16 block; this one:
		eori.w	#$F,d3
	endif
		lea	(v_anglebuffer).w,a4			; write angle here
		move.b	#0,(a4)
		movea.w	#-$10,a3				; width of a 16x16 tile
		move.w	#$800,d6				; eor mask
		moveq	#$E,d5					; bit to test for solidness
		bsr.w	FindWall
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#$40,d3					; snap to flat left wall

	; locret_15098:
	.no_snap:
		rts
; End of function ObjHitWallLeft
