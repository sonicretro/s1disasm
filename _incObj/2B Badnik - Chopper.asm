; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2B - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

Chopper:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Chop_Index(pc,d0.w),d1
		jsr	Chop_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Chop_Index:	dc.w Chop_Main-Chop_Index	; 0
		dc.w Chop_ChgSpeed-Chop_Index	; 2

chop_origY:	equ objoff_30	; original Y-position when Chopper was spawned
; ===========================================================================

Chop_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; advance to Chop_ChgSpeed
		move.l	#Map_Chop,obMap(a0)		; set mappings
		move.w	#ArtTile_Chopper,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
		move.b	#4,obPriority(a0)		; set sprite priority
		move.b	#col_24x32|col_badnik,obColType(a0) ; set to ReactToItem entry 9 (badnik, 24x32)
		move.b	#32/2,obActWid(a0)		; set sprite display width
		move.w	#-$700,obVelY(a0)		; set vertical speed
		move.w	obY(a0),chop_origY(a0)		; save original position
; ---------------------------------------------------------------------------

Chop_ChgSpeed:	; Routine 2
		lea	(Ani_Chop).l,a1			; load Chopper animation script
		bsr.w	AnimateSprite			; run animation

		bsr.w	SpeedToPos			; update coordinates based on velocities
		addi.w	#$18,obVelY(a0)			; reduce speed

		move.w	chop_origY(a0),d0		; get initial Y-position
		cmp.w	obY(a0),d0			; has Chopper returned to its original position?
		bhs.s	.chganimation			; if not, branch
		move.w	d0,obY(a0)			; force to initial position
		move.w	#-$700,obVelY(a0)		; set vertical speed

	.chganimation:
		move.b	#1,obAnim(a0)			; use fast animation
		subi.w	#$C0,d0				; set animation speed change trigger $C0px above launch
		cmp.w	obY(a0),d0			; has Chopper moved past that Y-position?
		bhs.s	.return				; if not, branch
		move.b	#0,obAnim(a0)			; use slow animation
		tst.w	obVelY(a0)			; is Chopper falling back down?
		bmi.s	.return				; if not, branch
		move.b	#2,obAnim(a0)			; use stationary animation

	.return:
		rts					; return to display
; ===========================================================================

		include	"_anim/Chopper.asm"
Map_Chop:	include	"_maps/Chopper.asm"
