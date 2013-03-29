; ---------------------------------------------------------------------------
; Sprite mappings - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------
Map_Bomb:	mappingsTable
	mappingsTableEntry.w	@stand1
	mappingsTableEntry.w	@stand2
	mappingsTableEntry.w	@walk1
	mappingsTableEntry.w	@walk2
	mappingsTableEntry.w	@walk3
	mappingsTableEntry.w	@walk4
	mappingsTableEntry.w	@activate1
	mappingsTableEntry.w	@activate2
	mappingsTableEntry.w	@fuse1
	mappingsTableEntry.w	@fuse2
	mappingsTableEntry.w	@shrapnel1
	mappingsTableEntry.w	@shrapnel2

@stand1:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
@stand1_End

@stand2:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
@stand2_End

@walk1:	spriteHeader
	spritePiece	-$C, -$10, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 8, 3, 1, $15, 0, 0, 0, 0
	spritePiece	-4, -$1A, 1, 2, $21, 0, 0, 0, 0
@walk1_End

@walk2:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $18, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
@walk2_End

@walk3:	spriteHeader
	spritePiece	-$C, -$10, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 8, 3, 1, $1B, 0, 0, 0, 0
	spritePiece	-4, -$1A, 1, 2, $21, 0, 0, 0, 0
@walk3_End

@walk4:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $1E, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
@walk4_End

@activate1:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
@activate1_End

@activate2:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
@activate2_End

@fuse1:	spriteHeader
	spritePiece	-4, -$19, 1, 2, $23, 0, 0, 0, 0
@fuse1_End

@fuse2:	spriteHeader
	spritePiece	-4, -$19, 1, 2, $25, 0, 0, 0, 0
@fuse2_End

@shrapnel1:	spriteHeader
	spritePiece	-4, -4, 1, 1, $27, 0, 0, 0, 0
@shrapnel1_End

@shrapnel2:	spriteHeader
	spritePiece	-4, -4, 1, 1, $28, 0, 0, 0, 0
@shrapnel2_End

	even
