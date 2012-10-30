; ---------------------------------------------------------------------------
; Sprite mappings - gargoyle head (LZ)
; ---------------------------------------------------------------------------
Map_Gar:	mappingsTable
	mappingsTableEntry.w	@head
	mappingsTableEntry.w	@head
	mappingsTableEntry.w	@fireball1
	mappingsTableEntry.w	@fireball2

@head:	spriteHeader
	spritePiece	0, -$10, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-8, 8, 3, 1, $A, 0, 0, 0, 0
@head_End

@fireball1:	spriteHeader
	spritePiece	-8, -4, 2, 1, $D, 0, 0, 0, 0
@fireball1_End

@fireball2:	spriteHeader
	spritePiece	-8, -4, 2, 1, $F, 0, 0, 0, 0
@fireball2_End

	even
