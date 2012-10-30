; ---------------------------------------------------------------------------
; Sprite mappings - metal stomping blocks on chains (MZ)
; ---------------------------------------------------------------------------
Map_CStom:	mappingsTable
	mappingsTableEntry.w	@wideblock
	mappingsTableEntry.w	@spikes
	mappingsTableEntry.w	@ceiling
	mappingsTableEntry.w	@chain1
	mappingsTableEntry.w	@chain2
	mappingsTableEntry.w	@chain3
	mappingsTableEntry.w	@chain4
	mappingsTableEntry.w	@chain5
	mappingsTableEntry.w	@chain5
	mappingsTableEntry.w	@mediumblock
	mappingsTableEntry.w	@smallblock

@wideblock:	spriteHeader
	spritePiece	-$38, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$28, -$C, 3, 3, 6, 0, 0, 0, 0
	spritePiece	-$10, -$14, 4, 4, $F, 0, 0, 0, 0
	spritePiece	$10, -$C, 3, 3, 6, 1, 0, 0, 0
	spritePiece	$28, -$C, 2, 3, 0, 1, 0, 0, 0
@wideblock_End

@spikes:	spriteHeader
	spritePiece	-$2C, -$10, 1, 4, $21F, 0, 1, 0, 0
	spritePiece	-$18, -$10, 1, 4, $21F, 0, 1, 0, 0
	spritePiece	-4, -$10, 1, 4, $21F, 0, 1, 0, 0
	spritePiece	$10, -$10, 1, 4, $21F, 0, 1, 0, 0
	spritePiece	$24, -$10, 1, 4, $21F, 0, 1, 0, 0
@spikes_End

@ceiling:	spriteHeader
	spritePiece	-$10, -$24, 4, 4, $F, 0, 1, 0, 0
@ceiling_End

@chain1:	spriteHeader
	spritePiece	-4, 0, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $3F, 0, 0, 0, 0
@chain1_End

@chain2:	spriteHeader
	spritePiece	-4, -$20, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, 0, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $3F, 0, 0, 0, 0
@chain2_End

@chain3:	spriteHeader
	spritePiece	-4, -$40, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$30, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$20, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, 0, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $3F, 0, 0, 0, 0
@chain3_End

@chain4:	spriteHeader
	spritePiece	-4, -$60, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$50, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$40, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$30, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$20, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, 0, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $3F, 0, 0, 0, 0
@chain4_End

@chain5:	spriteHeader
	spritePiece	-4, -$80, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$70, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$60, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$50, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$40, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$30, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$20, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, 0, 1, 2, $3F, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 2, $3F, 0, 0, 0, 0
@chain5_End

@mediumblock:	spriteHeader
	spritePiece	-$30, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$20, -$C, 3, 3, 6, 0, 0, 0, 0
	spritePiece	8, -$C, 3, 3, 6, 1, 0, 0, 0
	spritePiece	$20, -$C, 2, 3, 0, 1, 0, 0, 0
	spritePiece	-$10, -$14, 4, 4, $F, 0, 0, 0, 0
@mediumblock_End

@smallblock:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $2F, 0, 0, 0, 0
@smallblock_End

	even
