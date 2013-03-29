; ---------------------------------------------------------------------------
; Sprite mappings - giant ring
; ---------------------------------------------------------------------------
Map_GRing:	mappingsTable
	mappingsTableEntry.w	byte_9FDA
	mappingsTableEntry.w	byte_A00D
	mappingsTableEntry.w	byte_A036
	mappingsTableEntry.w	byte_A04B

byte_9FDA:	spriteHeader
	spritePiece	-$18, -$20, 3, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 3, 1, 3, 0, 0, 0, 0
	spritePiece	-$20, -$18, 4, 1, 6, 0, 0, 0, 0
	spritePiece	0, -$18, 4, 1, $A, 0, 0, 0, 0
	spritePiece	-$20, -$10, 2, 4, $E, 0, 0, 0, 0
	spritePiece	$10, -$10, 2, 4, $16, 0, 0, 0, 0
	spritePiece	-$20, $10, 4, 1, $1E, 0, 0, 0, 0
	spritePiece	0, $10, 4, 1, $22, 0, 0, 0, 0
	spritePiece	-$18, $18, 3, 1, $26, 0, 0, 0, 0
	spritePiece	0, $18, 3, 1, $29, 0, 0, 0, 0
byte_9FDA_End

byte_A00D:	spriteHeader
	spritePiece	-$10, -$20, 4, 1, $2C, 0, 0, 0, 0
	spritePiece	-$18, -$18, 3, 1, $30, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 2, $33, 0, 0, 0, 0
	spritePiece	-$18, -$10, 2, 4, $39, 0, 0, 0, 0
	spritePiece	8, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	0, 8, 3, 2, $45, 0, 0, 0, 0
	spritePiece	-$18, $10, 3, 1, $4B, 0, 0, 0, 0
	spritePiece	-$10, $18, 4, 1, $4E, 0, 0, 0, 0
byte_A00D_End

byte_A036:	spriteHeader
	spritePiece	-$C, -$20, 2, 4, $52, 0, 0, 0, 0
	spritePiece	4, -$20, 1, 4, $52, 1, 0, 0, 0
	spritePiece	-$C, 0, 2, 4, $5A, 0, 0, 0, 0
	spritePiece	4, 0, 1, 4, $5A, 1, 0, 0, 0
byte_A036_End

byte_A04B:	spriteHeader
	spritePiece	-$10, -$20, 4, 1, $2C, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 1, $30, 1, 0, 0, 0
	spritePiece	-$18, -$18, 3, 2, $33, 1, 0, 0, 0
	spritePiece	8, -$10, 2, 4, $39, 1, 0, 0, 0
	spritePiece	-$18, -8, 2, 2, $41, 1, 0, 0, 0
	spritePiece	-$18, 8, 3, 2, $45, 1, 0, 0, 0
	spritePiece	0, $10, 3, 1, $4B, 1, 0, 0, 0
	spritePiece	-$10, $18, 4, 1, $4E, 1, 0, 0, 0
byte_A04B_End

	even
