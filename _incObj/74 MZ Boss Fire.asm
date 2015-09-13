; ---------------------------------------------------------------------------
; Object 74 - lava that	Eggman drops (MZ)
; ---------------------------------------------------------------------------

BossFire:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj74_Index(pc,d0.w),d0
		jsr	Obj74_Index(pc,d0.w)
		jmp	(DisplaySprite).l
; ===========================================================================
Obj74_Index:	dc.w Obj74_Main-Obj74_Index
		dc.w Obj74_Action-Obj74_Index
		dc.w loc_18886-Obj74_Index
		dc.w Obj74_Delete3-Obj74_Index
; ===========================================================================

Obj74_Main:	; Routine 0
		move.b	#8,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#$345,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#5,obPriority(a0)
		move.w	obY(a0),$38(a0)
		move.b	#8,obActWid(a0)
		addq.b	#2,obRoutine(a0)
		tst.b	obSubtype(a0)
		bne.s	loc_1870A
		move.b	#$8B,obColType(a0)
		addq.b	#2,obRoutine(a0)
		bra.w	loc_18886
; ===========================================================================

loc_1870A:
		move.b	#$1E,$29(a0)
		sfx	sfx_Fireball,0,0,0	; play lava sound

Obj74_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Obj74_Index2(pc,d0.w),d0
		jsr	Obj74_Index2(pc,d0.w)
		jsr	(SpeedToPos).l
		lea	(Ani_Fire).l,a1
		jsr	(AnimateSprite).l
		cmpi.w	#$2E8,obY(a0)
		bhi.s	Obj74_Delete
		rts	
; ===========================================================================

Obj74_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
Obj74_Index2:	dc.w Obj74_Drop-Obj74_Index2
		dc.w Obj74_MakeFlame-Obj74_Index2
		dc.w Obj74_Duplicate-Obj74_Index2
		dc.w Obj74_FallEdge-Obj74_Index2
; ===========================================================================

Obj74_Drop:
		bset	#1,obStatus(a0)
		subq.b	#1,$29(a0)
		bpl.s	locret_18780
		move.b	#$8B,obColType(a0)
		clr.b	obSubtype(a0)
		addi.w	#$18,obVelY(a0)
		bclr	#1,obStatus(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_18780
		addq.b	#2,ob2ndRout(a0)

locret_18780:
		rts	
; ===========================================================================

Obj74_MakeFlame:
		subq.w	#2,obY(a0)
		bset	#7,obGfx(a0)
		move.w	#$A0,obVelX(a0)
		clr.w	obVelY(a0)
		move.w	obX(a0),$30(a0)
		move.w	obY(a0),$38(a0)
		move.b	#3,$29(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_187CA
		lea	(a1),a3
		lea	(a0),a2
		moveq	#3,d0

Obj74_Loop:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d0,Obj74_Loop

		neg.w	obVelX(a1)
		addq.b	#2,ob2ndRout(a1)

loc_187CA:
		addq.b	#2,ob2ndRout(a0)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj74_Duplicate2:
		jsr	(FindNextFreeObj).l
		bne.s	locret_187EE
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#id_BossFire,(a1)
		move.w	#$67,obSubtype(a1)

locret_187EE:
		rts	
; End of function Obj74_Duplicate2

; ===========================================================================

Obj74_Duplicate:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	loc_18826
		move.w	obX(a0),d0
		cmpi.w	#$1940,d0
		bgt.s	loc_1882C
		move.w	$30(a0),d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		andi.w	#$10,d0
		andi.w	#$10,d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		bsr.s	Obj74_Duplicate2
		move.w	obX(a0),$32(a0)

loc_1881E:
		move.w	obX(a0),$30(a0)
		rts	
; ===========================================================================

loc_18826:
		addq.b	#2,ob2ndRout(a0)
		rts	
; ===========================================================================

loc_1882C:
		addq.b	#2,obRoutine(a0)
		rts	
; ===========================================================================

Obj74_FallEdge:
		bclr	#1,obStatus(a0)
		addi.w	#$24,obVelY(a0)	; make flame fall
		move.w	obX(a0),d0
		sub.w	$32(a0),d0
		bpl.s	loc_1884A
		neg.w	d0

loc_1884A:
		cmpi.w	#$12,d0
		bne.s	loc_18856
		bclr	#7,obGfx(a0)

loc_18856:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_1887E
		subq.b	#1,$29(a0)
		beq.s	Obj74_Delete2
		clr.w	obVelY(a0)
		move.w	$32(a0),obX(a0)
		move.w	$38(a0),obY(a0)
		bset	#7,obGfx(a0)
		subq.b	#2,ob2ndRout(a0)

locret_1887E:
		rts	
; ===========================================================================

Obj74_Delete2:
		jmp	(DeleteObject).l
; ===========================================================================

loc_18886:	; Routine 4
		bset	#7,obGfx(a0)
		subq.b	#1,$29(a0)
		bne.s	Obj74_Animate
		move.b	#1,obAnim(a0)
		subq.w	#4,obY(a0)
		clr.b	obColType(a0)

Obj74_Animate:
		lea	(Ani_Fire).l,a1
		jmp	(AnimateSprite).l
; ===========================================================================

Obj74_Delete3:	; Routine 6
		jmp	(DeleteObject).l
