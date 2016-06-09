; ---------------------------------------------------------------------------
; Object 78 - Caterkiller enemy	(MZ, SBZ)
; ---------------------------------------------------------------------------

Caterkiller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cat_Index(pc,d0.w),d1
		jmp	Cat_Index(pc,d1.w)
; ===========================================================================
Cat_Index:	dc.w Cat_Main-Cat_Index
		dc.w Cat_Head-Cat_Index
		dc.w Cat_BodySeg1-Cat_Index
		dc.w Cat_BodySeg2-Cat_Index
		dc.w Cat_BodySeg1-Cat_Index
		dc.w Cat_Delete-Cat_Index
		dc.w loc_16CC0-Cat_Index

cat_parent = $3C		; address of parent object
; ===========================================================================

locret_16950:
		rts	
; ===========================================================================

Cat_Main:	; Routine 0
		move.b	#7,obHeight(a0)
		move.b	#8,obWidth(a0)
		jsr	(ObjectFall).l
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	locret_16950
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Cat,obMap(a0)
		move.w	#$22B0,obGfx(a0)
		cmpi.b	#id_SBZ,(v_zone).w ; if level is SBZ, branch
		beq.s	.isscrapbrain
		move.w	#$24FF,obGfx(a0) ; MZ specific code

.isscrapbrain:
		andi.b	#3,obRender(a0)
		ori.b	#4,obRender(a0)
		move.b	obRender(a0),obStatus(a0)
		move.b	#4,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.b	#$B,obColType(a0)
		move.w	obX(a0),d2
		moveq	#$C,d5
		btst	#0,obStatus(a0)
		beq.s	.noflip
		neg.w	d5

.noflip:
		move.b	#4,d6
		moveq	#0,d3
		moveq	#4,d4
		movea.l	a0,a2
		moveq	#2,d1

Cat_Loop:
		jsr	(FindNextFreeObj).l
		if Revision=0
		bne.s	.fail
		else
			bne.w	Cat_ChkGone
		endif
		_move.b	#id_Caterkiller,0(a1) ; load body segment object
		move.b	d6,obRoutine(a1) ; goto Cat_BodySeg1 or Cat_BodySeg2 next
		addq.b	#2,d6		; alternate between the two
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	#5,obPriority(a1)
		move.b	#8,obActWid(a1)
		move.b	#$CB,obColType(a1)
		add.w	d5,d2
		move.w	d2,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	obStatus(a0),obRender(a1)
		move.b	#8,obFrame(a1)
		move.l	a2,cat_parent(a1)
		move.b	d4,cat_parent(a1)
		addq.b	#4,d4
		movea.l	a1,a2

.fail:
		dbf	d1,Cat_Loop	; repeat sequence 2 more times

		move.b	#7,$2A(a0)
		clr.b	cat_parent(a0)

Cat_Head:	; Routine 2
		tst.b	obStatus(a0)
		bmi.w	loc_16C96
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Cat_Index2(pc,d0.w),d1
		jsr	Cat_Index2(pc,d1.w)
		move.b	$2B(a0),d1
		bpl.s	.display
		lea	(Ani_Cat).l,a1
		move.b	obAngle(a0),d0
		andi.w	#$7F,d0
		addq.b	#4,obAngle(a0)
		move.b	(a1,d0.w),d0
		bpl.s	.animate
		bclr	#7,$2B(a0)
		bra.s	.display

.animate:
		andi.b	#$10,d1
		add.b	d1,d0
		move.b	d0,obFrame(a0)

.display:
		out_of_range.w	Cat_ChkGone
		jmp	(DisplaySprite).l

Cat_ChkGone:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	.delete
		bclr	#7,2(a2,d0.w)

.delete:
		move.b	#$A,obRoutine(a0)	; goto Cat_Delete next
		rts	
; ===========================================================================

Cat_Delete:	; Routine $A
		jmp	(DeleteObject).l
; ===========================================================================
Cat_Index2:	dc.w .wait-Cat_Index2
		dc.w loc_16B02-Cat_Index2
; ===========================================================================

.wait:
		subq.b	#1,$2A(a0)
		bmi.s	.move
		rts	
; ===========================================================================

.move:
		addq.b	#2,ob2ndRout(a0)
		move.b	#$10,$2A(a0)
		move.w	#-$C0,obVelX(a0)
		move.w	#$40,obInertia(a0)
		bchg	#4,$2B(a0)
		bne.s	loc_16AFC
		clr.w	obVelX(a0)
		neg.w	obInertia(a0)

loc_16AFC:
		bset	#7,$2B(a0)

