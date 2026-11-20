Map_ExplodeItem:	mappingsTable
	mappingsTableEntry.w	.explode0
	mappingsTableEntry.w	.explode1
	mappingsTableEntry.w	.explode2
	mappingsTableEntry.w	.explode3
	mappingsTableEntry.w	.explode4

.explode0:	spriteHeader
	spritePiece	-$C, -8, 3, 2, 0, 0, 0, 0, 0
.explode0_End

.explode1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 6, 0, 0, 0, 0
.explode1_End

.explode2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $16, 0, 0, 0, 0
.explode2_End

.explode3:	spriteHeader
	spritePiece	-$14, -$14, 3, 3, $26, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $2F, 0, 0, 0, 0
	spritePiece	-$14, 4, 2, 2, $2F, 1, 1, 0, 0
	spritePiece	-4, -4, 3, 3, $26, 1, 1, 0, 0
.explode3_End

.explode4:	spriteHeader
	spritePiece	-$14, -$14, 3, 3, $33, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $3C, 0, 0, 0, 0
	spritePiece	-$14, 4, 2, 2, $3C, 1, 1, 0, 0
	spritePiece	-4, -4, 3, 3, $33, 1, 1, 0, 0
.explode4_End

	even
