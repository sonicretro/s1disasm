; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms	(SBZ)
; ---------------------------------------------------------------------------
Map_VanP:	mappingsTable
	mappingsTableEntry.w	@whole
	mappingsTableEntry.w	@half
	mappingsTableEntry.w	@quarter
	mappingsTableEntry.w	@gone

@whole:	spriteHeader
	spritePiece	-$10, -8, 4, 4, 0, 0, 0, 0, 0
@whole_End

@half:	spriteHeader
	spritePiece	-8, -8, 2, 4, $10, 0, 0, 0, 0
@half_End

@quarter:	spriteHeader
	spritePiece	-4, -8, 1, 4, $18, 0, 0, 0, 0
@quarter_End

@gone:	spriteHeader
@gone_End

	even
