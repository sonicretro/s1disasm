; ===========================================================================
; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

DeformLayers:
		tst.b	(f_nobgscroll).w			; is scrolling disabled?
		beq.s	.bgscroll				; if not, branch
		rts
; ===========================================================================

	.bgscroll:
		clr.w	(v_fg_scroll_flags).w			; clear all redraw flags
		clr.w	(v_bg1_scroll_flags).w
		clr.w	(v_bg2_scroll_flags).w
		clr.w	(v_bg3_scroll_flags).w

		bsr.w	ScrollHoriz				; update camera position & redraw flags
		bsr.w	ScrollVertical
		bsr.w	DynamicLevelEvents			; update level boundaries, load bosses etc.

		move.w	(v_screenposy).w,(v_scrposy_vdp).w	; v_scrposy_vdp is sent to VSRAM during VBlank
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w

		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone number
		add.w	d0,d0					; multiply by 2
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)			; goto relevant deformation code
; End of function DeformLayers

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:
		dc.w Deform_GHZ-Deform_Index
		dc.w Deform_LZ-Deform_Index
		dc.w Deform_MZ-Deform_Index
		dc.w Deform_SLZ-Deform_Index
		dc.w Deform_SYZ-Deform_Index
		dc.w Deform_SBZ-Deform_Index
		zonewarning Deform_Index,2
		dc.w Deform_GHZ-Deform_Index

; ===========================================================================
; ---------------------------------------------------------------------------
; Green	Hill Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_GHZ:
; REV01 - additional scrolling for clouds

		; block 3 - distant mountains
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#0,d6
		bsr.w	BGScroll_Block3				; update bg x pos and set redraw flags

		; block 2 - hills & waterfalls
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#7,d4					; multiply by $80
		moveq	#0,d6
		bsr.w	BGScroll_Block2				; update bg x pos and set redraw flags

		; calculate Y position
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_screenposy).w,d0			; get camera pos
		andi.w	#$7FF,d0				; maximum $7FF
		lsr.w	#5,d0					; divide by $20
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	.limitY					; branch if v_screenposy is between 0 and $400
		moveq	#0,d0					; use 0 if greater
	.limitY:
		move.w	d0,d4
		move.w	d0,(v_bgscrposy_vdp).w			; update bg y pos

		; get FG X position (force 0 on title screen)
		move.w	(v_screenposx).w,d0			; use regular camera X-position as input
		cmpi.b	#id_Title,(v_gamemode).w		; are we on the title screen?
		bne.s	.notTitle				; if not, branch
		moveq	#0,d0					; force FB X-position to 0 at all times (to keep Title Screen emblem in place)
	.notTitle:
		neg.w	d0
		swap	d0

		; auto-scroll clouds
		lea	(v_bgscroll_buffer).w,a2
		addi.l	#$10000,(a2)+				; autoscroll upper cloud fastest
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+

		; calculate background scroll
		move.w	(v_bgscroll_buffer).w,d0		; get autoscroll position of upper cloud
		add.w	(v_bg3screenposx).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#32-1,d1
		sub.w	d4,d1
		bcs.s	.gotoCloud2
	.cloudLoop1:						; upper cloud (32px)
		move.l	d0,(a1)+				; write to v_hscrolltablebuffer
		dbf	d1,.cloudLoop1

	.gotoCloud2:
		move.w	(v_bgscroll_buffer+4).w,d0		; get autoscroll position of middle cloud
		add.w	(v_bg3screenposx).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#16-1,d1
	.cloudLoop2:						; middle cloud (16px)
		move.l	d0,(a1)+				; write to v_hscrolltablebuffer
		dbf	d1,.cloudLoop2

		move.w	(v_bgscroll_buffer+8).w,d0		; get autoscroll position of lower cloud
		add.w	(v_bg3screenposx).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#16-1,d1
	.cloudLoop3:						; lower cloud (16px)
		move.l	d0,(a1)+				; write to v_hscrolltablebuffer
		dbf	d1,.cloudLoop3

		; mountains
		move.w	#48-1,d1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
	.mountainLoop:						; distant mountains (48px)
		move.l	d0,(a1)+
		dbf	d1,.mountainLoop

		; hills and waterfalls
		move.w	#40-1,d1
		move.w	(v_bg2screenposx).w,d0
		neg.w	d0
	.hillLoop:						; hills & waterfalls (40px)
		move.l	d0,(a1)+
		dbf	d1,.hillLoop

		; water
		move.w	(v_bg2screenposx).w,d0
		move.w	(v_screenposx).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#72-1,d1
		add.w	d4,d1
	.waterLoop:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,.waterLoop
		rts
