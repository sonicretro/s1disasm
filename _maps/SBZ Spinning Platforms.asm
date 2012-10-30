; ---------------------------------------------------------------------------
; Sprite mappings - spinning platforms (SBZ)
; ---------------------------------------------------------------------------
Map_Spin:	mappingsTable
	mappingsTableEntry.w	@flat
	mappingsTableEntry.w	@spin1
	mappingsTableEntry.w	@spin2
	mappingsTableEntry.w	@spin3
	mappingsTableEntry.w	@spin4

@flat:	spriteHeader
	spritePiece	-$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 1, 0, 0, 0
@flat_End

@spin1:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, $14, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 2, $1C, 0, 0, 0, 0
@spin1_End

@spin2:	spriteHeader
	spritePiece	-$10, -$10, 3, 2, 4, 0, 0, 0, 0
	spritePiece	-8, 0, 3, 2, $A, 0, 0, 0, 0
@spin2_End

@spin3:	spriteHeader
	spritePiece	-$10, -$10, 3, 2, $24, 0, 0, 0, 0
	spritePiece	-8, 0, 3, 2, $2A, 0, 0, 0, 0
@spin3_End

@spin4:	spriteHeader
	spritePiece	-8, -$10, 2, 2, $10, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, $10, 0, 1, 0, 0
@spin4_End

	even
