; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeformLayers:				; XREF: GM_TitleScr; GM_Level; GM_Ending
		tst.b	(f_nobgscroll).w
		beq.s	loc_628E
		rts	
; ===========================================================================

loc_628E:
		clr.w	(v_bgscroll1).w
		clr.w	(v_bgscroll2).w
		clr.w	(v_bgscroll3).w
		clr.w	($FFFFF75A).w
		bsr.w	ScrollHoriz
		bsr.w	ScrollVertical
		bsr.w	DynamicLevelEvents
		move.w	(v_screenposy).w,(v_scrposy_dup).w
		move.w	($FFFFF70C).w,($FFFFF618).w
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; End of function DeformLayers

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:	dc.w Deform_GHZ-Deform_Index, Deform_LZ-Deform_Index
		dc.w Deform_MZ-Deform_Index, Deform_SLZ-Deform_Index
		dc.w Deform_SYZ-Deform_Index, Deform_SBZ-Deform_Index
		dc.w Deform_GHZ-Deform_Index
		zonewarning Deform_Index,2
; ---------------------------------------------------------------------------
; Green	Hill Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_GHZ:				; XREF: Deform_Index
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr	ScrollBlock5
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr	ScrollBlock4
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_screenposy).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	loc_62F6
		moveq	#0,d0
loc_62F6:
		move.w	d0,d4
		move.w	d0,($FFFFF618).w
		move.w	(v_screenposx).w,d0
		cmpi.b	#id_Title,($FFFFF600).w
		bne.s	loc_630A
		moveq	#0,d0
loc_630A:
		neg.w	d0
		swap.w	d0
		lea	($FFFFA800).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
		move.w	($FFFFA800).w,d0
		add.w	($FFFFF718).w,d0
		neg.w	d0
		move.w	#$1F,d1
		sub.w	d4,d1
		bcs.s	loc_633C
loc_6336:		
		move.l	d0,(a1)+
		dbra	d1,loc_6336
loc_633C:
		move.w	($FFFFA804).w,d0
		add.w	($FFFFF718).w,d0
		neg.w	d0
		move.w	#$F,d1
loc_634A:		
		move.l	d0,(a1)+
		dbra	d1,loc_634A
		move.w	($FFFFA808).w,d0
		add.w	($FFFFF718).w,d0
		neg.w	d0
		move.w	#$F,d1
loc_635E:		
		move.l	d0,(a1)+
		dbra	d1,loc_635E
		move.w	#$2F,d1
		move.w	($FFFFF718).w,d0
		neg.w	d0
loc_636E:		
		move.l	d0,(a1)+
		dbra	d1,loc_636E
		move.w	#$27,d1
		move.w	($FFFFF710).w,d0
		neg.w	d0
loc_637E:		
		move.l	d0,(a1)+
		dbra	d1,loc_637E
		move.w	($FFFFF710).w,d0
		move.w	(v_screenposx).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1
loc_63A4:		
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap.w	d3
		add.l	d2,d3
		swap.w	d3
		dbra	d1,loc_63A4
		rts
; End of function Deform_GHZ

; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_LZ:				; XREF: Deform_Index
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	($FFFFF73C).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr	ScrollBlock1
		move.w	($FFFFF70C).w,($FFFFF618).w
		lea	(Lz_Scroll_Data),a3
		lea	(Drown_WobbleData),a2
		move.b	($FFFFF7D8).w,d2
		move.b	d2,d3
		addi.w	#$80,($FFFFF7D8).w
		add.w	($FFFFF70C).w,d2
		andi.w	#$FF,d2
		add.w	(v_screenposy).w,d3
		andi.w	#$FF,d3
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$DF,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		move.w	d0,d6
		swap.w	d0
		move.w	($FFFFF708).w,d0
		neg.w	d0
		move.w	(v_waterpos1).w,d4
		move.w	(v_screenposy).w,d5
loc_6418:		
		cmp.w	d4,d5
		bge.s	loc_642A
		move.l	d0,(a1)+
		addq.w	#1,d5
		addq.b	#1,d2
		addq.b	#1,d3
		dbra	d1,loc_6418
		rts
loc_642A:
		move.b	(a3,d3),d4
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+
		move.b	(a2,d2),d4
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+
		addq.b	#1,d2
		addq.b	#1,d3
		dbra	d1,loc_642A
		rts

Lz_Scroll_Data:
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $FF,$FF,$FE,$FE,$FD,$FD,$FD,$FD,$FE,$FE,$FF,$FF,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; End of function Deform_LZ

; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_MZ:				; XREF: Deform_Index
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#2,d6
		bsr	ScrollBlock3
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#6,d6
		bsr	ScrollBlock5
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#4,d6
		bsr	ScrollBlock4
		move.w	#$200,d0
		move.w	(v_screenposy).w,d1
		subi.w	#$1C8,d1
		bcs.s	loc_6590
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0
loc_6590:
		move.w	d0,($FFFFF714).w
		move.w	d0,($FFFFF71C).w
		bsr	ScrollBlock2
		move.w	($FFFFF70C).w,($FFFFF618).w
		move.b	(v_bgscroll2).w,d0
		or.b	(v_bgscroll3).w,d0
		or.b	d0,($FFFFF75A).w
		clr.b	(v_bgscroll2).w
		clr.b	(v_bgscroll3).w
		lea	($FFFFA800).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#2,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#5,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#4,d1
loc_65DE:		
		move.w	d3,(a1)+
		swap.w	d3
		add.l	d0,d3
		swap.w	d3
		dbra	d1,loc_65DE
		move.w	($FFFFF718).w,d0
		neg.w	d0
		move.w	#1,d1
loc_65F4:		
		move.w	d0,(a1)+
		dbra	d1,loc_65F4
		move.w	($FFFFF710).w,d0
		neg.w	d0
		move.w	#8,d1
loc_6604:		
		move.w	d0,(a1)+
		dbra	d1,loc_6604
		move.w	($FFFFF708).w,d0
		neg.w	d0
		move.w	#$F,d1
loc_6614:		
		move.w	d0,(a1)+
		dbra	d1,loc_6614
		lea	($FFFFA800).w,a2
		move.w	($FFFFF70C).w,d0
		subi.w	#$200,d0
		move.w	d0,d2
		cmpi.w	#$100,d0
		bcs.s	loc_6632
		move.w	#$100,d0
loc_6632:
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra	Bg_Scroll_X
; End of function Deform_MZ

; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SLZ:				; XREF: Deform_Index
		move.w	($FFFFF73C).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr	Bg_Scroll_Y
		move.w	($FFFFF70C).w,($FFFFF618).w
		lea	($FFFFA800).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#$1B,d1
loc_6678:		
		move.w	d3,(a1)+
		swap.w	d3
		add.l	d0,d3
		swap.w	d3
		dbra	d1,loc_6678
		move.w	d2,d0
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#4,d1
loc_6692:		
		move.w	d0,(a1)+
		dbra	d1,loc_6692
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1
loc_66A0:		
		move.w	d0,(a1)+
		dbra	d1,loc_66A0
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1
loc_66AE:		
		move.w	d0,(a1)+
		dbra	d1,loc_66AE
		lea	($FFFFA800).w,a2
		move.w	($FFFFF70C).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Bg_Scroll_X:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$E,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap.w	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_66EA(pc,d2)
Loop_Bg_Scroll_X:
		move.w	(a2)+,d0
loc_66EA:		
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbra	d1,Loop_Bg_Scroll_X
		rts

; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SYZ:				; XREF: Deform_Index
		move.w	($FFFFF73C).w,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr	Bg_Scroll_Y
		move.w	($FFFFF70C).w,($FFFFF618).w
		lea	($FFFFA800).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#8,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#7,d1
loc_6750:		
		move.w	d3,(a1)+
		swap.w	d3
		add.l	d0,d3
		swap.w	d3
		dbra	d1,loc_6750
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1
loc_6764:		
		move.w	d0,(a1)+
		dbra	d1,loc_6764
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#5,d1
loc_6772:		
		move.w	d0,(a1)+
		dbra	d1,loc_6772
		move.w	d2,d0
		move.w	d2,d1
		asr.w	#1,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$E,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#$D,d1
loc_6798:		
		move.w	d3,(a1)+
		swap.w	d3
		add.l	d0,d3
		swap.w	d3
		dbra	d1,loc_6798
		lea	($FFFFA800).w,a2
		move.w	($FFFFF70C).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra	Bg_Scroll_X
; End of function Deform_SYZ

; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SBZ:				; XREF: Deform_Index
		tst.b	(v_act).w
		bne	Bg_Scroll_SBz_2
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#2,d6
		bsr	ScrollBlock3
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#6,d6
		bsr	ScrollBlock5
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#4,d6
		bsr	ScrollBlock4
		moveq	#0,d4
		move.w	($FFFFF73C).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr	loc_6AF8
		move.w	($FFFFF70C).w,d0
		move.w	d0,($FFFFF714).w
		move.w	d0,($FFFFF71C).w
		move.w	d0,($FFFFF618).w
		move.b	(v_bgscroll2).w,d0
		or.b	($FFFFF75A).w,d0
		or.b	d0,(v_bgscroll3).w
		clr.b	(v_bgscroll2).w
		clr.b	($FFFFF75A).w
		lea	($FFFFA800).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		asr.w	#2,d2
		move.w	d2,d0
		asr.w	#1,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#4,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#3,d1
loc_684E:		
		move.w	d3,(a1)+
		swap.w	d3
		add.l	d0,d3
		swap.w	d3
		dbra	d1,loc_684E
		move.w	($FFFFF718).w,d0
		neg.w	d0
		move.w	#9,d1
loc_6864:		
		move.w	d0,(a1)+
		dbra	d1,loc_6864
		move.w	($FFFFF710).w,d0
		neg.w	d0
		move.w	#6,d1
loc_6874:		
		move.w	d0,(a1)+
		dbra	d1,loc_6874
		move.w	($FFFFF708).w,d0
		neg.w	d0
		move.w	#$A,d1
loc_6884:		
		move.w	d0,(a1)+
		dbra	d1,loc_6884
		lea	($FFFFA800).w,a2
		move.w	($FFFFF70C).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra	Bg_Scroll_X
;-------------------------------------------------------------------------------
Bg_Scroll_SBz_2:;loc_68A2:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4		
		asl.l	#6,d4
		move.w	($FFFFF73C).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr	ScrollBlock1
		move.w	($FFFFF70C).w,($FFFFF618).w
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#223,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap.w	d0
		move.w	($FFFFF708).w,d0
		neg.w	d0
loc_68D2:		
		move.l	d0,(a1)+
		dbra	d1,loc_68D2
		rts
; End of function Deform_SBZ

; ---------------------------------------------------------------------------
; Subroutine to	scroll the level horizontally as Sonic moves
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollHoriz:				; XREF: DeformLayers
		move.w	(v_screenposx).w,d4 ; save old screen position
		bsr.s	MoveScreenHoriz
		move.w	(v_screenposx).w,d0
		andi.w	#$10,d0
		move.b	($FFFFF74A).w,d1
		eor.b	d1,d0
		bne.s	locret_65B0
		eori.b	#$10,($FFFFF74A).w
		move.w	(v_screenposx).w,d0
		sub.w	d4,d0		; compare new with old screen position
		bpl.s	SH_Forward

		bset	#2,(v_bgscroll1).w ; screen moves backward
		rts	

	SH_Forward:
		bset	#3,(v_bgscroll1).w ; screen moves forward

locret_65B0:
		rts	
; End of function ScrollHoriz


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MoveScreenHoriz:			; XREF: ScrollHoriz
		move.w	(v_player+obX).w,d0
		sub.w	(v_screenposx).w,d0 ; Sonic's distance from left edge of screen
		subi.w	#144,d0		; is distance less than 144px?
		bcs.s	SH_BehindMid	; if yes, branch
		subi.w	#16,d0		; is distance more than 160px?
		bcc.s	SH_AheadOfMid	; if yes, branch
		clr.w	(v_scrshiftx).w
		rts	
; ===========================================================================

SH_AheadOfMid:
		cmpi.w	#16,d0		; is Sonic within 16px of middle area?
		bcs.s	SH_Ahead16	; if yes, branch
		move.w	#16,d0		; set to 16 if greater

	SH_Ahead16:
		add.w	(v_screenposx).w,d0
		cmp.w	(v_limitright2).w,d0
		blt.s	SH_SetScreen
		move.w	(v_limitright2).w,d0

SH_SetScreen:
		move.w	d0,d1
		sub.w	(v_screenposx).w,d1
		asl.w	#8,d1
		move.w	d0,(v_screenposx).w ; set new screen position
		move.w	d1,(v_scrshiftx).w ; set distance for screen movement
		rts	
; ===========================================================================

SH_BehindMid:
		add.w	(v_screenposx).w,d0
		cmp.w	(v_limitleft2).w,d0
		bgt.s	SH_SetScreen
		move.w	(v_limitleft2).w,d0
		bra.s	SH_SetScreen
; End of function MoveScreenHoriz

; ===========================================================================
		tst.w	d0
		bpl.s	loc_6610
		move.w	#-2,d0
		bra.s	SH_BehindMid

