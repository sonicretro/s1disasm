; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6E - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

Electro:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Elec_Index(pc,d0.w),d1
		jmp	Elec_Index(pc,d1.w)
; ===========================================================================
Elec_Index:	dc.w Elec_Main-Elec_Index
		dc.w Elec_Shock-Elec_Index

elec_freq:	equ objoff_34		; zapping frequency as andable value
; ===========================================================================

Elec_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Elec_Shock
		move.l	#Map_Elec,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Electric_Orb,obGfx(a0)	; set art tile
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#80/2,obActWid(a0)			; set sprite width

		; Zap intervals are defined through the subtype, which must always be a power of 2.
		; This value will get ANDed with the current level frame counter, and zap if it's 0.
		moveq	#0,d0					; clear d0, frequency is a word
		move.b	obSubtype(a0),d0			; read zapper subtype
		lsl.w	#4,d0					; multiply by $10
		subq.w	#1,d0					; sub 1 to get andable value (e.g. $1F, $3F, $7F)
		move.w	d0,elec_freq(a0)			; set result as frequency
; ---------------------------------------------------------------------------

Elec_Shock:	; Routine 2
		move.w	(v_framecount).w,d0			; get current frame counter value
		and.w	elec_freq(a0),d0			; is it time to zap?
		bne.s	.animate				; if not, branch

		move.b	#1,obAnim(a0)				; run "zap" animation
		tst.b	obRender(a0)				; is zapper on screen?
		bpl.s	.animate				; if not, don't play sound
		move.w	#sfx_Electric,d0			; set electricity sound
		jsr	(QueueSound2).l				; play it

	.animate:
		lea	(Ani_Elec).l,a1				; load animation script
		jsr	(AnimateSprite).l			; animate zapper

		move.b	#col_none,obColType(a0)			; make zapper harmless by default
		cmpi.b	#4,obFrame(a0)				; is 4th frame displayed?
		bne.s	.display				; if not, branch
		move.b	#col_144x16|col_hurt,obColType(a0)	; if yes, make object hurt Sonic this frame

	.display:
		bra.w	RememberState				; display sprite or delete if offscreen
; ===========================================================================

		include	"_anim/Electrocuter.asm"
Map_Elec:	include	"_maps/Electrocuter.asm"
