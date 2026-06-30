; ===========================================================================
; ---------------------------------------------------------------------------
; Object 59 - platforms that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

Elevator:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Elev_Index(pc,d0.w),d1
		jsr	Elev_Index(pc,d1.w)

		out_of_range.w	DeleteObject,elev_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================
Elev_Index:	dc.w Elev_Main-Elev_Index
		dc.w Elev_Platform-Elev_Index
		dc.w Elev_StoodOn-Elev_Index
		dc.w Elev_Spawner-Elev_Index

elev_origY:		equ objoff_30		; original y-axis position
elev_origX:		equ objoff_32		; original x-axis position
elev_moveddistance:	equ objoff_34		; distance platform has moved from origin so far
elev_acceleration:	equ objoff_38		; current acceleration per frame while platform is moving
elev_slowingdown:	equ objoff_3A		; set when moving platform is slowing down again
elev_half_distance:	equ objoff_3C		; half of target distance to move platform (slows down after this point)
elev_spawner_delay:	equ objoff_3C		; spawner subtype only: delay between spawning platforms
elev_spawner_delaybase:	equ objoff_3E		; spawner subtype only: base value for elev_spawner_delay
; ===========================================================================

Elev_Var1:	; width, frame number
		dc.b	80/2, 0		; only one entry, though could theoretically support more

Elev_Var2:	; total distance to move divided by 8, action type for Elev_Types
		dc.b	 $80/8, 1	; 0
		dc.b	$100/8, 1	; 1
		dc.b	$1A0/8, 1	; 2
		dc.b	 $80/8, 3	; 3
		dc.b	$100/8, 3	; 4
		dc.b	$1A0/8, 3	; 5
		dc.b	 $A0/8, 1	; 6
		dc.b	$120/8, 1	; 7
		dc.b	$160/8, 1	; 8
		dc.b	 $A0/8, 3	; 9
		dc.b	$120/8, 3	; A
		dc.b	$160/8, 3	; B
		dc.b	$100/8, 5	; C
		dc.b	$100/8, 7	; D
		dc.b	$180/8, 9	; E (from spawner)
; ===========================================================================

Elev_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Elev_Platform

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get platform subtype
		bpl.s	.normalPlatform				; is this a spawner ($80 and above)? if not, branch

	.spawner:
		addq.b	#4,obRoutine(a0)			; set to Elev_Spawner routine
		andi.w	#$7F,d0					; clear bit 7 (spwaner flag)
		mulu.w	#6,d0					; multiply lower digit by 6
		move.w	d0,elev_spawner_delay(a0)		; set spawner interval (e.g. $xA * 6 = 1 second)
		move.w	d0,elev_spawner_delaybase(a0)		; ''
		addq.l	#4,sp					; don't return to "Elevator:" to prevent calling DisplaySprite
		rts						; keep spawner alive while invisible
; ---------------------------------------------------------------------------

	.normalPlatform:
		lsr.w	#3,d0					; read only upper subtype digit, multiplied by 2 for word-based indexing
		andi.w	#$1E,d0					; limit to sane values
		lea	Elev_Var1(pc,d0.w),a2			; load setup array (only has one entry, always the same)
		move.b	(a2)+,obActWid(a0)			; set sprite display width and platform solidity width
		move.b	(a2)+,obFrame(a0)			; set frame ID

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype again
		add.w	d0,d0					; multiply by 2 bytes per Elev_Var2 entry
		andi.w	#$1E,d0					; limit to sane values
		lea	Elev_Var2(pc,d0.w),a2			; load distance and action type array
		move.b	(a2)+,d0				; get half target distance
		lsl.w	#2,d0					; multiply target distance by 4
		move.w	d0,elev_half_distance(a0)		; set distance to move until slowing down again
		move.b	(a2)+,obSubtype(a0)			; set action type

		move.l	#Map_Elev,obMap(a0)			; set mappings
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile and palette line (part of level graphics)
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.w	obX(a0),elev_origX(a0)			; remember initial X-position
		move.w	obY(a0),elev_origY(a0)			; remember initial Y-position
; ---------------------------------------------------------------------------

Elev_Platform:	; Routine 2
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		jsr	(PlatformObject).l			; make object a platform (can set obRoutine to 4 = Elev_StoodOn)
		bra.w	Elev_Types				; execute platform action type
