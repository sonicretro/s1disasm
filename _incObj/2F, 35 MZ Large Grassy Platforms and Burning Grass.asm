; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2F - large grass-covered platforms (MZ)
; ---------------------------------------------------------------------------

LargeGrass:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LGrass_Index(pc,d0.w),d1
		jmp	LGrass_Index(pc,d1.w)
; ===========================================================================
LGrass_Index:	dc.w LGrass_Main-LGrass_Index
		dc.w LGrass_Action-LGrass_Index

lgrass_origX:	equ objoff_2A	; initial X-position
lgrass_origY:	equ objoff_2C	; initial Y-position
lgrass_coldata:	equ objoff_30	; pointer to platform slope collision data
lgrass_nudge:	equ objoff_34	; (type $x5 only, burnable) nudge Y-offset while Sonic is standing on platform
lgrass_burning:	equ objoff_35	; (type $x5 only, burnable) flag set when platform has started burning
lgrass_flames:	equ objoff_36	; (type $x5 only, burnable) array of children fire objects ($36 = child count, $37-$3E = RAM indeces to flames)
; ===========================================================================

LGrass_Data: 	; collision angle data (relative offset)
		; frame number, platform width
		dc.w LGrass_Data_Symmetrical-LGrass_Data	; Type $0x - symmetrical platform
		dc.b 0,	128/2

		dc.w LGrass_Data_Asymmetrical-LGrass_Data	; Type $1x - asymmetrical platform
		dc.b 1,	128/2

		dc.w LGrass_Data_Column-LGrass_Data		; Type $2x - column/rectangular platform
		dc.b 2,	64/2
; ===========================================================================

LGrass_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to LGrass_Action
		move.l	#Map_LGrass,obMap(a0)			; set mappings
		move.w	#ArtTile_Level|Tile_Pal3|Tile_Prio,obGfx(a0) ; set art tile, palette line, and high-priority flag
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#5,obPriority(a0)			; set sprite priority
		move.w	obY(a0),lgrass_origY(a0)		; remember initial Y-position
		move.w	obX(a0),lgrass_origX(a0)		; remember initial X-position

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		lsr.w	#2,d0					; read only upper digit, multiplied by 4 bytes per entry
		andi.w	#$1C,d0					; limit to shifted, upper digit
		lea	LGrass_Data(pc,d0.w),a1			; load platform data
		move.w	(a1)+,d0				; get relative offset to collision angle data
		lea	LGrass_Data(pc,d0.w),a2			; calculate pointer to collision angle data
		move.l	a2,lgrass_coldata(a0)			; store pointer to collision angle data
		move.b	(a1)+,obFrame(a0)			; load platform frame ID
		move.b	(a1),obActWid(a0)			; load platform sprite display width and solidity width
		andi.b	#$F,obSubtype(a0)			; clear upper subtype digit

		move.b	#128/2,obHeight(a0)			; set sprite display height
		bset	#sprite_customheight_bit,obRender(a0)	; enable custom sprite height rendering
; ---------------------------------------------------------------------------

LGrass_Action:	; Routine 2
		bsr.w	LGrass_Types				; execute platform movement behavior

		tst.b	obSolid(a0)				; is Sonic standing on platform?
		beq.s	LGrass_Solid				; if not, branch

		; Check if Sonic is still in platform
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform width
		addi.w	#sonic_solid_width,d1			; add Sonic's own solidity width
		bsr.w	ExitPlatform				; allow Sonic exiting the platform
		btst	#3,obStatus(a1)				; is Sonic still standing on platform?
		bne.w	LGrass_Slope				; if yes, branch
		clr.b	obSolid(a0)				; clear platform solidity flag

		bra.s	LGrass_Display				; display platform or delete if out of range
; ===========================================================================

