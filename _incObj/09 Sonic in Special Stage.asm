; ---------------------------------------------------------------------------
; Object 09 - Sonic (special stage)
; ---------------------------------------------------------------------------

SonicSpecial:				; XREF: Obj_Index
		tst.w	(v_debuguse).w	; is debug mode	being used?
		beq.s	Obj09_Normal	; if not, branch
		bsr.w	SS_FixCamera
		bra.w	DebugMode
; ===========================================================================

Obj09_Normal:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj09_Index(pc,d0.w),d1
		jmp	Obj09_Index(pc,d1.w)
; ===========================================================================
Obj09_Index:	dc.w Obj09_Main-Obj09_Index
		dc.w Obj09_ChkDebug-Obj09_Index
		dc.w Obj09_ExitStage-Obj09_Index
		dc.w Obj09_Exit2-Obj09_Index
; ===========================================================================

Obj09_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#0,obPriority(a0)
		move.b	#id_Roll,obAnim(a0)
		bset	#2,obStatus(a0)
		bset	#1,obStatus(a0)

Obj09_ChkDebug:	; Routine 2
		tst.w	(f_debugmode).w	; is debug mode	cheat enabled?
		beq.s	Obj09_NoDebug	; if not, branch
		btst	#bitB,(v_jpadpress1).w ; is button B pressed?
		beq.s	Obj09_NoDebug	; if not, branch
		move.w	#1,(v_debuguse).w ; change Sonic into a ring

Obj09_NoDebug:
		move.b	#0,$30(a0)
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#2,d0
		move.w	Obj09_Modes(pc,d0.w),d1
		jsr	Obj09_Modes(pc,d1.w)
		jsr	Sonic_LoadGfx
		jmp	DisplaySprite
; ===========================================================================
Obj09_Modes:	dc.w Obj09_OnWall-Obj09_Modes
		dc.w Obj09_InAir-Obj09_Modes
; ===========================================================================

Obj09_OnWall:				; XREF: Obj09_Modes
		bsr.w	Obj09_Jump
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall
		bra.s	Obj09_Display
; ===========================================================================

Obj09_InAir:				; XREF: Obj09_Modes
		bsr.w	nullsub_2
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall

Obj09_Display:				; XREF: Obj09_OnWall
		bsr.w	Obj09_ChkItems
		bsr.w	Obj09_ChkItems2
		jsr	SpeedToPos
		bsr.w	SS_FixCamera
		move.w	(v_ssangle).w,d0
		add.w	(v_ssrotate).w,d0
		move.w	d0,(v_ssangle).w
		jsr	Sonic_Animate
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_Move:				; XREF: Obj09_OnWall; Obj09_InAir
		btst	#bitL,(v_jpadhold2).w ; is left being pressed?
		beq.s	Obj09_ChkRight	; if not, branch
		bsr.w	Obj09_MoveLeft

Obj09_ChkRight:
		btst	#bitR,(v_jpadhold2).w ; is right being pressed?
		beq.s	loc_1BA78	; if not, branch
		bsr.w	Obj09_MoveRight

loc_1BA78:
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	loc_1BAA8
		move.w	obInertia(a0),d0
		beq.s	loc_1BAA8
		bmi.s	loc_1BA9A
		subi.w	#$C,d0
		bcc.s	loc_1BA94
		move.w	#0,d0

loc_1BA94:
		move.w	d0,obInertia(a0)
		bra.s	loc_1BAA8
; ===========================================================================

loc_1BA9A:
		addi.w	#$C,d0
		bcc.s	loc_1BAA4
		move.w	#0,d0

loc_1BAA4:
		move.w	d0,obInertia(a0)

loc_1BAA8:
		move.b	(v_ssangle).w,d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d1
		add.l	d1,obX(a0)
		muls.w	obInertia(a0),d0
		add.l	d0,obY(a0)
		movem.l	d0-d1,-(sp)
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		bsr.w	sub_1BCE8
		beq.s	loc_1BAF2
		movem.l	(sp)+,d0-d1
		sub.l	d1,obX(a0)
		sub.l	d0,obY(a0)
		move.w	#0,obInertia(a0)
		rts	
; ===========================================================================

loc_1BAF2:
		movem.l	(sp)+,d0-d1
		rts	
; End of function Obj09_Move


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_MoveLeft:				; XREF: Obj09_Move
		bset	#0,obStatus(a0)
		move.w	obInertia(a0),d0
		beq.s	loc_1BB06
		bpl.s	loc_1BB1A

