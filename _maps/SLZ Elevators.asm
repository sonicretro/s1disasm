; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	when you stand on them (SLZ)
; ---------------------------------------------------------------------------
Map_Elev:	mappingsTable
	mappingsTableEntry.w	@elevator

@elevator:	spriteHeader
	spritePiece	-$28, -8, 4, 4, $41, 0, 0, 0, 0
	spritePiece	-8, -8, 4, 4, $41, 0, 0, 0, 0
	spritePiece	$18, -8, 2, 4, $41, 0, 0, 0, 0
@elevator_End

	even
