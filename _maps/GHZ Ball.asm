; ---------------------------------------------------------------------------
; Sprite mappings - swinging ball on a chain from GHZ boss
; ---------------------------------------------------------------------------
Map_GBall:	mappingsTable
	mappingsTableEntry.w	@shiny
	mappingsTableEntry.w	@check1
	mappingsTableEntry.w	@check2
	mappingsTableEntry.w	@check3

@shiny:	spriteHeader
	spritePiece	-$10, -$10, 2, 1, $24, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 1, $24, 0, 1, 0, 0
	spritePiece	-$18, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 0, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, 0, 1, 1, 0, 0
@shiny_End

@check1:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, 9, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 9, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 9, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, 9, 1, 1, 0, 0
@check1_End

@check2:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, $12, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, $1B, 0, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, $1B, 1, 1, 0, 0
	spritePiece	0, 0, 3, 3, $12, 1, 1, 0, 0
@check2_End

@check3:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, $1B, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 3, $12, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, $12, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, $1B, 0, 1, 0, 0
@check3_End

	even
