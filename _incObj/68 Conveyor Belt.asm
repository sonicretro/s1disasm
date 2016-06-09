; ---------------------------------------------------------------------------
; Object 68 - conveyor belts (SBZ)
; ---------------------------------------------------------------------------

Conveyor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Conv_Index(pc,d0.w),d1
		jmp	Conv_Index(pc,d1.w)
; ===========================================================================
Conv_Index:	dc.w Conv_Main-Conv_Index
		dc.w Conv_Action-Conv_Index

conv_speed = $36
conv_width = $38
; ===========================================================================

Conv_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#128,conv_width(a0) ; set width to 128 pixels
		move.b	obSubtype(a0),d1 ; get object type
		andi.b	#$F,d1		; read only the	2nd digit
		beq.s	.typeis0	; if zero, branch
		move.b	#56,conv_width(a0) ; set width to 56 pixels

.typeis0:
		move.b	obSubtype(a0),d1 ; get object type
		andi.b	#$F0,d1		; read only the	1st digit
		ext.w	d1
		asr.w	#4,d1
		move.w	d1,conv_speed(a0) ; set belt speed

Conv_Action:	; Routine 2
		bsr.s	.movesonic
		out_of_range.s	.delete
		rts	

.delete:
		jmp	(DeleteObject).l
; ===========================================================================

.movesonic:
		moveq	#0,d2
		move.b	conv_width(a0),d2
		move.w	d2,d3
		add.w	d3,d3
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	.notonconveyor
		move.w	obY(a1),d1
		sub.w	obY(a0),d1
		addi.w	#$30,d1
		cmpi.w	#$30,d1
		bcc.s	.notonconveyor
		btst	#1,obStatus(a1)
		bne.s	.notonconveyor
		move.w	conv_speed(a0),d0
		add.w	d0,obX(a1)

.notonconveyor:
		rts	
