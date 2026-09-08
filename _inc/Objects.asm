; ===========================================================================
; ---------------------------------------------------------------------------
; Object code execution subroutine
; 
; output:
;	d7.l = OST index of last object (must not be changed by any object)
;	a0 = address of OST of last object
; ---------------------------------------------------------------------------

ExecuteObjects:
		lea	(v_objspace).w,a0			; set address for object RAM
		moveq	#(v_objspace_end-v_objspace)/object_size-1,d7 ; $80 objects - 1
		moveq	#0,d0					; clear d0
		cmpi.b	#6,(v_player+obRoutine).w		; is Sonic dying?
		bhs.s	.sonic_dead				; if yes, branch to alternate logic

; loc_D348:
.run_object:
		move.b	(a0),d0					; load object ID from RAM
		beq.s	.next_object				; if ID is 0, this is an empty object slot, branch
		add.w	d0,d0					; quadruple for...
		add.w	d0,d0					; ...long-based indexing
		movea.l	Obj_Index-4(pc,d0.w),a1			; find relevant object pointer (minus -4 because entries skip ID 00)
		jsr	(a1)					; run the object's code
		moveq	#0,d0					; clear d0 for next loop

	; loc_D358:
	.next_object:
		lea	object_size(a0),a0			; increase a0 to go to next object entry ($40 bytes)
		dbf	d7,.run_object				; loop until all objects have been executed
		rts						; return
; ===========================================================================

; Separate logic while Sonic is dying, used to freeze level objects in place
; while still executing reserved objects normally (mainly Sonic himself).

; loc_D362:
.sonic_dead:
		moveq	#(v_lvlobjspace-v_objspace)/object_size-1,d7 ; run first 32 objects normally (reserved objects like Sonic)
		bsr.s	.run_object				; execute those objects and return here

		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d7 ; run the remaining 96 objects in display-only mode
; loc_D368:
.display_object:
		moveq	#0,d0					; clear d0
		move.b	obID(a0),d0				; load object ID from RAM
		beq.s	.next_object_displayonly		; if ID is 0, this is an empty object slot, branch
		tst.b	obRender(a0)				; was object on-screen as Sonic died?
		bpl.s	.next_object_displayonly		; if not, branch
		bsr.w	DisplaySprite				; keep displaying the object as Sonic dies but don't execute it

	; loc_D378:
	.next_object_displayonly:
		lea	object_size(a0),a0			; increase a0 to go to next object entry ($40 bytes)
		dbf	d7,.display_object			; loop until all objects have been executed
		rts						; return
; End of function ExecuteObjects

; ===========================================================================
; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
Obj_Index:

objptr:	macro objectpointer,{INTLABEL}
__LABEL__:	label	((*-Obj_Index)/4)+1
		dc.l	objectpointer
		endm

; ---------------------------------------------------------------------------
; ID label:	non-zero index byte (see ID value)
; Object label:	main label to the actual object source

; ID label			Object label		  ID value
id_SonicPlayer:		objptr	SonicPlayer		; 01
id_Obj02:		objptr	NullObject		; 02
id_Obj03:		objptr	NullObject		; 03
id_Obj04:		objptr	NullObject		; 04
id_Obj05:		objptr	NullObject		; 05
id_Obj06:		objptr	NullObject		; 06
id_Obj07:		objptr	NullObject		; 07
id_Splash:		objptr	Splash			; 08
id_SonicSpecial:	objptr	SonicSpecial		; 09
id_DrownCount:		objptr	DrownCount		; 0A
id_Pole:		objptr	Pole			; 0B
id_FlapDoor:		objptr	FlapDoor		; 0C
id_Signpost:		objptr	Signpost		; 0D
id_TitleSonic:		objptr	TitleSonic		; 0E
id_PSBTM:		objptr	PSBTM			; 0F
	if UnusedOptimization
id_Obj10:		objptr	NullObject		; 10
	else
id_AnimTest:		objptr	AnimTest		; 10
	endif
id_Bridge:		objptr	Bridge			; 11
id_SpinningLight:	objptr	SpinningLight		; 12
id_LavaMaker:		objptr	LavaMaker		; 13
id_LavaBall:		objptr	LavaBall		; 14
id_SwingingPlatform:	objptr	SwingingPlatform	; 15
id_Harpoon:		objptr	Harpoon			; 16
id_Helix:		objptr	Helix			; 17
id_BasicPlatform:	objptr	BasicPlatform		; 18
	if UnusedOptimization
id_Obj19:		objptr	NullObject		; 19
	else
id_RollingBall:		objptr	RollingBall		; 19
	endif
id_CollapseLedge:	objptr	CollapseLedge		; 1A
id_WaterSurface:	objptr	WaterSurface		; 1B
id_Scenery:		objptr	Scenery			; 1C
id_MagicSwitch:		objptr	MagicSwitch		; 1D
id_BallHog:		objptr	BallHog			; 1E
id_Crabmeat:		objptr	Crabmeat		; 1F
id_Cannonball:		objptr	Cannonball		; 20
id_HUD:			objptr	HUD			; 21
id_BuzzBomber:		objptr	BuzzBomber		; 22
id_Missile:		objptr	Missile			; 23
	if UnusedOptimization
id_Obj24:		objptr	NullObject		; 24
	else
