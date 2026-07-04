; ===========================================================================
; ---------------------------------------------------------------------------
; Object 18 - basic platforms (GHZ, SYZ, SLZ)
; ---------------------------------------------------------------------------

BasicPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Plat_Index(pc,d0.w),d1
		jmp	Plat_Index(pc,d1.w)
; ===========================================================================
Plat_Index:	dc.w Plat_Main-Plat_Index	; 0
		dc.w Plat_Solid-Plat_Index	; 2
		dc.w Plat_StoodOn-Plat_Index	; 4
		dc.w Plat_Delete-Plat_Index	; 6
		dc.w Plat_Action-Plat_Index	; 8

plat_rawY:	equ objoff_2C	; raw Y-positon (without nudge Y-offset)
plat_origX:	equ objoff_32	; initial X-position
plat_origY:	equ objoff_34	; initial Y-position
plat_nudge:	equ objoff_38	; nudge Y-offset while Sonic is on platform
plat_delay:	equ objoff_3A	; multi-purpose delay timers
; ===========================================================================

Plat_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Plat_Solid

		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile for GHZ (part of the level graphics)
		move.l	#Map_Plat_GHZ,obMap(a0)			; GHZ-specific mappings
		move.b	#64/2,obActWid(a0)			; set sprite display width and solidity width

		cmpi.b	#id_SYZ,(v_zone).w			; check if level is SYZ
		bne.s	.checkSLZ				; if not, branch
		move.l	#Map_Plat_SYZ,obMap(a0)			; SYZ-specific mappings
		move.b	#64/2,obActWid(a0)			; set SYZ width (redundant, it's the same as GHZ)

	.checkSLZ:
		cmpi.b	#id_SLZ,(v_zone).w			; check if level is SLZ
		bne.s	.continueSetup				; if not, branch
		move.l	#Map_Plat_SLZ,obMap(a0)			; SLZ-specific mappings
		move.b	#64/2,obActWid(a0)			; set SLZ width (redundant, it's the same as GHZ)
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set SLZ art tile (redundant, it's the same as GHZ)
		move.b	#3,obSubtype(a0)			; force Plat_FallAfterStand behavior

	.continueSetup:
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.w	obY(a0),plat_rawY(a0)			; remember initial raw Y-position
		move.w	obY(a0),plat_origY(a0)			; remember initial Y-position
		move.w	obX(a0),plat_origX(a0)			; remember initial X-position
		move.w	#$80,obAngle(a0)			; begin oscillating movement from the center

		moveq	#0,d1					; use frame 0 by default
		move.b	obSubtype(a0),d0			; get platform subtype
		cmpi.b	#$A,d0					; is object type $A? (large vertical GHZ2 platform, Plat_DownUp_LargeGHZ2)
		bne.s	.setframe				; if not, branch
		addq.b	#1,d1					; use frame 1 instead
		move.b	#64/2,obActWid(a0)			; set width (redundant, it's still the same)
	.setframe:
		move.b	d1,obFrame(a0)				; set platform frame ID
; ---------------------------------------------------------------------------

Plat_Solid:	; Routine 2
		tst.b	plat_nudge(a0)				; has platform nudge gone back to 0?
		beq.s	.checkEnterPlatform			; if yes, branch
		subq.b	#4,plat_nudge(a0)			; reduce nudging while Sonic isn't on platform

	.checkEnterPlatform:
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		bsr.w	PlatformObject				; enable platform behavior (sets obRoutine = 4 (Plat_StoodOn) when stood on)
		; continue to Plat_Action...
; ---------------------------------------------------------------------------

Plat_Action:	; Routine 8
		bsr.w	Plat_Move				; execute platform type behavior
		bsr.w	Plat_Nudge				; depress platform a bit while Sonic is on it
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display platform sprite
	endif
		bra.w	Plat_ChkDel				; delete platform if it has gone out of range
; ===========================================================================

; Plat_Action2:
Plat_StoodOn:	; Routine 4
		cmpi.b	#$40,plat_nudge(a0)			; has platform fully nudged down?
		beq.s	.platformBehavior			; if yes, don't depress it further
		addq.b	#4,plat_nudge(a0)			; nudge platform down as Sonic stands on it

	.platformBehavior:
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		bsr.w	ExitPlatform				; enable platform behavior (sets obRoutine = 4 (Plat_Action) when stood on)

		move.w	obX(a0),-(sp)				; backup platform X-position before calling Plat_Move
		bsr.w	Plat_Move				; execute platform type behavior
		bsr.w	Plat_Nudge				; depress platform a bit while Sonic is on it
		move.w	(sp)+,d2				; restore platform X-position as input for MvSonicOnPtfm2
		bsr.w	MvSonicOnPtfm2				; move Sonic with platform as it moves

	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display platform psirte
	endif
		bra.w	Plat_ChkDel				; delete platform if it has gone out of range
		rts						; useless rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move platform slightly when you stand on it
; ---------------------------------------------------------------------------

Plat_Nudge:
		move.b	plat_nudge(a0),d0			; get current platform nudge value (0-$40)
		bsr.w	CalcSine				; convert it into a sine for smooth movement
		move.w	#$400,d1				; depress by at most 4px
		muls.w	d1,d0					; multiply sine value by amplitude
		swap	d0					; use upper word of multiplication result
		add.w	plat_rawY(a0),d0			; add raw Y-position without nudge
		move.w	d0,obY(a0)				; update actual Y-position to be with nudge
		rts						; return
; End of function Plat_Nudge

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to execute platform movement behavior based on its subtype
; ---------------------------------------------------------------------------

Plat_Move:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		andi.w	#$F,d0					; only read lower digit
		add.w	d0,d0					; double for word-based indexing
		move.w	Plat_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jmp	Plat_TypeIndex(pc,d1.w)			; execute platform behavior for subtype
; ===========================================================================
Plat_TypeIndex:	dc.w Plat_Stationary-Plat_TypeIndex		; 0
		dc.w Plat_RightLeft-Plat_TypeIndex		; 1
		dc.w Plat_DownUp-Plat_TypeIndex			; 2
		dc.w Plat_FallAfterStand-Plat_TypeIndex		; 3
		dc.w Plat_FallingDown-Plat_TypeIndex		; 4
		dc.w Plat_LeftRight-Plat_TypeIndex		; 5
		dc.w Plat_UpDown-Plat_TypeIndex			; 6
		dc.w Plat_RiseOnSwitch-Plat_TypeIndex		; 7
		dc.w Plat_Rising-Plat_TypeIndex			; 8
		dc.w Plat_Stationary-Plat_TypeIndex		; 9
		dc.w Plat_DownUp_LargeGHZ2-Plat_TypeIndex	; A
		dc.w Plat_DownUp_Slow-Plat_TypeIndex		; B
		dc.w Plat_UpDown_Slow-Plat_TypeIndex		; C
; ===========================================================================

; Type 0 - stationary
Plat_Stationary:
		rts						; platform 00 doesn't move
; ===========================================================================

; Type 5 - moving left and right continuously (left first)
Plat_LeftRight:
		move.w	plat_origX(a0),d0			; get initial platform X-position
		move.b	obAngle(a0),d1				; load platform-motion variable
		neg.b	d1					; reverse platform-motion
		addi.b	#$40,d1					; center around middle position
		bra.s	Plat_MoveHorizontal			; update platform X-position
; ===========================================================================

; Type 1 - moving right and left continuously (right first)
Plat_RightLeft:
		move.w	plat_origX(a0),d0			; get initial platform X-position
		move.b	obAngle(a0),d1				; load platform-motion variable
		subi.b	#$40,d1					; center around middle position
; ---------------------------------------------------------------------------

Plat_MoveHorizontal:
		ext.w	d1					; extend platform-motion variable to word
		add.w	d1,d0					; add motion variable to initial X-position
		move.w	d0,obX(a0)				; update platform's X-position
		bra.w	Plat_ChangeMotion			; oscillate platform-motion variable
; ===========================================================================

; Type C - moving up and down continuously, slow (up first)
Plat_UpDown_Slow:
		move.w	plat_origY(a0),d0			; get initial platform Y-position
		move.b	(v_oscillate+$E).w,d1			; use slower platform-motion variable (frequency 2, middle value $30)
		neg.b	d1					; reverse platform-motion
		addi.b	#$30,d1					; center around middle position
		bra.s	Plat_MoveVertical			; update platform Y-position
; ===========================================================================

; Type B - moving down and up continuously, slow (down first)
Plat_DownUp_Slow:
		move.w	plat_origY(a0),d0			; get initial platform Y-position
		move.b	(v_oscillate+$E).w,d1			; use slower platform-motion variable (frequency 2, middle value $30)
		subi.b	#$30,d1					; center around middle position
		bra.s	Plat_MoveVertical			; update platform Y-position
; ===========================================================================

; Type 6 - moving up and down continuously (up first)
Plat_UpDown:
		move.w	plat_origY(a0),d0			; get initial platform Y-position
		move.b	obAngle(a0),d1				; load platform-motion variable
		neg.b	d1					; reverse platform-motion
		addi.b	#$40,d1					; center around middle position
		bra.s	Plat_MoveVertical			; update platform Y-position
; ===========================================================================

; Type 2 - moving down and up continuously (down first)
Plat_DownUp:
		move.w	plat_origY(a0),d0			; get initial platform Y-position
		move.b	obAngle(a0),d1				; load platform-motion variable
		subi.b	#$40,d1					; center around middle position
; ---------------------------------------------------------------------------

Plat_MoveVertical:
		ext.w	d1					; extend platform-motion variable to word
		add.w	d1,d0					; add motion variable to initial Y-position
		move.w	d0,plat_rawY(a0)			; update platform's Y-position
		bra.w	Plat_ChangeMotion			; oscillate platform-motion variable
; ===========================================================================

; Type 3 - stationary, advances to next subtype half a second after landing on it (4, falling)
Plat_FallAfterStand:
		tst.w	plat_delay(a0)				; has Sonic already stepped on the platform?
		bne.s	.wait					; if yes, branch
		btst	#3,obStatus(a0)				; is Sonic currently standing on the platform?
		beq.s	.return					; if not, branch
		move.w	#30,plat_delay(a0)			; set time delay to 0.5 seconds

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.wait:
		subq.w	#1,plat_delay(a0)			; decrement delay before falling
		bne.s	.return					; if time remains, branch
		move.w	#32,plat_delay(a0)			; keep Sonic attached to platform for 32 frames after it begins falling
		addq.b	#1,obSubtype(a0)			; change type to 04 (Plat_FallingDown, falling)
		rts						; return
; ===========================================================================

; Type 4 (set from Type 3) - falls down, Sonic stays attached to platform until timer expires
Plat_FallingDown:
		tst.w	plat_delay(a0)				; has detachment logic already run?
		beq.s	.fallingDown				; if yes, branch
		subq.w	#1,plat_delay(a0)			; decrement timer for Sonic to stay attached on platform
		bne.s	.fallingDown				; if time remains, branch
		btst	#3,obStatus(a0)				; was Sonic still on platform as timer expired?
		beq.s	.notOnPlatform				; if not, branch
		
		; Note: a1 was set to v_player when calling ExitPlatform earlier
		bset	#1,obStatus(a1)				; set Sonic in-air
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		move.b	#2,obRoutine(a1)			; force Sonic to Sonic_Control routine
		bclr	#3,obStatus(a0)				; clear platform's stood-on flag
		clr.b	obSolid(a0)				; clear platform's solidity flag
		move.w	obVelY(a0),obVelY(a1)			; set Sonic to continue falling on his own at the platform's current speed

	.notOnPlatform:
		move.b	#8,obRoutine(a0)			; set to Plat_Action routine (don't allow entering platform again)

	.fallingDown:
		move.l	plat_rawY(a0),d3			; get raw Y-position without nudge
		move.w	obVelY(a0),d0				; get current falling speed
		ext.l	d0					; extend to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed)
		add.l	d0,d3					; add speed to current Y-position
		move.l	d3,plat_rawY(a0)			; update raw Y-position
		addi.w	#gravity,obVelY(a0)			; make platform fall faster

		move.w	(v_limitbtm2).w,d0			; get current bottom level boundary
		addi.w	#224,d0					; add screen height
		cmp.w	plat_rawY(a0),d0			; has platform fallen below bottom level boundary?
		bhs.s	.return					; if not, branch
		move.b	#6,obRoutine(a0)			; set to Plat_Delete routine

	.return:
		rts						; return
