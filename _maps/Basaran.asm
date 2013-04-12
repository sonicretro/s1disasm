; ---------------------------------------------------------------------------
; Sprite mappings - Basaran enemy (MZ)
; ---------------------------------------------------------------------------
Map_Bas:	mappingsTable
	mappingsTableEntry.w	@still
	mappingsTableEntry.w	@fly1
	mappingsTableEntry.w	@fly2
	mappingsTableEntry.w	@fly3

@still:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
@still_End

@fly1:	spriteHeader
	spritePiece	-$C, -$E, 4, 3, 6, 0, 0, 0, 0
	spritePiece	-4, $A, 2, 1, $12, 0, 0, 0, 0
	spritePiece	$C, 2, 1, 1, $27, 0, 0, 0, 0
@fly1_End

@fly2:	spriteHeader
	spritePiece	-8, -8, 2, 1, $14, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $16, 0, 0, 0, 0
	spritePiece	0, 8, 2, 1, $1A, 0, 0, 0, 0
	spritePiece	$C, 0, 1, 1, $28, 0, 0, 0, 0
@fly2_End

@fly3:	spriteHeader
	spritePiece	-$B, -$A, 3, 2, $1C, 0, 0, 0, 0
	spritePiece	-$C, 6, 3, 1, $22, 0, 0, 0, 0
	spritePiece	-$C, $E, 2, 1, $25, 0, 0, 0, 0
	spritePiece	$C, -2, 1, 1, $27, 0, 0, 0, 0
@fly3_End

	even
