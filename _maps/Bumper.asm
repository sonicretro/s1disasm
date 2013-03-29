; ---------------------------------------------------------------------------
; Sprite mappings - pinball bumper (SYZ)
; ---------------------------------------------------------------------------
Map_Bump:	mappingsTable
	mappingsTableEntry.w	@normal
	mappingsTableEntry.w	@bumped1
	mappingsTableEntry.w	@bumped2

@normal:	spriteHeader
	spritePiece	-$10, -$10, 2, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 4, 0, 1, 0, 0, 0
@normal_End

@bumped1:	spriteHeader
	spritePiece	-$C, -$C, 2, 3, 8, 0, 0, 0, 0
	spritePiece	4, -$C, 1, 3, 8, 1, 0, 0, 0
@bumped1_End

@bumped2:	spriteHeader
	spritePiece	-$10, -$10, 2, 4, $E, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 4, $E, 1, 0, 0, 0
@bumped2_End

	even
