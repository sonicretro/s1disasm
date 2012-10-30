; ---------------------------------------------------------------------------
; Sprite mappings - rings
; ---------------------------------------------------------------------------
Map_Ring:	mappingsTable
	mappingsTableEntry.w	@front
	mappingsTableEntry.w	@angle1
	mappingsTableEntry.w	@edge
	mappingsTableEntry.w	@angle2
	mappingsTableEntry.w	@sparkle1
	mappingsTableEntry.w	@sparkle2
	mappingsTableEntry.w	@sparkle3
	mappingsTableEntry.w	@sparkle4

@front:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
@front_End

@angle1:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0
@angle1_End

@edge:	spriteHeader
	spritePiece	-4, -8, 1, 2, 8, 0, 0, 0, 0
@edge_End

@angle2:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 1, 0, 0, 0
@angle2_End

@sparkle1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 0, 0
@sparkle1_End

@sparkle2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 1, 1, 0, 0
@sparkle2_End

@sparkle3:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 1, 0, 0, 0
@sparkle3_End

@sparkle4:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 1, 0, 0
@sparkle4_End

	even
