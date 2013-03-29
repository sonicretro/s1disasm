; ---------------------------------------------------------------------------
; Sprite mappings - trapdoor (SBZ)
; ---------------------------------------------------------------------------
Map_Trap:	mappingsTable
	mappingsTableEntry.w	@closed
	mappingsTableEntry.w	@half
	mappingsTableEntry.w	@open

@closed:	spriteHeader
	spritePiece	-$40, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$20, -$C, 4, 3, 0, 1, 0, 0, 0
	spritePiece	0, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$20, -$C, 4, 3, 0, 1, 0, 0, 0
@closed_End

@half:	spriteHeader
	spritePiece	-$4A, -$E, 4, 4, $C, 0, 0, 0, 0
	spritePiece	-$2A, $1A, 4, 4, $C, 1, 1, 0, 0
	spritePiece	-$2A, 2, 3, 3, $1C, 0, 0, 0, 0
	spritePiece	-$42, $12, 3, 3, $1C, 1, 1, 0, 0
	spritePiece	$2A, -$E, 4, 4, $C, 1, 0, 0, 0
	spritePiece	$A, $1A, 4, 4, $C, 0, 1, 0, 0
	spritePiece	$12, 2, 3, 3, $1C, 1, 0, 0, 0
	spritePiece	$2A, $12, 3, 3, $1C, 0, 1, 0, 0
@half_End

@open:	spriteHeader
	spritePiece	-$4C, 0, 3, 4, $25, 0, 0, 0, 0
	spritePiece	-$4C, $20, 3, 4, $25, 0, 1, 0, 0
	spritePiece	$34, 0, 3, 4, $25, 0, 0, 0, 0
	spritePiece	$34, $20, 3, 4, $25, 0, 1, 0, 0
@open_End

	even
