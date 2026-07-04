; ===========================================================================
; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ, LZ, SBZ)
; ---------------------------------------------------------------------------

MovingBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	MBlock_Index(pc,d0.w),d1
		jmp	MBlock_Index(pc,d1.w)
; ===========================================================================
MBlock_Index:	dc.w MBlock_Main-MBlock_Index
		dc.w MBlock_Platform-MBlock_Index
		dc.w MBlock_StandOn-MBlock_Index

mblock_origX:		equ objoff_30	; initial X-position
mblock_origY:		equ objoff_32	; initial Y-position
mblock_slide_wait:	equ objoff_34	; (subtype 9/A only) delay before red sliding floor moves back
mblock_slide_goback:	equ objoff_36	; (subtype 9/A only) set if red sliding floor is currently moving back

    if FixBugs
mblock_fix_storeX:	equ objoff_38	; (FixBugs only) stores X-position around MBlock_Move to avoid stack pointer corruption
    endif
; ===========================================================================

MBlock_Var:	; width, frame
		dc.b  32/2, 0	; $0x - MZ single block / LZ small raft
		dc.b  64/2, 1	; $1x - MZ double block (unused)
		dc.b  64/2, 2	; $2x - SBZ short (yellow/black striped)
		dc.b 128/2, 3	; $3x - SBZ long (red sliding floors)
		dc.b  96/2, 4	; $4x - MZ triple block
; ===========================================================================

MBlock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to MBlock_Platform

		move.l	#Map_MBlock,obMap(a0)			; MZ-specific mappings
		move.w	#ArtTile_MZ_Block|Tile_Pal3,obGfx(a0)	; MZ-specific art tile

		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.checkSBZ				; if not, branch
		move.l	#Map_MBlockLZ,obMap(a0)			; LZ-specific mappings
		move.w	#ArtTile_LZ_Moving_Block|Tile_Pal3,obGfx(a0) ; LZ-specific art tile
		move.b	#14/2,obHeight(a0)			; LZ-specific height

	.checkSBZ:
		cmpi.b	#id_SBZ,(v_zone).w			; check if level is SBZ
		bne.s	.continueSetup				; if not, branch
		move.w	#ArtTile_SBZ_Moving_Block_Short|Tile_Pal2,obGfx(a0) ; SBZ-specific art tile (short platform)
		cmpi.b	#$28,obSubtype(a0)			; is subtype $28? (short platform)
		beq.s	.continueSetup				; if yes, branch
		move.w	#ArtTile_SBZ_Moving_Block_Long|Tile_Pal3,obGfx(a0) ; use art tile for long platform instead

.continueSetup:
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		lsr.w	#3,d0					; read only lower digit, multiplied by 2 bytes per entry
		andi.w	#$1E,d0					; mask out upper subtype digit
		lea	MBlock_Var(pc,d0.w),a2			; load setup array
		move.b	(a2)+,obActWid(a0)			; set sprite display width and solidity width
		move.b	(a2)+,obFrame(a0)			; set frame ID

		move.b	#4,obPriority(a0)			; set sprite priority
		move.w	obX(a0),mblock_origX(a0)		; remember initial X-position
		move.w	obY(a0),mblock_origY(a0)		; remember initial Y-position
		andi.b	#$F,obSubtype(a0)			; mask out upper subtype digit
; ---------------------------------------------------------------------------

MBlock_Platform: ; Routine 2
		bsr.w	MBlock_Move				; execute platform movement behavior

		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		jsr	(PlatformObject).l			; enable platform behavior (can set obRoutine = 4, MBlock_StandOn)
		bra.s	MBlock_DisplayOrDelete			; display platform
; ===========================================================================

MBlock_StandOn:	; Routine 4
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		jsr	(ExitPlatform).l			; allow exiting platform (can set obRoutine = 2, MBlock_Platform)

	if FixBugs
		; MBlock_SecretLZ1Raft manipulates the stack pointer, potentially
		; resulting in a crash. To avoid this, don't store data on
		; the stack. We can use object scratch RAM instead.
		move.w	obX(a0),mblock_fix_storeX(a0)		; backup current X-position before calling MBlock_Move (scratch RAM)
		bsr.w	MBlock_Move				; execute platform movement behavior
		move.w	mblock_fix_storeX(a0),d2		; restore previous X-position as input for MvSonicOnPtfm2 (scratch RAM)
	else
		move.w	obX(a0),-(sp)				; backup current X-position before calling MBlock_Move (stack)
		bsr.w	MBlock_Move				; execute platform movement behavior
		move.w	(sp)+,d2				; restore previous X-position as input for MvSonicOnPtfm2 (stack)
	endif

		jsr	(MvSonicOnPtfm2).l			; move Sonic with platform as it moves
