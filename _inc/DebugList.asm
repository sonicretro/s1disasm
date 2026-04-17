; ---------------------------------------------------------------------------
; Debug mode item lists
; ---------------------------------------------------------------------------
DebugList:	offsetTable
		ptr .GHZ
		ptr .LZ
		ptr .MZ
		ptr .SLZ
		ptr .SYZ
		ptr .SBZ
		zonewarning DebugList,2
		ptr .Ending

dbug:	macro map,object,subtype,frame,vram
		dc.l map+(object<<24)
		dc.b subtype,frame
		dc.w vram
		endm

.GHZ:
		dc.w (.GHZend-.GHZ-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,	0,	0,	ArtTile_Monitor
		dbug	Map_Crab,	id_Crabmeat,	0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Chop,	id_Chopper,	0,	0,	ArtTile_Chopper
		dbug	Map_Spike,	id_Spikes,	0,	0,	ArtTile_Spikes
		dbug	Map_Plat_GHZ,	id_BasicPlatform, 0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_PRock,	id_PurpleRock,	0,	0,	ArtTile_GHZ_Purple_Rock|Tile_Pal4
		dbug	Map_Moto,	id_MotoBug,	0,	0,	ArtTile_Moto_Bug
		dbug	Map_Spring,	id_Springs,	0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Newt,	id_Newtron,	0,	0,	ArtTile_Newtron|Tile_Pal2
		dbug	Map_Edge,	id_EdgeWalls,	0,	0,	ArtTile_GHZ_Edge_Wall|Tile_Pal3
		dbug	Map_GBall,	id_Obj19,	0,	0,	ArtTile_GHZ_Giant_Ball|Tile_Pal3
		dbug	Map_Lamp,	id_Lamppost,	1,	0,	ArtTile_Lamppost
		dbug	Map_GRing,	id_GiantRing,	0,	0,	ArtTile_Giant_Ring|Tile_Pal2
		dbug	Map_Bonus,	id_HiddenBonus,	1,	1,	ArtTile_Hidden_Points|Tile_Prio
.GHZend:

.LZ:
		dc.w (.LZend-.LZ-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,	0,	0,	ArtTile_Monitor
		dbug	Map_Spring,	id_Springs,	0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Jaws,	id_Jaws,	8,	0,	ArtTile_Jaws|Tile_Pal2
		dbug	Map_Burro,	id_Burrobot,	0,	2,	ArtTile_Burrobot|Tile_Prio
		dbug	Map_Harp,	id_Harpoon,	0,	0,	ArtTile_LZ_Harpoon
		dbug	Map_Harp,	id_Harpoon,	2,	3,	ArtTile_LZ_Harpoon
		dbug	Map_Push,	id_PushBlock,	0,	0,	ArtTile_LZ_Push_Block|Tile_Pal3
		dbug	Map_But,	id_Button,	0,	0,	ArtTile_Button+4
		dbug	Map_Spike,	id_Spikes,	0,	0,	ArtTile_Spikes
		dbug	Map_MBlockLZ,	id_MovingBlock,	4,	0,	ArtTile_LZ_Moving_Block|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock, 1,	0,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock, $13,	1,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock, 5,	0,	ArtTile_LZ_Blocks|Tile_Pal3
	if FixBugs
		dbug	Map_Gar,	id_Gargoyle,	0,	0,	ArtTile_LZ_Gargoyle|Tile_Pal3
	else
		dbug	Map_Gar,	id_Gargoyle,	0,	0,	(ArtTile_LZ_Sonic_Drowning-2)|Tile_Pal3 ; Incorrect VRAM address.
	endif
		dbug	Map_LBlock,	id_LabyrinthBlock, $27,	2,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LBlock,	id_LabyrinthBlock, $30,	3,	ArtTile_LZ_Blocks|Tile_Pal3
		dbug	Map_LConv,	id_LabyrinthConvey, $7F, 0,	ArtTile_LZ_Conveyor_Belt
		dbug	Map_Orb,	id_Orbinaut,	0,	0,	ArtTile_LZ_Orbinaut
		dbug	Map_Bub,	id_Bubble,	$84,	$13,	ArtTile_LZ_Bubbles|Tile_Prio
		dbug	Map_WFall,	id_Waterfall,	2,	2,	ArtTile_LZ_Splash|Tile_Pal3|Tile_Prio
		dbug	Map_WFall,	id_Waterfall,	9,	9,	ArtTile_LZ_Splash|Tile_Pal3|Tile_Prio
		dbug	Map_Pole,	id_Pole,	0,	0,	ArtTile_LZ_Pole|Tile_Pal3
		dbug	Map_Flap,	id_FlapDoor,	2,	0,	ArtTile_LZ_Flapping_Door|Tile_Pal3
		dbug	Map_Lamp,	id_Lamppost,	1,	0,	ArtTile_Lamppost
.LZend:

.MZ:
		dc.w (.MZend-.MZ-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,	0,	0,	ArtTile_Monitor
		dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Spike,	id_Spikes,	0,	0,	ArtTile_Spikes
		dbug	Map_Spring,	id_Springs,	0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Fire,	id_LavaMaker,	0,	0,	ArtTile_MZ_Fireball
		dbug	Map_Brick,	id_MarbleBrick,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	ArtTile_MZ_Lava|Tile_Pal4
		dbug	Map_LWall,	id_LavaWall,	0,	0,	ArtTile_MZ_Lava|Tile_Pal4
		dbug	Map_Push,	id_PushBlock,	0,	0,	ArtTile_MZ_Block|Tile_Pal3
		dbug	Map_Yad,	id_Yadrin,	0,	0,	ArtTile_Yadrin|Tile_Pal2
		dbug	Map_Smab,	id_SmashBlock,	0,	0,	ArtTile_MZ_Block|Tile_Pal3
	if FixBugs
		dbug	Map_MBlock,	id_MovingBlock,	0,	0,	ArtTile_MZ_Block|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	ArtTile_MZ_Block|Tile_Pal3
	else
		dbug	Map_MBlock,	id_MovingBlock,	0,	0,	ArtTile_MZ_Block ; Incorrect palette line.
		dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	ArtTile_MZ_Block|Tile_Pal4 ; Incorrect palette line.
	endif
		dbug	Map_LTag,	id_LavaTag,	0,	0,	ArtTile_Monitor|Tile_Prio
		dbug	Map_Bas,	id_Basaran,	0,	0,	ArtTile_Basaran
		dbug	Map_Cat,	id_Caterkiller,	0,	0,	ArtTile_MZ_SYZ_Caterkiller|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,	1,	0,	ArtTile_Lamppost
.MZend:

.SLZ:
		dc.w (.SLZend-.SLZ-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,	0,	0,	ArtTile_Monitor
		dbug	Map_Elev,	id_Elevator,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor, 0,	2,	ArtTile_SLZ_Collapsing_Floor|Tile_Pal3
		dbug	Map_Plat_SLZ,	id_BasicPlatform, 0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Circ,	id_CirclingPlatform, 0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Stair,	id_Staircase,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Fan,	id_Fan,		0,	0,	ArtTile_SLZ_Fan|Tile_Pal3
		dbug	Map_Seesaw,	id_Seesaw,	0,	0,	ArtTile_SLZ_Seesaw
		dbug	Map_Spring,	id_Springs,	0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Fire,	id_LavaMaker,	0,	0,	ArtTile_SLZ_Fireball
		dbug	Map_Scen,	id_Scenery,	0,	0,	ArtTile_SLZ_Fireball_Launcher|Tile_Pal3
		dbug	Map_Bomb,	id_Bomb,	0,	0,	ArtTile_Bomb
		dbug	Map_Orb,	id_Orbinaut,	0,	0,	ArtTile_SLZ_Orbinaut|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,	1,	0,	ArtTile_Lamppost
.SLZend:

.SYZ:
		dc.w (.SYZend-.SYZ-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,	0,	0,	ArtTile_Monitor
		dbug	Map_Spike,	id_Spikes,	0,	0,	ArtTile_Spikes
		dbug	Map_Spring,	id_Springs,	0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Roll,	id_Roller,	0,	0,	ArtTile_Roller
		dbug	Map_Light,	id_SpinningLight, 0,	0,	ArtTile_Level
		dbug	Map_Bump,	id_Bumper,	0,	0,	ArtTile_SYZ_Bumper
		dbug	Map_Crab,	id_Crabmeat,	0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Yad,	id_Yadrin,	0,	0,	ArtTile_Yadrin|Tile_Pal2
		dbug	Map_Plat_SYZ,	id_BasicPlatform, 0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_FBlock,	id_FloatingBlock, 0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_But,	id_Button,	0,	0,	ArtTile_Button+4
		dbug	Map_Cat,	id_Caterkiller,	0,	0,	ArtTile_MZ_SYZ_Caterkiller|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,	1,	0,	ArtTile_Lamppost
.SYZend:

.SBZ:
		dc.w (.SBZend-.SBZ-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,	0,	0,	ArtTile_Monitor
		dbug	Map_Bomb,	id_Bomb,	0,	0,	ArtTile_Bomb
		dbug	Map_Orb,	id_Orbinaut,	0,	0,	ArtTile_SBZ_Orbinaut
		dbug	Map_Cat,	id_Caterkiller,	0,	0,	ArtTile_SBZ_Caterkiller|Tile_Pal2
		dbug	Map_BBall,	id_SwingingPlatform, 7,	2,	ArtTile_SBZ_Swing|Tile_Pal3
		dbug	Map_Disc,	id_RunningDisc,	$E0,	0,	ArtTile_SBZ_Disc|Tile_Pal3|Tile_Prio
		dbug	Map_MBlock,	id_MovingBlock,	$28,	2,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_But,	id_Button,	0,	0,	ArtTile_Button+4
		dbug	Map_Trap,	id_SpinPlatform, 3,	0,	ArtTile_SBZ_Trap_Door|Tile_Pal3
		dbug	Map_Spin,	id_SpinPlatform, $83,	0,	ArtTile_SBZ_Spinning_Platform
		dbug	Map_Saw,	id_Saws,	2,	0,	ArtTile_SBZ_Saw|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	ArtTile_SBZ_Collapsing_Floor|Tile_Pal3
		dbug	Map_MBlock,	id_MovingBlock,	$39,	3,	ArtTile_SBZ_Moving_Block_Long|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,	0,	0,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_ADoor,	id_AutoDoor,	0,	0,	ArtTile_SBZ_Door|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,	$13,	1,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_Saw,	id_Saws,	1,	0,	ArtTile_SBZ_Saw|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,	$24,	1,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_Saw,	id_Saws,	4,	2,	ArtTile_SBZ_Saw|Tile_Pal3
		dbug	Map_Stomp,	id_ScrapStomp,	$34,	1,	ArtTile_SBZ_Moving_Block_Short|Tile_Pal2
		dbug	Map_VanP,	id_VanishPlatform, 0,	0,	ArtTile_SBZ_Vanishing_Block|Tile_Pal3
		dbug	Map_Flame,	id_Flamethrower, $64,	0,	ArtTile_SBZ_Flamethrower|Tile_Prio
		dbug	Map_Flame,	id_Flamethrower, $64,	$B,	ArtTile_SBZ_Flamethrower|Tile_Prio
		dbug	Map_Elec,	id_Electro,	4,	0,	ArtTile_SBZ_Electric_Orb
		dbug	Map_Gird,	id_Girder,	0,	0,	ArtTile_SBZ_Girder|Tile_Pal3
		dbug	Map_Invis,	id_Invisibarrier, $11,	0,	ArtTile_Monitor|Tile_Prio
		dbug	Map_Hog,	id_BallHog,	4,	0,	ArtTile_Ball_Hog|Tile_Pal2
		dbug	Map_Lamp,	id_Lamppost,	1,	0,	ArtTile_Lamppost
.SBZend:

.Ending:
		dc.w (.Endingend-.Ending-2)/8

;			mappings	object		subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,	0,	0,	ArtTile_Ring|Tile_Pal2
	if Revision=0
		dbug	Map_Bump,	id_Bumper,	0,	0,	ArtTile_SYZ_Bumper
		if FixBugs
			dbug	Map_Animal2,	id_Animals,	$A,	0,	ArtTile_Ending_Flicky
			dbug	Map_Animal2,	id_Animals,	$B,	0,	ArtTile_Ending_Flicky
			dbug	Map_Animal2,	id_Animals,	$C,	0,	ArtTile_Ending_Flicky
		else
			dbug	Map_Animal2,	id_Animals,	$A,	0,	ArtTile_Ending_Flicky-5
			dbug	Map_Animal2,	id_Animals,	$B,	0,	ArtTile_Ending_Flicky-5
			dbug	Map_Animal2,	id_Animals,	$C,	0,	ArtTile_Ending_Flicky-5
		endif
		dbug	Map_Animal1,	id_Animals,	$D,	0,	ArtTile_Ending_Rabbit
		dbug	Map_Animal1,	id_Animals,	$E,	0,	ArtTile_Ending_Rabbit
		dbug	Map_Animal1,	id_Animals,	$F,	0,	ArtTile_Ending_Penguin
		dbug	Map_Animal1,	id_Animals,	$10,	0,	ArtTile_Ending_Penguin
		dbug	Map_Animal2,	id_Animals,	$11,	0,	ArtTile_Ending_Seal
		dbug	Map_Animal3,	id_Animals,	$12,	0,	ArtTile_Ending_Pig
		dbug	Map_Animal2,	id_Animals,	$13,	0,	ArtTile_Ending_Chicken
		dbug	Map_Animal3,	id_Animals,	$14,	0,	ArtTile_Ending_Squirrel
	else
		dbug 	Map_Ring,	id_Rings,	0,	8,	ArtTile_Ring|Tile_Pal2
	endif
.Endingend:

		even
