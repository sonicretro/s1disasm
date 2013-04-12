; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------
Map_Push:	mappingsTable
	mappingsTableEntry.w	@single
	mappingsTableEntry.w	@four

@single:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 8, 0, 0, 0, 0
@single_End

@four:	spriteHeader
	spritePiece	-$40, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	$20, -$10, 4, 4, 8, 0, 0, 0, 0
@four_End

	even
