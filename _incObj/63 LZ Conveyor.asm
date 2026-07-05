; ===========================================================================
; ---------------------------------------------------------------------------
; Object 63 - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

LabyrinthConvey:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LCon_Index(pc,d0.w),d1
		jsr	LCon_Index(pc,d1.w)

		out_of_range.s	.outOfRange,lcon_baseX(a0)	; has platform object gone out of range? if yes, branch

	.display:
		bra.w	DisplaySprite				; display platform object
; ---------------------------------------------------------------------------

.outOfRange:
		; This check prevents conveyor platforms specifically in LZ3 from despawning
		; after crossing one coarse X-position ($80 pixels) beyond the left edge of
		; the normal range, which fixes a pop-in bug for the wide platform group 4.
		cmpi.b	#act3,(v_act).w				; are we in act 3?
		bne.s	.delete					; if not, branch
		cmpi.w	#$FF80,d0				; has it BARELY gone out of range? (d0 is result from out_of_range)
		bhs.s	.display				; if yes, don't delete platform just yet

	.delete:
		move.b	lcon_groupid(a0),d0			; get initial group ID
		bpl.w	DeleteObject				; if this isn't the spawner object, just delete platform
		andi.w	#$7F,d0					; mask out spawner bit 7
		lea	(v_obj63).w,a2				; load flags storing the "conveyor group loaded" states per set
		bclr	#0,(a2,d0.w)				; clear flag that this group had been loaded to allow reloading it
		bra.w	DeleteObject				; delete spawner object

; ===========================================================================
LCon_Index:	dc.w LCon_Main-LCon_Index		; 0
		dc.w LCon_Platform-LCon_Index		; 2
		dc.w LCon_OnPlatform-LCon_Index		; 4
		dc.w LCon_Wheel-LCon_Index		; 6

lcon_groupid:	equ objoff_2F	; copy of obSubtype from the initial group spawner
lcon_baseX:	equ objoff_30	; base X-position for entire group (roughly in the center)
lcon_nextX:	equ objoff_34	; next target X-position for platform
lcon_nextY:	equ objoff_36	; next target Y-position for platform
lcon_posindex:	equ objoff_38	; current index in target positioning data
lcon_count:	equ objoff_39	; number of entries in group (multiplied by 4)
lcon_increment:	equ objoff_3A	; value to increment to next entry in group (+4 or -4)
lcon_reversed:	equ objoff_3B	; flag set if conveyor direction is currently reversed
lcon_targetdata:equ objoff_3C	; pointer to corner data for group
; ===========================================================================

LCon_Main:	; Routine 0
		move.b	obSubtype(a0),d0			; is this the initial spawner object?
		bmi.w	LCon_Main_Spawner			; if yes, branch
		
		; Object is a platform (from custom objpos data) or a decorative wheel (from normal objpos data)
		addq.b	#2,obRoutine(a0)			; advance to LCon_Platform
		move.l	#Map_LConv,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Conveyor_Belt|Tile_Pal3,obGfx(a0) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#32/2,obActWid(a0)			; set sprite display width and platform collision width
		move.b	#4,obPriority(a0)			; set sprite priority

		cmpi.b	#$7F,obSubtype(a0)			; is this the decorative wheel object?
		bne.s	LCon_Main_Platform			; if not, branch
		addq.b	#4,obRoutine(a0)			; advance to LCon_Wheel
		move.w	#ArtTile_LZ_Conveyor_Belt,obGfx(a0)	; use palette line 1
		move.b	#1,obPriority(a0)			; set sprite priority above other conveyor objects and Sonic
		bra.w	LCon_Wheel				; go straight to wheel logic
; ---------------------------------------------------------------------------

