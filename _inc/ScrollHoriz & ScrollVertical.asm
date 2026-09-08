; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to scroll the level horizontally as Sonic moves (+ redraw flags)
; ---------------------------------------------------------------------------

ScrollHoriz:
		move.w	(v_screenposx).w,d4			; save old screen X-position before calling MoveScreenHoriz
		bsr.s	MoveScreenHoriz				; update camera X-position based on Sonic's current X-position

		move.w	(v_screenposx).w,d0			; get updated camera X-position
		andi.w	#$10,d0					; redraw a column of blocks every $10px
		move.b	(v_fg_xblock).w,d1			; get expected state of screen position (alternates between $00 and $10)
		eor.b	d1,d0					; check if screen position matches it
		bne.s	.return					; if not, no block boundary was crossed
		eori.b	#$10,(v_fg_xblock).w			; toggle expected state for next boundary crossing
		move.w	(v_screenposx).w,d0			; get updated camera X-position
		sub.w	d4,d0					; compare new with old screen position
		bpl.s	.scrollRight				; branch if scrolling right

	.scrollLeft:
		bset	#2,(v_fg_scroll_flags).w		; draw a new column at left of screen
		rts						; return

	; loc_65AA:
	.scrollRight:
		bset	#3,(v_fg_scroll_flags).w		; draw a new column at right of screen

	; locret_65B0:
	.return:
		rts						; return
; ===========================================================================

; ScrollHoriz2:
MoveScreenHoriz:
		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		sub.w	(v_screenposx).w,d0			; d0 = Sonic's distance from left edge of screen

		subi.w	#(320/2)-16,d0				; is distance less than 144px?
	if FixBugs
		; Fix horizontal wrap bug (left)
		blt.s	SH_MoveCameraLeft			; if yes, branch (signed)
	else
		bcs.s	SH_MoveCameraLeft			; if yes, branch (unsigned)
	endif

		subi.w	#16,d0					; is distance more than 160px?
	if FixBugs
		; Fix horizontal wrap bug (right)
		bge.s	SH_MoveCameraRight			; if yes, branch (signed)
	else
		bcc.s	SH_MoveCameraRight			; if yes, branch (unsigned)
	endif

		clr.w	(v_scrshiftx).w				; Sonic is within the sweet spot, do not update camera shift
		rts						; return
; ---------------------------------------------------------------------------

; SH_AheadOfMid:
SH_MoveCameraRight:
		cmpi.w	#16,d0					; is Sonic within 16px of middle area?
		blo.s	.moveRight				; if yes, branch
		move.w	#16,d0					; set to 16 if greater

	; SH_Ahead16:
	.moveRight:
		add.w	(v_screenposx).w,d0			; add current camera position to Sonic's X-offset

		cmp.w	(v_limitright2).w,d0			; is camera past the right level boundary?
		blt.s	SH_SetScreen				; if not, branch
		move.w	(v_limitright2).w,d0			; limit camera X-position to right boundary

; loc_65E4:
SH_SetScreen:
		move.w	d0,d1					; copy X-screen position to calculate scroll shift
		sub.w	(v_screenposx).w,d1			; get just the scroll difference
		asl.w	#8,d1					; shift scroll difference but a byte (8.8 fixed)
		move.w	d0,(v_screenposx).w			; set new X-screen position
		move.w	d1,(v_scrshiftx).w			; set distance for screen movement
		rts						; return
; ---------------------------------------------------------------------------

; SH_BehindMid:
SH_MoveCameraLeft:
	if FixBugs
		; Fix leftside movement not being capped (unlike rightside movement),
		; which can result in draw errors if going too fast to the left.
		cmpi.w	#-16,d0					; is Sonic within -16px of middle area?
		bgt.s	.moveLeft				; if yes, branch
		move.w	#-16,d0					; set to -16 if lower
	endif

	; SH_Behind16:
	.moveLeft:
		add.w	(v_screenposx).w,d0			; add current camera position to Sonic's X-offset

		cmp.w	(v_limitleft2).w,d0			; is camera before the left level boundary?
		bgt.s	SH_SetScreen				; if not, branch
		move.w	(v_limitleft2).w,d0			; limit camera X-position to left boundary
		bra.s	SH_SetScreen				; set new position and calculate scroll difference
; End of function ScrollHoriz
; ===========================================================================

; Dead, unused code.
AutoScroll_Unused:
		; This appears to be some sort of autoscrolling logic that moves
		; the camera at a fixed rate of 2px per frame left or right,
		; depending on whether d0 as input value is negative or positive.

		tst.w	d0					; is d0 positive?
		bpl.s	.autoScrollRight			; if yes, branch

	.autoScrollLeft:
		move.w	#-2,d0					; move camera to the left
		bra.s	SH_MoveCameraLeft			; go to left-moving logic

	; loc_6610:
	.autoScrollRight:
		move.w	#2,d0					; move camera to the right
		bra.s	SH_MoveCameraRight			; go to right-moving logic
