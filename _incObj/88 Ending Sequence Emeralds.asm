; ---------------------------------------------------------------------------
; Object 88 - chaos emeralds on	the ending sequence
; ---------------------------------------------------------------------------

EndChaos:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ECha_Index(pc,d0.w),d1
		jsr	ECha_Index(pc,d1.w)
		jmp	DisplaySprite
; ===========================================================================
ECha_Index:	dc.w ECha_Main-ECha_Index
		dc.w ECha_Move-ECha_Index

echa_origX:	= $38	; x-axis centre of emerald circle (2 bytes)
echa_origY:	= $3A	; y-axis centre of emerald circle (2 bytes)
echa_radius:	= $3C	; radius (2 bytes)
echa_angle:	= $3E	; angle for rotation (2 bytes)
; ===========================================================================

ECha_Main:	; Routine 0
		cmpi.b	#2,(v_player+obFrame).w
		beq.s	ECha_CreateEms
		addq.l	#4,sp
		rts	
; ===========================================================================

ECha_CreateEms:
		move.w	(v_player+obX).w,obX(a0) ; match X position with Sonic
		move.w	(v_player+obY).w,obY(a0) ; match Y position with Sonic
		movea.l	a0,a1
		moveq	#0,d3
		moveq	#1,d2
		moveq	#5,d1

	ECha_LoadLoop:
		move.b	#id_EndChaos,(a1) ; load chaos emerald object
		addq.b	#2,obRoutine(a1)
		move.l	#Map_ECha,obMap(a1)
		move.w	#$3C5,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#1,obPriority(a1)
		move.w	obX(a0),echa_origX(a1)
		move.w	obY(a0),echa_origY(a1)
		move.b	d2,obAnim(a1)
		move.b	d2,obFrame(a1)
		addq.b	#1,d2
		move.b	d3,obAngle(a1)
		addi.b	#$100/6,d3	; angle between each emerald
		lea	$40(a1),a1
		dbf	d1,ECha_LoadLoop ; repeat 5 more times

ECha_Move:	; Routine 2
		move.w	echa_angle(a0),d0
		add.w	d0,obAngle(a0)
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		moveq	#0,d4
		move.b	echa_radius(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	echa_origX(a0),d1
		add.w	echa_origY(a0),d0
		move.w	d1,obX(a0)
		move.w	d0,obY(a0)

	ECha_Expand:
		cmpi.w	#$2000,echa_radius(a0)
		beq.s	ECha_Rotate
		addi.w	#$20,echa_radius(a0) ; expand circle of emeralds

	ECha_Rotate:
		cmpi.w	#$2000,echa_angle(a0)
		beq.s	ECha_Rise
		addi.w	#$20,echa_angle(a0) ; move emeralds around the centre

	ECha_Rise:
		cmpi.w	#$140,echa_origY(a0)
		beq.s	ECha_End
		subq.w	#1,echa_origY(a0) ; make circle rise

ECha_End:
		rts	
