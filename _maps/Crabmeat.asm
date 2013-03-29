; ---------------------------------------------------------------------------
; Sprite mappings - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------
Map_Crab:	mappingsTable
	mappingsTableEntry.w	@stand
	mappingsTableEntry.w	@walk
	mappingsTableEntry.w	@slope1
	mappingsTableEntry.w	@slope2
	mappingsTableEntry.w	@firing
	mappingsTableEntry.w	@ball1
	mappingsTableEntry.w	@ball2

@stand:	spriteHeader
	spritePiece	-$18, -$10, 3, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 2, 0, 1, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 6, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 6, 1, 0, 0, 0
@stand_End

@walk:	spriteHeader
	spritePiece	-$18, -$10, 3, 2, $A, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 2, $10, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $16, 0, 0, 0, 0
	spritePiece	0, 0, 3, 2, $1A, 0, 0, 0, 0
@walk_End

@slope1:	spriteHeader
	spritePiece	-$18, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$14, 3, 2, 0, 1, 0, 0, 0
	spritePiece	0, -4, 2, 2, 6, 1, 0, 0, 0
	spritePiece	-$10, -4, 2, 3, $20, 0, 0, 0, 0
@slope1_End

@slope2:	spriteHeader
	spritePiece	-$18, -$14, 3, 2, $A, 0, 0, 0, 0
	spritePiece	0, -$14, 3, 2, $10, 0, 0, 0, 0
	spritePiece	0, -4, 3, 2, $26, 0, 0, 0, 0
	spritePiece	-$10, -4, 2, 3, $2C, 0, 0, 0, 0
@slope2_End

@firing:	spriteHeader
	spritePiece	-$10, -$10, 2, 1, $32, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 1, $32, 1, 0, 0, 0
	spritePiece	-$18, -8, 3, 2, $34, 0, 0, 0, 0
	spritePiece	0, -8, 3, 2, $34, 1, 0, 0, 0
	spritePiece	-$10, 8, 2, 1, $3A, 0, 0, 0, 0
	spritePiece	0, 8, 2, 1, $3A, 1, 0, 0, 0
@firing_End

@ball1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $3C, 0, 0, 0, 0
@ball1_End

@ball2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $40, 0, 0, 0, 0
@ball2_End

	even
