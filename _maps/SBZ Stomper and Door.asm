; ---------------------------------------------------------------------------
; Sprite mappings - stomper and	platforms (SBZ)
; ---------------------------------------------------------------------------
Map_Stomp:	mappingsTable
	mappingsTableEntry.w	@door
	mappingsTableEntry.w	@stomper
	mappingsTableEntry.w	@stomper
	mappingsTableEntry.w	@stomper
	mappingsTableEntry.w	@bigdoor

@door:	spriteHeader
	spritePiece	-$40, -$C, 4, 3, $1AF, 0, 0, 1, 0
	spritePiece	-$20, -$C, 4, 3, $1B2, 0, 0, 1, 0
	spritePiece	0, -$C, 4, 3, $1B2, 0, 0, 1, 0
	spritePiece	$20, -$C, 4, 3, $1AF, 1, 0, 1, 0
@door_End

@stomper:	spriteHeader
	spritePiece	-$1C, -$20, 4, 1, $C, 0, 0, 0, 0
	spritePiece	4, -$20, 3, 1, $10, 0, 0, 0, 0
	spritePiece	-$1C, -$18, 4, 3, $13, 0, 0, 1, 0
	spritePiece	4, -$18, 3, 3, $1F, 0, 0, 1, 0
	spritePiece	-$1C, 0, 4, 3, $13, 0, 0, 1, 0
	spritePiece	4, 0, 3, 3, $1F, 0, 0, 1, 0
	spritePiece	-$1C, $18, 4, 1, $C, 0, 0, 0, 0
	spritePiece	4, $18, 3, 1, $10, 0, 0, 0, 0
@stomper_End

@bigdoor:	spriteHeader
	spritePiece	-$80, -$40, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$60, -$40, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$40, -$40, 4, 4, $20, 0, 0, 0, 0
	spritePiece	-$20, -$40, 4, 4, $10, 0, 0, 0, 0
	spritePiece	0, -$40, 4, 4, $20, 0, 0, 0, 0
	spritePiece	$20, -$40, 4, 4, $10, 0, 0, 0, 0
	spritePiece	$40, -$40, 4, 4, $30, 0, 0, 0, 0
	spritePiece	$60, -$40, 4, 2, $40, 0, 0, 0, 0
	spritePiece	-$80, -$20, 4, 4, $48, 0, 0, 0, 0
	spritePiece	-$40, -$20, 4, 4, $48, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $58, 0, 0, 0, 0
	spritePiece	-$80, 0, 4, 4, $48, 0, 0, 0, 0
	spritePiece	-$40, 0, 4, 4, $58, 0, 0, 0, 0
	spritePiece	-$80, $20, 4, 4, $58, 0, 0, 0, 0
@bigdoor_End

	even
