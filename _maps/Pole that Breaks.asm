; ---------------------------------------------------------------------------
; Sprite mappings - pole that breaks (LZ)
; ---------------------------------------------------------------------------
Map_Pole:	mappingsTable
	mappingsTableEntry.w	@normal
	mappingsTableEntry.w	@broken

@normal:	spriteHeader
	spritePiece	-4, -$20, 1, 4, 0, 0, 0, 0, 0
	spritePiece	-4, 0, 1, 4, 0, 0, 1, 0, 0
@normal_End

@broken:	spriteHeader
	spritePiece	-4, -$20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-4, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-4, 0, 2, 2, 4, 0, 1, 0, 0
	spritePiece	-4, $10, 1, 2, 0, 0, 1, 0, 0
@broken_End

	even
