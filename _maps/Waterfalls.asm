; ---------------------------------------------------------------------------
; Sprite mappings - waterfalls (LZ)
; ---------------------------------------------------------------------------
Map_WFall:	mappingsTable
	mappingsTableEntry.w	@vertnarrow
	mappingsTableEntry.w	@cornerwide
	mappingsTableEntry.w	@cornermedium
	mappingsTableEntry.w	@cornernarrow
	mappingsTableEntry.w	@cornermedium2
	mappingsTableEntry.w	@cornernarrow2
	mappingsTableEntry.w	@cornernarrow3
	mappingsTableEntry.w	@vertwide
	mappingsTableEntry.w	@diagonal
	mappingsTableEntry.w	@splash1
	mappingsTableEntry.w	@splash2
	mappingsTableEntry.w	@splash3

@vertnarrow:	spriteHeader
	spritePiece	-8, -$10, 2, 4, 0, 0, 0, 0, 0
@vertnarrow_End

@cornerwide:	spriteHeader
	spritePiece	-4, -8, 2, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 1, $A, 0, 0, 0, 0
@cornerwide_End

@cornermedium:	spriteHeader
	spritePiece	0, -8, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 1, $D, 0, 0, 0, 0
@cornermedium_End

@cornernarrow:	spriteHeader
	spritePiece	0, -8, 1, 2, $F, 0, 0, 0, 0
@cornernarrow_End

@cornermedium2:	spriteHeader
	spritePiece	0, -8, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 1, $D, 0, 0, 0, 0
@cornermedium2_End

@cornernarrow2:	spriteHeader
	spritePiece	0, -8, 1, 2, $11, 0, 0, 0, 0
@cornernarrow2_End

@cornernarrow3:	spriteHeader
	spritePiece	0, -8, 1, 2, $13, 0, 0, 0, 0
@cornernarrow3_End

@vertwide:	spriteHeader
	spritePiece	-8, -$10, 2, 4, $15, 0, 0, 0, 0
@vertwide_End

@diagonal:	spriteHeader
	spritePiece	-$A, -8, 4, 1, $1D, 0, 0, 0, 0
	spritePiece	-$18, 0, 4, 1, $21, 0, 0, 0, 0
@diagonal_End

@splash1:	spriteHeader
	spritePiece	-$18, -$10, 3, 4, $25, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 4, $31, 0, 0, 0, 0
@splash1_End

@splash2:	spriteHeader
	spritePiece	-$18, -$10, 3, 4, $3D, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 4, $49, 0, 0, 0, 0
@splash2_End

@splash3:	spriteHeader
	spritePiece	-$18, -$10, 3, 4, $55, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 4, $61, 0, 0, 0, 0
@splash3_End

	even
