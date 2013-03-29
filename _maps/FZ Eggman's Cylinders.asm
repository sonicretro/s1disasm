; ---------------------------------------------------------------------------
; Sprite mappings - cylinders Eggman hides in (FZ)
; ---------------------------------------------------------------------------
Map_EggCyl:	mappingsTable
	mappingsTableEntry.w	@flat
	mappingsTableEntry.w	@extending1
	mappingsTableEntry.w	@extending2
	mappingsTableEntry.w	@extending3
	mappingsTableEntry.w	@extending4
	mappingsTableEntry.w	@extendedfully
	mappingsTableEntry.w	@extendedfully
	mappingsTableEntry.w	@extendedfully
	mappingsTableEntry.w	@extendedfully
	mappingsTableEntry.w	@extendedfully
	mappingsTableEntry.w	@extendedfully
	mappingsTableEntry.w	@controlpanel

@flat:	spriteHeader
	spritePiece	-$20, -$60, 4, 2, 0, 0, 0, 2, 0
	spritePiece	0, -$60, 4, 2, 0, 1, 0, 2, 0
	spritePiece	-$20, -$50, 4, 1, 8, 0, 0, 1, 0
	spritePiece	0, -$50, 4, 1, $C, 0, 0, 1, 0
	spritePiece	-$20, -$48, 4, 4, $10, 0, 0, 2, 0
	spritePiece	0, -$48, 4, 4, $10, 1, 0, 2, 0
@flat_End

@extending1:	spriteHeader
	spritePiece	-$20, -$60, 4, 2, 0, 0, 0, 2, 0
	spritePiece	0, -$60, 4, 2, 0, 1, 0, 2, 0
	spritePiece	-$20, -$50, 4, 1, 8, 0, 0, 1, 0
	spritePiece	0, -$50, 4, 1, $C, 0, 0, 1, 0
	spritePiece	-$20, -$48, 4, 4, $10, 0, 0, 2, 0
	spritePiece	0, -$48, 4, 4, $10, 1, 0, 2, 0
	spritePiece	-$20, -$28, 4, 4, $20, 0, 0, 2, 0
	spritePiece	0, -$28, 4, 4, $20, 1, 0, 2, 0
@extending1_End

@extending2:	spriteHeader
	spritePiece	-$20, -$60, 4, 2, 0, 0, 0, 2, 0
	spritePiece	0, -$60, 4, 2, 0, 1, 0, 2, 0
	spritePiece	-$20, -$50, 4, 1, 8, 0, 0, 1, 0
	spritePiece	0, -$50, 4, 1, $C, 0, 0, 1, 0
	spritePiece	-$20, -$48, 4, 4, $10, 0, 0, 2, 0
	spritePiece	0, -$48, 4, 4, $10, 1, 0, 2, 0
	spritePiece	-$20, -$28, 4, 4, $20, 0, 0, 2, 0
	spritePiece	0, -$28, 4, 4, $20, 1, 0, 2, 0
	spritePiece	-$20, -8, 4, 4, $30, 0, 0, 2, 0
	spritePiece	0, -8, 4, 4, $30, 1, 0, 2, 0
@extending2_End

@extending3:	spriteHeader
	spritePiece	-$20, -$60, 4, 2, 0, 0, 0, 2, 0
	spritePiece	0, -$60, 4, 2, 0, 1, 0, 2, 0
	spritePiece	-$20, -$50, 4, 1, 8, 0, 0, 1, 0
	spritePiece	0, -$50, 4, 1, $C, 0, 0, 1, 0
	spritePiece	-$20, -$48, 4, 4, $10, 0, 0, 2, 0
	spritePiece	0, -$48, 4, 4, $10, 1, 0, 2, 0
	spritePiece	-$20, -$28, 4, 4, $20, 0, 0, 2, 0
	spritePiece	0, -$28, 4, 4, $20, 1, 0, 2, 0
	spritePiece	-$20, -8, 4, 4, $30, 0, 0, 2, 0
	spritePiece	0, -8, 4, 4, $30, 1, 0, 2, 0
	spritePiece	-$20, $18, 4, 4, $40, 0, 0, 2, 0
	spritePiece	0, $18, 4, 4, $40, 1, 0, 2, 0
@extending3_End

@extending4:	spriteHeader
	spritePiece	-$20, -$60, 4, 2, 0, 0, 0, 2, 0
	spritePiece	0, -$60, 4, 2, 0, 1, 0, 2, 0
	spritePiece	-$20, -$50, 4, 1, 8, 0, 0, 1, 0
	spritePiece	0, -$50, 4, 1, $C, 0, 0, 1, 0
	spritePiece	-$20, -$48, 4, 4, $10, 0, 0, 2, 0
	spritePiece	0, -$48, 4, 4, $10, 1, 0, 2, 0
	spritePiece	-$20, -$28, 4, 4, $20, 0, 0, 2, 0
	spritePiece	0, -$28, 4, 4, $20, 1, 0, 2, 0
	spritePiece	-$20, -8, 4, 4, $30, 0, 0, 2, 0
	spritePiece	0, -8, 4, 4, $30, 1, 0, 2, 0
	spritePiece	-$20, $18, 4, 4, $40, 0, 0, 2, 0
	spritePiece	0, $18, 4, 4, $40, 1, 0, 2, 0
	spritePiece	-$10, $38, 4, 4, $50, 0, 0, 2, 0
@extending4_End

@extendedfully:	spriteHeader
	spritePiece	-$20, -$60, 4, 2, 0, 0, 0, 2, 0
	spritePiece	0, -$60, 4, 2, 0, 1, 0, 2, 0
	spritePiece	-$20, -$50, 4, 1, 8, 0, 0, 1, 0
	spritePiece	0, -$50, 4, 1, $C, 0, 0, 1, 0
	spritePiece	-$20, -$48, 4, 4, $10, 0, 0, 2, 0
	spritePiece	0, -$48, 4, 4, $10, 1, 0, 2, 0
	spritePiece	-$20, -$28, 4, 4, $20, 0, 0, 2, 0
	spritePiece	0, -$28, 4, 4, $20, 1, 0, 2, 0
	spritePiece	-$20, -8, 4, 4, $30, 0, 0, 2, 0
	spritePiece	0, -8, 4, 4, $30, 1, 0, 2, 0
	spritePiece	-$20, $18, 4, 4, $40, 0, 0, 2, 0
	spritePiece	0, $18, 4, 4, $40, 1, 0, 2, 0
	spritePiece	-$10, $38, 4, 4, $50, 0, 0, 2, 0
	spritePiece	-$10, $58, 4, 4, $50, 0, 0, 2, 0
@extendedfully_End

@controlpanel:	spriteHeader
	spritePiece	-$10, -8, 2, 1, $68, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $6A, 0, 0, 0, 0
@controlpanel_End

	even