LGrass_Slope:	; Sonic is still on platform, align with slope data
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform width
		addi.w	#sonic_solid_width,d1			; add Sonic's own solidity width
		movea.l	lgrass_coldata(a0),a2			; load pointer to slope collision data
		move.w	obX(a0),d2				; platform X-position is required as input
		bsr.w	SlopeObject_AssumeStoodOn		; align Sonic with platform slope collision data

		bra.s	LGrass_Display				; display platform or delete if out of range
; ===========================================================================

LGrass_Solid:	; Sonic is NOT on platform
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform width
		addi.w	#sonic_solid_width,d1			; add Sonic's own solidity width
		move.w	#64/2,d2				; platform height (symmetrical/asymmetrical)
		cmpi.b	#2,obFrame(a0)				; is this a column/rectangular platform?
		bne.s	.solidSlope				; if not, branch
		move.w	#96/2,d2				; platform height (column)
	.solidSlope:
		movea.l	lgrass_coldata(a0),a2			; load pointer to slope collision data
		bsr.w	SolidObject_Heightmap			; make platform solid based on slope collision data (sets obSolid when stood on)
; ---------------------------------------------------------------------------

LGrass_Display:
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display platform sprite
	endif
		bra.w	LGrass_ChkDel				; delete platform if it has gone out of range

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to execute platform behavior based on its subtype
; ---------------------------------------------------------------------------

LGrass_Types:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		andi.w	#7,d0					; limit to lower digit, lower nybble
		add.w	d0,d0					; double for word-based indexing
		move.w	LGrass_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jmp	LGrass_TypeIndex(pc,d1.w)		; execute behavior for platform
; End of function LGrass_Types
; ===========================================================================
LGrass_TypeIndex:
		dc.w LGrass_Stationary-LGrass_TypeIndex		; 0
		dc.w LGrass_UpDown_Narrowest-LGrass_TypeIndex	; 1
		dc.w LGrass_UpDown_Narrow-LGrass_TypeIndex	; 2
		dc.w LGrass_UpDown_Wide-LGrass_TypeIndex	; 3
		dc.w LGrass_UpDown_Widest-LGrass_TypeIndex	; 4
		dc.w LGrass_Burnable-LGrass_TypeIndex		; 5
; ===========================================================================

; Type 0 - stationary
LGrass_Stationary:
		rts		; type 00 platform doesn't move
; ===========================================================================

; Type 1 - up/down narrowest
LGrass_UpDown_Narrowest:
		move.b	(v_oscillate+2).w,d0			; get oscillation value (frequency 2, middle value $10)
		move.w	#$10*2,d1				; keep in same range if movement is reversed
		bra.s	LGrass_MoveVertical			; update Y-position for oscillation value
; ===========================================================================

; Type 2 - up/down narrow
LGrass_UpDown_Narrow:
		move.b	(v_oscillate+6).w,d0			; get oscillation value (frequency 2, middle value $18)
		move.w	#$18*2,d1				; keep in same range if movement is reversed
		bra.s	LGrass_MoveVertical			; update Y-position for oscillation value
; ===========================================================================

; Type 3 - up/down wide
LGrass_UpDown_Wide:
		move.b	(v_oscillate+$A).w,d0			; get oscillation value (frequency 2, middle value $20)
		move.w	#$20*2,d1				; keep in same range if movement is reversed
		bra.s	LGrass_MoveVertical			; update Y-position for oscillation value
; ===========================================================================

; Type 4 - up/down widest
LGrass_UpDown_Widest:
		move.b	(v_oscillate+$E).w,d0			; get oscillation value (frequency 2, middle value $30)
		move.w	#$30*2,d1				; keep in same range if movement is reversed
		; continue to LGrass_MoveVertical...
; ---------------------------------------------------------------------------

LGrass_MoveVertical:
		btst	#3,obSubtype(a0)			; is "reverse movement" flag set in subtype? (i.e. +8 or bit 3)
		beq.s	.updateYPosition			; if not, branch
		neg.w	d0					; return movement direction
		add.w	d1,d0					; keep in the same general range

	.updateYPosition:
		move.w	lgrass_origY(a0),d1			; get initial platform Y-position
		sub.w	d0,d1					; adjust by oscillation offset
		move.w	d1,obY(a0)				; move platform up and down
		rts						; return
