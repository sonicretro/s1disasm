; ---------------------------------------------------------------------------
; Sprite mappings - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------
Map_HUD:	mappingsTable
	mappingsTableEntry.w	@allyellow
	mappingsTableEntry.w	@ringred
	mappingsTableEntry.w	@timered
	mappingsTableEntry.w	@allred

@allyellow:	spriteHeader
	spritePiece	0, -$80, 4, 2, 0, 0, 0, 0, 1
	spritePiece	$20, -$80, 4, 2, $18, 0, 0, 0, 1
	spritePiece	$40, -$80, 4, 2, $20, 0, 0, 0, 1
	spritePiece	0, -$70, 4, 2, $10, 0, 0, 0, 1
	spritePiece	$28, -$70, 4, 2, $28, 0, 0, 0, 1
	spritePiece	0, -$60, 4, 2, 8, 0, 0, 0, 1
	spritePiece	$20, -$60, 1, 2, 0, 0, 0, 0, 1
	spritePiece	$30, -$60, 3, 2, $30, 0, 0, 0, 1
	spritePiece	0, $40, 2, 2, $10A, 0, 0, 0, 1
	spritePiece	$10, $40, 4, 2, $10E, 0, 0, 0, 1
@allyellow_End
	even
@ringred:	spriteHeader
	spritePiece	0, -$80, 4, 2, 0, 0, 0, 0, 1
	spritePiece	$20, -$80, 4, 2, $18, 0, 0, 0, 1
	spritePiece	$40, -$80, 4, 2, $20, 0, 0, 0, 1
	spritePiece	0, -$70, 4, 2, $10, 0, 0, 0, 1
	spritePiece	$28, -$70, 4, 2, $28, 0, 0, 0, 1
	spritePiece	0, -$60, 4, 2, 8, 0, 0, 1, 1
	spritePiece	$20, -$60, 1, 2, 0, 0, 0, 1, 1
	spritePiece	$30, -$60, 3, 2, $30, 0, 0, 0, 1
	spritePiece	0, $40, 2, 2, $10A, 0, 0, 0, 1
	spritePiece	$10, $40, 4, 2, $10E, 0, 0, 0, 1
@ringred_End
	even
@timered:	spriteHeader
	spritePiece	0, -$80, 4, 2, 0, 0, 0, 0, 1
	spritePiece	$20, -$80, 4, 2, $18, 0, 0, 0, 1
	spritePiece	$40, -$80, 4, 2, $20, 0, 0, 0, 1
	spritePiece	0, -$70, 4, 2, $10, 0, 0, 1, 1
	spritePiece	$28, -$70, 4, 2, $28, 0, 0, 0, 1
	spritePiece	0, -$60, 4, 2, 8, 0, 0, 0, 1
	spritePiece	$20, -$60, 1, 2, 0, 0, 0, 0, 1
	spritePiece	$30, -$60, 3, 2, $30, 0, 0, 0, 1
	spritePiece	0, $40, 2, 2, $10A, 0, 0, 0, 1
	spritePiece	$10, $40, 4, 2, $10E, 0, 0, 0, 1
@timered_End
	even
@allred:	spriteHeader
	spritePiece	0, -$80, 4, 2, 0, 0, 0, 0, 1
	spritePiece	$20, -$80, 4, 2, $18, 0, 0, 0, 1
	spritePiece	$40, -$80, 4, 2, $20, 0, 0, 0, 1
	spritePiece	0, -$70, 4, 2, $10, 0, 0, 1, 1
	spritePiece	$28, -$70, 4, 2, $28, 0, 0, 0, 1
	spritePiece	0, -$60, 4, 2, 8, 0, 0, 1, 1
	spritePiece	$20, -$60, 1, 2, 0, 0, 0, 1, 1
	spritePiece	$30, -$60, 3, 2, $30, 0, 0, 0, 1
	spritePiece	0, $40, 2, 2, $10A, 0, 0, 0, 1
	spritePiece	$10, $40, 4, 2, $10E, 0, 0, 0, 1
@allred_End

	even
