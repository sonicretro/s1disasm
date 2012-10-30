; ---------------------------------------------------------------------------
; Sprite mappings - special stage entry	from beta
; ---------------------------------------------------------------------------
Map_Vanish:	mappingsTable
	mappingsTableEntry.w	@flash1
	mappingsTableEntry.w	@flash2
	mappingsTableEntry.w	@flash3
	mappingsTableEntry.w	@sparkle1
	mappingsTableEntry.w	@sparkle2
	mappingsTableEntry.w	@sparkle3
	mappingsTableEntry.w	@sparkle4
	mappingsTableEntry.w	@blank

@flash1:	spriteHeader
	spritePiece	8, -8, 1, 1, 0, 0, 0, 0, 0
	spritePiece	0, 0, 2, 1, 1, 0, 0, 0, 0
	spritePiece	8, 8, 1, 1, 0, 0, 1, 0, 0
@flash1_End

@flash2:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, 3, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $B, 0, 0, 0, 0
	spritePiece	-$10, 8, 4, 2, 3, 0, 1, 0, 0
@flash2_End

@flash3:	spriteHeader
	spritePiece	-$C, -$1C, 4, 3, $F, 0, 0, 0, 0
	spritePiece	-$14, -$14, 1, 3, $1B, 0, 0, 0, 0
	spritePiece	-$C, -4, 4, 1, $1E, 0, 0, 0, 0
	spritePiece	-$C, 4, 4, 3, $F, 0, 1, 0, 0
	spritePiece	-$14, 4, 1, 2, $1B, 0, 1, 0, 0
@flash3_End

@sparkle1:	spriteHeader
	spritePiece	-8, -$10, 3, 1, $22, 0, 0, 0, 0
	spritePiece	-$10, -8, 4, 3, $25, 0, 0, 0, 0
	spritePiece	-$10, $10, 3, 1, $31, 0, 0, 0, 0
	spritePiece	$10, 0, 2, 2, $34, 0, 0, 0, 0
	spritePiece	$10, -8, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$18, -$10, 1, 1, $36, 1, 1, 0, 0
	spritePiece	$20, -8, 1, 1, $25, 1, 1, 0, 0
	spritePiece	$28, 0, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$30, -8, 1, 1, $25, 0, 0, 0, 0
@sparkle1_End

@sparkle2:	spriteHeader
	spritePiece	-$10, 0, 1, 1, $25, 1, 1, 0, 0
	spritePiece	-8, -8, 2, 1, $38, 0, 0, 0, 0
	spritePiece	8, -$10, 1, 1, $26, 0, 0, 0, 0
	spritePiece	0, 0, 1, 1, $25, 0, 0, 0, 0
	spritePiece	-8, 8, 1, 1, $25, 1, 1, 0, 0
	spritePiece	0, $10, 1, 1, $26, 0, 1, 0, 0
	spritePiece	8, 8, 1, 1, $38, 0, 1, 0, 0
	spritePiece	$10, -8, 1, 1, $29, 0, 0, 0, 0
	spritePiece	$10, 0, 1, 1, $26, 0, 0, 0, 0
	spritePiece	$18, 0, 1, 1, $2D, 0, 0, 0, 0
	spritePiece	$18, 8, 1, 1, $26, 1, 0, 0, 0
	spritePiece	$20, 8, 1, 1, $29, 0, 0, 0, 0
	spritePiece	$20, -8, 1, 1, $26, 0, 0, 0, 0
	spritePiece	$28, -8, 1, 1, $2D, 0, 0, 0, 0
	spritePiece	$28, 0, 1, 1, $3A, 0, 0, 0, 0
	spritePiece	$30, -8, 1, 1, $26, 1, 1, 0, 0
	spritePiece	$38, 0, 1, 1, $25, 0, 1, 0, 0
	spritePiece	$40, -8, 1, 1, $25, 0, 1, 0, 0
@sparkle2_End

@sparkle3:	spriteHeader
	spritePiece	0, -8, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$10, -$10, 1, 1, $38, 0, 0, 0, 0
	spritePiece	0, $10, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$10, 0, 1, 1, $25, 1, 1, 0, 0
	spritePiece	$18, 8, 1, 1, $25, 0, 1, 0, 0
	spritePiece	$20, -8, 1, 1, $25, 1, 1, 0, 0
	spritePiece	$28, 0, 1, 1, $26, 0, 1, 0, 0
	spritePiece	$30, -8, 1, 1, $25, 0, 1, 0, 0
	spritePiece	$30, 0, 1, 1, $25, 0, 0, 0, 0
	spritePiece	$30, 8, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$38, 0, 1, 1, $26, 1, 0, 0, 0
	spritePiece	$38, 8, 1, 1, $29, 0, 0, 0, 0
	spritePiece	$40, -8, 1, 1, $26, 1, 0, 0, 0
	spritePiece	$40, 0, 1, 1, $2D, 0, 0, 0, 0
	spritePiece	$48, -8, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$48, 0, 1, 1, $25, 0, 0, 0, 0
	spritePiece	$50, 0, 1, 1, $25, 0, 1, 0, 0
@sparkle3_End

@sparkle4:	spriteHeader
	spritePiece	$30, -4, 1, 1, $26, 1, 0, 0, 0
	spritePiece	$28, 4, 1, 1, $25, 1, 0, 0, 0
	spritePiece	$38, 4, 1, 1, $27, 0, 1, 0, 0
	spritePiece	$40, 4, 1, 1, $26, 1, 0, 0, 0
	spritePiece	$40, -4, 1, 1, $25, 0, 1, 0, 0
	spritePiece	$48, -4, 1, 1, $26, 0, 1, 0, 0
	spritePiece	$48, $C, 1, 1, $27, 1, 0, 0, 0
	spritePiece	$50, 4, 1, 1, $26, 1, 1, 0, 0
@blank	EQU	*+1
	spritePiece	$58, 4, 1, 1, $27, 1, 0, 0, 0
@sparkle4_End

	even
