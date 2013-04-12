; ---------------------------------------------------------------------------
; Sprite mappings - lamppost
; ---------------------------------------------------------------------------
Map_Lamp:	mappingsTable
	mappingsTableEntry.w	@blue
	mappingsTableEntry.w	@poleonly
	mappingsTableEntry.w	@redballonly
	mappingsTableEntry.w	@red

@blue:	spriteHeader
	spritePiece	-8, -$1C, 1, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$1C, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-8, -$C, 1, 4, 2, 0, 0, 1, 0
	spritePiece	0, -$C, 1, 4, 2, 1, 0, 1, 0
	spritePiece	-8, -$2C, 1, 2, 6, 0, 0, 0, 0
	spritePiece	0, -$2C, 1, 2, 6, 1, 0, 0, 0
@blue_End

@poleonly:	spriteHeader
	spritePiece	-8, -$1C, 1, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$1C, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-8, -$C, 1, 4, 2, 0, 0, 1, 0
	spritePiece	0, -$C, 1, 4, 2, 1, 0, 1, 0
@poleonly_End

@redballonly:	spriteHeader
	spritePiece	-8, -8, 1, 2, 8, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, 8, 1, 0, 0, 0
@redballonly_End

@red:	spriteHeader
	spritePiece	-8, -$1C, 1, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$1C, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-8, -$C, 1, 4, 2, 0, 0, 1, 0
	spritePiece	0, -$C, 1, 4, 2, 1, 0, 1, 0
	spritePiece	-8, -$2C, 1, 2, 8, 0, 0, 0, 0
	spritePiece	0, -$2C, 1, 2, 8, 1, 0, 0, 0
@red_End

	even
