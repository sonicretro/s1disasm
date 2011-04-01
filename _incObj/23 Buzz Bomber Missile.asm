; ---------------------------------------------------------------------------
; Object 23 - missile that Buzz	Bomber throws
; ---------------------------------------------------------------------------

Missile:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Msl_Index(pc,d0.w),d1
		jmp	Msl_Index(pc,d1.w)
; ===========================================================================
Msl_Index:	dc.w Msl_Main-Msl_Index
		dc.w Msl_Animate-Msl_Index
		dc.w Msl_FromBuzz-Msl_Index
		dc.w Msl_Delete-Msl_Index
		dc.w Msl_FromNewt-Msl_Index

parent:		= $3C
; ===========================================================================

Msl_Main:	; Routine 0
		subq.w	#1,$32(a0)
		bpl.s	Msl_ChkCancel
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Missile,obMap(a0)
		move.w	#$2444,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obActWid(a0)
		andi.b	#3,obStatus(a0)
		tst.b	obSubtype(a0)	; was object created by	a Newtron?
		beq.s	Msl_Animate	; if not, branch

		move.b	#8,obRoutine(a0) ; run "Msl_FromNewt" routine
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bra.s	Msl_Animate2
; ===========================================================================

Msl_Animate:	; Routine 2
		bsr.s	Msl_ChkCancel
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, then cancel	the missile
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Msl_ChkCancel:				; XREF: Msl_Main
		movea.l	parent(a0),a1
		cmpi.b	#id_ExplosionItem,0(a1) ; has Buzz Bomber been destroyed?
		beq.s	Msl_Delete	; if yes, branch
		rts	
; End of function Msl_ChkCancel

; ===========================================================================

Msl_FromBuzz:	; Routine 4
		btst	#7,obStatus(a0)
		bne.s	@explode
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bsr.w	SpeedToPos
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object moved below the level boundary?
		bcs.s	Msl_Delete	; if yes, branch
		rts	
; ===========================================================================

	@explode:
		move.b	#id_MissileDissolve,0(a0) ; change object to an explosion (Obj24)
		move.b	#0,obRoutine(a0)
		bra.w	MissileDissolve
; ===========================================================================

Msl_Delete:	; Routine 6
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Msl_FromNewt:	; Routine 8
		tst.b	obRender(a0)
		bpl.s	Msl_Delete
		bsr.w	SpeedToPos

Msl_Animate2:				; XREF: Msl_Main
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts	
