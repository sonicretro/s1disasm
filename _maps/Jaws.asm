; ---------------------------------------------------------------------------
; Sprite mappings - Jaws enemy (LZ)
; ---------------------------------------------------------------------------
Map_Jaws:	mappingsTable
	mappingsTableEntry.w	@open1
	mappingsTableEntry.w	@shut1
	mappingsTableEntry.w	@open2
	mappingsTableEntry.w	@shut2

@open1:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $18, 0, 0, 0, 0
@open1_End

@shut1:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $1C, 0, 0, 0, 0
@shut1_End

@open2:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $18, 0, 1, 0, 0
@open2_End

@shut2:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $1C, 0, 1, 0, 0
@shut2_End

	even
