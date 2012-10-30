; ---------------------------------------------------------------------------
; Sprite mappings - signpost
; ---------------------------------------------------------------------------
Map_Sign:	mappingsTable
	mappingsTableEntry.w	@eggman
	mappingsTableEntry.w	@spin1
	mappingsTableEntry.w	@spin2
	mappingsTableEntry.w	@spin3
	mappingsTableEntry.w	@sonic

@eggman:	spriteHeader
	spritePiece	-$18, -$10, 3, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 4, 0, 1, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $38, 0, 0, 0, 0
@eggman_End

@spin1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $C, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $38, 0, 0, 0, 0
@spin1_End

@spin2:	spriteHeader
	spritePiece	-4, -$10, 1, 4, $1C, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $38, 1, 0, 0, 0
@spin2_End

@spin3:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $C, 1, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $38, 1, 0, 0, 0
@spin3_End

@sonic:	spriteHeader
	spritePiece	-$18, -$10, 3, 4, $20, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 4, $2C, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $38, 0, 0, 0, 0
@sonic_End

	even
