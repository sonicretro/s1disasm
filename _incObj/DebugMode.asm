; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(v_debuguse).w,d0
		move.w	Debug_Index(pc,d0.w),d1
		jmp	Debug_Index(pc,d1.w)
; ===========================================================================
Debug_Index:	dc.w Debug_Main-Debug_Index
		dc.w Debug_Action-Debug_Index
; ===========================================================================

Debug_Main:	; Routine 0
		addq.b	#2,(v_debuguse).w
		move.w	(v_limittop2).w,(v_limittopdb).w ; buffer level x-boundary
		move.w	(v_limitbtm1).w,(v_limitbtmdb).w ; buffer level y-boundary
		move.w	#0,(v_limittop2).w
		move.w	#$720,(v_limitbtm1).w
		andi.w	#$7FF,(v_player+obY).w
		andi.w	#$7FF,(v_screenposy).w
		andi.w	#$3FF,(v_bgscreenposy).w
		move.b	#0,obFrame(a0)
		move.b	#id_Walk,obAnim(a0)
		cmpi.b	#id_Special,(v_gamemode).w ; is game mode $10 (special stage)?
		bne.s	.islevel	; if not, branch

		move.w	#0,(v_ssrotate).w ; stop special stage rotating
		move.w	#0,(v_ssangle).w ; make	special	stage "upright"
		moveq	#6,d0		; use 6th debug	item list
		bra.s	.selectlist
; ===========================================================================

.islevel:
		moveq	#0,d0
		move.b	(v_zone).w,d0

.selectlist:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(v_debugitem).w,d6 ; have you gone past the last item?
		bhi.s	.noreset	; if not, branch
		move.b	#0,(v_debugitem).w ; back to start of list

.noreset:
		bsr.w	Debug_ShowItem
		move.b	#12,(v_debugxspeed).w
		move.b	#1,(v_debugyspeed).w

Debug_Action:	; Routine 2
		moveq	#6,d0
		cmpi.b	#id_Special,(v_gamemode).w
		beq.s	.isntlevel

		moveq	#0,d0
		move.b	(v_zone).w,d0

.isntlevel:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	Debug_Control
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Debug_Control:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(v_jpadpress1).w,d4
		andi.w	#btnDir,d4	; is up/down/left/right	pressed?
		bne.s	.dirpressed	; if yes, branch

		move.b	(v_jpadhold1).w,d0
		andi.w	#btnDir,d0	; is up/down/left/right	held?
		bne.s	.dirheld	; if yes, branch

		move.b	#12,(v_debugxspeed).w
		move.b	#15,(v_debugyspeed).w
		bra.w	Debug_ChgItem
; ===========================================================================

.dirheld:
		subq.b	#1,(v_debugxspeed).w
		bne.s	loc_1D01C
		move.b	#1,(v_debugxspeed).w
		addq.b	#1,(v_debugyspeed).w
		bne.s	.dirpressed
		move.b	#-1,(v_debugyspeed).w

.dirpressed:
		move.b	(v_jpadhold1).w,d4

loc_1D01C:
		moveq	#0,d1
		move.b	(v_debugyspeed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		btst	#bitUp,d4	; is up	being pressed?
		beq.s	loc_1D03C	; if not, branch
		sub.l	d1,d2
		bcc.s	loc_1D03C
		moveq	#0,d2

loc_1D03C:
		btst	#bitDn,d4	; is down being	pressed?
		beq.s	loc_1D052	; if not, branch
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_1D052
		move.l	#$7FF0000,d2

loc_1D052:
		btst	#bitL,d4
		beq.s	loc_1D05E
		sub.l	d1,d3
		bcc.s	loc_1D05E
		moveq	#0,d3

loc_1D05E:
		btst	#bitR,d4
		beq.s	loc_1D066
		add.l	d1,d3

loc_1D066:
		move.l	d2,obY(a0)
		move.l	d3,obX(a0)

Debug_ChgItem:
		btst	#bitA,(v_jpadhold1).w ; is button A pressed?
		beq.s	.createitem	; if not, branch
		btst	#bitC,(v_jpadpress1).w ; is button C pressed?
		beq.s	.nextitem	; if not, branch
		subq.b	#1,(v_debugitem).w ; go back 1 item
		bcc.s	.display
		add.b	d6,(v_debugitem).w
		bra.s	.display
; ===========================================================================

.nextitem:
		btst	#bitA,(v_jpadpress1).w ; is button A pressed?
		beq.s	.createitem	; if not, branch
		addq.b	#1,(v_debugitem).w ; go forwards 1 item
		cmp.b	(v_debugitem).w,d6
		bhi.s	.display
		move.b	#0,(v_debugitem).w ; loop back to first item

.display:
		bra.w	Debug_ShowItem
; ===========================================================================

.createitem:
		btst	#bitC,(v_jpadpress1).w ; is button C pressed?
		beq.s	.backtonormal	; if not, branch
		jsr	(FindFreeObj).l
		bne.s	.backtonormal
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		_move.b	4(a0),0(a1)	; create object
		move.b	obRender(a0),obRender(a1)
		move.b	obRender(a0),obStatus(a1)
		andi.b	#$7F,obStatus(a1)
		moveq	#0,d0
		move.b	(v_debugitem).w,d0
		lsl.w	#3,d0
		move.b	4(a2,d0.w),obSubtype(a1)
		rts	
; ===========================================================================

.backtonormal:
		btst	#bitB,(v_jpadpress1).w ; is button B pressed?
		beq.s	.stayindebug	; if not, branch
		moveq	#0,d0
		move.w	d0,(v_debuguse).w ; deactivate debug mode
		move.l	#Map_Sonic,(v_player+obMap).w
		move.w	#$780,(v_player+obGfx).w
		move.b	d0,(v_player+obAnim).w
		move.w	d0,obX+2(a0)
		move.w	d0,obY+2(a0)
		move.w	(v_limittopdb).w,(v_limittop2).w ; restore level boundaries
		move.w	(v_limitbtmdb).w,(v_limitbtm1).w
		cmpi.b	#id_Special,(v_gamemode).w ; are you in the special stage?
		bne.s	.stayindebug	; if not, branch

		clr.w	(v_ssangle).w
		move.w	#$40,(v_ssrotate).w ; set new level rotation speed
		move.l	#Map_Sonic,(v_player+obMap).w
		move.w	#$780,(v_player+obGfx).w
		move.b	#id_Roll,(v_player+obAnim).w
		bset	#2,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

.stayindebug:
		rts	
; End of function Debug_Control


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Debug_ShowItem:
		moveq	#0,d0
		move.b	(v_debugitem).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),obMap(a0) ; load mappings for item
		move.w	6(a2,d0.w),obGfx(a0) ; load VRAM setting for item
		move.b	5(a2,d0.w),obFrame(a0) ; load frame number for item
		rts	
; End of function Debug_ShowItem
