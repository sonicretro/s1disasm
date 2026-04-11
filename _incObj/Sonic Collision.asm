; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic to the wall in front of him
; ---------------------------------------------------------------------------

; Sonic_WalkSpeed: <-- old misnomer
Sonic_CalcRoomAhead:
		move.w	#v_collision1,(v_collindex).w	; MJ: load first collision data location
		cmpi.b	#$C,(v_top_solid_bit).w		; MJ: is second collision set to be used?
		beq.s	.first				; MJ: if not, branch
		move.w	#v_collision2,(v_collindex).w	; MJ: load second collision data location
.first:
		move.b	(v_lrb_solid_bit).w,d5		; MJ: load L/R/B soldity bit
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		move.b	d0,d1
		addi.b	#$20,d0
		bpl.s	loc_14D1A
		move.b	d1,d0
		bpl.s	loc_14D14
		subq.b	#1,d0

loc_14D14:
		addi.b	#$20,d0
		bra.s	loc_14D24
; ===========================================================================

loc_14D1A:
		move.b	d1,d0
		bpl.s	loc_14D20
		addq.b	#1,d0

loc_14D20:
		addi.b	#$1F,d0

loc_14D24:
		andi.b	#$C0,d0
		beq.w	Sonic_FindFloor_Quick
		cmpi.b	#$80,d0
		beq.w	Sonic_FindCeiling_Quick
		andi.b	#$38,d1
		bne.s	loc_14D3C
		addq.w	#8,d2
	if FixBugs
		; Fix push sensor position while rolling
		btst	#2,obStatus(a0)	; Is Sonic rolling?
		beq.s	loc_14D3C	; If not, branch
		subq.w	#5,d2		; If so, move push sensor up a bit
	endif

loc_14D3C:
		cmpi.b	#$40,d0
		beq.w	Sonic_FindWallLeft_Quick
		bra.w	Sonic_FindWallRight_Quick
; End of function Sonic_CalcRoomAhead


; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic's head to the ceiling
; ---------------------------------------------------------------------------

; sub_14D48:
Sonic_CalcHeadroom:
		move.w	#v_collision1,(v_collindex).w	; MJ: load first collision data location
		cmpi.b	#$C,(v_top_solid_bit).w		; MJ: is second collision set to be used?
		beq.s	.first				; MJ: if not, branch
		move.w	#v_collision2,(v_collindex).w	; MJ: load second collision data location
.first:
		move.b	(v_lrb_solid_bit).w,d5		; MJ: load L/R/B soldity bit
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_FindWallLeft
		cmpi.b	#$80,d0
		beq.w	Sonic_FindCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_FindWallRight
; End of function Sonic_CalcHeadroom


; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor
; ---------------------------------------------------------------------------

; Sonic_HitFloor: <-- old misnomer
Sonic_FindFloor:
		move.w	#v_collision1,(v_collindex).w	; MJ: load first collision data location
		cmpi.b	#$C,(v_top_solid_bit).w		; MJ: is second collision set to be used?
		beq.s	.first				; MJ: if not, branch
		move.w	#v_collision2,(v_collindex).w	; MJ: load second collision data location
.first:
		move.b	(v_top_solid_bit).w,d5		; MJ: load L/R/B soldity bit
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor	; MJ: check solidity
		move.w	(sp)+,d0
		move.b	#0,d2

; loc_14DD0:
Sonic_FindSmaller:
		move.b	(v_anglebuffer2).w,d3
		cmp.w	d0,d1
		ble.s	loc_14DDE
		move.b	(v_anglebuffer).w,d3
		exg.l	d0,d1

loc_14DDE:
		btst	#0,d3
		beq.s	locret_14DE6
		move.b	d2,d3

locret_14DE6:
		rts
; End of function Sonic_FindFloor


; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor, no width/height checks
; ---------------------------------------------------------------------------

Sonic_FindFloor_Quick_UsePos: ; not called from anywhere
		move.w	obY(a0),d2
		move.w	obX(a0),d3

