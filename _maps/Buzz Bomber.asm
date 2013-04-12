; ---------------------------------------------------------------------------
; Sprite mappings - Buzz Bomber	enemy
; ---------------------------------------------------------------------------
Map_Buzz:	mappingsTable
	mappingsTableEntry.w	@Fly1
	mappingsTableEntry.w	@Fly2
	mappingsTableEntry.w	@Fly3
	mappingsTableEntry.w	@Fly4
	mappingsTableEntry.w	@Fire1
	mappingsTableEntry.w	@Fire2

@Fly1:	spriteHeader
	spritePiece	-$18, -$C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$C, 3, 2, $F, 0, 0, 0, 0
	spritePiece	-$18, 4, 3, 1, $15, 0, 0, 0, 0
	spritePiece	0, 4, 2, 1, $18, 0, 0, 0, 0
	spritePiece	-$14, -$F, 3, 1, $1A, 0, 0, 0, 0
	spritePiece	4, -$F, 2, 1, $1D, 0, 0, 0, 0
@Fly1_End

@Fly2:	spriteHeader
	spritePiece	-$18, -$C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$C, 3, 2, $F, 0, 0, 0, 0
	spritePiece	-$18, 4, 3, 1, $15, 0, 0, 0, 0
	spritePiece	0, 4, 2, 1, $18, 0, 0, 0, 0
	spritePiece	-$14, -$C, 3, 1, $1F, 0, 0, 0, 0
	spritePiece	4, -$C, 2, 1, $22, 0, 0, 0, 0
@Fly2_End

@Fly3:	spriteHeader
	spritePiece	$C, 4, 1, 1, $30, 0, 0, 0, 0
	spritePiece	-$18, -$C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$C, 3, 2, $F, 0, 0, 0, 0
	spritePiece	-$18, 4, 3, 1, $15, 0, 0, 0, 0
	spritePiece	0, 4, 2, 1, $18, 0, 0, 0, 0
	spritePiece	-$14, -$F, 3, 1, $1A, 0, 0, 0, 0
	spritePiece	4, -$F, 2, 1, $1D, 0, 0, 0, 0
@Fly3_End

@Fly4:	spriteHeader
	spritePiece	$C, 4, 2, 1, $31, 0, 0, 0, 0
	spritePiece	-$18, -$C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$C, 3, 2, $F, 0, 0, 0, 0
	spritePiece	-$18, 4, 3, 1, $15, 0, 0, 0, 0
	spritePiece	0, 4, 2, 1, $18, 0, 0, 0, 0
	spritePiece	-$14, -$C, 3, 1, $1F, 0, 0, 0, 0
	spritePiece	4, -$C, 2, 1, $22, 0, 0, 0, 0
@Fly4_End

@Fire1:	spriteHeader
	spritePiece	-$14, -$C, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 1, 8, 0, 0, 0, 0
	spritePiece	$C, 4, 1, 1, $C, 0, 0, 0, 0
	spritePiece	-$C, $C, 2, 1, $D, 0, 0, 0, 0
	spritePiece	-$14, -$F, 3, 1, $1A, 0, 0, 0, 0
	spritePiece	4, -$F, 2, 1, $1D, 0, 0, 0, 0
@Fire1_End

@Fire2:	spriteHeader
	spritePiece	-$14, -$C, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 1, 8, 0, 0, 0, 0
	spritePiece	$C, 4, 1, 1, $C, 0, 0, 0, 0
	spritePiece	-$C, $C, 2, 1, $D, 0, 0, 0, 0
@Fire2_End
	spritePiece	-$14, -$C, 3, 1, $1F, 0, 0, 0, 0
	spritePiece	4, -$C, 2, 1, $22, 0, 0, 0, 0

	even
