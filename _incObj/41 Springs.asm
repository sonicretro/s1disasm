; ===========================================================================
; ---------------------------------------------------------------------------
; Object 41 - springs
; ---------------------------------------------------------------------------

Springs:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Spring_Index(pc,d0.w),d1
		jsr	Spring_Index(pc,d1.w)
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================
Spring_Index:	dc.w Spring_Main-Spring_Index		; 0
		dc.w Spring_Up-Spring_Index		; 2
		dc.w Spring_AniUp-Spring_Index		; 4
		dc.w Spring_ResetUp-Spring_Index	; 6
		dc.w Spring_LR-Spring_Index		; 8
		dc.w Spring_AniLR-Spring_Index		; A
		dc.w Spring_ResetLR-Spring_Index	; C
		dc.w Spring_Down-Spring_Index		; E
		dc.w Spring_AniDown-Spring_Index	; 10
		dc.w Spring_ResetDown-Spring_Index	; 12

spring_pow:	equ objoff_30		; power of current spring

Spring_Powers:	dc.w -$1000		; power of red spring
		dc.w -$A00		; power of yellow spring
; ===========================================================================

Spring_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to "Spring_Up"
		move.l	#Map_Spring,obMap(a0)			; set mappings
		move.w	#ArtTile_Spring_Horizontal,obGfx(a0)	; set art tile for upright springs (palette line 1, red)
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield positioning mode
		move.b	#32/2,obActWid(a0)			; set display width
		move.b	#4,obPriority(a0)			; set sprite priority

		move.b	obSubtype(a0),d0			; get spring subtype
	.checkSideways:
		btst	#4,d0					; does the spring face left/right?
		beq.s	.checkDownwards				; if not, branch
		move.b	#8,obRoutine(a0)			; use "Spring_LR" routine
		move.b	#1,obAnim(a0)				; use different animation
		move.b	#3,obFrame(a0)				; set to sideways frame
		move.w	#ArtTile_Spring_Vertical,obGfx(a0)	; set art tile for sideways springs
		move.b	#16/2,obActWid(a0)			; use smaller display width

	; Spring_NotLR:
	.checkDownwards:
		btst	#5,d0					; does the spring face downwards?
		beq.s	.checkYellow				; if not, branch
		move.b	#$E,obRoutine(a0)			; use "Spring_Down" routine
		bset	#1,obStatus(a0)				; set Y-flip flag

	; Spring_NotDown:
	.checkYellow:
		btst	#1,d0					; is this a yellow spring?
		beq.s	.getPower				; if not, branch
		bset	#5,obGfx(a0)				; use palette line 2 (yellow)

	; loc_DB72:
	.getPower:
		andi.w	#$F,d0					; mask out upper nybble
		move.w	Spring_Powers(pc,d0.w),spring_pow(a0)	; get spring power for subtype
		rts						; return to display
; ===========================================================================

Spring_Up:	; Routine 2
		move.w	#32/2+sonic_solid_width,d1
		move.w	#16/2,d2
		move.w	#32/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject				; check Sonic's collision with spring
		tst.b	obSolid(a0)				; is Sonic on top of the spring?
		bne.s	.bounceUp				; if yes, branch
		rts						; return
; ---------------------------------------------------------------------------

	; Spring_BounceUp:
	.bounceUp:
		addq.b	#2,obRoutine(a0)			; set to "Spring_AniUp"
		addq.w	#8,obY(a1)				; push Sonic a few pixels into the spring
		move.w	spring_pow(a0),obVelY(a1)		; bounce Sonic upwards
		bset	#1,obStatus(a1)				; set Sonic's airborne flag
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		move.b	#id_Spring,obAnim(a1)			; use "bouncing" animation
		move.b	#2,obRoutine(a1)			; set Sonic to Sonic_Control routine
		bclr	#3,obStatus(a0)				; clear spring's Sonic touch flag
		clr.b	obSolid(a0)				; clear spring's solidity flag
		move.w	#sfx_Spring,d0
		jsr	(QueueSound2).l				; play spring sound
; ---------------------------------------------------------------------------

Spring_AniUp:	; Routine 4
		lea	(Ani_Spring).l,a1			; animation script will advance routine...
		bra.w	AnimateSprite				; ...to "Spring_ResetUp" once it's finished
; ===========================================================================

Spring_ResetUp:	; Routine 6
		move.b	#1,obPrevAni(a0)			; reset animation
		subq.b	#4,obRoutine(a0)			; goto "Spring_Up" routine
		rts						; return
; ===========================================================================
; ===========================================================================