loc_6610:
		move.w	#2,d0
		bra.s	SH_AheadOfMid

; ---------------------------------------------------------------------------
; Subroutine to	scroll the level vertically as Sonic moves
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollVertical:				; XREF: DeformLayers
		moveq	#0,d1
		move.w	(v_player+obY).w,d0
		sub.w	(v_screenposy).w,d0 ; Sonic's distance from top of screen
		btst	#2,(v_player+obStatus).w ; is Sonic rolling?
		beq.s	SV_NotRolling	; if not, branch
		subq.w	#5,d0

	SV_NotRolling:
		btst	#1,(v_player+obStatus).w ; is Sonic jumping?
		beq.s	loc_664A	; if not, branch

		addi.w	#32,d0
		sub.w	(v_lookshift).w,d0
		bcs.s	loc_6696
		subi.w	#64,d0
		bcc.s	loc_6696
		tst.b	(f_bgscrollvert).w
		bne.s	loc_66A8
		bra.s	loc_6656
; ===========================================================================

loc_664A:
		sub.w	(v_lookshift).w,d0
		bne.s	loc_665C
		tst.b	(f_bgscrollvert).w
		bne.s	loc_66A8

loc_6656:
		clr.w	($FFFFF73C).w
		rts	
; ===========================================================================

loc_665C:
		cmpi.w	#$60,(v_lookshift).w
		bne.s	loc_6684
		move.w	(v_player+obInertia).w,d1
		bpl.s	loc_666C
		neg.w	d1

loc_666C:
		cmpi.w	#$800,d1
		bcc.s	loc_6696
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.s	loc_66F6
		cmpi.w	#-6,d0
		blt.s	loc_66C0
		bra.s	loc_66AEa
; ===========================================================================

loc_6684:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_66F6
		cmpi.w	#-2,d0
		blt.s	loc_66C0
		bra.s	loc_66AEa
; ===========================================================================

loc_6696:
		move.w	#$1000,d1
		cmpi.w	#$10,d0
		bgt.s	loc_66F6
		cmpi.w	#-$10,d0
		blt.s	loc_66C0
		bra.s	loc_66AEa
; ===========================================================================

loc_66A8:
		moveq	#0,d0
		move.b	d0,(f_bgscrollvert).w

loc_66AEa:
		moveq	#0,d1
		move.w	d0,d1
		add.w	(v_screenposy).w,d1
		tst.w	d0
		bpl.w	loc_6700
		bra.w	loc_66CC
; ===========================================================================

loc_66C0:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_screenposy).w,d1
		swap	d1

loc_66CC:
		cmp.w	(v_limittop2).w,d1
		bgt.s	loc_6724
		cmpi.w	#-$100,d1
		bgt.s	loc_66F0
		andi.w	#$7FF,d1
		andi.w	#$7FF,(v_player+obY).w
		andi.w	#$7FF,(v_screenposy).w
		andi.w	#$3FF,($FFFFF70C).w
		bra.s	loc_6724
; ===========================================================================

loc_66F0:
		move.w	(v_limittop2).w,d1
		bra.s	loc_6724
; ===========================================================================

loc_66F6:
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_screenposy).w,d1
		swap	d1

loc_6700:
		cmp.w	(v_limitbtm2).w,d1
		blt.s	loc_6724
		subi.w	#$800,d1
		bcs.s	loc_6720
		andi.w	#$7FF,(v_player+obY).w
		subi.w	#$800,(v_screenposy).w
		andi.w	#$3FF,($FFFFF70C).w
		bra.s	loc_6724
; ===========================================================================

loc_6720:
		move.w	(v_limitbtm2).w,d1

loc_6724:
		move.w	(v_screenposy).w,d4
		swap	d1
		move.l	d1,d3
		sub.l	(v_screenposy).w,d3
		ror.l	#8,d3
		move.w	d3,($FFFFF73C).w
		move.l	d1,(v_screenposy).w
		move.w	(v_screenposy).w,d0
		andi.w	#$10,d0
		move.b	($FFFFF74B).w,d1
		eor.b	d1,d0
		bne.s	locret_6766
		eori.b	#$10,($FFFFF74B).w
		move.w	(v_screenposy).w,d0
		sub.w	d4,d0
		bpl.s	loc_6760
		bset	#0,(v_bgscroll1).w
		rts	
; ===========================================================================

loc_6760:
		bset	#1,(v_bgscroll1).w

locret_6766:
		rts	
