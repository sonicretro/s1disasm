; ---------------------------------------------------------------------------
; Object 13 - lava ball maker (MZ, SLZ)
; ---------------------------------------------------------------------------

LavaMaker:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LavaM_Index(pc,d0.w),d1
		jsr	LavaM_Index(pc,d1.w)
	if FixBugs
		; See LavaBall.
		out_of_range.w	DeleteObject
		rts
	else
		bra.w	LBall_ChkDel
	endif
; ===========================================================================
LavaM_Index:	dc.w LavaM_Main-LavaM_Index
		dc.w LavaM_MakeLava-LavaM_Index
; ---------------------------------------------------------------------------
;
; Lava ball production rates
;
LavaM_Rates:	dc.b 30, 60, 90, 120, 150, 180
; ===========================================================================

LavaM_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	obSubtype(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	LavaM_Rates(pc,d0.w),obDelayAni(a0)
		move.b	obDelayAni(a0),obTimeFrame(a0) ; set time delay for lava balls
		andi.b	#$F,obSubtype(a0)

LavaM_MakeLava:	; Routine 2
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from time delay
		bne.s	LavaM_Wait	; if time still remains, branch
		move.b	obDelayAni(a0),obTimeFrame(a0) ; reset time delay
		bsr.w	ChkObjectVisible
		bne.s	LavaM_Wait
		bsr.w	FindFreeObj
		bne.s	LavaM_Wait
		_move.b	#id_LavaBall,obID(a1) ; load lava ball object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obSubtype(a0),obSubtype(a1)

LavaM_Wait:
		rts


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 14 - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

LavaBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LBall_Index(pc,d0.w),d1
	if FixBugs
		jmp	LBall_Index(pc,d1.w)
	else
		jsr	LBall_Index(pc,d1.w)
		bra.w	DisplaySprite
	endif
; ===========================================================================
LBall_Index:	dc.w LBall_Main-LBall_Index
		dc.w LBall_Action-LBall_Index
		dc.w LBall_Delete-LBall_Index

LBall_Speeds:	dc.w -$400, -$500, -$600, -$700, -$200
		dc.w $200, -$200, $200,	0
; ===========================================================================

LBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#16/2,obHeight(a0)
		move.b	#16/2,obWidth(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#ArtTile_MZ_Fireball,obGfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w	; check if level is SLZ
		bne.s	.notSLZ
		move.w	#ArtTile_SLZ_Fireball,obGfx(a0)	; SLZ specific code

.notSLZ:
		move.b	#sprite_cam_field,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#col_16x16|col_hurt,obColType(a0)
		move.w	obY(a0),objoff_30(a0)
		tst.b	objoff_29(a0)
		beq.s	.speed
		addq.b	#2,obPriority(a0)

.speed:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	LBall_Speeds(pc,d0.w),obVelY(a0) ; load object speed (vertical)
		move.b	#16/2,obActWid(a0)
		cmpi.b	#6,obSubtype(a0) ; is object type below $6 ?
		blo.s	.sound		; if yes, branch

		move.b	#32/2,obActWid(a0)
		move.b	#2,obAnim(a0)	; use horizontal animation
		move.w	obVelY(a0),obVelX(a0) ; set horizontal speed
		move.w	#0,obVelY(a0)	; delete vertical speed

.sound:
		move.w	#sfx_Fireball,d0
		jsr	(QueueSound2).l	; play lava ball sound

LBall_Action:	; Routine 2
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	LBall_TypeIndex(pc,d0.w),d1
		jsr	LBall_TypeIndex(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Fire).l,a1
		bsr.w	AnimateSprite

LBall_ChkDel:
		out_of_range.w	DeleteObject
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================
LBall_TypeIndex:dc.w LBall_Type00-LBall_TypeIndex
		dc.w LBall_Type00-LBall_TypeIndex
		dc.w LBall_Type00-LBall_TypeIndex
		dc.w LBall_Type00-LBall_TypeIndex
		dc.w LBall_Type04-LBall_TypeIndex
		dc.w LBall_Type05-LBall_TypeIndex
		dc.w LBall_Type06-LBall_TypeIndex
		dc.w LBall_Type07-LBall_TypeIndex
		dc.w LBall_Type08-LBall_TypeIndex
; ===========================================================================
; lava ball types 00-03 fly up and fall back down

LBall_Type00:
		addi.w	#$18,obVelY(a0)	; increase object's downward speed
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0	; has object fallen back to its original position?
		bhs.s	loc_E41E	; if not, branch
		addq.b	#2,obRoutine(a0)	; goto "LBall_Delete" routine

loc_E41E:
		bclr	#1,obStatus(a0)
		tst.w	obVelY(a0)
		bpl.s	locret_E430
		bset	#1,obStatus(a0)

locret_E430:
		rts
; ===========================================================================
; lavaball type 04 flies up until it hits the ceiling

LBall_Type04:
		bset	#1,obStatus(a0)
		bsr.w	ObjHitCeiling
		tst.w	d1
		bpl.s	locret_E452
		move.b	#8,obSubtype(a0)
		move.b	#1,obAnim(a0)
		move.w	#0,obVelY(a0)	; stop the object when it touches the ceiling

locret_E452:
		rts
; ===========================================================================
; lavaball type 05 falls down until it hits the floor

LBall_Type05:
		bclr	#1,obStatus(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_E474
		move.b	#8,obSubtype(a0)
		move.b	#1,obAnim(a0)
		move.w	#0,obVelY(a0)	; stop the object when it touches the floor

locret_E474:
		rts
; ===========================================================================
; lavaball types 06-07 move sideways

LBall_Type06:
		bset	#0,obStatus(a0)
		moveq	#-8,d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bpl.s	locret_E498
		move.b	#8,obSubtype(a0)
		move.b	#3,obAnim(a0)
		move.w	#0,obVelX(a0)	; stop object when it touches a wall

locret_E498:
		rts
; ===========================================================================

LBall_Type07:
		bclr	#0,obStatus(a0)
		moveq	#8,d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bpl.s	locret_E4BC
		move.b	#8,obSubtype(a0)
		move.b	#3,obAnim(a0)
		move.w	#0,obVelX(a0)	; stop object when it touches a wall

locret_E4BC:
		rts
; ===========================================================================

LBall_Type08:
		rts
; ===========================================================================

LBall_Delete:
		bra.w	DeleteObject
; ===========================================================================

		include	"_anim/Fireballs.asm"
