; ---------------------------------------------------------------------------
; Sprite mappings - prison capsule
; ---------------------------------------------------------------------------
Map_Pri:	mappingsTable
	mappingsTableEntry.w	@capsule
	mappingsTableEntry.w	@switch1
	mappingsTableEntry.w	@broken
	mappingsTableEntry.w	@switch2
	mappingsTableEntry.w	@unusedthing1
	mappingsTableEntry.w	@unusedthing2
	mappingsTableEntry.w	@blank

@capsule:	spriteHeader
	spritePiece	-$10, -$20, 4, 1, 0, 0, 0, 1, 0
	spritePiece	-$20, -$18, 4, 2, 4, 0, 0, 1, 0
	spritePiece	0, -$18, 4, 2, $C, 0, 0, 1, 0
	spritePiece	-$20, -8, 4, 3, $14, 0, 0, 1, 0
	spritePiece	0, -8, 4, 3, $20, 0, 0, 1, 0
	spritePiece	-$20, $10, 4, 2, $2C, 0, 0, 1, 0
	spritePiece	0, $10, 4, 2, $34, 0, 0, 1, 0
@capsule_End

@switch1:	spriteHeader
	spritePiece	-$C, -8, 3, 2, $3C, 0, 0, 0, 0
@switch1_End

@broken:	spriteHeader
	spritePiece	-$20, 0, 3, 1, $42, 0, 0, 1, 0
	spritePiece	-$20, 8, 4, 1, $45, 0, 0, 1, 0
	spritePiece	$10, 0, 2, 1, $49, 0, 0, 1, 0
	spritePiece	0, 8, 4, 1, $4B, 0, 0, 1, 0
	spritePiece	-$20, $10, 4, 2, $2C, 0, 0, 1, 0
	spritePiece	0, $10, 4, 2, $34, 0, 0, 1, 0
@broken_End

@switch2:	spriteHeader
	spritePiece	-$C, -8, 3, 2, $4F, 0, 0, 0, 0
@switch2_End

@unusedthing1:	spriteHeader
	spritePiece	-$10, -$18, 4, 3, $55, 0, 0, 1, 0
	spritePiece	-$10, 0, 4, 3, $61, 0, 0, 1, 0
@unusedthing1_End

@unusedthing2:	spriteHeader
	spritePiece	-8, -$10, 2, 4, $6D, 0, 0, 1, 0
@unusedthing2_End

@blank:	spriteHeader
@blank_End

	even
