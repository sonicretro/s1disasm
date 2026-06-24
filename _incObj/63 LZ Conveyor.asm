; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

LabyrinthConvey:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LCon_Index(pc,d0.w),d1
		jsr	LCon_Index(pc,d1.w)
		out_of_range.s	loc_1236A,objoff_30(a0)

LCon_Display:
		bra.w	DisplaySprite
; ===========================================================================

loc_1236A:
		cmpi.b	#act3,(v_act).w
		bne.s	loc_12378
		cmpi.w	#-$80,d0
		bhs.s	LCon_Display

loc_12378:
		move.b	objoff_2F(a0),d0
		bpl.w	DeleteObject
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bclr	#0,(a2,d0.w)
		bra.w	DeleteObject
; ===========================================================================
LCon_Index:	dc.w LCon_Main-LCon_Index
		dc.w LCon_Platform-LCon_Index
		dc.w LCon_OnPlatform-LCon_Index
		dc.w LCon_Wheel-LCon_Index
; ===========================================================================

LCon_Main:	; Routine 0
		move.b	obSubtype(a0),d0
		bmi.w	loc_12460
		addq.b	#2,obRoutine(a0)
		move.l	#Map_LConv,obMap(a0)
		move.w	#ArtTile_LZ_Conveyor_Belt|Tile_Pal3,obGfx(a0)
		ori.b	#sprite_cam_field,obRender(a0)
		move.b	#32/2,obActWid(a0)
		move.b	#4,obPriority(a0)
		cmpi.b	#$7F,obSubtype(a0)
		bne.s	loc_123E2
		addq.b	#4,obRoutine(a0)
		move.w	#ArtTile_LZ_Conveyor_Belt,obGfx(a0)
		move.b	#1,obPriority(a0)
		bra.w	LCon_Wheel
; ===========================================================================

loc_123E2:
		move.b	#4,obFrame(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	LCon_Data(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,objoff_38(a0)
		move.w	(a2)+,objoff_30(a0)
		move.l	a2,objoff_3C(a0)
		andi.w	#$F,d1
		lsl.w	#2,d1
		move.b	d1,objoff_38(a0)
		move.b	#4,objoff_3A(a0)
		tst.b	(f_conveyrev).w
		beq.s	loc_1244C
		move.b	#1,objoff_3B(a0)
		neg.b	objoff_3A(a0)
		moveq	#0,d1
		move.b	objoff_38(a0),d1
		add.b	objoff_3A(a0),d1
		cmp.b	objoff_39(a0),d1
		blo.s	loc_12448
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_12448
		move.b	objoff_39(a0),d1
		subq.b	#4,d1

loc_12448:
		move.b	d1,objoff_38(a0)

loc_1244C:
		move.w	(a2,d1.w),objoff_34(a0)
		move.w	2(a2,d1.w),objoff_36(a0)
		bsr.w	LCon_ChangeDir
		bra.w	LCon_Platform
; ===========================================================================

loc_12460:
		move.b	d0,objoff_2F(a0)
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bset	#0,(a2,d0.w)
	if FixBugs
		bne.s	.delete
	else
		bne.w	DeleteObject
	endif
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosLZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d1
		movea.l	a0,a1
		bra.s	LCon_MakePtfms

	if FixBugs
		; Avoid returning to LabyrinthConvey to prevent a
		; display-and-delete bug.
.delete:
		addq.l	#4,sp
		bra.w	DeleteObject
	endif
; ===========================================================================

LCon_Loop:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	loc_124AA

LCon_MakePtfms:
		_move.b	#id_LabyrinthConvey,obID(a1)
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,obY(a1)
		move.w	(a2)+,d0
		move.b	d0,obSubtype(a1)

loc_124AA:
		dbf	d1,LCon_Loop

		addq.l	#4,sp
		rts
; ===========================================================================

; loc_124B2:
LCon_Platform:	; Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.w	LCon_Platform_Update
; ===========================================================================

; loc_124C2:
LCon_OnPlatform: ; Routine 4
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
		move.w	obX(a0),-(sp)
		bsr.w	LCon_Platform_Update
		move.w	(sp)+,d2
		jmp	(MvSonicOnPtfm2).l
; ===========================================================================

; loc_124DE:
LCon_Wheel:	; Routine 6
		move.w	(v_framecount).w,d0
		andi.w	#3,d0
		bne.s	loc_124FC
		moveq	#1,d1
		tst.b	(f_conveyrev).w
		beq.s	loc_124F2
		neg.b	d1

loc_124F2:
		add.b	d1,obFrame(a0)
		andi.b	#3,obFrame(a0)

loc_124FC:
		addq.l	#4,sp
		bra.w	RememberState

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to get next corner coordinates and update platform position
; ---------------------------------------------------------------------------

; sub_12502:
LCon_Platform_Update:
		tst.b	(f_switch+$E).w				; has button $E been pressed?
		beq.s	.no_reverse				; if not, branch
		tst.b	objoff_3B(a0)				; is reverse flag already set?
		bne.s	.no_reverse				; if yes, branch
		move.b	#1,objoff_3B(a0)			; set local flag
		move.b	#1,(f_conveyrev).w			; set global flag
		neg.b	objoff_3A(a0)
		bra.s	.next_corner
; ===========================================================================

.no_reverse:
		move.w	obX(a0),d0
		cmp.w	objoff_34(a0),d0			; is platform at corner?
		bne.s	.not_at_corner				; if not, branch
		move.w	obY(a0),d0
		cmp.w	objoff_36(a0),d0
		bne.s	.not_at_corner

