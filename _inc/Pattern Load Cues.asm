; ===========================================================================
; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------

; Macro to define PLC pointer entry
plcptr:		macro plc,{INTLABEL}
__LABEL__:	label	(*-ArtLoadCues)/2
		dc.w	plc-ArtLoadCues
		endm

; Macro for the header of a PLC list
plcheader:	macro {INTLABEL}
__LABEL__:	label	*
		dc.w ((__LABEL___end-__LABEL__-2)/6)-1
		endm

; Macro for single pattern load cue entry
plcm:		macro gfx,vram
		dc.l gfx
		dc.w (vram)*tile_size
		endm

; ---------------------------------------------------------------------------

; Index and ID definitions
ArtLoadCues:

plcid_Main:		plcptr	PLC_Main
plcid_Main2:		plcptr	PLC_Main2
plcid_Explode:		plcptr	PLC_Explode
plcid_GameOver:		plcptr	PLC_GameOver

	PLC_Levels:
plcid_GHZ:		plcptr	PLC_GHZ
plcid_GHZ2:		plcptr	PLC_GHZ2
plcid_LZ:		plcptr	PLC_LZ
plcid_LZ2:		plcptr	PLC_LZ2
plcid_MZ:		plcptr	PLC_MZ
plcid_MZ2:		plcptr	PLC_MZ2
plcid_SLZ:		plcptr	PLC_SLZ
plcid_SLZ2:		plcptr	PLC_SLZ2
plcid_SYZ:		plcptr	PLC_SYZ
plcid_SYZ2:		plcptr	PLC_SYZ2
plcid_SBZ:		plcptr	PLC_SBZ
plcid_SBZ2:		plcptr	PLC_SBZ2
	zonewarning PLC_Levels,4

plcid_TitleCard:	plcptr	PLC_TitleCard
plcid_Boss:		plcptr	PLC_Boss
plcid_Signpost:		plcptr	PLC_Signpost
plcid_Warp:		plcptr	PLC_Warp
plcid_SpecialStage:	plcptr	PLC_SpecialStage

	PLC_Animals:
plcid_GHZAnimals:	plcptr	PLC_GHZAnimals
plcid_LZAnimals:	plcptr	PLC_LZAnimals
plcid_MZAnimals:	plcptr	PLC_MZAnimals
plcid_SLZAnimals:	plcptr	PLC_SLZAnimals
plcid_SYZAnimals:	plcptr	PLC_SYZAnimals
plcid_SBZAnimals:	plcptr	PLC_SBZAnimals
	zonewarning PLC_Animals,2

plcid_SSResult:		plcptr	PLC_SSResult
plcid_Ending:		plcptr	PLC_Ending
plcid_TryAgain:		plcptr	PLC_TryAgain
plcid_EggmanSBZ2:	plcptr	PLC_EggmanSBZ2
plcid_FZBoss:		plcptr	PLC_FZBoss

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	plcheader
		plcm	Nem_Lamp,	ArtTile_Lamppost		; lamppost
		plcm	Nem_Hud,	ArtTile_HUD			; HUD
		plcm	Nem_Lives,	ArtTile_Lives_Counter		; lives counter
		plcm	Nem_Ring,	ArtTile_Ring			; rings
		plcm	Nem_Points,	ArtTile_Points			; points from enemy
PLC_Main_end:

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	plcheader
		plcm	Nem_Monitors,	ArtTile_Monitor			; monitors
		plcm	Nem_Shield,	ArtTile_Shield			; shield
		plcm	Nem_Stars,	ArtTile_Invincibility		; invincibility stars
PLC_Main2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	plcheader
		plcm	Nem_Explode,	ArtTile_Explosion		; explosion
PLC_Explode_end:

; ---------------------------------------------------------------------------
; Pattern load cues - game/time over
; ---------------------------------------------------------------------------
PLC_GameOver:	plcheader
		plcm	Nem_GameOver,	ArtTile_Game_Over		; game/time over
PLC_GameOver_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	plcheader
		plcm	Nem_GHZ_1st,	ArtTile_Level			; GHZ main patterns
		plcm	Nem_GHZ_2nd,	ArtTile_Level+$1CD		; GHZ secondary patterns
		plcm	Nem_Stalk,	ArtTile_GHZ_Flower_Stalk	; flower stalk
		plcm	Nem_PplRock,	ArtTile_GHZ_Purple_Rock		; purple rock
		plcm	Nem_Crabmeat,	ArtTile_Crabmeat		; crabmeat enemy
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_Chopper,	ArtTile_Chopper			; chopper enemy
		plcm	Nem_Newtron,	ArtTile_Newtron			; newtron enemy
		plcm	Nem_Motobug,	ArtTile_Moto_Bug		; motobug enemy
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_GHZ_end:

