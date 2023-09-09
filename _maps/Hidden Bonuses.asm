; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of	a level
; ---------------------------------------------------------------------------
Map_Bonus_internal:	mappingsTable
	mappingsTableEntry.w	.blank
	mappingsTableEntry.w	._10000
	mappingsTableEntry.w	._1000
	mappingsTableEntry.w	._100

.blank:	spriteHeader
.blank_End

._10000:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
._10000_End

._1000:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
._1000_End

._100:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $18, 0, 0, 0, 0
._100_End

	even