id_UnusedExplosion:	objptr	UnusedExplosion		; 24
	endif
id_Rings:		objptr	Rings			; 25
id_Monitor:		objptr	Monitor			; 26
id_ExplosionItem:	objptr	ExplosionItem		; 27
id_Animals:		objptr	Animals			; 28
id_Points:		objptr	Points			; 29
id_AutoDoor:		objptr	AutoDoor		; 2A
id_Chopper:		objptr	Chopper			; 2B
id_Jaws:		objptr	Jaws			; 2C
id_Burrobot:		objptr	Burrobot		; 2D
id_PowerUp:		objptr	PowerUp			; 2E
id_LargeGrass:		objptr	LargeGrass		; 2F
id_GlassBlock:		objptr	GlassBlock		; 30
id_ChainStomp:		objptr	ChainStomp		; 31
id_Button:		objptr	Button			; 32
id_PushBlock:		objptr	PushBlock		; 33
id_TitleCard:		objptr	TitleCard		; 34
id_GrassFire:		objptr	GrassFire		; 35
id_Spikes:		objptr	Spikes			; 36
id_RingLoss:		objptr	RingLoss		; 37
id_ShieldItem:		objptr	ShieldItem		; 38
id_GameOverCard:	objptr	GameOverCard		; 39
id_GotThroughCard:	objptr	GotThroughCard		; 3A
id_PurpleRock:		objptr	PurpleRock		; 3B
id_SmashWall:		objptr	SmashWall		; 3C
id_BossGreenHill:	objptr	BossGreenHill		; 3D
id_Prison:		objptr	Prison			; 3E
id_Explosion:		objptr	Explosion		; 3F
id_MotoBug:		objptr	MotoBug			; 40
id_Springs:		objptr	Springs			; 41
id_Newtron:		objptr	Newtron			; 42
id_Roller:		objptr	Roller			; 43
id_EdgeWalls:		objptr	EdgeWalls		; 44
	if UnusedOptimization
id_Obj45:		objptr	NullObject		; 45
	else
id_SideStomp:		objptr	SideStomp		; 45
	endif
id_MarbleBrick:		objptr	MarbleBrick		; 46
id_Bumper:		objptr	Bumper			; 47
id_BossBall:		objptr	BossBall		; 48
id_WaterSound:		objptr	WaterSound		; 49
	if UnusedOptimization
id_Obj4A:		objptr	NullObject		; 4A
	else
id_VanishSonic:		objptr	VanishSonic		; 4A
	endif
id_GiantRing:		objptr	GiantRing		; 4B
id_GeyserMaker:		objptr	GeyserMaker		; 4C
id_LavaGeyser:		objptr	LavaGeyser		; 4D
id_LavaWall:		objptr	LavaWall		; 4E
	if UnusedOptimization
id_Obj4F:		objptr	NullObject		; 4F
	else
id_Splats:		objptr	Splats			; 4F
	endif
id_Yadrin:		objptr	Yadrin			; 50
id_SmashBlock:		objptr	SmashBlock		; 51
id_MovingBlock:		objptr	MovingBlock		; 52
id_CollapseFloor:	objptr	CollapseFloor		; 53
id_LavaTag:		objptr	LavaTag			; 54
id_Basaran:		objptr	Basaran			; 55
id_FloatingBlock:	objptr	FloatingBlock		; 56
id_SpikeBall:		objptr	SpikeBall		; 57
id_BigSpikeBall:	objptr	BigSpikeBall		; 58
id_Elevator:		objptr	Elevator		; 59
id_CirclingPlatform:	objptr	CirclingPlatform	; 5A
id_Staircase:		objptr	Staircase		; 5B
id_Pylon:		objptr	Pylon			; 5C
id_Fan:			objptr	Fan			; 5D
id_Seesaw:		objptr	Seesaw			; 5E
id_Bomb:		objptr	Bomb			; 5F
id_Orbinaut:		objptr	Orbinaut		; 60
id_LabyrinthBlock:	objptr	LabyrinthBlock		; 61
id_Gargoyle:		objptr	Gargoyle		; 62
id_LabyrinthConvey:	objptr	LabyrinthConvey		; 63
id_Bubble:		objptr	Bubble			; 64
id_Waterfall:		objptr	Waterfall		; 65
id_Junction:		objptr	Junction		; 66
id_RunningDisc:		objptr	RunningDisc		; 67
id_Conveyor:		objptr	Conveyor		; 68
id_SpinPlatform:	objptr	SpinPlatform		; 69
id_Saws:		objptr	Saws			; 6A
id_ScrapStomp:		objptr	ScrapStomp		; 6B
id_VanishPlatform:	objptr	VanishPlatform		; 6C
id_Flamethrower:	objptr	Flamethrower		; 6D
id_Electro:		objptr	Electro			; 6E
id_SpinConvey:		objptr	SpinConvey		; 6F
id_Girder:		objptr	Girder			; 70
id_Invisibarrier:	objptr	Invisibarrier		; 71
id_Teleport:		objptr	Teleport		; 72
id_BossMarble:		objptr	BossMarble		; 73
id_BossFire:		objptr	BossFire		; 74
id_BossSpringYard:	objptr	BossSpringYard		; 75
id_BossBlock:		objptr	BossBlock		; 76
id_BossLabyrinth:	objptr	BossLabyrinth		; 77
id_Caterkiller:		objptr	Caterkiller		; 78
id_Lamppost:		objptr	Lamppost		; 79
id_BossStarLight:	objptr	BossStarLight		; 7A
id_BossSpikeball:	objptr	BossSpikeball		; 7B
id_RingFlash:		objptr	RingFlash		; 7C
id_HiddenBonus:		objptr	HiddenBonus		; 7D
id_SSResult:		objptr	SSResult		; 7E
id_SSRChaos:		objptr	SSRChaos		; 7F
id_ContScrItem:		objptr	ContScrItem		; 80
id_ContSonic:		objptr	ContSonic		; 81
id_ScrapEggman:		objptr	ScrapEggman		; 82
id_FalseFloor:		objptr	FalseFloor		; 83
id_EggmanCylinder:	objptr	EggmanCylinder		; 84
id_BossFinal:		objptr	BossFinal		; 85
id_BossPlasma:		objptr	BossPlasma		; 86
id_EndSonic:		objptr	EndSonic		; 87
id_EndChaos:		objptr	EndChaos		; 88
id_EndSTH:		objptr	EndSTH			; 89
id_CreditsText:		objptr	CreditsText		; 8A
id_EndEggman:		objptr	EndEggman		; 8B
id_TryChaos:		objptr	TryChaos		; 8C

