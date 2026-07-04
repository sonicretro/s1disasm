; ===========================================================================
; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;           - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

SwingingPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:	dc.w Swing_Main-Swing_Index		; 0
		dc.w Swing_Platform-Swing_Index		; 2
		dc.w Swing_StoodOn-Swing_Index		; 4
		dc.w Swing_Delete-Swing_Index		; 6
		dc.w Swing_Delete-Swing_Index		; 8
		dc.w Swing_ChainLink-Swing_Index	; A
		dc.w Swing_Swinging-Swing_Index		; C

swing_children:	equ obSubtype		; number of child link objects ($28 = child count, $29-$39 RAM indeces to links)
swing_origY:	equ objoff_38		; original y-axis position
swing_origX:	equ objoff_3A		; original x-axis position
swing_radius:	equ objoff_3C		; radius distance from center, individual per chain link
; ===========================================================================

Swing_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Swing_Platform
		move.l	#Map_Swing_GHZ,obMap(a0)		; GHZ and MZ specific mappings
		move.w	#ArtTile_GHZ_MZ_Swing|Tile_Pal3,obGfx(a0) ; set GHZ/MZ art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#48/2,obActWid(a0)			; set sprite display width and platform solidity width
		move.b	#16/2,obHeight(a0)			; set platform solidity height
		move.w	obY(a0),swing_origY(a0)			; remember initial Y-position
		move.w	obX(a0),swing_origX(a0)			; remember initial X-position

		cmpi.b	#id_SLZ,(v_zone).w			; check if level is SLZ (swinging half-size metal spikeball)
		bne.s	.checkSBZ				; if not, branch
		move.l	#Map_Swing_SLZ,obMap(a0)		; SLZ-specific mappings
		move.w	#ArtTile_SLZ_Swing|Tile_Pal3,obGfx(a0)	; SLZ-specific art tile
		move.b	#64/2,obActWid(a0)			; SLZ-specific width
		move.b	#32/2,obHeight(a0)			; SLZ-specific height
		move.b	#col_64x16|col_hurt,obColType(a0)	; make spikeball part from below harmful on touch

	.checkSBZ:
		cmpi.b	#id_SBZ,(v_zone).w			; check if level is SBZ (swinging metal spikeball)
		bne.s	Swing_CreateLinks			; if not, branch
		move.l	#Map_BBall,obMap(a0)			; SBZ-specific mappings
		move.w	#ArtTile_SBZ_Swing,obGfx(a0)		; SBZ-specific art tile
		move.b	#48/2,obActWid(a0)			; SBZ-specific width
		move.b	#48/2,obHeight(a0)			; SBZ-specific height
		move.b	#col_32x32|col_hurt,obColType(a0)	; make entire spikeball harmful on touch
		move.b	#$C,obRoutine(a0)			; use Swing_Swinging routine (disable platform logic)

