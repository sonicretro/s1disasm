; ---------------------------------------------------------------------------
; Sprite mappings - points that	appear when you	destroy	something
; ---------------------------------------------------------------------------
Map_Poi:	mappingsTable
	mappingsTableEntry.w	byte_94BC
	mappingsTableEntry.w	byte_94C2
	mappingsTableEntry.w	byte_94C8
	mappingsTableEntry.w	byte_94CE
	mappingsTableEntry.w	byte_94D4
	mappingsTableEntry.w	byte_94DA
	mappingsTableEntry.w	byte_94E5

byte_94BC:	spriteHeader
	spritePiece	-8, -4, 2, 1, 0, 0, 0, 0, 0
byte_94BC_End

byte_94C2:	spriteHeader
	spritePiece	-8, -4, 2, 1, 2, 0, 0, 0, 0
byte_94C2_End

byte_94C8:	spriteHeader
	spritePiece	-8, -4, 2, 1, 4, 0, 0, 0, 0
byte_94C8_End

byte_94CE:	spriteHeader
	spritePiece	-8, -4, 3, 1, 6, 0, 0, 0, 0
byte_94CE_End

byte_94D4:	spriteHeader
	spritePiece	-4, -4, 1, 1, 6, 0, 0, 0, 0
byte_94D4_End

byte_94DA:	spriteHeader
	spritePiece	-$C, -4, 3, 1, 6, 0, 0, 0, 0
	spritePiece	1, -4, 2, 1, 7, 0, 0, 0, 0
byte_94DA_End

byte_94E5:	spriteHeader
	spritePiece	-$C, -4, 3, 1, 6, 0, 0, 0, 0
	spritePiece	6, -4, 2, 1, 7, 0, 0, 0, 0
byte_94E5_End

	even
