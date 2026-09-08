; ===========================================================================
; ---------------------------------------------------------------------------
; When Debug Mode is currently in use (entered from Sonic objects)
; ---------------------------------------------------------------------------
debug_movedelay:  equ 12	; frames to wait when holding down D-Pad before starting to move
debug_startspeed: equ 15	; initial movement speed when first holding D-Pad
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0					; clear d0
		move.b	(v_debuguse).w,d0			; get debug mode state (0 if just launched, 2 if already active)
		move.w	Debug_Index(pc,d0.w),d1			; find relevant section in offset table
		jmp	Debug_Index(pc,d1.w)			; jump to that label
; ===========================================================================
Debug_Index:	dc.w Debug_Init-Debug_Index			; 0 - init
		dc.w Debug_Action-Debug_Index			; 2 - main mode
; ===========================================================================

; Debug_Main:
Debug_Init:	; Routine 0
		addq.b	#2,(v_debuguse).w			; set to Debug_Action

		move.w	(v_limittop2).w,(v_limittopdb).w	; buffer level x-boundary
		move.w	(v_limitbtm1).w,(v_limitbtmdb).w	; buffer level y-boundary
	if FixBugs
		; Do not affect camera and position in Special Stages
		cmpi.b	#id_Special,(v_gamemode).w		; are we in a Special Stage?
		beq.s	.wrapDone				; if yes, skip wrapping
	endif
		move.w	#0,(v_limittop2).w			; unlock top screen boundary
		move.w	#$800-224,(v_limitbtm1).w		; unlock bottom level boundary, minus screen height

		; Do vertical wrapping in LZ3 and SBZ2
		andi.w	#$7FF,(v_player+obY).w			; wrap Sonic's Y-position
		andi.w	#$7FF,(v_screenposy).w			; wrap screen Y-position
		andi.w	#$3FF,(v_bgscreenposy).w		; wrap background Y-position
	.wrapDone:

		move.b	#fr_Null,obFrame(a0)			; set Sonic's frame to null (blank)
		move.b	#id_Walk,obAnim(a0)			; set Sonic's animation to walk (0)

	if FixBugs
		; Fix various issues when entering debug mode by resetting
		; Sonic to his normal state and clearing a handful of flags.
		bset	#1,obStatus(a0)				; force airborne state to speed up vertical camera
		move.b	#2,obRoutine(a0)			; force to Sonic_Control routine
		move.w	#$60,(v_lookshift).w			; reset up/down camera shift

		moveq	#0,d0					; set to clear values
		move.b	d0,(f_playerctrl).w			; clear control override flag
		move.b	d0,(f_nobgscroll).w			; clear deform stop flag
		move.w	d0,obVelX(a0)				; clear X-velocity
		move.w	d0,obVelY(a0)				; clear Y-velocity
		move.w	d0,obInertia(a0)			; clear ground speed
		move.b	d0,obAngle(a0)				; clear angle
		move.b	d0,jumping(a0)				; clear jump flag
		move.b	d0,sticktoconvex(a0)			; clear SBZ gear flag

		; Debug Mode makes no attempt to check if Sonic was standing on any
		; object before entering it, causing behavior such as being stuck to
		; platforms or warped back down to an object previously stood on.
		btst	#3,obStatus(a0)				; is Sonic standing on an object?
		beq.s	.notOnObject				; if not, branch
		bclr	#3,obStatus(a0)				; clear Sonic's standing flag
		move.b	standonobject(a0),d0			; get object ID
		clr.b	standonobject(a0)			; clear object ID
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM location
		movea.l	d0,a2					; a2 = address of stood-on object
		bclr	#3,obStatus(a2)				; clear object's standing flag
		clr.b	obSolid(a2)				; clear object's solid state
	.notOnObject:

		; Exit underwater state if applicable
		bclr	#6,obStatus(a0)				; clear underwater status
		beq.s	.notUnderwater				; if Sonic wasn't underwater, branch
		jsr	(ResumeMusic).l				; resume music after a countdown
		move.w  #son_maxspeed,(v_sonspeedmax).w		; restore Sonic's speed
		move.w  #son_acceleration,(v_sonspeedacc).w	; restore Sonic's acceleration
		move.w  #son_deceleration,(v_sonspeeddec).w	; restore Sonic's deceleration
	.notUnderwater:
	endif

		cmpi.b	#id_Special,(v_gamemode).w		; is game mode Special Stage?
		bne.s	.isLevel				; if not, branch
		move.w	#0,(v_ssrotate).w			; stop Special Stage rotating
		move.w	#0,(v_ssangle).w			; make Special Stage "upright"
		moveq	#id_EndZ,d0				; use 6th debug item list (which is actually the ending sequence)
		bra.s	.loadDebugList				; ignore actual Zone ID