; ===========================================================================

; Type 5 - starts burning when it has been depressed from standing on it long enough
LGrass_Burnable:
		move.b	lgrass_nudge(a0),d0			; get current nudge value
		tst.b	obSolid(a0)				; is Sonic standing on platform?
		bne.s	.depress				; if yes, branch

		subq.b	#2,d0					; reduce nudging while Sonic isn't on platform
		bcc.s	.updateY				; if it hasn't returned to origin position, branch 
		moveq	#0,d0					; stop going back up
		bra.s	.updateY				; skip depression logic
; ---------------------------------------------------------------------------

.depress:
		addq.b	#4,d0					; depress platform further
		cmpi.b	#$40,d0					; has it reached maximum depression?
		blo.s	.updateY				; if not, branch
		move.b	#$40,d0					; keep at maximum depression

	.updateY:
		move.b	d0,lgrass_nudge(a0)			; update current nudge value
		jsr	(CalcSine).l				; convert it into a sine for smooth movement
		lsr.w	#4,d0					; divide sine result by $10
		move.w	d0,d1					; copy result for later
		add.w	lgrass_origY(a0),d0			; get initial platform Y-position
		move.w	d0,obY(a0)				; update current platform Y-position

		; Flame logic
		cmpi.b	#$40/2,lgrass_nudge(a0)			; has platform been depressed halfway through?
		bne.s	.updateflamesForNudge			; if not, branch
		tst.b	lgrass_burning(a0)			; is platform already burning?
		bne.s	.updateflamesForNudge			; if yes, branch
		move.b	#1,lgrass_burning(a0)			; set flag that platform is burning

		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.updateflamesForNudge			; if object RAM is full, branch
		_move.b	#id_GrassFire,obID(a1)			; load sitting grass fire object
		move.w	obX(a0),obX(a1)				; copy parent X-position
		move.w	lgrass_origY(a0),gfire_origY(a1)	; copy parent initial Y-position
		addq.w	#8,gfire_origY(a1)			; adjust Y-position 8px down...
		subq.w	#3,gfire_origY(a1)			; ...and 3px up again (could've just been 5px down once)
		subi.w	#128/2,obX(a1)				; adjust 64px to the left (platform half-width)
		move.l	lgrass_coldata(a0),gfire_coldata(a1)	; copy pointer to slope collision data
		move.l	a0,gfire_platform(a1)			; remember address to parent platform object
		movea.l	a0,a2					; a2 is parent platform as input for LGrass_AddChildToList
		bsr.s	LGrass_AddChildToList			; add child fire object to list of children objects

	.updateflamesForNudge:
		moveq	#0,d2					; clear d2
		lea	lgrass_flames(a0),a2			; load list of child objects
		move.b	(a2)+,d2				; get current child count
		subq.b	#1,d2					; decrement for dbf
		bcs.s	.return					; if it underflowed, no children are in the list yet
	.loopUpdateForNudge:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get next RAM index for child object
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.w	#v_objspace&$FFFF,d0			; add base object RAM offset
		movea.w	d0,a1					; a1 = full RAM address to child fire object
		move.w	d1,gfire_nudge(a1)			; write nudge distance from earlier to child
		dbf	d2,.loopUpdateForNudge			; loop for all child objects

	.return:
		rts						; return
; End of function LGrass_Types

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to index to RAM location of child flame to list in parent
; 
; input:
;	a1 = address of child fire
;	a2 = address of parent platform
; ---------------------------------------------------------------------------

