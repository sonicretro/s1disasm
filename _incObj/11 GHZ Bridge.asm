; ===========================================================================
; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge (the main object, for the stumps refer to Object 1C)
; ---------------------------------------------------------------------------

Bridge:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bri_Index(pc,d0.w),d1
		jmp	Bri_Index(pc,d1.w)
; ===========================================================================
Bri_Index:	dc.w Bri_Main-Bri_Index		; 0
		dc.w Bri_Action-Bri_Index	; 2
		dc.w Bri_StoodOn-Bri_Index	; 4
		dc.w Bri_Delete-Bri_Index	; 6
		dc.w Bri_Delete-Bri_Index	; 8
		dc.w Bri_ChildLog-Bri_Index	; A

bridge_children:	equ obSubtype		; number of log objects, initially retrieved from subtype ($28)
bridge_children_ram:	equ bridge_children+1	; RAM indeces to log objects ($29-$39, usually read together with bridge_children)
bridge_origY:		equ objoff_3C		; initial Y-position
bridge_nudge:		equ objoff_3E		; general nudge Y-offset while Sonic is on bridge
bridge_currentlog:	equ objoff_3F		; 0-based index of log Sonic is currently standing on
; ===========================================================================

Bri_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Bri_Action
		move.l	#Map_Bri,obMap(a0)			; set mappings
		move.w	#ArtTile_GHZ_Bridge|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
	if FixBugs
		move.b	#16/2,obActWid(a0)			; set sprite display width (one log)
	else
		; This sprite display width is way too large, causing the bridge to potentially screen-wrap.
		; It's likely that this was forgotten when the bridge was turned into indivudal 16px log objects.
		move.b	#256/2,obActWid(a0)			; set sprite display width (very large)
	endif

		move.w	obY(a0),d2				; copy Y-position from parent
		move.w	obX(a0),d3				; get center X-position of bridge
		_move.b	obID(a0),d4				; copy parent object ID to children
		lea	bridge_children(a0),a2			; load child object index array (= obSubtype)
		moveq	#0,d1					; clear d1
		move.b	(a2),d1					; get subtype for bridge
		move.b	#0,(a2)+				; clear subtype, and initialize number of spawned children to 0
		move.w	d1,d0					; copy bridge log count to d0
		lsr.w	#1,d0					; divide by 2 (half-size)
		lsl.w	#4,d0					; multiply by $10 (16px per log)
		sub.w	d0,d3					; d3 = X-position of leftmost log
		subq.b	#2,d1					; -1 for dbf, -1 for parent log
		bcs.s	Bri_Action				; branch on underflow (bridge only has only 1 log)

.loopBuildBridge:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj				; find next free object RAM slot
	else
		bsr.w	FindFreeObj				; find any free object RAM slot
	endif
		bne.s	Bri_Action				; if object RAM is full, abort
		addq.b	#1,bridge_children(a0)			; increment number of loaded child objects

		cmp.w	obX(a0),d3				; is current X-position matching parent/middle log's initial X-position?
		bne.s	.setupChild				; if not, branch
		addi.w	#16,d3					; make next child horizontally skip over parent
		move.w	d2,obY(a0)				; set parent Y-position (redundant)
		move.w	d2,bridge_origY(a0)			; remember initial Y-position
		move.w	a0,d5					; get parent address
		subi.w	#v_objspace&$FFFF,d5			; make address 0-based
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; d5 = index of parent in object RAM
		move.b	d5,(a2)+				; store parent RAM index as first entry in bridge_children
		addq.b	#1,bridge_children(a0)			; increment number of loaded objects to account for parent

	.setupChild:
		move.w	a1,d5					; get child address
		subi.w	#v_objspace&$FFFF,d5			; make child address 0-based
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; d5 = index of child in object RAM
		move.b	d5,(a2)+				; store new child index at the end of bridge_children

		move.b	#$A,obRoutine(a1)			; set child log to Bri_ChildLog (display only)
		_move.b	d4,obID(a1)				; copy object ID from parent
		move.w	d2,obY(a1)				; copy Y-position from parent
		move.w	d2,bridge_origY(a1)			; remember initial Y-position
		move.w	d3,obX(a1)				; write current X-position set in d3
		move.l	#Map_Bri,obMap(a1)			; set mappings
		move.w	#ArtTile_GHZ_Bridge|Tile_Pal3,obGfx(a1)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#3,obPriority(a1)			; set sprite priority
		move.b	#16/2,obActWid(a1)			; set sprite display width for individual log
		addi.w	#16,d3					; position next log 16px further to the right

		dbf	d1,.loopBuildBridge			; repeat for length of bridge
