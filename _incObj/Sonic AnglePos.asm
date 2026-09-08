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
; ===========================================================================

; locret_1470A:
Sonic_InsideWall:
		rts

; ===========================================================================
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