loc_1BB06:
		subi.w	#$C,d0
		cmpi.w	#-$800,d0
		bgt.s	loc_1BB14
		move.w	#-$800,d0

loc_1BB14:
		move.w	d0,obInertia(a0)
		rts	
; ===========================================================================

loc_1BB1A:
		subi.w	#$40,d0
		bcc.s	loc_1BB22
		nop	

loc_1BB22:
		move.w	d0,obInertia(a0)
		rts	
; End of function Obj09_MoveLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_MoveRight:			; XREF: Obj09_Move
		bclr	#0,obStatus(a0)
		move.w	obInertia(a0),d0
		bmi.s	loc_1BB48
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_1BB42
		move.w	#$800,d0

loc_1BB42:
		move.w	d0,obInertia(a0)
		bra.s	locret_1BB54
; ===========================================================================

loc_1BB48:
		addi.w	#$40,d0
		bcc.s	loc_1BB50
		nop	

loc_1BB50:
		move.w	d0,obInertia(a0)

locret_1BB54:
		rts	
; End of function Obj09_MoveRight


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_Jump:				; XREF: Obj09_OnWall
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0	; is A,	B or C pressed?
		beq.s	Obj09_NoJump	; if not, branch
		move.b	(v_ssangle).w,d0
		andi.b	#$FC,d0
		neg.b	d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		bset	#1,obStatus(a0)
		sfx	sfx_Jump	; play jumping sound

Obj09_NoJump:
		rts	
; End of function Obj09_Jump


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


nullsub_2:				; XREF: Obj09_InAir
		rts	
; End of function nullsub_2

; ===========================================================================
; ---------------------------------------------------------------------------
; unused subroutine to limit Sonic's upward vertical speed
; ---------------------------------------------------------------------------
		move.w	#-$400,d1
		cmp.w	obVelY(a0),d1
		ble.s	locret_1BBB4
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnABC,d0
		bne.s	locret_1BBB4
		move.w	d1,obVelY(a0)

locret_1BBB4:
		rts	
; ---------------------------------------------------------------------------
; Subroutine to	fix the	camera on Sonic's position (special stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_FixCamera:				; XREF: Obj09
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		move.w	(v_screenposx).w,d0
		subi.w	#$A0,d3
		bcs.s	loc_1BBCE
		sub.w	d3,d0
		sub.w	d0,(v_screenposx).w

loc_1BBCE:
		move.w	(v_screenposy).w,d0
		subi.w	#$70,d2
		bcs.s	locret_1BBDE
		sub.w	d2,d0
		sub.w	d0,(v_screenposy).w

locret_1BBDE:
		rts	
; End of function SS_FixCamera

; ===========================================================================

Obj09_ExitStage:			; XREF: Obj09_Index
		addi.w	#$40,(v_ssrotate).w
		cmpi.w	#$1800,(v_ssrotate).w
		bne.s	loc_1BBF4
		move.b	#id_Level,(v_gamemode).w

loc_1BBF4:
		cmpi.w	#$3000,(v_ssrotate).w
		blt.s	loc_1BC12
		move.w	#0,(v_ssrotate).w
		move.w	#$4000,(v_ssangle).w
		addq.b	#2,obRoutine(a0)
		move.w	#$3C,$38(a0)

loc_1BC12:
		move.w	(v_ssangle).w,d0
		add.w	(v_ssrotate).w,d0
		move.w	d0,(v_ssangle).w
		jsr	Sonic_Animate
		jsr	Sonic_LoadGfx
		bsr.w	SS_FixCamera
		jmp	DisplaySprite
; ===========================================================================

Obj09_Exit2:				; XREF: Obj09_Index
		subq.w	#1,$38(a0)
		bne.s	loc_1BC40
		move.b	#id_Level,(v_gamemode).w