; ---------------------------------------------------------------------------

Bri_Action:	; Routine 2
		bsr.s	Bri_CheckOnBridge			; allow stepping on bridge (sets obRoutine = 4 (Bri_StoodOn) on enter)

		tst.b	bridge_nudge(a0)			; has bridge nudge gone back to 0?
		beq.s	.display				; if yes, branch
		subq.b	#4,bridge_nudge(a0)			; reduce nudging while Sonic isn't on bridge
		bsr.w	Bri_Bend				; update bridge bend for nudge

.display:
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display main bridge object
	endif
		bra.w	Bri_ChkDel				; delete main bridge object and all child logs if out of range

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if Sonic is on bridge platform
; ---------------------------------------------------------------------------

; Bri_Solid:
Bri_CheckOnBridge:
		moveq	#0,d1					; clear d1
		move.b	bridge_children(a0),d1			; get number of logs in bridge
		lsl.w	#3,d1					; multiply by 8
		move.w	d1,d2					; copy for right-side check
		addq.w	#8,d1					; d1 = left edge of bridge
		add.w	d2,d2					; d2 = right edge of bridge
		lea	(v_player).w,a1				; load Sonic player object
		tst.w	obVelY(a1)				; is Sonic moving upwards?
		bmi.w	Plat_Exit				; if yes, ignore bridge interaction

		move.w	obX(a1),d0				; get Sonic's current X-position
		sub.w	obX(a0),d0				; d0 = Sonic's distance from center of bridge
		add.w	d1,d0					; add left edge of bridge
		bmi.w	Plat_Exit				; branch if Sonic is left of the bridge
		cmp.w	d2,d0					; is Sonic within right edge of the bridge?
		bhs.w	Plat_Exit				; if not, branch

		bra.s	Plat_NoXCheck				; continue with regular platform check, assume height is 8px
; End of function Bri_CheckOnBridge

; ===========================================================================

	; Allow Sonic stepping on platforms. This is sandwiched in here,
	; likely for being the first platform object created for the game.
	include	"_incObj/sub PlatformObject & SlopeObject.asm"

; ===========================================================================

; Bri_Platform:
Bri_StoodOn:	; Routine 4
		bsr.s	Bri_WalkOff				; allow exiting bridge (sets obRoutine = 2 (Bri_Action) on exit)

	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display main bridge object
	endif
		bra.w	Bri_ChkDel				; delete main bridge object and all child logs if out of range

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk off a bridge
; ---------------------------------------------------------------------------

Bri_WalkOff:
		moveq	#0,d1					; clear d1
		move.b	bridge_children(a0),d1			; get number of logs in bridge
		lsl.w	#3,d1					; multiply by 8
		move.w	d1,d2					; d2 = half-width for right-side check
		addq.w	#8,d1					; d1 = half-width for left-side check
		bsr.s	ExitPlatform2				; allow Sonic exiting the bridge
		bcc.s	.return					; has Sonic exited bridge? if yes, branch

		lsr.w	#4,d0					; divide Sonic's distance from left edge by $10 (i.e. 16px per log)
		move.b	d0,bridge_currentlog(a0)		; store index of log Sonic is currently standing on

		move.b	bridge_nudge(a0),d0			; get current bridge nudge value (0-$40)
		cmpi.b	#$40,d0					; has bridge fully nudged down?
		beq.s	.bridgeBehavior				; if yes, don't depress it further
		addq.b	#4,bridge_nudge(a0)			; nudge bridge down as Sonic stands on it

	.bridgeBehavior:
		bsr.w	Bri_Bend				; update bridge bend for nudge
		bsr.w	Bri_MoveSonic				; vertically align Sonic with bridge bend

	.return:
		rts						; return
