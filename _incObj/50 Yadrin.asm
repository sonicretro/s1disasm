; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Yad_ChkWall:				; XREF: Yad_FixToFloor
		move.w	(v_framecount).w,d0
		add.w	d7,d0
		andi.w	#3,d0
		bne.s	loc_F836
		moveq	#0,d3
		move.b	obActWid(a0),d3
		tst.w	obVelX(a0)
		bmi.s	loc_F82C
		bsr.w	ObjHitWallRight
		tst.w	d1
		bpl.s	loc_F836

loc_F828:
		moveq	#1,d0
		rts	
; ===========================================================================

loc_F82C:
		not.w	d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bmi.s	loc_F828

loc_F836:
		moveq	#0,d0
		rts	
; End of function Yad_ChkWall

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

Yadrin:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Yad_Index(pc,d0.w),d1
		jmp	Yad_Index(pc,d1.w)
; ===========================================================================
Yad_Index:	dc.w Yad_Main-Yad_Index
		dc.w Yad_Action-Yad_Index

timedelay:	= $30
; ===========================================================================

Yad_Main:	; Routine 0
		move.l	#Map_Yad,obMap(a0)
		move.w	#$247B,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		move.b	#$11,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#$CC,obColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_F89E
		add.w	d1,obY(a0)	; match	object's position with the floor
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		bchg	#0,obStatus(a0)

	locret_F89E:
		rts	
; ===========================================================================

Yad_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Yad_Index2(pc,d0.w),d1
		jsr	Yad_Index2(pc,d1.w)
		lea	(Ani_Yad).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Yad_Index2:	dc.w Yad_Move-Yad_Index2
		dc.w Yad_FixToFloor-Yad_Index2
; ===========================================================================

Yad_Move:				; XREF: Yad_Index2
		subq.w	#1,timedelay(a0) ; subtract 1 from pause time
		bpl.s	locret_F8E2	; if time remains, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$100,obVelX(a0) ; move object
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	locret_F8E2
		neg.w	obVelX(a0)	; change direction

	locret_F8E2:
		rts	
; ===========================================================================

Yad_FixToFloor:			; XREF: Yad_Index2
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	Yad_Pause
		cmpi.w	#$C,d1
		bge.s	Yad_Pause
		add.w	d1,obY(a0)	; match	object's position to the floor
		bsr.w	Yad_ChkWall
		bne.s	Yad_Pause
		rts	
; ===========================================================================

Yad_Pause:
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,timedelay(a0) ; set pause time to 1 second
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts	
