; ---------------------------------------------------------------------------
; Object 28 - animals
; ---------------------------------------------------------------------------

Animals:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Anml_Index(pc,d0.w),d1
		jmp	Anml_Index(pc,d1.w)
; ===========================================================================
Anml_Index:	dc.w Anml_Ending-Anml_Index, loc_912A-Anml_Index
		dc.w loc_9184-Anml_Index, loc_91C0-Anml_Index
		dc.w loc_9184-Anml_Index, loc_9184-Anml_Index
		dc.w loc_9184-Anml_Index, loc_91C0-Anml_Index
		dc.w loc_9184-Anml_Index, loc_9240-Anml_Index
		dc.w loc_9260-Anml_Index, loc_9260-Anml_Index
		dc.w loc_9280-Anml_Index, loc_92BA-Anml_Index
		dc.w loc_9314-Anml_Index, loc_9332-Anml_Index
		dc.w loc_9314-Anml_Index, loc_9332-Anml_Index
		dc.w loc_9314-Anml_Index, loc_9370-Anml_Index
		dc.w loc_92D6-Anml_Index

Anml_VarIndex:	dc.b 0,	5 ; Green Hill Zone
		dc.b 2, 3 ; Labyrinth Zone
		dc.b 6, 3 ; Marble Zone
		dc.b 4, 5 ; Star Light Zone
		dc.b 4, 1 ; Spring Yard Zone
		dc.b 0, 1 ; Scrap Brain Zone

Anml_Variables:	dc.w -$200, -$400
		dc.l Map_Animal1
		dc.w -$200, -$300	; horizontal speed, vertical speed
		dc.l Map_Animal2	; mappings address
		dc.w -$180, -$300
		dc.l Map_Animal1
		dc.w -$140, -$180
		dc.l Map_Animal2
		dc.w -$1C0, -$300
		dc.l Map_Animal3
		dc.w -$300, -$400
		dc.l Map_Animal2
		dc.w -$280, -$380
		dc.l Map_Animal3

Anml_EndSpeed:	dc.w -$440, -$400, -$440, -$400, -$440, -$400, -$300, -$400
		dc.w -$300, -$400, -$180, -$300, -$180, -$300, -$140, -$180
		dc.w -$1C0, -$300, -$200, -$300, -$280, -$380

Anml_EndMap:	dc.l Map_Animal2, Map_Animal2, Map_Animal2, Map_Animal1, Map_Animal1
		dc.l Map_Animal1, Map_Animal1, Map_Animal2, Map_Animal3, Map_Animal2
		dc.l Map_Animal3

Anml_EndVram:	dc.w make_art_tile(ArtTile_Ending_Flicky,0,0)
		dc.w make_art_tile(ArtTile_Ending_Flicky,0,0)
		dc.w make_art_tile(ArtTile_Ending_Flicky,0,0)
		dc.w make_art_tile(ArtTile_Ending_Rabbit,0,0)
		dc.w make_art_tile(ArtTile_Ending_Rabbit,0,0)
		dc.w make_art_tile(ArtTile_Ending_Penguin,0,0)
		dc.w make_art_tile(ArtTile_Ending_Penguin,0,0)
		dc.w make_art_tile(ArtTile_Ending_Seal,0,0)
		dc.w make_art_tile(ArtTile_Ending_Pig,0,0)
		dc.w make_art_tile(ArtTile_Ending_Chicken,0,0)
		dc.w make_art_tile(ArtTile_Ending_Squirrel,0,0)
; ===========================================================================

Anml_Ending:	; Routine 0
		tst.b	obSubtype(a0)	; did animal come from a destroyed enemy?
		beq.w	Anml_FromEnemy	; if yes, branch
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; move object type to d0
		add.w	d0,d0		; multiply d0 by 2
		move.b	d0,obRoutine(a0) ; move d0 to routine counter
		subi.w	#$14,d0
		move.w	Anml_EndVram(pc,d0.w),obGfx(a0)
		add.w	d0,d0
		move.l	Anml_EndMap(pc,d0.w),obMap(a0)
		lea	Anml_EndSpeed(pc),a1
		move.w	(a1,d0.w),objoff_32(a0) ; load horizontal speed
		move.w	(a1,d0.w),obVelX(a0)
		move.w	2(a1,d0.w),objoff_34(a0) ; load vertical speed
		move.w	2(a1,d0.w),obVelY(a0)
		move.b	#$C,obHeight(a0)
		move.b	#4,obRender(a0)
		bset	#0,obRender(a0)
		move.b	#6,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		bra.w	DisplaySprite
; ===========================================================================

Anml_FromEnemy:
		addq.b	#2,obRoutine(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(v_zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		lea	Anml_VarIndex(pc),a1
		move.b	(a1,d1.w),d0
		move.b	d0,objoff_30(a0)
		lsl.w	#3,d0
		lea	Anml_Variables(pc),a1
		adda.w	d0,a1
		move.w	(a1)+,objoff_32(a0)	; load horizontal speed
		move.w	(a1)+,objoff_34(a0)	; load vertical	speed
		move.l	(a1)+,obMap(a0)	; load mappings
		move.w	#make_art_tile(ArtTile_Animal_1,0,0),obGfx(a0)	; VRAM setting for 1st animal
		btst	#0,objoff_30(a0)	; is 1st animal	used?
		beq.s	loc_90C0	; if yes, branch
		move.w	#make_art_tile(ArtTile_Animal_2,0,0),obGfx(a0)	; VRAM setting for 2nd animal

