; ---------------------------------------------------------------------------
; Sprite mappings - flapping door (LZ)
; ---------------------------------------------------------------------------
Map_Flap:	mappingsTable
	mappingsTableEntry.w	@closed
	mappingsTableEntry.w	@halfway
	mappingsTableEntry.w	@open

@closed:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 4, 0, 0, 1, 0, 0
@closed_End

@halfway:	spriteHeader
	spritePiece	-5, -$26, 4, 4, 8, 0, 0, 0, 0
	spritePiece	-5, 6, 4, 4, 8, 0, 1, 0, 0
@halfway_End

@open:	spriteHeader
	spritePiece	0, -$28, 4, 2, $18, 0, 0, 0, 0
	spritePiece	0, $18, 4, 2, $18, 0, 1, 0, 0
@open_End

	even
