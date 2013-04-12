; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball on a chain (SBZ) and big spiked ball (SYZ)
; ---------------------------------------------------------------------------
Map_BBall:	mappingsTable
	mappingsTableEntry.w	@ball
	mappingsTableEntry.w	@chain
	mappingsTableEntry.w	@anchor

@ball:	spriteHeader
	spritePiece	-8, -$18, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -$10, 4, 4, 2, 0, 0, 0, 0
	spritePiece	-$18, -8, 1, 2, $12, 0, 0, 0, 0
	spritePiece	$10, -8, 1, 2, $14, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 1, $16, 0, 0, 0, 0
@ball_End

@chain:	spriteHeader
	spritePiece	-8, -8, 2, 2, $20, 0, 0, 0, 0
@chain_End

@anchor:	spriteHeader
	spritePiece	-$10, -8, 4, 2, $18, 0, 0, 0, 0
	spritePiece	-$10, -$18, 4, 2, $18, 0, 1, 0, 0
@anchor_End

	even