PLC_GHZ2:	plcheader
		plcm	Nem_Swing,	ArtTile_GHZ_MZ_Swing		; swinging platform
		plcm	Nem_Bridge,	ArtTile_GHZ_Bridge		; bridge
		plcm	Nem_SpikePole,	ArtTile_GHZ_Spike_Pole		; spiked pole
		plcm	Nem_Ball,	ArtTile_GHZ_Giant_Ball		; giant ball
		plcm	Nem_GhzWall1,	ArtTile_GHZ_SLZ_Smashable_Wall	; breakable wall
		plcm	Nem_GhzWall2,	ArtTile_GHZ_Edge_Wall		; normal wall
PLC_GHZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		plcheader
		plcm	Nem_LZ,		ArtTile_Level			; LZ main patterns
		plcm	Nem_LzBlock1,	ArtTile_LZ_Block_1		; block
		plcm	Nem_LzBlock2,	ArtTile_LZ_Block_2		; blocks
		plcm	Nem_Splash,	ArtTile_LZ_Splash		; waterfalls and splash
		plcm	Nem_Water,	ArtTile_LZ_Water_Surface	; water surface
		plcm	Nem_LzSpikeBall, ArtTile_LZ_Spikeball_Chain	; spiked ball
		plcm	Nem_FlapDoor,	ArtTile_LZ_Flapping_Door	; flapping door
		plcm	Nem_Bubbles,	ArtTile_LZ_Bubbles		; bubbles and numbers
		plcm	Nem_LzBlock3,	ArtTile_LZ_Moving_Block		; block
		plcm	Nem_LzDoor1,	ArtTile_LZ_Door			; vertical door
		plcm	Nem_Harpoon,	ArtTile_LZ_Harpoon		; harpoon
		plcm	Nem_Burrobot,	ArtTile_Burrobot		; burrobot enemy
PLC_LZ_end:

PLC_LZ2:	plcheader
		plcm	Nem_LzPole,	ArtTile_LZ_Pole			; pole that breaks
		plcm	Nem_LzDoor2,	ArtTile_LZ_Blocks		; large horizontal door
		plcm	Nem_LzWheel,	ArtTile_LZ_Conveyor_Belt	; wheel
		plcm	Nem_Gargoyle,	ArtTile_LZ_Gargoyle		; gargoyle head
	if Revision=0
		plcm	Nem_LzSonic,	ArtTile_LZ_UnusedFace		; unused face of Sonic holding his breath
	endif
		plcm	Nem_LzPlatfm,	ArtTile_LZ_Rising_Platform	; rising platform
		plcm	Nem_Orbinaut,	ArtTile_LZ_Orbinaut		; orbinaut enemy
		plcm	Nem_Jaws,	ArtTile_Jaws			; jaws enemy
		plcm	Nem_LzSwitch,	ArtTile_Button			; switch
		plcm	Nem_Cork,	ArtTile_LZ_Cork			; cork block
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_LZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Marble
; ---------------------------------------------------------------------------
PLC_MZ:		plcheader
		plcm	Nem_MZ,	ArtTile_Level				; MZ main patterns
		plcm	Nem_MzMetal,	ArtTile_MZ_Spike_Stomper	; metal blocks
		plcm	Nem_MzFire,	ArtTile_MZ_Fireball		; fireballs
		plcm	Nem_Swing,	ArtTile_GHZ_MZ_Swing		; swinging platform
		plcm	Nem_MzGlass,	ArtTile_MZ_Glass_Pillar		; green glassy block
		plcm	Nem_Lava,	ArtTile_MZ_Lava			; lava
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_Yadrin,	ArtTile_Yadrin			; yadrin enemy
		plcm	Nem_Basaran,	ArtTile_Basaran			; basaran enemy
		plcm	Nem_Cater,	ArtTile_MZ_SYZ_Caterkiller	; caterkiller enemy
PLC_MZ_end:

PLC_MZ2:	plcheader
		plcm	Nem_MzSwitch,	ArtTile_Button_Main		; switch
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
		plcm	Nem_MzBlock,	ArtTile_MZ_Block		; green stone block
