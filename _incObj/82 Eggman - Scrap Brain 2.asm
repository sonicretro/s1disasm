; ---------------------------------------------------------------------------
; Object 82 - Eggman (SBZ2)
; ---------------------------------------------------------------------------

ScrapEggman:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SEgg_Index(pc,d0.w),d1
		jmp	SEgg_Index(pc,d1.w)
; ===========================================================================
SEgg_Index:	dc.w SEgg_Main-SEgg_Index
		dc.w SEgg_Eggman-SEgg_Index
		dc.w SEgg_Switch-SEgg_Index

SEgg_ObjData:	dc.b 2,	0, 3		; routine number, animation, priority
		dc.b 4,	0, 3
; ===========================================================================

SEgg_Main:	; Routine 0
		lea	SEgg_ObjData(pc),a2
		move.w	#boss_sbz2_x+$110,obX(a0)
		move.w	#boss_sbz2_y+$94,obY(a0)
		move.b	#$F,obColType(a0)
		move.b	#$10,obColProp(a0)
		bclr	#0,obStatus(a0)
		clr.b	ob2ndRout(a0)
		move.b	(a2)+,obRoutine(a0)
		move.b	(a2)+,obAnim(a0)
		move.b	(a2)+,obPriority(a0)
		move.l	#Map_SEgg,obMap(a0)
		move.w	#make_art_tile(ArtTile_Eggman,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		bset	#7,obRender(a0)
		move.b	#$20,obActWid(a0)
		jsr	(FindNextFreeObj).l
		bne.s	SEgg_Eggman
		move.l	a0,objoff_34(a1)
		move.b	#id_ScrapEggman,(a1) ; load switch object
		move.w	#boss_sbz2_x+$E0,obX(a1)
		move.w	#boss_sbz2_y+$AC,obY(a1)
		clr.b	ob2ndRout(a0)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,obAnim(a1)
		move.b	(a2)+,obPriority(a1)
		move.l	#Map_But,obMap(a1)
		move.w	#make_art_tile(ArtTile_Eggman_Button,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		bset	#7,obRender(a1)
		move.b	#$10,obActWid(a1)
		move.b	#0,obFrame(a1)

SEgg_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	SEgg_EggIndex(pc,d0.w),d1
		jsr	SEgg_EggIndex(pc,d1.w)
		lea	Ani_SEgg(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
SEgg_EggIndex:	dc.w SEgg_ChkSonic-SEgg_EggIndex
		dc.w SEgg_PreLeap-SEgg_EggIndex
		dc.w SEgg_Leap-SEgg_EggIndex
		dc.w loc_19934-SEgg_EggIndex
; ===========================================================================

SEgg_ChkSonic:
		move.w	obX(a0),d0
		sub.w	(v_player+obX).w,d0
		cmpi.w	#128,d0		; is Sonic within 128 pixels of	Eggman?
		bhs.s	loc_19934	; if not, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#180,objoff_3C(a0)	; set delay to 3 seconds
		move.b	#1,obAnim(a0)

loc_19934:
		jmp	(SpeedToPos).l
; ===========================================================================

SEgg_PreLeap:
		subq.w	#1,objoff_3C(a0)	; subtract 1 from time delay
		bne.s	loc_19954	; if time remains, branch
		addq.b	#2,ob2ndRout(a0)
		move.b	#2,obAnim(a0)
		addq.w	#4,obY(a0)
		move.w	#15,objoff_3C(a0)

loc_19954:
		bra.s	loc_19934
; ===========================================================================

SEgg_Leap:
		subq.w	#1,objoff_3C(a0)
		bgt.s	loc_199D0
		bne.s	loc_1996A
		move.w	#-$FC,obVelX(a0) ; make Eggman leap
		move.w	#-$3C0,obVelY(a0)

loc_1996A:
		cmpi.w	#boss_sbz2_x+$E2,obX(a0)
		bgt.s	loc_19976
		clr.w	obVelX(a0)

loc_19976:
		addi.w	#$24,obVelY(a0)
		tst.w	obVelY(a0)
		bmi.s	SEgg_FindBlocks
		cmpi.w	#boss_sbz2_y+$85,obY(a0)
		blo.s	SEgg_FindBlocks
		move.w	#"SW",obSubtype(a0)
		cmpi.w	#boss_sbz2_y+$8B,obY(a0)
		blo.s	SEgg_FindBlocks
		move.w	#boss_sbz2_y+$8B,obY(a0)
		clr.w	obVelY(a0)

SEgg_FindBlocks:
		move.w	obVelX(a0),d0
		or.w	obVelY(a0),d0
		bne.s	loc_199D0
		lea	(v_objspace).w,a1 ; start at the first object RAM
		moveq	#$3E,d0
		moveq	#$40,d1

SEgg_FindLoop:	
		adda.w	d1,a1		; jump to next object RAM
		cmpi.b	#id_FalseFloor,(a1) ; is object a block? (object $83)
		dbeq	d0,SEgg_FindLoop ; if not, repeat (max	$3E times)

		bne.s	loc_199D0
		move.w	#"GO",obSubtype(a1) ; set block to disintegrate
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)

loc_199D0:
		bra.w	loc_19934
; ===========================================================================

SEgg_Switch:	; Routine 4
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	SEgg_SwIndex(pc,d0.w),d0
		jmp	SEgg_SwIndex(pc,d0.w)
; ===========================================================================
SEgg_SwIndex:	dc.w loc_199E6-SEgg_SwIndex
		dc.w SEgg_SwDisplay-SEgg_SwIndex
; ===========================================================================

loc_199E6:
		movea.l	objoff_34(a0),a1
		cmpi.w	#"SW",obSubtype(a1)
		bne.s	SEgg_SwDisplay
		move.b	#1,obFrame(a0)
		addq.b	#2,ob2ndRout(a0)

SEgg_SwDisplay:
		jmp	(DisplaySprite).l
