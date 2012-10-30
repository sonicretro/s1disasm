; ---------------------------------------------------------------------------
; Sprite mappings - spiked balls on the	seesaws	(SLZ)
; ---------------------------------------------------------------------------
Map_SSawBall:	mappingsTable
	mappingsTableEntry.w	@red
	mappingsTableEntry.w	@silver

@red:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
@red_End

@silver:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
@silver_End

	even
