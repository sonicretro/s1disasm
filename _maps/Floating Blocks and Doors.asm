; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (SYZ/SLZ/LZ)
; ---------------------------------------------------------------------------
Map_FBlock:	mappingsTable
	mappingsTableEntry.w	@syz1x1
	mappingsTableEntry.w	@syz2x2
	mappingsTableEntry.w	@syz1x2
	mappingsTableEntry.w	@syzrect2x2
	mappingsTableEntry.w	@syzrect1x3
	mappingsTableEntry.w	@slz
	mappingsTableEntry.w	@lzvert
	mappingsTableEntry.w	@lzhoriz

@syz1x1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $61, 0, 0, 0, 0
@syz1x1_End

@syz2x2:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $61, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $61, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $61, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $61, 0, 0, 0, 0
@syz2x2_End

@syz1x2:	spriteHeader
	spritePiece	-$10, -$20, 4, 4, $61, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $61, 0, 0, 0, 0
@syz1x2_End

@syzrect2x2:	spriteHeader
	spritePiece	-$20, -$1A, 4, 4, $81, 0, 0, 0, 0
	spritePiece	0, -$1A, 4, 4, $81, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $81, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $81, 0, 0, 0, 0
@syzrect2x2_End

@syzrect1x3:	spriteHeader
	spritePiece	-$10, -$27, 4, 4, $81, 0, 0, 0, 0
	spritePiece	-$10, -$D, 4, 4, $81, 0, 0, 0, 0
	spritePiece	-$10, $D, 4, 4, $81, 0, 0, 0, 0
@syzrect1x3_End

@slz:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $21, 0, 0, 0, 0
@slz_End

@lzvert:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 4, 0, 0, 1, 0, 0
@lzvert_End

@lzhoriz:	spriteHeader
	spritePiece	-$40, -$10, 4, 4, $22, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $22, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $22, 0, 0, 0, 0
	spritePiece	$20, -$10, 4, 4, $22, 0, 0, 0, 0
@lzhoriz_End

	even
