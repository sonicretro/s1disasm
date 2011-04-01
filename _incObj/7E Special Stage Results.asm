; ---------------------------------------------------------------------------
; Object 7E - special stage results screen
; ---------------------------------------------------------------------------

SSResult:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SSR_Index(pc,d0.w),d1
		jmp	SSR_Index(pc,d1.w)
; ===========================================================================
SSR_Index:	dc.w SSR_ChkPLC-SSR_Index
		dc.w SSR_Move-SSR_Index
		dc.w SSR_Wait-SSR_Index
		dc.w SSR_RingBonus-SSR_Index
		dc.w SSR_Wait-SSR_Index
		dc.w SSR_Exit-SSR_Index
		dc.w SSR_Wait-SSR_Index
		dc.w SSR_Continue-SSR_Index
		dc.w SSR_Wait-SSR_Index
		dc.w SSR_Exit-SSR_Index
		dc.w loc_C91A-SSR_Index

ssr_mainX:	= $30		; position for card to display on
; ===========================================================================

SSR_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w ; are the pattern load cues empty?
		beq.s	SSR_Main	; if yes, branch
		rts	
; ===========================================================================

SSR_Main:
		movea.l	a0,a1
		lea	(SSR_Config).l,a2
		moveq	#3,d1
		cmpi.w	#50,(v_rings).w	; do you have 50 or more rings?
		bcs.s	SSR_Loop	; if no, branch
		addq.w	#1,d1		; if yes, add 1	to d1 (number of sprites)

	SSR_Loop:
		move.b	#id_SSResult,0(a1)
		move.w	(a2)+,obX(a1)	; load start x-position
		move.w	(a2)+,ssr_mainX(a1) ; load main x-position
		move.w	(a2)+,obScreenY(a1) ; load y-position
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,obFrame(a1)
		move.l	#Map_SSR,obMap(a1)
		move.w	#$8580,obGfx(a1)
		move.b	#0,obRender(a1)
		lea	$40(a1),a1
		dbf	d1,SSR_Loop	; repeat sequence 3 or 4 times

		moveq	#7,d0
		move.b	(v_emeralds).w,d1
		beq.s	loc_C842
		moveq	#0,d0
		cmpi.b	#6,d1		; do you have all chaos	emeralds?
		bne.s	loc_C842	; if not, branch
		moveq	#8,d0		; load "Sonic got them all" text
		move.w	#$18,obX(a0)
		move.w	#$118,ssr_mainX(a0) ; change position of text

loc_C842:
		move.b	d0,obFrame(a0)

SSR_Move:	; Routine 2
		moveq	#$10,d1		; set horizontal speed
		move.w	ssr_mainX(a0),d0
		cmp.w	obX(a0),d0	; has item reached its target position?
		beq.s	loc_C86C	; if yes, branch
		bge.s	SSR_ChgPos
		neg.w	d1

SSR_ChgPos:
		add.w	d1,obX(a0)	; change item's position

loc_C85A:				; XREF: loc_C86C
		move.w	obX(a0),d0
		bmi.s	locret_C86A
		cmpi.w	#$200,d0	; has item moved beyond	$200 on	x-axis?
		bcc.s	locret_C86A	; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

locret_C86A:
		rts	
; ===========================================================================

loc_C86C:				; XREF: SSR_Move
		cmpi.b	#2,obFrame(a0)
		bne.s	loc_C85A
		addq.b	#2,obRoutine(a0)
		move.w	#180,obTimeFrame(a0) ; set time delay to 3 seconds
		move.b	#id_SSRChaos,(v_objspace+$800).w ; load chaos emerald object

SSR_Wait:	; Routine 4, 8, $C, $10
		subq.w	#1,obTimeFrame(a0) ; subtract 1 from time delay
		bne.s	SSR_Display
		addq.b	#2,obRoutine(a0)

SSR_Display:
		bra.w	DisplaySprite
; ===========================================================================

SSR_RingBonus:	; Routine 6
		bsr.w	DisplaySprite
		move.b	#1,(f_endactbonus).w ; set ring bonus update flag
		tst.w	(v_ringbonus).w	; is ring bonus	= zero?
		beq.s	loc_C8C4	; if yes, branch
		subi.w	#10,(v_ringbonus).w ; subtract 10 from ring bonus
		moveq	#10,d0		; add 10 to score
		jsr	AddPoints
		move.b	(v_vbla_byte).w,d0
		andi.b	#3,d0
		bne.s	locret_C8EA
		sfx	sfx_Switch,1	; play "blip" sound
; ===========================================================================

loc_C8C4:
		sfx	sfx_Cash	; play "ker-ching" sound
		addq.b	#2,obRoutine(a0)
		move.w	#180,obTimeFrame(a0) ; set time delay to 3 seconds
		cmpi.w	#50,(v_rings).w	; do you have at least 50 rings?
		bcs.s	locret_C8EA	; if not, branch
		move.w	#60,obTimeFrame(a0) ; set time delay to 1 second
		addq.b	#4,obRoutine(a0) ; goto "SSR_Continue" routine

locret_C8EA:
		rts	
; ===========================================================================

SSR_Exit:	; Routine $A, $12
		move.w	#1,(f_restart).w ; restart level
		bra.w	DisplaySprite
; ===========================================================================

SSR_Continue:	; Routine $E
		move.b	#4,(v_objspace+$6C0+obFrame).w
		move.b	#$14,(v_objspace+$6C0+obRoutine).w
		sfx	sfx_Continue	; play continues jingle
		addq.b	#2,obRoutine(a0)
		move.w	#360,obTimeFrame(a0) ; set time delay to 6 seconds
		bra.w	DisplaySprite
; ===========================================================================

loc_C91A:	; Routine $14
		move.b	(v_vbla_byte).w,d0
		andi.b	#$F,d0
		bne.s	SSR_Display2
		bchg	#0,obFrame(a0)

SSR_Display2:
		bra.w	DisplaySprite
; ===========================================================================
SSR_Config:	dc.w $20, $120,	$C4	; start	x-pos, main x-pos, y-pos
		dc.b 2,	0		; rountine number, frame number
		dc.w $320, $120, $118
		dc.b 2,	1
		dc.w $360, $120, $128
		dc.b 2,	2
		dc.w $1EC, $11C, $C4
		dc.b 2,	3
		dc.w $3A0, $120, $138
		dc.b 2,	6
