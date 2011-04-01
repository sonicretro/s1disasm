; ---------------------------------------------------------------------------
; Object 26 - monitors
; ---------------------------------------------------------------------------

Monitor:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Mon_Index(pc,d0.w),d1
		jmp	Mon_Index(pc,d1.w)
; ===========================================================================
Mon_Index:	dc.w Mon_Main-Mon_Index
		dc.w Mon_Solid-Mon_Index
		dc.w Mon_BreakOpen-Mon_Index
		dc.w Mon_Animate-Mon_Index
		dc.w Mon_Display-Mon_Index
; ===========================================================================

Mon_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$E,obHeight(a0)
		move.b	#$E,obWidth(a0)
		move.l	#Map_Monitor,obMap(a0)
		move.w	#$680,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$F,obActWid(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)	; has monitor been broken?
		beq.s	@notbroken	; if not, branch
		move.b	#8,obRoutine(a0) ; run "Mon_Display" routine
		move.b	#$B,obFrame(a0)	; use broken monitor frame
		rts	
; ===========================================================================

	@notbroken:
		move.b	#$46,obColType(a0)
		move.b	obSubtype(a0),obAnim(a0)

Mon_Solid:	; Routine 2
		move.b	ob2ndRout(a0),d0 ; is monitor set to fall?
		beq.s	@normal		; if not, branch
		subq.b	#2,d0
		bne.s	@fall

		; 2nd Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		bsr.w	ExitPlatform
		btst	#3,obStatus(a1) ; is Sonic on top of the monitor?
		bne.w	@ontop		; if yes, branch
		clr.b	ob2ndRout(a0)
		bra.w	Mon_Animate
; ===========================================================================

	@ontop:
		move.w	#$10,d3
		move.w	obX(a0),d2
		bsr.w	MvSonicOnPtfm
		bra.w	Mon_Animate
; ===========================================================================

@fall:		; 2nd Routine 4
		bsr.w	ObjectFall
		jsr	ObjFloorDist
		tst.w	d1
		bpl.w	Mon_Animate
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		clr.b	ob2ndRout(a0)
		bra.w	Mon_Animate
; ===========================================================================

@normal:	; 2nd Routine 0
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	Mon_SolidSides
		beq.w	loc_A25C
		tst.w	obVelY(a1)
		bmi.s	loc_A20A
		cmpi.b	#id_Roll,obAnim(a1) ; is Sonic rolling?
		beq.s	loc_A25C	; if yes, branch

loc_A20A:
		tst.w	d1
		bpl.s	loc_A220
		sub.w	d3,obY(a1)
		bsr.w	loc_74AE
		move.b	#2,ob2ndRout(a0)
		bra.w	Mon_Animate
; ===========================================================================

loc_A220:
		tst.w	d0
		beq.w	loc_A246
		bmi.s	loc_A230
		tst.w	obVelX(a1)
		bmi.s	loc_A246
		bra.s	loc_A236
; ===========================================================================

loc_A230:
		tst.w	obVelX(a1)
		bpl.s	loc_A246

loc_A236:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)

loc_A246:
		btst	#1,obStatus(a1)
		bne.s	loc_A26A
		bset	#5,obStatus(a1)
		bset	#5,obStatus(a0)
		bra.s	Mon_Animate
; ===========================================================================

loc_A25C:
		btst	#5,obStatus(a0)
		beq.s	Mon_Animate
		move.w	#1,obAnim(a1)

loc_A26A:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)

Mon_Animate:	; Routine 6
		lea	(Ani_Monitor).l,a1
		bsr.w	AnimateSprite

Mon_Display:	; Routine 8
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
; ===========================================================================

Mon_BreakOpen:	; Routine 4
		addq.b	#2,obRoutine(a0)
		move.b	#0,obColType(a0)
		bsr.w	FindFreeObj
		bne.s	Mon_Explode
		move.b	#id_PowerUp,0(a1) ; load monitor contents object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obAnim(a0),obAnim(a1)

Mon_Explode:
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_ExplosionItem,0(a1) ; load explosion object
		addq.b	#2,obRoutine(a1) ; don't create an animal
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

	@fail:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#9,obAnim(a0)	; set monitor type to broken
		bra.w	DisplaySprite
