; ---------------------------------------------------------------------------
; Object 74 - lava that Eggman drops (MZ)
; ---------------------------------------------------------------------------

BossFire:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BossFire_Index(pc,d0.w),d0
	if FixBugs
		; DisplaySprite has been moved to avoid a display-after-free bug.
		jmp	BossFire_Index(pc,d0.w)
	else
		jsr	BossFire_Index(pc,d0.w)
		jmp	(DisplaySprite).l
	endif
; ===========================================================================
BossFire_Index:	offsetTable
		ptr BossFire_Main
		ptr BossFire_Action
		ptr BossFire_TempFire
		ptr BossFire_TempFireDel
; ===========================================================================

BossFire_Main:	; Routine 0
		move.b	#8,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#ArtTile_MZ_Fireball,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#5,obPriority(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#8,obActWid(a0)
		addq.b	#2,obRoutine(a0)
		tst.b	obSubtype(a0)
		bne.s	loc_1870A
		move.b	#$8B,obColType(a0)
		addq.b	#2,obRoutine(a0)
		bra.w	BossFire_TempFire
; ===========================================================================

loc_1870A:
		move.b	#$1E,objoff_29(a0)
		move.w	#sfx_Fireball,d0
		jsr	(QueueSound2).l	; play lava sound

BossFire_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BossFire_Index2(pc,d0.w),d0
		jsr	BossFire_Index2(pc,d0.w)
		jsr	(SpeedToPos).l
		lea	(Ani_Fire).l,a1
		jsr	(AnimateSprite).l
		cmpi.w	#boss_mz_y+$D8,obY(a0)
		bhi.s	BossFire_Delete
	if FixBugs
		; DisplaySprite has been moved to avoid a display-after-free bug.
		jmp	(DisplaySprite).l
	else
		rts
	endif
; ===========================================================================

BossFire_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
BossFire_Index2: offsetTable
		ptr BossFire_Drop
		ptr BossFire_MakeFlame
		ptr BossFire_Duplicate
		ptr BossFire_FallEdge
; ===========================================================================

BossFire_Drop:
		bset	#1,obStatus(a0)
		subq.b	#1,objoff_29(a0)
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

BossFire_MakeFlame:
		subq.w	#2,obY(a0)
		bset	#7,obGfx(a0)
		move.w	#$A0,obVelX(a0)
		clr.w	obVelY(a0)
		move.w	obX(a0),obBossX(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#3,objoff_29(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_187CA
		lea	(a1),a3
		lea	(a0),a2
		moveq	#3,d0

BossFire_Loop:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d0,BossFire_Loop

		neg.w	obVelX(a1)
		addq.b	#2,ob2ndRout(a1)

loc_187CA:
		addq.b	#2,ob2ndRout(a0)
		rts
; ===========================================================================

BossFire_Duplicate2:
		jsr	(FindNextFreeObj).l
		bne.s	locret_187EE
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#id_BossFire,obID(a1)
		move.w	#$67,obSubtype(a1)

locret_187EE:
		rts
; End of function BossFire_Duplicate2

; ===========================================================================

BossFire_Duplicate:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	loc_18826
		move.w	obX(a0),d0
		cmpi.w	#boss_mz_x+$140,d0
		bgt.s	loc_1882C
		move.w	obBossX(a0),d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		andi.w	#$10,d0
		andi.w	#$10,d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		bsr.s	BossFire_Duplicate2
		move.w	obX(a0),objoff_32(a0)

loc_1881E:
		move.w	obX(a0),obBossX(a0)
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

BossFire_FallEdge:
		bclr	#1,obStatus(a0)
		addi.w	#$24,obVelY(a0)	; make flame fall
		move.w	obX(a0),d0
		sub.w	objoff_32(a0),d0
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
		subq.b	#1,objoff_29(a0)
		beq.s	BossFire_Delete2
		clr.w	obVelY(a0)
		move.w	objoff_32(a0),obX(a0)
		move.w	obBossY(a0),obY(a0)
		bset	#7,obGfx(a0)
		subq.b	#2,ob2ndRout(a0)

locret_1887E:
		rts
; ===========================================================================

BossFire_Delete2:
	if FixBugs
		; Do not return to BossFire_Action, to avoid double-delete
		; and display-and-delete bugs.
		addq.l	#4,sp
	endif
		jmp	(DeleteObject).l
; ===========================================================================

; loc_18886:
BossFire_TempFire: ; Routine 4
		bset	#7,obGfx(a0)
		subq.b	#1,objoff_29(a0)
		bne.s	BossFire_Animate
		move.b	#1,obAnim(a0)
		subq.w	#4,obY(a0)
		clr.b	obColType(a0)

BossFire_Animate:
		lea	(Ani_Fire).l,a1
	if FixBugs
		; DisplaySprite has been moved to avoid a display-after-free bug.
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
	else
		jmp	(AnimateSprite).l
	endif
; ===========================================================================

; BossFire_Delete3:
BossFire_TempFireDel:	; Routine 6
		jmp	(DeleteObject).l