; ===========================================================================

; Elev_Action:
Elev_StoodOn:	; Routine 4
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		jsr	(ExitPlatform).l			; allow exiting platform (can set obRoutine to 2 = Elev_Platform on exit)

		move.w	obX(a0),-(sp)				; backup previous X-position before executing action types
		bsr.w	Elev_Types				; execute platform action type
		move.w	(sp)+,d2				; restore previous X-position for as MvSonicOnPtfm input

		_tst.b	obID(a0)				; has platform already deleted itself?
		beq.s	.deleted				; if yes, branch
		jmp	(MvSonicOnPtfm2).l			; move Sonic with platform as it moves
; ---------------------------------------------------------------------------

.deleted:
	if FixBugs
		; Avoid display-and-delete and double-delete bugs.
		addq.l	#4,sp					; don't return to "Elevator:" to prevent calling DisplaySprite
	endif
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle action type for platform (set from Elev_Var2)
; ---------------------------------------------------------------------------

Elev_Types:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get action type set from Elev_Var2
		andi.w	#$F,d0					; only look at lower digit
		add.w	d0,d0					; double for word-based indexing
		move.w	Elev_TypeIndex(pc,d0.w),d1		; find index in jump table
		jmp	Elev_TypeIndex(pc,d1.w)			; execute action behavior for platform type
; ===========================================================================
Elev_TypeIndex:	dc.w Elev_Stationary-Elev_TypeIndex		; 0
		dc.w Elev_NextOnTouch-Elev_TypeIndex		; 1
		dc.w Elev_Rising-Elev_TypeIndex			; 2
		dc.w Elev_NextOnTouch-Elev_TypeIndex		; 3
		dc.w Elev_Descending-Elev_TypeIndex		; 4
		dc.w Elev_NextOnTouch-Elev_TypeIndex		; 5
		dc.w Elev_RiseRight-Elev_TypeIndex		; 6
		dc.w Elev_NextOnTouch-Elev_TypeIndex		; 7
		dc.w Elev_DescendLeft-Elev_TypeIndex		; 8
		dc.w Elev_FromSpawner-Elev_TypeIndex		; 9
; ===========================================================================

; Type 0 - stationary
Elev_Stationary:
		rts						; doesn't move
; ===========================================================================

; Type 1/3/5/7 - go to next action type in list when Sonic stands on the platform
Elev_NextOnTouch:
		cmpi.b	#4,obRoutine(a0)			; check if Sonic is standing on the object
		bne.s	.return					; if not, branch
		addq.b	#1,obSubtype(a0)			; if yes, go to next type in list

	.return:
		rts						; return
; ===========================================================================

; Type 2 (from type 1) - rising until target distance is reached
Elev_Rising:
		bsr.w	Elev_Move				; advance current platform distance

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		neg.w	d0					; make platform rise up
		add.w	elev_origY(a0),d0			; add negative distance to initial Y-position
		move.w	d0,obY(a0)				; update Y-position to make platform rise
		rts						; return
; ===========================================================================

; Type 4 (from type 3) - descending until target distance is reached
Elev_Descending:
		bsr.w	Elev_Move				; advance current platform distance

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		add.w	elev_origY(a0),d0			; add positive distance to initial Y-position
		move.w	d0,obY(a0)				; update Y-position to make platform descend
		rts						; return
; ===========================================================================

; Type 6 (from type 5) - rise at half speed, move right at full speed
Elev_RiseRight:
		bsr.w	Elev_Move				; advance current platform distance

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		asr.w	#1,d0					; divide rising distance in half
		neg.w	d0					; make platform rise up
		add.w	elev_origY(a0),d0			; add halved negative distance to initial Y-position
		move.w	d0,obY(a0)				; update Y-position to make platform rise (slowly)

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		add.w	elev_origX(a0),d0			; add positive distance to initial X-position
		move.w	d0,obX(a0)				; update X-position to make platform move right
		rts						; return
; ===========================================================================

; Type 8 (from type 7) - descend at half speed, move left at full speed
Elev_DescendLeft:
		bsr.w	Elev_Move				; advance current platform distance

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		asr.w	#1,d0					; divide descending distance in half
		add.w	elev_origY(a0),d0			; add halved positive distance to initial Y-position
		move.w	d0,obY(a0)				; update Y-position to make platform descend (slowly)

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		neg.w	d0					; move platform move to the left
		add.w	elev_origX(a0),d0			; add negative distance to initial X-position
		move.w	d0,obX(a0)				; update X-position to make platform move left
		rts						; return
