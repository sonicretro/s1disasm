; ---------------------------------------------------------------------------
; Object 70 - large girder block (SBZ)
; ---------------------------------------------------------------------------

Girder:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Gird_Index(pc,d0.w),d1
		jmp	Gird_Index(pc,d1.w)
; ===========================================================================
Gird_Index:	dc.w Gird_Main-Gird_Index
		dc.w Gird_Action-Gird_Index

gird_height:	= $16
gird_origX:	= $32		; original x-axis position
gird_origY:	= $30		; original y-axis position
gird_time:	= $34		; duration for movement in a direction
gird_set:	= $38		; which movement settings to use (0/8/16/24)
gird_delay:	= $3A		; delay for movement
; ===========================================================================

Gird_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Gird,obMap(a0)
		move.w	#$42F0,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$60,obActWid(a0)
		move.b	#$18,gird_height(a0)
		move.w	obX(a0),gird_origX(a0)
		move.w	obY(a0),gird_origY(a0)
		bsr.w	Gird_ChgMove

Gird_Action:	; Routine 2
		move.w	obX(a0),-(sp)
		tst.w	gird_delay(a0)
		beq.s	@beginmove
		subq.w	#1,gird_delay(a0)
		bne.s	@solid

	@beginmove:
		jsr	SpeedToPos
		subq.w	#1,gird_time(a0) ; decrement movement duration
		bne.s	@solid		; if time remains, branch
		bsr.w	Gird_ChgMove	; if time is zero, branch

	@solid:
		move.w	(sp)+,d4
		tst.b	obRender(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	gird_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

	@chkdel:
		out_of_range.s	@delete,gird_origX(a0)
		jmp	DisplaySprite

	@delete:
		jmp	DeleteObject
; ===========================================================================

Gird_ChgMove:
		move.b	gird_set(a0),d0
		andi.w	#$18,d0
		lea	(@settings).l,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,obVelX(a0)
		move.w	(a1)+,obVelY(a0)
		move.w	(a1)+,gird_time(a0)
		addq.b	#8,gird_set(a0)	; use next settings
		move.w	#7,gird_delay(a0)
		rts	
; ===========================================================================
@settings:	;   x-speed, y-speed, duration
		dc.w   $100,	 0,   $60,     0 ; right
		dc.w	  0,  $100,   $30,     0 ; down
		dc.w  -$100,  -$40,   $60,     0 ; up/left
		dc.w	  0, -$100,   $18,     0 ; up
