; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6D - flame thrower (SBZ)
; ---------------------------------------------------------------------------

Flamethrower:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Flame_Index(pc,d0.w),d1
		jmp	Flame_Index(pc,d1.w)
; ===========================================================================
Flame_Index:	dc.w Flame_Main-Flame_Index
		dc.w Flame_Action-Flame_Index

flame_timer:		equ objoff_30	; current timer value
flame_firetime:		equ objoff_32	; base time for flamethrower to fire
flame_pausetime:	equ objoff_34	; base time for flamethrower to idle
flame_hurtframe:	equ objoff_36	; frame ID that is harmful to Sonic
; ===========================================================================

Flame_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Flame_Action
		move.l	#Map_Flame,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Flamethrower|Tile_Prio,obGfx(a0) ; set art tile and high-priority flag
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)
		move.w	obY(a0),flame_timer(a0)			; store obY (pointless, gets overwritten below)
		move.b	#24/2,obActWid(a0)			; set sprite display width

		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#$F0,d0					; read upper digit of object subtype
		add.w	d0,d0					; multiply by 2 frames
		move.w	d0,flame_timer(a0)			; set as initial timer value
		move.w	d0,flame_firetime(a0)			; store base flaming time

		move.b	obSubtype(a0),d0			; get object subtype again
		andi.w	#$0F,d0					; read lower digit of object subtype
		lsl.w	#5,d0					; multiply by 32 frames
		move.w	d0,flame_pausetime(a0)			; store base pause time

		move.b	#$A,flame_hurtframe(a0)			; set harmful frame ID to $A (broken pipe flamethrower)
		btst	#1,obStatus(a0)				; is flamethrower flipped vertically?
		beq.s	Flame_Action				; if not, branch
		move.b	#2,obAnim(a0)				; use "valve" animations
		move.b	#$15,flame_hurtframe(a0)		; set harmful frame ID to $15 (valve flamethrower)
; ---------------------------------------------------------------------------

Flame_Action:	; Routine 2
		subq.w	#1,flame_timer(a0)			; decrement current timer
		bpl.s	Flame_Animate				; if time remains, branch

		move.w	flame_pausetime(a0),flame_timer(a0)	; begin pause time
		bchg	#0,obAnim(a0)				; toggle between expanding/retracting animations
		beq.s	Flame_Animate				; if on retracting animation now, branch (to pause)

		move.w	flame_firetime(a0),flame_timer(a0)	; flamethrower is expanding again, begin flaming time
		move.w	#sfx_Flamethrower,d0			; set flamethrower sound
		jsr	(QueueSound2).l				; play it

Flame_Animate:
		lea	(Ani_Flame).l,a1			; load animation scripts
		bsr.w	AnimateSprite				; (stays on last 1/2 frames per animation indefinitely)

		move.b	#col_none,obColType(a0)			; make flamethrower harmless by default
		move.b	flame_hurtframe(a0),d0			; get specified harmful frame ID
		cmp.b	obFrame(a0),d0				; is current frame in the animation script a harmful one?
		bne.s	.display				; if not, branch
		move.b	#col_24x48|col_hurt,obColType(a0)	; make flamethrower harmless

	.display:
		out_of_range.w	DeleteObject			; has object gone out of range? if yes, delete it
		bra.w	DisplaySprite				; display flamethrower sprite

; ===========================================================================

		include	"_anim/Flamethrower.asm"
Map_Flame:	include	"_maps/Flamethrower.asm"
