; ---------------------------------------------------------------------------
; Object 41 - springs
; ---------------------------------------------------------------------------

Springs:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Spring_Index(pc,d0.w),d1
		jsr	Spring_Index(pc,d1.w)
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
; ===========================================================================
Spring_Index:	dc.w Spring_Main-Spring_Index
		dc.w Spring_Up-Spring_Index
		dc.w Spring_AniUp-Spring_Index
		dc.w Spring_ResetUp-Spring_Index
		dc.w Spring_LR-Spring_Index
		dc.w Spring_AniLR-Spring_Index
		dc.w Spring_ResetLR-Spring_Index
		dc.w Spring_Dwn-Spring_Index
		dc.w Spring_AniDwn-Spring_Index
		dc.w Spring_ResetDwn-Spring_Index

spring_pow:	= $30			; power of current spring

Spring_Powers:	dc.w -$1000		; power	of red spring
		dc.w -$A00		; power	of yellow spring
; ===========================================================================

Spring_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Spring,obMap(a0)
		move.w	#$523,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),d0
		btst	#4,d0		; does the spring face left/right?
		beq.s	Spring_NotLR	; if not, branch

		move.b	#8,obRoutine(a0) ; use "Spring_LR" routine
		move.b	#1,obAnim(a0)
		move.b	#3,obFrame(a0)
		move.w	#$533,obGfx(a0)
		move.b	#8,obActWid(a0)

	Spring_NotLR:
		btst	#5,d0		; does the spring face downwards?
		beq.s	Spring_NotDwn	; if not, branch

		move.b	#$E,obRoutine(a0) ; use "Spring_Dwn" routine
		bset	#1,obStatus(a0)

	Spring_NotDwn:
		btst	#1,d0
		beq.s	loc_DB72
		bset	#5,obGfx(a0)

loc_DB72:
		andi.w	#$F,d0
		move.w	Spring_Powers(pc,d0.w),spring_pow(a0)
		rts	
; ===========================================================================

Spring_Up:	; Routine 2
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		tst.b	ob2ndRout(a0)	; is Sonic on top of the spring?
		bne.s	Spring_BounceUp	; if yes, branch
		rts	
; ===========================================================================

Spring_BounceUp:
		addq.b	#2,obRoutine(a0)
		addq.w	#8,obY(a1)
		move.w	spring_pow(a0),obVelY(a1) ; move Sonic upwards
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#id_Spring,obAnim(a1) ; use "bouncing" animation
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	ob2ndRout(a0)
		sfx	sfx_Spring	; play spring sound

Spring_AniUp:	; Routine 4
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ===========================================================================

Spring_ResetUp:	; Routine 6
		move.b	#1,obNextAni(a0) ; reset animation
		subq.b	#4,obRoutine(a0) ; goto "Spring_Up" routine
		rts	
; ===========================================================================

Spring_LR:	; Routine 8
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,obRoutine(a0)
		bne.s	loc_DC0C
		move.b	#8,obRoutine(a0)

loc_DC0C:
		btst	#5,obStatus(a0)
		bne.s	Spring_BounceLR
		rts	
; ===========================================================================

Spring_BounceLR:
		addq.b	#2,obRoutine(a0)
		move.w	spring_pow(a0),obVelX(a1) ; move Sonic to the left
		addq.w	#8,obX(a1)
		btst	#0,obStatus(a0)	; is object flipped?
		bne.s	Spring_Flipped	; if yes, branch
		subi.w	#$10,obX(a1)
		neg.w	obVelX(a1)	; move Sonic to	the right

	Spring_Flipped:
		move.w	#$F,$3E(a1)
		move.w	obVelX(a1),obInertia(a1)
		bchg	#0,obStatus(a1)
		btst	#2,obStatus(a1)
		bne.s	loc_DC56
		move.b	#0,obAnim(a1)	; use running animation

loc_DC56:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)
		sfx	sfx_Spring	; play spring sound

Spring_AniLR:	; Routine $A
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ===========================================================================

Spring_ResetLR:	; Routine $C
		move.b	#2,obNextAni(a0) ; reset animation
		subq.b	#4,obRoutine(a0) ; goto "Spring_LR" routine
		rts	
; ===========================================================================

Spring_Dwn:	; Routine $E
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,obRoutine(a0)
		bne.s	loc_DCA4
		move.b	#$E,obRoutine(a0)

loc_DCA4:
		tst.b	ob2ndRout(a0)
		bne.s	locret_DCAE
		tst.w	d4
		bmi.s	Spring_BounceDwn

locret_DCAE:
		rts	
; ===========================================================================

Spring_BounceDwn:			; XREF: Spring_Dwn
		addq.b	#2,obRoutine(a0)
		subq.w	#8,obY(a1)
		move.w	spring_pow(a0),obVelY(a1)
		neg.w	obVelY(a1)	; move Sonic downwards
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	ob2ndRout(a0)
		sfx	sfx_Spring	; play spring sound

Spring_AniDwn:	; Routine $10
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ===========================================================================

Spring_ResetDwn:
		; Routine $12
		move.b	#1,obNextAni(a0) ; reset animation
		subq.b	#4,obRoutine(a0) ; goto "Spring_Dwn" routine
		rts	
