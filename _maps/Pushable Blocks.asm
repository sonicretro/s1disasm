; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------
Map_Push_internal:	mappingsTable
	mappingsTableEntry.w	.single
	mappingsTableEntry.w	.four

.single:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 8, 0, 0, 0, 0	; single block
.single_End

.four:	spriteHeader
	spritePiece	-$40, -$10, 4, 4, 8, 0, 0, 0, 0	; row of 4 blocks
	spritePiece	-$20, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	$20, -$10, 4, 4, 8, 0, 0, 0, 0
.four_End

	even