; ---------------------------------------------------------------------------

NullObject:
	if FixBugs
		; It would be safer to have this instruction here, otherwise it would just fall through to ObjectFall
		jmp	(DeleteObject).l
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to make an object fall downwards, increasingly fast
; ---------------------------------------------------------------------------
gravity:	equ	$38				; gravity constant used by many objects
; ---------------------------------------------------------------------------

ObjectFall:
		move.l	obX(a0),d2				; get object's X-axis position
		move.l	obY(a0),d3				; get object's Y-axis position
		move.w	obVelX(a0),d0				; load horizontal speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d2					; add speed to X-axis position

		move.w	obVelY(a0),d0				; load vertical speed
		addi.w	#gravity,obVelY(a0)			; increase vertical speed (apply gravity)
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d3					; add speed to Y-axis position

		move.l	d2,obX(a0)				; update X-axis position
		move.l	d3,obY(a0)				; update Y-axis position
		rts						; return
; End of function ObjectFall


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position.
; Identical to ObjectFall, but without applying gravity.
; ---------------------------------------------------------------------------

SpeedToPos:
		move.l	obX(a0),d2				; get object's X-axis position
		move.l	obY(a0),d3				; get object's Y-axis position
		move.w	obVelX(a0),d0				; load horizontal speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d2					; add speed to X-axis position

		move.w	obVelY(a0),d0				; load vertical speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d3					; add speed to Y-axis position

		move.l	d2,obX(a0)				; update X-axis position
		move.l	d3,obY(a0)				; update Y-axis position
		rts						; return
; End of function SpeedToPos

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

DisplaySprite:
		lea	(v_spritequeue).w,a1			; load sprite priority layer buffer
		move.w	obPriority(a0),d0			; d0 = priority level * $100 (lower byte ignored)
		lsr.w	#8-spritelayer_size_bits,d0		; d0 = priority level * spritequeue_layersize (lower bits ignored)
		andi.w	#spritelayer_size*(spritelayer_num-1),d0 ; mask to possible offset starts per layer ($80*7=$380)
		adda.w	d0,a1					; jump to start of appropriate priority layer
		cmpi.w	#spritelayer_size-2,(a1)		; is this sprite priority layer full? ($7E bytes)
		bhs.s	.return					; if yes, drop queuing this sprite
		addq.w	#2,(a1)					; increment sprite counter
		adda.w	(a1),a1					; jump to empty position
		move.w	a0,(a1)					; insert RAM address for object

	.return:
		rts						; return
; End of function DisplaySprite

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to display a 2nd sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; DisplaySprite1: <-- old misnomer
DisplaySprite2:
		lea	(v_spritequeue).w,a2			; load sprite priority layer buffer
		move.w	obPriority(a1),d0			; d0 = priority level * $100 (lower byte ignored)
		lsr.w	#8-spritelayer_size_bits,d0		; d0 = priority level * spritequeue_layersize (lower bits ignored)
		andi.w	#spritelayer_size*(spritelayer_num-1),d0 ; mask to possible offset starts per layer ($80*7=$380)
		adda.w	d0,a2					; jump to start of appropriate priority layer
		cmpi.w	#spritelayer_size-2,(a2)		; is this sprite priority layer full? ($7E bytes)
		bhs.s	.return					; if yes, drop queuing this sprite
		addq.w	#2,(a2)					; increment sprite counter
		adda.w	(a2),a2					; jump to empty position
		move.w	a1,(a2)					; insert RAM address for object

	.return:
		rts						; return
; End of function DisplaySprite2

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to delete an object
;
; input:
;	a0 = pointer to object to delete (DeleteObject)
;	a1 = pointer to object to delete (DeleteChild)
; ---------------------------------------------------------------------------

DeleteObject:
		movea.l	a0,a1					; move self object RAM address a0 to a1
; ---------------------------------------------------------------------------

