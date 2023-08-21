; ---------------------------------------------------------------------------
; Object 23 - missile that Buzz	Bomber throws
; ---------------------------------------------------------------------------

Missile:
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

msl_parent = objoff_3C
; ===========================================================================

Msl_Main:	; Routine 0
		subq.w	#1,objoff_32(a0)
		bpl.s	Msl_ChkCancel
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Missile,obMap(a0)
		move.w	#make_art_tile(ArtTile_Buzz_Bomber,1,0),obGfx(a0)
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
	if FixBugs
		; Msl_ChkCancel can call DeleteObject, so we shouldn't queue
		; this object for display or update the animation state.
		; Failing to account for this results in a null pointer
		; dereference, which is harmless in Sonic 1 but will crash
		; Sonic 2. Fun fact: Sonic 2 REV00 has some leftover debug
		; code in its BuildSprites function for detecting this type
		; of bug.
		beq.s	Msl_ChkCancel.return
	endif
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, then cancel	the missile
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Msl_ChkCancel:
		movea.l	msl_parent(a0),a1
		_cmpi.b	#id_ExplosionItem,obID(a1) ; has Buzz Bomber been destroyed?
	if FixBugs
		; This adds a return value so that we know if the object has
		; been freed.
		bne.s	.return
		bsr.s	Msl_Delete
		moveq	#0,d0

.return:
	else
		beq.s	Msl_Delete	; if yes, branch
	endif
		rts	
; End of function Msl_ChkCancel

; ===========================================================================

Msl_FromBuzz:	; Routine 4
		btst	#7,obStatus(a0)
		bne.s	.explode
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bsr.w	SpeedToPos

	if ~~FixBugs
		; Object should not call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
	endif

		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object moved below the level boundary?
		blo.s	Msl_Delete	; if yes, branch

	if FixBugs
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
	else
		rts	
	endif
; ===========================================================================

.explode:
		_move.b	#id_MissileDissolve,obID(a0) ; change object to an explosion (Obj24)
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

Msl_Animate2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts	
