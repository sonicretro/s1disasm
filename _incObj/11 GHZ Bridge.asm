; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge
; ---------------------------------------------------------------------------

Bridge:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bri_Index(pc,d0.w),d1
		jmp	Bri_Index(pc,d1.w)
; ===========================================================================
Bri_Index:	dc.w Bri_Main-Bri_Index
		dc.w Bri_Action-Bri_Index
		dc.w Bri_Platform-Bri_Index
		dc.w Bri_Delete-Bri_Index
		dc.w Bri_Delete-Bri_Index
		dc.w Bri_Display-Bri_Index
; ===========================================================================

Bri_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bri,obMap(a0)
		move.w	#ArtTile_GHZ_Bridge|Tile_Pal3,obGfx(a0)
		move.b	#sprite_cam_field,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#256/2,obActWid(a0)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		_move.b	obID(a0),d4	; copy object number ($11) to d4
		lea	obSubtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1		; copy bridge length to d1
		move.b	#0,(a2)+	; clear bridge length
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3		; d3 is position of leftmost log
		subq.b	#2,d1
		bcs.s	Bri_Action	; don't make more if bridge has only 1 log

.buildloop:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	Bri_Action
		addq.b	#1,obSubtype(a0)
		cmp.w	obX(a0),d3	; is this log the leftmost one?
		bne.s	.notleftmost	; if not, branch

		addi.w	#$10,d3
		move.w	d2,obY(a0)
		move.w	d2,objoff_3C(a0)
		move.w	a0,d5
		subi.w	#v_objspace&$FFFF,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		addq.b	#1,obSubtype(a0)

.notleftmost:
		move.w	a1,d5
		subi.w	#v_objspace&$FFFF,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1)
		_move.b	d4,obID(a1)	; load bridge object (d4 = $11)
		move.w	d2,obY(a1)
		move.w	d2,objoff_3C(a1)
		move.w	d3,obX(a1)
		move.l	#Map_Bri,obMap(a1)
		move.w	#ArtTile_GHZ_Bridge|Tile_Pal3,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)
		move.b	#3,obPriority(a1)
		move.b	#16/2,obActWid(a1)
		addi.w	#$10,d3
		dbf	d1,.buildloop ; repeat d1 times (length of bridge)

Bri_Action:	; Routine 2
		bsr.s	Bri_Solid
		tst.b	objoff_3E(a0)
		beq.s	.display
		subq.b	#4,objoff_3E(a0)
		bsr.w	Bri_Bend

.display:
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite
	endif
		bra.w	Bri_ChkDel
; ===========================================================================

Bri_Solid:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		cmp.w	d2,d0
		bhs.w	Plat_Exit
		bra.s	Plat_NoXCheck
; End of function Bri_Solid
; ===========================================================================

		include	"_incObj/sub PlatformObject & SlopeObject.asm"

; ===========================================================================

Bri_Platform:	; Routine 4
		bsr.s	Bri_WalkOff
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite
	endif
		bra.w	Bri_ChkDel

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk off a bridge
; ---------------------------------------------------------------------------

Bri_WalkOff:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	ExitPlatform2
		bcc.s	locret_75BE
		lsr.w	#4,d0
		move.b	d0,objoff_3F(a0)
		move.b	objoff_3E(a0),d0
		cmpi.b	#$40,d0
		beq.s	loc_75B6
		addq.b	#4,objoff_3E(a0)

loc_75B6:
		bsr.w	Bri_Bend
		bsr.w	Bri_MoveSonic

locret_75BE:
		rts
; End of function Bri_WalkOff
; ===========================================================================

		include	"_incObj/sub ExitPlatform.asm"

; ===========================================================================

Bri_MoveSonic:
		moveq	#0,d0
		move.b	objoff_3F(a0),d0
		move.b	objoff_29(a0,d0.w),d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		lea	(v_player).w,a1
		move.w	obY(a2),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)	; change Sonic's position on y-axis
		rts
; End of function Bri_MoveSonic
; ===========================================================================

Bri_Bend:
		move.b	objoff_3E(a0),d0
		bsr.w	CalcSine
		move.w	d0,d4
		lea	(Bri_Data_Align).l,a4
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	(Bri_Data_Y_Max).l,a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		lea	objoff_29(a0),a2

loc_765C:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a1),d0
		move.w	d0,obY(a1)
		dbf	d2,loc_765C
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_76CA
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_76CA

loc_76A4:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a1),d0
		move.w	d0,obY(a1)
		dbf	d2,loc_76A4

locret_76CA:
		rts
; End of function Bri_Bend

