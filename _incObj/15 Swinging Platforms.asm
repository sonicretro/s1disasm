; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;           - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

SwingingPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:	dc.w Swing_Main-Swing_Index
		dc.w Swing_SetSolid-Swing_Index
		dc.w Swing_Action2-Swing_Index
		dc.w Swing_Delete-Swing_Index
		dc.w Swing_Delete-Swing_Index
		dc.w Swing_Display-Swing_Index
		dc.w Swing_Action-Swing_Index

swing_origX = objoff_3A		; original x-axis position
swing_origY = objoff_38		; original y-axis position
; ===========================================================================

Swing_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Swing_GHZ,obMap(a0) ; GHZ and MZ specific code
		move.w	#ArtTile_GHZ_MZ_Swing|Tile_Pal3,obGfx(a0)
		move.b	#sprite_cam_field,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#48/2,obActWid(a0)
		move.b	#16/2,obHeight(a0)
		move.w	obY(a0),swing_origY(a0)
		move.w	obX(a0),swing_origX(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ

		move.l	#Map_Swing_SLZ,obMap(a0) ; SLZ specific code
		move.w	#ArtTile_SLZ_Swing|Tile_Pal3,obGfx(a0)
		move.b	#64/2,obActWid(a0)
		move.b	#32/2,obHeight(a0)
		move.b	#col_64x16|col_hurt,obColType(a0)

.notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	.length

		move.l	#Map_BBall,obMap(a0) ; SBZ specific code
		move.w	#ArtTile_SBZ_Swing,obGfx(a0)
		move.b	#48/2,obActWid(a0)
		move.b	#48/2,obHeight(a0)
		move.b	#col_32x32|col_hurt,obColType(a0)
		move.b	#$C,obRoutine(a0) ; goto Swing_Action next

.length:
		_move.b	obID(a0),d4
		moveq	#0,d1
		lea	obSubtype(a0),a2 ; move chain length to a2
		move.b	(a2),d1		; move a2 to d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,objoff_3C(a0)
		subq.b	#8,d3
		tst.b	obFrame(a0)
		beq.s	.makechain
		addq.b	#8,d3
		subq.w	#1,d1

.makechain:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	.fail
		addq.b	#1,obSubtype(a0)
		move.w	a1,d5
		subi.w	#v_objspace&$FFFF,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1) ; goto Swing_Display next
		_move.b	d4,obID(a1)	; load swinging object
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		bclr	#6,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)
		move.b	#4,obPriority(a1)
		move.b	#16/2,obActWid(a1)
		move.b	#1,obFrame(a1)
		move.b	d3,objoff_3C(a1)
		subi.b	#$10,d3
		bcc.s	.notanchor
		move.b	#2,obFrame(a1)
		move.b	#3,obPriority(a1)
		bset	#6,obGfx(a1)

.notanchor:
		dbf	d1,.makechain ; repeat d1 times (chain length)

.fail:
		move.w	a0,d5
		subi.w	#v_objspace&$FFFF,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,obAngle(a0)
		move.w	#-$200,objoff_3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1		; is object type $1X ?
		beq.s	.not1X	; if not, branch
		move.l	#Map_GBall,obMap(a0) ; use GHZ ball mappings
		move.w	#ArtTile_GHZ_Giant_Ball|Tile_Pal3,obGfx(a0)
		move.b	#1,obFrame(a0)
		move.b	#2,obPriority(a0)
		move.b	#col_40x40|col_hurt,obColType(a0) ; make object hurt when touched

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
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite
	endif
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
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite
	endif
		bra.w	Swing_ChkDel

		rts	; redundant rts
; ===========================================================================

		; shared by other platform objects
		include "_incObj/sub MvSonicOnPtfm.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update swinging angle and positions for chain links and platform
; ---------------------------------------------------------------------------

Swing_Move:
		move.b	(v_oscillate+$1A).w,d0
		move.w	#$80,d1
		btst	#0,obStatus(a0)
		beq.s	loc_7B78
		neg.w	d0
		add.w	d1,d0

loc_7B78:
		bra.s	Swing_Move2

; ---------------------------------------------------------------------------

; Obj48_Move:
GBall_Move:	; called from wrecking ball for GHZ boss
		tst.b	objoff_3D(a0)			; is ball on the left side of the screen?
		bne.s	.left_side			; if yes, branch
		move.w	objoff_3E(a0),d0
		addq.w	#8,d0
		move.w	d0,objoff_3E(a0)		; increase swing speed
		add.w	d0,obAngle(a0)			; update angle
		cmpi.w	#$200,d0			; is speed at max?
		bne.s	.not_at_highest			; if not, branch
		move.b	#1,objoff_3D(a0)		; switch side flag
		bra.s	.not_at_highest
; ===========================================================================

	.left_side:
		move.w	objoff_3E(a0),d0
		subq.w	#8,d0
		move.w	d0,objoff_3E(a0)		; decrease swing speed
		add.w	d0,obAngle(a0)			; update angle
		cmpi.w	#-$200,d0			; is speed at max?
		bne.s	.not_at_highest			; if not, branch
		move.b	#0,objoff_3D(a0)		; switch side flag

	.not_at_highest:
		move.b	obAngle(a0),d0			; get latest angle
		; fall-through to Swing_Move2...

; End of function GBall_Move
; ---------------------------------------------------------------------------

Swing_Move2:
		bsr.w	CalcSine
		move.w	swing_origY(a0),d2
		move.w	swing_origX(a0),d3
		lea	obSubtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_7BCE:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#object_size_bits,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	objoff_3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,obY(a1)
		move.w	d5,obX(a1)
		dbf	d6,loc_7BCE
		rts
; End of function Swing_Move

; ===========================================================================
; ===========================================================================

Swing_ChkDel:
		out_of_range.w	Swing_DelAll,swing_origX(a0)
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

Swing_DelAll:
		moveq	#0,d2
		lea	obSubtype(a0),a2
		move.b	(a2)+,d2

Swing_DelLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,Swing_DelLoop ; repeat for length of chain
		rts
; ===========================================================================

Swing_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts
; ===========================================================================

Swing_Display:	; Routine $A
		bra.w	DisplaySprite
; ===========================================================================

Map_Swing_GHZ:	include	"_maps/Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:	include	"_maps/Swinging Platforms (SLZ).asm"