DeleteChild:	; object is already in a1
		moveq	#0,d1					; overwrite with zeroes
		moveq	#object_size/4-1,d0			; cover all $40 bytes of object RAM slot
DelObj_Loop:	move.l	d1,(a1)+				; clear the object RAM
		dbf	d0,DelObj_Loop				; repeat for length of object RAM
		rts						; deletion done
; End of function DeleteObject

; ===========================================================================
; BuildSprites camera pointers to be used depending on bits 2-3 in obRender.

; Here they point to the camera X-position, and it's expected that 4 bytes
; after it the camera Y-position is located (e.g. v_screenposx/v_screenposy).
; Note that the last two background camera pointers go completely unused
; in the entire game, though they may have once been used for the
; foreground palm trees in the Tokyo Toy Show demo.

; BldSpr_ScrPos:
BuildSpr_Cameras:
		dc.l 0						; null (fallback for on-screen coordinates)
		dc.l v_screenposx&$FFFFFF			; foreground camera
		dc.l v_bgscreenposx&$FFFFFF			; background camera 1 (unused)
		dc.l v_bg3screenposx&$FFFFFF			; background camera 2 (unused)
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) into proper Mega Drive sprites
; and queue them into a linked sprite buffer table (transferred in VBlank).
; ---------------------------------------------------------------------------

BuildSprites:
		lea	(v_spritetablebuffer).w,a2
		moveq	#0,d5					; d5 will be used as counter for total rendered sprites

		lea	(v_spritequeue).w,a4
		moveq	#spritelayer_num-1,d7
.priorityLoop:
		tst.w	(a4)					; are there objects left to draw in current priority layer?
		beq.w	.nextPriority				; if not, go to next priority layer

		moveq	#2,d6					; initialize offset pointer to first object after entry counter (2 bytes)
	.objectLoop:
		movea.w	(a4,d6.w),a0				; load object's address in RAM
		tst.b	obID(a0)				; has an object been queued for display but deleted?
		beq.w	.skipObject				; if yes, skip (this appears to be an effort to fix display-and-delete bugs)
		bclr	#sprite_rendered_bit,obRender(a0)	; set object as not visible

	; --- Coordinate system ---
		move.b	obRender(a0),d0
		move.b	d0,d4
		andi.w	#sprite_cam_field|sprite_cam_bg,d0	; get drawing coordinate system in render flags (bit 2-3)
		beq.s	.screenCoords				; branch if 0 (on-screen positioning coordinate system)
		movea.l	BuildSpr_Cameras(pc,d0.w),a1		; load camera pointers for coordinate system (in practice, only foreground camera is ever used)

	; --- Screen bounds check for X-position ---
		moveq	#0,d0
		move.b	obActWid(a0),d0				; get display width
		move.w	obX(a0),d3
		sub.w	(a1),d3					; subtract camera X-position
		move.w	d3,d1
		add.w	d0,d1					; d1 = obX - cameraX + obActWid
		bmi.w	.skipObject				; if underflowed, left edge is out of bounds
		move.w	d3,d1
		sub.w	d0,d1					; d1 = obX - cameraX - obActWid
		cmpi.w	#320,d1					; is result greater than screen width?
		bge.s	.skipObject				; if yes, right edge is out of bounds
		addi.w	#$80,d3					; add VDP sprite start

	; --- Screen bounds check for Y-position ---
		btst	#sprite_customheight_bit,d4		; is custom height flag set?
		beq.s	.assumeHeight				; if not, assume height instead

		moveq	#0,d0
		move.b	obHeight(a0),d0				; use custom height
		move.w	obY(a0),d2
		sub.w	4(a1),d2				; subtract camera Y-position
		move.w	d2,d1
		add.w	d0,d1					; d1 = obY - cameraY + obHeight
		bmi.s	.skipObject				; if negative, top edge is out of bounds
		move.w	d2,d1
		sub.w	d0,d1					; d1 = obY - cameraY - obHeight
		cmpi.w	#224,d1					; is result greater than screen height?
		bge.s	.skipObject				; if yes, bottom edge is out of bounds
		addi.w	#$80,d2					; add VDP sprite start
		bra.s	.drawObject
; ---------------------------------------------------------------------------

	.screenCoords:
		move.w	obScreenY(a0),d2			; special variable for screen Y
		move.w	obX(a0),d3
		bra.s	.drawObject
; ---------------------------------------------------------------------------

	.assumeHeight:
		.ah:	equ 32					; assumed height = 32px ($20)
		move.w	obY(a0),d2
		sub.w	4(a1),d2				; subtract camera Y-position
		addi.w	#$80,d2
		cmpi.w	#$80-.ah,d2				; is top Y-position with assumed height out of bounds?
		blo.s	.skipObject				; if yes, branch
		cmpi.w	#$80+224+.ah,d2				; is bottom Y-position with assumed height out of bounds?
		bhs.s	.skipObject				; if yes, branch

	; --- Load sprite mappings ---
	.drawObject:
		movea.l	obMap(a0),a1

		moveq	#1-1,d1					; write only one sprite for raw-mappings
		btst	#sprite_rawmappings_bit,d4		; is "raw-mappings" flag on?
		bne.s	.drawFrame				; if yes, branch (assume mappings point to a single sprite piece)

		move.b	obFrame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1				; get mappings frame address
		move.b	(a1)+,d1				; get number of sprite pieces in frame
		subq.b	#1,d1					; subtract 1 for dbf
		bmi.s	.setVisible				; skip rendering if mapping was blank

	; --- Do the actual sprite mapping rendering ---
	.drawFrame:
		bsr.w	BuildSpr_Draw

	.setVisible:
		bset	#sprite_rendered_bit,obRender(a0)	; set object as visible

	.skipObject:
		addq.w	#2,d6					; advance to next entry in layer
		subq.w	#2,(a4)					; decrement number of objects left
		bne.w	.objectLoop				; if entries remain, loop

