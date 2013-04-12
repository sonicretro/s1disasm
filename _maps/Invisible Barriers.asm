; ---------------------------------------------------------------------------
; Sprite mappings - invisible solid blocks
; ---------------------------------------------------------------------------
Map_Invis:	mappingsTable
	mappingsTableEntry.w	@solid
	mappingsTableEntry.w	@unused1
	mappingsTableEntry.w	@unused2

@solid:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $18, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, $18, 0, 0, 0, 0
@solid_End

@unused1:	spriteHeader
	spritePiece	-$40, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$30, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$40, $10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$30, $10, 2, 2, $18, 0, 0, 0, 0
@unused1_End

@unused2:	spriteHeader
	spritePiece	-$80, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$70, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$80, $10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$70, $10, 2, 2, $18, 0, 0, 0, 0
@unused2_End

	even