Spring_LR:	; Routine 8
		move.w	#16/2+sonic_solid_width,d1
		move.w	#28/2,d2
		move.w	#30/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject				; check Sonic's collision with spring

		cmpi.b	#2,obRoutine(a0)			; is spring routine set to Spring_Up for some reason?
		bne.s	.checkPushing				; if not, branch
		move.b	#8,obRoutine(a0)			; force routine back to Spring_LR

	; loc_DC0C:
	.checkPushing:
		btst	#5,obStatus(a0)				; is Sonic pushing against this spring?
		bne.s	.bounceSideways				; if yes, branch
		rts						; no bounce
; ---------------------------------------------------------------------------

	; Spring_BounceLR:
	.bounceSideways:
		addq.b	#2,obRoutine(a0)			; advance to Spring_AniLR
		move.w	spring_pow(a0),obVelX(a1)		; bounce Sonic to the left
		addq.w	#8,obX(a1)				; push Sonic a few pixels into the spring (to the right)
		btst	#0,obStatus(a0)				; is spring facing to the left?
		bne.s	.doBounce				; if not, branch
		subi.w	#8+8,obX(a1)				; push Sonic a few pixels into the spring (to the left)
		neg.w	obVelX(a1)				; bounce Sonic to the right

	; Spring_Flipped:
	.doBounce:
		move.w	#15,locktime(a1)			; disable Sonic's D-Pad inputs for 15 frames
		move.w	obVelX(a1),obInertia(a1)		; copy X-speed to ground speed
		bchg	#0,obStatus(a1)				; flip Sonic's X-orientation
		btst	#2,obStatus(a1)				; is Sonic rolling?
		bne.s	.clearPush				; if yes, don't change animation
		move.b	#id_Walk,obAnim(a1)			; use walking animation

	; loc_DC56:
	.clearPush:
		bclr	#5,obStatus(a0)				; clear spring's pushed flag
		bclr	#5,obStatus(a1)				; clear Sonic's pushing flag
		move.w	#sfx_Spring,d0				; set spring sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

Spring_AniLR:	; Routine $A
		lea	(Ani_Spring).l,a1			; animation script will advance routine...
		bra.w	AnimateSprite				; ...to "Spring_ResetLR" once it's finished
; ===========================================================================

Spring_ResetLR:	; Routine $C
		move.b	#2,obPrevAni(a0)			; reset animation
		subq.b	#4,obRoutine(a0)			; goto "Spring_LR" routine
		rts						; return
; ===========================================================================
; ===========================================================================

Spring_Down:	; Routine $E
		move.w	#32/2+sonic_solid_width,d1
		move.w	#16/2,d2
		move.w	#32/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject				; check Sonic's collision with spring

		cmpi.b	#2,obRoutine(a0)			; is spring routine set to Spring_Up for some reason?
		bne.s	.checkTouch				; if not, branch
		move.b	#$E,obRoutine(a0)			; force routine back to Spring_Down

	; loc_DCA4:
	.checkTouch:
		tst.b	obSolid(a0)				; is Sonic standing on top of the spring?
		bne.s	.return					; if yes, don't bounce
		tst.w	d4					; has Sonic touched the spring from below?
		bmi.s	.bounceDown				; if yes, branch

	; locret_DCAE:
	.return:
		rts						; return
; ---------------------------------------------------------------------------

	; Spring_BounceDown:
	.bounceDown:
		addq.b	#2,obRoutine(a0)			; advance to "Spring_AniDown"
		subq.w	#8,obY(a1)				; push Sonic a few pixels into the spring
		move.w	spring_pow(a0),obVelY(a1)		; get spring force
		neg.w	obVelY(a1)				; negate it to move Sonic downwards
		bset	#1,obStatus(a1)				; set Sonic's airborne flag
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		move.b	#2,obRoutine(a1)			; set Sonic to Sonic_Control routine
		bclr	#3,obStatus(a0)				; clear spring's Sonic touch flag
		clr.b	obSolid(a0)				; clear spring's solidity flag
		move.w	#sfx_Spring,d0				; set spring sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

Spring_AniDown:	; Routine $10
		lea	(Ani_Spring).l,a1			; animation script will advance routine...
		bra.w	AnimateSprite				; ...to "Spring_ResetDown" once it's finished
; ===========================================================================

Spring_ResetDown:
		; Routine $12
		move.b	#1,obPrevAni(a0)			; reset animation
		subq.b	#4,obRoutine(a0)			; goto "Spring_Down" routine
		rts						; return
; ===========================================================================
; ===========================================================================

		include	"_anim/Springs.asm"
Map_Spring:	include	"_maps/Springs.asm"
