; ---------------------------------------------------------------------------
; Sprite mappings - blocks (LZ)
; ---------------------------------------------------------------------------
Map_LBlock:	mappingsTable
	mappingsTableEntry.w	@sinkblock
	mappingsTableEntry.w	@riseplatform
	mappingsTableEntry.w	@cork
	mappingsTableEntry.w	@block

@sinkblock:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
@sinkblock_End

@riseplatform:	spriteHeader
	spritePiece	-$20, -$C, 4, 3, $69, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 3, $75, 0, 0, 0, 0
@riseplatform_End

@cork:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $11A, 0, 0, 0, 0
@cork_End

@block:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $5FA, 1, 1, 3, 1
@block_End

	even
