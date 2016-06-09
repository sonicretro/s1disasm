; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;	    - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

SwingingPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:	dc.w Swing_Main-Swing_Index, Swing_SetSolid-Swing_Index
		dc.w Swing_Action2-Swing_Index,	Swing_Delete-Swing_Index
		dc.w Swing_Delete-Swing_Index, Swing_Display-Swing_Index
		dc.w Swing_Action-Swing_Index

swing_origX = $3A		; original x-axis position
swing_origY = $38		; original y-axis position
; ===========================================================================

Swing_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Swing_GHZ,obMap(a0) ; GHZ and MZ specific code
		move.w	#$4380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#8,obHeight(a0)
		move.w	obY(a0),swing_origY(a0)
		move.w	obX(a0),swing_origX(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ

		move.l	#Map_Swing_SLZ,obMap(a0) ; SLZ specific code
		move.w	#$43DC,obGfx(a0)
		move.b	#$20,obActWid(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$99,obColType(a0)

.notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	.length

		move.l	#Map_BBall,obMap(a0) ; SBZ specific code
		move.w	#$391,obGfx(a0)
		move.b	#$18,obActWid(a0)
		move.b	#$18,obHeight(a0)
		move.b	#$86,obColType(a0)
		move.b	#$C,obRoutine(a0) ; goto Swing_Action next

.length:
		_move.b	0(a0),d4
		moveq	#0,d1
		lea	obSubtype(a0),a2 ; move chain length to a2
		move.b	(a2),d1		; move a2 to d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,$3C(a0)
		subq.b	#8,d3
		tst.b	obFrame(a0)
		beq.s	.makechain
		addq.b	#8,d3
		subq.w	#1,d1

.makechain:
		bsr.w	FindFreeObj
		bne.s	.fail
		addq.b	#1,obSubtype(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1) ; goto Swing_Display next
		_move.b	d4,0(a1)	; load swinging	object
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		bclr	#6,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#4,obPriority(a1)
		move.b	#8,obActWid(a1)
		move.b	#1,obFrame(a1)
		move.b	d3,$3C(a1)
		subi.b	#$10,d3
		bcc.s	.notanchor
		move.b	#2,obFrame(a1)
		move.b	#3,obPriority(a1)
		bset	#6,obGfx(a1)

.notanchor:
		dbf	d1,.makechain ; repeat d1 times (chain length)

.fail:
		move.w	a0,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,obAngle(a0)
		move.w	#-$200,$3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1		; is object type $1X ?
		beq.s	.not1X	; if not, branch
		move.l	#Map_GBall,obMap(a0) ; use GHZ ball mappings
		move.w	#$43AA,obGfx(a0)
		move.b	#1,obFrame(a0)
		move.b	#2,obPriority(a0)
		move.b	#$81,obColType(a0) ; make object hurt when touched

.not1X:
		cmpi.b	#id_SBZ,(v_zone).w ; is zone SBZ?
		beq.s	Swing_Action	; if yes, branch

Swing_SetSolid:	; Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		bsr.w	Swing_Solid

Swing_Action:	; Routine $C
		bsr.w	Swing_Move
		bsr.w	DisplaySprite
		bra.w	Swing_ChkDel
; ===========================================================================

Swing_Action2:	; Routine 4
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	ExitPlatform
		move.w	obX(a0),-(sp)
		bsr.w	Swing_Move
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		bsr.w	MvSonicOnPtfm
		bsr.w	DisplaySprite
		bra.w	Swing_ChkDel

		rts
