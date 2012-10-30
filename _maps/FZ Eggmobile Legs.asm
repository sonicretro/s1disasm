; ---------------------------------------------------------------------------
; Sprite mappings - legs on Eggman's escape ship (FZ)
; ---------------------------------------------------------------------------
Map_FZLegs:	mappingsTable
	mappingsTableEntry.w	@extended
	mappingsTableEntry.w	@halfway
	mappingsTableEntry.w	@retracted

@extended:	spriteHeader
	spritePiece	-$C, $14, 4, 3, 0, 1, 0, 1, 0
	spritePiece	-$14, $24, 1, 1, $C, 1, 0, 1, 0
@extended_End

@halfway:	spriteHeader
	spritePiece	$C, $C, 2, 2, $D, 1, 0, 1, 0
	spritePiece	$C, $1C, 1, 1, $11, 1, 0, 1, 0
	spritePiece	-$14, $14, 4, 2, $12, 1, 0, 1, 0
@halfway_End

@retracted:	spriteHeader
	spritePiece	$C, $C, 1, 2, $1A, 1, 0, 1, 0
	spritePiece	-$14, $14, 4, 1, $1C, 1, 0, 1, 0
@retracted_End

	even
