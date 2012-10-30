; ---------------------------------------------------------------------------
; Sprite mappings - SLZ	swinging platforms
; ---------------------------------------------------------------------------
Map_Swing_SLZ:	mappingsTable
	mappingsTableEntry.w	@block
	mappingsTableEntry.w	@chain
	mappingsTableEntry.w	@anchor

@block:	spriteHeader
	spritePiece	-$20, -$10, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$30, -$10, 2, 2, $14, 0, 0, 0, 0
	spritePiece	$20, -$10, 2, 2, $14, 1, 0, 0, 0
	spritePiece	-$20, $10, 2, 1, $18, 0, 0, 0, 0
	spritePiece	$10, $10, 2, 1, $18, 1, 0, 0, 0
	spritePiece	-8, $10, 1, 2, $1A, 0, 0, 0, 0
	spritePiece	0, $10, 1, 2, $1A, 1, 0, 0, 0
@block_End

@chain:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 2, 0
@chain_End

@anchor:	spriteHeader
	spritePiece	-8, -8, 2, 2, $1C, 0, 0, 0, 0
@anchor_End

	even
