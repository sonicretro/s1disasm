; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	platforms
; ---------------------------------------------------------------------------
Map_Plat_GHZ:	mappingsTable
	mappingsTableEntry.w	@small
	mappingsTableEntry.w	@large

@small:	spriteHeader
	spritePiece	-$20, -$C, 3, 4, $3B, 0, 0, 0, 0
	spritePiece	-8, -$C, 2, 4, $3F, 0, 0, 0, 0
	spritePiece	8, -$C, 2, 4, $3F, 0, 0, 0, 0
	spritePiece	$18, -$C, 1, 4, $47, 0, 0, 0, 0
@small_End

@large:	spriteHeader
	spritePiece	-$20, -$C, 4, 4, $C5, 0, 0, 0, 0
	spritePiece	-$20, 4, 4, 4, $D5, 0, 0, 0, 0
	spritePiece	-$20, $24, 4, 4, $D5, 0, 0, 0, 0
	spritePiece	-$20, $44, 4, 4, $D5, 0, 0, 0, 0
	spritePiece	-$20, $64, 4, 4, $D5, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 4, $C5, 1, 0, 0, 0
	spritePiece	0, 4, 4, 4, $D5, 1, 0, 0, 0
	spritePiece	0, $24, 4, 4, $D5, 1, 0, 0, 0
	spritePiece	0, $44, 4, 4, $D5, 1, 0, 0, 0
	spritePiece	0, $64, 4, 4, $D5, 1, 0, 0, 0
@large_End

	even
