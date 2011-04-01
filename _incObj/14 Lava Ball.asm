; ---------------------------------------------------------------------------
; Object 14 - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

LavaBall:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LBall_Index(pc,d0.w),d1
		jsr	LBall_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
LBall_Index:	dc.w LBall_Main-LBall_Index
		dc.w LBall_Action-LBall_Index
		dc.w LBall_Delete-LBall_Index

LBall_Speeds:	dc.w -$400, -$500, -$600, -$700, -$200
		dc.w $200, -$200, $200,	0
; ===========================================================================

LBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#8,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#$345,obGfx(a0)
		cmpi.b	#3,(v_zone).w	; check if level is SLZ
		bne.s	@notSLZ
		move.w	#$480,obGfx(a0)	; SLZ specific code

	@notSLZ:
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.w	obY(a0),$30(a0)
		tst.b	$29(a0)
		beq.s	@speed
		addq.b	#2,obPriority(a0)

	@speed:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	LBall_Speeds(pc,d0.w),obVelY(a0) ; load object speed (vertical)
		move.b	#8,obActWid(a0)
		cmpi.b	#6,obSubtype(a0) ; is object type below $6 ?
		bcs.s	@sound		; if yes, branch

		move.b	#$10,obActWid(a0)
		move.b	#2,obAnim(a0)	; use horizontal animation
		move.w	obVelY(a0),obVelX(a0) ; set horizontal speed
		move.w	#0,obVelY(a0)	; delete vertical speed

	@sound:
		sfx	sfx_Fireball	; play lava ball sound

LBall_Action:	; Routine 2
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	LBall_TypeIndex(pc,d0.w),d1
		jsr	LBall_TypeIndex(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Fire).l,a1
		bsr.w	AnimateSprite

LBall_ChkDel:				; XREF: LavaMaker
		out_of_range	DeleteObject
		rts	
; ===========================================================================
LBall_TypeIndex:dc.w LBall_Type00-LBall_TypeIndex, LBall_Type00-LBall_TypeIndex
		dc.w LBall_Type00-LBall_TypeIndex, LBall_Type00-LBall_TypeIndex
		dc.w LBall_Type04-LBall_TypeIndex, LBall_Type05-LBall_TypeIndex
		dc.w LBall_Type06-LBall_TypeIndex, LBall_Type07-LBall_TypeIndex
		dc.w LBall_Type08-LBall_TypeIndex
; ===========================================================================
; lavaball types 00-03 fly up and fall back down

LBall_Type00:				; XREF: LBall_TypeIndex
		addi.w	#$18,obVelY(a0)	; increase object's downward speed
		move.w	$30(a0),d0
		cmp.w	obY(a0),d0	; has object fallen back to its	original position?
		bcc.s	loc_E41E	; if not, branch
		addq.b	#2,obRoutine(a0)	; goto "LBall_Delete" routine

loc_E41E:
		bclr	#1,obStatus(a0)
		tst.w	obVelY(a0)
		bpl.s	locret_E430
		bset	#1,obStatus(a0)

locret_E430:
		rts	
; ===========================================================================
; lavaball type	04 flies up until it hits the ceiling

LBall_Type04:				; XREF: LBall_TypeIndex
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
; lavaball type	05 falls down until it hits the	floor

LBall_Type05:				; XREF: LBall_TypeIndex
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

LBall_Type06:				; XREF: LBall_TypeIndex
		bset	#0,obStatus(a0)
		moveq	#-8,d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bpl.s	locret_E498
		move.b	#8,obSubtype(a0)
		move.b	#3,obAnim(a0)
		move.w	#0,obVelX(a0)	; stop object when it touches a	wall

locret_E498:
		rts	
; ===========================================================================

LBall_Type07:				; XREF: LBall_TypeIndex
		bclr	#0,obStatus(a0)
		moveq	#8,d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bpl.s	locret_E4BC
		move.b	#8,obSubtype(a0)
		move.b	#3,obAnim(a0)
		move.w	#0,obVelX(a0)	; stop object when it touches a	wall

locret_E4BC:
		rts	
; ===========================================================================

LBall_Type08:				; XREF: LBall_TypeIndex
		rts	
; ===========================================================================

LBall_Delete:				; XREF: LBall_Index
		bra.w	DeleteObject
