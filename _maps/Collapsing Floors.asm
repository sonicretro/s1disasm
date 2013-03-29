; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ,	SBZ)
; ---------------------------------------------------------------------------
Map_CFlo:	mappingsTable
	mappingsTableEntry.w	byte_874E
	mappingsTableEntry.w	byte_8763
	mappingsTableEntry.w	byte_878C
	mappingsTableEntry.w	byte_87A1

byte_874E:	spriteHeader
	spritePiece	-$20, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 4, 2, 0, 0, 0, 0, 0
byte_874E_End

byte_8763:	spriteHeader
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, 8, 2, 2, 0, 0, 0, 0, 0
byte_8763_End

byte_878C:	spriteHeader
	spritePiece	-$20, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 4, 2, 8, 0, 0, 0, 0
	spritePiece	0, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 4, 2, 8, 0, 0, 0, 0
byte_878C_End

byte_87A1:	spriteHeader
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$20, 8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, $C, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	$10, 8, 2, 2, $C, 0, 0, 0, 0
byte_87A1_End

	even
