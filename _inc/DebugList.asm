; ---------------------------------------------------------------------------
; Debug	mode item lists
; ---------------------------------------------------------------------------
DebugList:
	dc.w .GHZ-DebugList
	dc.w .LZ-DebugList
	dc.w .MZ-DebugList
	dc.w .SLZ-DebugList
	dc.w .SYZ-DebugList
	dc.w .SBZ-DebugList
	dc.w .Ending-DebugList
	zonewarning DebugList,2

dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

.GHZ:
	dc.w (.GHZend-.GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Chop,	id_Chopper,	0,	0,	$47B
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_Plat_GHZ,	id_BasicPlatform, 0,	0,	$4000
	dbug	Map_PRock,	id_PurpleRock,	0,	0,	$63D0
	dbug	Map_Moto,	id_MotoBug,	0,	0,	$4F0
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Newt,	id_Newtron,	0,	0,	$249B
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	$434C
	dbug	Map_GBall,	id_Obj19,	0,	0,	$43AA
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	dbug	Map_GRing,	id_GiantRing,	0,	0,	$2400
	dbug	Map_Bonus,	id_HiddenBonus,	1,	1,	$84B6
.GHZend:

.LZ:
	dc.w (.LZend-.LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Jaws,	id_Jaws,	8,	0,	$2486
	dbug	Map_Burro,	id_Burrobot,	0,	2,	$84A6
	dbug	Map_Harp,	id_Harpoon,	0,	0,	$3CC
	dbug	Map_Harp,	id_Harpoon,	2,	3,	$3CC
	dbug	Map_Push,	id_PushBlock,	0,	0,	$43DE
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_MBlockLZ,	id_MovingBlock,	4,	0,	$43BC
	dbug	Map_LBlock,	id_LabyrinthBlock, 1,	0,	$43E6
	dbug	Map_LBlock,	id_LabyrinthBlock, $13,	1,	$43E6
	dbug	Map_LBlock,	id_LabyrinthBlock, 5,	0,	$43E6
	dbug	Map_Gar,	id_Gargoyle,	0,	0,	$443E
	dbug	Map_LBlock,	id_LabyrinthBlock, $27,	2,	$43E6
	dbug	Map_LBlock,	id_LabyrinthBlock, $30,	3,	$43E6
	dbug	Map_LConv,	id_LabyrinthConvey, $7F, 0,	$3F6
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	$467
	dbug	Map_Bub,	id_Bubble,	$84,	$13,	$8348
	dbug	Map_WFall,	id_Waterfall,	2,	2,	$C259
	dbug	Map_WFall,	id_Waterfall,	9,	9,	$C259
	dbug	Map_Pole,	id_Pole,	0,	0,	$43DE
	dbug	Map_Flap,	id_FlapDoor,	2,	0,	$4328
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
.LZend:

.MZ:
	dc.w (.MZend-.MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	$345
	dbug	Map_Brick,	id_MarbleBrick,	0,	0,	$4000
	dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	$63A8
	dbug	Map_LWall,	id_LavaWall,	0,	0,	$63A8
	dbug	Map_Push,	id_PushBlock,	0,	0,	$42B8
	dbug	Map_Yad,	id_Yadrin,	0,	0,	$247B
	dbug	Map_Smab,	id_SmashBlock,	0,	0,	$42B8
	dbug	Map_MBlock,	id_MovingBlock,	0,	0,	$2B8
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	$62B8
	dbug	Map_LTag,	id_LavaTag,	0,	0,	$8680
	dbug	Map_Bas,	id_Basaran,	0,	0,	$4B8
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	$24FF
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
.MZend:

.SLZ:
	dc.w (.SLZend-.SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Elev,	id_Elevator,	0,	0,	$4000
	dbug	Map_CFlo,	id_CollapseFloor, 0,	2,	$44E0
	dbug	Map_Plat_SLZ,	id_BasicPlatform, 0,	0,	$4000
	dbug	Map_Circ,	id_CirclingPlatform, 0,	0,	$4000
	dbug	Map_Stair,	id_Staircase,	0,	0,	$4000
	dbug	Map_Fan,	id_Fan,		0,	0,	$43A0
	dbug	Map_Seesaw,	id_Seesaw,	0,	0,	$374
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	$480
	dbug	Map_Scen,	id_Scenery,	0,	0,	$44D8
	dbug	Map_Bomb,	id_Bomb,	0,	0,	$400
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	$2429
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
.SLZend:

.SYZ:
	dc.w (.SYZend-.SYZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Roll,	id_Roller,	0,	0,	$4B8
	dbug	Map_Light,	id_SpinningLight, 0,	0,	0
	dbug	Map_Bump,	id_Bumper,	0,	0,	$380
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Yad,	id_Yadrin,	0,	0,	$247B
	dbug	Map_Plat_SYZ,	id_BasicPlatform, 0,	0,	$4000
	dbug	Map_FBlock,	id_FloatingBlock, 0,	0,	$4000
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	$24FF
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
.SYZend:

.SBZ:
	dc.w (.SBZend-.SBZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Bomb,	id_Bomb,	0,	0,	$400
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	$429
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	$22B0
	dbug	Map_BBall,	id_SwingingPlatform, 7,	2,	$4391
	dbug	Map_Disc,	id_RunningDisc,	$E0,	0,	$C344
	dbug	Map_MBlock,	id_MovingBlock,	$28,	2,	$22C0
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Trap,	id_SpinPlatform, 3,	0,	$4492
	dbug	Map_Spin,	id_SpinPlatform, $83,	0,	$4DF
	dbug	Map_Saw,	id_Saws,	2,	0,	$43B5
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	$43F5
	dbug	Map_MBlock,	id_MovingBlock,	$39,	3,	$4460
	dbug	Map_Stomp,	id_ScrapStomp,	0,	0,	$22C0
	dbug	Map_ADoor,	id_AutoDoor,	0,	0,	$42E8
	dbug	Map_Stomp,	id_ScrapStomp,	$13,	1,	$22C0
	dbug	Map_Saw,	id_Saws,	1,	0,	$43B5
	dbug	Map_Stomp,	id_ScrapStomp,	$24,	1,	$22C0
	dbug	Map_Saw,	id_Saws,	4,	2,	$43B5
	dbug	Map_Stomp,	id_ScrapStomp,	$34,	1,	$22C0
	dbug	Map_VanP,	id_VanishPlatform, 0,	0,	$44C3
	dbug	Map_Flame,	id_Flamethrower, $64,	0,	$83D9
	dbug	Map_Flame,	id_Flamethrower, $64,	$B,	$83D9
	dbug	Map_Elec,	id_Electro,	4,	0,	$47E
	dbug	Map_Gird,	id_Girder,	0,	0,	$42F0
	dbug	Map_Invis,	id_Invisibarrier, $11,	0,	$8680
	dbug	Map_Hog,	id_BallHog,	4,	0,	$2302
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
.SBZend:

.Ending:
	dc.w (.Endingend-.Ending-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	if Revision=0
	dbug	Map_Bump,	id_Bumper,	0,	0,	$380
	dbug	Map_Animal2,	id_Animals,	$A,	0,	$5A0
	dbug	Map_Animal2,	id_Animals,	$B,	0,	$5A0
	dbug	Map_Animal2,	id_Animals,	$C,	0,	$5A0
	dbug	Map_Animal1,	id_Animals,	$D,	0,	$553
	dbug	Map_Animal1,	id_Animals,	$E,	0,	$553
	dbug	Map_Animal1,	id_Animals,	$F,	0,	$573
	dbug	Map_Animal1,	id_Animals,	$10,	0,	$573
	dbug	Map_Animal2,	id_Animals,	$11,	0,	$585
	dbug	Map_Animal3,	id_Animals,	$12,	0,	$593
	dbug	Map_Animal2,	id_Animals,	$13,	0,	$565
	dbug	Map_Animal3,	id_Animals,	$14,	0,	$5B3
	else
	dbug	Map_Ring,	id_Rings,	0,	8,	$27B2
	endif
.Endingend:

	even