Swing_CreateLinks:
		_move.b	obID(a0),d4				; copy parent object ID to children
		moveq	#0,d1					; clear d1
		lea	swing_children(a0),a2			; load child object index array (= obSubtype)
		move.b	(a2),d1					; get subtype for platform
		move.w	d1,-(sp)				; backup subtype for later
		andi.w	#$F,d1					; limit subtype to lower digit (number of child objects to spawn)
		move.b	#0,(a2)+				; clear subtype, and initialize number of spawned children to 0
		move.w	d1,d3					; copy lower subtype digit to d3
		lsl.w	#4,d3					; multiply link count by $10px
		addq.b	#8,d3					; increase parent radius by an extra 8px
		move.b	d3,swing_radius(a0)			; set radius for parent object, based on link count
		subq.b	#8,d3					; undo previous 8px addition

		tst.b	obFrame(a0)				; is parent object a main block? (...isn't it always?)
		beq.s	.loopMakeChain				; if yes, branch
		addq.b	#8,d3					; redo 8px addition once again
		subq.w	#1,d1					; spawn one less child object

.loopMakeChain:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj				; find next free object RAM slot
	else
		bsr.w	FindFreeObj				; find any free object RAM slot
	endif
		bne.s	.finalizeParent				; if object RAM is full, abort

		addq.b	#1,swing_children(a0)			; increment number of loaded child objects
		move.w	a1,d5					; get child address
		subi.w	#v_objspace&$FFFF,d5			; make child address 0-based
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; d5 = index of child in object RAM
		move.b	d5,(a2)+				; store new child index at the end of swing_children

		move.b	#$A,obRoutine(a1)			; use Swing_ChainLink routine (display only)
		_move.b	d4,obID(a1)				; copy object ID from parent
		move.l	obMap(a0),obMap(a1)			; copy mappings from parent
		move.w	obGfx(a0),obGfx(a1)			; copy art tile from parent
		bclr	#6,obGfx(a1)				; force palette line 1 instead of line 3 (gray)
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#4,obPriority(a1)			; set sprite priority (behind parent)
		move.b	#16/2,obActWid(a1)			; set sprite display width
		move.b	#1,obFrame(a1)				; use "chain" frame

		move.b	d3,swing_radius(a1)			; set radius for child
		subi.b	#$10,d3					; reduce radius for next child object
		bcc.s	.next					; is this the anchor (no radius)? if not, branch
		move.b	#2,obFrame(a1)				; use "anchor" frame
		move.b	#3,obPriority(a1)			; use higher sprite priority than chains
		bset	#6,obGfx(a1)				; force palette line 3
	.next:
		dbf	d1,.loopMakeChain			; repeat d1 times (chain length)

.finalizeParent:
		move.w	a0,d5					; get parent address
		subi.w	#v_objspace&$FFFF,d5			; make address 0-based
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; d5 = index of parent in object RAM
		move.b	d5,(a2)+				; store parent platform as final entry in swing_child list

		move.w	#$4080,obAngle(a0)			; GHZ wrecking ball boss only: set initial angle to equilibrium position
		move.w	#-$200,GBall_Swing_Speed(a0)		; GHZ wrecking ball boss only: set initial speed (counterclockwise)

		move.w	(sp)+,d1				; restore full subtype byte
		btst	#4,d1					; is object type $1x? (swinging GHZ ball on chain, unused in levels)
		beq.s	.checkSBZ				; if not, branch
		move.l	#Map_GBall,obMap(a0)			; use GHZ ball mappings
		move.w	#ArtTile_GHZ_Giant_Ball|Tile_Pal3,obGfx(a0) ; set alternate art tile
		move.b	#1,obFrame(a0)				; use checkered frame ID
		move.b	#2,obPriority(a0)			; set alternate sprite priority (above chains)
		move.b	#col_40x40|col_hurt,obColType(a0)	; make ball harmful on touch

	.checkSBZ:
		cmpi.b	#id_SBZ,(v_zone).w			; is zone SBZ?
		beq.s	Swing_Swinging				; if yes, branch (disable platform logic)
; ---------------------------------------------------------------------------

; Swing_SetSolid:
Swing_Platform:	; Routine 2
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		moveq	#0,d3					; clear d3
		move.b	obHeight(a0),d3				; set custom platform solidity height as input
		bsr.w	PlatformObject_CustomHeight		; enable platform behavior (sets obRoutine = 4 (Swing_StoodOn) when stood on)
; ---------------------------------------------------------------------------

; Swing_Action:
Swing_Swinging:	; Routine $C
		bsr.w	Swing_Move				; swing platform and update its child links

	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display main platform object
	endif
		bra.w	Swing_ChkDel				; delete platform and links if out of range
; ===========================================================================

; Swing_Action2:
Swing_StoodOn:	; Routine 4
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		bsr.w	ExitPlatform				; allow Sonic exiting platform (sets obRoutine = 2 (Swing_Platform) on exit)

		move.w	obX(a0),-(sp)				; backup platform X-position before calling Swing_Move
		bsr.w	Swing_Move				; swing platform and update its child links

		move.w	(sp)+,d2				; restore previous platform X-position as input for MvSonicOnPtfm
		moveq	#0,d3					; clear d3
		move.b	obHeight(a0),d3				; set platform solidity height
		addq.b	#1,d3					; +1px for height
		bsr.w	MvSonicOnPtfm				; move Sonic with platform as it swings

	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display main platform object
	endif
		bra.w	Swing_ChkDel				; delete platform and links if out of range
		rts						; useless rts
; ===========================================================================

	; Move Sonic with platform, shared by almost all other platform objects.
	; This is likely sandwiched in between here for being the first one.
	include "_incObj/sub MvSonicOnPtfm.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update swinging angle and positions for chain links and platform
; ---------------------------------------------------------------------------

Swing_Move:
		move.b	(v_oscillate+$1A).w,d0			; get oscillation value (frequency 8, middle value $40)
		move.w	#$40*2,d1				; keep in same range if movement is reversed
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.swing					; if not, branch
		neg.w	d0					; reverse movement direction
		add.w	d1,d0					; keep in the same general range
	.swing:
		bra.s	Swing_UpdateSwingPosition		; swing all objects

; ---------------------------------------------------------------------------
; Alternate swing logic, called from wrecking ball for GHZ boss.
; See "GBall_Base2" in Object 4B.
; ---------------------------------------------------------------------------

; Obj48_Move:
GBall_Move:
		tst.b	GBall_Swing_Direction(a0)		; is wrecking ball set to swing counterclockwise?
		bne.s	.swingCounterclockwise			; if yes, branch

	.swingClockwise:
		move.w	GBall_Swing_Speed(a0),d0		; get current wrecking ball swing speed
		addq.w	#8,d0					; increase swing speed (clockwise)
		move.w	d0,GBall_Swing_Speed(a0)		; store new swing speed
		add.w	d0,obAngle(a0)				; update angle
		cmpi.w	#$200,d0				; has speed crossed middle threshold?
		bne.s	.updateSwing				; if not, branch
		move.b	#1,GBall_Swing_Direction(a0)		; begin swinging counterclockwise next
		bra.s	.updateSwing				; update swing position
; ---------------------------------------------------------------------------

	.swingCounterclockwise:
		move.w	GBall_Swing_Speed(a0),d0		; get current wrecking ball swing speed
		subq.w	#8,d0					; increase swing speed (counterclockwise)
		move.w	d0,GBall_Swing_Speed(a0)		; store new swing speed
		add.w	d0,obAngle(a0)				; update angle
		cmpi.w	#-$200,d0				; has speed crossed middle threshold?
		bne.s	.updateSwing				; if not, branch
		move.b	#0,GBall_Swing_Direction(a0)		; begin swinging clockwise again

	.updateSwing:
		move.b	obAngle(a0),d0				; get latest angle
		; fall-through to Swing_UpdateSwingPosition...

; ---------------------------------------------------------------------------
; Subroutine to convert angle to position for all chain links
; 
; input:
;	d0 = current swing angle
; ---------------------------------------------------------------------------

; Swing_Move2:
Swing_UpdateSwingPosition:
		bsr.w	CalcSine				; calculate sine and cosine values for current swing angle in d0
		move.w	swing_origY(a0),d2			; get initial platform Y-position
		move.w	swing_origX(a0),d3			; get initial platform X-position

		lea	swing_children(a0),a2			; load RAM indeces for all objects in platform chain
		moveq	#0,d6					; clear d6
		move.b	(a2)+,d6				; get number of objects in chain

	.loopSwing:
		moveq	#0,d4					; clear d4
		move.b	(a2)+,d4				; get next RAM index for object
		lsl.w	#object_size_bits,d4			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d4			; add base object RAM offset
		movea.l	d4,a1					; a1 = full RAM address to object

		moveq	#0,d4					; clear d4
		move.b	swing_radius(a1),d4			; get radius for object
		move.l	d4,d5					; duplicate radius
		muls.w	d0,d4					; multiply radius by sine value
		asr.l	#8,d4					; shift result down a byte
		muls.w	d1,d5					; multiply radius by cosine value
		asr.l	#8,d5					; shift result down a byte
		add.w	d2,d4					; add initial Y-position to sine
		add.w	d3,d5					; add initial X-position to cosine
		move.w	d4,obY(a1)				; update Y-position for object
		move.w	d5,obX(a1)				; update X-position for object

		dbf	d6,.loopSwing				; loop for all objects in swing_children
		rts						; return
; End of function Swing_Move

; ===========================================================================
; ===========================================================================

Swing_ChkDel:
		out_of_range.w	.deleteAll,swing_origX(a0)	; has platform gone out of range? if yes, delete it with all links
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite				; display platform
	else
		rts						; return
	endif
; ---------------------------------------------------------------------------

; Swing_DelAll:
.deleteAll:
		moveq	#0,d2					; clear d2
		lea	swing_children(a0),a2			; load child object index array (includes parent platform itself, too)
		move.b	(a2)+,d2				; get number of objects in chain

	.loopDeleteLinks:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get next RAM index for object
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM offset
		movea.l	d0,a1					; move result to a1 as input for DeleteChild
		bsr.w	DeleteChild				; delete child object (and parent in last loop)
		dbf	d2,.loopDeleteLinks			; repeat for length of chain

	.return:
		rts						; return
; ===========================================================================

Swing_Delete:	; Routine 6/8 (unused?)
		bsr.w	DeleteObject				; delete object
		rts						; return
; ===========================================================================

; Swing_Display:
Swing_ChainLink: ; Routine $A
		; Note: Chain links are updated and deleted through the parent object!
		bra.w	DisplaySprite				; just display chain sprite

; ===========================================================================

Map_Swing_GHZ:	include	"_maps/Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:	include	"_maps/Swinging Platforms (SLZ).asm"
