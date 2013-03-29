; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	collapsing ledge
; ---------------------------------------------------------------------------
Map_Ledge:	mappingsTable
	mappingsTableEntry.w	@left
	mappingsTableEntry.w	@right
	mappingsTableEntry.w	@leftsmash
	mappingsTableEntry.w	@rightsmash

@left:	spriteHeader
	spritePiece	$10, -$38, 4, 3, $57, 0, 0, 0, 0
	spritePiece	-$10, -$30, 4, 2, $63, 0, 0, 0, 0
	spritePiece	$10, -$20, 4, 2, $6B, 0, 0, 0, 0
	spritePiece	-$10, -$20, 4, 2, $73, 0, 0, 0, 0
	spritePiece	-$20, -$28, 2, 3, $7B, 0, 0, 0, 0
	spritePiece	-$30, -$28, 2, 3, $81, 0, 0, 0, 0
	spritePiece	$10, -$10, 4, 2, $87, 0, 0, 0, 0
	spritePiece	-$10, -$10, 4, 2, $8F, 0, 0, 0, 0
	spritePiece	-$20, -$10, 2, 2, $97, 0, 0, 0, 0
	spritePiece	-$30, -$10, 2, 2, $9B, 0, 0, 0, 0
	spritePiece	$10, 0, 4, 2, $9F, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, $A7, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 2, $AB, 0, 0, 0, 0
	spritePiece	-$30, 0, 2, 2, $B3, 0, 0, 0, 0
	spritePiece	$10, $10, 4, 2, $AB, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, $B7, 0, 0, 0, 0
@left_End

@right:	spriteHeader
	spritePiece	$10, -$38, 4, 3, $57, 0, 0, 0, 0
	spritePiece	-$10, -$30, 4, 2, $63, 0, 0, 0, 0
	spritePiece	$10, -$20, 4, 2, $6B, 0, 0, 0, 0
	spritePiece	-$10, -$20, 4, 2, $73, 0, 0, 0, 0
	spritePiece	-$20, -$28, 2, 3, $7B, 0, 0, 0, 0
	spritePiece	-$30, -$28, 2, 3, $BB, 0, 0, 0, 0
	spritePiece	$10, -$10, 4, 2, $87, 0, 0, 0, 0
	spritePiece	-$10, -$10, 4, 2, $8F, 0, 0, 0, 0
	spritePiece	-$20, -$10, 2, 2, $97, 0, 0, 0, 0
	spritePiece	-$30, -$10, 2, 2, $C1, 0, 0, 0, 0
	spritePiece	$10, 0, 4, 2, $9F, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, $A7, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 2, $AB, 0, 0, 0, 0
	spritePiece	-$30, 0, 2, 2, $B7, 0, 0, 0, 0
	spritePiece	$10, $10, 4, 2, $AB, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, $B7, 0, 0, 0, 0
@right_End

@leftsmash:	spriteHeader
	spritePiece	$20, -$38, 2, 3, $5D, 0, 0, 0, 0
	spritePiece	$10, -$38, 2, 3, $57, 0, 0, 0, 0
	spritePiece	0, -$30, 2, 2, $67, 0, 0, 0, 0
	spritePiece	-$10, -$30, 2, 2, $63, 0, 0, 0, 0
	spritePiece	$20, -$20, 2, 2, $6F, 0, 0, 0, 0
	spritePiece	$10, -$20, 2, 2, $6B, 0, 0, 0, 0
	spritePiece	0, -$20, 2, 2, $77, 0, 0, 0, 0
	spritePiece	-$10, -$20, 2, 2, $73, 0, 0, 0, 0
	spritePiece	-$20, -$28, 2, 3, $7B, 0, 0, 0, 0
	spritePiece	-$30, -$28, 2, 3, $81, 0, 0, 0, 0
	spritePiece	$20, -$10, 2, 2, $8B, 0, 0, 0, 0
	spritePiece	$10, -$10, 2, 2, $87, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, $93, 0, 0, 0, 0
	spritePiece	-$10, -$10, 2, 2, $8F, 0, 0, 0, 0
	spritePiece	-$20, -$10, 2, 2, $97, 0, 0, 0, 0
	spritePiece	-$30, -$10, 2, 2, $9B, 0, 0, 0, 0
	spritePiece	$20, 0, 2, 2, $8B, 0, 0, 0, 0
	spritePiece	$10, 0, 2, 2, $8B, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, $A7, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	-$20, 0, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	-$30, 0, 2, 2, $B3, 0, 0, 0, 0
	spritePiece	$20, $10, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	$10, $10, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, $B7, 0, 0, 0, 0
@leftsmash_End

@rightsmash:	spriteHeader
	spritePiece	$20, -$38, 2, 3, $5D, 0, 0, 0, 0
	spritePiece	$10, -$38, 2, 3, $57, 0, 0, 0, 0
	spritePiece	0, -$30, 2, 2, $67, 0, 0, 0, 0
	spritePiece	-$10, -$30, 2, 2, $63, 0, 0, 0, 0
	spritePiece	$20, -$20, 2, 2, $6F, 0, 0, 0, 0
	spritePiece	$10, -$20, 2, 2, $6B, 0, 0, 0, 0
	spritePiece	0, -$20, 2, 2, $77, 0, 0, 0, 0
	spritePiece	-$10, -$20, 2, 2, $73, 0, 0, 0, 0
	spritePiece	-$20, -$28, 2, 3, $7B, 0, 0, 0, 0
	spritePiece	-$30, -$28, 2, 3, $BB, 0, 0, 0, 0
	spritePiece	$20, -$10, 2, 2, $8B, 0, 0, 0, 0
	spritePiece	$10, -$10, 2, 2, $87, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, $93, 0, 0, 0, 0
	spritePiece	-$10, -$10, 2, 2, $8F, 0, 0, 0, 0
	spritePiece	-$20, -$10, 2, 2, $97, 0, 0, 0, 0
	spritePiece	-$30, -$10, 2, 2, $C1, 0, 0, 0, 0
	spritePiece	$20, 0, 2, 2, $8B, 0, 0, 0, 0
	spritePiece	$10, 0, 2, 2, $8B, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, $A7, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	-$20, 0, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	-$30, 0, 2, 2, $B7, 0, 0, 0, 0
	spritePiece	$20, $10, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	$10, $10, 2, 2, $AB, 0, 0, 0, 0
	spritePiece	0, $10, 2, 2, $B7, 0, 0, 0, 0
@rightsmash_End

	even