; End of function Deform_GHZ

; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_LZ:
		; plain background scroll
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_XY

		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w

; REV01 - additional water ripple effects

		lea	(Lz_Scroll_Data).l,a3			; get foreground ripple data
		lea	(Drown_WobbleData).l,a2			; get background ripple data (see Objects\LZ Drowning Numbers.asm)
		move.b	(v_lz_deform).w,d2			; get high byte of y pos. of ripple effect
		move.b	d2,d3
		addi.w	#$80,(v_lz_deform).w			; add $80 to low byte (i.e. high byte increments every other frame)

		add.w	(v_bgscreenposy).w,d2
		andi.w	#$FF,d2					; d2 = low byte of bg y pos
		add.w	(v_screenposy).w,d3
		andi.w	#$FF,d3					; d3 = low byte of camera y pos

		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224-1,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		move.w	d0,d6
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0

; REV01 - additional water ripple effects

		move.w	(v_waterpos1).w,d4
		move.w	(v_screenposy).w,d5

		; write normal scroll before meeting water position
	.normalLoop:
		cmp.w	d4,d5					; is current scanline at or below actual water y pos?
		bge.s	.underwaterLoop				; if yes, branch
		move.l	d0,(a1)+				; write to v_hscrolltablebuffer without ripple effect
		addq.w	#1,d5					; next scanline
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,.normalLoop
		rts
; ---------------------------------------------------------------------------

		; apply ripple effects when underwater
	.underwaterLoop:
		move.b	(a3,d3.w),d4				; get fg ripple value from Lz_Scroll_Data
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+				; write to v_hscrolltablebuffer
		move.b	(a2,d2.w),d4				; get bg ripple value from Drown_WobbleData
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+				; write to v_hscrolltablebuffer
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,.underwaterLoop
		rts
; ===========================================================================

Lz_Scroll_Data:
		dc.b 1,1,2,2,3,3,3,3,2,2,1,1			; 12 lines shifted to right
		dcb.b 116, 0					; 116 lines normal
		dc.b -1,-1,-2,-2,-3,-3,-3,-3,-2,-2,-1,-1	; 12 lines shifted to left
		dcb.b 20, 0					; 20 lines normal
		dc.b 1,1,2,2,3,3,3,3,2,2,1,1			; 12 lines shifted to right
		dcb.b 84, 0					; 84 lines normal (total 256 lines)
; End of function Deform_LZ

; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_MZ:
		; block 1 - dungeon interior
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $C0

		moveq	#2,d6
		bsr.w	BGScroll_Block1

		; block 3 - mountains
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#6,d4					; multiply by $40
		moveq	#6,d6
		bsr.w	BGScroll_Block3

		; block 2 - bushes & antique buildings
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#7,d4					; multiply by $80
		moveq	#4,d6
		bsr.w	BGScroll_Block2

		; calculate y position of background
		move.w	#512,d0					; start with 512px, ignoring 2 chunks
		move.w	(v_screenposy).w,d1
		subi.w	#456,d1
		bcs.s	.noYscroll				; branch if v_screenposy < 456
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0					; d0 = 512+((v_screenposy-456)*0.75) = (v_screenposy*0.75)+170
	.noYscroll:
		move.w	d0,(v_bg2screenposy).w
		move.w	d0,(v_bg3screenposy).w
		bsr.w	BGScroll_YAbsolute
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w

		; do something with redraw flags
		move.b	(v_bg1_scroll_flags).w,d0
		or.b	(v_bg2_scroll_flags).w,d0
		or.b	d0,(v_bg3_scroll_flags).w
		clr.b	(v_bg1_scroll_flags).w
		clr.b	(v_bg2_scroll_flags).w

		; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
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
		move.w	#5-1,d1
	.cloudLoop:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#2-1,d1
	.mountainLoop:
		move.w	d0,(a1)+
		dbf	d1,.mountainLoop

		move.w	(v_bg2screenposx).w,d0
		neg.w	d0
		move.w	#9-1,d1
	.bushLoop:
		move.w	d0,(a1)+
		dbf	d1,.bushLoop

		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		move.w	#16-1,d1
	.interiorLoop:
		move.w	d0,(a1)+
		dbf	d1,.interiorLoop

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		subi.w	#512,d0					; subtract 512px (unused 2 chunks)
		move.w	d0,d2
		cmpi.w	#$100,d0
		bcs.s	.limitY
		move.w	#$100,d0
	.limitY:
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	BGScroll_X
; End of function Deform_MZ

; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_SLZ:
		; vertical scrolling
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_Y
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w

		; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
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
		move.w	#28-1,d1
	.starLoop:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.starLoop

		move.w	d2,d0
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#5-1,d1
	.buildingLoop1:						; distant black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop1

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#5-1,d1
	.buildingLoop2:						; closer buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop2

		move.w	d2,d0
		asr.w	#1,d0
		move.w	#30-1,d1
	.bottomLoop:						; bottom part of background
		move.w	d0,(a1)+
		dbf	d1,.bottomLoop

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2					; d2 = v_bgscreenposy
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0					; d0 = (v_bgscreenposy-$C0)/8
		lea	(a2,d0.w),a2				; jump to relevant part of bg scroll buffer
		; Fall-through to BGScroll_X...
; End of function Deform_SLZ

; ---------------------------------------------------------------------------
; Subroutine to update the hscroll buffer with contents of bg scroll buffer
; and camera x position
; 
; input:
;	d2 = background y position
;	a2 = address of bg scroll buffer
; ---------------------------------------------------------------------------

; Bg_Scroll_X: UpdateHscrollBuffer:
BGScroll_X:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#15-1,d1
		move.w	(v_screenposx).w,d0			; get camera x pos
		neg.w	d0					; make negative
		swap	d0					; move to high word
		andi.w	#$F,d2					; read low nybble of bg y pos
		add.w	d2,d2					; multiply by 2
		move.w	(a2)+,d0				; get 1st value from bg scroll buffer
		jmp	.skip_rows(pc,d2.w)			; skip rows that are off screen

	.loop_hscroll:
		move.w	(a2)+,d0				; get subsequent value from bg scroll buffer
	.skip_rows:
	rept 16
		move.l	d0,(a1)+				; write 16 fg/bg values to v_hscrolltablebuffer
	endr
		dbf	d1,.loop_hscroll
		rts
; End of function BGScroll_X

; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

Deform_SYZ:
		; vertical scrolling
		move.w	(v_scrshifty).w,d5			; get camera y pos change since last frame
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5					; multiply by $30
		bsr.w	BGScroll_Y
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w

		; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
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
		move.w	#8-1,d1
	.cloudLoop:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	d2,d0
		asr.w	#3,d0
		move.w	#5-1,d1
	.mountainLoop:
		move.w	d0,(a1)+
		dbf	d1,.mountainLoop

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#6-1,d1
	.buildingLoop:
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop

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
		move.w	#14-1,d1
	.bushLoop:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.bushLoop

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	BGScroll_X
; End of function Deform_SYZ

; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

Deform_SBZ:
; REV01 - different scrolling for act 1

		tst.b	(v_act).w				; is this SBZ act 1?
		bne.w	Deform_SBZ2				; if not, branch

		; block 1 - lower black buildings
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#7,d4					; multiply by $80
		moveq	#2,d6
		bsr.w	BGScroll_Block1

		; block 3 - distant brown buildings
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#6,d4					; multiply by $40
		moveq	#6,d6
		bsr.w	BGScroll_Block3

		; block 2 - upper black buildings
		move.w	(v_scrshiftx).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#4,d6
		bsr.w	BGScroll_Block2

		; vertical scrolling
		moveq	#0,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_YRelative

		move.w	(v_bgscreenposy).w,d0
		move.w	d0,(v_bg2screenposy).w
		move.w	d0,(v_bg3screenposy).w
		move.w	d0,(v_bgscrposy_vdp).w
		move.b	(v_bg1_scroll_flags).w,d0
		or.b	(v_bg3_scroll_flags).w,d0
		or.b	d0,(v_bg2_scroll_flags).w
		clr.b	(v_bg1_scroll_flags).w
		clr.b	(v_bg3_scroll_flags).w

		; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
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
		move.w	#4-1,d1
	.cloudLoop:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#10-1,d1
	.buildingLoop1:						; distant brown buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop1

		move.w	(v_bg2screenposx).w,d0
		neg.w	d0
		move.w	#7-1,d1
	.buildingLoop2:						; upper black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop2

		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		move.w	#11-1,d1
	.buildingLoop3:						; lower black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop3

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	BGScroll_X
;-------------------------------------------------------------------------------

