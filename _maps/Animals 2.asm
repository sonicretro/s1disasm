; ---------------------------------------------------------------------------
; Sprite mappings - animals
; ---------------------------------------------------------------------------
Map_Animal2:	mappingsTable
	mappingsTableEntry.w	byte_948A
	mappingsTableEntry.w	byte_9490
	mappingsTableEntry.w	byte_9484

byte_9484:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
byte_9484_End

byte_948A:	spriteHeader
	spritePiece	-8, -4, 2, 2, 6, 0, 0, 0, 0
byte_948A_End

byte_9490:	spriteHeader
	spritePiece	-8, -4, 2, 2, $A, 0, 0, 0, 0
byte_9490_End

	even
