; ---------------------------------------------------------------------------
; Object 7D - hidden points at the end of a level
; ---------------------------------------------------------------------------

HiddenBonus:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bonus_Index(pc,d0.w),d1
		jmp	Bonus_Index(pc,d1.w)
; ===========================================================================
Bonus_Index:	dc.w Bonus_Main-Bonus_Index
		dc.w Bonus_Display-Bonus_Index

bonus_timelen = $30		; length of time to display bonus sprites
; ===========================================================================

Bonus_Main:	; Routine 0
		moveq	#$10,d2
		move.w	d2,d3
		add.w	d3,d3
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	.chkdel
		move.w	obY(a1),d1
		sub.w	obY(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1
		bcc.s	.chkdel
		tst.w	(v_debuguse).w
		bne.s	.chkdel
		tst.b	(f_bigring).w
		bne.s	.chkdel
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bonus,obMap(a0)
		move.w	#$84B6,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#0,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.b	obSubtype(a0),obFrame(a0)
		move.w	#119,bonus_timelen(a0) ; set display time to 2 seconds
		sfx	sfx_Bonus,0,0,0	; play bonus sound
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	.points(pc,d0.w),d0 ; load bonus points array
		jsr	(AddPoints).l

.chkdel:
		out_of_range.s	.delete
		rts	

.delete:
		jmp	(DeleteObject).l

; ===========================================================================
.points:	dc.w 0			; Bonus	points array
		dc.w 1000
		dc.w 100
		dc.w 1
; ===========================================================================

Bonus_Display:	; Routine 2
		subq.w	#1,bonus_timelen(a0) ; decrement display time
		bmi.s	Bonus_Display_Delete		; if time is zero, branch
		out_of_range.s	Bonus_Display_Delete
		jmp	(DisplaySprite).l

Bonus_Display_Delete:	
		jmp	(DeleteObject).l
