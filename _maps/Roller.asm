; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------
Map_Roll:	mappingsTable
	mappingsTableEntry.w	M_Roll_Stand
	mappingsTableEntry.w	M_Roll_Fold
	mappingsTableEntry.w	M_Roll_Roll1
	mappingsTableEntry.w	M_Roll_Roll2
	mappingsTableEntry.w	M_Roll_Roll3

M_Roll_Stand:	spriteHeader
	spritePiece	-$10, -$22, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, -$A, 4, 3, $C, 0, 0, 0, 0
M_Roll_Stand_End

M_Roll_Fold:	spriteHeader
	spritePiece	-$10, -$1A, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, -2, 4, 2, $18, 0, 0, 0, 0
M_Roll_Fold_End

M_Roll_Roll1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $20, 0, 0, 0, 0
M_Roll_Roll1_End

M_Roll_Roll2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $30, 0, 0, 0, 0
M_Roll_Roll2_End

M_Roll_Roll3:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $40, 0, 0, 0, 0
M_Roll_Roll3_End

	even