; loc_14DF0:
Sonic_FindFloor_Quick:
		addi.w	#$A,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor	; MJ: check solidity
		move.b	#0,d2

; loc_14E0A:
Sonic_SnapAngle:
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	.no_angle_snap	; branch if bit 0 of angle is clear
		move.b	d2,d3		; snap angle to 0, $40, $80 or $C0

	.no_angle_snap:
		rts
; End of function Sonic_FindFloor_Quick
; ===========================================================================

		include	"_incObj/sub ObjFloorDist.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find distance to right wall when Sonic is moving vertically
; ---------------------------------------------------------------------------

; sub_14E50:
Sonic_FindWallRight:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall	; MJ: check solidity
		move.w	(sp)+,d0
		move.b	#-$40,d2
		bra.w	Sonic_FindSmaller
; End of function Sonic_FindWallRight


; ---------------------------------------------------------------------------
; Subroutine to	find distance to right wall when moving vertically,
; no width/height checks
; ---------------------------------------------------------------------------

; sub_14EB4:
Sonic_FindWallRight_Quick_UsePos:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

; loc_14EBC:
Sonic_FindWallRight_Quick:
		addi.w	#$A,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall	; MJ: check solidity
		move.b	#-$40,d2
		bra.w	Sonic_SnapAngle
; End of function Sonic_FindWallRight_Quick


; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its right.
; Runs FindWall without the need for inputs, using object RAM instead.
; ---------------------------------------------------------------------------

; FindWallRightObj:
ObjHitWallRight:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5		; MJ: set solid type to check
		bsr.w	FindWall	; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	.return
		move.b	#-$40,d3

	.return:
		rts
; End of function ObjHitWallRight


; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling, used to prevent Sonic from
; running on walls and ceilings when he touches them
; ---------------------------------------------------------------------------

; Sonic_DontRunOnWalls: <-- old misnomer
Sonic_FindCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.w	(sp)+,d0
		move.b	#-$80,d2
		bra.w	Sonic_FindSmaller
; End of function Sonic_FindCeiling


; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling, no width/height checks
; ---------------------------------------------------------------------------

Sonic_FindCeiling_Quick_UsePos: ; not called from anywhere
		move.w	obY(a0),d2
		move.w	obX(a0),d3

; loc_14F7C:
Sonic_FindCeiling_Quick:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		bsr.w	FindFloor	; MJ: check solidity
		move.b	#-$80,d2
		bra.w	Sonic_SnapAngle
; End of function Sonic_FindCeiling_Quick


; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the ceiling.
; Runs FindFloor without the need for inputs, using object RAM instead.
; ---------------------------------------------------------------------------

; FindCeilingObj:
ObjHitCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6	; MJ: $1000/2
		moveq	#$D,d5		; MJ: set solid type to check
		bsr.w	FindFloor	; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14FD4
		move.b	#-$80,d3

locret_14FD4:
		rts
; End of function ObjHitCeiling


; ---------------------------------------------------------------------------
; Subroutine to find distance to left wall when Sonic is moving vertically
; ---------------------------------------------------------------------------

; loc_14FD6:
Sonic_FindWallLeft:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	Sonic_FindSmaller
; End of function Sonic_FindWallLeft


; ---------------------------------------------------------------------------
; Subroutine to	find distance to left wall when moving vertically,
; no width/height checks
; ---------------------------------------------------------------------------

; Sonic_HitWall: <-- old misnomer
Sonic_FindWallLeft_Quick_UsePos:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

; loc_1504A:
Sonic_FindWallLeft_Quick:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		bsr.w	FindWall	; MJ: check solidity
		move.b	#$40,d2
		bra.w	Sonic_SnapAngle
; End of function Sonic_FindWallLeft_Quick


; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its left
; Runs FindWall without the need for inputs, taking inputs from local OST variables
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
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$400,d6	; MJ: $800/2
		moveq	#$D,d5		; MJ: set solid type to check
		bsr.w	FindWall	; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	.return
		move.b	#$40,d3

	.return:
		rts
; End of function ObjHitWallLeft
