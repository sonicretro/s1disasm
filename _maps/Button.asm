; ---------------------------------------------------------------------------
; Sprite mappings - switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------
Map_But:	mappingsTable
	mappingsTableEntry.w	byte_BEAC
	mappingsTableEntry.w	byte_BEB7
	mappingsTableEntry.w	byte_BEC2
	mappingsTableEntry.w	byte_BEB7

byte_BEAC:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 0, 1, 0, 0, 0
byte_BEAC_End

byte_BEB7:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 4, 1, 0, 0, 0
byte_BEB7_End

byte_BEC2:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, $7FC, 1, 1, 3, 1
	spritePiece	0, -$B, 2, 2, $7FC, 0, 0, 0, 0
byte_BEC2_End
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0

	even