loc_16B02:
		subq.b	#1,$2A(a0)
		bmi.s	.loc_16B5E
		if Revision=0
		move.l	obX(a0),-(sp)
		move.l	obX(a0),d2
		else
			tst.w	obVelX(a0)
			beq.s	.notmoving
			move.l	obX(a0),d2
			move.l	d2,d3
		endif
		move.w	obVelX(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noflip
		neg.w	d0

.noflip:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,obX(a0)
		if Revision=0
		jsr	(ObjFloorDist).l
		move.l	(sp)+,d2
		cmpi.w	#-8,d1
		blt.s	.loc_16B70
		cmpi.w	#$C,d1
		bge.s	.loc_16B70
		add.w	d1,obY(a0)
		swap	d2
		cmp.w	obX(a0),d2
		beq.s	.notmoving
		else
			swap	d3
			cmp.w	obX(a0),d3
			beq.s	.notmoving
			jsr	(ObjFloorDist).l
			cmpi.w	#$FFF8,d1
			blt.s	.loc_16B70
			cmpi.w	#$C,d1
			bge.s	.loc_16B70
			add.w	d1,obY(a0)
		endif
		moveq	#0,d0
		move.b	cat_parent(a0),d0
		addq.b	#1,cat_parent(a0)
		andi.b	#$F,cat_parent(a0)
		move.b	d1,$2C(a0,d0.w)

.notmoving:
		rts	
; ===========================================================================

.loc_16B5E:
		subq.b	#2,ob2ndRout(a0)
		move.b	#7,$2A(a0)
		if Revision=0
		move.w	#0,obVelX(a0)
		else
			clr.w	obVelX(a0)
			clr.w	obInertia(a0)
		endif
		rts	
; ===========================================================================

.loc_16B70:
		if Revision=0
		move.l	d2,obX(a0)
		bchg	#0,obStatus(a0)
		move.b	obStatus(a0),obRender(a0)
		moveq	#0,d0
		move.b	cat_parent(a0),d0
		move.b	#$80,$2C(a0,d0.w)
		else
			moveq	#0,d0
			move.b	cat_parent(a0),d0
			move.b	#$80,$2C(a0,d0)
			neg.w	obX+2(a0)
			beq.s	.loc_1730A
			btst	#0,obStatus(a0)
			beq.s	.loc_1730A
			subq.w	#1,obX(a0)
			addq.b	#1,cat_parent(a0)
			moveq	#0,d0
			move.b	cat_parent(a0),d0
			clr.b	$2C(a0,d0)
.loc_1730A:
			bchg	#0,obStatus(a0)
			move.b	obStatus(a0),obRender(a0)
		endif
		addq.b	#1,cat_parent(a0)
		andi.b	#$F,cat_parent(a0)
		rts	
; ===========================================================================

Cat_BodySeg2:	; Routine 6
		movea.l	cat_parent(a0),a1
		move.b	$2B(a1),$2B(a0)
		bpl.s	Cat_BodySeg1
		lea	(Ani_Cat).l,a1
		move.b	obAngle(a0),d0
		andi.w	#$7F,d0
		addq.b	#4,obAngle(a0)
		tst.b	4(a1,d0.w)
		bpl.s	Cat_AniBody
		addq.b	#4,obAngle(a0)

Cat_AniBody:
		move.b	(a1,d0.w),d0
		addq.b	#8,d0
		move.b	d0,obFrame(a0)

Cat_BodySeg1:	; Routine 4, 8
		movea.l	cat_parent(a0),a1
		tst.b	obStatus(a0)
		bmi.w	loc_16C90
		move.b	$2B(a1),$2B(a0)
		move.b	ob2ndRout(a1),ob2ndRout(a0)
		beq.w	loc_16C64
		move.w	obInertia(a1),obInertia(a0)
		move.w	obVelX(a1),d0
		if Revision=0
		add.w	obInertia(a1),d0
		else
			add.w	obInertia(a0),d0
		endif
		move.w	d0,obVelX(a0)
		move.l	obX(a0),d2
		move.l	d2,d3
		move.w	obVelX(a0),d0
		btst	#0,obStatus(a0)
		beq.s	loc_16C0C
		neg.w	d0

loc_16C0C:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,obX(a0)
		swap	d3
		cmp.w	obX(a0),d3
		beq.s	loc_16C64
		moveq	#0,d0
		move.b	cat_parent(a0),d0
		move.b	$2C(a1,d0.w),d1
		cmpi.b	#$80,d1
		bne.s	loc_16C50
		if Revision=0
		swap	d3
		move.l	d3,obX(a0)
		move.b	d1,$2C(a0,d0.w)
		else
			move.b	d1,$2C(a0,d0)
			neg.w	obX+2(a0)
			beq.s	locj_173E4
			btst	#0,obStatus(a0)
			beq.s	locj_173E4
			cmpi.w	#-$C0,obVelX(a0)
			bne.s	locj_173E4
			subq.w	#1,obX(a0)
			addq.b	#1,cat_parent(a0)
			moveq	#0,d0
			move.b	cat_parent(a0),d0
			clr.b	$2C(a0,d0)
locj_173E4:
		endif
		bchg	#0,obStatus(a0)
		move.b	obStatus(a0),1(a0)
		addq.b	#1,cat_parent(a0)
		andi.b	#$F,cat_parent(a0)
		bra.s	loc_16C64
; ===========================================================================

loc_16C50:
		ext.w	d1
		add.w	d1,obY(a0)
		addq.b	#1,cat_parent(a0)
		andi.b	#$F,cat_parent(a0)
		move.b	d1,$2C(a0,d0.w)

loc_16C64:
		cmpi.b	#$C,obRoutine(a1)
		beq.s	loc_16C90
		_cmpi.b	#id_ExplosionItem,0(a1)
		beq.s	loc_16C7C
		cmpi.b	#$A,obRoutine(a1)
		bne.s	loc_16C82

loc_16C7C:
		move.b	#$A,obRoutine(a0)

loc_16C82:
		jmp	(DisplaySprite).l

; ===========================================================================
Cat_FragSpeed:	dc.w -$200, -$180, $180, $200
; ===========================================================================

loc_16C90:
		bset	#7,obStatus(a1)

loc_16C96:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cat_FragSpeed-2(pc,d0.w),d0
		btst	#0,obStatus(a0)
		beq.s	loc_16CAA
		neg.w	d0

loc_16CAA:
		move.w	d0,obVelX(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#$C,obRoutine(a0)
		andi.b	#$F8,obFrame(a0)

loc_16CC0:	; Routine $C
		jsr	(ObjectFall).l
		tst.w	obVelY(a0)
		bmi.s	loc_16CE0
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_16CE0
		add.w	d1,obY(a0)
		move.w	#-$400,obVelY(a0)

loc_16CE0:
		tst.b	obRender(a0)
		bpl.w	Cat_ChkGone
		jmp	(DisplaySprite).l
