; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DynamicLevelEvents:			; XREF: DeformLayers
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	DLE_Index(pc,d0.w),d0
		jsr	DLE_Index(pc,d0.w) ; run level-specific events
		moveq	#2,d1
		move.w	(v_limitbtm1).w,d0
		sub.w	(v_limitbtm2).w,d0 ; has lower level boundary changed recently?
		beq.s	DLE_NoChg	; if not, branch
		bcc.s	loc_6DAC

		neg.w	d1
		move.w	(v_screenposy).w,d0
		cmp.w	(v_limitbtm1).w,d0
		bls.s	loc_6DA0
		move.w	d0,(v_limitbtm2).w
		andi.w	#$FFFE,(v_limitbtm2).w

loc_6DA0:
		add.w	d1,(v_limitbtm2).w
		move.b	#1,(f_bgscrollvert).w

DLE_NoChg:
		rts	
; ===========================================================================

loc_6DAC:
		move.w	(v_screenposy).w,d0
		addq.w	#8,d0
		cmp.w	(v_limitbtm2).w,d0
		bcs.s	loc_6DC4
		btst	#1,(v_player+obStatus).w
		beq.s	loc_6DC4
		add.w	d1,d1
		add.w	d1,d1

loc_6DC4:
		add.w	d1,(v_limitbtm2).w
		move.b	#1,(f_bgscrollvert).w
		rts	
; End of function DynamicLevelEvents

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:	dc.w DLE_GHZ-DLE_Index, DLE_LZ-DLE_Index
		dc.w DLE_MZ-DLE_Index, DLE_SLZ-DLE_Index
		dc.w DLE_SYZ-DLE_Index, DLE_SBZ-DLE_Index
		dc.w DLE_Ending-DLE_Index
		zonewarning DLE_Index,2
; ===========================================================================
; ---------------------------------------------------------------------------
; Green	Hill Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_GHZ:				; XREF: DLE_Index
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_GHZx(pc,d0.w),d0
		jmp	DLE_GHZx(pc,d0.w)
; ===========================================================================
DLE_GHZx:	dc.w DLE_GHZ1-DLE_GHZx
		dc.w DLE_GHZ2-DLE_GHZx
		dc.w DLE_GHZ3-DLE_GHZx
; ===========================================================================

DLE_GHZ1:
		move.w	#$300,(v_limitbtm1).w ; set lower y-boundary
		cmpi.w	#$1780,(v_screenposx).w ; has the camera reached $1780 on x-axis?
		bcs.s	locret_6E08	; if not, branch
		move.w	#$400,(v_limitbtm1).w ; set lower y-boundary

locret_6E08:
		rts	
; ===========================================================================

DLE_GHZ2:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$ED0,(v_screenposx).w
		bcs.s	locret_6E3A
		move.w	#$200,(v_limitbtm1).w
		cmpi.w	#$1600,(v_screenposx).w
		bcs.s	locret_6E3A
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1D60,(v_screenposx).w
		bcs.s	locret_6E3A
		move.w	#$300,(v_limitbtm1).w

locret_6E3A:
		rts	
; ===========================================================================

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_6E4A(pc,d0.w),d0
		jmp	off_6E4A(pc,d0.w)
; ===========================================================================
off_6E4A:	dc.w DLE_GHZ3main-off_6E4A
		dc.w DLE_GHZ3boss-off_6E4A
		dc.w DLE_GHZ3end-off_6E4A
; ===========================================================================

DLE_GHZ3main:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$380,(v_screenposx).w
		bcs.s	locret_6E96
		move.w	#$310,(v_limitbtm1).w
		cmpi.w	#$960,(v_screenposx).w
		bcs.s	locret_6E96
		cmpi.w	#$280,(v_screenposy).w
		bcs.s	loc_6E98
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1380,(v_screenposx).w
		bcc.s	loc_6E8E
		move.w	#$4C0,(v_limitbtm1).w
		move.w	#$4C0,(v_limitbtm2).w

