; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds from	the special stage results screen
; ---------------------------------------------------------------------------
Map_SSRC:	mappingsTable
	mappingsTableEntry.w	byte_CE02
	mappingsTableEntry.w	byte_CE08
	mappingsTableEntry.w	byte_CE0E
	mappingsTableEntry.w	byte_CE14
	mappingsTableEntry.w	byte_CE1A
	mappingsTableEntry.w	byte_CE20
	mappingsTableEntry.w	byte_CE26

byte_CE02:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 1, 0
byte_CE02_End

byte_CE08:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
byte_CE08_End

byte_CE0E:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 2, 0
byte_CE0E_End

byte_CE14:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 3, 0
byte_CE14_End

byte_CE1A:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 1, 0
byte_CE1A_End

byte_CE20:	spriteHeader
	spritePiece	-8, -8, 2, 2, $C, 0, 0, 1, 0
byte_CE20_End

byte_CE26:	spriteHeader
byte_CE26_End

	even
