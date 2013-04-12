; ---------------------------------------------------------------------------
; Sprite mappings - smashable walls (GHZ, SLZ)
; ---------------------------------------------------------------------------
Map_Smash:	mappingsTable
	mappingsTableEntry.w	@left
	mappingsTableEntry.w	@middle
	mappingsTableEntry.w	@right

@left:	spriteHeader
	spritePiece	-$10, -$20, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -$10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, $10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, 4, 0, 0, 0, 0
@left_End

@middle:	spriteHeader
	spritePiece	-$10, -$20, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$10, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$10, $10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$20, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, 4, 0, 0, 0, 0
@middle_End

@right:	spriteHeader
	spritePiece	-$10, -$20, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$10, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$10, $10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$20, 2, 2, 8, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, 8, 0, 0, 0, 0
@right_End

	even
