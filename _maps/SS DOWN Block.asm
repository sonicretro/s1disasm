; ---------------------------------------------------------------------------
; Sprite mappings - special stage "DOWN" block
; ---------------------------------------------------------------------------
Map_SS_Down:	mappingsTable
	mappingsTableEntry.w	byte_1B954
	mappingsTableEntry.w	byte_1B95A

byte_1B954:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
byte_1B954_End

byte_1B95A:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
byte_1B95A_End

	even