; ===========================================================================

	.isLevel:
		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; get current Zone ID
	.loadDebugList:
		lea	(DebugList).l,a2			; load debug item index list
		add.w	d0,d0					; double for word-based indexing
		adda.w	(a2,d0.w),a2				; go to debug item list for Zone ID
		move.w	(a2)+,d6				; load number of entries in debug item list
		cmp.b	(v_debugitem).w,d6			; is currently selected item index past end of list?
		bhi.s	.finishDebugSetup			; if not, branch
		move.b	#0,(v_debugitem).w			; go back to start of list

	.finishDebugSetup:
		bsr.w	Debug_ShowItem				; load selected item graphics when entering debug mode
		move.b	#debug_movedelay,(v_debugspeedtimer).w	; set initial move delay (12 frames)
	if FixBugs
		; If the D-Pad is held while entering debug mode, the initial move speed
		; is incredibly slow. The cause is this value getting set to just a 1,
		; instead of the normal 15 when no D-Pad button is pressed in Debug_Control.
		move.b	#debug_startspeed,(v_debugspeed).w	; set initial move speed (normal)
	else
		move.b	#1,(v_debugspeed).w			; set initial move speed (just 1)
	endif
; ---------------------------------------------------------------------------

Debug_Action:	; Routine 2
		moveq	#id_EndZ,d0				; use 6th debug item list (which is actually the ending sequence)
		cmpi.b	#id_Special,(v_gamemode).w		; are we in a Special Stage?
		beq.s	.loadDebugList				; if yes, branch

		moveq	#0,d0					; clear d0
		move.b	(v_zone).w,d0				; use Zone ID to select debug list
	.loadDebugList:
		lea	(DebugList).l,a2			; load debug item index list
		add.w	d0,d0					; double for word-based indexing
		adda.w	(a2,d0.w),a2				; go to debug item list for Zone ID
		move.w	(a2)+,d6				; load number of entries in debug item list

		bsr.w	Debug_Control				; allow movement and object spawning, and update graphics
		jmp	(DisplaySprite).l			; display debug object
; End of function DebugMode


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to allow movement in debug mode, spawning objects,
; and updating displayed debug object sprite graphics.
; ---------------------------------------------------------------------------

Debug_Control:
		moveq	#0,d4					; clear d4 for button input buffer
		move.w	#1,d1					; set d1 to 1 (useless, cleared again below)

		move.b	(v_jpadpress1).w,d4			; get buttons that were pressed this frame
		andi.w	#btnDir,d4				; is up/down/left/right pressed?
		bne.s	Debug_Move_GetDirections		; if yes, branch (immediately move a bit)

		move.b	(v_jpadhold1).w,d0			; get buttons that were already held down
		andi.w	#btnDir,d0				; is up/down/left/right held?
		bne.s	Debug_Move_Delay			; if yes, branch

		; No D-Pad buttons were pressed...
		move.b	#debug_movedelay,(v_debugspeedtimer).w	; reset movement delay
		move.b	#debug_startspeed,(v_debugspeed).w	; reset initial move speed
		bra.w	Debug_ChgItem				; skip movement

