; ---------------------------------------------------------------------------
; Sprite mappings - Eggman in broken eggmobile (FZ)
; ---------------------------------------------------------------------------
Map_FZDamaged:	mappingsTable
	mappingsTableEntry.w	@damage1
	mappingsTableEntry.w	@damage2

@damage1:	spriteHeader
	spritePiece	-$C, -$1C, 3, 1, $20, 0, 0, 0, 0
	spritePiece	-$1C, -$14, 4, 2, $23, 0, 0, 0, 0
	spritePiece	4, -$14, 3, 2, $2B, 0, 0, 0, 0
	spritePiece	-$1C, -4, 2, 2, $3A, 0, 0, 1, 0
	spritePiece	4, -4, 4, 3, $3E, 0, 0, 1, 0
	spritePiece	4, $14, 2, 1, $4A, 0, 0, 1, 0
@damage1_End

@damage2:	spriteHeader
	spritePiece	-$C, -$1C, 3, 3, $31, 0, 0, 0, 0
	spritePiece	-$1C, -$14, 2, 2, $23, 0, 0, 0, 0
	spritePiece	4, -$14, 3, 2, $2B, 0, 0, 0, 0
	spritePiece	-$1C, -4, 2, 2, $3A, 0, 0, 1, 0
	spritePiece	4, -4, 4, 3, $3E, 0, 0, 1, 0
	spritePiece	4, $14, 2, 1, $4A, 0, 0, 1, 0
@damage2_End

	even
