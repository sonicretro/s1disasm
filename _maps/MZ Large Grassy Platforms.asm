; ---------------------------------------------------------------------------
; Sprite mappings - large moving grass-covered platforms (MZ)
; ---------------------------------------------------------------------------
Map_LGrass:	mappingsTable
	mappingsTableEntry.w	@wide
	mappingsTableEntry.w	@sloped
	mappingsTableEntry.w	@narrow

@wide:	spriteHeader
	spritePiece	-$40, -$28, 2, 3, $57, 0, 0, 0, 0
	spritePiece	-$40, -$10, 2, 2, $53, 0, 0, 0, 0
	spritePiece	-$40, 0, 4, 4, 1, 0, 0, 0, 0
	spritePiece	-$30, -$30, 4, 4, $27, 0, 0, 0, 0
	spritePiece	-$30, -$10, 4, 2, $37, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 1, 0, 0, 0, 0
	spritePiece	-$10, -$30, 4, 4, $11, 0, 0, 0, 0
	spritePiece	$10, -$30, 4, 4, $3F, 0, 0, 0, 0
	spritePiece	$10, -$10, 4, 2, $4F, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 1, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, 1, 0, 0, 0, 0
	spritePiece	$30, -$28, 2, 3, $57, 0, 0, 0, 0
	spritePiece	$30, -$10, 2, 2, $53, 0, 0, 0, 0
@wide_End

@sloped:	spriteHeader
	spritePiece	-$40, -$30, 4, 4, $27, 0, 0, 0, 0
	spritePiece	-$40, -$10, 4, 2, $37, 0, 0, 0, 0
	spritePiece	-$40, 0, 4, 4, 1, 0, 0, 0, 0
	spritePiece	-$20, -$40, 4, 4, $27, 0, 0, 0, 0
	spritePiece	-$20, -$20, 4, 2, $37, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 1, 0, 0, 0, 0
	spritePiece	0, -$40, 4, 4, $11, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 1, 0, 0, 0, 0
	spritePiece	$20, -$40, 4, 4, $3F, 0, 0, 0, 0
	spritePiece	$20, -$20, 4, 2, $4F, 0, 0, 0, 0
@sloped_End

@narrow:	spriteHeader
	spritePiece	-$20, -$30, 4, 4, $11, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 1, 0, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, 1, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $11, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 1, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, 1, 0, 0, 0, 0
@narrow_End

	even
