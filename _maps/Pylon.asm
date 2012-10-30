; ---------------------------------------------------------------------------
; Sprite mappings - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------
Map_Pylon:	mappingsTable
	mappingsTableEntry.w	@pylon

@pylon:	spriteHeader
	spritePiece	-$10, -$80, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, -$60, 4, 4, 0, 0, 1, 0, 0
	spritePiece	-$10, -$40, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, -$20, 4, 4, 0, 0, 1, 0, 0
	spritePiece	-$10, 0, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, $20, 4, 4, 0, 0, 1, 0, 0
	spritePiece	-$10, $40, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, $60, 4, 4, 0, 0, 1, 0, 0
	spritePiece	-$10, $7F, 4, 4, 0, 0, 0, 0, 0
@pylon_End

	even
