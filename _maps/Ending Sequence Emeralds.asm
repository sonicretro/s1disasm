; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------
Map_ECha_internal:	mappingsTable
	mappingsTableEntry.w	.eCha_flashing
	mappingsTableEntry.w	.eCha_1_blue
	mappingsTableEntry.w	.eCha_2_yellow
	mappingsTableEntry.w	.eCha_3_pink
	mappingsTableEntry.w	.eCha_4_green
	mappingsTableEntry.w	.eCha_5_red
	mappingsTableEntry.w	.eCha_6_gray

.eCha_flashing:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
.eCha_flashing_End

.eCha_1_blue:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0
.eCha_1_blue_End

.eCha_2_yellow:	spriteHeader
	spritePiece	-8, -8, 2, 2, $10, 0, 0, 2, 0
.eCha_2_yellow_End

.eCha_3_pink:	spriteHeader
	spritePiece	-8, -8, 2, 2, $18, 0, 0, 1, 0
.eCha_3_pink_End

.eCha_4_green:	spriteHeader
	spritePiece	-8, -8, 2, 2, $14, 0, 0, 2, 0
.eCha_4_green_End

.eCha_5_red:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 0, 0
.eCha_5_red_End

.eCha_6_gray:	spriteHeader
	spritePiece	-8, -8, 2, 2, $C, 0, 0, 0, 0
.eCha_6_gray_End

	even
