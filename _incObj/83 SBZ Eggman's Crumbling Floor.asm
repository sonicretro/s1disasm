; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate Eggman	presses	a switch (SBZ2)
; ---------------------------------------------------------------------------

FalseFloor:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FFloor_Index(pc,d0.w),d1
		jmp	FFloor_Index(pc,d1.w)
; ===========================================================================
FFloor_Index:	dc.w FFloor_Main-FFloor_Index
		dc.w FFloor_ChkBreak-FFloor_Index
		dc.w loc_19C36-FFloor_Index
		dc.w loc_19C62-FFloor_Index
		dc.w loc_19C72-FFloor_Index
		dc.w loc_19C80-FFloor_Index
; ===========================================================================

FFloor_Main:	; Routine 0
		move.w	#$2080,obX(a0)
		move.w	#$5D0,obY(a0)
		move.b	#$80,obActWid(a0)
		move.b	#$10,obHeight(a0)
		move.b	#4,obRender(a0)
		bset	#7,obRender(a0)
		moveq	#0,d4
		move.w	#$2010,d5
		moveq	#7,d6
		lea	$30(a0),a2

FFloor_MakeBlock:
		jsr	FindFreeObj
		bne.s	FFloor_ExitMake
		move.w	a1,(a2)+
		move.b	#id_FalseFloor,(a1) ; load block object
		move.l	#Map_FFloor,obMap(a1)
		move.w	#$4518,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$10,obActWid(a1)
		move.b	#$10,obHeight(a1)
		move.b	#3,obPriority(a1)
		move.w	d5,obX(a1)	; set X	position
		move.w	#$5D0,obY(a1)
		addi.w	#$20,d5		; add $20 for next X position
		move.b	#8,obRoutine(a1)
		dbf	d6,FFloor_MakeBlock ; repeat sequence 7 more times

FFloor_ExitMake:
		addq.b	#2,obRoutine(a0)
		rts	
; ===========================================================================

FFloor_ChkBreak:; Routine 2
		cmpi.w	#$474F,obSubtype(a0) ; is object set to disintegrate?
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
		move.w	#$2100,d4
		sub.w	d0,d4
		move.b	d0,obActWid(a0)
		move.w	d4,obX(a0)
		moveq	#$B,d1
		add.w	d0,d1
		moveq	#$10,d2
		moveq	#$11,d3
		jmp	SolidObject
; ===========================================================================

loc_19C36:	; Routine 4
		subi.b	#$E,obTimeFrame(a0)
		bcc.s	FFloor_Solid2
		moveq	#-1,d0
		move.b	obFrame(a0),d0
		ext.w	d0
		add.w	d0,d0
		move.w	$30(a0,d0.w),d0
		movea.l	d0,a1
		move.w	#$474F,obSubtype(a1)
		addq.b	#1,obFrame(a0)
		cmpi.b	#8,obFrame(a0)
		beq.s	loc_19C62

FFloor_Solid2:
		bra.s	FFloor_Solid
; ===========================================================================

loc_19C62:	; Routine 6
		bclr	#3,obStatus(a0)
		bclr	#3,(v_player+obStatus).w
		bra.w	loc_1982C
; ===========================================================================

loc_19C72:	; Routine 8
		cmpi.w	#$474F,obSubtype(a0) ; is object set to disintegrate?
		beq.s	FFloor_Break	; if yes, branch
		jmp	DisplaySprite
; ===========================================================================

loc_19C80:	; Routine $A
		tst.b	obRender(a0)
		bpl.w	loc_1982C
		jsr	ObjectFall
		jmp	DisplaySprite
; ===========================================================================

FFloor_Break:				; XREF: loc_19C72
		lea	FFloor_FragSpeed(pc),a4
		lea	FFloor_FragPos(pc),a5
		moveq	#1,d4
		moveq	#3,d1
		moveq	#$38,d2
		addq.b	#2,obRoutine(a0)
		move.b	#8,obActWid(a0)
		move.b	#8,obHeight(a0)
		lea	(a0),a1
		bra.s	FFloor_MakeFrag
; ===========================================================================

FFloor_LoopFrag:
		jsr	FindNextFreeObj
		bne.s	FFloor_BreakSnd

FFloor_MakeFrag:				; XREF: FFloor_Break
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
		sfx	sfx_WallSmash	; play smashing sound
		jmp	DisplaySprite
; ===========================================================================
FFloor_FragSpeed:dc.w $80, 0
		dc.w $120, $C0
FFloor_FragPos:	dc.w -8, -8
		dc.w $10, 0
		dc.w 0,	$10
		dc.w $10, $10