; ---------------------------------------------------------------------------
; Allow freely moving around in debug mode
; ---------------------------------------------------------------------------

Debug_Move_Delay:
		subq.b	#1,(v_debugspeedtimer).w		; decrement delay for held buttons before moving
		bne.s	Debug_Move				; if time remains, branch
		move.b	#1,(v_debugspeedtimer).w		; keep delay to 1 so that the above branch keeps triggering
		addq.b	#1,(v_debugspeed).w			; accelerate speed for held D-Pad
		bne.s	Debug_Move_GetDirections		; if speed didn't reach max yet, branch
		move.b	#$FF,(v_debugspeed).w			; keep speed fixed at max until D-Pad is released again

Debug_Move_GetDirections:
		move.b	(v_jpadhold1).w,d4			; get held buttons for the directional checks

Debug_Move:
		moveq	#0,d1					; clear d1
		move.b	(v_debugspeed).w,d1			; get current debug move speed
		addq.w	#1,d1					; add one unit to base speed (at max speed, $FF+1=$100)
		swap	d1					; move delta to upper word (calculations use longwords for subpixels)
		asr.l	#4,d1					; divide speed by 16 to reasonably slow it down (upper nybble is pixels per frame)

		move.l	obY(a0),d2				; d2 = current debug object Y-position
		move.l	obX(a0),d3				; d3 = current debug object X-position

	.chkUp:
		btst	#bitUp,d4				; is up being held?
		beq.s	.chkDown				; if not, branch
		sub.l	d1,d2					; move up
	if FixBugs
		; These boundary checks only consider absolute values, which allows going offscreen.
		; From Sonic 2 onward, the active level boundaries are instead used for the checks.
		; Left/right bounds technically lack those fixes, they were added here for consistency.
		moveq	#0,d0					; clear d0
		move.w	(v_limittop2).w,d0			; get current top level boundary
		swap	d0					; move to upper word for long comparison
		cmp.l	d0,d2					; would new Y-position exceed top level boundary?
		bge.s	.chkDown				; if not, branch
		move.l	d0,d2					; keep Y-position within top level bound
	else
		bcc.s	.chkDown				; would new Y-position underflow? if not, branch
		moveq	#0,d2					; keep Y-position within absolute top bound
	endif

	.chkDown:
		btst	#bitDn,d4				; is down being held?
		beq.s	.chkLeft				; if not, branch
		add.l	d1,d2					; move down
	if FixBugs
		; See above.
		moveq	#0,d0					; clear d0
		move.w	(v_limitbtm2).w,d0			; get current bottom level boundary
		addi.w	#224-1,d0				; add screen height
		swap	d0					; move to upper word for long comparison
		cmp.l	d0,d2					; would new Y-position exceed bottom level boundary?
		blt.s	.chkLeft				; if not, branch
		move.l	d0,d2					; keep Y-position within bottom level bound
	else
		cmpi.l	#$7FF<<16,d2				; would new Y-position exceed maximum bottom?
		blo.s	.chkLeft				; if not, branch
		move.l	#$7FF<<16,d2				; keep Y-position within bottom bound
	endif

	.chkLeft:
		btst	#bitL,d4				; is left being held?
		beq.s	.chkRight				; if not, branch
		sub.l	d1,d3					; move left
	if FixBugs
		; See above.
		moveq	#0,d0					; clear d0
		move.w	(v_limitleft2).w,d0			; get current left level boundary
		swap	d0					; move to upper word for long comparison
		cmp.l	d0,d3					; would new X-position exceed left level boundary?
		bge.s	.chkRight				; if not, branch
		move.l	d0,d3					; keep X-position within left level bound
	else
		bcc.s	.chkRight				; would new X-position underflow? if not, branch
		moveq	#0,d3					; keep X-position within absolute left bound
	endif

	.chkRight:
		btst	#bitR,d4				; is right being held?
		beq.s	.setNewDebugPosition			; if not, branch
		add.l	d1,d3					; move right
	if FixBugs
		; See above. Also, right side lacked any boundary check to begin with.
		moveq	#0,d0					; clear d0
		move.w	(v_limitright2),d0			; get current right level boundary
		addi.w	#320-1,d0				; add screen width
		swap	d0					; move to upper word for long comparison
		cmp.l	d0,d3					; would new X-position exceed right level boundary?
		blt.s	.setNewDebugPosition			; if not, branch
		move.l	d0,d3					; keep X-position within right level bound
	endif

