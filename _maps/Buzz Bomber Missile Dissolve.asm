; ---------------------------------------------------------------------------
; Sprite mappings - buzz bomber missile vanishing
; ---------------------------------------------------------------------------
Map_MisDissolve:	mappingsTable
	mappingsTableEntry.w	byte_8EAE
	mappingsTableEntry.w	byte_8EB4
	mappingsTableEntry.w	byte_8EBA
	mappingsTableEntry.w	byte_8EC0

byte_8EAE:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
byte_8EAE_End

byte_8EB4:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
byte_8EB4_End

byte_8EBA:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
byte_8EBA_End

byte_8EC0:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $1B, 0, 0, 0, 0
byte_8EC0_End

	even
