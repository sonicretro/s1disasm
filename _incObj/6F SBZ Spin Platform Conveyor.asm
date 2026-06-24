; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

SpinConvey:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SpinC_Index(pc,d0.w),d1
		jsr	SpinC_Index(pc,d1.w)
		out_of_range.s	SpinC_OutOfRange,objoff_30(a0)

SpinC_Display:
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1629A:
SpinC_OutOfRange:
		cmpi.b	#act3,(v_act).w	; check if act is 3
		bne.s	SpinC_Act1or2	; if not, branch
		cmpi.w	#-$80,d0
		bhs.s	SpinC_Display

SpinC_Act1or2:
		move.b	objoff_2F(a0),d0
		bpl.s	SpinC_Delete
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bclr	#0,(a2,d0.w)

SpinC_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
SpinC_Index:	dc.w SpinC_Main-SpinC_Index
		dc.w SpinC_Solid-SpinC_Index
; ===========================================================================

SpinC_Main:	; Routine 0
		move.b	obSubtype(a0),d0
		bmi.w	loc_16380
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Spin,obMap(a0)
		move.w	#ArtTile_SBZ_Spinning_Platform,obGfx(a0)
		move.b	#32/2,obActWid(a0)
		ori.b	#sprite_cam_field,obRender(a0)
		move.b	#4,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	SpinC_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,objoff_38(a0)
		move.w	(a2)+,objoff_30(a0)
		move.l	a2,objoff_3C(a0)
		andi.w	#$F,d1
		lsl.w	#2,d1
		move.b	d1,objoff_38(a0)
		move.b	#4,objoff_3A(a0)
		tst.b	(f_conveyrev).w
		beq.s	loc_16356
		move.b	#1,objoff_3B(a0)
		neg.b	objoff_3A(a0)
		moveq	#0,d1
		move.b	objoff_38(a0),d1
		add.b	objoff_3A(a0),d1
		cmp.b	objoff_39(a0),d1
		blo.s	loc_16352
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16352
		move.b	objoff_39(a0),d1
		subq.b	#4,d1

loc_16352:
		move.b	d1,objoff_38(a0)

loc_16356:
		move.w	(a2,d1.w),objoff_34(a0)
		move.w	2(a2,d1.w),objoff_36(a0)
		tst.w	d1
		bne.s	loc_1636C
		move.b	#1,obAnim(a0)

loc_1636C:
		cmpi.w	#8,d1
		bne.s	loc_16378
		move.b	#0,obAnim(a0)

loc_16378:
		bsr.w	LCon_ChangeDir
		bra.w	SpinC_Solid
; ===========================================================================

loc_16380:
		move.b	d0,objoff_2F(a0)
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bset	#0,(a2,d0.w)
		beq.s	loc_1639A
	if FixBugs
		; Avoid returning to SpinConvey to prevent display-and-delete
		; and double-delete bugs.
		addq.l	#4,sp
	endif
		jmp	(DeleteObject).l
; ===========================================================================

loc_1639A:
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosSBZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d1
		movea.l	a0,a1
		bra.s	SpinC_LoadPform
; ===========================================================================

SpinC_Loop:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		jsr	(FindNextFreeObj).l
	else
		jsr	(FindFreeObj).l
	endif
		bne.s	SpinC_LoadNext

SpinC_LoadPform:
		_move.b	#id_SpinConvey,obID(a1)
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,obY(a1)
		move.w	(a2)+,d0
		move.b	d0,obSubtype(a1)
	if FixBugs
		; Initialize platforms on the upper path to not spinning state as soon
		; as they are loaded, rather than always starting out spinning.
		andi.b	#3,d0		; subtype 0-2 is for not spinning state
		cmpi.b	#3,d0		; is this a lower path platform?
		beq.s	SpinC_LoadNext	; if yes, branch (keep spinning)
		move.b	#1,obAnim(a1)	; set to not spinning
	endif

; loc_163D0:
SpinC_LoadNext:
		dbf	d1,SpinC_Loop

		addq.l	#4,sp
		rts
; ===========================================================================

; loc_163D8:
SpinC_Solid:	; Routine 2
		lea	(Ani_SpinConvey).l,a1
		jsr	(AnimateSprite).l
		tst.b	obFrame(a0)
		bne.s	loc_16404
		move.w	obX(a0),-(sp)
		bsr.w	loc_16424
		move.w	#32/2+sonic_solid_width,d1
		move.w	#14/2,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	(sp)+,d4
		bra.w	SolidObject
