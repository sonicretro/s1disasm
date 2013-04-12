; ---------------------------------------------------------------------------
; Sprite mappings - animals
; ---------------------------------------------------------------------------
Map_Animal3:	mappingsTable
	mappingsTableEntry.w	byte_94A2
	mappingsTableEntry.w	byte_94A8
	mappingsTableEntry.w	byte_949C

byte_949C:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
byte_949C_End

byte_94A2:	spriteHeader
	spritePiece	-$C, -4, 3, 2, 6, 0, 0, 0, 0
byte_94A2_End

byte_94A8:	spriteHeader
	spritePiece	-$C, -4, 3, 2, $C, 0, 0, 0, 0
byte_94A8_End

	even
