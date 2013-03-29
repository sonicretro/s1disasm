; ---------------------------------------------------------------------------
; Sprite mappings - Unused switch thingy
; ---------------------------------------------------------------------------
Map_Swi:	mappingsTable
	mappingsTableEntry.w	byte_891E

byte_891E:	spriteHeader
	spritePiece	-$10, -$18, 2, 4, $54, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, $5C, 0, 0, 0, 0
	spritePiece	0, -$18, 2, 4, $54, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, $5C, 0, 0, 0, 0
byte_891E_End

	even