loc_6E8E:
		cmpi.w	#$1700,(v_screenposx).w
		bcc.s	loc_6E98

locret_6E96:
		rts	
; ===========================================================================

loc_6E98:
		move.w	#$300,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w
		rts	
; ===========================================================================

DLE_GHZ3boss:
		cmpi.w	#$960,(v_screenposx).w
		bcc.s	loc_6EB0
		subq.b	#2,(v_dle_routine).w

loc_6EB0:
		cmpi.w	#$2960,(v_screenposx).w
		bcs.s	locret_6EE8
		bsr.w	FindFreeObj
		bne.s	loc_6ED0
		move.b	#id_BossGreenHill,0(a1) ; load GHZ boss	object
		move.w	#$2A60,obX(a1)
		move.w	#$280,obY(a1)

loc_6ED0:
		move.w	#bgm_Boss,d0
		bsr.w	PlaySound	; play boss music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

locret_6EE8:
		rts	
; ===========================================================================

DLE_GHZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_LZ:				; XREF: DLE_Index
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_LZx(pc,d0.w),d0
		jmp	DLE_LZx(pc,d0.w)
; ===========================================================================
DLE_LZx:	dc.w DLE_LZ12-DLE_LZx
		dc.w DLE_LZ12-DLE_LZx
		dc.w DLE_LZ3-DLE_LZx
		dc.w DLE_SBZ3-DLE_LZx
; ===========================================================================

DLE_LZ12:
		rts	
; ===========================================================================

DLE_LZ3:
		tst.b	(f_switch+$F).w	; has switch $F	been pressed?
		beq.s	loc_6F28	; if not, branch
		lea	(v_lvllayout+$106).w,a1
		cmpi.b	#7,(a1)
		beq.s	loc_6F28
		move.b	#7,(a1)		; modify level layout
		move.w	#sfx_Rumbling,d0
		bsr.w	PlaySound_Special ; play rumbling sound

loc_6F28:
		tst.b	(v_dle_routine).w
		bne.s	locret_6F64
		cmpi.w	#$1CA0,(v_screenposx).w
		bcs.s	locret_6F62
		cmpi.w	#$600,(v_screenposy).w
		bcc.s	locret_6F62
		bsr.w	FindFreeObj
		bne.s	loc_6F4A
		move.b	#id_BossLabyrinth,0(a1) ; load LZ boss object

loc_6F4A:
		move.w	#bgm_Boss,d0
		bsr.w	PlaySound	; play boss music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

locret_6F62:
		rts	
; ===========================================================================

locret_6F64:
		rts	
; ===========================================================================

DLE_SBZ3:
		cmpi.w	#$D00,(v_screenposx).w
		bcs.s	locret_6F8C
		cmpi.w	#$18,(v_player+obY).w ; has Sonic reached the top of the level?
		bcc.s	locret_6F8C	; if not, branch
		clr.b	(v_lastlamp).w
		move.w	#1,(f_restart).w ; restart level
		move.w	#(id_SBZ<<8)+2,(v_zone).w ; set level number to 0502 (FZ)
		move.b	#1,(f_lockmulti).w ; freeze Sonic

locret_6F8C:
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_MZ:				; XREF: DLE_Index
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_MZx(pc,d0.w),d0
		jmp	DLE_MZx(pc,d0.w)
; ===========================================================================
DLE_MZx:	dc.w DLE_MZ1-DLE_MZx
		dc.w DLE_MZ2-DLE_MZx
		dc.w DLE_MZ3-DLE_MZx
; ===========================================================================

DLE_MZ1:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_6FB2(pc,d0.w),d0
		jmp	off_6FB2(pc,d0.w)
; ===========================================================================
off_6FB2:	dc.w loc_6FBA-off_6FB2
		dc.w loc_6FEA-off_6FB2
		dc.w loc_702E-off_6FB2
		dc.w loc_7050-off_6FB2