; ===========================================================================
; ---------------------------------------------------------------------------
; GHZ bridge-bending data
; (Defines how the bridge bends when Sonic walks across it)
; ---------------------------------------------------------------------------

; Obj11_BendData:
Bri_Data_Y_Max:	; Distance each log is moved down when stood on (only $C is used, i.e. 12 logs)
		dc.b  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 0 logs
		dc.b  2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 1 log
		dc.b  2,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 2 logs
		dc.b  2,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 3 logs
		dc.b  2,   4,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 4 logs
		dc.b  2,   4,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 5 logs
		dc.b  2,   4,   6,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 6 logs
		dc.b  2,   4,   6,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; 7 logs
		dc.b  2,   4,   6,   8,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0 ; 8 logs
		dc.b  2,   4,   6,   8,  $A,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0 ; 9 logs
		dc.b  2,   4,   6,   8,  $A,  $A,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0 ; $A logs
		dc.b  2,   4,   6,   8,  $A,  $C,  $A,   8,   6,   4,   2,   0,   0,   0,   0,   0 ; $B logs
		dc.b  2,   4,   6,   8,  $A,  $C,  $C,  $A,   8,   6,   4,   2,   0,   0,   0,   0 ; $C logs
		dc.b  2,   4,   6,   8,  $A,  $C,  $E,  $C,  $A,   8,   6,   4,   2,   0,   0,   0 ; $D logs
		dc.b  2,   4,   6,   8,  $A,  $C,  $E,  $E,  $C,  $A,   8,   6,   4,   2,   0,   0 ; $E logs
		dc.b  2,   4,   6,   8,  $A,  $C,  $E, $10,  $E,  $C,  $A,   8,   6,   4,   2,   0 ; $F logs
		dc.b  2,   4,   6,   8,  $A,  $C,  $E, $10, $10,  $E,  $C,  $A,   8,   6,   4,   2 ; $10 logs
		even

; Obj11_BendData2:
Bri_Data_Align:	; Values used to align logs to the left & right of the one being stood on
		dc.b $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 0
		dc.b $B5, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 1
		dc.b $7E, $DB, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 2
		dc.b $61, $B5, $EC, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 3
		dc.b $4A, $93, $CD, $F3, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 4
		dc.b $3E, $7E, $B0, $DB, $F6, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 5
		dc.b $38, $6D, $9D, $C5, $E4, $F8, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 6
		dc.b $31, $61, $8E, $B5, $D4, $EC, $FB, $FF,   0,   0,   0,   0,   0,   0,   0,   0 ; standing on log 7
		dc.b $2B, $56, $7E, $A2, $C1, $DB, $EE, $FB, $FF,   0,   0,   0,   0,   0,   0,   0 ; standing on log 8
		dc.b $25, $4A, $73, $93, $B0, $CD, $E1, $F3, $FC, $FF,   0,   0,   0,   0,   0,   0 ; standing on log 9
		dc.b $1F, $44, $67, $88, $A7, $BD, $D4, $E7, $F4, $FD, $FF,   0,   0,   0,   0,   0 ; standing on log $A
		dc.b $1F, $3E, $5C, $7E, $98, $B0, $C9, $DB, $EA, $F6, $FD, $FF,   0,   0,   0,   0 ; standing on log $B
		dc.b $19, $38, $56, $73, $8E, $A7, $BD, $D1, $E1, $EE, $F8, $FE, $FF,   0,   0,   0 ; standing on log $C
		dc.b $19, $38, $50, $6D, $83, $9D, $B0, $C5, $D8, $E4, $F1, $F8, $FE, $FF,   0,   0 ; standing on log $D
		dc.b $19, $31, $4A, $67, $7E, $93, $A7, $BD, $CD, $DB, $E7, $F3, $F9, $FE, $FF,   0 ; standing on log $E
		dc.b $19, $31, $4A, $61, $78, $8E, $A2, $B5, $C5, $D4, $E1, $EC, $F4, $FB, $FE, $FF ; standing on log $F
		even

; ===========================================================================

Bri_ChkDel:
		out_of_range.w	.deletebridge
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

.deletebridge:
		moveq	#0,d2
		lea	obSubtype(a0),a2 ; load bridge length
		move.b	(a2)+,d2	; move bridge length to d2
		subq.b	#1,d2		; subtract 1
		bcs.s	.delparent

.loop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		cmp.w	a0,d0
		beq.s	.skipdel
		bsr.w	DeleteChild

.skipdel:
		dbf	d2,.loop ; repeat d2 times (bridge length)

.delparent:
		bsr.w	DeleteObject
		rts
; ===========================================================================

Bri_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts
; ===========================================================================

Bri_Display:	; Routine $A
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Map_Bri:	include	"_maps/Bridge.asm"
