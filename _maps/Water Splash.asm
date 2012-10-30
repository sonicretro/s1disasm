; ---------------------------------------------------------------------------
; Sprite mappings - water splash (LZ)
; ---------------------------------------------------------------------------
Map_Splash:	mappingsTable
	mappingsTableEntry.w	@splash1
	mappingsTableEntry.w	@splash2
	mappingsTableEntry.w	@splash3

@splash1:	spriteHeader
	spritePiece	-8, -$E, 2, 1, $6D, 0, 0, 0, 0
	spritePiece	-$10, -6, 4, 1, $6F, 0, 0, 0, 0
@splash1_End

@splash2:	spriteHeader
	spritePiece	-8, -$1E, 1, 1, $73, 0, 0, 0, 0
	spritePiece	-$10, -$16, 4, 3, $74, 0, 0, 0, 0
@splash2_End

@splash3:	spriteHeader
	spritePiece	-$10, -$1E, 4, 4, $80, 0, 0, 0, 0
@splash3_End

	even
