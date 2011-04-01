; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge
; ---------------------------------------------------------------------------

CollapseLedge:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Ledge_Index(pc,d0.w),d1
		jmp	Ledge_Index(pc,d1.w)
; ===========================================================================
Ledge_Index:	dc.w Ledge_Main-Ledge_Index, Ledge_Touch-Ledge_Index
		dc.w Ledge_Collapse-Ledge_Index, Ledge_Display-Ledge_Index
		dc.w Ledge_Delete-Ledge_Index, Ledge_WalkOff-Ledge_Index

timedelay:	= $38		; time between touching the ledge and it collapsing
collapse:	= $3A		; collapse flag
; ===========================================================================

Ledge_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Ledge,obMap(a0)
		move.w	#$4000,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#7,timedelay(a0) ; set time delay for collapse
		move.b	#$64,obActWid(a0)
		move.b	obSubtype(a0),obFrame(a0)
		move.b	#$38,obHeight(a0)
		bset	#4,obRender(a0)

Ledge_Touch:	; Routine 2
		tst.b	collapse(a0)	; is ledge collapsing?
		beq.s	@slope		; if not, branch
		tst.b	timedelay(a0)	; has time reached zero?
		beq.w	Ledge_Fragment	; if yes, branch
		subq.b	#1,timedelay(a0) ; subtract 1 from time

	@slope:
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		bsr.w	SlopeObject
		bra.w	RememberState
; ===========================================================================

Ledge_Collapse:	; Routine 4
		tst.b	timedelay(a0)
		beq.w	loc_847A
		move.b	#1,collapse(a0)	; set collapse flag
		subq.b	#1,timedelay(a0)

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Ledge_WalkOff:	; Routine $A
		move.w	#$30,d1
		bsr.w	ExitPlatform
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		move.w	obX(a0),d2
		bsr.w	SlopeObject2
		bra.w	RememberState
; End of function Ledge_WalkOff

; ===========================================================================

Ledge_Display:	; Routine 6
		tst.b	timedelay(a0)	; has time delay reached zero?
		beq.s	Ledge_TimeZero	; if yes, branch
		tst.b	collapse(a0)	; is ledge collapsing?
		bne.w	loc_82D0	; if yes, branch
		subq.b	#1,timedelay(a0) ; subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

loc_82D0:
		subq.b	#1,timedelay(a0)
		bsr.w	Ledge_WalkOff
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_82FC
		tst.b	timedelay(a0)
		bne.s	locret_8308
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#1,obNextAni(a1)

loc_82FC:
		move.b	#0,collapse(a0)
		move.b	#6,obRoutine(a0) ; run "Ledge_Display" routine

locret_8308:
		rts	
; ===========================================================================

Ledge_TimeZero:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.s	Ledge_Delete
		rts	
; ===========================================================================

Ledge_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts	