.setNewDebugPosition:
		move.l	d2,obY(a0)				; set new Y-position
		move.l	d3,obX(a0)				; set new X-position
		; continue to Debug_ChgItem...

; ---------------------------------------------------------------------------
; Allow spawning debug objects and cycling through item list
; ---------------------------------------------------------------------------

Debug_ChgItem:
		; Cycle back one item in list when holding A and pressing C
		btst	#bitA,(v_jpadhold1).w			; is button A held?
		beq.s	.checkCreateItem			; if not, branch
		btst	#bitC,(v_jpadpress1).w			; is button C pressed?
		beq.s	.checkNextItem				; if not, branch
		subq.b	#1,(v_debugitem).w			; go back 1 item
		bcc.s	.display				; if still a valid index, branch
		add.b	d6,(v_debugitem).w			; on underflow, set to last entry in list
		bra.s	.display				; do not spawn an item from this C press
; ===========================================================================

.checkNextItem:
		; Cycle forwards one item in list when pressing A
		btst	#bitA,(v_jpadpress1).w			; is button A pressed?
		beq.s	.checkCreateItem			; if not, branch
		addq.b	#1,(v_debugitem).w			; go forwards 1 item
		cmp.b	(v_debugitem).w,d6			; is newly selected item index past end of list?
		bhi.s	.display				; if not, branch
		move.b	#0,(v_debugitem).w			; go back to start of list

	.display:
		bra.w	Debug_ShowItem				; update displayed sprite for debug object
; ===========================================================================

.checkCreateItem:
		; Spawn new object when pressing C
		btst	#bitC,(v_jpadpress1).w			; is button C pressed?
		beq.s	Debug_ExitDebugMode			; if not, branch

		jsr	(FindFreeObj).l				; find a free object slot
		bne.s	Debug_ExitDebugMode			; if none are free, branch
	if FixBugs
		; Fix not being able to place more rings and such after collecting one
		clr.b	(v_objstate+2).w			; free up object state for spawned object (target for obRespawnNo=0)
	endif
		move.w	obX(a0),obX(a1)				; set new object's X-position
		move.w	obY(a0),obY(a1)				; set new object's Y-position
		_move.b	obMap(a0),obID(a1)			; create object (ID is stored in list with mappings as map+(object<<24))
		move.b	obRender(a0),obRender(a1)		; set new object's render flags
		move.b	obRender(a0),obStatus(a1)		; set new object's status flags
		andi.b	#$7F,obStatus(a1)			; make sure bit 7 in status flag is clear

		moveq	#0,d0					; clear d0
		move.b	(v_debugitem).w,d0			; get index of currently selected debug item
		lsl.w	#3,d0					; each entry is 8 bytes
		move.b	4(a2,d0.w),obSubtype(a1)		; load subtype for object from debug list entry

		rts						; return

; ---------------------------------------------------------------------------
; Allow exiting debug mode to revert back to normal Sonic state
; ---------------------------------------------------------------------------

