; ---------------------------------------------------------------------------
; Sprite mappings - extra boss items (e.g. swinging ball on a chain in GHZ)
; ---------------------------------------------------------------------------
Map_BossItems:	mappingsTable
	mappingsTableEntry.w	@chainanchor1
	mappingsTableEntry.w	@chainanchor2
	mappingsTableEntry.w	@cross
	mappingsTableEntry.w	@widepipe
	mappingsTableEntry.w	@pipe
	mappingsTableEntry.w	@spike
	mappingsTableEntry.w	@legmask
	mappingsTableEntry.w	@legs

@chainanchor1:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
@chainanchor1_End

@chainanchor2:	spriteHeader
	spritePiece	-8, -4, 2, 1, 4, 0, 0, 0, 0
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
@chainanchor2_End
		even
@cross:	spriteHeader
	spritePiece	-4, -4, 1, 1, 6, 0, 0, 0, 0
@cross_End

@widepipe:	spriteHeader
	spritePiece	-$C, $14, 3, 2, 7, 0, 0, 0, 0
@widepipe_End

@pipe:	spriteHeader
	spritePiece	-8, $14, 2, 2, $D, 0, 0, 0, 0
@pipe_End

@spike:	spriteHeader
	spritePiece	-8, -$10, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-8, -8, 1, 2, $13, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, $13, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 1, $15, 0, 0, 0, 0
@spike_End
		even
@legmask:	spriteHeader
	spritePiece	0, 0, 2, 2, $17, 0, 0, 0, 0
	spritePiece	$10, 0, 1, 1, $1B, 0, 0, 0, 0
@legmask_End
		even
@legs:	spriteHeader
	spritePiece	0, $18, 2, 1, $1C, 0, 0, 0, 0
	spritePiece	$10, 0, 3, 4, $1E, 0, 0, 0, 0
@legs_End

	even