PLC_MZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Star Light
; ---------------------------------------------------------------------------
PLC_SLZ:	plcheader
		plcm	Nem_SLZ,	ArtTile_Level			; SLZ main patterns
		plcm	Nem_Bomb,	ArtTile_Bomb			; bomb enemy
		plcm	Nem_Orbinaut,	ArtTile_SLZ_Orbinaut		; orbinaut enemy
		plcm	Nem_MzFire,	ArtTile_SLZ_Fireball		; fireballs
		plcm	Nem_SlzBlock,	ArtTile_SLZ_Collapsing_Floor	; block
		plcm	Nem_SlzWall,	ArtTile_GHZ_SLZ_Smashable_Wall+4 ; breakable wall
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_SLZ_end:

PLC_SLZ2:	plcheader
		plcm	Nem_Seesaw,	ArtTile_SLZ_Seesaw		; seesaw
		plcm	Nem_Fan,	ArtTile_SLZ_Fan			; fan
		plcm	Nem_Pylon,	ArtTile_SLZ_Pylon		; foreground pylon
		plcm	Nem_SlzSwing,	ArtTile_SLZ_Swing		; swinging platform
		plcm	Nem_SlzCannon,	ArtTile_SLZ_Fireball_Launcher	; fireball launcher
		plcm	Nem_SlzSpike,	ArtTile_SLZ_Spikeball		; spikeball
PLC_SLZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Spring Yard
; ---------------------------------------------------------------------------
PLC_SYZ:	plcheader
		plcm	Nem_SYZ,	ArtTile_Level			; SYZ main patterns
		plcm	Nem_Crabmeat,	ArtTile_Crabmeat		; crabmeat enemy
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_Yadrin,	ArtTile_Yadrin			; yadrin enemy
		plcm	Nem_Roller,	ArtTile_Roller			; roller enemy
PLC_SYZ_end:

PLC_SYZ2:	plcheader
		plcm	Nem_Bumper,	ArtTile_SYZ_Bumper		; bumper
		plcm	Nem_SyzSpike1,	ArtTile_SYZ_Big_Spikeball	; large spikeball
		plcm	Nem_SyzSpike2,	ArtTile_SYZ_Spikeball_Chain	; small spikeball
	if FixBugs=0
		; Despite being unused, this corrupts the Roller's graphics
		plcm	Nem_Cater,	ArtTile_MZ_SYZ_Caterkiller	; caterkiller enemy
	endif
		plcm	Nem_LzSwitch,	ArtTile_Button			; switch
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_SYZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Scrap Brain
; ---------------------------------------------------------------------------
PLC_SBZ:	plcheader
		plcm	Nem_SBZ,	ArtTile_Level			; SBZ main patterns
		plcm	Nem_Stomper,	ArtTile_SBZ_Moving_Block_Short	; moving platform and stomper
		plcm	Nem_SbzDoor1,	ArtTile_SBZ_Door		; door
		plcm	Nem_Girder,	ArtTile_SBZ_Girder		; girder
		plcm	Nem_BallHog,	ArtTile_Ball_Hog		; ball hog enemy
		plcm	Nem_SbzWheel1,	ArtTile_SBZ_Disc		; spot on large wheel
		plcm	Nem_SbzWheel2,	ArtTile_SBZ_Junction		; wheel that grabs Sonic
		plcm	Nem_SyzSpike1,	ArtTile_SBZ_Swing		; large spikeball
		plcm	Nem_Cutter,	ArtTile_SBZ_Saw			; pizza cutter
		plcm	Nem_FlamePipe,	ArtTile_SBZ_Flamethrower	; flaming pipe
		plcm	Nem_SbzFloor,	ArtTile_SBZ_Collapsing_Floor	; collapsing floor
		plcm	Nem_SbzBlock,	ArtTile_SBZ_Vanishing_Block	; vanishing block
PLC_SBZ_end:

PLC_SBZ2:	plcheader
		plcm	Nem_Cater,	ArtTile_SBZ_Caterkiller		; caterkiller enemy
		plcm	Nem_Bomb,	ArtTile_Bomb			; bomb enemy
		plcm	Nem_Orbinaut,	ArtTile_SBZ_Orbinaut		; orbinaut enemy
		plcm	Nem_SlideFloor,	ArtTile_SBZ_Moving_Block_Long	; floor that slides away
		plcm	Nem_SbzDoor2,	ArtTile_SBZ_Horizontal_Door	; horizontal door
		plcm	Nem_Electric,	ArtTile_SBZ_Electric_Orb	; electric orb
		plcm	Nem_TrapDoor,	ArtTile_SBZ_Trap_Door		; trapdoor
		plcm	Nem_SbzFloor,	ArtTile_SBZ_Collapsing_Floor+4	; collapsing floor
		plcm	Nem_SpinPform,	ArtTile_SBZ_Spinning_Platform	; small spinning platform
		plcm	Nem_LzSwitch,	ArtTile_Button			; switch
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_SBZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	plcheader
		plcm	Nem_TitleCard,	ArtTile_Title_Card