; ===========================================================================

loc_16404:
		btst	#3,obStatus(a0)
		beq.s	loc_16420
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)

loc_16420:
		bra.w	loc_16424

loc_16424:
		move.w	obX(a0),d0
		cmp.w	objoff_34(a0),d0
		bne.s	loc_16484
		move.w	obY(a0),d0
		cmp.w	objoff_36(a0),d0
		bne.s	loc_16484
		moveq	#0,d1
		move.b	objoff_38(a0),d1
		add.b	objoff_3A(a0),d1
		cmp.b	objoff_39(a0),d1
		blo.s	loc_16456
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16456
		move.b	objoff_39(a0),d1
		subq.b	#4,d1

loc_16456:
		move.b	d1,objoff_38(a0)
		movea.l	objoff_3C(a0),a1
		move.w	(a1,d1.w),objoff_34(a0)
		move.w	2(a1,d1.w),objoff_36(a0)
		tst.w	d1
		bne.s	loc_16474
		move.b	#1,obAnim(a0)

loc_16474:
		cmpi.w	#8,d1
		bne.s	loc_16480
		move.b	#0,obAnim(a0)

loc_16480:
		bsr.w	LCon_ChangeDir

loc_16484:
		jmp	(SpeedToPos).l

; ===========================================================================
; We need to include animations from here to keep the corner data in this file...
		include	"_anim/SBZ Spin Platform Conveyor.asm"

; ===========================================================================
; Conveyor belt corner target coordinate definitions.
; Each group corresponds to the lower nybble of the given subtype.
; Format:
; 	dc.w number of entries, times 4
; 	dc.w base X position (used for out_of_range check)
; 	dc.w entries...
; Entries consist of a target X position and target Y position.

SpinC_Data:	dc.w .group0-SpinC_Data
		dc.w .group1-SpinC_Data
		dc.w .group2-SpinC_Data
		dc.w .group3-SpinC_Data
		dc.w .group4-SpinC_Data
		dc.w .group5-SpinC_Data

.group0:
		.baseX_0: = $E80
		.baseY_0: = $358
		dc.w 4*4
		dc.w .baseX_0
		dc.w .baseX_0-$6C, .baseY_0+$18
		dc.w .baseX_0+$6F, .baseY_0-$56
		dc.w .baseX_0+$6F, .baseY_0-$18
		dc.w .baseX_0-$6C, .baseY_0+$56

.group1:
		.baseX_1: = $F80
		.baseY_1: = $2C8
		dc.w 4*4
		dc.w .baseX_1
		dc.w .baseX_1-$6C, .baseY_1+$18
		dc.w .baseX_1+$6F, .baseY_1-$56
		dc.w .baseX_1+$6F, .baseY_1-$18
		dc.w .baseX_1-$6C, .baseY_1+$56

.group2:
		.baseX_2: = $1080
		.baseY_2: = $228
		dc.w 4*4
		dc.w .baseX_2
		dc.w .baseX_2-$6C, .baseY_2+$48
		dc.w .baseX_2+$6F, .baseY_2-$26
		dc.w .baseX_2+$6F, .baseY_2+$18
		dc.w .baseX_2-$6C, .baseY_2+$86

.group3:
		.baseX_3: = $F80
		.baseY_3: = $558
		dc.w 4*4
		dc.w .baseX_3
		dc.w .baseX_3-$6C, .baseY_3+$18
		dc.w .baseX_3+$6F, .baseY_3-$56
		dc.w .baseX_3+$6F, .baseY_3-$18
		dc.w .baseX_3-$6C, .baseY_3+$56

.group4:
		.baseX_4: = $1B80
		.baseY_4: = $658
		dc.w 4*4
		dc.w .baseX_4
		dc.w .baseX_4-$6C, .baseY_4+$18
		dc.w .baseX_4+$6F, .baseY_4-$56
		dc.w .baseX_4+$6F, .baseY_4-$18
		dc.w .baseX_4-$6C, .baseY_4+$56

.group5:
		.baseX_5: = $1C80
		.baseY_5: = $5C8
		dc.w 4*4
		dc.w .baseX_5
		dc.w .baseX_5-$6C, .baseY_5+$18
		dc.w .baseX_5+$6F, .baseY_5-$56
		dc.w .baseX_5+$6F, .baseY_5-$18
		dc.w .baseX_5-$6C, .baseY_5+$56

		even