; End of function AutoScroll_Unused

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to scroll the level vertically as Sonic moves (+ redraw flags)
; ---------------------------------------------------------------------------

ScrollVertical:
		moveq	#0,d1					; clear d1

		move.w	(v_player+obY).w,d0			; get Sonic's current Y-position
		sub.w	(v_screenposy).w,d0			; d0 = Sonic's distance from top of screen

		btst	#2,(v_player+obStatus).w		; is Sonic rolling?
		beq.s	.checkInAir				; if not, branch
		subq.w	#sonic_height-sonic_roll_height,d0	; adjust distance for roll height

	; SV_NotRolling:
	.checkInAir:
		btst	#1,(v_player+obStatus).w		; is Sonic in-air?
		beq.s	SV_OnGround				; if not, branch

		addi.w	#32,d0					; lower in-air sweet spot is 32px
		sub.w	(v_lookshift).w,d0			; subtract current shift when holding Up/Down buttons (default = $60)
		bcs.s	SV_ScrollFast				; if Sonic is below sweet spot, branch
		subi.w	#32*2,d0				; upper in-air sweet spot is also 32px
		bcc.s	SV_ScrollFast				; if Sonic is above sweet spot, branch

		tst.b	(f_bgscrollvert).w			; is bottom level boundary currently getting changed?
		bne.s	SV_BottomBoundaryMoving			; if yes, branch
		bra.s	SV_NoUpdate				; otherwise, camera Y-position doesn't need updating
; ===========================================================================

; loc_664A:
SV_OnGround:
		sub.w	(v_lookshift).w,d0			; subtract current shift when holding Up/Down buttons (default = 96px)
		bne.s	SV_OutsideMid				; if Sonic is not exactly 96px from top screen, branch
		tst.b	(f_bgscrollvert).w			; is bottom level boundary currently getting changed?
		bne.s	SV_BottomBoundaryMoving			; if yes, branch

; loc_6656:
SV_NoUpdate:
		clr.w	(v_scrshifty).w				; camera does not move vertically this frame
		rts						; return
; ---------------------------------------------------------------------------

; loc_665C:
SV_OutsideMid:
		cmpi.w	#$60,(v_lookshift).w			; is current Up/Down shift at default value?
		bne.s	SV_ScrollSlow				; if not, branch

		move.w	(v_player+obInertia).w,d1		; get Sonic's current ground speed
		bpl.s	.chkSpeed				; if positive, branch
		neg.w	d1					; make positive for check
	; loc_666C:
	.chkSpeed:
		cmpi.w	#$800,d1				; is Sonic moving very fast?
		bhs.s	SV_ScrollFast				; if yes, branch

; .slowAndNotShifted:
SV_ScrollMedium:
		move.w	#6<<8,d1				; scroll 6px up/down
		cmpi.w	#6,d0					; is Sonic 6px below middle area?
		bgt.s	SV_MoveCameraDown			; if yes, branch
		cmpi.w	#-6,d0					; is Sonic 6px above middle area?
		blt.s	SV_MoveCameraUp				; if yes, branch
		bra.s	SV_SweetSpot				; branch if in sweet spot
; ---------------------------------------------------------------------------

; loc_6684:
SV_ScrollSlow:
		move.w	#2<<8,d1				; scroll 2px up/down
		cmpi.w	#2,d0					; is Sonic 2px below middle area?
		bgt.s	SV_MoveCameraDown			; if yes, branch
		cmpi.w	#-2,d0					; is Sonic 2px above middle area?
		blt.s	SV_MoveCameraUp				; if yes, branch
		bra.s	SV_SweetSpot				; branch if in sweet spot
; ---------------------------------------------------------------------------

; loc_6696:
SV_ScrollFast:
		move.w	#16<<8,d1				; scroll 16px up/down
		cmpi.w	#16,d0					; is Sonic 16px below middle area?
		bgt.s	SV_MoveCameraDown			; if yes, branch
		cmpi.w	#-16,d0					; is Sonic 16px above middle area?
		blt.s	SV_MoveCameraUp				; if yes, branch
		bra.s	SV_SweetSpot				; branch if in sweet spot
; ===========================================================================

; loc_66A8:
SV_BottomBoundaryMoving:
		moveq	#0,d0					; treat Sonic as being exactly in the sweet spot
		move.b	d0,(f_bgscrollvert).w			; clear bottom boundary moving flag this frame

