; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	disintegrate when Eggman presses a switch
; ---------------------------------------------------------------------------
Map_FFloor:	mappingsTable
	mappingsTableEntry.w	@wholeblock
	mappingsTableEntry.w	@topleft
	mappingsTableEntry.w	@topright
	mappingsTableEntry.w	@bottomleft
	mappingsTableEntry.w	@bottomright

@wholeblock:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
@wholeblock_End

@topleft:	spriteHeader
	spritePiece	-8, -8, 1, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, 4, 0, 0, 0, 0
@topleft_End
	even
@topright:	spriteHeader
	spritePiece	-8, -8, 1, 2, 8, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, $C, 0, 0, 0, 0
@topright_End
	even
@bottomleft:	spriteHeader
	spritePiece	-8, -8, 1, 2, 2, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, 6, 0, 0, 0, 0
@bottomleft_End
	even
@bottomright:	spriteHeader
	spritePiece	-8, -8, 1, 2, $A, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, $E, 0, 0, 0, 0
@bottomright_End

	even
