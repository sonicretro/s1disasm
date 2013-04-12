; ---------------------------------------------------------------------------
; Sprite mappings - flame thrower (SBZ)
; ---------------------------------------------------------------------------
Map_Flame:	mappingsTable
	mappingsTableEntry.w	@pipe1
	mappingsTableEntry.w	@pipe2
	mappingsTableEntry.w	@pipe3
	mappingsTableEntry.w	@pipe4
	mappingsTableEntry.w	@pipe5
	mappingsTableEntry.w	@pipe6
	mappingsTableEntry.w	@pipe7
	mappingsTableEntry.w	@pipe8
	mappingsTableEntry.w	@pipe9
	mappingsTableEntry.w	@pipe10
	mappingsTableEntry.w	@pipe11
	mappingsTableEntry.w	@valve1
	mappingsTableEntry.w	@valve2
	mappingsTableEntry.w	@valve3
	mappingsTableEntry.w	@valve4
	mappingsTableEntry.w	@valve5
	mappingsTableEntry.w	@valve6
	mappingsTableEntry.w	@valve7
	mappingsTableEntry.w	@valve8
	mappingsTableEntry.w	@valve9
	mappingsTableEntry.w	@valve10
	mappingsTableEntry.w	@valve11

@pipe1:	spriteHeader
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe1_End

@pipe2:	spriteHeader
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe2_End

@pipe3:	spriteHeader
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe3_End

@pipe4:	spriteHeader
	spritePiece	-8, $10, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe4_End

@pipe5:	spriteHeader
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe5_End

@pipe6:	spriteHeader
	spritePiece	-8, 8, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe6_End

@pipe7:	spriteHeader
	spritePiece	-8, 8, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe7_End

@pipe8:	spriteHeader
	spritePiece	-$C, -8, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-8, 8, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe8_End

@pipe9:	spriteHeader
	spritePiece	-$C, -8, 3, 4, 8, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe9_End

@pipe10:	spriteHeader
	spritePiece	-$C, -$18, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-$C, -9, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-8, 8, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-8, $F, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe10_End

@pipe11:	spriteHeader
	spritePiece	-$C, -$19, 3, 4, 8, 1, 0, 0, 0
	spritePiece	-$C, -8, 3, 4, 8, 1, 0, 0, 0
	spritePiece	-8, 7, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
	spritePiece	-5, $28, 2, 2, $14, 0, 0, 2, 0
@pipe11_End

@valve1:	spriteHeader
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
@valve1_End

@valve2:	spriteHeader
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
@valve2_End

@valve3:	spriteHeader
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
@valve3_End

@valve4:	spriteHeader
	spritePiece	-8, $10, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
@valve4_End

@valve5:	spriteHeader
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
@valve5_End

@valve6:	spriteHeader
	spritePiece	-8, 8, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
@valve6_End

@valve7:	spriteHeader
	spritePiece	-8, 8, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
@valve7_End

@valve8:	spriteHeader
	spritePiece	-$C, -8, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-8, 8, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
@valve8_End

@valve9:	spriteHeader
	spritePiece	-$C, -8, 3, 4, 8, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
@valve9_End

@valve10:	spriteHeader
	spritePiece	-$C, -$18, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-$C, -9, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-8, 8, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-8, $F, 2, 3, 2, 0, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-3, $20, 1, 2, 0, 0, 0, 0, 0
@valve10_End

@valve11:	spriteHeader
	spritePiece	-$C, -$19, 3, 4, 8, 1, 0, 0, 0
	spritePiece	-$C, -8, 3, 4, 8, 1, 0, 0, 0
	spritePiece	-8, 7, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 3, 2, 1, 0, 0, 0
	spritePiece	-7, $28, 2, 2, $18, 0, 0, 2, 0
	spritePiece	-4, $20, 1, 2, 0, 1, 0, 0, 0
@valve11_End

	even
