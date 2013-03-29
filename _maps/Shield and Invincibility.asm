; ---------------------------------------------------------------------------
; Sprite mappings - shield and invincibility stars
; ---------------------------------------------------------------------------
Map_Shield:	mappingsTable
	mappingsTableEntry.w	@shield1
	mappingsTableEntry.w	@shield2
	mappingsTableEntry.w	@shield3
	mappingsTableEntry.w	@shield4
	mappingsTableEntry.w	@stars1
	mappingsTableEntry.w	@stars2
	mappingsTableEntry.w	@stars3
	mappingsTableEntry.w	@stars4

@shield2:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 9, 0, 0, 0, 0
@shield1:spritePiece	-$18, 0, 3, 3, 0, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, 9, 0, 1, 0, 0
@shield2_End

@shield3:	spriteHeader
	spritePiece	-$17, -$18, 3, 3, $12, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 3, $12, 0, 0, 0, 0
	spritePiece	-$17, 0, 3, 3, $12, 1, 1, 0, 0
	spritePiece	0, 0, 3, 3, $12, 0, 1, 0, 0
@shield3_End

@shield4:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, 9, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 9, 1, 1, 0, 0
	spritePiece	0, 0, 3, 3, 0, 1, 1, 0, 0
@shield4_End

@stars1:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 9, 1, 1, 0, 0
	spritePiece	0, 0, 3, 3, 0, 1, 1, 0, 0
@stars1_End

@stars2:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, 9, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 0, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, 9, 0, 1, 0, 0
@stars2_End

@stars3:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, $12, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, $1B, 0, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, $1B, 1, 1, 0, 0
	spritePiece	0, 0, 3, 3, $12, 1, 1, 0, 0
@stars3_End

@stars4:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, $1B, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 3, $12, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, $12, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, $1B, 0, 1, 0, 0
@stars4_End

	even