PLC_TitleCard_end:

; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	plcheader
		plcm	Nem_Eggman,	ArtTile_Eggman			; Eggman main patterns
		plcm	Nem_Weapons,	ArtTile_Eggman_Weapons		; Eggman's weapons
		plcm	Nem_Prison,	ArtTile_Prison_Capsule		; prison capsule
		plcm	Nem_Bomb,	ArtTile_Eggman_Spikeball	; bomb enemy (gets overwritten)
		plcm	Nem_SlzSpike,	ArtTile_Eggman_Spikeball	; spikeball (SLZ boss)
		plcm	Nem_Exhaust,	ArtTile_Eggman_Exhaust		; exhaust flame
PLC_Boss_end:

; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	plcheader
		plcm	Nem_SignPost,	ArtTile_Signpost		; signpost
		plcm	Nem_Bonus,	ArtTile_Hidden_Points		; hidden bonus points
		plcm	Nem_BigFlash,	ArtTile_Giant_Ring_Flash	; giant ring flash effect
PLC_Signpost_end:

; ---------------------------------------------------------------------------
; Pattern load cues - beta special stage warp effect
; ---------------------------------------------------------------------------
PLC_Warp:
	if Revision=0
PLC_WarpRev0:	plcheader
		plcm	Nem_Warp,	ArtTile_Warp
PLC_WarpRev0_end:
	endif

; ---------------------------------------------------------------------------
; Pattern load cues - special stage
; ---------------------------------------------------------------------------
PLC_SpecialStage:	plcheader
		plcm	Nem_SSBgCloud,	ArtTile_SS_Background_Clouds	; bubble and cloud background
		plcm	Nem_SSBgFish,	ArtTile_SS_Background_Fish	; bird and fish background
		plcm	Nem_SSWalls,	ArtTile_SS_Wall			; walls
		plcm	Nem_Bumper,	ArtTile_SS_Bumper		; bumper
		plcm	Nem_SSGOAL,	ArtTile_SS_Goal			; GOAL block
		plcm	Nem_SSUpDown,	ArtTile_SS_Up_Down		; UP and DOWN blocks
		plcm	Nem_SSRBlock,	ArtTile_SS_R_Block		; R block
		plcm	Nem_SS1UpBlock,	ArtTile_SS_Extra_Life		; 1UP block
		plcm	Nem_SSEmStars,	ArtTile_SS_Emerald_Sparkle	; emerald collection stars
		plcm	Nem_SSRedWhite,	ArtTile_SS_Red_White_Block	; red and white block
		plcm	Nem_SSGhost,	ArtTile_SS_Ghost_Block		; ghost block
		plcm	Nem_SSWBlock,	ArtTile_SS_W_Block		; W block
		plcm	Nem_SSGlass,	ArtTile_SS_Glass		; glass block
		plcm	Nem_SSEmerald,	ArtTile_SS_Emerald		; emeralds
		plcm	Nem_SSZone1,	ArtTile_SS_Zone_1		; ZONE 1 block
		plcm	Nem_SSZone2,	ArtTile_SS_Zone_2		; ZONE 2 block
		plcm	Nem_SSZone3,	ArtTile_SS_Zone_3		; ZONE 3 block
PLC_SpecialStage_end:

		; Unused
		plcm	Nem_SSZone4,	ArtTile_SS_Zone_4		; ZONE 4 block
		plcm	Nem_SSZone5,	ArtTile_SS_Zone_5		; ZONE 5 block
		plcm	Nem_SSZone6,	ArtTile_SS_Zone_6		; ZONE 6 block

; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	plcheader
		plcm	Nem_Rabbit,	ArtTile_Animal_1		; rabbit
		plcm	Nem_Flicky,	ArtTile_Animal_2		; flicky
PLC_GHZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	plcheader
		plcm	Nem_Penguin,	ArtTile_Animal_1		; penguin
		plcm	Nem_Seal,	ArtTile_Animal_2		; seal
