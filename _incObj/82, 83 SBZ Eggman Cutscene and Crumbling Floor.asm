; ---------------------------------------------------------------------------
; Object 82 - Eggman (SBZ2)
; ---------------------------------------------------------------------------

; loc_1982C:
FalseFloor_Delete:
		; This is part of Object 82, but it is only ever called
		; from Object 83 (the collapsing floor)
		jmp	(DeleteObject).l
; ===========================================================================

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
		move.b	#col_48x48|col_boss,obColType(a0)
		move.b	#16,obBossHits(a0) ; SBZ2 Eggman is set to 16 hits, despite being unhittable
		bclr	#0,obStatus(a0)
		clr.b	ob2ndRout(a0)
		move.b	(a2)+,obRoutine(a0)
		move.b	(a2)+,obAnim(a0)
		move.b	(a2)+,obPriority(a0)
		move.l	#Map_SEgg,obMap(a0)
		move.w	#ArtTile_Eggman,obGfx(a0)
		move.b	#sprite_cam_field,obRender(a0)
		bset	#sprite_rendered_bit,obRender(a0)
		move.b	#64/2,obActWid(a0)
		jsr	(FindNextFreeObj).l
		bne.s	SEgg_Eggman
		move.l	a0,objoff_34(a1)
		move.b	#id_ScrapEggman,obID(a1) ; load switch object
		move.w	#boss_sbz2_x+$E0,obX(a1)
		move.w	#boss_sbz2_y+$AC,obY(a1)
		clr.b	ob2ndRout(a0)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,obAnim(a1)
		move.b	(a2)+,obPriority(a1)
		move.l	#Map_But,obMap(a1)
		move.w	#ArtTile_Eggman_Button,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)
		bset	#sprite_rendered_bit,obRender(a1)
		move.b	#32/2,obActWid(a1)
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
		dc.w SEgg_Move-SEgg_EggIndex
; ===========================================================================

SEgg_ChkSonic:
		move.w	obX(a0),d0
		sub.w	(v_player+obX).w,d0
		cmpi.w	#128,d0		; is Sonic within 128 pixels of Eggman?
		bhs.s	SEgg_Move	; if not, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#180,objoff_3C(a0)	; set delay to 3 seconds
		move.b	#1,obAnim(a0)

; loc_19934:
SEgg_Move:
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
		bra.s	SEgg_Move
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

	if FixBugs
		lea	(v_lvlobjspace-object_size).w,a1
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0
	else
		lea	(v_objspace).w,a1 ; Nonsensical starting point, since dynamic object allocations begin at v_lvlobjspace.
		moveq	#(v_objspace_end-(v_objspace+object_size*1))/object_size/2-1,d0	; Nonsensical length, it only covers the first half of object RAM.
	endif
		moveq	#object_size,d1

SEgg_FindLoop:
		adda.w	d1,a1		; jump to next object RAM
		cmpi.b	#id_FalseFloor,obID(a1) ; is object a block? (object $83)
		dbeq	d0,SEgg_FindLoop ; if not, repeat (max $3E times)

		bne.s	loc_199D0
		move.w	#"GO",obSubtype(a1) ; set block to disintegrate
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)

loc_199D0:
		bra.w	SEgg_Move
; ===========================================================================

SEgg_Switch:	; Routine 4
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	SEgg_SwIndex(pc,d0.w),d0
		jmp	SEgg_SwIndex(pc,d0.w)
; ===========================================================================
SEgg_SwIndex:	dc.w SEgg_SwChk-SEgg_SwIndex
		dc.w SEgg_SwDisplay-SEgg_SwIndex
; ===========================================================================

; loc_199E6:
SEgg_SwChk:
		movea.l	objoff_34(a0),a1
		cmpi.w	#"SW",obSubtype(a1)
		bne.s	SEgg_SwDisplay
		move.b	#1,obFrame(a0)
		addq.b	#2,ob2ndRout(a0)

SEgg_SwDisplay:
		jmp	(DisplaySprite).l
; ===========================================================================


		include	"_anim/Eggman - Scrap Brain 2 & Final.asm"
Map_SEgg:	include	"_maps/Eggman - Scrap Brain 2.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate Eggman presses a switch (SBZ2)
; ---------------------------------------------------------------------------

FalseFloor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FFloor_Index(pc,d0.w),d1
		jmp	FFloor_Index(pc,d1.w)
; ===========================================================================
FFloor_Index:	dc.w FFloor_Main-FFloor_Index
		dc.w FFloor_ChkBreak-FFloor_Index
		dc.w FFloor_Break-FFloor_Index
		dc.w FFloor_AllGone-FFloor_Index
		dc.w FFloor_Block-FFloor_Index
		dc.w FFloor_Frag-FFloor_Index
; ===========================================================================