loc_90C0:
		move.b	#$C,obHeight(a0)
		move.b	#4,obRender(a0)
		bset	#0,obRender(a0)
		move.b	#6,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		move.b	#2,obFrame(a0)
		move.w	#-$400,obVelY(a0)
		tst.b	(v_bossstatus).w
		bne.s	loc_911C
		bsr.w	FindFreeObj
		bne.s	Anml_Display
		_move.b	#id_Points,obID(a1) ; load points object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	objoff_3E(a0),d0
		lsr.w	#1,d0
		move.b	d0,obFrame(a1)

Anml_Display:
		bra.w	DisplaySprite
; ===========================================================================

loc_911C:
		move.b	#$12,obRoutine(a0)
		clr.w	obVelX(a0)
		bra.w	DisplaySprite
; ===========================================================================

loc_912A:
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectFall
		tst.w	obVelY(a0)
		bmi.s	loc_9180
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_9180
		add.w	d1,obY(a0)
		move.w	objoff_32(a0),obVelX(a0)
		move.w	objoff_34(a0),obVelY(a0)
		move.b	#1,obFrame(a0)
		move.b	objoff_30(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,obRoutine(a0)
		tst.b	(v_bossstatus).w
		beq.s	loc_9180
		btst	#4,(v_vbla_byte).w
		beq.s	loc_9180
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)

loc_9180:
		bra.w	DisplaySprite
; ===========================================================================

loc_9184:
		bsr.w	ObjectFall
		move.b	#1,obFrame(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_91AE
		move.b	#0,obFrame(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_91AE
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

loc_91AE:
		tst.b	obSubtype(a0)
		bne.s	loc_9224
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

loc_91C0:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_91FC
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_91FC
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_91FC
		cmpi.b	#$A,obSubtype(a0)
		beq.s	loc_91FC
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)

loc_91FC:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_9212
		move.b	#1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		andi.b	#1,obFrame(a0)

loc_9212:
		tst.b	obSubtype(a0)
		bne.s	loc_9224
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

loc_9224:
		move.w	obX(a0),d0
		sub.w	(v_player+obX).w,d0
		bcs.s	loc_923C
		subi.w	#$180,d0
		bpl.s	loc_923C
		tst.b	obRender(a0)
		bpl.w	DeleteObject

loc_923C:
		bra.w	DisplaySprite
; ===========================================================================

loc_9240:
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		subq.w	#1,objoff_36(a0)
		bne.w	loc_925C
		move.b	#2,obRoutine(a0)
		move.b	#3,obPriority(a0)

loc_925C:
		bra.w	DisplaySprite
; ===========================================================================

loc_9260:
		bsr.w	sub_9404
		bcc.s	loc_927C
		move.w	objoff_32(a0),obVelX(a0)
		move.w	objoff_34(a0),obVelY(a0)
		move.b	#$E,obRoutine(a0)
		bra.w	loc_91C0
; ===========================================================================

loc_927C:
		bra.w	loc_9224
; ===========================================================================

loc_9280:
		bsr.w	sub_9404
		bpl.s	loc_92B6
		clr.w	obVelX(a0)
		clr.w	objoff_32(a0)
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bsr.w	loc_93C4
		bsr.w	loc_93EC
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_92B6
		move.b	#1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		andi.b	#1,obFrame(a0)

loc_92B6:
		bra.w	loc_9224
; ===========================================================================

loc_92BA:
		bsr.w	sub_9404
		bpl.s	loc_9310
		move.w	objoff_32(a0),obVelX(a0)
		move.w	objoff_34(a0),obVelY(a0)
		move.b	#4,obRoutine(a0)
		bra.w	loc_9184
; ===========================================================================

loc_92D6:
		bsr.w	ObjectFall
		move.b	#1,obFrame(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_9310
		move.b	#0,obFrame(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_9310
		not.b	objoff_29(a0)
		bne.s	loc_9306
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)

loc_9306:
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

loc_9310:
		bra.w	loc_9224
; ===========================================================================

loc_9314:
		bsr.w	sub_9404
		bpl.s	loc_932E
		clr.w	obVelX(a0)
		clr.w	objoff_32(a0)
		bsr.w	ObjectFall
		bsr.w	loc_93C4
		bsr.w	loc_93EC

loc_932E:
		bra.w	loc_9224
; ===========================================================================

loc_9332:
		bsr.w	sub_9404
		bpl.s	loc_936C
		bsr.w	ObjectFall
		move.b	#1,obFrame(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_936C
		move.b	#0,obFrame(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_936C
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

loc_936C:
		bra.w	loc_9224
; ===========================================================================

loc_9370:
		bsr.w	sub_9404
		bpl.s	loc_93C0
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_93AA
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_93AA
		not.b	objoff_29(a0)
		bne.s	loc_93A0
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)

loc_93A0:
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

loc_93AA:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_93C0
		move.b	#1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		andi.b	#1,obFrame(a0)

loc_93C0:
		bra.w	loc_9224
; ===========================================================================

loc_93C4:
		move.b	#1,obFrame(a0)
		tst.w	obVelY(a0)
		bmi.s	locret_93EA
		move.b	#0,obFrame(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	locret_93EA
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

locret_93EA:
		rts	
; ===========================================================================

loc_93EC:
		bset	#0,obRender(a0)
		move.w	obX(a0),d0
		sub.w	(v_player+obX).w,d0
		bcc.s	locret_9402
		bclr	#0,obRender(a0)

locret_9402:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_9404:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		subi.w	#$B8,d0
		rts	
; End of function sub_9404
