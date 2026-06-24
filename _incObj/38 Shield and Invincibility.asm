; ---------------------------------------------------------------------------
; Object 38 - shield and invincibility stars
; ---------------------------------------------------------------------------

ShieldItem:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Shi_Index(pc,d0.w),d1
		jmp	Shi_Index(pc,d1.w)
; ===========================================================================
Shi_Index:	dc.w Shi_Main-Shi_Index
		dc.w Shi_Shield-Shi_Index
		dc.w Shi_Stars-Shi_Index

stars_lag:	equ objoff_30		; lag index before stars update position again
; ===========================================================================

Shi_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Shi_Shield
		move.l	#Map_Shield,obMap(a0)			; set shield mappings
		move.b	#sprite_cam_field,obRender(a0)		; set playfield-positioning mode
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)
		move.b	#32/2,obActWid(a0)			; set sprite display width

		tst.b	obAnim(a0)				; is object a shield?
		bne.s	.stars					; if not, branch
		move.w	#ArtTile_Shield,obGfx(a0)		; shield-specific art tile
		rts						; return

	.stars:
		addq.b	#2,obRoutine(a0)			; advance to Shi_Stars
		move.w	#ArtTile_Invincibility,obGfx(a0)	; stars-specific art tile
		rts						; return
; ===========================================================================

Shi_Shield:	; Routine 2
		tst.b	(v_invinc).w				; has Sonic gained invincibility after already having a shield?
		bne.s	.hide					; if yes, hide shield sprite
		tst.b	(v_shield).w				; has Sonic lost the shield?
		beq.s	.delete					; if yes, delete it

		move.w	(v_player+obX).w,obX(a0)		; keep copying Sonic's X-position
		move.w	(v_player+obY).w,obY(a0)		; keep copying Sonic's Y-position
		move.b	(v_player+obStatus).w,obStatus(a0)	; keep Sonic's status flags for rendering
		lea	(Ani_Shield).l,a1			; load shield animation script
		jsr	(AnimateSprite).l			; keep animating shield
		jmp	(DisplaySprite).l			; display shield sprite

	.hide:
		rts						; hide shield sprite but don't delete it

	.delete:
		jmp	(DeleteObject).l			; delete shield object
; ===========================================================================

Shi_Stars:	; Routine 4
		tst.b	(v_invinc).w				; has invincibility run out?
		beq.s	Shi_Start_Delete			; if yes, delete stars object

		move.w	(v_trackpos).w,d0			; get index value for tracking data
		move.b	obAnim(a0),d1				; get stars animation ID (1-4)
		subq.b	#1,d1					; make it 0-based
		bra.s	.trail					; skip over dead code

; ===========================================================================
; unused older trailing code that makes a much shorter trail
	; .trail_unused:
		lsl.b	#4,d1					; multiply animation ID by 16
		addq.b	#4,d1
		sub.b	d1,d0
		move.b	stars_lag(a0),d1
		sub.b	d1,d0					; use earlier tracking data to create trail
		addq.b	#4,d1
		andi.b	#$F,d1
		move.b	d1,stars_lag(a0)
		bra.s	.updateStars
; ===========================================================================

	.trail:
		lsl.b	#3,d1					; multiply animation ID by 8
		move.b	d1,d2
		add.b	d1,d1
		add.b	d2,d1					; multiply by 3
		addq.b	#4,d1					; advance to next recorded position array index
		sub.b	d1,d0					; d0 = base index for animation ID

		; This makes stars effectively only update position every 6 frames to create a small jitter effect
		move.b	stars_lag(a0),d1			; get previous lag value
		sub.b	d1,d0					; subtract lag value use earlier tracking data to create trail
		addq.b	#4,d1					; increment lag value to previous recording array index
		cmpi.b	#6*4,d1					; has lag value exceeded limit? (=$18)
		blo.s	.updateLag				; if not, branch
		moveq	#0,d1					; reset lag value
	;.a:
	.updateLag:
		move.b	d1,stars_lag(a0)			; update lag value for next run

	; .b:
	.updateStars:
		lea	(v_tracksonic).w,a1			; load Sonic's recorded position data array (each entry is 4 bytes, a word per X/Y)
		lea	(a1,d0.w),a1				; go to desired recorded position
		move.w	(a1)+,obX(a0)				; set new X-position
		move.w	(a1)+,obY(a0)				; set new Y-position
		move.b	(v_player+obStatus).w,obStatus(a0)	; keep Sonic's status flags for rendering
		lea	(Ani_Shield).l,a1			; load stars animation script (bundled with shield animations)
		jsr	(AnimateSprite).l			; keep animating stars
		jmp	(DisplaySprite).l			; keep displaying stars
; ===========================================================================

Shi_Start_Delete:	
		jmp	(DeleteObject).l			; delete invincibility stars object