FFloor_Main:	; Routine 0
		move.w	#boss_sbz2_x+$30,obX(a0)
		move.w	#boss_sbz2_y+$C0,obY(a0)
		move.b	#256/2,obActWid(a0)
		move.b	#32/2,obHeight(a0)
		move.b	#sprite_cam_field,obRender(a0)
		bset	#sprite_rendered_bit,obRender(a0)
		moveq	#0,d4
		move.w	#boss_sbz2_x-$40,d5
		moveq	#7,d6
		lea	objoff_30(a0),a2

FFloor_MakeBlock:
		jsr	(FindFreeObj).l
		bne.s	FFloor_ExitMake
		move.w	a1,(a2)+
		move.b	#id_FalseFloor,obID(a1) ; load block object
		move.l	#Map_FFloor,obMap(a1)
		move.w	#ArtTile_Eggman_Trap_Floor|Tile_Pal3,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)
		move.b	#32/2,obActWid(a1)
		move.b	#32/2,obHeight(a1)
		move.b	#3,obPriority(a1)
		move.w	d5,obX(a1)	; set X position
		move.w	#boss_sbz2_y+$C0,obY(a1)
		addi.w	#$20,d5		; add $20 for next X position
		move.b	#8,obRoutine(a1)
		dbf	d6,FFloor_MakeBlock ; repeat sequence 7 more times

FFloor_ExitMake:
		addq.b	#2,obRoutine(a0)
		rts
; ===========================================================================

FFloor_ChkBreak:; Routine 2
		cmpi.w	#"GO",obSubtype(a0) ; is object set to disintegrate?
		bne.s	FFloor_Solid	; if not, branch
		clr.b	obFrame(a0)
		addq.b	#2,obRoutine(a0) ; next subroutine

FFloor_Solid:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		neg.b	d0
		ext.w	d0
		addq.w	#8,d0
		asl.w	#4,d0
		move.w	#boss_sbz2_x+$B0,d4
		sub.w	d0,d4
		move.b	d0,obActWid(a0)
		move.w	d4,obX(a0)
		moveq	#sonic_solid_width,d1
		add.w	d0,d1
		moveq	#$10,d2
		moveq	#$11,d3
		jmp	(SolidObject).l
; ===========================================================================

; loc_19C36:
FFloor_Break:	; Routine 4
		subi.b	#$E,obTimeFrame(a0)
		bcc.s	FFloor_Solid2
		moveq	#-1,d0
		move.b	obFrame(a0),d0
		ext.w	d0
		add.w	d0,d0
		move.w	objoff_30(a0,d0.w),d0
		movea.l	d0,a1
		move.w	#"GO",obSubtype(a1)
		addq.b	#1,obFrame(a0)
		cmpi.b	#8,obFrame(a0)
		beq.s	FFloor_AllGone

FFloor_Solid2:
		bra.s	FFloor_Solid
; ===========================================================================

; loc_19C62:
FFloor_AllGone:	; Routine 6
		bclr	#3,obStatus(a0)
		bclr	#3,(v_player+obStatus).w
		bra.w	FalseFloor_Delete
; ===========================================================================

; loc_19C72:
FFloor_Block:	; Routine 8
		cmpi.w	#"GO",obSubtype(a0)	; is object set to disintegrate?
		beq.s	FFloor_BlockBreak	; if yes, branch
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_19C80:
FFloor_Frag:	; Routine $A
		tst.b	obRender(a0)
		bpl.w	FalseFloor_Delete
		jsr	(ObjectFall).l
		jmp	(DisplaySprite).l
; ===========================================================================

FFloor_BlockBreak:
		lea	FFloor_FragSpeed(pc),a4
		lea	FFloor_FragPos(pc),a5
		moveq	#1,d4
		moveq	#3,d1
		moveq	#gravity,d2	; unused leftover from SmashObject
		addq.b	#2,obRoutine(a0)
		move.b	#16/2,obActWid(a0)
		move.b	#16/2,obHeight(a0)
		lea	(a0),a1
		bra.s	FFloor_MakeFrag
; ===========================================================================

FFloor_LoopFrag:
		jsr	(FindNextFreeObj).l
		bne.s	FFloor_BreakSnd

FFloor_MakeFrag:
		lea	(a0),a2
		lea	(a1),a3
		moveq	#3,d3

loc_19CC4:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d3,loc_19CC4

		move.w	(a4)+,obVelY(a1)
		move.w	(a5)+,d3
		add.w	d3,obX(a1)
		move.w	(a5)+,d3
		add.w	d3,obY(a1)
		move.b	d4,obFrame(a1)
		addq.w	#1,d4
		dbf	d1,FFloor_LoopFrag ; repeat sequence 3 more times

FFloor_BreakSnd:
		move.w	#sfx_WallSmash,d0
		jsr	(QueueSound2).l	; play smashing sound
		jmp	(DisplaySprite).l

; ===========================================================================
FFloor_FragSpeed:dc.w $80, 0
		dc.w $120, $C0
FFloor_FragPos:	dc.w -8, -8
		dc.w $10, 0
		dc.w 0,	$10
		dc.w $10, $10
; ===========================================================================

Map_FFloor:	include	"_maps/SBZ Eggman's Crumbling Floor.asm"
