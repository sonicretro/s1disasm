; ---------------------------------------------------------------------------
; Sprite mappings - large girder block (SBZ)
; ---------------------------------------------------------------------------
Map_Gird:	mappingsTable
	mappingsTableEntry.w	@girder

@girder:	spriteHeader
	spritePiece	-$60, -$18, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$60, 0, 4, 3, 0, 0, 1, 0, 0
	spritePiece	-$40, -$18, 4, 3, 6, 0, 0, 0, 0
	spritePiece	-$40, 0, 4, 3, 6, 0, 1, 0, 0
	spritePiece	-$20, -$18, 4, 3, 6, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 3, 6, 0, 1, 0, 0
	spritePiece	0, -$18, 4, 3, 6, 0, 0, 0, 0
	spritePiece	0, 0, 4, 3, 6, 0, 1, 0, 0
	spritePiece	$20, -$18, 4, 3, 6, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 3, 6, 0, 1, 0, 0
	spritePiece	$40, -$18, 4, 3, 6, 0, 0, 0, 0
	spritePiece	$40, 0, 4, 3, 6, 0, 1, 0, 0
@girder_End

	even
