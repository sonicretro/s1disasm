; ===========================================================================
; ---------------------------------------------------------------------------
; Object 49 - invisible waterfall sound effect trigger (GHZ)
; ---------------------------------------------------------------------------

WaterSound:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	WSnd_Index(pc,d0.w),d1
		jmp	WSnd_Index(pc,d1.w)
; ===========================================================================
WSnd_Index:	dc.w WSnd_Main-WSnd_Index
		dc.w WSnd_PlaySnd-WSnd_Index
; ===========================================================================

WSnd_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)	; advance to WSnd_PlaySnd
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
; ---------------------------------------------------------------------------

WSnd_PlaySnd:	; Routine 2
		move.b	(v_vblank_byte).w,d0	; get low byte of VBlank counter
		andi.b	#$3F,d0			; only play waterfall sound effect every 64 frames
		bne.s	.chkDel			; branch on other frames
		move.w	#sfx_Waterfall,d0	; set waterfall SFX sound command
		jsr	(QueueSound2).l		; play it

	.chkDel:
		out_of_range.w	DeleteObject	; check if object has gone offscreen and delete it if so
		rts				; return (do not display any sprite)
; ===========================================================================
