; ---------------------------------------------------------------------------
; Object 49 - waterfall sound effect (GHZ)
; ---------------------------------------------------------------------------

WaterSound:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	WSnd_Index(pc,d0.w),d1
		jmp	WSnd_Index(pc,d1.w)
; ===========================================================================
WSnd_Index:	offsetTable
		ptr WSnd_Main
		ptr WSnd_PlaySnd
; ===========================================================================

WSnd_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#4,obRender(a0)

WSnd_PlaySnd:	; Routine 2
		move.b	(v_vblank_byte).w,d0 ; get low byte of VBlank counter
		andi.b	#$3F,d0
		bne.s	WSnd_ChkDel
		move.w	#sfx_Waterfall,d0
		jsr	(QueueSound2).l	; play waterfall sound

WSnd_ChkDel:
		out_of_range.w	DeleteObject
		rts