.nextPriority:
		lea	spritelayer_size(a4),a4			; advance to next layer (each layer is $80 bytes)
		dbf	d7,.priorityLoop

		move.b	d5,(v_spritecount).w			; write number of rendered sprites to debug var
		cmpi.b	#sprites_max,d5				; check if sprite limit was exhausted
		beq.s	.spriteLimit				; if yes, branch
		move.l	#0,(a2)					; unlink last sprite
		rts
; ---------------------------------------------------------------------------

	.spriteLimit:
		move.b	#0,-5(a2)				; unlink penultimate sprite
		rts
; End of function BuildSprites

; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for all BuildSpr_Draw functions, to visualize the differences between them.
; All four variants work on the same basic principle, only coming with
; modifications for the flipping.
; 
; input:
;	d1 = number of sprite pieces in mapping minus 1
;	d2 = base Y-position
;	d3 = base X-position
;	d5 = total rendered sprites so far (max 80)
;	a1 = pointer to starting sprite piece in sprite mappings (see breakdown above)
;	a2 = pointer to sprite link buffer (v_spritetablebuffer)
;	a3 = art tile / VRAM setting (obGfx)
;
; Each sprite piece is exactly 5 bytes. See here for a breakdown:
; https://info.sonicretro.org/SCHG:Sonic_the_Hedgehog_(16-bit)/Object_Editing#Mappings_editing
; ---------------------------------------------------------------------------

buildsprite:	macro xflip,yflip

.loopSpritePieces:
	; --- Sprite limit check ---
		cmpi.b	#sprites_max,d5				; check sprite limit
		beq.s	.return					; if all sprite slots are taken up, abort process

	; --- Y-position ---
		move.b	(a1)+,d0				; get relative Y-offset
		if yflip
			move.b	(a1),d4				; get dimensions of sprite piece
			ext.w	d0
			neg.w	d0
			lsl.b	#3,d4
			andi.w	#%11000,d4
			addq.w	#8,d4
			sub.w	d4,d0				; d0 = flipped Y-position
		else
			ext.w	d0
		endif
		add.w	d2,d0					; add base Y-position
		move.w	d0,(a2)+				; write Y-position to buffer

	; --- Sprite width/height ---
		if xflip
			move.b	(a1)+,d4			; get dimensions of sprite piece (WWHH) (backup for later)
			move.b	d4,(a2)+			; write sprite width to buffer
		else
			move.b	(a1)+,(a2)+			; write sprite width to buffer
		endif

	; --- Sprite link ---
		addq.b	#1,d5					; increase total sprites counter
		move.b	d5,(a2)+				; write sprite link to buffer

	; --- VRAM settings / art tile / flipping ---
		move.b	(a1)+,d0				; get first half of VRAM settings
		lsl.w	#8,d0
		move.b	(a1)+,d0				; get second half of VRAM settings
		add.w	a3,d0					; add base art tile offset of object
		if xflip|yflip
			eori.w	#xflip<<11|yflip<<12,d0		; toggle X-flip ($800) and/or Y-flip ($1000) in VDP
		endif
		move.w	d0,(a2)+				; write VRAM settings to buffer

	; --- X-position ---
		move.b	(a1)+,d0				; get relative X-offset
		ext.w	d0
		if xflip
			neg.w	d0
			add.b	d4,d4
			andi.w	#%11000,d4
			addq.w	#8,d4
			sub.w	d4,d0				; d0 = flipped X-position
		endif
		add.w	d3,d0					; add X-position
		andi.w	#$1FF,d0				; keep within 512px (screen wrap)
		bne.s	.x					; if non-zero, branch
		addq.w	#1,d0					; force zero X-position to non-zero (avoid unwanted sprite masking)
	.x:	move.w	d0,(a2)+				; write X-position to buffer

	; --- Loop for all pieces in mapping ---
		dbf	d1,.loopSpritePieces

	.return:
		rts

	endm

; ---------------------------------------------------------------------------
; Subroutine to convert a object mapping frame (with multiple sprite pieces)
; into valid, linked Mega Drive sprites and buffer them, with flipping.
; ---------------------------------------------------------------------------

BuildSpr_Draw:
		movea.w	obGfx(a0),a3				; get VRAM settings for object (art tile, palette line, priority flag)

		btst	#sprite_xflip_bit,d4			; is X-flip flag set?
		bne.s	BuildSpr_FlipX				; if yes, branch
		btst	#sprite_yflip_bit,d4			; is Y-flip flag set?
		bne.w	BuildSpr_FlipY				; if yes, branch

BuildSpr_Normal:
		buildsprite	0,0