; End of function Bri_WalkOff
; ===========================================================================

	; Allow Sonic exiting platforms. This is sandwiched in here,
	; likely for being the first platform object created.
	include	"_incObj/sub ExitPlatform.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to vertically align Sonic with log he is currently standing on
; ---------------------------------------------------------------------------

Bri_MoveSonic:
		moveq	#0,d0					; clear d0
		move.b	bridge_currentlog(a0),d0		; get index of log Sonic is currently standing on
		move.b	bridge_children_ram(a0,d0.w),d0		; find RAM index of that log
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM offset
		movea.l	d0,a2					; a1 = full RAM address to log Sonic is standing on

		lea	(v_player).w,a1				; load Sonic player object
		move.w	obY(a2),d0				; get current Y-position of log Sonic is standing on
		subq.w	#8,d0					; align by 8px upwards
		moveq	#0,d1					; clear d1
		move.b	obHeight(a1),d1				; get Sonic's current collision height
		sub.w	d1,d0					; adjust upwards by Sonic's collision height
		move.w	d0,obY(a1)				; vertically align Sonic with currently stood-on log
		rts						; return
; End of function Bri_MoveSonic

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to bend the bridge by vertically aliging all log objects
; to the left and right of the one Sonic is currently standing on.
; ---------------------------------------------------------------------------

Bri_Bend:
		move.b	bridge_nudge(a0),d0			; get current bridge nudge value (0-$40)
		bsr.w	CalcSine				; convert it into a sine for smooth movement
		move.w	d0,d4					; backup sine result for later

		lea	(Bri_Data_Align).l,a4			; load values used to align logs to the left/right of the one being stood on
		moveq	#0,d0					; clear d0
		move.b	bridge_children(a0),d0			; get bridge log count
		lsl.w	#4,d0					; multiply by $10 bytes per data row
		moveq	#0,d3					; clear d3
		move.b	bridge_currentlog(a0),d3		; get index of log Sonic is currently standing on
		move.w	d3,d2					; d2 = number of logs to the left of Sonic (dbf count)
		add.w	d0,d3					; d3 = index in Bri_Data_Y_Max for current log
		moveq	#0,d5					; clear d5
		lea	(Bri_Data_Y_Max).l,a5			; load max Y-bend distance array
		move.b	(a5,d3.w),d5				; d5 = max Y-bend distance based on current log
		andi.w	#$F,d3					; clear upper nybble in d3
		lsl.w	#4,d3					; multiply by $10 bytes per data row
		lea	(a4,d3.w),a3				; a3 = start index in align data array for current log
		lea	bridge_children_ram(a0),a2		; a2 = RAM indeces to log objects

	.loopLeftLogs:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get next RAM index for log object
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM offset
		movea.l	d0,a1					; a1 = full RAM address to object
		moveq	#0,d0					; clear d0
		move.b	(a3)+,d0				; retrieve next byte value from align data array
		addq.w	#1,d0					; increment by 1 (max ROM value is $FF, probably to save space)
		mulu.w	d5,d0					; multiply align value by max Y-bend distance
		mulu.w	d4,d0					; multiply that by the sine of the current nudge distance
		swap	d0					; move integer result into lower word
		add.w	bridge_origY(a1),d0			; add initial Y-position
		move.w	d0,obY(a1)				; update Y-position for current log
		dbf	d2,.loopLeftLogs			; repeat for all logs left of the one Sonic is standing on
