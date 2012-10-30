; ---------------------------------------------------------------------------
; Sprite mappings - fire balls (MZ, SLZ)
; ---------------------------------------------------------------------------
Map_Fire:	mappingsTable
	mappingsTableEntry.w	@vertical1
	mappingsTableEntry.w	@vertical2
	mappingsTableEntry.w	@vertcollide
	mappingsTableEntry.w	@horizontal1
	mappingsTableEntry.w	@horizontal2
	mappingsTableEntry.w	@horicollide

@vertical1:	spriteHeader
	spritePiece	-8, -$18, 2, 4, 0, 0, 0, 0, 0
@vertical1_End

@vertical2:	spriteHeader
	spritePiece	-8, -$18, 2, 4, 8, 0, 0, 0, 0
@vertical2_End

@vertcollide:	spriteHeader
	spritePiece	-8, -$10, 2, 3, $10, 0, 0, 0, 0
@vertcollide_End

@horizontal1:	spriteHeader
	spritePiece	-$18, -8, 4, 2, $16, 0, 0, 0, 0
@horizontal1_End

@horizontal2:	spriteHeader
	spritePiece	-$18, -8, 4, 2, $1E, 0, 0, 0, 0
@horizontal2_End

@horicollide:	spriteHeader
	spritePiece	-$10, -8, 3, 2, $26, 0, 0, 0, 0
@horicollide_End

	even