LCon_Main_Platform:
		move.b	#4,obFrame(a0)				; set to "platform" frame ID

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype of platform (stored in custom objpos data)
		move.w	d0,d1					; backup for later
		lsr.w	#3,d0					; read only upper digit, multiplied by 2
		andi.w	#$1E,d0					; limit to sane values
		lea	LCon_Data(pc),a2			; load platform target coordinate data
		adda.w	(a2,d0.w),a2				; advance to data set for current group
		move.w	(a2)+,lcon_posindex(a0)			; set lcon_posindex to zero ($38) and write group entry count to lcon_count ($39)
		move.w	(a2)+,lcon_baseX(a0)			; retrieve base X-position
		move.l	a2,lcon_targetdata(a0)			; store address pointing to first actual entry in group

		andi.w	#$F,d1					; read only lower digit of platform subtype
		lsl.w	#2,d1					; multiply by 4 bytes per entry
		move.b	d1,lcon_posindex(a0)			; set initial index in target positioning data specified by subtype
		move.b	#4,lcon_increment(a0)			; set increment value forwards (4 bytes per entry)

		tst.b	(f_conveyrev).w				; is conveyor direction currently (globally) reversed?
		beq.s	.finishPlatform				; if not, branch
		move.b	#1,lcon_reversed(a0)			; set movement-reversed flag
		neg.b	lcon_increment(a0)			; set increment value backwards (-4)
		moveq	#0,d1					; clear d1
		move.b	lcon_posindex(a0),d1			; get initial index for target positioning data
		add.b	lcon_increment(a0),d1			; go to previous entry (-4 since it's reversed)
		cmp.b	lcon_count(a0),d1			; has new index exceeded group size?
		bcs.s	.setTargetIndex				; if not, branch

		; This probably was copy-pasted from LCon_Platform_Update, seeing how it
		; still checks for non-reversed movement despite not being possible here.
		move.b	d1,d0					; backup for reversal check
		moveq	#0,d1					; reset corner index to 0 (not reversed)
		tst.b	d0					; is movement currently reversed? (...it always is at this point)
		bpl.s	.setTargetIndex				; if not, branch
		move.b	lcon_count(a0),d1			; reset corner entry to last entry (reversed)
		subq.b	#4,d1					; indeces are 0-based
	.setTargetIndex:
		move.b	d1,lcon_posindex(a0)			; remember new index in target data

	.finishPlatform:
		move.w	(a2,d1.w),lcon_nextX(a0)		; retrieve first target X-position for platform
		move.w	2(a2,d1.w),lcon_nextY(a0)		; retrieve first target Y-position for platform

		bsr.w	LCon_ChangeDir				; initialize platform's speeds for first target
		bra.w	LCon_Platform				; go to main platform logic
; ===========================================================================

LCon_Main_Spawner:
		move.b	d0,lcon_groupid(a0)			; remember subtype ID of parent group
		andi.w	#$7F,d0					; mask out spawner bit 7
		lea	(v_obj63).w,a2				; load flags storing the "conveyor group loaded" states per set
		bset	#0,(a2,d0.w)				; set flag that this conveyor group has been loaded
	if FixBugs
		; Avoid returning to LabyrinthConvey to prevent a
		; display-and-delete bug.
		beq.s	.spawn					; if it wasn't already set, branch
		addq.l	#4,sp					; skip returning to "LabyrinthConvey"
		bra.w	DeleteObject				; delete spawner object
	else
		bne.w	DeleteObject				; if it was already set, don't create platform group again
	endif
; ---------------------------------------------------------------------------

.spawn:
		; LZ conveyor belt platforms use a special variation of the standard level object positioning data,
		; indexed at ObjPosLZPlatform_Index (see "objpos/platforms/" folder). The same format is also used
		; for the conveyor platforms in SBZ, as that object is largely copy-pasted from this one.
		; Format:
		; 	number of entries minus 1
		; 	X-pos, Y-pos, subtype
		; 	entries...
		; All fields are word-sized, even the subtype.

		add.w	d0,d0					; double group ID for word-based indexing
		andi.w	#$1E,d0					; mask out upper digit
		addi.w	#ObjPosLZPlatform_Index-ObjPos_Index,d0	; add start index for LZ conveyor platform objpos data
		lea	(ObjPos_Index).l,a2			; load base of level object definitions
		adda.w	(a2,d0.w),a2				; advance to conveyor platform objpos data for group ID
		move.w	(a2)+,d1				; retrieve number of platforms in objpos data
		movea.l	a0,a1					; write first platform to current RAM location
		bra.s	.makePlatform				; no need to find a free RAM slot for first platform
; ---------------------------------------------------------------------------

.loopMakePlatforms:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj				; find next free object RAM slot
	else
		bsr.w	FindFreeObj				; find any free object RAM slot
	endif
		bne.s	.next					; if object RAM is full, branch

	.makePlatform:
		; Note: obRoutine is implicitely left at 0, so all platforms will run through LCon_Main again!
		_move.b	#id_LabyrinthConvey,obID(a1)		; load LZ conveyor platform object
		move.w	(a2)+,obX(a1)				; get next X-position
		move.w	(a2)+,obY(a1)				; get next Y-position
		move.w	(a2)+,d0				; get next subtype (stored as word, upper byte is always $00)
		move.b	d0,obSubtype(a1)			; save lower byte as subtype ($00-$53)
	.next:
		dbf	d1,.loopMakePlatforms			; loop for number of platforms in objpos data

		addq.l	#4,sp					; skip returning to "LabyrinthConvey"
		rts						; exit object
; ===========================================================================

LCon_Platform:	; Routine 2
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		jsr	(PlatformObject).l			; allow Sonic entering platform (sets obRoutine = 4 (LCon_OnPlatform) on enter)

		bra.w	LCon_Platform_Update			; update platform target movement, if necessary
; ===========================================================================

LCon_OnPlatform: ; Routine 4
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		jsr	(ExitPlatform).l			; allow Sonic exiting platform (sets obRoutine = 2 (LCon_Platform) on exit)

		move.w	obX(a0),-(sp)				; backup previous X-position before calling LCon_Platform_Update
		bsr.w	LCon_Platform_Update			; update platform target movement, if necessary
		move.w	(sp)+,d2				; restore previous X-position as input for MvSonicOnPtfm2
		jmp	(MvSonicOnPtfm2).l			; move Sonic with platform as it moves along conveyor belt
; ===========================================================================

LCon_Wheel:	; Routine 6
		move.w	(v_framecount).w,d0			; get current level frame counter
		andi.w	#3,d0					; advance animation every 4th frame
		bne.s	.display				; branch on other frames
		moveq	#1,d1					; advance to next frame ID
		tst.b	(f_conveyrev).w				; is conveyor currently going backwards?
		beq.s	.updateFrame				; if not, branch
		neg.b	d1					; advance to previous frame ID instead

	.updateFrame:
		add.b	d1,obFrame(a0)				; update current wheel frame ID
		andi.b	#3,obFrame(a0)				; limit to frame IDs 0-3

	.display:
		addq.l	#4,sp					; skip returning to "LabyrinthConvey:" to avoid its custom deletion logic
		bra.w	RememberState				; just display and delete the wheel sprite normally


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to get next target coordinates and update platform position
; ---------------------------------------------------------------------------

; sub_12502:
LCon_Platform_Update:
		tst.b	(f_switch+$E).w				; has button $E been pressed?
		beq.s	.checkAtCorner				; if not, branch
		tst.b	lcon_reversed(a0)			; is reverse flag already set?
		bne.s	.checkAtCorner				; if yes, branch
		move.b	#1,lcon_reversed(a0)			; set local flag
		move.b	#1,(f_conveyrev).w			; set global flag
		neg.b	lcon_increment(a0)			; negate increment value (to -4)
		bra.s	.nextCorner				; immediately update movement direction
; ---------------------------------------------------------------------------

	.checkAtCorner:
		move.w	obX(a0),d0				; get platform's current X-position
		cmp.w	lcon_nextX(a0),d0			; is platform at corner? (X-axis)
		bne.s	.updatePos				; if not, branch
		move.w	obY(a0),d0				; get platform's current Y-position
		cmp.w	lcon_nextY(a0),d0			; is platform at corner? (Y-axis)
		bne.s	.updatePos				; if not, branch

	.nextCorner:
		moveq	#0,d1					; clear d1
		move.b	lcon_posindex(a0),d1			; get current index for target positioning data
		add.b	lcon_increment(a0),d1			; go to next entry (+4, or -4 if reversed)
		cmp.b	lcon_count(a0),d1			; has new index exceeded group size?
		bcs.s	.getNextTarget				; if not, branch
		move.b	d1,d0					; backup for reversal check
		moveq	#0,d1					; reset corner index to 0 (not reversed)
		tst.b	d0					; is movement currently reversed?
		bpl.s	.getNextTarget				; if not, branch
		move.b	lcon_count(a0),d1			; reset corner entry to last entry (reversed)
		subq.b	#4,d1					; indeces are 0-based

	.getNextTarget:
		move.b	d1,lcon_posindex(a0)			; remember new index in target data

		movea.l	lcon_targetdata(a0),a1			; get address pointing to target positions for group
		move.w	(a1,d1.w),lcon_nextX(a0)		; retrieve next target X-position for platform
		move.w	2(a1,d1.w),lcon_nextY(a0)		; retrieve next target Y-position for platform
		bsr.w	LCon_ChangeDir				; update platform's speeds for next target

	.updatePos:
		bsr.w	SpeedToPos				; update platform's current position
		rts						; return
; End of function LCon_Platform_Update

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set a platform's movement speeds towards next X/Y-target.
; Note: this is also called from Object 63 (SBZ spinning conveyor platforms)!
; ---------------------------------------------------------------------------

LCon_ChangeDir:
		moveq	#0,d0					; clear d0
		move.w	#-$100,d2				; move platforms horizontally at 1px/frame left
		move.w	obX(a0),d0				; get platform's current X-position
		sub.w	lcon_nextX(a0),d0			; calculate difference to target X-position
		bcc.s	.calcYDirection				; if platform is right of target, branch
		neg.w	d0					; keep X-position difference positive
		neg.w	d2					; move platforms right instead

	.calcYDirection:
		moveq	#0,d1					; clear d1
		move.w	#-$100,d3				; move platforms vertically at 1px/frame upwards
		move.w	obY(a0),d1				; get platform's current Y-position
		sub.w	lcon_nextY(a0),d1			; calculate difference to target Y-position
		bcc.s	.checkGreaterDistance			; if platform is below target, branch
		neg.w	d1					; keep Y-position difference positive
		neg.w	d3					; move platforms down instead

	.checkGreaterDistance:
		cmp.w	d0,d1					; is Y-position difference larger than X-position difference?
		bcs.s	.moveVertical				; if yes, branch

		move.w	obX(a0),d0				; get platform's current X-position
		sub.w	lcon_nextX(a0),d0			; calculate signed difference to target X-position
		beq.s	.setSpeedsHorizontal			; if no horizontal movement is needed, branch
		ext.l	d0					; sign-extend difference to long
		asl.l	#8,d0					; shift up a byte (16.16 fixed)
		divs.w	d1,d0					; X-speed = signed X-difference / unsigned Y-difference
		neg.w	d0					; negate result to move towards target position
	.setSpeedsHorizontal:
		move.w	d0,obVelX(a0)				; set platform's horizontal speed (division result)
		move.w	d3,obVelY(a0)				; set platform's vertical speed (1px/frame up or down)
		swap	d0					; move division remainder into lower word (0 if skipped)
		move.w	d0,obSubpixelX(a0)			; use division remainder as initial X-subpixel position
		clr.w	obSubpixelY(a0)				; force initial Y-subpixel position to 0
		rts						; return
; ---------------------------------------------------------------------------

.moveVertical:
		move.w	obY(a0),d1				; get platform's current Y-position
		sub.w	lcon_nextY(a0),d1			; calculate signed difference to target Y-position
		beq.s	.setSpeedsVertical			; if no vertical movement is needed, branch
		ext.l	d1					; sign-extend difference to long
		asl.l	#8,d1					; shift up a byte (16.16 fixed)
		divs.w	d0,d1					; Y-speed = signed Y-difference / unsigned X-difference
		neg.w	d1					; negate result to move towards target position
	.setSpeedsVertical:
		move.w	d1,obVelY(a0)				; set platform's vertical speed (division result)
		move.w	d2,obVelX(a0)				; set platform's horizontal speed (1px/frame left or right)
		swap	d1					; move division remainder into lower word (0 if skipped)
		move.w	d1,obSubpixelY(a0)			; use division remainder as initial Y-subpixel position
		clr.w	obSubpixelX(a0)				; force initial X-subpixel position to 0
		rts						; return
; End of function LCon_ChangeDir


; ===========================================================================
; Conveyor belt corner target coordinate definitions.
; Each group corresponds to the lower nybble of the given subtype.
; Format:
; 	dc.w number of entries times 4
; 	dc.w base X position (used for out_of_range check)
; 	dc.w entries...
; Entries consist of a target X position and target Y position.

LCon_Data:	dc.w .group0-LCon_Data
		dc.w .group1-LCon_Data
		dc.w .group2-LCon_Data
		dc.w .group3-LCon_Data
		dc.w .group4-LCon_Data
		dc.w .group5-LCon_Data

.group0:	
		.baseX_0: = $1070
		.baseY_0: = $2F0
		dc.w 6*4
		dc.w .baseX_0
		dc.w .baseX_0+$08, .baseY_0-$D6
		dc.w .baseX_0+$4E, .baseY_0-$90
		dc.w .baseX_0+$4E, .baseY_0+$A3
		dc.w .baseX_0+$1C, .baseY_0+$D5
		dc.w .baseX_0-$4E, .baseY_0+$A0
		dc.w .baseX_0-$4E, .baseY_0-$AC

.group1:
		.baseX_1: = $1280
		.baseY_1: = $377
		dc.w 5*4
		dc.w .baseX_1
		dc.w .baseX_1-$02, .baseY_1-$F7
		dc.w .baseX_1+$4E, .baseY_1-$A7
		dc.w .baseX_1+$4E, .baseY_1+$F7
		dc.w .baseX_1-$4E, .baseY_1+$A9
		dc.w .baseX_1-$4E, .baseY_1-$AB

.group2:
		.baseX_2: = $D68
		.baseY_2: = $530
		dc.w 4*4
		dc.w .baseX_2
		dc.w .baseX_2-$46, .baseY_2-$AE
		dc.w .baseX_2-$46, .baseY_2+$AE
		dc.w .baseX_2+$46, .baseY_2+$AE
		dc.w .baseX_2+$46, .baseY_2-$AE

.group3:
		.baseX_3: = $DA0
		.baseY_3: = $440
		dc.w 4*4
		dc.w .baseX_3
		dc.w .baseX_3-$3E, .baseY_3-$9E
		dc.w .baseX_3+$4E, .baseY_3-$9E
		dc.w .baseX_3+$4E, .baseY_3+$9E
		dc.w .baseX_3-$3E, .baseY_3+$9E

.group4:
		.baseX_4: = $D00
		.baseY_4: = $310
		dc.w 5*4
		dc.w .baseX_4
		dc.w .baseX_4-$54, .baseY_4-$CE
		dc.w .baseX_4+$DE, .baseY_4-$CE
		dc.w .baseX_4+$DE, .baseY_4+$CE
		dc.w .baseX_4-$AE, .baseY_4+$CE
		dc.w .baseX_4-$AE, .baseY_4-$74

.group5:
		.baseX_5: = $1300
		.baseY_5: = $264
		dc.w 4*4
		dc.w .baseX_5
		dc.w .baseX_5-$AE, .baseY_5-$5A
		dc.w .baseX_5+$DE, .baseY_5-$5A
		dc.w .baseX_5+$DE, .baseY_5+$5A
		dc.w .baseX_5-$AE, .baseY_5+$5A

; ===========================================================================

Map_LConv:	include	"_maps/LZ Conveyor.asm"