; ===========================================================================

loc_6FBA:
		move.w	#$1D0,(v_limitbtm1).w
		cmpi.w	#$700,(v_screenposx).w
		bcs.s	locret_6FE8
		move.w	#$220,(v_limitbtm1).w
		cmpi.w	#$D00,(v_screenposx).w
		bcs.s	locret_6FE8
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$340,(v_screenposy).w
		bcs.s	locret_6FE8
		addq.b	#2,(v_dle_routine).w

locret_6FE8:
		rts	
; ===========================================================================

loc_6FEA:
		cmpi.w	#$340,(v_screenposy).w
		bcc.s	loc_6FF8
		subq.b	#2,(v_dle_routine).w
		rts	
; ===========================================================================

loc_6FF8:
		move.w	#0,(v_limittop2).w
		cmpi.w	#$E00,(v_screenposx).w
		bcc.s	locret_702C
		move.w	#$340,(v_limittop2).w
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$A90,(v_screenposx).w
		bcc.s	locret_702C
		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$370,(v_screenposy).w
		bcs.s	locret_702C
		addq.b	#2,(v_dle_routine).w

locret_702C:
		rts	
; ===========================================================================

loc_702E:
		cmpi.w	#$370,(v_screenposy).w
		bcc.s	loc_703C
		subq.b	#2,(v_dle_routine).w
		rts	
; ===========================================================================

loc_703C:
		cmpi.w	#$500,(v_screenposy).w
		bcs.s	locret_704E
		if Revision=0
		else
			cmpi.w	#$B80,(v_screenposx).w
			bcs.s	locret_704E
		endc
		move.w	#$500,(v_limittop2).w
		addq.b	#2,(v_dle_routine).w

locret_704E:
		rts	
; ===========================================================================

loc_7050:
		if Revision=0
		else
			cmpi.w	#$B80,(v_screenposx).w
			bcc.s	locj_76B8
			cmpi.w	#$340,(v_limittop2).w
			beq.s	locret_7072
			subq.w	#2,(v_limittop2).w
			rts
	locj_76B8:
			cmpi.w	#$500,(v_limittop2).w
			beq.s	locj_76CE
			cmpi.w	#$500,(v_screenposy).w
			bcs.s	locret_7072
			move.w	#$500,(v_limittop2).w
	locj_76CE:
		endc

		cmpi.w	#$E70,(v_screenposx).w
		bcs.s	locret_7072
		move.w	#0,(v_limittop2).w
		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$1430,(v_screenposx).w
		bcs.s	locret_7072
		move.w	#$210,(v_limitbtm1).w

locret_7072:
		rts	
; ===========================================================================

DLE_MZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$1700,(v_screenposx).w
		bcs.s	locret_7088
		move.w	#$200,(v_limitbtm1).w

locret_7088:
		rts	
; ===========================================================================

DLE_MZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7098(pc,d0.w),d0
		jmp	off_7098(pc,d0.w)
; ===========================================================================
off_7098:	dc.w DLE_MZ3boss-off_7098
		dc.w DLE_MZ3end-off_7098
; ===========================================================================

DLE_MZ3boss:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#$1560,(v_screenposx).w
		bcs.s	locret_70E8
		move.w	#$210,(v_limitbtm1).w
		cmpi.w	#$17F0,(v_screenposx).w
		bcs.s	locret_70E8
		bsr.w	FindFreeObj
		bne.s	loc_70D0
		move.b	#id_BossMarble,0(a1) ; load MZ boss object
		move.w	#$19F0,obX(a1)
		move.w	#$22C,obY(a1)

loc_70D0:
		move.w	#bgm_Boss,d0
		bsr.w	PlaySound	; play boss music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

locret_70E8:
		rts	
; ===========================================================================

DLE_MZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SLZ:				; XREF: DLE_Index
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SLZx(pc,d0.w),d0
		jmp	DLE_SLZx(pc,d0.w)
