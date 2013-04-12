; ---------------------------------------------------------------------------
; Sprite mappings - Orbinaut enemy (LZ,	SLZ, SBZ)
; ---------------------------------------------------------------------------
Map_Orb:	mappingsTable
	mappingsTableEntry.w	@normal
	mappingsTableEntry.w	@medium
	mappingsTableEntry.w	@angry
	mappingsTableEntry.w	@spikeball

@normal:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
@normal_End

@medium:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 1, 0
@medium_End

@angry:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
@angry_End

@spikeball:	spriteHeader
	spritePiece	-8, -8, 2, 2, $1B, 0, 0, 0, 0
@spikeball_End

	even
