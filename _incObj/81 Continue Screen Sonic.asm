; ---------------------------------------------------------------------------
; Object 81 - Sonic on the continue screen
; ---------------------------------------------------------------------------

ContSonic:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CSon_Index(pc,d0.w),d1
		jsr	CSon_Index(pc,d1.w)
		jmp	DisplaySprite
; ===========================================================================
CSon_Index:	dc.w CSon_Main-CSon_Index
		dc.w CSon_ChkLand-CSon_Index
		dc.w CSon_Animate-CSon_Index
		dc.w CSon_Run-CSon_Index
; ===========================================================================

CSon_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$A0,obX(a0)
		move.w	#$C0,obY(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#id_Float3,obAnim(a0) ; use "floating" animation
		move.w	#$400,obVelY(a0) ; make Sonic fall from above

CSon_ChkLand:	; Routine 2
		cmpi.w	#$1A0,obY(a0)	; has Sonic landed yet?
		bne.s	CSon_ShowFall	; if not, branch

		addq.b	#2,obRoutine(a0)
		clr.w	obVelY(a0)	; stop Sonic falling
		move.l	#Map_ContScr,obMap(a0)
		move.w	#$8500,obGfx(a0)
		move.b	#0,obAnim(a0)
		bra.s	CSon_Animate

CSon_ShowFall:
		jsr	SpeedToPos
		jsr	Sonic_Animate
		jmp	Sonic_LoadGfx
; ===========================================================================

CSon_Animate:	; Routine 4
		tst.b	(v_jpadpress1).w ; is Start button pressed?
		bmi.s	CSon_GetUp	; if yes, branch
		lea	(AniScript_CSon).l,a1
		jmp	AnimateSprite

CSon_GetUp:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#id_Float4,obAnim(a0) ; use "getting up" animation
		clr.w	obInertia(a0)
		subq.w	#8,obY(a0)
		move.b	#$E0,d0
		bsr.w	PlaySound_Special ; fade out music

CSon_Run:	; Routine 6
		cmpi.w	#$800,obInertia(a0) ; check Sonic's inertia
		bne.s	CSon_AddInertia	; if too low, branch
		move.w	#$1000,obVelX(a0) ; move Sonic to the right
		bra.s	CSon_ShowRun

CSon_AddInertia:
		addi.w	#$20,obInertia(a0) ; increase inertia

CSon_ShowRun:
		jsr	SpeedToPos
		jsr	Sonic_Animate
		jmp	Sonic_LoadGfx
