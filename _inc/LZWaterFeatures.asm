; ---------------------------------------------------------------------------
; Subroutine to	do special water effects in Labyrinth Zone
; ---------------------------------------------------------------------------

LZWaterFeatures:			; XREF: GM_Level
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	@notlabyrinth	; if not, branch
		if Revision=0
		else
			tst.b   (f_nobgscroll).w
			bne.s	@setheight
		endc
		cmpi.b	#6,(v_player+obRoutine).w ; has Sonic just died?
		bcc.s	@setheight	; if yes, skip other effects

		bsr.w	LZWindTunnels
		bsr.w	LZWaterSlides
		bsr.w	LZDynamicWater

@setheight:
		clr.b	(f_wtr_state).w
		moveq	#0,d0
		move.b	(v_oscillate+2).w,d0
		lsr.w	#1,d0
		add.w	(v_waterpos2).w,d0
		move.w	d0,(v_waterpos1).w
		move.w	(v_waterpos1).w,d0
		sub.w	(v_screenposy).w,d0
		bcc.s	@isbelow
		tst.w	d0
		bpl.s	@isbelow	; if water is below top of screen, branch

		move.b	#223,(v_hbla_line).w
		move.b	#1,(f_wtr_state).w ; screen is all underwater

	@isbelow:
		cmpi.w	#223,d0		; is water within 223 pixels of top of screen?
		bcs.s	@isvisible	; if yes, branch
		move.w	#223,d0

	@isvisible:
		move.b	d0,(v_hbla_line).w ; set water surface as on-screen

@notlabyrinth:
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Initial water heights
; ---------------------------------------------------------------------------
WaterHeight:	dc.w $B8	; Labyrinth 1
		dc.w $328	; Labyrinth 2
		dc.w $900	; Labyrinth 3
		dc.w $228	; Scrap Brain 3
		even
; ===========================================================================

; ---------------------------------------------------------------------------
; Labyrinth dynamic water routines
; ---------------------------------------------------------------------------

LZDynamicWater:				; XREF: LZWaterFeatures
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DynWater_Index(pc,d0.w),d0
		jsr	DynWater_Index(pc,d0.w)
		moveq	#0,d1
		move.b	(f_water).w,d1
		move.w	(v_waterpos3).w,d0
		sub.w	(v_waterpos2).w,d0
		beq.s	@exit		; if water level is correct, branch
		bcc.s	@movewater	; if water level is too high, branch
		neg.w	d1		; set water to move up instead

	@movewater:
		add.w	d1,(v_waterpos2).w ; move water up/down

	@exit:
		rts	
; ===========================================================================
DynWater_Index:	dc.w DynWater_LZ1-DynWater_Index
		dc.w DynWater_LZ2-DynWater_Index
		dc.w DynWater_LZ3-DynWater_Index
		dc.w DynWater_SBZ3-DynWater_Index
; ===========================================================================

DynWater_LZ1:				; XREF: DynWater_Index
		move.w	(v_screenposx).w,d0
		move.b	(v_wtr_routine).w,d2
		bne.s	@routine2
		move.w	#$B8,d1		; water height
		cmpi.w	#$600,d0	; has screen reached next position?
		bcs.s	@setwater	; if not, branch
		move.w	#$108,d1
		cmpi.w	#$200,(v_player+obY).w ; is Sonic above $200 y-axis?
		bcs.s	@sonicishigh	; if yes, branch
		cmpi.w	#$C00,d0
		bcs.s	@setwater
		move.w	#$318,d1
		cmpi.w	#$1080,d0
		bcs.s	@setwater
		move.b	#$80,(f_switch+5).w
		move.w	#$5C8,d1
		cmpi.w	#$1380,d0
		bcs.s	@setwater
		move.w	#$3A8,d1
		cmp.w	(v_waterpos2).w,d1 ; has water reached last height?
		bne.s	@setwater	; if not, branch
		move.b	#1,(v_wtr_routine).w ; use second routine next

	@setwater:
		move.w	d1,(v_waterpos3).w
		rts	
; ===========================================================================

@sonicishigh:
		cmpi.w	#$C80,d0
		bcs.s	@setwater
		move.w	#$E8,d1
		cmpi.w	#$1500,d0
		bcs.s	@setwater
		move.w	#$108,d1
		bra.s	@setwater
; ===========================================================================

@routine2:
		subq.b	#1,d2
		bne.s	@skip
		cmpi.w	#$2E0,(v_player+obY).w ; is Sonic above $2E0 y-axis?
		bcc.s	@skip		; if not, branch
		move.w	#$3A8,d1
		cmpi.w	#$1300,d0
		bcs.s	@setwater2
		move.w	#$108,d1
		move.b	#2,(v_wtr_routine).w

	@setwater2:
		move.w	d1,(v_waterpos3).w

	@skip:
		rts	
; ===========================================================================

