; ---------------------------------------------------------------------------
; Sprite mappings - drowning countdown numbers (LZ)
; ---------------------------------------------------------------------------
Map_Drown:	mappingsTable
	mappingsTableEntry.w	@num

@num:	spriteHeader
	spritePiece	-$E, -$18, 4, 3, 0, 0, 0, 0, 0
@num_End

	even
