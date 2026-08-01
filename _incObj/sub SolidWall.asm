; ===========================================================================
; ---------------------------------------------------------------------------
; Solid	object subroutine used by Object 44.
; This is essentially a very stripped-down version of SolidObject.
;
; input:
;	d1 = width
;	d2 = height / 2
;
; output:
;	d4 = collision type: 0 = none; 1 = side collision; -1 = top/bottom collision
; ---------------------------------------------------------------------------

EdgeWall_SolidWall:
		bsr.w	EdgeWall_ChkCollision
		beq.s	.no_collision				; branch if no collision
		bmi.w	.topbottom				; branch if top/bottom collision
		tst.w	d0					; where is Sonic?
		beq.w	.centre					; if inside the object, branch
		bmi.s	.right					; if right of the object, branch
		tst.w	obVelX(a1)				; is Sonic moving left?
		bmi.s	.centre					; if yes, branch
		bra.s	.left
; ===========================================================================

.right:
		tst.w	obVelX(a1)				; is Sonic moving right?
		bpl.s	.centre					; if yes, branch

.left:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)				; stop Sonic moving

.centre:
		btst	#1,obStatus(a1)				; is Sonic in the air?
		bne.s	.air					; if yes, branch
		bset	#5,obStatus(a1)				; make Sonic push object
		bset	#5,obStatus(a0)				; make object be pushed
		rts
; ===========================================================================

.no_collision:
		btst	#5,obStatus(a0)				; is Sonic pushing?
		beq.s	.exit					; if not, branch
	if FixBugs=0
		; This causes the infamous "walk-jump bug"
		move.w	#id_Run,obAnim(a1)			; use running animation
	endif

.air:
		bclr	#5,obStatus(a0)				; clear pushing flag
		bclr	#5,obStatus(a1)				; clear Sonic's pushing flag

	.exit:
		rts
; ===========================================================================

.topbottom:
		tst.w	obVelY(a1)				; is Sonic moving downwards?
		bpl.s	.exit2					; if yes, branch
		tst.w	d3					; is Sonic above the object?
		bpl.s	.exit2					; if yes, branch
		sub.w	d3,obY(a1)				; correct Sonic's position
		move.w	#0,obVelY(a1)				; stop Sonic moving

	.exit2:
		rts
; ===========================================================================

EdgeWall_ChkCollision:
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0				; d0: +ve if Sonic is right; -ve if Sonic is left
		add.w	d1,d0					; add width of object
		bmi.s	Edge_Ignore				; branch if Sonic is outside left boundary
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	Edge_Ignore				; branch if Sonic is outside right boundary

		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2					; add obHeight to stated height
		move.w	obY(a1),d3
		sub.w	obY(a0),d3				; d3: +ve if Sonic is below; -ve if Sonic is above
		add.w	d2,d3					; add total height of object
		bmi.s	Edge_Ignore				; branch if Sonic is outside upper boundary
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	Edge_Ignore				; branch if Sonic is outside lower boundary

		tst.b	(f_playerctrl).w			; are controls locked?
		bmi.s	Edge_Ignore				; if yes, branch
		cmpi.b	#6,(v_player+obRoutine).w		; is Sonic dying?
		bhs.s	Edge_Ignore				; if yes, branch
		tst.w	(v_debuguse).w				; is debug mode being used?
		bne.s	Edge_Ignore				; if yes, branch
		move.w	d0,d5
		cmp.w	d0,d1					; is Sonic right of centre of object?
		bhs.s	.isright				; if yes, branch
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

	.isright:
		move.w	d3,d1
		cmp.w	d3,d2					; is Sonic below centre of object?
		bhs.s	.isbelow				; if yes, branch
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

	.isbelow:
		cmp.w	d1,d5
		bhi.s	Edge_TopBottom
		moveq	#1,d4					; return side collision
		rts
; ===========================================================================

Edge_TopBottom:
		moveq	#-1,d4					; return top/bottom collision
		rts
; ===========================================================================

Edge_Ignore:
		moveq	#0,d4					; return no collision
		rts
; End of function EdgeWall_SolidWall