; ===========================================================================
DLE_SLZx:	dc.w DLE_SLZ12-DLE_SLZx
		dc.w DLE_SLZ12-DLE_SLZx
		dc.w DLE_SLZ3-DLE_SLZx
; ===========================================================================

DLE_SLZ12:
		rts	
; ===========================================================================

DLE_SLZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7118(pc,d0.w),d0
		jmp	off_7118(pc,d0.w)
; ===========================================================================
off_7118:	dc.w DLE_SLZ3main-off_7118
		dc.w DLE_SLZ3boss-off_7118
		dc.w DLE_SLZ3end-off_7118
; ===========================================================================

DLE_SLZ3main:
		cmpi.w	#$1E70,(v_screenposx).w
		bcs.s	locret_7130
		move.w	#$210,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w

locret_7130:
		rts	
; ===========================================================================

DLE_SLZ3boss:
		cmpi.w	#$2000,(v_screenposx).w
		bcs.s	locret_715C
		bsr.w	FindFreeObj
		bne.s	loc_7144
		move.b	#id_BossStarLight,(a1) ; load SLZ boss object

loc_7144:
		move.w	#bgm_Boss,d0
		bsr.w	PlaySound	; play boss music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

locret_715C:
		rts	
; ===========================================================================

DLE_SLZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SYZ:				; XREF: DLE_Index
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SYZx(pc,d0.w),d0
		jmp	DLE_SYZx(pc,d0.w)
; ===========================================================================
DLE_SYZx:	dc.w DLE_SYZ1-DLE_SYZx
		dc.w DLE_SYZ2-DLE_SYZx
		dc.w DLE_SYZ3-DLE_SYZx
; ===========================================================================

DLE_SYZ1:
		rts	
; ===========================================================================

DLE_SYZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$25A0,(v_screenposx).w
		bcs.s	locret_71A2
		move.w	#$420,(v_limitbtm1).w
		cmpi.w	#$4D0,($FFFFD00C).w
		bcs.s	locret_71A2
		move.w	#$520,(v_limitbtm1).w

locret_71A2:
		rts	
; ===========================================================================

DLE_SYZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_71B2(pc,d0.w),d0
		jmp	off_71B2(pc,d0.w)
; ===========================================================================
off_71B2:	dc.w DLE_SYZ3main-off_71B2
		dc.w DLE_SYZ3boss-off_71B2
		dc.w DLE_SYZ3end-off_71B2
; ===========================================================================

DLE_SYZ3main:
		cmpi.w	#$2AC0,(v_screenposx).w
		bcs.s	locret_71CE
		bsr.w	FindFreeObj
		bne.s	locret_71CE
		move.b	#id_BossBlock,(a1) ; load blocks that boss picks up
		addq.b	#2,(v_dle_routine).w

locret_71CE:
		rts	
; ===========================================================================

DLE_SYZ3boss:
		cmpi.w	#$2C00,(v_screenposx).w
		bcs.s	locret_7200
		move.w	#$4CC,(v_limitbtm1).w
		bsr.w	FindFreeObj
		bne.s	loc_71EC
		move.b	#id_BossSpringYard,(a1) ; load SYZ boss	object
		addq.b	#2,(v_dle_routine).w

loc_71EC:
		move.w	#bgm_Boss,d0
		bsr.w	PlaySound	; play boss music
		move.b	#1,(f_lockscreen).w ; lock screen
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

locret_7200:
		rts	
; ===========================================================================

DLE_SYZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap	Brain Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SBZ:				; XREF: DLE_Index
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SBZx(pc,d0.w),d0
		jmp	DLE_SBZx(pc,d0.w)
; ===========================================================================
DLE_SBZx:	dc.w DLE_SBZ1-DLE_SBZx
		dc.w DLE_SBZ2-DLE_SBZx
		dc.w DLE_FZ-DLE_SBZx
; ===========================================================================

