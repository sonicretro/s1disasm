; ---------------------------------------------------------------------------
; Sprite mappings - springs
; ---------------------------------------------------------------------------
Map_Spring:	mappingsTable
	mappingsTableEntry.w	M_Spg_Up
	mappingsTableEntry.w	M_Spg_UpFlat
	mappingsTableEntry.w	M_Spg_UpExt
	mappingsTableEntry.w	M_Spg_Left
	mappingsTableEntry.w	M_Spg_LeftFlat
	mappingsTableEntry.w	M_Spg_LeftExt

M_Spg_Up:	spriteHeader
	spritePiece	-$10, -8, 4, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, 4, 0, 0, 0, 0
M_Spg_Up_End

M_Spg_UpFlat:	spriteHeader
	spritePiece	-$10, 0, 4, 1, 0, 0, 0, 0, 0
M_Spg_UpFlat_End

M_Spg_UpExt:	spriteHeader
	spritePiece	-$10, -$18, 4, 1, 0, 0, 0, 0, 0
	spritePiece	-8, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $C, 0, 0, 0, 0
M_Spg_UpExt_End

M_Spg_Left:	spriteHeader
	spritePiece	-8, -$10, 2, 4, 0, 0, 0, 0, 0
M_Spg_Left_End

M_Spg_LeftFlat:	spriteHeader
	spritePiece	-8, -$10, 1, 4, 4, 0, 0, 0, 0
M_Spg_LeftFlat_End

M_Spg_LeftExt:	spriteHeader
	spritePiece	$10, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	-8, -8, 3, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -$10, 1, 1, 0, 0, 0, 0, 0
	spritePiece	-8, 8, 1, 1, 3, 0, 0, 0, 0
M_Spg_LeftExt_End

	even
