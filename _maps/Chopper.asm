; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Chop:	mappingsTable
	mappingsTableEntry.w	@mouthshut
	mappingsTableEntry.w	@mouthopen

@mouthshut:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
@mouthshut_End

@mouthopen:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $10, 0, 0, 0, 0
@mouthopen_End

	even