; ---------------------------------------------------------------------------

; MBlock_ChkDel:
MBlock_DisplayOrDelete:	
		out_of_range.w	DeleteObject,mblock_origX(a0)	; has platform gone out of range? if yes, delete it
		bra.w	DisplaySprite				; display platform sprite

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to control platform behavior based on subtype
; ---------------------------------------------------------------------------

MBlock_Move:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		andi.w	#$F,d0					; limit to lower digit (redundant, it's already been cleared earlier)
		add.w	d0,d0					; double for word-based indexing
		move.w	MBlock_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jmp	MBlock_TypeIndex(pc,d1.w)		; execute behavior for platform subtype
; ===========================================================================
MBlock_TypeIndex:
		dc.w MBlock_Stationary-MBlock_TypeIndex		; 0
		dc.w MBlock_LeftRight-MBlock_TypeIndex		; 1
		dc.w MBlock_NextWhenStoodOn-MBlock_TypeIndex	; 2
		dc.w MBlock_Right_StopOnWall-MBlock_TypeIndex	; 3
		dc.w MBlock_NextWhenStoodOn-MBlock_TypeIndex	; 4
		dc.w MBlock_Right_FallOnWall-MBlock_TypeIndex	; 5
		dc.w MBlock_FallingDown-MBlock_TypeIndex	; 6
		dc.w MBlock_SecretLZ1Raft-MBlock_TypeIndex	; 7
		dc.w MBlock_UpDown-MBlock_TypeIndex		; 8
		dc.w MBlock_NextWhenStoodOn-MBlock_TypeIndex	; 9
		dc.w MBlock_SlideFast-MBlock_TypeIndex		; A
; ===========================================================================

; Type 0 - stationary
MBlock_Stationary:
		rts						; do nothing
; ===========================================================================

; Type 1 - moves left and right continuously
MBlock_LeftRight:
		move.b	(v_oscillate+$E).w,d0			; get oscillatory value (frequency 2, middle value $30)
		move.w	#$60,d1					; adjustment offset for X-flipped platforms (oscillation range * 2)
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		add.w	d1,d0					; keep flipped platforms in the same $60px range

	.setX:
		move.w	mblock_origX(a0),d1			; get initial X-position of platform
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obX(a0)				; move platform horizontally
		rts						; return
; ===========================================================================

; Type 2/4/9 - stationary, advances to next subtype when stood on (3/5/A)
MBlock_NextWhenStoodOn:
		cmpi.b	#4,obRoutine(a0)			; is Sonic standing on the platform?
		bne.s	.return					; if not, branch
		addq.b	#1,obSubtype(a0)			; if yes, go to next subtype in list

	.return:
		rts						; return
; ===========================================================================

; Type 3 (set from Type 2) - moves right, advances to Type 0 on wall hit (stationary)
MBlock_Right_StopOnWall:
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; use platform half-width as pixels to look ahead
		bsr.w	ObjHitWallRight				; get distance to platform right edge and nearest wall
		tst.w	d1					; has the platform hit a wall?
		bmi.s	.stopPlatform				; if yes, branch
		addq.w	#1,obX(a0)				; move platform to the right at 1px/frame
		move.w	obX(a0),mblock_origX(a0)		; update initial X-position as platform moves
		rts						; return
; ---------------------------------------------------------------------------

	.stopPlatform:
		clr.b	obSubtype(a0)				; change to type 00 (non-moving type)
		rts						; return
; ===========================================================================

; Type 5 (set from Type 4) - moves right, advances to Type 6 on wall hit (falling down)
MBlock_Right_FallOnWall:
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; use platform half-width as pixels to look ahead
		bsr.w	ObjHitWallRight				; get distance to platform right edge and nearest wall
		tst.w	d1					; has the platform hit a wall?
		bmi.s	.fallDown				; if yes, branch
		addq.w	#1,obX(a0)				; move platform to the right at 1px/frame
		move.w	obX(a0),mblock_origX(a0)		; update initial X-position as platform moves
		rts						; return