; ===========================================================================

; Type 9 - rises and deletes itself when peak is reached (created from spawner)
Elev_FromSpawner:
		bsr.w	Elev_Move				; advance current platform distance

		move.w	elev_moveddistance(a0),d0		; get current distance from origin
		neg.w	d0					; make platform rise up
		add.w	elev_origY(a0),d0			; add negative distance to initial Y-position
		move.w	d0,obY(a0)				; update Y-position to make platform rise

		tst.b	obSubtype(a0)				; has platform reached final destination? (subtype set to 0 from Elev_Move)
		beq.w	.vanishPlatform				; if yes, delete platform
		rts						; otherwise, keep it alive
; ---------------------------------------------------------------------------

.vanishPlatform:
		btst	#3,obStatus(a0)				; was Sonic standing on platform as it reached peak?
		beq.s	.delete					; if not, branch
		bset	#1,obStatus(a1)				; set Sonic's in-air flag
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		move.b	#2,obRoutine(a1)			; force Sonic to Sonic_Control routine

	.delete:
		bra.w	DeleteObject				; delete platform

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to accelerate/decelerate platform again until target distance.
; The distance itself is generic and each platform handles it differently.
; ---------------------------------------------------------------------------

Elev_Move:
		move.w	elev_acceleration(a0),d0		; get current acceleration value
		tst.b	elev_slowingdown(a0)			; is platform set to slow down again?
		bne.s	.slowDown				; if yes, branch
		cmpi.w	#$800,d0				; has acceleration reached reached limit?
		bhs.s	.movePlatform				; if yes, don't speed it up further
		addi.w	#$10,d0					; increase acceleration
		bra.s	.movePlatform				; skip over slowing down logic
; ---------------------------------------------------------------------------

	.slowDown:
		tst.w	d0					; has acceleration gone down to 0 again?
		beq.s	.movePlatform				; if yes, branch
		subi.w	#$10,d0					; decrease acceleration

	.movePlatform:
		move.w	d0,elev_acceleration(a0)		; update stored acceleration
		ext.l	d0					; extend acceleration to longword
		asl.l	#8,d0					; shift acceleration up to 16.16 fixed
		add.l	elev_moveddistance(a0),d0		; add distance platform has already moved from origin
		move.l	d0,elev_moveddistance(a0)		; set new distance for platform

		swap	d0					; get only integer part
		move.w	elev_half_distance(a0),d2		; get half target distance for platform
		cmp.w	d2,d0					; has platform reached target distance?
		bls.s	.checkFinalDestination			; if not, branch
		move.b	#1,elev_slowingdown(a0)			; set flag to slow down platform again

	.checkFinalDestination:
		add.w	d2,d2					; double half target distance to full distance
		cmp.w	d2,d0					; has platform reached its final destination?
		bne.s	.return					; if not, branch
		clr.b	obSubtype(a0)				; set platform to type 0 (stationary)

	.return:
		rts						; return
; End of function Elev_Move

; ===========================================================================

; Elev_MakeMulti:
Elev_Spawner:	; Routine 6
		subq.w	#1,elev_spawner_delay(a0)		; decrement delay until next platform spawn
		bne.s	.chkdel					; if time remains, branch
		move.w	elev_spawner_delaybase(a0),elev_spawner_delay(a0) ; reset spawn delay

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.chkdel					; if object RAM is full, branch
		_move.b	#id_Elevator,obID(a1)			; spawn another platform object
		move.w	obX(a0),obX(a1)				; copy spawner's X-position
		move.w	obY(a0),obY(a1)				; copy spawner's Y-position
		move.b	#$E,obSubtype(a1)			; set to entry $E in Elev_Var2 (which sets action type 9)

	.chkdel:
		addq.l	#4,sp					; don't return to "Elevator:" to prevent calling DisplaySprite
		out_of_range.w	DeleteObject			; has spawner gone out of range? if yes, delete it
		rts						; keep spawner alive while invisible

; ===========================================================================

Map_Elev:	include	"_maps/SLZ Elevators.asm"
