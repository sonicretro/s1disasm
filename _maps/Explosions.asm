; ---------------------------------------------------------------------------
; Sprite mappings - explosion from a badnik or monitor
; ---------------------------------------------------------------------------
Map_ExplodeItem:	mappingsTable
	mappingsTableEntry.w	byte_8ED0
	mappingsTableEntry.w	byte_8ED6
	mappingsTableEntry.w	byte_8EDC
	mappingsTableEntry.w	byte_8EE2
	mappingsTableEntry.w	byte_8EF7

byte_8ED0:	spriteHeader
	spritePiece	-$C, -8, 3, 2, 0, 0, 0, 0, 0
byte_8ED0_End

byte_8ED6:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 6, 0, 0, 0, 0
byte_8ED6_End

byte_8EDC:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $16, 0, 0, 0, 0
byte_8EDC_End

byte_8EE2:	spriteHeader
	spritePiece	-$14, -$14, 3, 3, $26, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $2F, 0, 0, 0, 0
	spritePiece	-$14, 4, 2, 2, $2F, 1, 1, 0, 0
	spritePiece	-4, -4, 3, 3, $26, 1, 1, 0, 0
byte_8EE2_End

byte_8EF7:	spriteHeader
	spritePiece	-$14, -$14, 3, 3, $33, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $3C, 0, 0, 0, 0
	spritePiece	-$14, 4, 2, 2, $3C, 1, 1, 0, 0
	spritePiece	-4, -4, 3, 3, $33, 1, 1, 0, 0
byte_8EF7_End

	even
; ---------------------------------------------------------------------------
; Sprite mappings - explosion from when	a boss is destroyed
; ---------------------------------------------------------------------------
Map_ExplodeBomb:	mappingsTable
	mappingsTableEntry.w	byte_8ED0
	mappingsTableEntry.w	byte_8F16
	mappingsTableEntry.w	byte_8F1C
	mappingsTableEntry.w	byte_8EE2
	mappingsTableEntry.w	byte_8EF7

byte_8F16:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $40, 0, 0, 0, 0
byte_8F16_End

byte_8F1C:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $50, 0, 0, 0, 0
byte_8F1C_End

	even
