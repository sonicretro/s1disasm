; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; 
; Note: this is pretty much an edited copy-paste of Object 63 (LZ conveyor)!
; ---------------------------------------------------------------------------

SpinConvey:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SpinC_Index(pc,d0.w),d1
		jsr	SpinC_Index(pc,d1.w)

		out_of_range.s	.outOfRange,spinc_baseX(a0)	; has platform gone out of range? if yes, branch

	.display:
		jmp	(DisplaySprite).l			; display platform object
; ---------------------------------------------------------------------------

.outOfRange:
		; Unused and pointless leftover likely copied from LabyrinthConvey (Object 63),
		; since SBZ act 3 is Final Zone internally and doesn't have conveyor belt platforms.
		cmpi.b	#act3,(v_act).w				; are we in act 3? (never the case)
		bne.s	.despawn				; if not, branch
		cmpi.w	#$FF80,d0				; has it BARELY gone out of range? (d0 is result from out_of_range)
		bhs.s	.display				; if yes, don't delete platform just yet

	.despawn:
		move.b	spinc_groupid(a0),d0			; get initial group ID
		bpl.s	.delete					; if this isn't the spawner object, just delete platform
		andi.w	#$7F,d0					; mask out spawner bit 7
		lea	(v_obj63).w,a2				; load flags storing the "conveyor group loaded" states per set
		bclr	#0,(a2,d0.w)				; clear flag that this group had been loaded to allow reloading it

	.delete:
		jmp	(DeleteObject).l			; delete spawner or platform object

; ===========================================================================
SpinC_Index:	dc.w SpinC_Main-SpinC_Index
		dc.w SpinC_Solid-SpinC_Index

; Note: This entire object is pretty much a modified copy-paste job of
; the LZ conveyor belt (Object 63), even calling some of its subroutines.
; As such not only are all its SSTs reused, some of them also MUST stay
; the same to function properly!
spinc_groupid:		equ objoff_2F	; copy of obSubtype from the initial group spawner
spinc_baseX:		equ objoff_30	; initial X-position for entire group (roughly in the center)
spinc_nextX:		equ lcon_nextX	; next target X-position (=objoff_34)
spinc_nextY:		equ lcon_nextY	; next target Y-position (=objoff_36)
spinc_posindex:		equ objoff_38	; index of next corner
spinc_count:		equ objoff_39	; number of entries in group (multiplied by 4)
spinc_increment:	equ objoff_3A	; value to increment to next entry in group (+4 or -4)
spinc_reversed:		equ objoff_3B	; (unused in SBZ) flag set if conveyor direction is currently reversed
spinc_targetdata:	equ objoff_3C	; pointer to corner data for group
; ===========================================================================

