; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (MZ, SBZ)
; ---------------------------------------------------------------------------
Map_MBlock:	mappingsTable
	mappingsTableEntry.w	@mz1
	mappingsTableEntry.w	@mz2
	mappingsTableEntry.w	@sbz
	mappingsTableEntry.w	@sbzwide
	mappingsTableEntry.w	@mz3

@mz1:	spriteHeader
	spritePiece	-$10, -8, 4, 4, 8, 0, 0, 0, 0
@mz1_End

@mz2:	spriteHeader
	spritePiece	-$20, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	0, -8, 4, 4, 8, 0, 0, 0, 0
@mz2_End

@sbz:	spriteHeader
	spritePiece	-$20, -8, 4, 1, 0, 0, 0, 1, 0
	spritePiece	-$20, 0, 4, 2, 4, 0, 0, 0, 0
	spritePiece	0, -8, 4, 1, 0, 0, 0, 1, 0
	spritePiece	0, 0, 4, 2, 4, 0, 0, 0, 0
@sbz_End

@sbzwide:	spriteHeader
	spritePiece	-$40, -8, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$20, -8, 4, 3, 3, 0, 0, 0, 0
	spritePiece	0, -8, 4, 3, 3, 0, 0, 0, 0
	spritePiece	$20, -8, 4, 3, 0, 1, 0, 0, 0
@sbzwide_End

@mz3:	spriteHeader
	spritePiece	-$30, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	-$10, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	$10, -8, 4, 4, 8, 0, 0, 0, 0
@mz3_End

	even
