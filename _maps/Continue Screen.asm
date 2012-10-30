; ---------------------------------------------------------------------------
; Sprite mappings - Continue screen
; ---------------------------------------------------------------------------
Map_ContScr:	mappingsTable
	mappingsTableEntry.w	M_Cont_text
	mappingsTableEntry.w	M_Cont_Sonic1
	mappingsTableEntry.w	M_Cont_Sonic2
	mappingsTableEntry.w	M_Cont_Sonic3
	mappingsTableEntry.w	M_Cont_oval
	mappingsTableEntry.w	M_Cont_Mini1
	mappingsTableEntry.w	M_Cont_Mini1
	mappingsTableEntry.w	M_Cont_Mini2

M_Cont_text:	spriteHeader
	spritePiece	-$3C, -8, 2, 2, $88, 0, 0, 0, 0
	spritePiece	-$2C, -8, 2, 2, $B2, 0, 0, 0, 0
	spritePiece	-$1C, -8, 2, 2, $AE, 0, 0, 0, 0
	spritePiece	-$C, -8, 2, 2, $C2, 0, 0, 0, 0
	spritePiece	4, -8, 1, 2, $A0, 0, 0, 0, 0
	spritePiece	$C, -8, 2, 2, $AE, 0, 0, 0, 0
	spritePiece	$1C, -8, 2, 2, $C6, 0, 0, 0, 0
	spritePiece	$2C, -8, 2, 2, $90, 0, 0, 0, 0
	spritePiece	-$18, $38, 2, 2, $21, 0, 0, 1, 0
	spritePiece	8, $38, 2, 2, $21, 0, 0, 1, 0
	spritePiece	-8, $36, 2, 2, $1FC, 0, 0, 0, 0
M_Cont_text_End

M_Cont_Sonic1:	spriteHeader
	spritePiece	-4, 4, 2, 2, $15, 0, 0, 0, 0
	spritePiece	-$14, -$C, 3, 3, 6, 0, 0, 0, 0
	spritePiece	4, -$C, 2, 3, $F, 0, 0, 0, 0
M_Cont_Sonic1_End

M_Cont_Sonic2:	spriteHeader
	spritePiece	-4, 4, 2, 2, $19, 0, 0, 0, 0
	spritePiece	-$14, -$C, 3, 3, 6, 0, 0, 0, 0
	spritePiece	4, -$C, 2, 3, $F, 0, 0, 0, 0
M_Cont_Sonic2_End

M_Cont_Sonic3:	spriteHeader
	spritePiece	-4, 4, 2, 2, $1D, 0, 0, 0, 0
	spritePiece	-$14, -$C, 3, 3, 6, 0, 0, 0, 0
	spritePiece	4, -$C, 2, 3, $F, 0, 0, 0, 0
M_Cont_Sonic3_End

M_Cont_oval:	spriteHeader
	spritePiece	-$18, $60, 3, 2, 0, 0, 0, 1, 0
	spritePiece	0, $60, 3, 2, 0, 1, 0, 1, 0
M_Cont_oval_End

M_Cont_Mini1:	spriteHeader
	spritePiece	0, 0, 2, 3, $12, 0, 0, 0, 0
M_Cont_Mini1_End

M_Cont_Mini2:	spriteHeader
	spritePiece	0, 0, 2, 3, $18, 0, 0, 0, 0
M_Cont_Mini2_End

	even