DynWater_LZ2:				; XREF: DynWater_Index
		move.w	(v_screenposx).w,d0
		move.w	#$328,d1
		cmpi.w	#$500,d0
		bcs.s	@setwater
		move.w	#$3C8,d1
		cmpi.w	#$B00,d0
		bcs.s	@setwater
		move.w	#$428,d1

	@setwater:
		move.w	d1,(v_waterpos3).w
		rts	
; ===========================================================================

DynWater_LZ3:				; XREF: DynWater_Index
		move.w	(v_screenposx).w,d0
		move.b	(v_wtr_routine).w,d2
		bne.s	@routine2

		move.w	#$900,d1
		cmpi.w	#$600,d0	; has screen reached position?
		bcs.s	@setwaterlz3	; if not, branch
		cmpi.w	#$3C0,(v_player+obY).w
		bcs.s	@setwaterlz3
		cmpi.w	#$600,(v_player+obY).w ; is Sonic in a y-axis range?
		bcc.s	@setwaterlz3	; if not, branch

		move.w	#$4C8,d1	; set new water height
		move.b	#$4B,(v_lvllayout+$106).w ; update level layout
		move.b	#1,(v_wtr_routine).w ; use second routine next
		move.w	#sfx_Rumbling,d0
		bsr.w	PlaySound_Special ; play sound $B7 (rumbling)

	@setwaterlz3:
		move.w	d1,(v_waterpos3).w
		move.w	d1,(v_waterpos2).w ; change water height instantly
		rts	
; ===========================================================================

@routine2:
		subq.b	#1,d2
		bne.s	@routine3
		move.w	#$4C8,d1
		cmpi.w	#$770,d0
		bcs.s	@setwater2
		move.w	#$308,d1
		cmpi.w	#$1400,d0
		bcs.s	@setwater2
		cmpi.w	#$508,(v_waterpos3).w
		beq.s	@sonicislow
		cmpi.w	#$600,(v_player+obY).w ; is Sonic below $600 y-axis?
		bcc.s	@sonicislow	; if yes, branch
		cmpi.w	#$280,(v_player+obY).w
		bcc.s	@setwater2

@sonicislow:
		move.w	#$508,d1
		move.w	d1,(v_waterpos2).w
		cmpi.w	#$1770,d0
		bcs.s	@setwater2
		move.b	#2,(v_wtr_routine).w

	@setwater2:
		move.w	d1,(v_waterpos3).w
		rts	
; ===========================================================================

@routine3:
		subq.b	#1,d2
		bne.s	@routine4
		move.w	#$508,d1
		cmpi.w	#$1860,d0
		bcs.s	@setwater3
		move.w	#$188,d1
		cmpi.w	#$1AF0,d0
		bcc.s	@loc_3DC6
		cmp.w	(v_waterpos2).w,d1
		bne.s	@setwater3

	@loc_3DC6:
		move.b	#3,(v_wtr_routine).w

	@setwater3:
		move.w	d1,(v_waterpos3).w
		rts	
; ===========================================================================

@routine4:
		subq.b	#1,d2
		bne.s	@routine5
		move.w	#$188,d1
		cmpi.w	#$1AF0,d0
		bcs.s	@setwater4
		move.w	#$900,d1
		cmpi.w	#$1BC0,d0
		bcs.s	@setwater4
		move.b	#4,(v_wtr_routine).w
		move.w	#$608,(v_waterpos3).w
		move.w	#$7C0,(v_waterpos2).w
		move.b	#1,(f_switch+8).w
		rts	
; ===========================================================================

@setwater4:
		move.w	d1,(v_waterpos3).w
		move.w	d1,(v_waterpos2).w
		rts	
; ===========================================================================

@routine5:
		cmpi.w	#$1E00,d0	; has screen passed final position?
		bcs.s	@dontset	; if not, branch
		move.w	#$128,(v_waterpos3).w

	@dontset:
		rts	
; ===========================================================================

DynWater_SBZ3:				; XREF: DynWater_Index
		move.w	#$228,d1
		cmpi.w	#$F00,(v_screenposx).w
		bcs.s	@setwater
		move.w	#$4C8,d1

	@setwater:
		move.w	d1,(v_waterpos3).w
		rts

; ---------------------------------------------------------------------------
; Labyrinth Zone "wind tunnels"	subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LZWindTunnels:				; XREF: LZWaterFeatures
		tst.w	(v_debuguse).w	; is debug mode	being used?
		bne.w	@quit	; if yes, branch
		lea	(LZWind_Data+8).l,a2
		moveq	#0,d0
		move.b	(v_act).w,d0	; get act number
		lsl.w	#3,d0		; multiply by 8
		adda.w	d0,a2		; add to address for data
		moveq	#0,d1
		tst.b	(v_act).w	; is act number 1?
		bne.s	@notact1	; if not, branch
		moveq	#1,d1
		subq.w	#8,a2		; use different data for act 1

	@notact1:
		lea	(v_player).w,a1