Debug_ExitDebugMode:
		btst	#bitB,(v_jpadpress1).w			; is button B pressed?
		beq.s	.return					; if not, stay in debug mode

		moveq	#0,d0					; prepare 0 value
		move.w	d0,(v_debuguse).w			; deactivate debug mode
		move.l	#Map_Sonic,(v_player+obMap).w		; reset Sonic's mappings
		move.w	#ArtTile_Sonic,(v_player+obGfx).w	; reset Sonic's art tile
		move.b	d0,(v_player+obAnim).w			; reset Sonic's animation to walking
		move.w	d0,obSubpixelX(a0)			; clear Sonic's X subpixel portion
		move.w	d0,obSubpixelY(a0)			; clear Sonic's Y subpixel portion

		move.w	(v_limittopdb).w,(v_limittop2).w	; restore top level boundary
		move.w	(v_limitbtmdb).w,(v_limitbtm1).w	; restore bottom level boundary

		cmpi.b	#id_Special,(v_gamemode).w		; are you in the Special Stage?
		bne.s	.return					; if not, branch
		clr.w	(v_ssangle).w				; make Special Stage "upright"
		move.w	#ss_rotatespeed,(v_ssrotate).w		; restart maze rotation
		move.l	#Map_Sonic,(v_player+obMap).w		; reset Sonic's mappings (redundant, already done)
		move.w	#ArtTile_Sonic,(v_player+obGfx).w	; reset Sonic's art tile (redundant, already done)
		move.b	#id_Roll,(v_player+obAnim).w		; reset Sonic's animation to rolling
		bset	#2,(v_player+obStatus).w		; force rolling state
		bset	#1,(v_player+obStatus).w		; force in-air state

	.return:
		rts						; return
; End of function Debug_Control

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set mappings and graphics for displayed debug object.
; Each entry in DebugList is 8 bytes in the following format:
; 	0:   object ID
;	0-3: mappings address (upper byte is ignored for 24-bit addressing)
;	4:   subtype
;	5:   frame ID
;	6-7: VRAM settings
; ---------------------------------------------------------------------------

Debug_ShowItem:
		moveq	#0,d0					; clear d0
		move.b	(v_debugitem).w,d0			; get currently selected item in debug list
		lsl.w	#3,d0					; each entry is 8 bytes
		move.l	(a2,d0.w),obMap(a0)			; load mappings for displayed item
		move.w	6(a2,d0.w),obGfx(a0)			; load VRAM setting for displayed item
		move.b	5(a2,d0.w),obFrame(a0)			; load frame number for displayed item
		rts						; return
; End of function Debug_ShowItem


; ===========================================================================
; ---------------------------------------------------------------------------
; Debug mode item lists
; ---------------------------------------------------------------------------
DebugList:
		dc.w .GHZ-DebugList
		dc.w .LZ-DebugList
		dc.w .MZ-DebugList
		dc.w .SLZ-DebugList
		dc.w .SYZ-DebugList
		dc.w .SBZ-DebugList
		zonewarning DebugList,2
		dc.w .EndingSS-DebugList

dbug:		macro	map,object,subtype,frame,vram
		dc.l	map+(object<<24)
		dc.b	subtype,frame
		dc.w	vram
		endm

dbugheader:	macro	{INTLABEL}
__LABEL__:	label	*
		dc.w	((__LABEL___end)-(__LABEL__)-2)/8
		endm

; ---------------------------------------------------------------------------

.GHZ:		dbugheader
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Chop,	id_Chopper,		0,	0,	ArtTile_Chopper
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_Plat_GHZ,	id_BasicPlatform,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_PRock,	id_PurpleRock,		0,	0,	ArtTile_GHZ_Purple_Rock|Tile_Pal4
		dbug	Map_Moto,	id_MotoBug,		0,	0,	ArtTile_Moto_Bug
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Newt,	id_Newtron,		0,	0,	ArtTile_Newtron|Tile_Pal2
		dbug	Map_Edge,	id_EdgeWalls,		0,	0,	ArtTile_GHZ_Edge_Wall|Tile_Pal3
		dbug	Map_GBall,	id_Obj19,		0,	0,	ArtTile_GHZ_Giant_Ball|Tile_Pal3
		dbug	Map_Lamp,	id_Lamppost,		1,	0,	ArtTile_Lamppost
		dbug	Map_GRing,	id_GiantRing,		0,	0,	ArtTile_Giant_Ring|Tile_Pal2
		dbug	Map_Bonus,	id_HiddenBonus,		1,	1,	ArtTile_Hidden_Points|Tile_Prio
