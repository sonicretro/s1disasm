; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
Map_ADoor:	mappingsTable
	mappingsTableEntry.w	@closed
	mappingsTableEntry.w	@01
	mappingsTableEntry.w	@02
	mappingsTableEntry.w	@03
	mappingsTableEntry.w	@04
	mappingsTableEntry.w	@05
	mappingsTableEntry.w	@06
	mappingsTableEntry.w	@07
	mappingsTableEntry.w	@open

@closed:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 0, 2, 4, 0, 1, 0, 0, 0
@closed_End

@01:	spriteHeader
	spritePiece	-8, -$24, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 4, 2, 4, 0, 1, 0, 0, 0
@01_End

@02:	spriteHeader
	spritePiece	-8, -$28, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 4, 0, 1, 0, 0, 0
@02_End

@03:	spriteHeader
	spritePiece	-8, -$2C, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $C, 2, 4, 0, 1, 0, 0, 0
@03_End

@04:	spriteHeader
	spritePiece	-8, -$30, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $10, 2, 4, 0, 1, 0, 0, 0
@04_End

@05:	spriteHeader
	spritePiece	-8, -$34, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $14, 2, 4, 0, 1, 0, 0, 0
@05_End

@06:	spriteHeader
	spritePiece	-8, -$38, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $18, 2, 4, 0, 1, 0, 0, 0
@06_End

@07:	spriteHeader
	spritePiece	-8, -$3C, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $1C, 2, 4, 0, 1, 0, 0, 0
@07_End

@open:	spriteHeader
	spritePiece	-8, -$40, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-8, $20, 2, 4, 0, 1, 0, 0, 0
@open_End

	even