; ---------------------------------------------------------------------------

		moveq	#0,d0					; clear d0
		move.b	bridge_children(a0),d0			; get bridge log count
		moveq	#0,d3					; clear d3
		move.b	bridge_currentlog(a0),d3		; get index of log Sonic is currently standing on
		addq.b	#1,d3					; add 1 for total subtraction
		sub.b	d0,d3					; subtract total log count from current log index
		neg.b	d3					; make result positive again
		bmi.s	.return					; if result is still negative, abort
		move.w	d3,d2					; backup result
		lsl.w	#4,d3					; multiply by $10 bytes per data row
		lea	(a4,d3.w),a3				; load row in Bri_Data_Align
		adda.w	d2,a3					; advance to first right-side log inside data row 
		subq.w	#1,d2					; undo earlier +1 for dbf
		bcs.s	.return					; if underflowed, Sonic is already standing on the rightmost log

	.loopRightLogs:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get next RAM index for log object
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM offset
		movea.l	d0,a1					; a1 = full RAM address to object

		moveq	#0,d0					; clear d0
		move.b	-(a3),d0				; retrieve PREVIOUS byte value from align data array
		addq.w	#1,d0					; increment by 1 (max ROM value is $FF, probably to save space)
		mulu.w	d5,d0					; multiply align value by max Y-bend distance
		mulu.w	d4,d0					; multiply that by the sine of the current nudge distance
		swap	d0					; move integer result into lower word
		add.w	bridge_origY(a1),d0			; add initial Y-position
		move.w	d0,obY(a1)				; update Y-position for current log
		dbf	d2,.loopRightLogs			; repeat for all logs right of the one Sonic is standing on

	.return:
		rts						; return

; ---------------------------------------------------------------------------
; GHZ bridge-bending data
; (Defines how the bridge bends when Sonic walks across it)
; ---------------------------------------------------------------------------

_ = 0	; for readability of out-of-bounds bytes

; Obj11_BendData:
Bri_Data_Y_Max:	; Y-distance each log is moved down when stood on (only 12 logs are ever used in-game)
		dc.b _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 0 logs (invalid)
		dc.b 2,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 1 log
		dc.b 2,  2,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 2 logs
		dc.b 2,  4,  2,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 3 logs
		dc.b 2,  4,  4,  2,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 4 logs
		dc.b 2,  4,  6,  4,  2,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 5 logs
		dc.b 2,  4,  6,  6,  4,  2,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 6 logs
		dc.b 2,  4,  6,  8,  6,  4,  2,  _,  _,  _,  _,  _,  _,  _,  _,  _	; 7 logs
		dc.b 2,  4,  6,  8,  8,  6,  4,  2,  _,  _,  _,  _,  _,  _,  _,  _	; 8 logs
		dc.b 2,  4,  6,  8, 10,  8,  6,  4,  2,  _,  _,  _,  _,  _,  _,  _	; 9 logs
		dc.b 2,  4,  6,  8, 10, 10,  8,  6,  4,  2,  _,  _,  _,  _,  _,  _	; 10 logs
		dc.b 2,  4,  6,  8, 10, 12, 10,  8,  6,  4,  2,  _,  _,  _,  _,  _	; 11 logs
		dc.b 2,  4,  6,  8, 10, 12, 12, 10,  8,  6,  4,  2,  _,  _,  _,  _	; 12 logs
		dc.b 2,  4,  6,  8, 10, 12, 14, 12, 10,  8,  6,  4,  2,  _,  _,  _	; 13 logs
		dc.b 2,  4,  6,  8, 10, 12, 14, 14, 12, 10,  8,  6,  4,  2,  _,  _	; 14 logs
		dc.b 2,  4,  6,  8, 10, 12, 14, 16, 14, 12, 10,  8,  6,  4,  2,  _	; 15 logs
		dc.b 2,  4,  6,  8, 10, 12, 14, 16, 16, 14, 12, 10,  8,  6,  4,  2	; 16 logs
		even