; ---------------------------------------------------------------------------

BuildSpr_FlipX:
		btst	#sprite_yflip_bit,d4			; is Y-flip flag set as well?
		bne.w	BuildSpr_FlipXY				; if yes, branch

		buildsprite	1,0
; ---------------------------------------------------------------------------

BuildSpr_FlipY:
		buildsprite	0,1
; ---------------------------------------------------------------------------

BuildSpr_FlipXY:
		buildsprite	1,1
; End of function BuildSpr_Draw

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if an object is off screen
;
; output:
;	d0 = 0 if on screen, 1 if off screen
; ---------------------------------------------------------------------------

ChkObjectVisible:
		move.w	obX(a0),d0				; get object x-position
		sub.w	(v_screenposx).w,d0			; subtract screen x-position
		bmi.s	.offscreen				; branch if object is off screen to the left
		cmpi.w	#320,d0					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the right

		move.w	obY(a0),d1				; get object y-position
		sub.w	(v_screenposy).w,d1			; subtract screen y-position
		bmi.s	.offscreen				; branch if object is off screen to the top
		cmpi.w	#224,d1					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the bottom

		moveq	#0,d0					; set Z-flag (object on screen)
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0					; clear Z-flag (object off screen)
		rts
; End of function ChkObjectVisible

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if an object is off screen
; More precise than above subroutine, taking width into account
;
; output:
;	d0 = 0 if on screen, 1 if off screen
; ---------------------------------------------------------------------------

ChkPartiallyVisible:
		moveq	#0,d1					; clear d1 (obActWid is byte-sized)
		move.b	obActWid(a0),d1				; get object's display width
		move.w	obX(a0),d0				; get object x-position
		sub.w	(v_screenposx).w,d0			; subtract screen x-position
		add.w	d1,d0					; add object display width
		bmi.s	.offscreen				; branch if object is off screen to the left
		add.w	d1,d1					; double width for undoing above addition and right-side check
		sub.w	d1,d0					; sub object display width
		cmpi.w	#320,d0					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the right

	if FixBugs
		; Fix partial visibility check for height, too
		moveq	#0,d1					; clear d1 (obHeight is byte-sized)
		move.b	obHeight(a0),d1				; get object's height
		move.w	obY(a0),d0				; get object's y-position
		sub.w	(v_screenposy).w,d0			; subtract screen y-position
		add.w	d1,d0					; add object height
		bmi.s	.offscreen				; branch if object is off screen to the top
		add.w	d1,d1					; double height for undoing above addition and for bottom-side check
		sub.w	d1,d0					; su object height
		cmpi.w	#224,d1					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the bottom
	else
		move.w	obY(a0),d1				; get object y-position
		sub.w	(v_screenposy).w,d1			; subtract screen y-position
		bmi.s	.offscreen				; branch if object is off screen to the top
		cmpi.w	#224,d1					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the bottom
	endif

		moveq	#0,d0					; set Z-flag (object on screen)
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0					; clear Z-flag (object off screen)
		rts
; End of function ChkPartiallyVisible

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load a level's objects
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)

; ===========================================================================
OPL_Index:	dc.w OPL_Main-OPL_Index
		dc.w OPL_Next-OPL_Index
; ===========================================================================

; Spawn window is initially -256px to -128px (relative to v_screenposx)
; This is moved to -128px to 640px during OPL_Next so that all on-screen objects load at level start

OPL_Main:
		addq.b	#2,(v_opl_routine).w			; goto OPL_Next next
		move.w	(v_zone_act).w,d0			; get zone/act numbers
		lsl.b	#6,d0
		lsr.w	#4,d0					; combine zone/act into single number, times 4
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1					; copy index pointer to a1
		adda.w	(a0,d0.w),a0				; jump to objpos list for specified zone/act
		move.l	a0,(v_opl_data).w			; copy objpos list address
		move.l	a0,(v_opl_data+4).w
		adda.w	2(a1,d0.w),a1				; jump to secondary objpos list (this is always blank)
		move.l	a1,(v_opl_data+8).w			; copy objpos list address
		move.l	a1,(v_opl_data+$C).w
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+				; start respawn counter at 1
	if FixBugs
		move.w	#(v_objstate_end-v_objstate-2)/4-1,d0
	else
		; This clears longwords, but the loop counter is measured in words!
		; This causes $17C bytes to be cleared instead of $BE.
		move.w	#(v_objstate_end-v_objstate-2)/2-1,d0
	endif

	; OPL_ClrList:
	.clear_respawn_list:
		clr.l	(a2)+
		dbf	d0,.clear_respawn_list			; clear object respawn list

	if FixBugs
		; Clear the last word, since the above loop only does longwords.
		if (v_objstate_end-v_objstate-2)&2
			clr.w	(a2)+
		endif
	endif

		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		subi.w	#128,d6					; d6 = 128px to left of screen
		bcc.s	.use_screen_x				; branch if camera is > 128px from left boundary
		moveq	#0,d6					; assume 0 if camera is close to left boundary

	; loc_D93C:
	.use_screen_x:
		andi.w	#$FF80,d6				; round down to nearest $80
		movea.l	(v_opl_data).w,a0			; get objpos data pointer

