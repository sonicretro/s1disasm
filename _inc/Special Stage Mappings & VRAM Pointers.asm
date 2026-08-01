; ===========================================================================
; ---------------------------------------------------------------------------
; Special stage mappings and VRAM pointers (loaded into v_ss_spritesettings)
; ---------------------------------------------------------------------------

SS_MapIndex:

specialStageData: macro *,frame,mappings,palette,vram
\*:	equ	(*-SS_MapIndex)/(4+2)+1
		dc.l	(frame<<24)|mappings
		dc.w	palette|vram
		endm

; Blank block is implicitly added to v_ss_spritesettings by skipping over the first 8 bytes
; id_SS_Blank:		specialStageData	0, 0		  0,	     0				; $00 - blank block

; Square wall blocks (0th blocks per color are static and don't animate)
id_SS_WallBlue_0:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $01 - wall block (blue)
id_SS_WallBlue_1:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $02 - ''
id_SS_WallBlue_2:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $03 - ''
id_SS_WallBlue_3:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $04 - ''
id_SS_WallBlue_4:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $05 - ''
id_SS_WallBlue_5:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $06 - ''
id_SS_WallBlue_6:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $07 - ''
id_SS_WallBlue_7:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $08 - ''
id_SS_WallBlue_8:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $09 - ''

id_SS_WallYellow_0:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0A - wall block (yellow)
id_SS_WallYellow_1:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0B - ''
id_SS_WallYellow_2:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0C - ''
id_SS_WallYellow_3:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0D - ''
id_SS_WallYellow_4:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0E - ''
id_SS_WallYellow_5:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0F - ''
id_SS_WallYellow_6:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $10 - ''
id_SS_WallYellow_7:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $11 - ''
id_SS_WallYellow_8:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $12 - ''

id_SS_WallPink_0:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $13 - wall block (pink)
id_SS_WallPink_1:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $14 - ''
id_SS_WallPink_2:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $15 - ''
id_SS_WallPink_3:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $16 - ''
id_SS_WallPink_4:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $17 - ''
id_SS_WallPink_5:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $18 - ''
id_SS_WallPink_6:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $19 - ''
id_SS_WallPink_7:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $1A - ''
id_SS_WallPink_8:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $1B - ''

id_SS_WallGreen_0:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $1C - wall block (green)
id_SS_WallGreen_1:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $1D - ''
id_SS_WallGreen_2:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $1E - ''
id_SS_WallGreen_3:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $1F - ''
id_SS_WallGreen_4:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $20 - ''
id_SS_WallGreen_5:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $21 - ''
id_SS_WallGreen_6:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $22 - ''
id_SS_WallGreen_7:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $23 - ''
id_SS_WallGreen_8:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $24 - ''

; Solid action blocks
id_SS_Bumper:		specialStageData	0, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper		; $25 - bumper (idle)
id_SS_W:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_W_Block		; $26 - W block (unused)
id_SS_GOAL:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Goal		; $27 - GOAL block
id_SS_1Up:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Extra_Life	; $28 - 1-Up block (hardcoded to be non-solid)
id_SS_UP:		specialStageData	0, Map_SS_Up,     Tile_Pal1, ArtTile_SS_Up_Down		; $29 - UP block
id_SS_DOWN:		specialStageData	0, Map_SS_Down,   Tile_Pal1, ArtTile_SS_Up_Down		; $2A - DOWN block
id_SS_R:		specialStageData	0, Map_SS_Shared, Tile_Pal2, ArtTile_SS_R_Block		; $2B - R block (idle)
id_SS_RedWhite:		specialStageData	0, Map_SS_Glass,  Tile_Pal1, ArtTile_SS_Red_White_Block	; $2C - red/white block
id_SS_Glass1_Blue:	specialStageData	0, Map_SS_Glass,  Tile_Pal1, ArtTile_SS_Glass		; $2D - glass block (blue)
id_SS_Glass2_Green:	specialStageData	0, Map_SS_Glass,  Tile_Pal4, ArtTile_SS_Glass		; $2E - ''          (green)
id_SS_Glass3_Yellow:	specialStageData	0, Map_SS_Glass,  Tile_Pal2, ArtTile_SS_Glass		; $2F - ''          (yellow)
id_SS_Glass4_Pink:	specialStageData	0, Map_SS_Glass,  Tile_Pal3, ArtTile_SS_Glass		; $30 - ''          (pink)
id_SS_R_Ani:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_R_Block		; $31 - R block (touched)
id_SS_Bumper_Ani1:	specialStageData	1, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper		; $32 - bumper (touched 1)
id_SS_Bumper_Ani2:	specialStageData	2, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper		; $33 - ''     (touched 2)
id_SS_ZONE1:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Zone_1		; $34 - ZONE 1 block (unused)
id_SS_ZONE2:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Zone_2		; $35 - ''   2 block (unused)
id_SS_ZONE3:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Zone_3		; $36 - ''   3 block (unused)
id_SS_ZONE4:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Zone_4		; $37 - ''   4 block (unused)
id_SS_ZONE5:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Zone_5		; $38 - ''   5 block (unused)
id_SS_ZONE6:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Zone_6		; $39 - ''   6 block (unused)

; Non-solid action blocks
id_SS_Ring:		specialStageData	0, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $3A - ring
id_SS_Emerald1_Blue:	specialStageData	0, Map_SS_Chaos3, Tile_Pal1, ArtTile_SS_Emerald		; $3B - emerald (blue)
id_SS_Emerald2_Yellow:	specialStageData	0, Map_SS_Chaos3, Tile_Pal2, ArtTile_SS_Emerald		; $3C - ''      (yellow)
id_SS_Emerald3_Pink:	specialStageData	0, Map_SS_Chaos3, Tile_Pal3, ArtTile_SS_Emerald		; $3D - ''      (pink)
id_SS_Emerald4_Green:	specialStageData	0, Map_SS_Chaos3, Tile_Pal4, ArtTile_SS_Emerald		; $3E - ''      (green)
id_SS_Emerald5_Red:	specialStageData	0, Map_SS_Chaos1, Tile_Pal1, ArtTile_SS_Emerald		; $3F - ''      (red)
id_SS_Emerald6_Grey:	specialStageData	0, Map_SS_Chaos2, Tile_Pal1, ArtTile_SS_Emerald		; $40 - ''      (grey)
id_SS_Ghost:		specialStageData	0, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Ghost_Block	; $41 - ghost block
id_SS_Ring_Ani1:	specialStageData	4, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $42 - ring (sparkle when collecting)
id_SS_Ring_Ani2:	specialStageData	5, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $43 - ''
id_SS_Ring_Ani3:	specialStageData	6, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $44 - ''
id_SS_Ring_Ani4:	specialStageData	7, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $45 - ''
id_SS_Emerald_Ani1:	specialStageData	0, Map_SS_Glass,  Tile_Pal2, ArtTile_SS_Emerald_Sparkle	; $46 - emerald (sparkle when collecting)
id_SS_Emerald_Ani2:	specialStageData	1, Map_SS_Glass,  Tile_Pal2, ArtTile_SS_Emerald_Sparkle	; $47 - ''
id_SS_Emerald_Ani3:	specialStageData	2, Map_SS_Glass,  Tile_Pal2, ArtTile_SS_Emerald_Sparkle	; $48 - ''
id_SS_Emerald_Ani4:	specialStageData	3, Map_SS_Glass,  Tile_Pal2, ArtTile_SS_Emerald_Sparkle	; $49 - ''
id_SS_InvGhostTrigger:	specialStageData	2, Map_SS_Shared, Tile_Pal1, ArtTile_SS_Ghost_Block	; $4A - invisible ghost block trigger

; Solid misc blocks
id_SS_Glass_Ani1:	specialStageData	0, Map_SS_Glass,  Tile_Pal1, ArtTile_SS_Glass		; $4B - glass block (blinking while touched)
id_SS_Glass_Ani2:	specialStageData	0, Map_SS_Glass,  Tile_Pal4, ArtTile_SS_Glass		; $4C - ''
id_SS_Glass_Ani3:	specialStageData	0, Map_SS_Glass,  Tile_Pal2, ArtTile_SS_Glass		; $4D - ''
id_SS_Glass_Ani4:	specialStageData	0, Map_SS_Glass,  Tile_Pal3, ArtTile_SS_Glass		; $4E - ''

SS_MapIndex_End: