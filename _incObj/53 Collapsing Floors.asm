; ---------------------------------------------------------------------------
; Object 53 - collapsing floors	(MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

CollapseFloor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CFlo_Index(pc,d0.w),d1
		jmp	CFlo_Index(pc,d1.w)
; ===========================================================================
CFlo_Index:	dc.w CFlo_Main-CFlo_Index, CFlo_Touch-CFlo_Index
		dc.w CFlo_Collapse-CFlo_Index, CFlo_Display-CFlo_Index
		dc.w CFlo_Delete-CFlo_Index, CFlo_WalkOff-CFlo_Index

cflo_timedelay = objoff_38
cflo_collapse_flag = objoff_3A
; ===========================================================================

CFlo_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_CFlo,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ

		move.w	#make_art_tile(ArtTile_SLZ_Collapsing_Floor,2,0),obGfx(a0) ; SLZ specific code
		addq.b	#2,obFrame(a0)

.notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	.notSBZ
		move.w	#make_art_tile(ArtTile_SBZ_Collapsing_Floor,2,0),obGfx(a0) ; SBZ specific code

.notSBZ:
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#7,cflo_timedelay(a0)
		move.b	#$44,obActWid(a0)

CFlo_Touch:	; Routine 2
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the	object?
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
		move.b	#1,cflo_collapse_flag(a0)	; set object as	"touched"
		subq.b	#1,cflo_timedelay(a0)

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the	object?
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
