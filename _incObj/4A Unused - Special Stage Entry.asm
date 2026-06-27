; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4A - unused and unfinished Special Stage entry from beta
; ---------------------------------------------------------------------------

VanishSonic:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Van_Index(pc,d0.w),d1
		jmp	Van_Index(pc,d1.w)
; ===========================================================================
Van_Index:	dc.w Van_ChkPLC-Van_Index
		dc.w Van_DeleteSonic-Van_Index
		dc.w Van_ReloadSonic-Van_Index

van_time:	equ objoff_30		; time for Sonic's disappearance (2 seconds)
; ===========================================================================

Van_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w			; have entry effect pattenrs finished decompressing? (see PLC_Warp)
		beq.s	Van_Main				; if yes, branch
		rts						; otherwise, wait until PLC queue is empty
; ===========================================================================

Van_Main:
		addq.b	#2,obRoutine(a0)			; advance to Van_DeleteSonic
		move.l	#Map_Vanish,obMap(a0)			; set mappings
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)
		move.b	#112/2,obActWid(a0)			; set large sprite display width
		move.w	#ArtTile_Warp,obGfx(a0)			; set art tile
		move.w	#2*60,van_time(a0)			; set time for Sonic's disappearance to 2 seconds
; ---------------------------------------------------------------------------

Van_DeleteSonic: ; Routine 2
		move.w	(v_player+obX).w,obX(a0)		; copy X-position from Sonic
		move.w	(v_player+obY).w,obY(a0)		; copy Y-position from Sonic
		move.b	(v_player+obStatus).w,obStatus(a0)	; copy status flags (i.e. X/Y-flip) from Sonic

		lea	(Ani_Vanish).l,a1			; load animation script
		jsr	(AnimateSprite).l			; (will advance obRoutine on finish)

		cmpi.b	#2,obFrame(a0)				; is frame ID 2 displayed? (once in the animation middle)
		bne.s	.display				; if not, branch
		tst.b	(v_player).w				; has Sonic already been deleted?
		beq.s	.display				; if yes, branch
		move.b	#0,(v_player).w				; delete Sonic object
		move.w	#sfx_SSGoal,d0				; set Special Stage "GOAL" sound
		jsr	(QueueSound2).l				; play it

	.display:
		jmp	(DisplaySprite).l			; display entry sprite
; ===========================================================================

Van_ReloadSonic: ; Routine 4
		subq.w	#1,van_time(a0)				; decrement timer
		bne.s	.return					; if time remains, branch
		move.b	#id_SonicPlayer,(v_player).w		; reload Sonic object
		jmp	(DeleteObject).l			; delete entry object

	.return:
		rts						; wait for timer to run out
