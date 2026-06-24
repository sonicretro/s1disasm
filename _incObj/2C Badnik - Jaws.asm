; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2C - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Jaws:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Jaws_Index(pc,d0.w),d1
		jmp	Jaws_Index(pc,d1.w)
; ===========================================================================
Jaws_Index:	dc.w Jaws_Main-Jaws_Index	; 0
		dc.w Jaws_Swim-Jaws_Index	; 2

jaws_turndelay_current:	equ objoff_30		; delay before turning around (64 frames per subtype value)
jaws_turndelay_base:	equ objoff_32		; base turn delay to reset to on turn
; ===========================================================================

Jaws_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Jaws_Swim
		move.l	#Map_Jaws,obMap(a0)			; set mappings
		move.w	#ArtTile_Jaws|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set playfield-positioned mode
		move.b	#col_32x24|col_badnik,obColType(a0)	; set collision type to badnik, 32x24
		move.b	#4,obPriority(a0)			; set sprite priority
	if FixBugs
		move.b	#48/2,obActWid(a0)			; set sprite display width (corrected)
	else
		; This is too small, object gets culled too early.
		move.b	#32/2,obActWid(a0)			; set sprite display width
	endif

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; load object subtype number
		lsl.w	#6,d0					; d0 = turn delay in frames (subtype value multiplied by 64 frames)
		subq.w	#1,d0					; sub 1 (timer counts 0 as another frame)
		move.w	d0,jaws_turndelay_current(a0)		; set current turn delay time
		move.w	d0,jaws_turndelay_base(a0)		; set base turn delay time to reset to on turn

		move.w	#-$40,obVelX(a0)			; move Jaws to the left
		btst	#0,obStatus(a0)				; is Jaws facing left?
		beq.s	Jaws_Swim				; if yes, branch
		neg.w	obVelX(a0)				; move Jaws to the right
; ---------------------------------------------------------------------------

Jaws_Swim:	; Routine 2
		subq.w	#1,jaws_turndelay_current(a0)		; subtract 1 from turn delay time
		bpl.s	.animate				; if time remains, branch
		move.w	jaws_turndelay_base(a0),jaws_turndelay_current(a0) ; reset turn delay time to base
		neg.w	obVelX(a0)				; change speed direction
		bchg	#0,obStatus(a0)				; change Jaws facing direction
		move.b	#1,obPrevAni(a0)			; reset animation

	.animate:
		lea	(Ani_Jaws).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate Jaws

		bsr.w	SpeedToPos				; make Jaws swim
		bra.w	RememberState				; display sprite, or delete when offscreen
; ===========================================================================

		include	"_anim/Jaws.asm"
Map_Jaws:	include	"_maps/Jaws.asm"
