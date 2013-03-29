; ---------------------------------------------------------------------------
; Sprite mappings - special stage breakable glass blocks and red-white blocks
; ---------------------------------------------------------------------------
Map_SS_Glass:	mappingsTable
	mappingsTableEntry.w	byte_1B928
	mappingsTableEntry.w	byte_1B92E
	mappingsTableEntry.w	byte_1B934
	mappingsTableEntry.w	byte_1B93A

byte_1B928:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
byte_1B928_End

byte_1B92E:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 1, 0, 0, 0
byte_1B92E_End

byte_1B934:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 1, 1, 0, 0
byte_1B934_End

byte_1B93A:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 1, 0, 0
byte_1B93A_End

	even
