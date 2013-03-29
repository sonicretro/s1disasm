; ---------------------------------------------------------------------------
; Sprite mappings - unused
; ---------------------------------------------------------------------------
Map_Plat_Unused:	mappingsTable
	mappingsTableEntry.w	@small
	mappingsTableEntry.w	@large

@small:	spriteHeader
	spritePiece	-$18, -$C, 3, 4, $3C, 0, 0, 0, 0
	spritePiece	0, -$C, 3, 4, $48, 0, 0, 0, 0
@small_End

@large:	spriteHeader
	spritePiece	-$20, -$C, 4, 4, $CA, 0, 0, 0, 0
	spritePiece	-$20, 4, 4, 4, $DA, 0, 0, 0, 0
	spritePiece	-$20, $24, 4, 4, $DA, 0, 0, 0, 0
	spritePiece	-$20, $44, 4, 4, $DA, 0, 0, 0, 0
	spritePiece	-$20, $64, 4, 4, $DA, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 4, $CA, 1, 0, 0, 0
	spritePiece	0, 4, 4, 4, $DA, 1, 0, 0, 0
	spritePiece	0, $24, 4, 4, $DA, 1, 0, 0, 0
	spritePiece	0, $44, 4, 4, $DA, 1, 0, 0, 0
	spritePiece	0, $64, 4, 4, $DA, 1, 0, 0, 0
@large_End

	even
