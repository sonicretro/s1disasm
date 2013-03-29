; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER"	and "TIME OVER"
; ---------------------------------------------------------------------------
Map_Over:	mappingsTable
	mappingsTableEntry.w	byte_CBAC
	mappingsTableEntry.w	byte_CBB7
	mappingsTableEntry.w	byte_CBC2
	mappingsTableEntry.w	byte_CBCD

byte_CBAC:	spriteHeader
	spritePiece	-$48, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$28, -8, 4, 2, 8, 0, 0, 0, 0
byte_CBAC_End

byte_CBB7:	spriteHeader
	spritePiece	8, -8, 4, 2, $14, 0, 0, 0, 0
	spritePiece	$28, -8, 4, 2, $C, 0, 0, 0, 0
byte_CBB7_End

byte_CBC2:	spriteHeader
	spritePiece	-$3C, -8, 3, 2, $1C, 0, 0, 0, 0
	spritePiece	-$24, -8, 4, 2, 8, 0, 0, 0, 0
byte_CBC2_End

byte_CBCD:	spriteHeader
	spritePiece	$C, -8, 4, 2, $14, 0, 0, 0, 0
	spritePiece	$2C, -8, 4, 2, $C, 0, 0, 0, 0
byte_CBCD_End

	even