; loc_68A2:
Deform_SBZ2:
		; plain background deformation
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_XY
		move.w	(v_bgscreenposy).w,(v_bgscrposy_vdp).w

		; copy fg & bg x-position to h-scroll table
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224-1,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
	.loop_hscroll:
		move.l	d0,(a1)+
		dbf	d1,.loop_hscroll
		rts
; End of function Deform_SBZ

; ===========================================================================

	; ScrollHoriz and ScrollVertical camera position update subroutines.
	; Extracted into a separate file because they are only tangentially
	; related to background deformation, and identical in REV00 and REV01.
	; (This file includes MoveScreenHoriz!)
	include	"_inc/ScrollHoriz & ScrollVertical.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	update bg position and redraw flags
; 
; input:
;	d4 = background x-diff
;	d5 = background y-diff
; ---------------------------------------------------------------------------

; ScrollBlock1:
BGScroll_XY:
		move.l	(v_bgscreenposx).w,d2
		move.l	d2,d0					; save old bg position
		add.l	d4,d0					; apply difference
		move.l	d0,(v_bgscreenposx).w			; update bg position
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_xblock).w,d3
		eor.b	d3,d1
		bne.s	BGScroll_YRelative			; insufficient change to redraw bg
		eori.b	#$10,(v_bg1_xblock).w
		sub.l	d2,d0					; new bg pos minus old
		bpl.s	.redraw_right				; branch if positive (i.e. moving right)
		bset	#2,(v_bg1_scroll_flags).w
		bra.s	BGScroll_YRelative

	.redraw_right:
		bset	#3,(v_bg1_scroll_flags).w
		; Fall-through to BGScroll_YRelative...
; ---------------------------------------------------------------------------

; loc_679C:
BGScroll_YRelative:
		move.l	(v_bgscreenposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscreenposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_yblock).w
		sub.l	d3,d0
		bpl.s	.redraw_bottom
		bset	#0,(v_bg1_scroll_flags).w
		rts

	.redraw_bottom:
		bset	#1,(v_bg1_scroll_flags).w

	.return:
		rts
; End of function BGScroll_XY
; ===========================================================================

; ScrollBlock2: Bg_Scroll_Y:
BGScroll_Y:
		move.l	(v_bgscreenposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscreenposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_yblock).w
		sub.l	d3,d0
		bpl.s	.redraw_bottom
		bset	#4,(v_bg1_scroll_flags).w
		rts

	.redraw_bottom:
		bset	#5,(v_bg1_scroll_flags).w

	.return:
		rts
; End of function BGScroll_Y

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	update bg y position and redraw flags
; 
; input:
;	d0 = new background y position
; ---------------------------------------------------------------------------

; ScrollBlock3:
BGScroll_YAbsolute:
		move.w	(v_bgscreenposy).w,d3			; save old bg position
		move.w	d0,(v_bgscreenposy).w			; update bg position
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_yblock).w
		sub.w	d3,d0
		bpl.s	.redraw_bottom
		bset	#0,(v_bg1_scroll_flags).w
		rts

	.redraw_bottom:
		bset	#1,(v_bg1_scroll_flags).w

	.return:
		rts
; End of function BGScroll_YAbsolute

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutines to update bg position and redraw flags for bg blocks 1, 2 and 3
; 
; input:
;	d4 = background x diff
;	d6 = bit to set for redraw direction
; ---------------------------------------------------------------------------

BGScroll_Block1:
		move.l	(v_bgscreenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscreenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_xblock).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_xblock).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg1_scroll_flags).w
		bra.s	.return

	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg1_scroll_flags).w

	.return:
		rts
; End of function BGScroll_Block1
; ===========================================================================

BGScroll_Block2:
		move.l	(v_bg2screenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg2screenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg2_xblock).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg2_xblock).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg2_scroll_flags).w
		bra.s	.return

	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg2_scroll_flags).w

	.return:
		rts
; End of function BGScroll_Block2
; ===========================================================================

BGScroll_Block3:
		move.l	(v_bg3screenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg3screenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg3_xblock).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg3_xblock).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg3_scroll_flags).w
		bra.s	.return

	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg3_scroll_flags).w

	.return:
		rts
; End of function BGScroll_Block3
