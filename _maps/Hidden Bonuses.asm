; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of	a level
; ---------------------------------------------------------------------------
Map_Bonus:	mappingsTable
	mappingsTableEntry.w	@blank
	mappingsTableEntry.w	@10000
	mappingsTableEntry.w	@1000
	mappingsTableEntry.w	@100

@blank:	spriteHeader
@blank_End

@10000:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
@10000_End

@1000:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
@1000_End

@100:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $18, 0, 0, 0, 0
@100_End

	even
