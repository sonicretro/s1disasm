; ---------------------------------------------------------------------------
; Sprite mappings - SYZ	platforms
; ---------------------------------------------------------------------------
Map_Plat_SYZ:	mappingsTable
	mappingsTableEntry.w	@platform

@platform:	spriteHeader
	spritePiece	-$20, -$A, 3, 4, $49, 0, 0, 0, 0
	spritePiece	-8, -$A, 2, 4, $51, 0, 0, 0, 0
	spritePiece	8, -$A, 3, 4, $55, 0, 0, 0, 0
@platform_End

	even