loc_1BC40:
		jsr	Sonic_Animate
		jsr	Sonic_LoadGfx
		bsr.w	SS_FixCamera
		jmp	DisplaySprite

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_Fall:				; XREF: Obj09_OnWall; Obj09_InAir
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		move.b	(v_ssangle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	obVelX(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0
		add.l	d4,d0
		move.w	obVelY(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1
		add.l	d4,d1
		add.l	d0,d3
		bsr.w	sub_1BCE8
		beq.s	loc_1BCB0
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,obVelX(a0)
		bclr	#1,obStatus(a0)
		add.l	d1,d2
		bsr.w	sub_1BCE8
		beq.s	loc_1BCC6
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,obVelY(a0)
		rts	
; ===========================================================================

loc_1BCB0:
		add.l	d1,d2
		bsr.w	sub_1BCE8
		beq.s	loc_1BCD4
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,obVelY(a0)
		bclr	#1,obStatus(a0)

loc_1BCC6:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,obVelX(a0)
		move.w	d1,obVelY(a0)
		rts	
; ===========================================================================

loc_1BCD4:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,obVelX(a0)
		move.w	d1,obVelY(a0)
		bset	#1,obStatus(a0)
		rts	
; End of function Obj09_Fall


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1BCE8:				; XREF: Obj09_Move; Obj09_Fall
		lea	($FF0000).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		adda.w	#$7E,a1
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		tst.b	d5
		rts	
; End of function sub_1BCE8


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1BD30:				; XREF: sub_1BCE8
		beq.s	locret_1BD44
		cmpi.b	#$28,d4
		beq.s	locret_1BD44
		cmpi.b	#$3A,d4
		bcs.s	loc_1BD46
		cmpi.b	#$4B,d4
		bcc.s	loc_1BD46

locret_1BD44:
		rts	
; ===========================================================================

loc_1BD46:
		move.b	d4,$30(a0)
		move.l	a1,$32(a0)
		moveq	#-1,d5
		rts	
; End of function sub_1BD30


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_ChkItems:				; XREF: Obj09_Display
		lea	($FF0000).l,a1
		moveq	#0,d4
		move.w	obY(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	obX(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	Obj09_ChkCont
		tst.b	$3A(a0)
		bne.w	Obj09_MakeGhostSolid
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_ChkCont:
		cmpi.b	#$3A,d4		; is the item a	ring?
		bne.s	Obj09_Chk1Up
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GetCont
		move.b	#1,(a2)
		move.l	a1,4(a2)

Obj09_GetCont:
		jsr	CollectRing
		cmpi.w	#50,(v_rings).w	; check if you have 50 rings
		bcs.s	Obj09_NoCont
		bset	#0,(v_lifecount).w
		bne.s	Obj09_NoCont
		addq.b	#1,(v_continues).w ; add 1 to number of continues
		move.w	#$BF,d0
		jsr	(PlaySound).l	; play extra continue sound

Obj09_NoCont:
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_Chk1Up:
		cmpi.b	#$28,d4		; is the item an extra life?
		bne.s	Obj09_ChkEmer
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_Get1Up
		move.b	#3,(a2)
		move.l	a1,4(a2)

Obj09_Get1Up:
		addq.b	#1,(v_lives).w	; add 1 to number of lives
		addq.b	#1,(f_lifecount).w ; update the lives counter
		music	bgm_ExtraLife	; play extra life music
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_ChkEmer:
		cmpi.b	#$3B,d4		; is the item an emerald?
		bcs.s	Obj09_ChkGhost
		cmpi.b	#$40,d4
		bhi.s	Obj09_ChkGhost
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GetEmer
		move.b	#5,(a2)
		move.l	a1,4(a2)

Obj09_GetEmer:
		cmpi.b	#6,(v_emeralds).w ; do you have all the emeralds?
		beq.s	Obj09_NoEmer	; if yes, branch
		subi.b	#$3B,d4
		moveq	#0,d0
		move.b	(v_emeralds).w,d0
		lea	(v_emldlist).w,a2
		move.b	d4,(a2,d0.w)
		addq.b	#1,(v_emeralds).w ; add 1 to number of emeralds

Obj09_NoEmer:
		move.w	#$93,d0
		jsr	(PlaySound_Special).l ;	play emerald music
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_ChkGhost:
		cmpi.b	#$41,d4		; is the item a	ghost block?
		bne.s	Obj09_ChkGhostTag
		move.b	#1,$3A(a0)	; mark the ghost block as "passed"

Obj09_ChkGhostTag:
		cmpi.b	#$4A,d4		; is the item a	switch for ghost blocks?
		bne.s	Obj09_NoGhost
		cmpi.b	#1,$3A(a0)	; have the ghost blocks	been passed?
		bne.s	Obj09_NoGhost	; if not, branch
		move.b	#2,$3A(a0)	; mark the ghost blocks	as "solid"

Obj09_NoGhost:
		moveq	#-1,d4
		rts	
; ===========================================================================

Obj09_MakeGhostSolid:
		cmpi.b	#2,$3A(a0)	; is the ghost marked as "solid"?
		bne.s	Obj09_GhostNotSolid ; if not, branch
		lea	($FF1020).l,a1
		moveq	#$3F,d1

Obj09_GhostLoop2:
		moveq	#$3F,d2

Obj09_GhostLoop:
		cmpi.b	#$41,(a1)	; is the item a	ghost block?
		bne.s	Obj09_NoReplace	; if not, branch
		move.b	#$2C,(a1)	; replace ghost	block with a solid block

Obj09_NoReplace:
		addq.w	#1,a1
		dbf	d2,Obj09_GhostLoop
		lea	$40(a1),a1
		dbf	d1,Obj09_GhostLoop2

Obj09_GhostNotSolid:
		clr.b	$3A(a0)
		moveq	#0,d4
		rts	
; End of function Obj09_ChkItems


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_ChkItems2:			; XREF: Obj09_Display
		move.b	$30(a0),d0
		bne.s	Obj09_ChkBumper
		subq.b	#1,$36(a0)
		bpl.s	loc_1BEA0
		move.b	#0,$36(a0)

loc_1BEA0:
		subq.b	#1,$37(a0)
		bpl.s	locret_1BEAC
		move.b	#0,$37(a0)

locret_1BEAC:
		rts	
; ===========================================================================

Obj09_ChkBumper:
		cmpi.b	#$25,d0		; is the item a	bumper?
		bne.s	Obj09_GOAL
		move.l	$32(a0),d1
		subi.l	#$FF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	obX(a0),d1
		sub.w	obY(a0),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		bset	#1,obStatus(a0)
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_BumpSnd
		move.b	#2,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

Obj09_BumpSnd:
		sfx	sfx_Bumper,1	; play bumper sound
; ===========================================================================

Obj09_GOAL:
		cmpi.b	#$27,d0		; is the item a	"GOAL"?
		bne.s	Obj09_UPblock
		addq.b	#2,obRoutine(a0) ; run routine "Obj09_ExitStage"
		sfx	sfx_SSGoal	; play "GOAL" sound
		rts	
; ===========================================================================

Obj09_UPblock:
		cmpi.b	#$29,d0		; is the item an "UP" block?
		bne.s	Obj09_DOWNblock
		tst.b	$36(a0)
		bne.w	Obj09_NoGlass
		move.b	#$1E,$36(a0)
		btst	#6,($FFFFF783).w
		beq.s	Obj09_UPsnd
		asl	(v_ssrotate).w	; increase stage rotation speed
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$2A,(a1)	; change item to a "DOWN" block

Obj09_UPsnd:
		sfx	sfx_SSItem,1	; play up/down sound
; ===========================================================================

Obj09_DOWNblock:
		cmpi.b	#$2A,d0		; is the item a	"DOWN" block?
		bne.s	Obj09_Rblock
		tst.b	$36(a0)
		bne.w	Obj09_NoGlass
		move.b	#$1E,$36(a0)
		btst	#6,(v_ssrotate+1).w
		bne.s	Obj09_DOWNsnd
		asr	(v_ssrotate).w	; reduce stage rotation speed
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$29,(a1)	; change item to an "UP" block

Obj09_DOWNsnd:
		sfx	sfx_SSItem,1	; play up/down sound
; ===========================================================================

Obj09_Rblock:
		cmpi.b	#$2B,d0		; is the item an "R" block?
		bne.s	Obj09_ChkGlass
		tst.b	$37(a0)
		bne.w	Obj09_NoGlass
		move.b	#$1E,$37(a0)
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_RevStage
		move.b	#4,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

Obj09_RevStage:
		neg.w	(v_ssrotate).w	; reverse stage rotation
		sfx	sfx_SSItem,1	; play sound
; ===========================================================================

Obj09_ChkGlass:
		cmpi.b	#$2D,d0		; is the item a	glass block?
		beq.s	Obj09_Glass	; if yes, branch
		cmpi.b	#$2E,d0
		beq.s	Obj09_Glass
		cmpi.b	#$2F,d0
		beq.s	Obj09_Glass
		cmpi.b	#$30,d0
		bne.s	Obj09_NoGlass	; if not, branch

Obj09_Glass:
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GlassSnd
		move.b	#6,(a2)
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0		; change glass type when touched
		cmpi.b	#$30,d0
		bls.s	Obj09_GlassUpdate ; if glass is	still there, branch
		clr.b	d0		; remove the glass block when it's destroyed

Obj09_GlassUpdate:
		move.b	d0,4(a2)	; update the stage layout

Obj09_GlassSnd:
		sfx	sfx_SSGlass,1	; play glass block sound
; ===========================================================================

Obj09_NoGlass:
		rts	
; End of function Obj09_ChkItems2
