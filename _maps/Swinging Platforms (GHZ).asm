; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	and MZ swinging	platforms
; ---------------------------------------------------------------------------
Map_Swing_GHZ:	mappingsTable
	mappingsTableEntry.w	@block
	mappingsTableEntry.w	@chain
	mappingsTableEntry.w	@anchor

@block:	spriteHeader
	spritePiece	-$18, -8, 3, 2, 4, 0, 0, 0, 0
	spritePiece	0, -8, 3, 2, 4, 0, 0, 0, 0
@block_End

@chain:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
@chain_End

@anchor:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 0, 0
@anchor_End

	even
