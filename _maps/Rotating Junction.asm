; ---------------------------------------------------------------------------
; Sprite mappings - rotating disc that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------
Map_Jun:	mappingsTable
	mappingsTableEntry.w	@gap0
	mappingsTableEntry.w	@gap1
	mappingsTableEntry.w	@gap2
	mappingsTableEntry.w	@gap3
	mappingsTableEntry.w	@gap4
	mappingsTableEntry.w	@gap5
	mappingsTableEntry.w	@gap6
	mappingsTableEntry.w	@gap7
	mappingsTableEntry.w	@gap8
	mappingsTableEntry.w	@gap9
	mappingsTableEntry.w	@gapA
	mappingsTableEntry.w	@gapB
	mappingsTableEntry.w	@gapC
	mappingsTableEntry.w	@gapD
	mappingsTableEntry.w	@gapE
	mappingsTableEntry.w	@gapF
	mappingsTableEntry.w	@circle

@gap0:	spriteHeader
	spritePiece	-$30, -$18, 2, 2, $22, 0, 0, 0, 0
	spritePiece	-$30, 8, 2, 2, $22, 0, 1, 0, 0
	spritePiece	-$38, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$20, -$18, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$38, 0, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$20, 0, 3, 3, 0, 1, 1, 0, 0
@gap0_End

@gap1:	spriteHeader
	spritePiece	-$30, -8, 1, 4, $26, 0, 0, 0, 0
	spritePiece	-$28, $18, 2, 2, $2A, 0, 0, 0, 0
	spritePiece	-$36, -$A, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$1E, -$A, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$36, $E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$1E, $E, 3, 3, 0, 1, 1, 0, 0
@gap1_End

@gap2:	spriteHeader
	spritePiece	-$30, 0, 2, 3, $2E, 0, 0, 0, 0
	spritePiece	-$18, $20, 3, 2, $34, 0, 0, 0, 0
	spritePiece	-$30, 0, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$30, $18, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$18, $18, 3, 3, 0, 1, 1, 0, 0
@gap2_End

@gap3:	spriteHeader
	spritePiece	-$28, 8, 2, 4, $3A, 0, 0, 0, 0
	spritePiece	-$10, $28, 3, 1, $42, 0, 0, 0, 0
	spritePiece	-$26, 6, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$E, 6, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$26, $1E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$E, $1E, 3, 3, 0, 1, 1, 0, 0
@gap3_End

@gap4:	spriteHeader
	spritePiece	-$18, $20, 2, 2, $45, 0, 0, 0, 0
	spritePiece	8, $20, 2, 2, $45, 1, 0, 0, 0
	spritePiece	-$18, 8, 3, 3, 0, 0, 0, 0, 0
	spritePiece	0, 8, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$18, $20, 3, 3, 0, 0, 1, 0, 0
	spritePiece	0, $20, 3, 3, 0, 1, 1, 0, 0
@gap4_End

@gap5:	spriteHeader
	spritePiece	-8, $28, 3, 1, $42, 1, 0, 0, 0
	spritePiece	$18, 8, 2, 4, $3A, 1, 0, 0, 0
	spritePiece	-$A, 6, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$E, 6, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$A, $1E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$E, $1E, 3, 3, 0, 1, 1, 0, 0
@gap5_End

@gap6:	spriteHeader
	spritePiece	0, $20, 3, 2, $34, 1, 0, 0, 0
	spritePiece	$20, 0, 2, 3, $2E, 1, 0, 0, 0
	spritePiece	0, 0, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$18, 0, 3, 3, 0, 1, 0, 0, 0
	spritePiece	0, $18, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$18, $18, 3, 3, 0, 1, 1, 0, 0
@gap6_End

@gap7:	spriteHeader
	spritePiece	$18, $18, 2, 2, $2A, 1, 0, 0, 0
	spritePiece	$28, -8, 1, 4, $26, 1, 0, 0, 0
	spritePiece	6, -$A, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$1E, -$A, 3, 3, 0, 1, 0, 0, 0
	spritePiece	6, $E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$1E, $E, 3, 3, 0, 1, 1, 0, 0
@gap7_End

@gap8:	spriteHeader
	spritePiece	$20, -$18, 2, 2, $22, 1, 0, 0, 0
	spritePiece	$20, 8, 2, 2, $22, 1, 1, 0, 0
	spritePiece	8, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$20, -$18, 3, 3, 0, 1, 0, 0, 0
	spritePiece	8, 0, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$20, 0, 3, 3, 0, 1, 1, 0, 0
