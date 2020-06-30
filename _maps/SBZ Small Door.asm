; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
Map_ADoor_internal:	mappingsTable
	mappingsTableEntry.w	.closed
	mappingsTableEntry.w	._01
	mappingsTableEntry.w	._02
	mappingsTableEntry.w	._03
	mappingsTableEntry.w	._04
	mappingsTableEntry.w	._05
	mappingsTableEntry.w	._06
	mappingsTableEntry.w	._07
	mappingsTableEntry.w	.open

.closed:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 0, 2, 4, 0, 1, 0, 0, 0
.closed_End

._01:	spriteHeader
	spritePiece	-8, -$24, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 4, 2, 4, 0, 1, 0, 0, 0
._01_End

._02:	spriteHeader
	spritePiece	-8, -$28, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 4, 0, 1, 0, 0, 0
._02_End

._03:	spriteHeader
	spritePiece	-8, -$2C, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $C, 2, 4, 0, 1, 0, 0, 0
._03_End

._04:	spriteHeader
	spritePiece	-8, -$30, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 4, 0, 1, 0, 0, 0
._04_End

._05:	spriteHeader
	spritePiece	-8, -$34, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $14, 2, 4, 0, 1, 0, 0, 0
._05_End

._06:	spriteHeader
	spritePiece	-8, -$38, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $18, 2, 4, 0, 1, 0, 0, 0
._06_End

._07:	spriteHeader
	spritePiece	-8, -$3C, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $1C, 2, 4, 0, 1, 0, 0, 0
._07_End

.open:	spriteHeader
	spritePiece	-8, -$40, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $20, 2, 4, 0, 1, 0, 0, 0
.open_End

		even
