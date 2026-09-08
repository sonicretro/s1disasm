; ---------------------------------------------------------------------------
; Sprite mappings - bubbles (LZ)
; ---------------------------------------------------------------------------
Map_Bub_internal:	mappingsTable
	mappingsTableEntry.w	.bubble1
	mappingsTableEntry.w	.bubble2
	mappingsTableEntry.w	.bubble3
	mappingsTableEntry.w	.bubble4
	mappingsTableEntry.w	.bubble5
	mappingsTableEntry.w	.bubble6
	mappingsTableEntry.w	.bubblefull
	mappingsTableEntry.w	.burst1
	mappingsTableEntry.w	.burst2
	mappingsTableEntry.w	.zero_sm
	mappingsTableEntry.w	.five_sm
	mappingsTableEntry.w	.three_sm
	mappingsTableEntry.w	.one_sm
	mappingsTableEntry.w	.zero
	mappingsTableEntry.w	.five
	mappingsTableEntry.w	.four
	mappingsTableEntry.w	.three
	mappingsTableEntry.w	.two
	mappingsTableEntry.w	.one
	mappingsTableEntry.w	.bubmaker1
	mappingsTableEntry.w	.bubmaker2
	mappingsTableEntry.w	.bubmaker3
	mappingsTableEntry.w	.blank

.bubble1:	spriteHeader
	spritePiece	-4, -4, 1, 1, 0, 0, 0, 0, 0	; bubbles, increasing in size
.bubble1_End

.bubble2:	spriteHeader
	spritePiece	-4, -4, 1, 1, 1, 0, 0, 0, 0
.bubble2_End

.bubble3:	spriteHeader
	spritePiece	-4, -4, 1, 1, 2, 0, 0, 0, 0
.bubble3_End

.bubble4:	spriteHeader
	spritePiece	-8, -8, 2, 2, 3, 0, 0, 0, 0
.bubble4_End

.bubble5:	spriteHeader
	spritePiece	-8, -8, 2, 2, 7, 0, 0, 0, 0
.bubble5_End

.bubble6:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $B, 0, 0, 0, 0
.bubble6_End

.bubblefull:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $14, 0, 0, 0, 0
.bubblefull_End

.burst1:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, $24, 0, 0, 0, 0 ; large bubble bursting
	spritePiece	0, -$10, 2, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $24, 0, 1, 0, 0
	spritePiece	0, 0, 2, 2, $24, 1, 1, 0, 0
.burst1_End

.burst2:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, $28, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, $28, 1, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $28, 0, 1, 0, 0
	spritePiece	0, 0, 2, 2, $28, 1, 1, 0, 0
.burst2_End

.zero_sm:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $2C, 0, 0, 0, 0 ; small, partially-formed countdown numbers
.zero_sm_End

.five_sm:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $32, 0, 0, 0, 0
.five_sm_End

.three_sm:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $38, 0, 0, 0, 0
.three_sm_End

.one_sm:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $3E, 0, 0, 0, 0
.one_sm_End

.zero:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $44, 0, 0, 1, 0 ; fully-formed countdown numbers
.zero_End

.five:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $4A, 0, 0, 1, 0
.five_End

.four:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $50, 0, 0, 1, 0
.four_End

.three:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $56, 0, 0, 1, 0
.three_End

.two:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $5C, 0, 0, 1, 0
.two_End

.one:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $62, 0, 0, 1, 0
.one_End

.bubmaker1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $68, 0, 0, 0, 0
.bubmaker1_End

.bubmaker2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $6C, 0, 0, 0, 0
.bubmaker2_End

.bubmaker3:	spriteHeader
	spritePiece	-8, -8, 2, 2, $70, 0, 0, 0, 0
.bubmaker3_End

.blank:	spriteHeader
.blank_End

	even
