; ---------------------------------------------------------------------------
; Object 5D - fans (SLZ)
; ---------------------------------------------------------------------------

Fan:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Fan_Index(pc,d0.w),d1
		jmp	Fan_Index(pc,d1.w)
; ===========================================================================
Fan_Index:	dc.w Fan_Main-Fan_Index
		dc.w Fan_Delay-Fan_Index

fan_time = $30		; time between switching on/off
fan_switch = $32		; on/off switch
; ===========================================================================

Fan_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Fan,obMap(a0)
		move.w	#$43A0,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)

Fan_Delay:	; Routine 2
		btst	#1,obSubtype(a0) ; is object type 02/03 (always on)?
		bne.s	.blow		; if yes, branch
		subq.w	#1,fan_time(a0)	; subtract 1 from time delay
		bpl.s	.blow		; if time remains, branch
		move.w	#120,fan_time(a0) ; set delay to 2 seconds
		bchg	#0,fan_switch(a0) ; switch fan on/off
		beq.s	.blow		; if fan is off, branch
		move.w	#180,fan_time(a0) ; set delay to 3 seconds

.blow:
		tst.b	fan_switch(a0)	; is fan switched on?
		bne.w	.chkdel		; if not, branch
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		btst	#0,obStatus(a0)	; is fan facing right?
		bne.s	.chksonic	; if yes, branch
		neg.w	d0

.chksonic:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0		; is Sonic more	than $A0 pixels	from the fan?
		bcc.s	.animate	; if yes, branch
		move.w	obY(a1),d1
		addi.w	#$60,d1
		sub.w	obY(a0),d1
		bcs.s	.animate	; branch if Sonic is too low
		cmpi.w	#$70,d1
		bcc.s	.animate	; branch if Sonic is too high
		subi.w	#$50,d0		; is Sonic more than $50 pixels from the fan?
		bcc.s	.faraway	; if yes, branch
		not.w	d0
		add.w	d0,d0

.faraway:
		addi.w	#$60,d0
		btst	#0,obStatus(a0)	; is fan facing right?
		bne.s	.right		; if yes, branch
		neg.w	d0

.right:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,obSubtype(a0)
		beq.s	.movesonic
		neg.w	d0

.movesonic:
		add.w	d0,obX(a1)	; push Sonic away from the fan

.animate:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.chkdel
		move.b	#0,obTimeFrame(a0)
		addq.b	#1,obAniFrame(a0)
		cmpi.b	#3,obAniFrame(a0)
		bcs.s	.noreset
		move.b	#0,obAniFrame(a0) ; reset after 4 frames

.noreset:
		moveq	#0,d0
		btst	#0,obSubtype(a0)
		beq.s	.noflip
		moveq	#2,d0

.noflip:
		add.b	obAniFrame(a0),d0
		move.b	d0,obFrame(a0)

.chkdel:
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts	
