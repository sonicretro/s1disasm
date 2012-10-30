; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	form a staircase (SLZ)
; ---------------------------------------------------------------------------
Map_Stair:	mappingsTable
	mappingsTableEntry.w	@block

@block:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $21, 0, 0, 0, 0
@block_End

	even
