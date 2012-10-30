; ---------------------------------------------------------------------------
; Sprite mappings - Sonic on the ending	sequence
; ---------------------------------------------------------------------------
Map_ESon:	mappingsTable
	mappingsTableEntry.w	M_ESon_Hold1
	mappingsTableEntry.w	M_ESon_Hold2
	mappingsTableEntry.w	M_ESon_Up
	mappingsTableEntry.w	M_ESon_Conf1
	mappingsTableEntry.w	M_ESon_Conf2
	mappingsTableEntry.w	M_ESon_Leap1
	mappingsTableEntry.w	M_ESon_Leap2
	mappingsTableEntry.w	M_ESon_Leap3

M_ESon_Hold1:	spriteHeader
	spritePiece	-8, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $C, 0, 0, 0, 0
M_ESon_Hold1_End

M_ESon_Hold2:	spriteHeader
	spritePiece	-$10, -4, 4, 2, $10, 0, 0, 0, 0
	spritePiece	-8, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $C, 0, 0, 0, 0
M_ESon_Hold2_End

M_ESon_Up:	spriteHeader
	spritePiece	-8, -$14, 3, 2, $18, 0, 0, 0, 0
	spritePiece	-$10, -4, 4, 3, $1E, 0, 0, 0, 0
M_ESon_Up_End

M_ESon_Conf1:	spriteHeader
	spritePiece	-8, -$14, 3, 2, $2A, 0, 0, 0, 0
	spritePiece	-$10, -4, 4, 3, $30, 0, 0, 0, 0
M_ESon_Conf1_End

M_ESon_Conf2:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, $2A, 1, 0, 0, 0
	spritePiece	-$10, -4, 4, 3, $30, 1, 0, 0, 0
M_ESon_Conf2_End

M_ESon_Leap1:	spriteHeader
	spritePiece	-$10, -$14, 2, 3, $3C, 0, 0, 0, 0
	spritePiece	0, -$14, 2, 3, $3C, 1, 0, 0, 0
	spritePiece	-$10, 4, 4, 2, $42, 0, 0, 0, 0
M_ESon_Leap1_End

M_ESon_Leap2:	spriteHeader
	spritePiece	-8, -$4E, 4, 1, $4A, 0, 0, 0, 0
	spritePiece	-$10, -$46, 4, 4, $4E, 0, 0, 0, 0
	spritePiece	$10, -$46, 2, 2, $5E, 0, 0, 0, 0
	spritePiece	$10, -$36, 1, 3, $62, 0, 0, 0, 0
	spritePiece	-$10, -$26, 4, 1, $65, 0, 0, 0, 0
	spritePiece	-8, -$1E, 3, 1, $69, 0, 0, 0, 0
	spritePiece	-8, -$16, 2, 2, $6C, 0, 0, 0, 0
M_ESon_Leap2_End

M_ESon_Leap3:	spriteHeader
	spritePiece	-8, -$80, 4, 4, $70, 0, 0, 0, 0
	spritePiece	-$20, -$70, 3, 4, $80, 0, 0, 0, 0
	spritePiece	$18, -$70, 3, 4, $8C, 0, 0, 0, 0
	spritePiece	$30, -$68, 3, 4, $98, 0, 0, 0, 0
	spritePiece	$58, -$60, 4, 4, $A4, 0, 0, 0, 0
	spritePiece	-$10, -$78, 1, 1, $B4, 0, 0, 0, 0
	spritePiece	$18, -$80, 2, 2, $B5, 0, 0, 0, 0
	spritePiece	-8, -$60, 4, 4, $B9, 0, 0, 0, 0
	spritePiece	-$20, -$50, 3, 4, $C9, 0, 0, 0, 0
	spritePiece	$38, -$48, 4, 4, $D5, 0, 0, 0, 0
	spritePiece	$48, -$58, 2, 2, $E5, 0, 0, 0, 0
	spritePiece	$58, -$40, 1, 3, $E9, 0, 0, 0, 0
	spritePiece	-8, -$40, 4, 4, $EC, 0, 0, 0, 0
	spritePiece	$18, -$48, 4, 4, $FC, 0, 0, 0, 0
	spritePiece	$18, -$50, 3, 1, $10C, 0, 0, 0, 0
	spritePiece	$30, -$28, 4, 2, $10F, 0, 0, 0, 0
	spritePiece	$18, -$28, 3, 1, $117, 0, 0, 0, 0
	spritePiece	-$28, -$28, 4, 4, $11A, 0, 0, 0, 0
	spritePiece	-8, -$20, 4, 2, $12A, 0, 0, 0, 0
	spritePiece	$28, -$20, 1, 1, $132, 0, 0, 0, 0
	spritePiece	-$20, -$30, 2, 1, $133, 0, 0, 0, 0
	spritePiece	-$38, -$18, 2, 2, $135, 0, 0, 0, 0
	spritePiece	-$38, -8, 4, 1, $139, 0, 0, 0, 0
	spritePiece	-8, -$10, 2, 3, $13D, 0, 0, 0, 0
M_ESon_Leap3_End

	even
