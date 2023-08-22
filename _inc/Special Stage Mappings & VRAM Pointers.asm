; ---------------------------------------------------------------------------
; Special stage	mappings and VRAM pointers
; ---------------------------------------------------------------------------
specialStageData: macro frame,mappings,palette,vram
		dc.l	mappings|(frame<<24)
		dc.w	make_art_tile(vram,palette,0)
		endm

		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_Bump,      0, ArtTile_SS_Bumper
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_W_Block
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Goal
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Extra_Life
		specialStageData	0, Map_SS_Up,     0, ArtTile_SS_Up_Down
		specialStageData	0, Map_SS_Down,   0, ArtTile_SS_Up_Down
		specialStageData	0, Map_SS_R,      1, ArtTile_SS_R_Block
		specialStageData	0, Map_SS_Glass,  0, ArtTile_SS_Red_White_Block
		specialStageData	0, Map_SS_Glass,  0, ArtTile_SS_Glass
		specialStageData	0, Map_SS_Glass,  3, ArtTile_SS_Glass
		specialStageData	0, Map_SS_Glass,  1, ArtTile_SS_Glass
		specialStageData	0, Map_SS_Glass,  2, ArtTile_SS_Glass
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_R_Block
		specialStageData	1, Map_Bump,      0, ArtTile_SS_Bumper
		specialStageData	2, Map_Bump,      0, ArtTile_SS_Bumper
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Zone_1
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Zone_2
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Zone_3
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Zone_4
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Zone_5
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Zone_6
		specialStageData	0, Map_Ring,      1, ArtTile_Ring
		specialStageData	0, Map_SS_Chaos3, 0, ArtTile_SS_Emerald
		specialStageData	0, Map_SS_Chaos3, 1, ArtTile_SS_Emerald
		specialStageData	0, Map_SS_Chaos3, 2, ArtTile_SS_Emerald
		specialStageData	0, Map_SS_Chaos3, 3, ArtTile_SS_Emerald
		specialStageData	0, Map_SS_Chaos1, 0, ArtTile_SS_Emerald
		specialStageData	0, Map_SS_Chaos2, 0, ArtTile_SS_Emerald
		specialStageData	0, Map_SS_R,      0, ArtTile_SS_Ghost_Block
		specialStageData	4, Map_Ring,      1, ArtTile_Ring
		specialStageData	5, Map_Ring,      1, ArtTile_Ring
		specialStageData	6, Map_Ring,      1, ArtTile_Ring
		specialStageData	7, Map_Ring,      1, ArtTile_Ring
		specialStageData	0, Map_SS_Glass,  1, ArtTile_SS_Emerald_Sparkle
		specialStageData	1, Map_SS_Glass,  1, ArtTile_SS_Emerald_Sparkle
		specialStageData	2, Map_SS_Glass,  1, ArtTile_SS_Emerald_Sparkle
		specialStageData	3, Map_SS_Glass,  1, ArtTile_SS_Emerald_Sparkle
		specialStageData	2, Map_SS_R,      0, ArtTile_SS_Ghost_Block
		specialStageData	0, Map_SS_Glass,  0, ArtTile_SS_Glass
		specialStageData	0, Map_SS_Glass,  3, ArtTile_SS_Glass
		specialStageData	0, Map_SS_Glass,  1, ArtTile_SS_Glass
		specialStageData	0, Map_SS_Glass,  2, ArtTile_SS_Glass