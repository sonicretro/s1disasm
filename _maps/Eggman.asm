; ---------------------------------------------------------------------------
; Sprite mappings - Eggman (boss levels)
; ---------------------------------------------------------------------------
Map_Eggman:	mappingsTable
	mappingsTableEntry.w	@ship
	mappingsTableEntry.w	@facenormal1
	mappingsTableEntry.w	@facenormal2
	mappingsTableEntry.w	@facelaugh1
	mappingsTableEntry.w	@facelaugh2
	mappingsTableEntry.w	@facehit
	mappingsTableEntry.w	@facepanic
	mappingsTableEntry.w	@facedefeat
	mappingsTableEntry.w	@flame1
	mappingsTableEntry.w	@flame2
	mappingsTableEntry.w	@blank
	mappingsTableEntry.w	@escapeflame1
	mappingsTableEntry.w	@escapeflame2

@ship:	spriteHeader
	spritePiece	-$1C, -$14, 1, 2, $A, 0, 0, 0, 0
	spritePiece	$C, -$14, 2, 2, $C, 0, 0, 0, 0
	spritePiece	-$1C, -4, 4, 3, $10, 0, 0, 1, 0
	spritePiece	4, -4, 4, 3, $1C, 0, 0, 1, 0
	spritePiece	-$14, $14, 4, 1, $28, 0, 0, 1, 0
	spritePiece	$C, $14, 1, 1, $2C, 0, 0, 1, 0
@ship_End

@facenormal1:	spriteHeader
	spritePiece	-$C, -$1C, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$14, -$14, 4, 2, 2, 0, 0, 0, 0
@facenormal1_End

@facenormal2:	spriteHeader
	spritePiece	-$C, -$1C, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$14, -$14, 4, 2, $35, 0, 0, 0, 0
@facenormal2_End

@facelaugh1:	spriteHeader
	spritePiece	-$C, -$1C, 3, 1, $3D, 0, 0, 0, 0
	spritePiece	-$14, -$14, 3, 2, $40, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $46, 0, 0, 0, 0
@facelaugh1_End

@facelaugh2:	spriteHeader
	spritePiece	-$C, -$1C, 3, 1, $4A, 0, 0, 0, 0
	spritePiece	-$14, -$14, 3, 2, $4D, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $53, 0, 0, 0, 0
@facelaugh2_End

@facehit:	spriteHeader
	spritePiece	-$C, -$1C, 3, 1, $57, 0, 0, 0, 0
	spritePiece	-$14, -$14, 3, 2, $5A, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $60, 0, 0, 0, 0
@facehit_End

@facepanic:	spriteHeader
	spritePiece	4, -$1C, 2, 1, $64, 0, 0, 0, 0
	spritePiece	-$C, -$1C, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$14, -$14, 4, 2, $35, 0, 0, 0, 0
@facepanic_End

@facedefeat:	spriteHeader
	spritePiece	-$C, -$1C, 3, 2, $66, 0, 0, 0, 0
	spritePiece	-$C, -$1C, 3, 1, $57, 0, 0, 0, 0
	spritePiece	-$14, -$14, 3, 2, $5A, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 2, $60, 0, 0, 0, 0
@facedefeat_End

@flame1:	spriteHeader
	spritePiece	$22, 4, 2, 2, $2D, 0, 0, 0, 0
@flame1_End

@flame2:	spriteHeader
	spritePiece	$22, 4, 2, 2, $31, 0, 0, 0, 0
@flame2_End

@blank:	spriteHeader
@blank_End

@escapeflame1:	spriteHeader
	spritePiece	$22, 0, 3, 1, $12A, 0, 0, 0, 0
	spritePiece	$22, 8, 3, 1, $12A, 0, 1, 0, 0
@escapeflame1_End

@escapeflame2:	spriteHeader
	spritePiece	$22, -8, 3, 4, $12D, 0, 0, 0, 0
	spritePiece	$3A, 0, 1, 2, $139, 0, 0, 0, 0
@escapeflame2_End

	even
