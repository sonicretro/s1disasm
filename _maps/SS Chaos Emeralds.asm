; ---------------------------------------------------------------------------
; Sprite mappings - special stage chaos	emeralds
; ---------------------------------------------------------------------------
Map_SS_Chaos1:	mappingsTable
	mappingsTableEntry.w	byte_1B96C
	mappingsTableEntry.w	byte_1B97E
Map_SS_Chaos2:	mappingsTable
	mappingsTableEntry.w	byte_1B972
	mappingsTableEntry.w	byte_1B97E
Map_SS_Chaos3:	mappingsTable
	mappingsTableEntry.w	byte_1B978
	mappingsTableEntry.w	byte_1B97E

byte_1B96C:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
byte_1B96C_End

byte_1B972:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0
byte_1B972_End

byte_1B978:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 0, 0
byte_1B978_End

byte_1B97E:	spriteHeader
	spritePiece	-8, -8, 2, 2, $C, 0, 0, 0, 0
byte_1B97E_End

		even
