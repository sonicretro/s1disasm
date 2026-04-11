; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
Obj_Index:

objptr:	macro objectpointer,{INTLABEL},{GLOBALSYMBOLS}
__LABEL__: = ((*-Obj_Index)/4)+1
	dc.l	objectpointer
	endm

; ---------------------------------------------------------------------------
; ID label:	non-zero index byte (see ID value)
; Object label:	main label to the actual object source

; ID label			Object label		  ID value
id_SonicPlayer:		objptr	SonicPlayer		; 01
id_Obj02:		objptr	NullObject		; 02
id_PathSwapper:		objptr	PathSwapper		; 03
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
id_Obj10:		objptr	Obj10			; 10
id_Bridge:		objptr	Bridge			; 11
id_SpinningLight:	objptr	SpinningLight		; 12
id_LavaMaker:		objptr	LavaMaker		; 13
id_LavaBall:		objptr	LavaBall		; 14
id_SwingingPlatform:	objptr	SwingingPlatform	; 15
id_Harpoon:		objptr	Harpoon			; 16
id_Helix:		objptr	Helix			; 17
id_BasicPlatform:	objptr	BasicPlatform		; 18
id_Obj19:		objptr	Obj19			; 19
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
id_MissileDissolve:	objptr	MissileDissolve		; 24
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
id_ExplosionBomb:	objptr	ExplosionBomb		; 3F
id_MotoBug:		objptr	MotoBug			; 40
id_Springs:		objptr	Springs			; 41
id_Newtron:		objptr	Newtron			; 42
id_Roller:		objptr	Roller			; 43
id_EdgeWalls:		objptr	EdgeWalls		; 44
id_SideStomp:		objptr	SideStomp		; 45
id_MarbleBrick:		objptr	MarbleBrick		; 46
id_Bumper:		objptr	Bumper			; 47
id_BossBall:		objptr	BossBall		; 48
id_WaterSound:		objptr	WaterSound		; 49
id_VanishSonic:		objptr	VanishSonic		; 4A
id_GiantRing:		objptr	GiantRing		; 4B
id_GeyserMaker:		objptr	GeyserMaker		; 4C
id_LavaGeyser:		objptr	LavaGeyser		; 4D
id_LavaWall:		objptr	LavaWall		; 4E
id_Obj4F:		objptr	Obj4F			; 4F
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
