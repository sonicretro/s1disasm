; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	bridge
; ---------------------------------------------------------------------------
Map_Bri:	mappingsTable
	mappingsTableEntry.w	M_Bri_Log
	mappingsTableEntry.w	M_Bri_Stump
	mappingsTableEntry.w	M_Bri_Rope

M_Bri_Log:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
M_Bri_Log_End

M_Bri_Stump:	spriteHeader
	spritePiece	-$10, -8, 2, 1, 4, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, 6, 0, 0, 0, 0
M_Bri_Stump_End

M_Bri_Rope:	spriteHeader
	spritePiece	-8, -4, 2, 1, 8, 0, 0, 0, 0
M_Bri_Rope_End

	even