; loc_66AE:
SV_SweetSpot:
		moveq	#0,d1					; clear d1, will be used to calculate new camera Y-position
		move.w	d0,d1					; copy Sonic's distance from exactly the middle of sweet spot
		add.w	(v_screenposy).w,d1			; add current screen position
		tst.w	d0					; check if Sonic is above or below sweet spot
		bpl.w	SV_BottomBoundary			; branch if going down or not moving at all
		bra.w	SV_TopBoundary				; branch if going up
; ===========================================================================

; loc_66C0:
SV_MoveCameraUp:
		neg.w	d1					; make specified scroll pixels negative when going up
		ext.l	d1					; extend scroll pixels to long
		asl.l	#8,d1					; shift up a byte (camera position is 16.16 fixed)
		add.l	(v_screenposy).w,d1			; add previous camera Y-position
		swap	d1					; get integer part for boundary check

; loc_66CC:
SV_TopBoundary:
		cmp.w	(v_limittop2).w,d1			; is new camera Y-position above top level boundary?
		bgt.s	SV_SetScreen				; if not, branch
		cmpi.w	#-$100,d1				; does level wrap vertically? (top boundary set to -$100)
		bgt.s	.noWrap					; if not, branch
		andi.w	#$7FF,d1				; wrap expected new camera Y-position
		andi.w	#$7FF,(v_player+obY).w			; wrap Sonic vertically
		andi.w	#$7FF,(v_screenposy).w			; wrap camera Y-position
		andi.w	#$3FF,(v_bgscreenposy).w		; wrap background Y-position
		bra.s	SV_SetScreen				; set updated screen position
; ---------------------------------------------------------------------------

	; loc_66F0:
	.noWrap:
		move.w	(v_limittop2).w,d1			; limit camera Y-position to top boundary
		bra.s	SV_SetScreen				; set new camera Y-position
; ===========================================================================

; loc_66F6:
SV_MoveCameraDown:
		ext.l	d1					; extend scroll pixels to long
		asl.l	#8,d1					; shift up a byte (camera position is 16.16 fixed)
		add.l	(v_screenposy).w,d1			; add previous camera Y-position
		swap	d1					; get integer part for boundary check

; loc_6700:
SV_BottomBoundary:
		cmp.w	(v_limitbtm2).w,d1			; is new camera Y-position below bottom level boundary?
		blt.s	SV_SetScreen				; if not, branch
		subi.w	#$7FF+1,d1				; does level wrap vertically? (bottom boundary set to $800)
		bcs.s	.noWrap					; if not, branch
		andi.w	#$7FF,(v_player+obY).w			; wrap Sonic vertically
		subi.w	#$7FF+1,(v_screenposy).w		; move camera back to top +1
		andi.w	#$3FF,(v_bgscreenposy).w		; wrap background Y-position
		bra.s	SV_SetScreen				; set updated screen position

	; loc_6720:
	.noWrap:
		move.w	(v_limitbtm2).w,d1			; limit camera Y-position to bottom boundary
; ---------------------------------------------------------------------------

; loc_6724:
SV_SetScreen:
		move.w	(v_screenposy).w,d4			; save old screen Y-position before updating it
		swap	d1					; convert new integer Y-position to camera format (long, with subpixels)
		move.l	d1,d3					; copy new Y-position
		sub.l	(v_screenposy).w,d3			; calculate camera movement since last frame
		ror.l	#8,d3					; convert delta to v_scrshifty format
		move.w	d3,(v_scrshifty).w			; store vertical camera movement delta
		move.l	d1,(v_screenposy).w			; set new camera Y-position

		move.w	(v_screenposy).w,d0			; get updated camera Y-position
		andi.w	#$10,d0					; redraw a row of blocks every $10px
		move.b	(v_fg_yblock).w,d1			; get expected state of screen position (alternates between $00 and $10)
		eor.b	d1,d0					; check if screen position matches it
		bne.s	.return					; if not, no block boundary was crossed
		eori.b	#$10,(v_fg_yblock).w			; toggle expected state for next boundary crossing
		move.w	(v_screenposy).w,d0			; get updated camera Y-position
		sub.w	d4,d0					; compare new with old screen position
		bpl.s	.scrollDown				; branch if scrolling down

	.scrollUp:
		bset	#0,(v_fg_scroll_flags).w		; draw a new row at top of screen
		rts						; return

	; loc_6760:
	.scrollDown:
		bset	#1,(v_fg_scroll_flags).w		; draw a new row at bottom of screen

	; locret_6766:
	.return:
		rts						; return
; End of function ScrollVertical
; ===========================================================================
