; ---------------------------------------------------------------------------
; Sprite mappings - flash effect when you collect the giant ring
; ---------------------------------------------------------------------------
Map_Flash:	mappingsTable
	mappingsTableEntry.w	byte_A084
	mappingsTableEntry.w	byte_A08F
	mappingsTableEntry.w	byte_A0A4
	mappingsTableEntry.w	byte_A0B9
	mappingsTableEntry.w	byte_A0CE
	mappingsTableEntry.w	byte_A0E3
	mappingsTableEntry.w	byte_A0F8
	mappingsTableEntry.w	byte_A103

byte_A084:	spriteHeader
	spritePiece	0, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, 0, 0, 1, 0, 0
byte_A084_End

byte_A08F:	spriteHeader
	spritePiece	-$10, -$20, 4, 4, $10, 0, 0, 0, 0
	spritePiece	$10, -$20, 2, 4, $20, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $10, 0, 1, 0, 0
	spritePiece	$10, 0, 2, 4, $20, 0, 1, 0, 0
byte_A08F_End

byte_A0A4:	spriteHeader
	spritePiece	-$18, -$20, 4, 4, $28, 0, 0, 0, 0
	spritePiece	8, -$20, 3, 4, $38, 0, 0, 0, 0
	spritePiece	-$18, 0, 4, 4, $28, 0, 1, 0, 0
	spritePiece	8, 0, 3, 4, $38, 0, 1, 0, 0
byte_A0A4_End

byte_A0B9:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $34, 1, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $34, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $34, 1, 1, 0, 0
	spritePiece	0, 0, 4, 4, $34, 0, 1, 0, 0
byte_A0B9_End

byte_A0CE:	spriteHeader
	spritePiece	-$20, -$20, 3, 4, $38, 1, 0, 0, 0
	spritePiece	-8, -$20, 4, 4, $28, 1, 0, 0, 0
	spritePiece	-$20, 0, 3, 4, $38, 1, 1, 0, 0
	spritePiece	-8, 0, 4, 4, $28, 1, 1, 0, 0
byte_A0CE_End

byte_A0E3:	spriteHeader
	spritePiece	-$20, -$20, 2, 4, $20, 1, 0, 0, 0
	spritePiece	-$10, -$20, 4, 4, $10, 1, 0, 0, 0
	spritePiece	-$20, 0, 2, 4, $20, 1, 1, 0, 0
	spritePiece	-$10, 0, 4, 4, $10, 1, 1, 0, 0
byte_A0E3_End

byte_A0F8:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 0, 1, 1, 0, 0
byte_A0F8_End

byte_A103:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $44, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $44, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $44, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, $44, 1, 1, 0, 0
byte_A103_End

	even
