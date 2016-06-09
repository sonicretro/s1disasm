; ---------------------------------------------------------------------------
; Object 57 - spiked balls (SYZ, LZ)
; ---------------------------------------------------------------------------

SpikeBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SBall_Index(pc,d0.w),d1
		jmp	SBall_Index(pc,d1.w)
; ===========================================================================
SBall_Index:	dc.w SBall_Main-SBall_Index
		dc.w SBall_Move-SBall_Index
		dc.w SBall_Display-SBall_Index

sball_childs = $29		; number of child objects (1 byte)
		; $30-$37	; object RAM numbers of childs (1 byte each)
sball_origX = $3A		; centre x-axis position (2 bytes)
sball_origY = $38		; centre y-axis position (2 bytes)
sball_radius = $3C		; radius (1 byte)
sball_speed = $3E		; rate of spin (2 bytes)
; ===========================================================================

SBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_SBall,obMap(a0)
		move.w	#$3BA,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	obX(a0),sball_origX(a0)
		move.w	obY(a0),sball_origY(a0)
		move.b	#$98,obColType(a0) ; SYZ specific code (chain hurts Sonic)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	.notlz

		move.b	#0,obColType(a0) ; LZ specific code (chain doesn't hurt)
		move.w	#$310,obGfx(a0)
		move.l	#Map_SBall2,obMap(a0)

.notlz:
		move.b	obSubtype(a0),d1 ; get object type
		andi.b	#$F0,d1		; read only the	1st digit
		ext.w	d1
		asl.w	#3,d1		; multiply by 8
		move.w	d1,sball_speed(a0) ; set object twirl speed
		move.b	obStatus(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,obAngle(a0)
		lea	sball_childs(a0),a2
		move.b	obSubtype(a0),d1 ; get object type
		andi.w	#7,d1		; read only the	2nd digit
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,sball_radius(a0)
		subq.w	#1,d1		; set chain length (type-1)
		bcs.s	.fail
		btst	#3,obSubtype(a0)
		beq.s	.makechain
		subq.w	#1,d1
		bcs.s	.fail

.makechain:
		bsr.w	FindFreeObj
		bne.s	.fail
		addq.b	#1,sball_childs(a0) ; increment child object counter
		move.w	a1,d5		; get child object RAM address
		subi.w	#$D000,d5	; subtract $D000
		lsr.w	#6,d5		; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+	; copy child RAM number
		move.b	#4,obRoutine(a1)
		_move.b	0(a0),0(a1)
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obRender(a0),obRender(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	obColType(a0),obColType(a1)
		subi.b	#$10,d3
		move.b	d3,sball_radius(a1)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	.notlzagain

		tst.b	d3
		bne.s	.notlzagain
		move.b	#2,obFrame(a1)	; use different frame for LZ chain

.notlzagain:
		dbf	d1,.makechain ; repeat for length of chain

.fail:
		move.w	a0,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	SBall_Move

		move.b	#$8B,obColType(a0) ; if yes, make last spikeball larger
		move.b	#1,obFrame(a0)	; use different	frame

SBall_Move:	; Routine 2
		bsr.w	.movesub
		bra.w	.chkdel
; ===========================================================================

.movesub:
		move.w	sball_speed(a0),d0
		add.w	d0,obAngle(a0)
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		move.w	sball_origY(a0),d2
		move.w	sball_origX(a0),d3
		lea	sball_childs(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

.loop:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	sball_radius(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,obY(a1)
		move.w	d5,obX(a1)
		dbf	d6,.loop
		rts	
; ===========================================================================

.chkdel:
		out_of_range.w	.delete,sball_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================

.delete:
		moveq	#0,d2
		lea	sball_childs(a0),a2
		move.b	(a2)+,d2

.deleteloop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,.deleteloop ; delete all pieces of	chain

		rts	
; ===========================================================================

SBall_Display:	; Routine 4
		bra.w	DisplaySprite
