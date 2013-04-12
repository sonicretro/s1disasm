; ---------------------------------------------------------------------------
; Sprite mappings - lava geyser / lava that falls from the ceiling (MZ)
; ---------------------------------------------------------------------------
Map_Geyser:	mappingsTable
	mappingsTableEntry.w	@bubble1
	mappingsTableEntry.w	@bubble2
	mappingsTableEntry.w	@bubble3
	mappingsTableEntry.w	@bubble4
	mappingsTableEntry.w	@bubble5
	mappingsTableEntry.w	@bubble6
	mappingsTableEntry.w	@end1
	mappingsTableEntry.w	@end2
	mappingsTableEntry.w	@medcolumn1
	mappingsTableEntry.w	@medcolumn2
	mappingsTableEntry.w	@medcolumn3
	mappingsTableEntry.w	@shortcolumn1
	mappingsTableEntry.w	@shortcolumn2
	mappingsTableEntry.w	@shortcolumn3
	mappingsTableEntry.w	@longcolumn1
	mappingsTableEntry.w	@longcolumn2
	mappingsTableEntry.w	@longcolumn3
	mappingsTableEntry.w	@bubble7
	mappingsTableEntry.w	@bubble8
	mappingsTableEntry.w	@blank

@bubble1:	spriteHeader
	spritePiece	-$18, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$14, 3, 4, 0, 1, 0, 0, 0
@bubble1_End

@bubble2:	spriteHeader
	spritePiece	-$18, -$14, 3, 4, $18, 0, 0, 0, 0
	spritePiece	0, -$14, 3, 4, $18, 1, 0, 0, 0
@bubble2_End

@bubble3:	spriteHeader
	spritePiece	-$38, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$20, -$C, 4, 3, $C, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 3, $C, 1, 0, 0, 0
	spritePiece	$20, -$14, 3, 4, 0, 1, 0, 0, 0
@bubble3_End

@bubble4:	spriteHeader
	spritePiece	-$38, -$14, 3, 4, $18, 0, 0, 0, 0
	spritePiece	-$20, -$C, 4, 3, $24, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 3, $24, 1, 0, 0, 0
	spritePiece	$20, -$14, 3, 4, $18, 1, 0, 0, 0
@bubble4_End

@bubble5:	spriteHeader
	spritePiece	-$38, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$20, -$C, 4, 3, $C, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 3, $C, 1, 0, 0, 0
	spritePiece	$20, -$14, 3, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, -$18, 4, 3, $90, 0, 0, 0, 0
	spritePiece	0, -$18, 4, 3, $90, 1, 0, 0, 0
@bubble5_End

@bubble6:	spriteHeader
	spritePiece	-$38, -$14, 3, 4, $18, 0, 0, 0, 0
	spritePiece	-$20, -$C, 4, 3, $24, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 3, $24, 1, 0, 0, 0
	spritePiece	$20, -$14, 3, 4, $18, 1, 0, 0, 0
	spritePiece	-$20, -$18, 4, 3, $90, 1, 0, 0, 0
	spritePiece	0, -$18, 4, 3, $90, 0, 0, 0, 0
@bubble6_End

@end1:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $30, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $30, 1, 0, 0, 0
@end1_End

@end2:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $30, 1, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $30, 0, 0, 0, 0
@end2_End

@medcolumn1:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, $40, 1, 0, 0, 0
@medcolumn1_End

@medcolumn2:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, $50, 1, 0, 0, 0
@medcolumn2_End

@medcolumn3:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, $60, 1, 0, 0, 0
@medcolumn3_End

@shortcolumn1:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $40, 1, 0, 0, 0
@shortcolumn1_End

@shortcolumn2:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $50, 1, 0, 0, 0
@shortcolumn2_End

@shortcolumn3:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $60, 1, 0, 0, 0
@shortcolumn3_End

@longcolumn1:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, $30, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, $30, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, $50, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, $50, 4, 4, $40, 1, 0, 0, 0
	spritePiece	-$20, $70, 4, 4, $40, 0, 0, 0, 0
	spritePiece	0, $70, 4, 4, $40, 1, 0, 0, 0
@longcolumn1_End

@longcolumn2:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, $30, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, $30, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, $50, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, $50, 4, 4, $50, 1, 0, 0, 0
	spritePiece	-$20, $70, 4, 4, $50, 0, 0, 0, 0
	spritePiece	0, $70, 4, 4, $50, 1, 0, 0, 0
@longcolumn2_End

@longcolumn3:	spriteHeader
	spritePiece	-$20, -$70, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$70, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$50, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$50, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, $30, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, $30, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, $50, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, $50, 4, 4, $60, 1, 0, 0, 0
	spritePiece	-$20, $70, 4, 4, $60, 0, 0, 0, 0
	spritePiece	0, $70, 4, 4, $60, 1, 0, 0, 0
@longcolumn3_End

@bubble7:	spriteHeader
	spritePiece	-$38, -$20, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$20, -$18, 4, 3, $C, 0, 0, 0, 0
	spritePiece	0, -$18, 4, 3, $C, 1, 0, 0, 0
	spritePiece	$20, -$20, 3, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, -$28, 4, 3, $90, 0, 0, 0, 0
	spritePiece	0, -$28, 4, 3, $90, 1, 0, 0, 0
@bubble7_End

@bubble8:	spriteHeader
	spritePiece	-$38, -$20, 3, 4, $18, 0, 0, 0, 0
	spritePiece	-$20, -$18, 4, 3, $24, 0, 0, 0, 0
	spritePiece	0, -$18, 4, 3, $24, 1, 0, 0, 0
	spritePiece	$20, -$20, 3, 4, $18, 1, 0, 0, 0
	spritePiece	-$20, -$28, 4, 3, $90, 1, 0, 0, 0
	spritePiece	0, -$28, 4, 3, $90, 0, 0, 0, 0
@bubble8_End

@blank:	spriteHeader
@blank_End

	even
