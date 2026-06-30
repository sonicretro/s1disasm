; ---------------------------------------------------------------------------
; Sprite mappings - speeding saws and pizza cutters (SBZ)
; ---------------------------------------------------------------------------
Map_Saw_internal:	mappingsTable
	mappingsTableEntry.w	.pizzacutter1
	mappingsTableEntry.w	.pizzacutter2
	mappingsTableEntry.w	.speedingsaw1
	mappingsTableEntry.w	.speedingsaw2

.pizzacutter1:	spriteHeader
	spritePiece	-4, -$3C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$2C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$1C, 1, 4, $20, 0, 0, 0, 0
	spritePiece	-$20, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 0, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, 0, 1, 1, 0, 0
.pizzacutter1_End

.pizzacutter2:	spriteHeader
	spritePiece	-4, -$3C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$2C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$1C, 1, 4, $20, 0, 0, 0, 0
	spritePiece	-$20, -$20, 4, 4, $10, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $10, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $10, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, $10, 1, 1, 0, 0
.pizzacutter2_End

.speedingsaw1:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 0, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, 0, 1, 1, 0, 0
.speedingsaw1_End

.speedingsaw2:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $10, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $10, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $10, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, $10, 1, 1, 0, 0
.speedingsaw2_End

	even
