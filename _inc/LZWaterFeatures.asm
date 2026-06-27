; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to do special water effects in Labyrinth Zone
; ---------------------------------------------------------------------------

LZWaterFeatures:
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.return					; if not, don't run any water effects at all

	if Revision<>0
		tst.b   (f_nobgscroll).w			; is Sonic drowning? (BG no-scroll flag)
		bne.s	.setWaterHeight				; if yes, skip other effects
	endif
		cmpi.b	#6,(v_player+obRoutine).w		; has Sonic just died?
		bhs.s	.setWaterHeight				; if yes, skip other effects

		bsr.w	LZWindTunnels				; run wind tunnels
		bsr.w	LZWaterSlides				; run water slides
		bsr.w	LZDynamicWater				; run dynamic water height
; ---------------------------------------------------------------------------

.setWaterHeight:
		clr.b	(f_wtr_state).w				; clear "screen is completely underwater" flag
		moveq	#0,d0					; clear d0 for word-sized water height
		move.b	(v_oscillate+2).w,d0			; get first entry in oscillatory values (frequency = 2; middle value = $10)
		lsr.w	#1,d0					; divide by 2
		add.w	(v_waterpos2).w,d0			; add internal water height without surface sway
		move.w	d0,(v_waterpos1).w			; set water height including surface sway

		move.w	(v_waterpos1).w,d0			; get water height including surface sway again (could've used d0 again...)
		sub.w	(v_screenposy).w,d0			; subtract current camera Y-position
		bhs.s	.checkWaterVisible			; if water is below top of screen, branch
		tst.w	d0					; check result again (redundant)
		bpl.s	.checkWaterVisible			; if water is below top of screen, branch
		move.b	#223,(v_hblank_line).w			; HBlank interrupt every 224 scanlines (starts at 0)
		move.b	#1,(f_wtr_state).w			; set screen is all underwater

	.checkWaterVisible:
		cmpi.w	#223,d0					; is water within 223 pixels of top of screen?
		blo.s	.setHBlankLine				; if yes, branch
		move.w	#223,d0					; HBlank interrupt every 224 scanlines (starts at 0)

	.setHBlankLine:
		move.b	d0,(v_hblank_line).w			; set chosen HBlank trigger scanline for swapping to underwater palette

	.return:
		rts						; return
; End of function LZWaterFeatures


; ===========================================================================
; ---------------------------------------------------------------------------
; Initial water heights at level start (loaded in GM_Level)
; ---------------------------------------------------------------------------
WaterHeight:	dc.w $B8	; Labyrinth act 1
		dc.w $328	; Labyrinth act 2
		dc.w $900	; Labyrinth act 3
		dc.w $228	; Scrap Brain act 3
		even


; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth dynamic water height routines per act (entirely hardcoded)
; ---------------------------------------------------------------------------

LZDynamicWater:
		moveq	#0,d0					; clear d0
		move.b	(v_act).w,d0				; get current act number (0-3)
		add.w	d0,d0					; double for word-based indexing
		move.w	DynWater_Index(pc,d0.w),d0		; find entry in jump table
		jsr	DynWater_Index(pc,d0.w)			; execute dynamic water for current act and return here

		moveq	#0,d1					; clear d1
		move.b	(f_water).w,d1				; get water enabled flag (this is always 1 here...)
		move.w	(v_waterpos3).w,d0			; get target water height
		sub.w	(v_waterpos2).w,d0			; subtract actual water height
		beq.s	.return					; if water level is correct, branch
		bhs.s	.updateWaterHeight			; if water level is too high, branch
		neg.w	d1					; set water to move up instead

	.updateWaterHeight:
		add.w	d1,(v_waterpos2).w			; move water height up/down

	.return:
		rts						; return

; ===========================================================================
DynWater_Index:	dc.w DynWater_LZ1-DynWater_Index
		dc.w DynWater_LZ2-DynWater_Index
		dc.w DynWater_LZ3-DynWater_Index
		dc.w DynWater_SBZ3-DynWater_Index
; ===========================================================================

; ---------------------------------------------------------------------------
; Dynamic Water Heights - Labyrinth Zone Act 1
; ---------------------------------------------------------------------------

DynWater_LZ1:
		move.w	(v_screenposx).w,d0			; get current camera X-position

		move.b	(v_wtr_routine).w,d2			; get current dynamic water routine
		bne.s	DynWater_LZ1_Routine1			; if not set to routine 0, branch

DynWater_LZ1_Routine0:
		move.w	#$B8,d1					; set water height to top area near beginning of level

		cmpi.w	#$600,d0				; has the screen passed the first door?
		blo.s	.setWaterTarget				; if not, branch to keep water in place
		move.w	#$108,d1				; otherwise, lower the water for the next hill with the "three Burrobots"

		cmpi.w	#$200,(v_player+obY).w			; is Sonic taking the secret shortcut top path?
		blo.s	.secretTopPath				; if yes, branch to perform the top path events instead

		cmpi.w	#$C00,d0				; has the screen passed the area with two lifting platforms and a spiked chain?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$318,d1				; otherwise, lower the water for the first conveyor belt area

		cmpi.w	#$1080,d0				; has the screen passed the very bottom tunnel door?
		blo.s	.setWaterTarget				; if not, branch
		move.b	#$80,(f_switch+5).w			; otherwise, set bit 7 in switch 5 (forces the door to close after)
		move.w	#$5C8,d1				; lower the water to the very bottom for a shallow tunnel

		cmpi.w	#$1380,d0				; has the screen reached the red spring for the vertical shaft?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$3A8,d1				; otherwise, rise the water for the second conveyor belt area

		cmp.w	(v_waterpos2).w,d1			; has the water reached that height yet?
		bne.s	.setWaterTarget				; if not, branch
		move.b	#1,(v_wtr_routine).w			; set to DynWater_LZ1_Routine1 (prevents water dropping back down if Sonic moves back)

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		rts						; return
; ---------------------------------------------------------------------------

.secretTopPath:
		cmpi.w	#$C80,d0				; has the screen passed the spikes & burrow bot?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$E8,d1					; move the water height uo

		cmpi.w	#$1500,d0				; has the screen reached the end of the tunnel (door made of blocks)?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$108,d1				; set water height for the final exit
		bra.s	.setWaterTarget				; continue to set the water height destination
; ===========================================================================

DynWater_LZ1_Routine1:
		subq.b	#1,d2					; is it set to routine 2?
		bne.s	.return					; if yes, branch (no more water heights events)

		cmpi.w	#$2E0,(v_player+obY).w			; has Sonic's Y position reached the tunnel full of corks yet?
		bhs.s	.return					; if not, branch
		move.w	#$3A8,d1				; keep water height at bottom of the second conveyor belts

		cmpi.w	#$1300,d0				; has the screen crossed into the tunnel full of corks yet?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$108,d1				; set water height to rise above the tunnel and lift the corks
		move.b	#2,(v_wtr_routine).w			; set to routine 2 (stop all further water changes)

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height

	.return:
		rts						; return
; ===========================================================================

; ---------------------------------------------------------------------------
; Dynamic Water Heights - Labyrinth Zone Act 2
; ---------------------------------------------------------------------------

DynWater_LZ2:
		move.w	(v_screenposx).w,d0			; get current camera X-position

		move.w	#$328,d1				; keep water height near the top for the end of the water slide

		cmpi.w	#$500,d0				; has the screen passed the first wind tunnel?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$3C8,d1				; lower the water a bit for the large room of platforms

		cmpi.w	#$B00,d0				; has the screen reached the area just before the "double conveyor belts room"?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$428,d1				; lower the water more for the "double conveyore belts room", and the end of level signpost

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		rts						; return
; ===========================================================================

; ---------------------------------------------------------------------------
; Dynamic Water Heights - Labyrinth Zone Act 3
; ---------------------------------------------------------------------------

DynWater_LZ3:
		move.w	(v_screenposx).w,d0			; get current camera X-position

		move.b	(v_wtr_routine).w,d2			; get current dynamic water routine
		bne.s	DynWater_LZ3_Routine1			; if not set to routine 0, branch

DynWater_LZ3_Routine0:
		move.w	#$900,d1				; force water to below $800 (this causes the water not to appear at all)

		cmpi.w	#$600,d0				; has the screen passed the area of the wall hole?
		blo.s	.setWaterTarget				; if not, branch
		cmpi.w	#$3C0,(v_player+obY).w			; is Sonic within the hole area between $3C0 and $5FF vertical?
		blo.s	.setWaterTarget				; ''
		cmpi.w	#$600,(v_player+obY).w			; ''
		bhs.s	.setWaterTarget				; if not, branch
		move.w	#$4C8,d1				; set new water height
		move.b	#$4B,(v_lvllayout_fg+((layout_row*2)+6)).w ; update chunk at row 2, column 6 (zero-based)
		move.b	#1,(v_wtr_routine).w			; set to DynWater_LZ3_Routine1
		move.w	#sfx_Rumbling,d0			; set rumbling sound
		bsr.w	QueueSound2				; play it

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		move.w	d1,(v_waterpos2).w			; change actual current water height instantly
		rts						; return
; ===========================================================================

DynWater_LZ3_Routine1:
		subq.b	#1,d2					; is dynamic water routine above 1?
		bne.s	DynWater_LZ3_Routine2			; if yes, branch

		move.w	#$4C8,d1				; set water height

		cmpi.w	#$770,d0				; has the screen reached the beginning of the "S" bendy tunnels to navigate through?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$308,d1				; raise water height to area with three spiked chains, and three spikes

		cmpi.w	#$1400,d0				; has the screen reached near the end of the level?
		blo.s	.setWaterTarget				; if not, branch
		cmpi.w	#$508,(v_waterpos3).w			; has the water destination been set for end of level yet (shallow for the lamppost)?
		beq.s	.checkEndArea				; if yes, branch
		cmpi.w	#$600,(v_player+obY).w			; is Sonic about to reach the end area (via underwater tunnel/bottom path)?
		bhs.s	.checkEndArea				; if yes, branch
		cmpi.w	#$280,(v_player+obY).w			; is Sonic about to reach the end area (via waterslide/top path)?
		bhs.s	.setWaterTarget				; if not, branch

	.checkEndArea:
		move.w	#$508,d1				; water height for ending area (shallow for the lamppost)
		move.w	d1,(v_waterpos2).w			; change actual current water height instantly

		cmpi.w	#$1770,d0				; has the screen reached the ending area with the lamppost, properly?
		blo.s	.setWaterTarget				; if not, branch
		move.b	#2,(v_wtr_routine).w			; set to DynWater_LZ3_Routine2

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		rts						; return
; ===========================================================================

DynWater_LZ3_Routine2:
		subq.b	#1,d2					; is dynamic water routine above 2?
		bne.s	DynWater_LZ3_Routine3			; if yes, branch

		move.w	#$508,d1				; keep water height at shallow area for the lamppost

		cmpi.w	#$1860,d0				; has the screen reached the first cork on the floor?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$188,d1				; rise the water so the corks lift as platforms

		cmpi.w	#$1AF0,d0				; has the screen passed the area with a rest room?
		bhs.s	.advanceRoutine				; if yes, branch
		cmp.w	(v_waterpos2).w,d1			; has the water reached its target yet?
		bne.s	.setWaterTarget				; if not, branch (stay in routine 2 until it has)

	.advanceRoutine:
		move.b	#3,(v_wtr_routine).w			; set to DynWater_LZ3_Routine3 (wrap area)

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		rts						; return
; ===========================================================================

DynWater_LZ3_Routine3:
		subq.b	#1,d2					; is dynamic water routine above 3?
		bne.s	DynWater_LZ3_Routine4			; if yes, branch

		move.w	#$188,d1				; keep water in place (just above rest room)

		cmpi.w	#$1AF0,d0				; has the screen passed the area with a rest room?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$900,d1				; force water to below $800 (this causes the water not to appear at all)

		cmpi.w	#$1BC0,d0				; has the screen reached the area with a sheild?
		blo.s	.setWaterTarget				; if not, branch
		move.b	#4,(v_wtr_routine).w			; set to DynWater_LZ3_Routine4 (boss area)
		move.w	#$608,(v_waterpos3).w			; set water target
		move.w	#$7C0,(v_waterpos2).w			; force water height to start at (to speed up rising)
		move.b	#1,(f_switch+8).w			; set switch 8 (opens a hidden door/wall; a switch was probably removed during developement)
		rts						; return
; ---------------------------------------------------------------------------

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		move.w	d1,(v_waterpos2).w			; change actual current water height instantly
		rts						; return
; ===========================================================================

DynWater_LZ3_Routine4:
	if FixBugs
		; If Sonic is able to stay on the left side of the tunnel while going up,
		; it's possible to go through the boss battle without raising the water at all.
		cmpi.w	#$1DA0,d0				;  has the screen passed $1DA0 (left side of the tunnel)?
	else
		cmpi.w	#$1E00,d0				; has the screen passed $1E00 (right side of the tunnel)?
	endif
		blo.s	.return					; if not, branch
		move.w	#$128,(v_waterpos3).w			; set water destination to the top of the level, so the water rises slowly in the boss area

	.return:
		rts						; return
; ===========================================================================

; ---------------------------------------------------------------------------
; Dynamic Water Heights - Scrap Brain Zone Act 3 (Labyrinth Zone Act 4)
; ---------------------------------------------------------------------------

DynWater_SBZ3:
		move.w	#$228,d1				; keep water height high up
		cmpi.w	#$F00,(v_screenposx).w			; is the screen in the far right area of the level (longest path)?
		blo.s	.setWaterTarget				; if not, branch
		move.w	#$4C8,d1				; lower the water height

	.setWaterTarget:
		move.w	d1,(v_waterpos3).w			; set target water height
		rts						; return
; End of function LZDynamicWater


; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone "wind tunnels" subroutine
; ---------------------------------------------------------------------------

LZWindTunnels:
		tst.w	(v_debuguse).w				; is debug mode being used?
		bne.w	.return					; if yes, ignore wind tunnels

		lea	(LZWind_Data+8).l,a2			; load wind tunnel data (start at second set for LZ act 1)
		moveq	#0,d0					; clear d0
		move.b	(v_act).w,d0				; get act number
		lsl.w	#3,d0					; multiply by 8 bytes per set
		adda.w	d0,a2					; add to address for data
		moveq	#1-1,d1					; set repeat times (only one set for acts other than LZ1)
		tst.b	(v_act).w				; is act number 1?
		bne.s	.loadSonic				; if not, branch
		moveq	#2-1,d1					; set repeat times (two sets for LZ1)
		subq.w	#8,a2					; start at first set for LZ1

	.loadSonic:
		lea	(v_player).w,a1				; load Sonic player object

.loopWindTunnelSets:
		move.w	obX(a1),d0				; get Sonic's current X-position
		cmp.w	(a2),d0					; compare with left boundary of wind tunnel
		blo.w	.notInTunnel				; branch if Sonic is left of wind tunnel
		cmp.w	4(a2),d0				; compare with right boundary of wind tunnel
		bhs.w	.notInTunnel				; branch if Sonic is right of wind tunnel

		move.w	obY(a1),d2				; get Sonic's current Y-position
	if FixBugs
		; Needed to fix an out-of-range error for the below bugfix.
		cmp.w	2(a2),d2				; compare with top boundary of wind tunnel
		blo.w	.notInTunnel				; branch if Sonic is above wind tunnel
		cmp.w	6(a2),d2				; compare with bottom boundary of wind tunnel
		bhs.w	.notInTunnel				; branch if Sonic is below wind tunnel
	else
		cmp.w	2(a2),d2				; compare with top boundary of wind tunnel
		blo.s	.notInTunnel				; branch if Sonic is above wind tunnel
		cmp.w	6(a2),d2				; compare with bottom boundary of wind tunnel
		bhs.s	.notInTunnel				; branch if Sonic is below wind tunnel
	endif

		move.b	(v_vblank_byte).w,d0			; get current VBlank counter
		andi.b	#$3F,d0					; only play water sound every $40 frames
		bne.s	.skipSound				; branch on other frames
		move.w	#sfx_Waterfall,d0			; play water rushing sound
		jsr	(QueueSound2).l				; (same one that is used by GHZ waterfalls)
	.skipSound:

		tst.b	(f_wtunneldisallow).w			; are wind tunnels disabled?
		bne.w	.return					; if yes, branch
		cmpi.b	#4,obRoutine(a1)			; is Sonic hurt/dying?
		bhs.s	.disableTunnel				; if yes, branch
		move.b	#1,(f_wtunnelmode).w			; set flag that Sonic is in a wind tunnel

	if FixBugs
		; d0 was overwritten earlier but here it's used as if it wasn't!		
		; Luckily, the upper byte of Sonic's X-position remains mostly in d0,
		; so the routine luckily still mostly works out of sheer, dumb luck.
		move.w	obX(a1),d0				; get Sonic's current X-position again
	endif
		subi.w	#128,d0					; move trigger zone for left side 128px further to the left
		cmp.w	(a2),d0					; is Sonic within 128px before the left side of the tunnel? ("suction")
		bhs.s	.moveSonic				; if not, branch

		moveq	#2,d0					; move Sonic down 2px
		cmpi.b	#act2,(v_act).w				; are we in LZ act 2?
		bne.s	.suck					; if not, branch
		neg.w	d0					; move Sonic up instead
	.suck:	add.w	d0,obY(a1)				; adjust Sonic's Y-axis 2px/frame before tunnel

	.moveSonic:
		addq.w	#4,obX(a1)				; move Sonic 4px/frame to the right
		move.w	#$400,obVelX(a1)			; set Sonic's X-speed to the right
		move.w	#0,obVelY(a1)				; clear vertical movement
		move.b	#id_Float2,obAnim(a1)			; use floating animation
		bset	#1,obStatus(a1)				; set Sonic's in-air flag
	if FixBugs
		; Knuckles in Sonic 2 added this.
		bclr	#4,obStatus(a1)				; clear roll-jump flag
	endif

	.chkUp:
		btst	#bitUp,(v_jpadhold2).w			; is up button being held?
		beq.s	.chkDown				; if not, branch
	if FixBugs
		; Knuckles in Sonic 2 prevents players from going above wind-tunnels,
		; likely due to how strange it looked. This isn't a problem in Sonic 1,
		; due to them being enclosed, but we may as well add it in for consistency.
		move.w	obY(a1),d2				; get Sonic's Y-position
		cmp.w	2(a2),d2				; is Sonic about to go above the wind tunnel?
		bls.s	.chkDown				; if yes, branch
	endif
		subq.w	#1,obY(a1)				; move Sonic up in tunnel

	.chkDown:
		btst	#bitDn,(v_jpadhold2).w			; is down button being held?
		beq.s	.return2				; if not, branch
		addq.w	#1,obY(a1)				; move Sonic down in tunnel

	.return2:
		rts						; return
; ===========================================================================

.notInTunnel:
		addq.w	#8,a2					; advance to second set of values (act 1 only)
		dbf	d1,.loopWindTunnelSets			; on act 1, repeat for a second set tunnel boundaries

		tst.b	(f_wtunnelmode).w			; was the tunnel active and flowing originally (has Sonic come out of a tunnel)?
		beq.s	.return					; if not, branch
		move.b	#id_Walk,obAnim(a1)			; use walking animation on tunnel exit

	.disableTunnel:
		clr.b	(f_wtunnelmode).w			; clear flag that Sonic is in a wind tunnel

	.return:
		rts						; return
; End of function LZWindTunnels
; ===========================================================================

		;    left, top,  right, bottom boundaries
LZWind_Data:	dc.w $A80, $300, $C10,  $380	; LZ act 1 values (1st set)
		dc.w $F80, $100, $1410,	$180	; LZ act 1 values (2nd set)
		dc.w $460, $400, $710,  $480	; LZ act 2 values
		dc.w $A20, $600, $1610, $6E0	; LZ act 3 values
		dc.w $C80, $600, $13D0, $680	; SBZ act 3 values
		even


; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone water slide subroutine
; ---------------------------------------------------------------------------

LZWaterSlides:
		lea	(v_player).w,a1				; load Sonic player object?
		btst	#1,obStatus(a1)				; is Sonic in air?
		bne.s	.exitWaterSlide				; if yes, ignore water slides

		move.w	obY(a1),d0				; get Sonic's Y-position
		lsr.w	#1,d0					; divide by 2 (for layout alignment)
		andi.w	#$380,d0				; keep in range of $800 pixels ($400 bytes in multiples of $80)
		move.b	obX(a1),d1				; load Sonic's X-position as upper byte (divide by $100, i.e. 256 pixels per chunk)
		andi.w	#$7F,d1					; keep in range of $80 chunks horizontally
		add.w	d1,d0					; fuse with layout Y-position
		lea	(v_lvllayout_fg).w,a2			; load FG layout address
		move.b	(a2,d0.w),d0				; d0 = chunk ID Sonic is located in
		lea	Slide_Chunks_End(pc),a2			; start checking at end of chunk ID list
		moveq	#Slide_Chunks_End-Slide_Chunks-1,d1	; check all chunk IDs
	.checkWaterChunk:
		cmp.b	-(a2),d0				; is Sonic located within a water slide chunk?
		dbeq	d1,.checkWaterChunk			; if not, repeat until match is found, or counter is finished
		beq.s	LZSlide_Move				; has any water slide chunk been found? if yes, branch
; ---------------------------------------------------------------------------

.exitWaterSlide:
		tst.b	(f_slidemode).w				; was Sonic on a water slide this frame?
		beq.s	.return					; if not, branch
		move.w	#5,locktime(a1)				; lock D-Pad for 5 frames (prevent moving and detaching again for a while)
		clr.b	(f_slidemode).w				; clear water slide flag

	.return:
		rts						; return
; ===========================================================================

LZSlide_Move:
		; This is some unused, unknown leftover from a deleted extra feature.
		; Judging by the design of chunks 2/7/3, which aren't that steep,
		; this may have been to slow down Sonic on those or something.
		cmpi.w	#3,d1					; is this one of the first three chunsk in Slide_Chunks? (IDs 2/7/3)
		bhs.s	.setSpeedAndDirection			; if not, branch
		nop						; useless nop

	.setSpeedAndDirection:
		bclr	#0,obStatus(a1)				; make Sonic face right
		move.b	Slide_Speeds(pc,d1.w),d0		; get slide speed for chunk
		move.b	d0,obInertia(a1)			; set speed as upper ground speed byte
		bpl.s	.setAnimation				; is slide speed to the left? if not, branch
		bset	#0,obStatus(a1)				; make Sonic face left

	.setAnimation:
		clr.b	obInertia+1(a1)				; clear lower ground speed byte
		move.b	#id_Slide,obAnim(a1)			; use Sonic's "water slide" animation
		move.b	#1,(f_slidemode).w			; set water slide flag

		move.b	(v_vblank_byte).w,d0			; get current VBlank counter
		andi.b	#$1F,d0					; only play water sound every $20 frames
		bne.s	.return					; branch on other frames
		move.w	#sfx_Waterfall,d0			; set waterfall sound
		jsr	(QueueSound2).l				; play it

	.return:
		rts						; return
; End of function LZWaterSlides
; ===========================================================================

Slide_Speeds:	; These speeds are mulitplied by $100!
		dc.b $A, -$B, $A, -$A, -$B, -$C, $B
		even

Slide_Chunks:
		dc.b 2, 7, 3, $4C, $4B, 8, 4
Slide_Chunks_End:
		even
