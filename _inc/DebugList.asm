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
	zonewarning DebugList,2
	dc.w .Ending-DebugList

dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

.GHZ:
	dc.w (.GHZend-.GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	dbug	Map_Chop,	id_Chopper,	0,	0,	make_art_tile(ArtTile_Chopper,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Plat_GHZ,	id_BasicPlatform, 0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_PRock,	id_PurpleRock,	0,	0,	make_art_tile(ArtTile_GHZ_Purple_Rock,3,0)
	dbug	Map_Moto,	id_MotoBug,	0,	0,	make_art_tile(ArtTile_Moto_Bug,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Newt,	id_Newtron,	0,	0,	make_art_tile(ArtTile_Newtron,1,0)
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	make_art_tile(ArtTile_GHZ_Edge_Wall,2,0)
	dbug	Map_GBall,	id_Obj19,	0,	0,	make_art_tile(ArtTile_GHZ_Giant_Ball,2,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
	dbug	Map_GRing,	id_GiantRing,	0,	0,	make_art_tile(ArtTile_Giant_Ring,1,0)
	dbug	Map_Bonus,	id_HiddenBonus,	1,	1,	make_art_tile(ArtTile_Hidden_Points,0,1)
.GHZend:

.LZ:
	dc.w (.LZend-.LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Jaws,	id_Jaws,	8,	0,	make_art_tile(ArtTile_Jaws,1,0)
	dbug	Map_Burro,	id_Burrobot,	0,	2,	make_art_tile(ArtTile_Burrobot,0,1)
	dbug	Map_Harp,	id_Harpoon,	0,	0,	make_art_tile(ArtTile_LZ_Harpoon,0,0)
	dbug	Map_Harp,	id_Harpoon,	2,	3,	make_art_tile(ArtTile_LZ_Harpoon,0,0)
	dbug	Map_Push,	id_PushBlock,	0,	0,	make_art_tile(ArtTile_LZ_Push_Block,2,0)
	dbug	Map_But,	id_Button,	0,	0,	make_art_tile(ArtTile_Button+4,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_MBlockLZ,	id_MovingBlock,	4,	0,	make_art_tile(ArtTile_LZ_Moving_Block,2,0)
	dbug	Map_LBlock,	id_LabyrinthBlock, 1,	0,	make_art_tile(ArtTile_LZ_Blocks,2,0)
	dbug	Map_LBlock,	id_LabyrinthBlock, $13,	1,	make_art_tile(ArtTile_LZ_Blocks,2,0)
	dbug	Map_LBlock,	id_LabyrinthBlock, 5,	0,	make_art_tile(ArtTile_LZ_Blocks,2,0)
    if FixBugs
	dbug	Map_Gar,	id_Gargoyle,	0,	0,	make_art_tile(ArtTile_LZ_Gargoyle,2,0)
    else
	dbug	Map_Gar,	id_Gargoyle,	0,	0,	make_art_tile(ArtTile_LZ_Sonic_Drowning-2,2,0) ; Incorrect VRAM address.
    endif
	dbug	Map_LBlock,	id_LabyrinthBlock, $27,	2,	make_art_tile(ArtTile_LZ_Blocks,2,0)
	dbug	Map_LBlock,	id_LabyrinthBlock, $30,	3,	make_art_tile(ArtTile_LZ_Blocks,2,0)
	dbug	Map_LConv,	id_LabyrinthConvey, $7F, 0,	make_art_tile(ArtTile_LZ_Conveyor_Belt,0,0)
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	make_art_tile(ArtTile_LZ_Orbinaut,0,0)
	dbug	Map_Bub,	id_Bubble,	$84,	$13,	make_art_tile(ArtTile_LZ_Bubbles,0,1)
	dbug	Map_WFall,	id_Waterfall,	2,	2,	make_art_tile(ArtTile_LZ_Splash,2,1)
	dbug	Map_WFall,	id_Waterfall,	9,	9,	make_art_tile(ArtTile_LZ_Splash,2,1)
	dbug	Map_Pole,	id_Pole,	0,	0,	make_art_tile(ArtTile_LZ_Pole,2,0)
	dbug	Map_Flap,	id_FlapDoor,	2,	0,	make_art_tile(ArtTile_LZ_Flapping_Door,2,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
.LZend:

.MZ:
	dc.w (.MZend-.MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	make_art_tile(ArtTile_MZ_Fireball,0,0)
	dbug	Map_Brick,	id_MarbleBrick,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	make_art_tile(ArtTile_MZ_Lava,3,0)
	dbug	Map_LWall,	id_LavaWall,	0,	0,	make_art_tile(ArtTile_MZ_Lava,3,0)
	dbug	Map_Push,	id_PushBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,2,0)
	dbug	Map_Yad,	id_Yadrin,	0,	0,	make_art_tile(ArtTile_Yadrin,1,0)
	dbug	Map_Smab,	id_SmashBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,2,0)
	dbug	Map_MBlock,	id_MovingBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,0,0)
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	make_art_tile(ArtTile_MZ_Block,3,0)
	dbug	Map_LTag,	id_LavaTag,	0,	0,	make_art_tile(ArtTile_Monitor,0,1)
	dbug	Map_Bas,	id_Basaran,	0,	0,	make_art_tile(ArtTile_Basaran,0,0)
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	make_art_tile(ArtTile_MZ_SYZ_Caterkiller,1,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
.MZend:

.SLZ:
	dc.w (.SLZend-.SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Elev,	id_Elevator,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_CFlo,	id_CollapseFloor, 0,	2,	make_art_tile(ArtTile_SLZ_Collapsing_Floor,2,0)
	dbug	Map_Plat_SLZ,	id_BasicPlatform, 0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_Circ,	id_CirclingPlatform, 0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_Stair,	id_Staircase,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_Fan,	id_Fan,		0,	0,	make_art_tile(ArtTile_SLZ_Fan,2,0)
	dbug	Map_Seesaw,	id_Seesaw,	0,	0,	make_art_tile(ArtTile_SLZ_Seesaw,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	make_art_tile(ArtTile_SLZ_Fireball,0,0)
	dbug	Map_Scen,	id_Scenery,	0,	0,	make_art_tile(ArtTile_SLZ_Fireball_Launcher,2,0)
	dbug	Map_Bomb,	id_Bomb,	0,	0,	make_art_tile(ArtTile_Bomb,0,0)
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	make_art_tile(ArtTile_SLZ_Orbinaut,1,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
.SLZend:

.SYZ:
	dc.w (.SYZend-.SYZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Roll,	id_Roller,	0,	0,	make_art_tile(ArtTile_Roller,0,0)
	dbug	Map_Light,	id_SpinningLight, 0,	0,	make_art_tile(ArtTile_Level,0,0)
	dbug	Map_Bump,	id_Bumper,	0,	0,	make_art_tile(ArtTile_SYZ_Bumper,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	dbug	Map_Yad,	id_Yadrin,	0,	0,	make_art_tile(ArtTile_Yadrin,1,0)
	dbug	Map_Plat_SYZ,	id_BasicPlatform, 0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_FBlock,	id_FloatingBlock, 0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_But,	id_Button,	0,	0,	make_art_tile(ArtTile_Button+4,0,0)
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	make_art_tile(ArtTile_MZ_SYZ_Caterkiller,1,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
.SYZend:

.SBZ:
	dc.w (.SBZend-.SBZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Bomb,	id_Bomb,	0,	0,	make_art_tile(ArtTile_Bomb,0,0)
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	make_art_tile(ArtTile_SBZ_Orbinaut,0,0)
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	make_art_tile(ArtTile_SBZ_Caterkiller,1,0)
	dbug	Map_BBall,	id_SwingingPlatform, 7,	2,	make_art_tile(ArtTile_SBZ_Swing,2,0)
	dbug	Map_Disc,	id_RunningDisc,	$E0,	0,	make_art_tile(ArtTile_SBZ_Disc,2,1)
	dbug	Map_MBlock,	id_MovingBlock,	$28,	2,	make_art_tile(ArtTile_SBZ_Moving_Block_Short,1,0)
	dbug	Map_But,	id_Button,	0,	0,	make_art_tile(ArtTile_Button+4,0,0)
	dbug	Map_Trap,	id_SpinPlatform, 3,	0,	make_art_tile(ArtTile_SBZ_Trap_Door,2,0)
	dbug	Map_Spin,	id_SpinPlatform, $83,	0,	make_art_tile(ArtTile_SBZ_Spinning_Platform,0,0)
	dbug	Map_Saw,	id_Saws,	2,	0,	make_art_tile(ArtTile_SBZ_Saw,2,0)
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	make_art_tile(ArtTile_SBZ_Collapsing_Floor,2,0)
	dbug	Map_MBlock,	id_MovingBlock,	$39,	3,	make_art_tile(ArtTile_SBZ_Moving_Block_Long,2,0)
	dbug	Map_Stomp,	id_ScrapStomp,	0,	0,	make_art_tile(ArtTile_SBZ_Moving_Block_Short,1,0)
	dbug	Map_ADoor,	id_AutoDoor,	0,	0,	make_art_tile(ArtTile_SBZ_Door,2,0)
	dbug	Map_Stomp,	id_ScrapStomp,	$13,	1,	make_art_tile(ArtTile_SBZ_Moving_Block_Short,1,0)
	dbug	Map_Saw,	id_Saws,	1,	0,	make_art_tile(ArtTile_SBZ_Saw,2,0)
	dbug	Map_Stomp,	id_ScrapStomp,	$24,	1,	make_art_tile(ArtTile_SBZ_Moving_Block_Short,1,0)
	dbug	Map_Saw,	id_Saws,	4,	2,	make_art_tile(ArtTile_SBZ_Saw,2,0)
	dbug	Map_Stomp,	id_ScrapStomp,	$34,	1,	make_art_tile(ArtTile_SBZ_Moving_Block_Short,1,0)
	dbug	Map_VanP,	id_VanishPlatform, 0,	0,	make_art_tile(ArtTile_SBZ_Vanishing_Block,2,0)
	dbug	Map_Flame,	id_Flamethrower, $64,	0,	make_art_tile(ArtTile_SBZ_Flamethrower,0,1)
	dbug	Map_Flame,	id_Flamethrower, $64,	$B,	make_art_tile(ArtTile_SBZ_Flamethrower,0,1)
	dbug	Map_Elec,	id_Electro,	4,	0,	make_art_tile(ArtTile_SBZ_Electric_Orb,0,0)
	dbug	Map_Gird,	id_Girder,	0,	0,	make_art_tile(ArtTile_SBZ_Girder,2,0)
	dbug	Map_Invis,	id_Invisibarrier, $11,	0,	make_art_tile(ArtTile_Monitor,0,1)
	dbug	Map_Hog,	id_BallHog,	4,	0,	make_art_tile(ArtTile_Ball_Hog,1,0)
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	make_art_tile(ArtTile_Lamppost,0,0)
.SBZend:

.Ending:
	dc.w (.Endingend-.Ending-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
    if Revision=0
	dbug	Map_Bump,	id_Bumper,	0,	0,	make_art_tile(ArtTile_SYZ_Bumper,0,0)
    if FixBugs
	dbug	Map_Animal2,	id_Animals,	$A,	0,	make_art_tile(ArtTile_Ending_Flicky,0,0)
	dbug	Map_Animal2,	id_Animals,	$B,	0,	make_art_tile(ArtTile_Ending_Flicky,0,0)
	dbug	Map_Animal2,	id_Animals,	$C,	0,	make_art_tile(ArtTile_Ending_Flicky,0,0)
    else
	dbug	Map_Animal2,	id_Animals,	$A,	0,	make_art_tile(ArtTile_Ending_Flicky-5,0,0)
	dbug	Map_Animal2,	id_Animals,	$B,	0,	make_art_tile(ArtTile_Ending_Flicky-5,0,0)
	dbug	Map_Animal2,	id_Animals,	$C,	0,	make_art_tile(ArtTile_Ending_Flicky-5,0,0)
    endif
	dbug	Map_Animal1,	id_Animals,	$D,	0,	make_art_tile(ArtTile_Ending_Rabbit,0,0)
	dbug	Map_Animal1,	id_Animals,	$E,	0,	make_art_tile(ArtTile_Ending_Rabbit,0,0)
	dbug	Map_Animal1,	id_Animals,	$F,	0,	make_art_tile(ArtTile_Ending_Penguin,0,0)
	dbug	Map_Animal1,	id_Animals,	$10,	0,	make_art_tile(ArtTile_Ending_Penguin,0,0)
	dbug	Map_Animal2,	id_Animals,	$11,	0,	make_art_tile(ArtTile_Ending_Seal,0,0)
	dbug	Map_Animal3,	id_Animals,	$12,	0,	make_art_tile(ArtTile_Ending_Pig,0,0)
	dbug	Map_Animal2,	id_Animals,	$13,	0,	make_art_tile(ArtTile_Ending_Chicken,0,0)
	dbug	Map_Animal3,	id_Animals,	$14,	0,	make_art_tile(ArtTile_Ending_Squirrel,0,0)
    else
	dbug 	Map_Ring,	id_Rings,	0,	8,	make_art_tile(ArtTile_Ring,1,0)
    endif
.Endingend:

	even