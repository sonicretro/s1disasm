; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------
Map_SS_R:	mappingsTable
	mappingsTableEntry.w	byte_1B912
	mappingsTableEntry.w	byte_1B918
	mappingsTableEntry.w	byte_1B91E

byte_1B912:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
byte_1B912_End

byte_1B918:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
byte_1B918_End

byte_1B91E:	spriteHeader
byte_1B91E_End

	even