.next_corner:
		moveq	#0,d1
		move.b	objoff_38(a0),d1
		add.b	objoff_3A(a0),d1
		cmp.b	objoff_39(a0),d1			; is next corner valid?
		bcs.s	.is_valid				; if yes, branch
		move.b	d1,d0
		moveq	#0,d1					; reset corner counter to 0
		tst.b	d0
		bpl.s	.is_valid
		move.b	objoff_39(a0),d1
		subq.b	#4,d1

	.is_valid:
		move.b	d1,objoff_38(a0)
		movea.l	objoff_3C(a0),a1
		move.w	(a1,d1.w),objoff_34(a0)
		move.w	2(a1,d1.w),objoff_36(a0)
		bsr.w	LCon_ChangeDir

	.not_at_corner:
		bsr.w	SpeedToPos
		rts	
; End of function LCon_Platform_Update
; ===========================================================================

LCon_ChangeDir:
		moveq	#0,d0
		move.w	#-$100,d2
		move.w	obX(a0),d0
		sub.w	objoff_34(a0),d0
		bcc.s	loc_12584
		neg.w	d0
		neg.w	d2

loc_12584:
		moveq	#0,d1
		move.w	#-$100,d3
		move.w	obY(a0),d1
		sub.w	objoff_36(a0),d1
		bcc.s	loc_12598
		neg.w	d1
		neg.w	d3

loc_12598:
		cmp.w	d0,d1
		blo.s	loc_125C2
		move.w	obX(a0),d0
		sub.w	objoff_34(a0),d0
		beq.s	loc_125AE
		ext.l	d0
		asl.l	#8,d0
		divs.w	d1,d0
		neg.w	d0

loc_125AE:
		move.w	d0,obVelX(a0)
		move.w	d3,obVelY(a0)
		swap	d0
		move.w	d0,obX+2(a0)
		clr.w	obY+2(a0)
		rts
; ===========================================================================

loc_125C2:
		move.w	obY(a0),d1
		sub.w	objoff_36(a0),d1
		beq.s	loc_125D4
		ext.l	d1
		asl.l	#8,d1
		divs.w	d0,d1
		neg.w	d1

loc_125D4:
		move.w	d1,obVelY(a0)
		move.w	d2,obVelX(a0)
		swap	d1
		move.w	d1,obY+2(a0)
		clr.w	obX+2(a0)
		rts
; End of function LCon_ChangeDir

; ===========================================================================
; Conveyor belt corner target coordinate definitions.
; Each group corresponds to the lower nybble of the given subtype.
; Format:
; 	dc.w number of entries, times 4
; 	dc.w base X position (used for out_of_range check)
; 	dc.w entries...
; Entries consist of a target X position and target Y position.

LCon_Data:	dc.w .group0-LCon_Data
		dc.w .group1-LCon_Data
		dc.w .group2-LCon_Data
		dc.w .group3-LCon_Data
		dc.w .group4-LCon_Data
		dc.w .group5-LCon_Data

.group0:	
		.baseX_0: = $1070
		.baseY_0: = $2F0
		dc.w 6*4
		dc.w .baseX_0
		dc.w .baseX_0+$08, .baseY_0-$D6
		dc.w .baseX_0+$4E, .baseY_0-$90
		dc.w .baseX_0+$4E, .baseY_0+$A3
		dc.w .baseX_0+$1C, .baseY_0+$D5
		dc.w .baseX_0-$4E, .baseY_0+$A0
		dc.w .baseX_0-$4E, .baseY_0-$AC

.group1:
		.baseX_1: = $1280
		.baseY_1: = $377
		dc.w 5*4
		dc.w .baseX_1
		dc.w .baseX_1-$02, .baseY_1-$F7
		dc.w .baseX_1+$4E, .baseY_1-$A7
		dc.w .baseX_1+$4E, .baseY_1+$F7
		dc.w .baseX_1-$4E, .baseY_1+$A9
		dc.w .baseX_1-$4E, .baseY_1-$AB

.group2:
		.baseX_2: = $D68
		.baseY_2: = $530
		dc.w 4*4
		dc.w .baseX_2
		dc.w .baseX_2-$46, .baseY_2-$AE
		dc.w .baseX_2-$46, .baseY_2+$AE
		dc.w .baseX_2+$46, .baseY_2+$AE
		dc.w .baseX_2+$46, .baseY_2-$AE

.group3:
		.baseX_3: = $DA0
		.baseY_3: = $440
		dc.w 4*4
		dc.w .baseX_3
		dc.w .baseX_3-$3E, .baseY_3-$9E
		dc.w .baseX_3+$4E, .baseY_3-$9E
		dc.w .baseX_3+$4E, .baseY_3+$9E
		dc.w .baseX_3-$3E, .baseY_3+$9E

.group4:
		.baseX_4: = $D00
		.baseY_4: = $310
		dc.w 5*4
		dc.w .baseX_4
		dc.w .baseX_4-$54, .baseY_4-$CE
		dc.w .baseX_4+$DE, .baseY_4-$CE
		dc.w .baseX_4+$DE, .baseY_4+$CE
		dc.w .baseX_4-$AE, .baseY_4+$CE
		dc.w .baseX_4-$AE, .baseY_4-$74

.group5:
		.baseX_5: = $1300
		.baseY_5: = $264
		dc.w 4*4
		dc.w .baseX_5
		dc.w .baseX_5-$AE, .baseY_5-$5A
		dc.w .baseX_5+$DE, .baseY_5-$5A
		dc.w .baseX_5+$DE, .baseY_5+$5A
		dc.w .baseX_5-$AE, .baseY_5+$5A

		even
; ===========================================================================

Map_LConv:	include	"_maps/LZ Conveyor.asm"
