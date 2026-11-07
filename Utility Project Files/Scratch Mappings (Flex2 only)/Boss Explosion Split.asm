Map_ExplodeBomb:	mappingsTable
	mappingsTableEntry.w	.explode_boss0
	mappingsTableEntry.w	.explode_boss1
	mappingsTableEntry.w	.explode_boss2
	mappingsTableEntry.w	.explode_boss3
	mappingsTableEntry.w	.explode_boss4

.explode_boss0:	spriteHeader
	spritePiece	-$C, -8, 3, 2, 0, 0, 0, 0, 0
.explode_boss0_End

.explode_boss1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $40, 0, 0, 0, 0
.explode_boss1_End

.explode_boss2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $50, 0, 0, 0, 0
.explode_boss2_End

.explode_boss3:	spriteHeader
	spritePiece	-$14, -$14, 3, 3, $26, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $2F, 0, 0, 0, 0
	spritePiece	-$14, 4, 2, 2, $2F, 1, 1, 0, 0
	spritePiece	-4, -4, 3, 3, $26, 1, 1, 0, 0
.explode_boss3_End

.explode_boss4:	spriteHeader
	spritePiece	-$14, -$14, 3, 3, $33, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $3C, 0, 0, 0, 0
	spritePiece	-$14, 4, 2, 2, $3C, 1, 1, 0, 0
	spritePiece	-4, -4, 3, 3, $33, 1, 1, 0, 0
.explode_boss4_End

	even