@chksonic:
		move.w	obX(a1),d0
		cmp.w	(a2),d0
		bcs.w	@chknext
		cmp.w	4(a2),d0
		bcc.w	@chknext
		move.w	obY(a1),d2
		cmp.w	2(a2),d2
		bcs.s	@chknext
		cmp.w	6(a2),d2
		bcc.s	@chknext	; branch if Sonic is outside a range
		move.b	(v_vbla_byte).w,d0
		andi.b	#$3F,d0		; does VInt counter fall on 0, $40, $80 or $C0?
		bne.s	@skipsound	; if not, branch
		sfx	sfx_Waterfall	; play rushing water sound (only every $40 frames)

	@skipsound:
		tst.b	(f_wtunnelallow).w ; are wind tunnels disabled?
		bne.w	@quit	; if yes, branch
		cmpi.b	#4,obRoutine(a1) ; is Sonic hurt/dying?
		bcc.s	@clrquit	; if yes, branch
		move.b	#1,(f_wtunnelmode).w
		subi.w	#$80,d0
		cmp.w	(a2),d0
		bcc.s	@movesonic
		moveq	#2,d0
		cmpi.b	#1,(v_act).w	; is act number 2?
		bne.s	@notact2	; if not, branch
		neg.w	d0

	@notact2:
		add.w	d0,obY(a1)	; adjust Sonic's y-axis for curve of tunnel

@movesonic:
		addq.w	#4,obX(a1)
		move.w	#$400,obVelX(a1) ; move Sonic horizontally
		move.w	#0,obVelY(a1)
		move.b	#$F,obAnim(a1)	; use floating animation
		bset	#1,obStatus(a1)
		btst	#0,(v_jpadhold2).w ; is up pressed?
		beq.s	@down		; if not, branch
		subq.w	#1,obY(a1)	; move Sonic up on pole

	@down:
		btst	#1,(v_jpadhold2).w ; is down being pressed?
		beq.s	@end		; if not, branch
		addq.w	#1,obY(a1)	; move Sonic down on pole

	@end:
		rts	
; ===========================================================================

@chknext:
		addq.w	#8,a2		; use second set of values (act 1 only)
		dbf	d1,@chksonic	; on act 1, repeat for a second tunnel
		tst.b	(f_wtunnelmode).w ; is Sonic still in a tunnel?
		beq.s	@quit		; if yes, branch
		move.b	#0,obAnim(a1)	; use walking animation

@clrquit:
		clr.b	(f_wtunnelmode).w ; finish tunnel

@quit:
		rts	
; End of function LZWindTunnels

; ===========================================================================

		;    left, top,  right, bottom boundaries
LZWind_Data:	dc.w $A80, $300, $C10,  $380 ; act 1 values (set 1)
		dc.w $F80, $100, $1410,	$180 ; act 1 values (set 2)
		dc.w $460, $400, $710,  $480 ; act 2 values
		dc.w $A20, $600, $1610, $6E0 ; act 3 values
		dc.w $C80, $600, $13D0, $680 ; SBZ act 3 values
		even

; ---------------------------------------------------------------------------
; Labyrinth Zone water slide subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LZWaterSlides:				; XREF: LZWaterFeatures
		lea	(v_player).w,a1
		btst	#1,obStatus(a1)	; is Sonic jumping?
		bne.s	loc_3F6A	; if not, branch
		move.w	obY(a1),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.b	obX(a1),d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a2
		move.b	(a2,d0.w),d0
		lea	byte_3FCF(pc),a2
		moveq	#6,d1

loc_3F62:
		cmp.b	-(a2),d0
		dbeq	d1,loc_3F62
		beq.s	LZSlide_Move

loc_3F6A:
		tst.b	(f_jumponly).w
		beq.s	locret_3F7A
		move.w	#5,$3E(a1)
		clr.b	(f_jumponly).w

locret_3F7A:
		rts	
; ===========================================================================

LZSlide_Move:
		cmpi.w	#3,d1
		bcc.s	loc_3F84
		nop	

loc_3F84:
		bclr	#0,obStatus(a1)
		move.b	byte_3FC0(pc,d1.w),d0
		move.b	d0,obInertia(a1)
		bpl.s	loc_3F9A
		bset	#0,obStatus(a1)

loc_3F9A:
		clr.b	obInertia+1(a1)
		move.b	#id_WaterSlide,obAnim(a1) ; use Sonic's "sliding" animation
		move.b	#1,(f_jumponly).w ; lock controls (except jumping)
		move.b	(v_vbla_byte).w,d0
		andi.b	#$1F,d0
		bne.s	locret_3FBE
		sfx	sfx_Waterfall	; play water sound

locret_3FBE:
		rts	
; End of function LZWaterSlides

; ===========================================================================
byte_3FC0:	dc.b $A, $F5, $A, $F6, $F5, $F4, $B, 0,	2, 7, 3, $4C, $4B, 8, 4
byte_3FCF:	dc.b 0			; XREF: LZWaterSlides
		even
