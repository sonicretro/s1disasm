; ---------------------------------------------------------------------------
; Sprite mappings - walls (GHZ)
; ---------------------------------------------------------------------------
Map_Edge:	mappingsTable
	mappingsTableEntry.w	M_Edge_Shadow
	mappingsTableEntry.w	M_Edge_Light
	mappingsTableEntry.w	M_Edge_Dark

M_Edge_Shadow:	spriteHeader
	spritePiece	-8, -$20, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-8, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 2, 8, 0, 0, 0, 0
M_Edge_Shadow_End

M_Edge_Light:	spriteHeader
	spritePiece	-8, -$20, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 2, 8, 0, 0, 0, 0
M_Edge_Light_End

M_Edge_Dark:	spriteHeader
	spritePiece	-8, -$20, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-8, -$10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 2, 0, 0, 0, 0, 0
M_Edge_Dark_End

	even