; ===========================================================================

; Type 7 - stationary, advances to next subtype one second after a switch is pressed (SYZ1 rising platform)
Plat_RiseOnSwitch:
		tst.w	plat_delay(a0)				; has timer already started?
		bne.s	.wait					; if yes, branch

		lea	(f_switch).w,a2				; load switch statuses
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		lsr.w	#4,d0					; only read upper digit (for SYZ1's platform, this is 8)
		tst.b	(a2,d0.w)				; has corresponding switch been pressed?
		beq.s	.return					; if not, branch
		move.w	#1*60,plat_delay(a0)			; wait 1 second before making platform rise

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.wait:
		subq.w	#1,plat_delay(a0)			; decrement delay before rising platform
		bne.s	.return					; if time remains, branch
		addq.b	#1,obSubtype(a0)			; change type to 08 (Plat_Rising, rising)
		rts						; return
; ===========================================================================

; Type 8 (set from Type 7) - rise, stop $200px above origin
Plat_Rising:
		subq.w	#2,plat_rawY(a0)			; move platform up at 2px/frame
		move.w	plat_origY(a0),d0			; get initial platform Y-position
		subi.w	#$200,d0				; stop platform $200 above origin
		cmp.w	plat_rawY(a0),d0			; has platform moved up $200 pixels?
		bne.s	.return					; if not, branch
		clr.b	obSubtype(a0)				; change type to 00 (Plat_Stationary, stationary)

	.return:
		rts						; return
; ===========================================================================

Plat_DownUp_LargeGHZ2:
		move.w	plat_origY(a0),d0			; get initial platform Y-position
		move.b	obAngle(a0),d1				; load platform-motion variable
		subi.b	#$40,d1					; center around middle position
		ext.w	d1					; extend platform-motion variable to word
		asr.w	#1,d1					; divide motion by 2 (half range)
		add.w	d1,d0					; add motion variable to initial Y-position
		move.w	d0,plat_rawY(a0)			; update platform's Y-position
; ---------------------------------------------------------------------------


Plat_ChangeMotion:
		move.b	(v_oscillate+$1A).w,obAngle(a0)		; update platform-movement variable (frequency 8, middle value $40)
		rts						; return
; End of function Plat_Move

; ===========================================================================

Plat_ChkDel:
		out_of_range.s	Plat_Delete,plat_origX(a0)	; has platform gone out of range? if yes, delete it
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite				; display platform psirte
	else
		rts						; return
	endif
; ===========================================================================

Plat_Delete:	; Routine 6
		bra.w	DeleteObject				; delete platform object

; ===========================================================================

Map_Plat_Unused:include	"_maps/Platforms (unused).asm"
Map_Plat_GHZ:	include	"_maps/Platforms (GHZ).asm"
Map_Plat_SYZ:	include	"_maps/Platforms (SYZ).asm"
Map_Plat_SLZ:	include	"_maps/Platforms (SLZ).asm"
