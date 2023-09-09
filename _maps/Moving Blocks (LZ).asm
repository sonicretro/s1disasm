; ---------------------------------------------------------------------------
; Sprite mappings - moving block (LZ)
; ---------------------------------------------------------------------------
Map_MBlockLZ_internal:	mappingsTable
	mappingsTableEntry.w	.f0

.f0:	spriteHeader
	spritePiece	-$10, -8, 4, 2, 0, 0, 0, 0, 0
.f0_End

	even