DLE_SBZ1:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#$1880,(v_screenposx).w
		bcs.s	locret_7242
		move.w	#$620,(v_limitbtm1).w
		cmpi.w	#$2000,(v_screenposx).w
		bcs.s	locret_7242
		move.w	#$2A0,(v_limitbtm1).w

locret_7242:
		rts	
; ===========================================================================

DLE_SBZ2:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7252(pc,d0.w),d0
		jmp	off_7252(pc,d0.w)
; ===========================================================================
off_7252:	dc.w DLE_SBZ2main-off_7252
		dc.w DLE_SBZ2boss-off_7252
		dc.w DLE_SBZ2boss2-off_7252
		dc.w DLE_SBZ2end-off_7252
; ===========================================================================

DLE_SBZ2main:
		move.w	#$800,(v_limitbtm1).w
		cmpi.w	#$1800,(v_screenposx).w
		bcs.s	locret_727A
		move.w	#$510,(v_limitbtm1).w
		cmpi.w	#$1E00,(v_screenposx).w
		bcs.s	locret_727A
		addq.b	#2,(v_dle_routine).w

locret_727A:
		rts	
; ===========================================================================

DLE_SBZ2boss:
		cmpi.w	#$1EB0,(v_screenposx).w
		bcs.s	locret_7298
		bsr.w	FindFreeObj
		bne.s	locret_7298
		move.b	#id_FalseFloor,(a1) ; load collapsing block object
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_EggmanSBZ2,d0
		bra.w	AddPLC		; load SBZ2 Eggman patterns
; ===========================================================================

locret_7298:
		rts	
; ===========================================================================

DLE_SBZ2boss2:
		cmpi.w	#$1F60,(v_screenposx).w
		bcs.s	loc_72B6
		bsr.w	FindFreeObj
		bne.s	loc_72B0
		move.b	#id_ScrapEggman,(a1) ; load SBZ2 Eggman object
		addq.b	#2,(v_dle_routine).w

loc_72B0:
		move.b	#1,(f_lockscreen).w ; lock screen

loc_72B6:
		bra.s	loc_72C2
; ===========================================================================

DLE_SBZ2end:
		cmpi.w	#$2050,(v_screenposx).w
		bcs.s	loc_72C2
		rts	
; ===========================================================================

loc_72C2:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts	
; ===========================================================================

DLE_FZ:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_72D8(pc,d0.w),d0
		jmp	off_72D8(pc,d0.w)
; ===========================================================================
off_72D8:	dc.w DLE_FZmain-off_72D8, DLE_FZboss-off_72D8
		dc.w DLE_FZend-off_72D8, locret_7322-off_72D8
		dc.w DLE_FZend2-off_72D8
; ===========================================================================

DLE_FZmain:
		cmpi.w	#$2148,(v_screenposx).w
		bcs.s	loc_72F4
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_FZBoss,d0
		bsr.w	AddPLC		; load FZ boss patterns

loc_72F4:
		bra.s	loc_72C2
; ===========================================================================

DLE_FZboss:
		cmpi.w	#$2300,(v_screenposx).w
		bcs.s	loc_7312
		bsr.w	FindFreeObj
		bne.s	loc_7312
		move.b	#id_BossFinal,(a1) ; load FZ boss object
		addq.b	#2,(v_dle_routine).w
		move.b	#1,(f_lockscreen).w ; lock screen

loc_7312:
		bra.s	loc_72C2
; ===========================================================================

DLE_FZend:
		cmpi.w	#$2450,(v_screenposx).w
		bcs.s	loc_7320
		addq.b	#2,(v_dle_routine).w

loc_7320:
		bra.s	loc_72C2
; ===========================================================================

locret_7322:
		rts	
; ===========================================================================

DLE_FZend2:
		bra.s	loc_72C2
; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence dynamic level events (empty)
; ---------------------------------------------------------------------------

DLE_Ending:				; XREF: DLE_Index
		rts	
