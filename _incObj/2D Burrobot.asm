; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Burrobot:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Burro_Index(pc,d0.w),d1
		jmp	Burro_Index(pc,d1.w)
; ===========================================================================
Burro_Index:	dc.w Burro_Main-Burro_Index
		dc.w Burro_Action-Burro_Index

timedelay:	= $30		; time between direction changes
; ===========================================================================

Burro_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Burro,obMap(a0)
		move.w	#$4A6,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		addq.b	#6,ob2ndRout(a0) ; run "Burro_ChkSonic" routine
		move.b	#2,obAnim(a0)

Burro_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		dc.w @changedir-@index
		dc.w Burro_Move-@index
		dc.w Burro_Jump-@index
		dc.w Burro_ChkSonic-@index
; ===========================================================================

@changedir:				; XREF: @index
		subq.w	#1,timedelay(a0)
		bpl.s	@nochg
		addq.b	#2,ob2ndRout(a0)
		move.w	#255,timedelay(a0)
		move.w	#$80,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)	; change direction the Burrobot	is facing
		beq.s	@nochg
		neg.w	obVelX(a0)	; change direction the Burrobot	is moving

	@nochg:
		rts	
; ===========================================================================

Burro_Move:				; XREF: @index
		subq.w	#1,timedelay(a0)
		bmi.s	loc_AD84
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_AD78
		move.w	obX(a0),d3
		addi.w	#$C,d3
		btst	#0,obStatus(a0)
		bne.s	loc_AD6A
		subi.w	#$18,d3

loc_AD6A:
		jsr	ObjFloorDist2
		cmpi.w	#$C,d1
		bge.s	loc_AD84
		rts	
; ===========================================================================

loc_AD78:				; XREF: Burro_Move
		jsr	ObjFloorDist
		add.w	d1,obY(a0)
		rts	
; ===========================================================================

loc_AD84:				; XREF: Burro_Move
		btst	#2,(v_vbla_byte).w
		beq.s	loc_ADA4
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,timedelay(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts	
; ===========================================================================

loc_ADA4:
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#2,obAnim(a0)
		rts	
; ===========================================================================

Burro_Jump:				; XREF: @index
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bmi.s	locret_ADF0
		move.b	#3,obAnim(a0)
		jsr	ObjFloorDist
		tst.w	d1
		bpl.s	locret_ADF0
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		move.b	#1,obAnim(a0)
		move.w	#255,timedelay(a0)
		subq.b	#2,ob2ndRout(a0)
		bsr.w	Burro_ChkSonic2

locret_ADF0:
		rts	
; ===========================================================================

Burro_ChkSonic:				; XREF: @index
		move.w	#$60,d2
		bsr.w	Burro_ChkSonic2
		bcc.s	locret_AE20
		move.w	(v_player+obY).w,d0
		sub.w	obY(a0),d0
		bcc.s	locret_AE20
		cmpi.w	#-$80,d0
		bcs.s	locret_AE20
		tst.w	(v_debuguse).w
		bne.s	locret_AE20
		subq.b	#2,ob2ndRout(a0)
		move.w	d1,obVelX(a0)
		move.w	#-$400,obVelY(a0)

locret_AE20:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Burro_ChkSonic2:			; XREF: Burro_ChkSonic
		move.w	#$80,d1
		bset	#0,obStatus(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_AE40
		neg.w	d0
		neg.w	d1
		bclr	#0,obStatus(a0)

loc_AE40:
		cmp.w	d2,d0
		rts	
; End of function Burro_ChkSonic2
