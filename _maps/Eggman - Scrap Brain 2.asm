; ---------------------------------------------------------------------------
; Sprite mappings - Eggman (SBZ2)
; ---------------------------------------------------------------------------
Map_SEgg:	mappingsTable
	mappingsTableEntry.w	@stand
	mappingsTableEntry.w	@laugh1
	mappingsTableEntry.w	@laugh2
	mappingsTableEntry.w	@jump1
	mappingsTableEntry.w	@jump2
	mappingsTableEntry.w	@surprise
	mappingsTableEntry.w	@starjump
	mappingsTableEntry.w	@running1
	mappingsTableEntry.w	@running2
	mappingsTableEntry.w	@intube
	mappingsTableEntry.w	@cockpit

@stand:	spriteHeader
	spritePiece	-$18, -4, 1, 1, $8F, 0, 0, 0, 0
	spritePiece	-$10, -$18, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $6F, 0, 0, 0, 0
@stand_End

@laugh1:	spriteHeader
	spritePiece	-$10, -$18, 4, 2, $E, 0, 0, 0, 0
	spritePiece	-$10, -$18, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $6F, 0, 0, 0, 0
	spritePiece	-$18, -4, 1, 1, $8F, 0, 0, 0, 0
@laugh1_End
	even
@laugh2:	spriteHeader
	spritePiece	-$10, -$17, 4, 2, $E, 0, 0, 0, 0
	spritePiece	-$10, -$17, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, 1, 4, 4, $7F, 0, 0, 0, 0
	spritePiece	-$18, -3, 1, 1, $8F, 0, 0, 0, 0
@laugh2_End
	even
@jump1:	spriteHeader
	spritePiece	-$10, -$C, 4, 4, $20, 1, 0, 0, 0
	spritePiece	$10, -$B, 2, 1, $30, 1, 0, 0, 0
	spritePiece	-$10, 8, 3, 2, $4E, 1, 0, 0, 0
	spritePiece	-$10, -$14, 4, 3, 0, 0, 0, 0, 0
@jump1_End
	even
@jump2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $20, 1, 0, 0, 0
	spritePiece	$10, -$F, 2, 1, $30, 1, 0, 0, 0
	spritePiece	-8, 8, 2, 3, $3E, 1, 0, 0, 0
	spritePiece	-$10, -$18, 4, 3, 0, 0, 0, 0, 0
@jump2_End
	even
@surprise:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, $16, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, $1E, 0, 0, 0, 0
	spritePiece	-$10, -$18, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $6F, 0, 0, 0, 0
@surprise_End
	even
@starjump:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, $16, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, $1E, 0, 0, 0, 0
	spritePiece	0, 4, 3, 2, $34, 1, 0, 0, 0
	spritePiece	-$18, 4, 2, 2, $3A, 1, 0, 0, 0
	spritePiece	-$10, -$10, 4, 4, $20, 1, 0, 0, 0
	spritePiece	$10, -$F, 2, 1, $54, 1, 0, 0, 0
	spritePiece	-$20, -$F, 2, 1, $54, 0, 0, 0, 0
@starjump_End

@running1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $20, 1, 0, 0, 0
	spritePiece	$10, -$F, 2, 1, $30, 1, 0, 0, 0
	spritePiece	0, 4, 3, 2, $34, 1, 0, 0, 0
	spritePiece	-$18, 4, 2, 2, $3A, 1, 0, 0, 0
	spritePiece	-$10, -$18, 4, 3, 0, 0, 0, 0, 0
@running1_End

@running2:	spriteHeader
	spritePiece	-$10, -$12, 4, 4, $20, 1, 0, 0, 0
	spritePiece	$10, -$11, 2, 1, $30, 1, 0, 0, 0
	spritePiece	0, 9, 2, 2, $44, 1, 0, 0, 0
	spritePiece	-8, 3, 1, 2, $48, 1, 0, 0, 0
	spritePiece	-$18, $B, 2, 2, $4A, 1, 0, 0, 0
	spritePiece	-$10, -$1A, 4, 3, 0, 0, 0, 0, 0
@running2_End
	even
@intube:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, $16, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, $1E, 0, 0, 0, 0
	spritePiece	-$10, -$18, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $6F, 0, 0, 0, 0
	spritePiece	-$10, -$20, 4, 2, $6F0, 1, 1, 1, 0
	spritePiece	-$10, -$10, 4, 2, $6F0, 1, 1, 1, 0
	spritePiece	-$10, 0, 4, 2, $6F0, 1, 1, 1, 0
	spritePiece	-$10, $10, 4, 2, $6F0, 1, 1, 1, 0
@intube_End

@cockpit:	spriteHeader
	spritePiece	-$1C, -$14, 4, 2, $56, 0, 0, 0, 0
	spritePiece	4, -$C, 3, 1, $5E, 0, 0, 0, 0
	spritePiece	-4, -$14, 4, 2, $61, 0, 0, 0, 0
@cockpit_End

	even