; Obj11_BendData2:
Bri_Data_Align:	; Values used to align logs to the left & right of the one being stood on
		dc.b $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 0
		dc.b $B5, $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 1
		dc.b $7E, $DB, $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 2
		dc.b $61, $B5, $EC, $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 3
		dc.b $4A, $93, $CD, $F3, $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 4
		dc.b $3E, $7E, $B0, $DB, $F6, $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 5
		dc.b $38, $6D, $9D, $C5, $E4, $F8, $FF,   _,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 6
		dc.b $31, $61, $8E, $B5, $D4, $EC, $FB, $FF,   _,   _,   _,   _,   _,   _,   _,   _	; standing on log 7
		dc.b $2B, $56, $7E, $A2, $C1, $DB, $EE, $FB, $FF,   _,   _,   _,   _,   _,   _,   _	; standing on log 8
		dc.b $25, $4A, $73, $93, $B0, $CD, $E1, $F3, $FC, $FF,   _,   _,   _,   _,   _,   _	; standing on log 9
		dc.b $1F, $44, $67, $88, $A7, $BD, $D4, $E7, $F4, $FD, $FF,   _,   _,   _,   _,   _	; standing on log 10
		dc.b $1F, $3E, $5C, $7E, $98, $B0, $C9, $DB, $EA, $F6, $FD, $FF,   _,   _,   _,   _	; standing on log 11
		dc.b $19, $38, $56, $73, $8E, $A7, $BD, $D1, $E1, $EE, $F8, $FE, $FF,   _,   _,   _	; standing on log 12
		dc.b $19, $38, $50, $6D, $83, $9D, $B0, $C5, $D8, $E4, $F1, $F8, $FE, $FF,   _,   _	; standing on log 13
		dc.b $19, $31, $4A, $67, $7E, $93, $A7, $BD, $CD, $DB, $E7, $F3, $F9, $FE, $FF,   _	; standing on log 14
		dc.b $19, $31, $4A, $61, $78, $8E, $A2, $B5, $C5, $D4, $E1, $EC, $F4, $FB, $FE, $FF	; standing on log 15
		even

; End of function Bri_Bend

; ===========================================================================

Bri_ChkDel:
		out_of_range.w	.deleteBridge			; has bridge gone out of range? if yes, delete it with all child logs
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite				; display main bridge object
	else
		rts						; return
	endif
; ---------------------------------------------------------------------------

.deleteBridge:
		moveq	#0,d2					; clear d2
		lea	bridge_children(a0),a2			; load child log object index array (includes main parent log itself, too)
		move.b	(a2)+,d2				; get number of child objects
		subq.b	#1,d2					; decrement for dbf
		bcs.s	.deleteParentLog			; if it underflowed, bridge only contained 1 log (parent)

	.loopDeleteLogs:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get next RAM index for object
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM offset
		movea.l	d0,a1					; move result to a1 as input for DeleteChild
		cmp.w	a0,d0					; is current object the main parent log?
		beq.s	.next					; if yes, postpone deletion
		bsr.w	DeleteChild				; delete child log object
	.next:	dbf	d2,.loopDeleteLogs			; repeat for bridge length

	.deleteParentLog:
		bsr.w	DeleteObject				; finally, delete main parent log itself
		rts						; return
; ===========================================================================

Bri_Delete:	; Routine 6/8 (unused?)
		bsr.w	DeleteObject				; delete object
		rts						; return
; ===========================================================================

; Bri_Display:
Bri_ChildLog:	; Routine $A
		; Note: Child logs are updated and deleted through the parent object!
		bsr.w	DisplaySprite				; just display child log sprite
		rts						; return

; ===========================================================================

Map_Bri:	include	"_maps/Bridge.asm"