; sub_B09C:
LGrass_AddChildToList:
		lea	lgrass_flames(a2),a2			; load list of child objects
		moveq	#0,d0					; clear d0
		move.b	(a2),d0					; get current child count
		addq.b	#1,(a2)					; increment child counter
		lea	1(a2,d0.w),a2				; go to end of list
		move.w	a1,d0					; get child address
		subi.w	#v_objspace&$FFFF,d0			; make child address 0-based
		lsr.w	#object_size_bits,d0			; divide by $40 (object_size)
		andi.w	#$7F,d0					; d0 = index of child
		move.b	d0,(a2)					; copy d0 to end of list
		rts						; return
; End of function LGrass_AddChildToList

; ===========================================================================

LGrass_ChkDel:
		tst.b	lgrass_burning(a0)			; is platform burning? (subtype $x5 only)
		beq.s	LGrass_ChkGone				; if not, branch
		tst.b	obRender(a0)				; is platform on screen?
		bpl.s	LGrass_DelFlames			; if not, delete fire objects

LGrass_ChkGone:
		out_of_range.w	DeleteObject,lgrass_origX(a0)	; has platform gone out of range? if yes, delete it
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite				; display platform sprite
	else
		rts						; return
	endif
; ===========================================================================

LGrass_DelFlames:
		moveq	#0,d2					; clear d0
		lea	lgrass_flames(a0),a2			; load list of child flames
		move.b	(a2),d2					; get current child count
		clr.b	(a2)+					; reset child count to 0
		subq.b	#1,d2					; decrement for dbf
		bcs.s	.return					; if it underflowed, no children were spawned

	.loopDeleteFire:
		moveq	#0,d0					; clear d0
		move.b	(a2),d0					; get next RAM index for child object
		clr.b	(a2)+					; clear RAM index in list
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.w	#v_objspace&$FFFF,d0			; add base object RAM offset
		movea.w	d0,a1					; move result to a1 as input for DeleteChild
		bsr.w	DeleteChild				; delete child fire object
		dbf	d2,.loopDeleteFire			; repeat for all spawned fire objects

		move.b	#0,lgrass_burning(a0)			; clear platform burning flag so it can burn again
		move.b	#0,lgrass_nudge(a0)			; reset to initial depression

.return:
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.s	LGrass_ChkGone				; continue deleting main platform object
	else
		rts						; return
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for large moving platforms (MZ)
; ---------------------------------------------------------------------------

