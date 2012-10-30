; ---------------------------------------------------------------------------
; Sprite mappings - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------
Map_Elec:	mappingsTable
	mappingsTableEntry.w	@normal
	mappingsTableEntry.w	@zap1
	mappingsTableEntry.w	@zap2
	mappingsTableEntry.w	@zap3
	mappingsTableEntry.w	@zap4
	mappingsTableEntry.w	@zap5

@normal:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
@normal_End

@zap1:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
@zap1_End

@zap2:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	8, -$A, 4, 2, $C, 0, 0, 0, 0
	spritePiece	-$24, -$A, 4, 2, $C, 1, 0, 0, 0
@zap2_End

@zap3:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	8, -$A, 4, 2, $C, 0, 0, 0, 0
	spritePiece	-$24, -$A, 4, 2, $C, 1, 0, 0, 0
@zap3_End

@zap4:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	8, -$A, 4, 2, $C, 0, 1, 0, 0
	spritePiece	-$24, -$A, 4, 2, $C, 1, 1, 0, 0
	spritePiece	$24, -$A, 4, 2, $C, 0, 0, 0, 0
	spritePiece	-$40, -$A, 4, 2, $C, 1, 0, 0, 0
@zap4_End

@zap5:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	$24, -$A, 4, 2, $C, 0, 1, 0, 0
	spritePiece	-$40, -$A, 4, 2, $C, 1, 1, 0, 0
@zap5_End

	even
