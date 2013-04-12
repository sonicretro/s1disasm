; ---------------------------------------------------------------------------
; Sprite mappings - water surface (LZ)
; ---------------------------------------------------------------------------
Map_Surf:	mappingsTable
	mappingsTableEntry.w	@normal1
	mappingsTableEntry.w	@normal2
	mappingsTableEntry.w	@normal3
	mappingsTableEntry.w	@paused1
	mappingsTableEntry.w	@paused2
	mappingsTableEntry.w	@paused3

@normal1:	spriteHeader
	spritePiece	-$60, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$20, -3, 4, 2, 0, 0, 0, 0, 0
@normal1_End

@normal2:	spriteHeader
	spritePiece	-$60, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-$20, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	$20, -3, 4, 2, 8, 0, 0, 0, 0
@normal2_End

@normal3:	spriteHeader
	spritePiece	-$60, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	-$20, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	$20, -3, 4, 2, 0, 1, 0, 0, 0
@normal3_End

@paused1:	spriteHeader
	spritePiece	-$60, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$40, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$20, -3, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$40, -3, 4, 2, 0, 0, 0, 0, 0
@paused1_End

@paused2:	spriteHeader
	spritePiece	-$60, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-$40, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-$20, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	0, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	$20, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	$40, -3, 4, 2, 8, 0, 0, 0, 0
@paused2_End

@paused3:	spriteHeader
	spritePiece	-$60, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	-$40, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	-$20, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	0, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	$20, -3, 4, 2, 0, 1, 0, 0, 0
	spritePiece	$40, -3, 4, 2, 0, 1, 0, 0, 0
@paused3_End

	even