; loc_D944:
.loop_find_right_init:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = edge of spawn window
		bls.s	.found_right				; branch if object is right of edge (1st object outside spawn window)
		tst.b	4(a0)					; 4(a0) = object id and remember state flag
		bpl.s	.no_respawn				; branch if no remember flag found
		move.b	(a2),d2					; d2 = respawn state
		addq.b	#1,(a2)					; increment respawn list counter

	; loc_D952:
	.no_respawn:
		addq.w	#6,a0					; goto next object in objpos list
		bra.s	.loop_find_right_init			; loop until object is found within window
; ===========================================================================

; loc_D956:
.found_right:
		move.l	a0,(v_opl_data).w			; save pointer for objpos, 128px left of screen
		movea.l	(v_opl_data+4).w,a0			; get first objpos in list again
		subi.w	#128,d6					; d6 = 256px to left of screen
		bcs.s	.found_left				; branch if camera is close to left boundary

; loc_D964:
.loop_find_left_init:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = edge of spawn window
		bls.s	.found_left				; branch if object is right of edge (1st object inside spawn window)
		tst.b	4(a0)					; 4(a0) = object id and remember state flag
		bpl.s	.no_respawn2				; branch if no remember flag found
		addq.b	#1,1(a2)				; increment second respawn list counter

	; loc_D972:
	.no_respawn2:
		addq.w	#6,a0					; goto next object in objpos list
		bra.s	.loop_find_left_init			; loop until object is found within window
; ===========================================================================

; loc_D976:
.found_left:
		move.l	a0,(v_opl_data+4).w			; save pointer for objpos, 256px left of screen
		move.w	#-1,(v_opl_screen).w			; start screen at -1 so OPL_Next thinks it's moving right
		; fall-through to OPL_Next...

; ---------------------------------------------------------------------------
; Primary level object loading routine
; ---------------------------------------------------------------------------

OPL_Next:
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6				; d6 = camera x pos rounded down to nearest $80
		cmp.w	(v_opl_screen).w,d6			; compare to previous screen position
		beq.w	OPL_NoMove				; branch if screen hasn't moved
		bge.s	OPL_MovedRight				; branch if screen is right of previous position (or if level just started)
; ---------------------------------------------------------------------------

OPL_MovedLeft:
		move.w	d6,(v_opl_screen).w			; update screen position
		movea.l	(v_opl_data+4).w,a0			; jump to objpos on left side of window
		subi.w	#128,d6					; d6 = 128px to left of screen
		bcs.s	.found_left				; branch if camera is close to left boundary

; loc_D9A6:
.loop_find_left:
		cmp.w	-6(a0),d6				; read objpos backwards
		bge.s	.found_left				; branch if object is outside spawn window
		subq.w	#6,a0					; update pointer
		tst.b	4(a0)					; 4(a0) = object id and remember state flag
		bpl.s	.no_respawn				; branch if no remember flag found
		subq.b	#1,1(a2)				; decrement second respawn list counter
		move.b	1(a2),d2				; get respawn counter

	; loc_D9BC:
	.no_respawn:
		bsr.w	OPL_SpawnObj				; check respawn flag and spawn object
		bne.s	.failed_to_spawn			; branch if spawn fails
		subq.w	#6,a0					; goto previous object in objpos list
		bra.s	.loop_find_left				; loop until object is found within window
; ===========================================================================

; loc_D9C6:
.failed_to_spawn:
		tst.b	4(a0)					; did object that failed to spawn have remember flag set?
		bpl.s	.no_respawn2				; if not, branch
		addq.b	#1,1(a2)				; revert decrementing second respawn list counter from above

	; loc_D9D0:
	.no_respawn2:
		addq.w	#6,a0					; advance objpos

; loc_D9D2:
.found_left:
		move.l	a0,(v_opl_data+4).w			; save pointer for objpos
		movea.l	(v_opl_data).w,a0			; jump to objpos on right side of window
		addi.w	#128+320+320,d6				; d6 = 320px to right of screen

; loc_D9DE:
.loop_find_right:
		cmp.w	-6(a0),d6				; read objpos backwards
		bgt.s	.found_right				; branch if object is within spawn window
		tst.b	-2(a0)					; -2(a0) = object id and remember state flag
		bpl.s	.no_respawn3				; branch if no remember flag found
		subq.b	#1,(a2)					; decrement respawn list counter

	; loc_D9EC:
	.no_respawn3:
		subq.w	#6,a0					; goto previous object in objpos list
		bra.s	.loop_find_right
; ===========================================================================

; loc_D9F0:
.found_right:
		move.l	a0,(v_opl_data).w			; save pointer for objpos
		rts
; End of function OPL_MovedLeft
; ===========================================================================

; loc_D9F6:
OPL_MovedRight:
		move.w	d6,(v_opl_screen).w			; update screen position
		movea.l	(v_opl_data).w,a0			; jump to objpos on right side of window
		addi.w	#320+320,d6				; d6 = 320px to right of screen

