; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
Map_ADoor_internal:	mappingsTable
	mappingsTableEntry.w	.closed
	mappingsTableEntry.w	.f01
	mappingsTableEntry.w	.f02
	mappingsTableEntry.w	.f03
	mappingsTableEntry.w	.f04
	mappingsTableEntry.w	.f05
	mappingsTableEntry.w	.f06
	mappingsTableEntry.w	.f07
	mappingsTableEntry.w	.open

.closed:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 1, 0, 0, 0	; door closed
	spritePiece	-8, 0, 2, 4, 0, 1, 0, 0, 0
.closed_End

.f01:	spriteHeader
	spritePiece	-8, -$24, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 4, 2, 4, 0, 1, 0, 0, 0
.f01_End

.f02:	spriteHeader
	spritePiece	-8, -$28, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 4, 0, 1, 0, 0, 0
.f02_End

.f03:	spriteHeader
	spritePiece	-8, -$2C, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $C, 2, 4, 0, 1, 0, 0, 0
.f03_End

.f04:	spriteHeader
	spritePiece	-8, -$30, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 4, 0, 1, 0, 0, 0
.f04_End

.f05:	spriteHeader
	spritePiece	-8, -$34, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $14, 2, 4, 0, 1, 0, 0, 0
.f05_End

.f06:	spriteHeader
	spritePiece	-8, -$38, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $18, 2, 4, 0, 1, 0, 0, 0
.f06_End

.f07:	spriteHeader
	spritePiece	-8, -$3C, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $1C, 2, 4, 0, 1, 0, 0, 0
.f07_End

.open:	spriteHeader
	spritePiece	-8, -$40, 2, 4, 0, 1, 0, 0, 0	; door fully open
	spritePiece	-8, $20, 2, 4, 0, 1, 0, 0, 0
.open_End

	even