LGrass_Data_Symmetrical:
	; _/*\_
	dcb.b	 14,$20		; flat
	range	$21,$2F,+1	; ascending
	dcb.b	 18,$30		; flat
	range	$2F,$21,-1	; descending
	dcb.b	 14,$20		; flat
	even

LGrass_Data_Column:
	; |**|
	dcb.b	 44,$30		; flat
	even

LGrass_Data_Asymmetrical:
	; _/*\-
	dcb.b	  6,$20		; flat
	range	$21,$3F,+1	; ascending
	dcb.b	 18,$40		; flat
	range	$3F,$31,-1	; descending
	dcb.b	  6,$30		; flat
	even


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 35 - fireball that sits on the floor (MZ)
; (appears when you walk on grass platforms with subtype $x5)
; ---------------------------------------------------------------------------

GrassFire:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GFire_Index(pc,d0.w),d1
		jmp	GFire_Index(pc,d1.w)
; ===========================================================================
GFire_Index:	dc.w GFire_Main-GFire_Index
		dc.w GFire_Spread-GFire_Index
		dc.w GFire_Move-GFire_Index

gfire_origX:	equ objoff_2A	; initial X-position
gfire_origY:	equ objoff_2C	; initial Y-position (set from parent)
gfire_coldata:	equ objoff_30	; pointer to platform slope collision data
gfire_platform:	equ objoff_38	; pointer to parent platform object
gfire_nudge:	equ objoff_3C	; current pixels parent platform is depressed from standing
; ===========================================================================

GFire_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to GFire_Spread
		move.l	#Map_Fire,obMap(a0)			; set mappings
		move.w	#ArtTile_MZ_Fireball,obGfx(a0)		; set art tile
		move.w	obX(a0),gfire_origX(a0)			; remember initial X-position
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#1,obPriority(a0)			; set sprite priority (above platform and Sonic)
		move.b	#col_16x16|col_hurt,obColType(a0)	; make fire balls harmful on touch
		move.b	#16/2,obActWid(a0)			; set sprite display width

		move.w	#sfx_Burning,d0				; set burning sound
		jsr	(QueueSound2).l				; play it

		tst.b	obSubtype(a0)				; is this the parent fireball?
		beq.s	GFire_Spread				; if yes, branch to spawn child fireballs
		addq.b	#2,obRoutine(a0)			; advance child fireball to GFire_Move
		bra.w	GFire_Move				; go there immediately
; ===========================================================================

GFire_Spread:	; Routine 2
		movea.l	gfire_coldata(a0),a1			; load parent platform slope collision data
		move.w	obX(a0),d1				; get main flame's current X-position
		sub.w	gfire_origX(a0),d1			; calculate horizontal distance travelled from origin so far
		addi.w	#12,d1					; start 12 bytes into slope collision data
		move.w	d1,d0					; remember result for later
		lsr.w	#1,d0					; divide by 2
		move.b	(a1,d0.w),d0				; find slope height at current X-position
		neg.w	d0					; align flames upwards
		add.w	gfire_origY(a0),d0			; add initial Y-position
		move.w	d0,d2					; remember result for potential child flame spawn
		add.w	gfire_nudge(a0),d0			; add current depression distance
		move.w	d0,obY(a0)				; align parent flame with sloped platform

		cmpi.w	#132,d1					; has parent flame reached the rightmost edge of platform?
		bhs.s	.animate				; if yes, stop moving or spawning new child flames
		addi.l	#$10000,obX(a0)				; move parent flame to the right at 1px/frame (including subpixels)

		cmpi.w	#128,d1					; has parent flame almost reached the rightmost edge of platform?
		bhs.s	.animate				; if yes, no longer spawn child flames (but move a bit longer)
		move.l	obX(a0),d0				; get current parent flame X-position (including subpixels)
		addi.l	#$80000,d0				; adjust by 8px to the right
		andi.l	#$FFFFF,d0				; has parent flame reached a new multiple of 16px?
		bne.s	.animate				; if not, don't spawn new flame object

		bsr.w	FindNextFreeObj				; find a free object slot ("next" ensures children always spawn behind parent sprite)
		bne.s	.animate				; if object RAM is full, branch
		_move.b	#id_GrassFire,obID(a1)			; load another child fireball object
		move.w	obX(a0),obX(a1)				; spawn at parent's current X-position
		move.w	d2,gfire_origY(a1)			; align new flame with slope height
		move.w	gfire_nudge(a0),gfire_nudge(a1)		; transfer current depression distance
		move.b	#1,obSubtype(a1)			; make child object skip GFire_Spread
		movea.l	gfire_platform(a0),a2			; a2 is parent platform as input for LGrass_AddChildToList
		bsr.w	LGrass_AddChildToList			; add child fire object to list of children objects

	.animate:
		bra.s	GFire_Animate				; skip regular slope align logic for parent flame
; ===========================================================================

GFire_Move:	; Routine 4
		move.w	gfire_origY(a0),d0			; get initial Y-position
		add.w	gfire_nudge(a0),d0			; adjust by nudge distance from parent platform
		move.w	d0,obY(a0)				; vertically align fireball with platform slope
; ---------------------------------------------------------------------------

GFire_Animate:
		lea	(Ani_GFire).l,a1			; load animation script
		bsr.w	AnimateSprite				; animate fireballs
		bra.w	DisplaySprite				; display fireballs

; ===========================================================================

		include	"_anim/Burning Grass.asm"
Map_LGrass:	include	"_maps/MZ Large Grassy Platforms.asm"
