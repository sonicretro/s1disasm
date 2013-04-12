; ---------------------------------------------------------------------------
; Sprite mappings - special stage "UP" block
; ---------------------------------------------------------------------------
Map_SS_Up:	mappingsTable
	mappingsTableEntry.w	byte_1B944
	mappingsTableEntry.w	byte_1B94A

byte_1B944:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
byte_1B944_End

byte_1B94A:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
byte_1B94A_End

	even