@gap8_End

@gap9:	spriteHeader
	spritePiece	$18, -$28, 2, 2, $2A, 1, 1, 0, 0
	spritePiece	$28, -$18, 1, 4, $26, 1, 1, 0, 0
	spritePiece	6, -$26, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$1E, -$26, 3, 3, 0, 1, 0, 0, 0
	spritePiece	6, -$E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$1E, -$E, 3, 3, 0, 1, 1, 0, 0
@gap9_End

@gapA:	spriteHeader
	spritePiece	0, -$30, 3, 2, $34, 1, 1, 0, 0
	spritePiece	$20, -$18, 2, 3, $2E, 1, 1, 0, 0
	spritePiece	0, -$30, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$18, -$30, 3, 3, 0, 1, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$18, -$18, 3, 3, 0, 1, 1, 0, 0
@gapA_End

@gapB:	spriteHeader
	spritePiece	-8, -$30, 3, 1, $42, 1, 1, 0, 0
	spritePiece	$18, -$28, 2, 4, $3A, 1, 1, 0, 0
	spritePiece	-$A, -$36, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$E, -$36, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$A, -$1E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	$E, -$1E, 3, 3, 0, 1, 1, 0, 0
@gapB_End

@gapC:	spriteHeader
	spritePiece	-$18, -$30, 2, 2, $45, 0, 1, 0, 0
	spritePiece	8, -$30, 2, 2, $45, 1, 1, 0, 0
	spritePiece	-$18, -$38, 3, 3, 0, 0, 0, 0, 0
	spritePiece	0, -$38, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$18, -$20, 3, 3, 0, 0, 1, 0, 0
	spritePiece	0, -$20, 3, 3, 0, 1, 1, 0, 0
@gapC_End

@gapD:	spriteHeader
	spritePiece	-$28, -$28, 2, 4, $3A, 0, 1, 0, 0
	spritePiece	-$10, -$30, 3, 1, $42, 0, 1, 0, 0
	spritePiece	-$26, -$36, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$E, -$36, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$26, -$1E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$E, -$1E, 3, 3, 0, 1, 1, 0, 0
@gapD_End

@gapE:	spriteHeader
	spritePiece	-$30, -$18, 2, 3, $2E, 0, 1, 0, 0
	spritePiece	-$18, -$30, 3, 2, $34, 0, 1, 0, 0
	spritePiece	-$30, -$30, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$18, -$30, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$30, -$18, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$18, -$18, 3, 3, 0, 1, 1, 0, 0
@gapE_End

@gapF:	spriteHeader
	spritePiece	-$30, -$18, 1, 4, $26, 0, 1, 0, 0
	spritePiece	-$28, -$28, 2, 2, $2A, 0, 1, 0, 0
	spritePiece	-$36, -$26, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$1E, -$26, 3, 3, 0, 1, 0, 0, 0
	spritePiece	-$36, -$E, 3, 3, 0, 0, 1, 0, 0
	spritePiece	-$1E, -$E, 3, 3, 0, 1, 1, 0, 0
@gapF_End

@circle:	spriteHeader
	spritePiece	-$20, -$38, 4, 2, 9, 0, 0, 0, 0
	spritePiece	-$30, -$30, 3, 3, $11, 0, 0, 0, 0
	spritePiece	-$38, -$20, 2, 4, $1A, 0, 0, 0, 0
	spritePiece	0, -$38, 4, 2, 9, 1, 0, 0, 0
	spritePiece	$18, -$30, 3, 3, $11, 1, 0, 0, 0
	spritePiece	$28, -$20, 2, 4, $1A, 1, 0, 0, 0
	spritePiece	-$38, 0, 2, 4, $1A, 0, 1, 0, 0
	spritePiece	-$30, $18, 3, 3, $11, 0, 1, 0, 0
	spritePiece	-$20, $28, 4, 2, 9, 0, 1, 0, 0
	spritePiece	0, $28, 4, 2, 9, 1, 1, 0, 0
	spritePiece	$18, $18, 3, 3, $11, 1, 1, 0, 0
	spritePiece	$28, 0, 2, 4, $1A, 1, 1, 0, 0
@circle_End

	even
