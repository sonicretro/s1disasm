; ---------------------------------------------------------------------------
; Sprite mappings - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------
Map_LConv:	mappingsTable
	mappingsTableEntry.w	@wheel1
	mappingsTableEntry.w	@wheel2
	mappingsTableEntry.w	@wheel3
	mappingsTableEntry.w	@wheel4
	mappingsTableEntry.w	@platform

@wheel1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
@wheel1_End

@wheel2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $10, 0, 0, 0, 0
@wheel2_End

@wheel3:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $20, 0, 0, 0, 0
@wheel3_End

@wheel4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $30, 0, 0, 0, 0
@wheel4_End

@platform:	spriteHeader
	spritePiece	-$10, -8, 4, 2, $40, 0, 0, 0, 0
@platform_End

	even
