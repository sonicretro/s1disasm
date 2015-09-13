; ---------------------------------------------------------------------------
; Object 18 - platforms	(GHZ, SYZ, SLZ)
; ---------------------------------------------------------------------------

BasicPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Plat_Index(pc,d0.w),d1
		jmp	Plat_Index(pc,d1.w)
; ===========================================================================
Plat_Index:	dc.w Plat_Main-Plat_Index
		dc.w Plat_Solid-Plat_Index
		dc.w Plat_Action2-Plat_Index
		dc.w Plat_Delete-Plat_Index
		dc.w Plat_Action-Plat_Index
; ===========================================================================

Plat_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$4000,obGfx(a0)
		move.l	#Map_Plat_GHZ,obMap(a0)
		move.b	#$20,obActWid(a0)
		cmpi.b	#id_SYZ,(v_zone).w ; check if level is SYZ
		bne.s	.notSYZ

		move.l	#Map_Plat_SYZ,obMap(a0) ; SYZ specific code
		move.b	#$20,obActWid(a0)

.notSYZ:
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ
		move.l	#Map_Plat_SLZ,obMap(a0) ; SLZ specific code
		move.b	#$20,obActWid(a0)
		move.w	#$4000,obGfx(a0)
		move.b	#3,obSubtype(a0)

.notSLZ:
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.w	obY(a0),$2C(a0)
		move.w	obY(a0),$34(a0)
		move.w	obX(a0),$32(a0)
		move.w	#$80,obAngle(a0)
		moveq	#0,d1
		move.b	obSubtype(a0),d0
		cmpi.b	#$A,d0		; is object type $A (large platform)?
		bne.s	.setframe	; if not, branch
		addq.b	#1,d1		; use frame #1
		move.b	#$20,obActWid(a0) ; set width

.setframe:
		move.b	d1,obFrame(a0)	; set frame to d1

Plat_Solid:	; Routine 2
		tst.b	$38(a0)
		beq.s	loc_7EE0
		subq.b	#4,$38(a0)

loc_7EE0:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	PlatformObject

Plat_Action:	; Routine 8
		bsr.w	Plat_Move
		bsr.w	Plat_Nudge
		bsr.w	DisplaySprite
		bra.w	Plat_ChkDel
; ===========================================================================

Plat_Action2:	; Routine 4
		cmpi.b	#$40,$38(a0)
		beq.s	loc_7F06
		addq.b	#4,$38(a0)

loc_7F06:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	ExitPlatform
		move.w	obX(a0),-(sp)
		bsr.w	Plat_Move
		bsr.w	Plat_Nudge
		move.w	(sp)+,d2
		bsr.w	MvSonicOnPtfm2
		bsr.w	DisplaySprite
		bra.w	Plat_ChkDel

		rts

; ---------------------------------------------------------------------------
; Subroutine to	move platform slightly when you	stand on it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Plat_Nudge:
		move.b	$38(a0),d0
		bsr.w	CalcSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	$2C(a0),d0
		move.w	d0,obY(a0)
		rts	
; End of function Plat_Nudge

; ---------------------------------------------------------------------------
; Subroutine to	move platforms
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Plat_Move:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	.index(pc,d0.w),d1
		jmp	.index(pc,d1.w)
; End of function Plat_Move

; ===========================================================================
.index:		dc.w .type00-.index, .type01-.index
		dc.w .type02-.index, .type03-.index
		dc.w .type04-.index, .type05-.index
		dc.w .type06-.index, .type07-.index
		dc.w .type08-.index, .type00-.index
		dc.w .type0A-.index, .type0B-.index
		dc.w .type0C-.index
; ===========================================================================

.type00:
		rts			; platform 00 doesn't move
; ===========================================================================

.type05:
		move.w	$32(a0),d0
		move.b	obAngle(a0),d1	; load platform-motion variable
		neg.b	d1		; reverse platform-motion
		addi.b	#$40,d1
		bra.s	.type01_move
; ===========================================================================

.type01:
		move.w	$32(a0),d0
		move.b	obAngle(a0),d1	; load platform-motion variable
		subi.b	#$40,d1

