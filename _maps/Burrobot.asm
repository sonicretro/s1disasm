; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------
Map_Burro:	mappingsTable
	mappingsTableEntry.w	@walk1
	mappingsTableEntry.w	@walk2
	mappingsTableEntry.w	@digging1
	mappingsTableEntry.w	@digging2
	mappingsTableEntry.w	@fall
	mappingsTableEntry.w	@facedown
	mappingsTableEntry.w	@walk3

@walk1:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, 9, 0, 0, 0, 0
@walk1_End

@walk2:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $18, 0, 0, 0, 0
@walk2_End

@digging1:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $1E, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 3, $27, 0, 0, 0, 0
@digging1_End

@digging2:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $30, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 3, $39, 0, 0, 0, 0
@digging2_End

@fall:	spriteHeader
	spritePiece	-$10, -$18, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 3, $42, 0, 0, 0, 0
@fall_End

@facedown:	spriteHeader
	spritePiece	-$18, -$C, 2, 3, $4B, 0, 0, 0, 0
	spritePiece	-8, -$C, 3, 3, $51, 0, 0, 0, 0
@facedown_End

@walk3:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, 9, 0, 0, 0, 0
@walk3_End

	even
