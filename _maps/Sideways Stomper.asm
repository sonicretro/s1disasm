; ---------------------------------------------------------------------------
; Sprite mappings - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------
Map_SStom:	mappingsTable
	mappingsTableEntry.w	@block
	mappingsTableEntry.w	@spikes
	mappingsTableEntry.w	@wallbracket
	mappingsTableEntry.w	@pole1
	mappingsTableEntry.w	@pole2
	mappingsTableEntry.w	@pole3
	mappingsTableEntry.w	@pole4
	mappingsTableEntry.w	@pole5
	mappingsTableEntry.w	@pole5

@block:	spriteHeader
	spritePiece	-$C, -$20, 3, 4, $1F, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 4, $1F, 0, 1, 0, 0
	spritePiece	$C, -$10, 1, 4, $2B, 0, 0, 0, 0
@block_End

@spikes:	spriteHeader
	spritePiece	-$10, -$18, 4, 1, $21B, 0, 1, 0, 0
	spritePiece	-$10, -4, 4, 1, $21B, 0, 1, 0, 0
	spritePiece	-$10, $10, 4, 1, $21B, 0, 1, 0, 0
@spikes_End

@wallbracket:	spriteHeader
	spritePiece	-4, -$10, 1, 4, $2B, 1, 0, 0, 0
@wallbracket_End

@pole1:	spriteHeader
	spritePiece	-$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $41, 0, 0, 0, 0
@pole1_End

@pole2:	spriteHeader
	spritePiece	-$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $41, 0, 0, 0, 0
@pole2_End

@pole3:	spriteHeader
	spritePiece	-$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$30, -8, 2, 2, $41, 0, 0, 0, 0
@pole3_End

@pole4:	spriteHeader
	spritePiece	-$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$30, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$40, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$50, -8, 2, 2, $41, 0, 0, 0, 0
@pole4_End

@pole5:	spriteHeader
	spritePiece	-$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$20, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$30, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$40, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$50, -8, 2, 2, $41, 0, 0, 0, 0
@pole5_End
	spritePiece	$60, -8, 2, 2, $41, 0, 0, 0, 0
	spritePiece	$70, -8, 2, 2, $41, 0, 0, 0, 0

	even