PLC_LZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	plcheader
		plcm	Nem_Squirrel,	ArtTile_Animal_1		; squirrel
		plcm	Nem_Seal,	ArtTile_Animal_2		; seal
PLC_MZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - SLZ animals
; ---------------------------------------------------------------------------
PLC_SLZAnimals:	plcheader
		plcm	Nem_Pig,	ArtTile_Animal_1		; pig
		plcm	Nem_Flicky,	ArtTile_Animal_2		; flicky
PLC_SLZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - SYZ animals
; ---------------------------------------------------------------------------
PLC_SYZAnimals:	plcheader
		plcm	Nem_Pig,	ArtTile_Animal_1		; pig
		plcm	Nem_Chicken,	ArtTile_Animal_2		; chicken
PLC_SYZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - SBZ animals
; ---------------------------------------------------------------------------
PLC_SBZAnimals:	plcheader
		plcm	Nem_Rabbit,	ArtTile_Animal_1		; rabbit
		plcm	Nem_Chicken,	ArtTile_Animal_2		; chicken
PLC_SBZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - special stage results screen
; ---------------------------------------------------------------------------
PLC_SSResult:	plcheader
		plcm	Nem_ResultEm,	ArtTile_SS_Results_Emeralds	; emeralds
		plcm	Nem_MiniSonic,	ArtTile_Mini_Sonic		; mini Sonic
PLC_SSResult_end:

; ---------------------------------------------------------------------------
; Pattern load cues - ending sequence
; ---------------------------------------------------------------------------
PLC_Ending:	plcheader
		plcm	Nem_GHZ_1st,	ArtTile_Level			; GHZ main patterns
		plcm	Nem_GHZ_2nd,	ArtTile_Level+$1CD		; GHZ secondary patterns
		plcm	Nem_Stalk,	ArtTile_GHZ_Flower_Stalk	; flower stalk
		plcm	Nem_EndFlower,	ArtTile_Ending_Flowers		; flowers
		plcm	Nem_EndEm,	ArtTile_Ending_Emeralds		; emeralds
		plcm	Nem_EndSonic,	ArtTile_Ending_Sonic		; Sonic
	if Revision=0
		plcm	Nem_EndEggman,	ArtTile_Ending_Eggman		; Eggman's death (unused)
	endif
		plcm	Nem_Rabbit,	ArtTile_Ending_Rabbit		; rabbit
		plcm	Nem_Chicken,	ArtTile_Ending_Chicken		; chicken
		plcm	Nem_Penguin,	ArtTile_Ending_Penguin		; penguin
		plcm	Nem_Seal,	ArtTile_Ending_Seal		; seal
		plcm	Nem_Pig,	ArtTile_Ending_Pig		; pig
		plcm	Nem_Flicky,	ArtTile_Ending_Flicky		; flicky
		plcm	Nem_Squirrel,	ArtTile_Ending_Squirrel		; squirrel
		plcm	Nem_EndStH,	ArtTile_Ending_STH		; "SONIC THE HEDGEHOG"
PLC_Ending_end:

; ---------------------------------------------------------------------------
; Pattern load cues - "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------
PLC_TryAgain:	plcheader
		plcm	Nem_EndEm,	ArtTile_Try_Again_Emeralds	; emeralds
		plcm	Nem_TryAgain,	ArtTile_Try_Again_Eggman	; Eggman
		plcm	Nem_CreditText,	ArtTile_Credits_Font		; credits alphabet
PLC_TryAgain_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Eggman on SBZ 2
; ---------------------------------------------------------------------------
PLC_EggmanSBZ2:	plcheader
		plcm	Nem_SbzBlock,	ArtTile_Eggman_Trap_Floor	; block
		plcm	Nem_Sbz2Eggman,	ArtTile_Eggman			; Eggman
		plcm	Nem_LzSwitch,	ArtTile_Eggman_Button-4		; switch
PLC_EggmanSBZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - final boss
; ---------------------------------------------------------------------------
PLC_FZBoss:	plcheader
		plcm	Nem_FzEggman,	ArtTile_FZ_Eggman_Fleeing	; Eggman after boss
		plcm	Nem_FzBoss,	ArtTile_FZ_Boss			; FZ boss
		plcm	Nem_Eggman,	ArtTile_Eggman			; Eggman main patterns
		plcm	Nem_Sbz2Eggman,	ArtTile_FZ_Eggman_No_Vehicle	; Eggman without ship
		plcm	Nem_Exhaust,	ArtTile_Eggman_Exhaust		; exhaust flame
PLC_FZBoss_end:
