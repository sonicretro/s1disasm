; ---------------------------------------------------------------------------
; Sprite mappings - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------
Map_Yad:	mappingsTable
	mappingsTableEntry.w	@walk0
	mappingsTableEntry.w	@walk1
	mappingsTableEntry.w	@walk2
	mappingsTableEntry.w	@walk3
	mappingsTableEntry.w	@walk4
	mappingsTableEntry.w	@walk5

@walk0:	spriteHeader
	spritePiece	-$C, -$C, 3, 1, 0, 0, 0, 0, 0
	spritePiece	-$14, -4, 4, 3, 3, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, $F, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $11, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $31, 0, 0, 0, 0
@walk0_End

@walk1:	spriteHeader
	spritePiece	-$C, -$C, 3, 1, $14, 0, 0, 0, 0
	spritePiece	-$14, -4, 4, 3, $17, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, $F, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $11, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $31, 0, 0, 0, 0
@walk1_End

@walk2:	spriteHeader
	spritePiece	-$C, -$C, 3, 2, $23, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 2, $29, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, $F, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $11, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $31, 0, 0, 0, 0
@walk2_End

@walk3:	spriteHeader
	spritePiece	-$C, -$C, 3, 1, 0, 0, 0, 0, 0
	spritePiece	-$14, -4, 4, 3, 3, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, $F, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $11, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $37, 0, 0, 0, 0
@walk3_End

@walk4:	spriteHeader
	spritePiece	-$C, -$C, 3, 1, $14, 0, 0, 0, 0
	spritePiece	-$14, -4, 4, 3, $17, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, $F, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $11, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $37, 0, 0, 0, 0
@walk4_End

@walk5:	spriteHeader
	spritePiece	-$C, -$C, 3, 2, $23, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 2, $29, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, $F, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $11, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $37, 0, 0, 0, 0
@walk5_End

	even
