; ---------------------------------------------------------------------------
; Sprite mappings - fans (SLZ)
; ---------------------------------------------------------------------------
Map_Fan:	mappingsTable
	mappingsTableEntry.w	@fan1
	mappingsTableEntry.w	@fan2
	mappingsTableEntry.w	@fan3
	mappingsTableEntry.w	@fan2
	mappingsTableEntry.w	@fan1

@fan1:	spriteHeader
	spritePiece	-8, -$10, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 2, 6, 0, 0, 0, 0
@fan1_End

@fan2:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, $E, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 2, $16, 0, 0, 0, 0
@fan2_End

@fan3:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, $1E, 0, 0, 0, 0
	spritePiece	-8, 0, 3, 2, $26, 0, 0, 0, 0
@fan3_End

	even
