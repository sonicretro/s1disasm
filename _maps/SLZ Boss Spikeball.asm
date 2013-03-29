; ---------------------------------------------------------------------------
; Sprite mappings - exploding spikeys that the SLZ boss	drops
; ---------------------------------------------------------------------------
Map_BSBall:	mappingsTable
	mappingsTableEntry.w	@fireball1
	mappingsTableEntry.w	@fireball2

@fireball1:	spriteHeader
	spritePiece	-4, -4, 1, 1, $27, 0, 0, 0, 0
@fireball1_End

@fireball2:	spriteHeader
	spritePiece	-4, -4, 1, 1, $28, 0, 0, 0, 0
@fireball2_End

	even