.GHZ_end:

; ---------------------------------------------------------------------------

.LZ:		dbugheader
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Jaws,	id_Jaws,		8,	0,	ArtTile_Jaws|Tile_Pal2
		dbug	Map_Burro,	id_Burrobot,		0,	2,	ArtTile_Burrobot|Tile_Prio
		dbug	Map_Harp,	id_Harpoon,		0,	0,	ArtTile_LZ_Harpoon
		dbug	Map_Harp,	id_Harpoon,		2,	3,	ArtTile_LZ_Harpoon
		dbug	Map_Push,	id_PushBlock,		0,	0,	ArtTile_LZ_Push_Block|Tile_Pal3
		dbug	Map_But,	id_Button,		0,	0,	ArtTile_Button_Main
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_MBlockLZ,	id_MovingBlock,		4,	0,	ArtTile_LZ_Moving_Block|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock,	1,	0,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock,	$13,	1,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock,	5,	0,	ArtTile_LZ_Blocks|Tile_Pal3
	    if FixBugs
		dbug	Map_Gar,	id_Gargoyle,		0,	0,	ArtTile_LZ_Gargoyle|Tile_Pal3
	    else
		; Incorrect VRAM address
		dbug	Map_Gar,	id_Gargoyle,		0,	0,	(ArtTile_LZ_UnusedFace-2)|Tile_Pal3
	    endif
		dbug	Map_LBlock,	id_LabyrinthBlock,	$27,	2,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock,	$30,	3,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LConv,	id_LabyrinthConvey,	$7F,	0,	ArtTile_LZ_Conveyor_Belt
		dbug	Map_Orb,	id_Orbinaut,		0,	0,	ArtTile_LZ_Orbinaut
		dbug	Map_Bub,	id_Bubble,		$84,	$13,	ArtTile_LZ_Bubbles|Tile_Prio
		dbug	Map_WFall,	id_Waterfall,		2,	2,	ArtTile_LZ_Splash|Tile_Pal3|Tile_Prio
		dbug	Map_WFall,	id_Waterfall,		9,	9,	ArtTile_LZ_Splash|Tile_Pal3|Tile_Prio
		dbug	Map_Pole,	id_Pole,		0,	0,	ArtTile_LZ_Pole|Tile_Pal3
		dbug	Map_Flap,	id_FlapDoor,		2,	0,	ArtTile_LZ_Flapping_Door|Tile_Pal3
		dbug	Map_Lamp,	id_Lamppost,		1,	0,	ArtTile_Lamppost
.LZ_end:

; ---------------------------------------------------------------------------

.MZ:		dbugheader
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Fire,	id_LavaMaker,		0,	0,	ArtTile_MZ_Fireball
		dbug	Map_Brick,	id_MarbleBrick,		0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Geyser,	id_GeyserMaker,		0,	0,	ArtTile_MZ_Lava|Tile_Pal4
		dbug	Map_LWall,	id_LavaWall,		0,	0,	ArtTile_MZ_Lava|Tile_Pal4
		dbug	Map_Push,	id_PushBlock,		0,	0,	ArtTile_MZ_Block|Tile_Pal3
		dbug	Map_Yad,	id_Yadrin,		0,	0,	ArtTile_Yadrin|Tile_Pal2
		dbug	Map_Smab,	id_SmashBlock,		0,	0,	ArtTile_MZ_Block|Tile_Pal3
	    if FixBugs
		dbug	Map_MBlock,	id_MovingBlock,		0,	0,	ArtTile_MZ_Block|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	ArtTile_MZ_Block|Tile_Pal3
	    else
		; Incorrect palette lines
		dbug	Map_MBlock,	id_MovingBlock,		0,	0,	ArtTile_MZ_Block
		dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	ArtTile_MZ_Block|Tile_Pal4
	    endif
		dbug	Map_LTag,	id_LavaTag,		0,	0,	ArtTile_Monitor|Tile_Prio
		dbug	Map_Bas,	id_Basaran,		0,	0,	ArtTile_Basaran
		dbug	Map_Cat,	id_Caterkiller,		0,	0,	ArtTile_MZ_SYZ_Caterkiller|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,		1,	0,	ArtTile_Lamppost
