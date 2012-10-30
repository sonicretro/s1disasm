; ---------------------------------------------------------------------------
; Sprite mappings - large green	glassy blocks (MZ)
; ---------------------------------------------------------------------------
Map_Glass:	mappingsTable
	mappingsTableEntry.w	@tall
	mappingsTableEntry.w	@shine
	mappingsTableEntry.w	@short

@tall:	spriteHeader
	spritePiece	-$20, -$48, 4, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$48, 4, 1, 0, 1, 0, 0, 0
	spritePiece	-$20, -$40, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$40, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, -$20, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $20, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, $20, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $40, 4, 1, 0, 0, 1, 0, 0
	spritePiece	0, $40, 4, 1, 0, 1, 1, 0, 0
@tall_End

@shine:	spriteHeader
	spritePiece	-$10, 8, 2, 3, $14, 0, 0, 0, 0
	spritePiece	0, 0, 2, 3, $14, 0, 0, 0, 0
@shine_End

@short:	spriteHeader
	spritePiece	-$20, -$38, 4, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$38, 4, 1, 0, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $30, 4, 1, 0, 0, 1, 0, 0
	spritePiece	0, $30, 4, 1, 0, 1, 1, 0, 0
@short_End

	even
