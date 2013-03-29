; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Moto:	mappingsTable
	mappingsTableEntry.w	@moto1
	mappingsTableEntry.w	@moto2
	mappingsTableEntry.w	@moto3
	mappingsTableEntry.w	@smoke1
	mappingsTableEntry.w	@smoke2
	mappingsTableEntry.w	@smoke3
	mappingsTableEntry.w	@blank

@moto1:	spriteHeader
	spritePiece	-$14, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 0, 4, 1, 8, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$C, 8, 3, 1, $E, 0, 0, 0, 0
@moto1_End

@moto2:	spriteHeader
	spritePiece	-$14, -$F, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 1, 4, 1, 8, 0, 0, 0, 0
	spritePiece	$C, -7, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $11, 0, 0, 0, 0
@moto2_End

@moto3:	spriteHeader
	spritePiece	-$14, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 0, 4, 1, $14, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$14, 8, 2, 1, $18, 0, 0, 0, 0
	spritePiece	-4, 8, 2, 1, $12, 0, 0, 0, 0
@moto3_End

@smoke1:	spriteHeader
	spritePiece	$10, -6, 1, 1, $1A, 0, 0, 0, 0
@smoke1_End

@smoke2:	spriteHeader
	spritePiece	$10, -6, 1, 1, $1B, 0, 0, 0, 0
@smoke2_End

@smoke3:	spriteHeader
	spritePiece	$10, -6, 1, 1, $1C, 0, 0, 0, 0
@smoke3_End

@blank:	spriteHeader
@blank_End

	even