.MZ_end:

; ---------------------------------------------------------------------------

.SLZ:		dbugheader
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Elev,	id_Elevator,		0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor,	0,	2,	ArtTile_SLZ_Collapsing_Floor|Tile_Pal3
		dbug	Map_Plat_SLZ,	id_BasicPlatform,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Circ,	id_CirclingPlatform,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Stair,	id_Staircase,		0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Fan,	id_Fan,			0,	0,	ArtTile_SLZ_Fan|Tile_Pal3
		dbug	Map_Seesaw,	id_Seesaw,		0,	0,	ArtTile_SLZ_Seesaw
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Fire,	id_LavaMaker,		0,	0,	ArtTile_SLZ_Fireball
		dbug	Map_Scen,	id_Scenery,		0,	0,	ArtTile_SLZ_Fireball_Launcher|Tile_Pal3
		dbug	Map_Bomb,	id_Bomb,		0,	0,	ArtTile_Bomb
		dbug	Map_Orb,	id_Orbinaut,		0,	0,	ArtTile_SLZ_Orbinaut|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,		1,	0,	ArtTile_Lamppost
.SLZ_end:

; ---------------------------------------------------------------------------

.SYZ:		dbugheader
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Roll,	id_Roller,		0,	0,	ArtTile_Roller
		dbug	Map_Light,	id_SpinningLight,	0,	0,	ArtTile_Level
		dbug	Map_Bump,	id_Bumper,		0,	0,	ArtTile_SYZ_Bumper
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Yad,	id_Yadrin,		0,	0,	ArtTile_Yadrin|Tile_Pal2
		dbug	Map_Plat_SYZ,	id_BasicPlatform,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_FBlock,	id_FloatingBlock,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_But,	id_Button,		0,	0,	ArtTile_Button_Main
		dbug	Map_Cat,	id_Caterkiller,		0,	0,	ArtTile_MZ_SYZ_Caterkiller|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,		1,	0,	ArtTile_Lamppost
.SYZ_end:
; ---------------------------------------------------------------------------

