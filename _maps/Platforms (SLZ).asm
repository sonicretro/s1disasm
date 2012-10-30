; ---------------------------------------------------------------------------
; Sprite mappings - SLZ	platforms
; ---------------------------------------------------------------------------
Map_Plat_SLZ:	mappingsTable
	mappingsTableEntry.w	@platform

@platform:	spriteHeader
	spritePiece	-$20, -8, 4, 4, $21, 0, 0, 0, 0
	spritePiece	0, -8, 4, 4, $21, 0, 0, 0, 0
@platform_End

	even