; loc_DA02:
.loop_find_right:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = right edge of spawn window
		bls.s	.found_right				; branch if object is outside spawn window
		tst.b	4(a0)
		bpl.s	.no_respawn
		move.b	(a2),d2
		addq.b	#1,(a2)

	; loc_DA10:
	.no_respawn:
		bsr.w	OPL_SpawnObj				; check respawn flag and spawn object
		beq.s	.loop_find_right			; loop until object is found outside window
	if FixBugs
		; Fix a remember sprite related bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_remember_sprite_related_bug
		tst.b	4(a0)					; was this object a remember state?
		bpl.s	.found_right				; if not, branch
		subq.b	#1,(a2)					; move right counter back
	endif

	; loc_DA16:
	.found_right:
		move.l	a0,(v_opl_data).w			; save pointer for objpos
		movea.l	(v_opl_data+4).w,a0			; jump to objpos on left side of window
		subi.w	#320+320+128,d6				; d6 = 128px to left of screen
		bcs.s	.found_left

; loc_DA24:
.loop_find_left:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = left edge of spawn window
		bls.s	.found_left				; branch if object is within spawn window
		tst.b	4(a0)
		bpl.s	.no_respawn2
		addq.b	#1,1(a2)

	; loc_DA32:
	.no_respawn2:
		addq.w	#6,a0
		bra.s	.loop_find_left
; ===========================================================================

; loc_DA36:
.found_left:
		move.l	a0,(v_opl_data+4).w

; locret_DA3A:
OPL_NoMove:
		rts
; End of function OPL_MovedRight

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	load an object
; 
; input:
;	d2.w = position in respawn list
;	a0 = pointer to specific object in objpos list
;	a2 = v_objstate
; 
; output:
;	d0.l = 0 if object is spawned (or skipped because it was broken)
;	a1 = address of OST of spawned object
; ---------------------------------------------------------------------------

; loc_DA3C:
OPL_SpawnObj:
		tst.b	4(a0)					; is remember respawn flag set?
		bpl.s	OPL_MakeItem				; if not, branch
	if FixBugs
		; Fix a remember sprite related bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_remember_sprite_related_bug
		btst	#7,2(a2,d2.w)				; is remember bit already set? (test only)
	else
		bset	#7,2(a2,d2.w)				; set flag so it isn't loaded more than once
	endif
		beq.s	OPL_MakeItem				; branch if object hasn't already been destroyed
		addq.w	#6,a0					; goto next object in objpos list
		moveq	#0,d0
		rts
; ===========================================================================

OPL_MakeItem:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.w	(a0)+,obX(a1)				; set x pos
		move.w	(a0)+,d0				; get y pos and x/y flip flags
		move.w	d0,d1
		andi.w	#$FFF,d0				; ignore x/y flip bits
		move.w	d0,obY(a1)				; set y pos
		rol.w	#2,d1
		andi.b	#sprite_xflip|sprite_yflip,d1		; read only x/y flip bits
		move.b	d1,obRender(a1)				; apply x/y flip
		move.b	d1,obStatus(a1)
		move.b	(a0)+,d0				; get object id
		bpl.s	.no_respawn_bit				; branch if remember respawn bit is not set
	if FixBugs
		; Fix a remember sprite related bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_remember_sprite_related_bug
		bset	#7,2(a2,d2.w)				; set as removed
	endif
		andi.b	#$7F,d0					; ignore respawn bit
		move.b	d2,obRespawnNo(a1)			; give object its place in the respawn table

	; loc_DA80:
	.no_respawn_bit:
		_move.b	d0,obID(a1)				; load object
		move.b	(a0)+,obSubtype(a1)			; set subtype
		moveq	#0,d0

	; locret_DA8A:
	.fail:
		rts
; End of function OPL_SpawnObj
; End of function ObjPosLoad (as a whole)

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find a free object space
; 
; output:
;	a1 = free position in object RAM
;	CCR Z-flag = set if slot was found, clear if RAM is full
; ---------------------------------------------------------------------------

FindFreeObj:
		lea	(v_lvlobjspace).w,a1			; start address for object RAM
		move.w	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0 ; check entire dynamic object RAM

FFree_Loop:
		tst.b	obID(a1)				; is object RAM slot empty?
		beq.s	FFree_Found				; if yes, exit and use that slot
		lea	object_size(a1),a1			; go to next object RAM slot
		dbf	d0,FFree_Loop				; repeat up to 95 times

FFree_Found:
		rts						; return with result in a1
; End of function FindFreeObj

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find a free object space AFTER the current one
; 
; input:
; 	a0 = base object pointer
; 
; output:
;	a1 = free position in object RAM
;	CCR Z-flag = set if slot was found, clear if RAM is full
; ---------------------------------------------------------------------------

FindNextFreeObj:
		movea.l	a0,a1					; get RAM location of parent object
		move.w	#v_lvlobjend&$FFFF,d0			; get end location of object RAM (16-bit)
		sub.w	a0,d0					; d0 = remaining RAM after parent object
		lsr.w	#6,d0					; divide by $40 (object_size)
		subq.w	#1,d0					; minus 1 for dbf
		bcs.s	NFree_Found				; if underflowed, parent object is at the end of RAM, quit

NFree_Loop:
		tst.b	obID(a1)				; is object RAM slot empty?
		beq.s	NFree_Found				; if yes, exit and use that slot
		lea	object_size(a1),a1			; go to next object RAM slot
		dbf	d0,NFree_Loop				; repeat for all free object RAM slots after parent

NFree_Found:
		rts						; return with result in a1
; End of function FindNextFreeObj
