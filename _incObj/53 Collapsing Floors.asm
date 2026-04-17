; ---------------------------------------------------------------------------
; Object 53 - collapsing floors (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

CollapseFloor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CFlo_Index(pc,d0.w),d1
		jmp	CFlo_Index(pc,d1.w)
; ===========================================================================
CFlo_Index:	offsetTable
		ptr CFlo_Main
		ptr CFlo_Touch
		ptr CFlo_Collapse
		ptr CFlo_Display
		ptr CFlo_Delete
		ptr CFlo_WalkOff

cflo_timedelay = objoff_38
cflo_collapse_flag = objoff_3A
; ===========================================================================

CFlo_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_CFlo,obMap(a0)
		move.w	#ArtTile_MZ_Block|Tile_Pal3,obGfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ

		move.w	#ArtTile_SLZ_Collapsing_Floor|Tile_Pal3,obGfx(a0) ; SLZ specific code
		addq.b	#2,obFrame(a0)

.notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	.notSBZ
		move.w	#ArtTile_SBZ_Collapsing_Floor|Tile_Pal3,obGfx(a0) ; SBZ specific code

.notSBZ:
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#7,cflo_timedelay(a0)
		move.b	#$44,obActWid(a0)

CFlo_Touch:	; Routine 2
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the object?
		beq.s	.solid		; if not, branch
		tst.b	cflo_timedelay(a0)	; has time delay reached zero?
		beq.w	CFlo_Fragment	; if yes, branch
		subq.b	#1,cflo_timedelay(a0) ; subtract 1 from time

.solid:
		move.w	#$20,d1
		bsr.w	PlatformObject
		tst.b	obSubtype(a0)
		bpl.s	.remstate
		btst	#3,obStatus(a1)
		beq.s	.remstate
		bclr	#0,obRender(a0)
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		bcc.s	.remstate
		bset	#0,obRender(a0)

.remstate:
		bra.w	RememberState
; ===========================================================================

CFlo_Collapse:	; Routine 4
		tst.b	cflo_timedelay(a0)
		beq.w	loc_8458
		move.b	#1,cflo_collapse_flag(a0)	; set object as "touched"
		subq.b	#1,cflo_timedelay(a0)
; ===========================================================================

CFlo_WalkOff:	; Routine $A
		move.w	#$20,d1
		bsr.w	ExitPlatform
		move.w	obX(a0),d2
		bsr.w	MvSonicOnPtfm2
		bra.w	RememberState
; End of function CFlo_WalkOff

; ===========================================================================

CFlo_Display:	; Routine 6
		tst.b	cflo_timedelay(a0)	; has time delay reached zero?
		beq.s	CFlo_TimeZero	; if yes, branch
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the object?
		bne.w	loc_8402	; if yes, branch
		subq.b	#1,cflo_timedelay(a0); subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

loc_8402:
		subq.b	#1,cflo_timedelay(a0)
		bsr.w	CFlo_WalkOff
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_842E
		tst.b	cflo_timedelay(a0)
		bne.s	locret_843A
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#id_Run,obPrevAni(a1) ; restart Sonic's animation

loc_842E:
		move.b	#0,cflo_collapse_flag(a0)
		move.b	#6,obRoutine(a0) ; run "CFlo_Display" routine

locret_843A:
		rts
; ===========================================================================

CFlo_TimeZero:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.s	CFlo_Delete
		rts
; ===========================================================================

CFlo_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts
; ===========================================================================

CFlo_Fragment:
		move.b	#0,cflo_collapse_flag(a0)

loc_8458:
		lea	(CFlo_Data2).l,a4
		btst	#0,obSubtype(a0)
		beq.s	loc_846C
		lea	(CFlo_Data3).l,a4

loc_846C:
		moveq	#7,d1
		addq.b	#1,obFrame(a0)
		bra.s	loc_8486


; ===========================================================================

Ledge_Fragment:
		move.b	#0,ledge_collapse_flag(a0)

loc_847A:
		lea	(CFlo_Data1).l,a4
		moveq	#$18,d1
		addq.b	#2,obFrame(a0)

loc_8486:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obRender(a0)
		_move.b	obID(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_84B2
; ===========================================================================

loc_84AA:
		bsr.w	FindFreeObj
		bne.s	loc_84F2
		addq.w	#5,a3

loc_84B2:
		move.b	#6,obRoutine(a1)
		_move.b	d4,obID(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		cmpa.l	a0,a1
		bhs.s	loc_84EE
		bsr.w	DisplaySprite2

loc_84EE:
		dbf	d1,loc_84AA

loc_84F2:
		bsr.w	DisplaySprite
		move.w	#sfx_Collapse,d0
		jmp	(QueueSound2).l	; play collapsing sound
; ===========================================================================
; ---------------------------------------------------------------------------
; Disintegration data for collapsing ledges (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------
CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12,	$E, $A,	6, $18,	$14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C, 0
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12,	$A, 2
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E,	$A, 2

; ===========================================================================
; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and MZ platforms)
; ---------------------------------------------------------------------------

SlopeObject2:
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	locret_856E
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,obRender(a0)
		beq.s	loc_854E
		not.w	d0
		add.w	d1,d0

loc_854E:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	obY(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_856E:
		rts
; End of function SlopeObject2

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for GHZ collapsing ledge
; ---------------------------------------------------------------------------
Ledge_SlopeData:
		binclude	"misc/GHZ Collapsing Ledge Heightmap.bin"
		even