; ---------------------------------------------------------------------------

	.fallDown:
		addq.b	#1,obSubtype(a0)			; change to type 06 (falling down)
		rts						; return
; ===========================================================================

; Type 6 (set from type 5) - falls down, advances to Type 0 on floor hit (stationary)
MBlock_FallingDown:
		bsr.w	SpeedToPos				; update plaform position as it falls down
		addi.w	#$18,obVelY(a0)				; make the platform fall faster

		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has platform hit the floor?
		bpl.w	.return					; if not, branch
		add.w	d1,obY(a0)				; align platform to floor
		clr.w	obVelY(a0)				; stop platform falling
		clr.b	obSubtype(a0)				; change to type 00 (non-moving type)

	.return:
		rts						; return
; ===========================================================================

; Type 7 - appears when switch ID 2 is pressed (secret LZ1 raft leading to shortcut)
MBlock_SecretLZ1Raft:
		tst.b	(f_switch+2).w				; has switch number 02 been pressed?
		beq.s	.hidePlatform				; if not, branch
		subq.b	#3,obSubtype(a0)			; change platform to type 04 (stationary, moves right when stood on, drops on wall hit)

	.hidePlatform:
		; This line, combined with the coordinate being pushed
		; to the stack in MBlock_StandOn, can be disastrous.
		; See the notes for the fix in MBlock_StandOn.
		addq.l	#4,sp					; skip returning to MBlock_Platform to disable platform interaction and sprite rendering

		out_of_range.w	DeleteObject,mblock_origX(a0)	; has invisible platform object gone out of range? if yes, delete it
		rts						; return and exit object 52 as a whole
; ===========================================================================

; Type 8 - moves up and down continuously
MBlock_UpDown:
		move.b	(v_oscillate+$1E).w,d0			; get oscillatory value (frequency 4, middle value $40)
		move.w	#$80,d1					; adjustment offset for X-flipped platforms (oscillation range * 2)
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		add.w	d1,d0					; keep flipped platforms in the same $80px range

	.setY:
		move.w	mblock_origY(a0),d1			; get initial Y-position of platform
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obY(a0)				; move platform vertically
		rts						; return
; ===========================================================================

; Type A (set from Type 2) - quickly slides to the right and goes back after a while (red sliding floors in SBZ)
MBlock_SlideFast:
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; get platform half-width
		add.w	d3,d3					; double to full-width (will be the total slide distance)
		moveq	#8,d1					; slide platform to the right
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.slide					; if not, branch
		neg.w	d1					; slide platform to the left instead
		neg.w	d3					; check target distance to the left instead

	.slide:
		tst.w	mblock_slide_goback(a0)			; is platform set to move back?
		bne.s	.goingBack				; if yes, branch

		move.w	obX(a0),d0				; get current platform X-position as it slides
		sub.w	mblock_origX(a0),d0			; calculate difference to origin
		cmp.w	d3,d0					; has platform moved its full width in distance?
		beq.s	.waiting				; if yes, stop it sliding
		add.w	d1,obX(a0)				; move platform to the left or right at 8px/frame
		move.w	#5*60,mblock_slide_wait(a0)		; reset time delay before it moves back to 5 seconds
		rts						; return
; ---------------------------------------------------------------------------

.waiting:
		subq.w	#1,mblock_slide_wait(a0)		; decrement from time delay before moving back
		bne.s	.return					; if time remains, branch
		move.w	#1,mblock_slide_goback(a0)		; set platform to move back to its original position

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.goingBack:
		move.w	obX(a0),d0				; get current platform X-position as it slides back
		sub.w	mblock_origX(a0),d0			; calculate difference to origin
		beq.s	.reset					; has platform moved back to original position? if yes, branch
		sub.w	d1,obX(a0)				; return platform to its original position at 8px/frame
		rts						; return
; ---------------------------------------------------------------------------

.reset:
		clr.w	mblock_slide_goback(a0)			; set platform as moved back to its original position
		subq.b	#1,obSubtype(a0)			; change type back to 09 to wait for Sonic to step on platform again
		rts						; return
; End of function MBlock_Move

; ===========================================================================

Map_MBlock:	include	"_maps/Moving Blocks (MZ and SBZ).asm"
Map_MBlockLZ:	include	"_maps/Moving Blocks (LZ).asm"
