; ---------------------------------------------------------------------------
; Sprite mappings - harpoon (LZ)
; ---------------------------------------------------------------------------
Map_Harp:	mappingsTable
	mappingsTableEntry.w	@h_retracted
	mappingsTableEntry.w	@h_middle
	mappingsTableEntry.w	@h_extended
	mappingsTableEntry.w	@v_retracted
	mappingsTableEntry.w	@v_middle
	mappingsTableEntry.w	@v_extended

@h_retracted:	spriteHeader
	spritePiece	-8, -4, 2, 1, 0, 0, 0, 0, 0
@h_retracted_End

@h_middle:	spriteHeader
	spritePiece	-8, -4, 4, 1, 2, 0, 0, 0, 0
@h_middle_End

@h_extended:	spriteHeader
	spritePiece	-8, -4, 3, 1, 6, 0, 0, 0, 0
	spritePiece	$10, -4, 3, 1, 3, 0, 0, 0, 0
@h_extended_End

@v_retracted:	spriteHeader
	spritePiece	-4, -8, 1, 2, 9, 0, 0, 0, 0
@v_retracted_End

@v_middle:	spriteHeader
	spritePiece	-4, -$18, 1, 4, $B, 0, 0, 0, 0
@v_middle_End

@v_extended:	spriteHeader
	spritePiece	-4, -$28, 1, 3, $B, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 3, $F, 0, 0, 0, 0
@v_extended_End

	even