.type01_move:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,obX(a0)	; change position on x-axis
		bra.w	.chgmotion
; ===========================================================================

.type0C:
		move.w	$34(a0),d0
		move.b	(v_oscillate+$E).w,d1 ; load platform-motion variable
		neg.b	d1		; reverse platform-motion
		addi.b	#$30,d1
		bra.s	.type02_move
; ===========================================================================

.type0B:
		move.w	$34(a0),d0
		move.b	(v_oscillate+$E).w,d1 ; load platform-motion variable
		subi.b	#$30,d1
		bra.s	.type02_move
; ===========================================================================

.type06:
		move.w	$34(a0),d0
		move.b	obAngle(a0),d1	; load platform-motion variable
		neg.b	d1		; reverse platform-motion
		addi.b	#$40,d1
		bra.s	.type02_move
; ===========================================================================

.type02:
		move.w	$34(a0),d0
		move.b	obAngle(a0),d1	; load platform-motion variable
		subi.b	#$40,d1

.type02_move:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$2C(a0)	; change position on y-axis
		bra.w	.chgmotion
; ===========================================================================

.type03:
		tst.w	$3A(a0)		; is time delay	set?
		bne.s	.type03_wait	; if yes, branch
		btst	#3,obStatus(a0)	; is Sonic standing on the platform?
		beq.s	.type03_nomove	; if not, branch
		move.w	#30,$3A(a0)	; set time delay to 0.5	seconds

.type03_nomove:
		rts	

.type03_wait:
		subq.w	#1,$3A(a0)	; subtract 1 from time
		bne.s	.type03_nomove	; if time is > 0, branch
		move.w	#32,$3A(a0)
		addq.b	#1,obSubtype(a0) ; change to type 04 (falling)
		rts	
; ===========================================================================

.type04:
		tst.w	$3A(a0)
		beq.s	.loc_8048
		subq.w	#1,$3A(a0)
		bne.s	.loc_8048
		btst	#3,obStatus(a0)
		beq.s	.loc_8042
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	$25(a0)
		move.w	obVelY(a0),obVelY(a1)

.loc_8042:
		move.b	#8,obRoutine(a0)

.loc_8048:
		move.l	$2C(a0),d3
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,$2C(a0)
		addi.w	#$38,obVelY(a0)
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	$2C(a0),d0
		bcc.s	.locret_8074
		move.b	#6,obRoutine(a0)

.locret_8074:
		rts	
; ===========================================================================

.type07:
		tst.w	$3A(a0)		; is time delay	set?
		bne.s	.type07_wait	; if yes, branch
		lea	(f_switch).w,a2	; load switch statuses
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; move object type ($x7) to d0
		lsr.w	#4,d0		; divide d0 by 8, round	down
		tst.b	(a2,d0.w)	; has switch no. d0 been pressed?
		beq.s	.type07_nomove	; if not, branch
		move.w	#60,$3A(a0)	; set time delay to 1 second

.type07_nomove:
		rts	

.type07_wait:
		subq.w	#1,$3A(a0)	; subtract 1 from time delay
		bne.s	.type07_nomove	; if time is > 0, branch
		addq.b	#1,obSubtype(a0) ; change to type 08
		rts	
; ===========================================================================

.type08:
		subq.w	#2,$2C(a0)	; move platform	up
		move.w	$34(a0),d0
		subi.w	#$200,d0
		cmp.w	$2C(a0),d0	; has platform moved $200 pixels?
		bne.s	.type08_nostop	; if not, branch
		clr.b	obSubtype(a0)	; change to type 00 (stop moving)

.type08_nostop:
		rts	
; ===========================================================================

.type0A:
		move.w	$34(a0),d0
		move.b	obAngle(a0),d1	; load platform-motion variable
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)	; change position on y-axis

.chgmotion:
		move.b	(v_oscillate+$1A).w,$26(a0) ; update platform-movement variable
		rts	
; ===========================================================================

Plat_ChkDel:
		out_of_range.s	Plat_Delete,$32(a0)
		rts	
; ===========================================================================

Plat_Delete:	; Routine 6
		bra.w	DeleteObject
