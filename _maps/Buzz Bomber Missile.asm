; ---------------------------------------------------------------------------
; Sprite mappings - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
Map_Missile:	mappingsTable
	mappingsTableEntry.w	@Flare1
	mappingsTableEntry.w	@Flare2
	mappingsTableEntry.w	@Ball1
	mappingsTableEntry.w	@Ball2

@Flare1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $24, 0, 0, 0, 0
@Flare1_End

@Flare2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $28, 0, 0, 0, 0
@Flare2_End

@Ball1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $2C, 0, 0, 0, 0
@Ball1_End

@Ball2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $33, 0, 0, 0, 0
@Ball2_End

	even