; End of function ScrollVertical


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock1:				; XREF: Deform_GHZ; et al
		move.l	($FFFFF708).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,($FFFFF708).w
		move.l	d0,d1
		swap.w	d1
		andi.w	#$10,d1
		move.b	($FFFFF74C).w,d3
		eor.b	d3,d1
		bne.s	loc_6AF8
		eori.b	#$10,($FFFFF74C).w
		sub.l	d2,d0
		bpl.s	loc_6AF2
		bset	#2,(v_bgscroll2).w
		bra.s	loc_6AF8
loc_6AF2:
		bset	#3,(v_bgscroll2).w
loc_6AF8:
		move.l	($FFFFF70C).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,($FFFFF70C).w
		move.l	d0,d1
		swap.w	d1
		andi.w	#$10,d1
		move.b	($FFFFF74D).w,d2
		eor.b	d2,d1
		bne.s	loc_6B2C
		eori.b	#$10,($FFFFF74D).w
		sub.l	d3,d0
		bpl.s	loc_6B26
		bset	#0,(v_bgscroll2).w
		rts
loc_6B26:
		bset	#1,(v_bgscroll2).w
loc_6B2C:
		rts
; End of function ScrollBlock1

Bg_Scroll_Y:
		move.l	($FFFFF70C).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,($FFFFF70C).w
		move.l	d0,d1
		swap.w	d1
		andi.w	#$10,d1
		move.b	($FFFFF74D).w,d2
		eor.b	d2,d1
		bne.s	Exit_Bg_Scroll_Y
		eori.b	#$10,($FFFFF74D).w
		sub.l	d3,d0
		bpl.s	loc_6B5C
		bset	#4,(v_bgscroll2).w
		rts
loc_6B5C:
		bset	#5,(v_bgscroll2).w
Exit_Bg_Scroll_Y:
		rts


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock2:				; XREF: Deform_SLZ
		move.w	($FFFFF70C).w,d3
		move.w	d0,($FFFFF70C).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	($FFFFF74D).w,d2
		eor.b	d2,d1
		bne.s	Exit_Scroll_Block2
		eori.b	#$10,($FFFFF74D).w
		sub.w	d3,d0
		bpl.s	loc_6B8C
		bset	#0,(v_bgscroll2).w
		rts
loc_6B8C:
		bset	#1,(v_bgscroll2).w
Exit_Scroll_Block2:
		rts
; End of function ScrollBlock2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock3:				; XREF: Deform_GHZ; et al
		move.l	($FFFFF708).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,($FFFFF708).w
		move.l	d0,d1
		swap.w	d1
		andi.w	#$10,d1
		move.b	($FFFFF74C).w,d3
		eor.b	d3,d1
		bne.s	Exit_Scroll_Block3
		eori.b	#$10,($FFFFF74C).w
		sub.l	d2,d0
		bpl.s	loc_6BC0
		bset	d6,(v_bgscroll2).w
		bra.s	Exit_Scroll_Block3
loc_6BC0:
		addq.b	#1,d6
		bset	d6,(v_bgscroll2).w
Exit_Scroll_Block3:
		rts
; End of function ScrollBlock3


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock4:				; XREF: Deform_GHZ
		move.l	($FFFFF710).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,($FFFFF710).w
		move.l	d0,d1
		swap.w	d1
		andi.w	#$10,d1
		move.b	($FFFFF74E).w,d3
		eor.b	d3,d1
		bne.s	Exit_Scroll_Block4
		eori.b	#$10,($FFFFF74E).w
		sub.l	d2,d0
		bpl.s	loc_6BF4
		bset	d6,(v_bgscroll3).w
		bra.s	Exit_Scroll_Block4
loc_6BF4:
		addq.b	#1,d6
		bset	d6,(v_bgscroll3).w
Exit_Scroll_Block4:
		rts
;-------------------------------------------------------------------------------
ScrollBlock5:
		move.l	($FFFFF718).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,($FFFFF718).w
		move.l	d0,d1
		swap.w	d1
		andi.w	#$10,d1
		move.b	($FFFFF750).w,d3
		eor.b	d3,d1
		bne.s	loc_6C2E
		eori.b	#$10,($FFFFF750).w
		sub.l	d2,d0
		bpl.s	loc_6C28
		bset	d6,($FFFFF75A).w
		bra.s	loc_6C2E
loc_6C28:
		addq.b	#1,d6
		bset	d6,($FFFFF75A).w
loc_6C2E:
		rts