SpinC_Main:	; Routine 0
		move.b	obSubtype(a0),d0			; is this the initial spawner object?
		bmi.w	SpinC_Main_Spawner			; if yes, branch

		; Object is a platform (from custom objpos data)
		addq.b	#2,obRoutine(a0)			; advance to SpinC_Solid
		move.l	#Map_Spin,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Spinning_Platform,obGfx(a0) ; set art tile
		move.b	#32/2,obActWid(a0)			; set sprite display width
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype of platform (stored in custom objpos data)
		move.w	d0,d1					; backup for later
		lsr.w	#3,d0					; read only upper digit, multiplied by 2
		andi.w	#$1E,d0					; limit to sane values
		lea	SpinC_Data(pc),a2			; load platform target coordinate data
		adda.w	(a2,d0.w),a2				; advance to data set for current group
		move.w	(a2)+,spinc_posindex(a0)		; set spinc_posindex to zero ($38) and write group entry count to spinc_count ($39)
		move.w	(a2)+,spinc_baseX(a0)			; retrieve base X-position
		move.l	a2,spinc_targetdata(a0)			; store address pointing to first actual entry in group

		andi.w	#$F,d1					; read only lower digit of platform subtype
		lsl.w	#2,d1					; multiply by 4 bytes per entry
		move.b	d1,spinc_posindex(a0)			; set initial index in target positioning data specified by subtype
		move.b	#4,spinc_increment(a0)			; set increment value forwards (4 bytes per entry)

		tst.b	(f_conveyrev).w				; is conveyor direction currently (globally) reversed?
		beq.s	.finishPlatform				; if not, branch
		move.b	#1,spinc_reversed(a0)			; set movement-reversed flag
		neg.b	spinc_increment(a0)			; set increment value backwards (-4)
		moveq	#0,d1					; clear d1
		move.b	spinc_posindex(a0),d1			; get initial index for target positioning data
		add.b	spinc_increment(a0),d1			; go to previous entry (-4 since it's reversed)
		cmp.b	spinc_count(a0),d1			; has new index exceeded group size?
		bcs.s	.setTargetIndex				; if not, branch

		; This was probably copy-pasted from spinc_Platform_Update, seeing how it
		; still checks for non-reversed movement despite not being possible here.
		move.b	d1,d0					; backup for reversal check
		moveq	#0,d1					; reset corner index to 0 (not reversed)
		tst.b	d0					; is movement currently reversed? (...it always is at this point)
		bpl.s	.setTargetIndex				; if not, branch
		move.b	spinc_count(a0),d1			; reset corner entry to last entry (reversed)
		subq.b	#4,d1					; indeces are 0-based
	.setTargetIndex:
		move.b	d1,spinc_posindex(a0)			; remember new index in target data

	.finishPlatform:
		move.w	(a2,d1.w),spinc_nextX(a0)		; retrieve first target X-position for platform
		move.w	2(a2,d1.w),spinc_nextY(a0)		; retrieve first target Y-position for platform

	if FixBugs
		; Ensure platforms on the upper path never start in the spinning state.
		move.b	#1,obAnim(a0)				; set "still" animation
		cmpi.w	#4*2,d1					; is platform at or past third corner?
		blo.s	.initMovement				; if not, branch
		move.b	#0,obAnim(a0)				; set "spinning" animation
	else
		tst.w	d1					; is platform at first corner?
		bne.s	.checkSpinning				; if not, branch
		move.b	#1,obAnim(a0)				; set "still" animation
	    .checkSpinning:
		cmpi.w	#4*2,d1					; is platform at third corner?
		bne.s	.initMovement				; if not, branch
		move.b	#0,obAnim(a0)				; set "spinning" animation
	endif

	.initMovement:
		bsr.w	LCon_ChangeDir				; initialize platform's speeds for first target (calling Object 63)
		bra.w	SpinC_Solid				; go to main platform logic
; ===========================================================================

SpinC_Main_Spawner:
		move.b	d0,spinc_groupid(a0)			; remember subtype ID of parent group
		andi.w	#$7F,d0					; mask out spawner bit 7
		lea	(v_obj63).w,a2				; load flags storing the "conveyor group loaded" states per set
		bset	#0,(a2,d0.w)				; set flag that this conveyor group has been loaded
		beq.s	.spawn					; if it wasn't already set, branch
	if FixBugs
		; Avoid returning to SpinConvey to prevent display-and-delete
		; and double-delete bugs.
		addq.l	#4,sp					; skip returning to "SpinConvey"
	endif
		jmp	(DeleteObject).l			; delete spawner object
; ---------------------------------------------------------------------------

	.spawn:
		; Same format as LZ conveyor platforms, see notes in LCon_Main_Spawner
		add.w	d0,d0					; double group ID for word-based indexing
		andi.w	#$1E,d0					; mask out upper digit
		addi.w	#ObjPosSBZPlatform_Index-ObjPos_Index,d0 ; add start index for SBZ conveyor platform objpos data
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
		jsr	(FindNextFreeObj).l			; find next free object RAM slot
	else
		jsr	(FindFreeObj).l				; find any free object RAM slot
	endif
		bne.s	.next					; if object RAM is full, branch

	; SpinC_LoadPform:
	.makePlatform:
		; Note: obRoutine is implicitely left at 0, so all platforms will run through SpinC_Main again!
		_move.b	#id_SpinConvey,obID(a1)			; load SBZ conveyor platform object
		move.w	(a2)+,obX(a1)				; get next X-position
		move.w	(a2)+,obY(a1)				; get next Y-position
		move.w	(a2)+,d0				; get next subtype (stored as word, upper byte is always $00)
		move.b	d0,obSubtype(a1)			; save lower byte as subtype ($00-$53)

	; SpinC_LoadNext:
	.next:
		dbf	d1,.loopMakePlatforms			; loop for number of platforms in objpos data

		addq.l	#4,sp					; skip returning to "SpinConvey"
		rts						; exit object
; ===========================================================================

; Unlike its copy-pasted original Object 63 (LZ conveyor belt platforms),
; the SBZ conveyor platforms are solid from ALL sides, not just from above.

SpinC_Solid:	; Routine 2
		lea	(Ani_SpinConvey).l,a1			; load animation scripts for spinning SBZ platforms
		jsr	(AnimateSprite).l			; advance animation
		tst.b	obFrame(a0)				; is new frame = 0? (platform upright)
		bne.s	.spinning				; if not, make platform non-solid

		move.w	obX(a0),-(sp)				; backup previous X-position before calling SpinC_Platform_Update
		bsr.w	SpinC_Platform_Update			; update platform target movement, if necessary
		move.w	#32/2+sonic_solid_width,d1		; set platform collision width plus Sonic's own collision width
		move.w	#14/2,d2				; set platform collision height (initial)
		move.w	d2,d3					; set platform collision height (stood-on)
		addq.w	#1,d3					; +1px while stood-on
		move.w	(sp)+,d4				; restore previous X-position as input for SolidObject
		bra.w	SolidObject				; make platform solid
; ---------------------------------------------------------------------------

.spinning:
		btst	#3,obStatus(a0)				; was Sonic on platform as it started spinning?
		beq.s	.updatePlatform				; if not, branch
		lea	(v_player).w,a1				; load Sonic player object
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		bclr	#3,obStatus(a0)				; clear platform's stood-on flag
		clr.b	obSolid(a0)				; clear platform's soliditiy state

	.updatePlatform:
		bra.w	SpinC_Platform_Update			; pointless zero-length branch... was something else here once?

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to get next target coordinates and update platform position,
; as well as setting the spinning/not-spinning animation state
; ---------------------------------------------------------------------------

SpinC_Platform_Update:
		move.w	obX(a0),d0				; get platform's current X-position
		cmp.w	spinc_nextX(a0),d0			; is platform at corner? (X-axis)
		bne.s	.updatePos				; if not, branch
		move.w	obY(a0),d0				; get platform's current Y-position
		cmp.w	spinc_nextY(a0),d0			; is platform at corner? (Y-axis)
		bne.s	.updatePos				; if not, branch

		moveq	#0,d1					; clear d1
		move.b	spinc_posindex(a0),d1			; get current index for target positioning data
		add.b	spinc_increment(a0),d1			; go to next entry (+4, or -4 if reversed)
		cmp.b	spinc_count(a0),d1			; has new index exceeded group size?
		bcs.s	.getNextTarget				; if not, branch
		move.b	d1,d0					; backup for reversal check
		moveq	#0,d1					; reset corner index to 0 (not reversed)
		tst.b	d0					; is movement currently reversed?
		bpl.s	.getNextTarget				; if not, branch
		move.b	spinc_count(a0),d1			; reset corner entry to last entry (reversed)
		subq.b	#4,d1					; indeces are 0-based

	.getNextTarget:
		move.b	d1,spinc_posindex(a0)			; remember new index in target data

		movea.l	spinc_targetdata(a0),a1			; get address pointing to target positions for group
		move.w	(a1,d1.w),spinc_nextX(a0)		; retrieve next target X-position for platform
		move.w	2(a1,d1.w),spinc_nextY(a0)		; retrieve next target Y-position for platform

		tst.w	d1					; is platform at first corner?
		bne.s	.checkSpinning				; if not, branch
		move.b	#1,obAnim(a0)				; set "still" animation
	.checkSpinning:
		cmpi.w	#4*2,d1					; is platform at third corner?
		bne.s	.changeDir				; if not, branch
		move.b	#0,obAnim(a0)				; set "spinning" animation

	.changeDir:
		bsr.w	LCon_ChangeDir				; update platform's speeds for next target

	.updatePos:
		jmp	(SpeedToPos).l				; update platform's current position
; End of function SpinC_Platform_Update


; ===========================================================================
; We need to include animations from here to keep the corner data in this file...
		include	"_anim/SBZ Spin Platform Conveyor.asm"


; ===========================================================================
; Conveyor belt corner target coordinate definitions.
; Each group corresponds to the lower nybble of the given subtype.
; Format:
; 	dc.w number of entries, times 4
; 	dc.w base X position (used for out_of_range check)
; 	dc.w entries...
; Entries consist of a target X position and target Y position.

SpinC_Data:	dc.w .group0-SpinC_Data
		dc.w .group1-SpinC_Data
		dc.w .group2-SpinC_Data
		dc.w .group3-SpinC_Data
		dc.w .group4-SpinC_Data
		dc.w .group5-SpinC_Data

.group0:
		.baseX_0: = $E80
		.baseY_0: = $358
		dc.w 4*4
		dc.w .baseX_0
		dc.w .baseX_0-$6C, .baseY_0+$18
		dc.w .baseX_0+$6F, .baseY_0-$56
		dc.w .baseX_0+$6F, .baseY_0-$18
		dc.w .baseX_0-$6C, .baseY_0+$56

.group1:
		.baseX_1: = $F80
		.baseY_1: = $2C8
		dc.w 4*4
		dc.w .baseX_1
		dc.w .baseX_1-$6C, .baseY_1+$18
		dc.w .baseX_1+$6F, .baseY_1-$56
		dc.w .baseX_1+$6F, .baseY_1-$18
		dc.w .baseX_1-$6C, .baseY_1+$56

.group2:
		.baseX_2: = $1080
		.baseY_2: = $228
		dc.w 4*4
		dc.w .baseX_2
		dc.w .baseX_2-$6C, .baseY_2+$48
		dc.w .baseX_2+$6F, .baseY_2-$26
		dc.w .baseX_2+$6F, .baseY_2+$18
		dc.w .baseX_2-$6C, .baseY_2+$86

.group3:
		.baseX_3: = $F80
		.baseY_3: = $558
		dc.w 4*4
		dc.w .baseX_3
		dc.w .baseX_3-$6C, .baseY_3+$18
		dc.w .baseX_3+$6F, .baseY_3-$56
		dc.w .baseX_3+$6F, .baseY_3-$18
		dc.w .baseX_3-$6C, .baseY_3+$56

.group4:
		.baseX_4: = $1B80
		.baseY_4: = $658
		dc.w 4*4
		dc.w .baseX_4
		dc.w .baseX_4-$6C, .baseY_4+$18
		dc.w .baseX_4+$6F, .baseY_4-$56
		dc.w .baseX_4+$6F, .baseY_4-$18
		dc.w .baseX_4-$6C, .baseY_4+$56

.group5:
		.baseX_5: = $1C80
		.baseY_5: = $5C8
		dc.w 4*4
		dc.w .baseX_5
		dc.w .baseX_5-$6C, .baseY_5+$18
		dc.w .baseX_5+$6F, .baseY_5-$56
		dc.w .baseX_5+$6F, .baseY_5-$18
		dc.w .baseX_5-$6C, .baseY_5+$56
