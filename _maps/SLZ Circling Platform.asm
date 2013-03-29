; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	in circles (SLZ)
; ---------------------------------------------------------------------------
Map_Circ:	mappingsTable
	mappingsTableEntry.w	@platform

@platform:	spriteHeader
	spritePiece	-$18, -8, 3, 2, $51, 0, 0, 0, 0
	spritePiece	0, -8, 3, 2, $51, 1, 0, 0, 0
@platform_End

	even