.SBZ:		dbugheader
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Bomb,	id_Bomb,		0,	0,	ArtTile_Bomb
		dbug	Map_Orb,	id_Orbinaut,		0,	0,	ArtTile_SBZ_Orbinaut
		dbug	Map_Cat,	id_Caterkiller,		0,	0,	ArtTile_SBZ_Caterkiller|Tile_Pal2
		dbug	Map_BBall,	id_SwingingPlatform,	7,	2,	ArtTile_SBZ_Swing|Tile_Pal3
		dbug	Map_Disc,	id_RunningDisc,		$E0,	0,	ArtTile_SBZ_Disc|Tile_Pal3|Tile_Prio
		dbug	Map_MBlock,	id_MovingBlock,		$28,	2,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_But,	id_Button,		0,	0,	ArtTile_Button_Main
		dbug	Map_Trap,	id_SpinPlatform,	3,	0,	ArtTile_SBZ_Trap_Door|Tile_Pal3
		dbug	Map_Spin,	id_SpinPlatform,	$83,	0,	ArtTile_SBZ_Spinning_Platform
		dbug	Map_Saw,	id_Saws,		2,	0,	ArtTile_SBZ_Saw|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	ArtTile_SBZ_Collapsing_Floor|Tile_Pal3
		dbug	Map_MBlock,	id_MovingBlock,		$39,	3,	ArtTile_SBZ_Moving_Block_Long|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,		0,	0,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_ADoor,	id_AutoDoor,		0,	0,	ArtTile_SBZ_Door|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,		$13,	1,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_Saw,	id_Saws,		1,	0,	ArtTile_SBZ_Saw|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,		$24,	1,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_Saw,	id_Saws,		4,	2,	ArtTile_SBZ_Saw|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,		$34,	1,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_VanP,	id_VanishPlatform,	0,	0,	ArtTile_SBZ_Vanishing_Block|Tile_Pal3
		dbug	Map_Flame,	id_Flamethrower,	$64,	0,	ArtTile_SBZ_Flamethrower|Tile_Prio
		dbug	Map_Flame,	id_Flamethrower,	$64,	$B,	ArtTile_SBZ_Flamethrower|Tile_Prio
		dbug	Map_Elec,	id_Electro,		4,	0,	ArtTile_SBZ_Electric_Orb
		dbug	Map_Gird,	id_Girder,		0,	0,	ArtTile_SBZ_Girder|Tile_Pal3
		dbug	Map_Invis,	id_Invisibarrier,	$11,	0,	ArtTile_Monitor|Tile_Prio
		dbug	Map_Hog,	id_BallHog,		4,	0,	ArtTile_Ball_Hog|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,		1,	0,	ArtTile_Lamppost
.SBZ_end:

; ---------------------------------------------------------------------------

; This list is used by both the Ending Sequence and the Special Stages
.EndingSS:	dbugheader
		;	mappings	object			subtype	frame	VRAM setting
	if Revision=0
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Bump,	id_Bumper,		0,	0,	ArtTile_SYZ_Bumper
	    if FixBugs
		dbug	Map_Animal2,	id_Animals,		$A,	0,	ArtTile_Ending_Flicky
		dbug	Map_Animal2,	id_Animals,		$B,	0,	ArtTile_Ending_Flicky
		dbug	Map_Animal2,	id_Animals,		$C,	0,	ArtTile_Ending_Flicky
	    else
		; Wrong art tile offset
		dbug	Map_Animal2,	id_Animals,		$A,	0,	ArtTile_Ending_Flicky-5
		dbug	Map_Animal2,	id_Animals,		$B,	0,	ArtTile_Ending_Flicky-5
		dbug	Map_Animal2,	id_Animals,		$C,	0,	ArtTile_Ending_Flicky-5
	    endif
		dbug	Map_Animal1,	id_Animals,		$D,	0,	ArtTile_Ending_Rabbit
		dbug	Map_Animal1,	id_Animals,		$E,	0,	ArtTile_Ending_Rabbit
		dbug	Map_Animal1,	id_Animals,		$F,	0,	ArtTile_Ending_Penguin
		dbug	Map_Animal1,	id_Animals,		$10,	0,	ArtTile_Ending_Penguin
		dbug	Map_Animal2,	id_Animals,		$11,	0,	ArtTile_Ending_Seal
		dbug	Map_Animal3,	id_Animals,		$12,	0,	ArtTile_Ending_Pig
		dbug	Map_Animal2,	id_Animals,		$13,	0,	ArtTile_Ending_Chicken
		dbug	Map_Animal3,	id_Animals,		$14,	0,	ArtTile_Ending_Squirrel
	else
		; REV01 cleared out most of this list, only leaving rings (two for some reason, second one is blank...)
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug 	Map_Ring,	id_Rings,		0,	8,	ArtTile_Ring|Tile_Pal2
	endif
.EndingSS_end:

; ---------------------------------------------------------------------------

		even
