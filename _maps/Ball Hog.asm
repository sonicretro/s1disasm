; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------
Map_Hog:	mappingsTable
	mappingsTableEntry.w	M_Hog_Stand
	mappingsTableEntry.w	M_Hog_Open
	mappingsTableEntry.w	M_Hog_Squat
	mappingsTableEntry.w	M_Hog_Leap
	mappingsTableEntry.w	M_Hog_Ball1
	mappingsTableEntry.w	M_Hog_Ball2

M_Hog_Stand:	spriteHeader
	spritePiece	-$C, -$11, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -1, 3, 3, 6, 0, 0, 0, 0
M_Hog_Stand_End

M_Hog_Open:	spriteHeader
	spritePiece	-$C, -$11, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -1, 3, 3, $F, 0, 0, 0, 0
M_Hog_Open_End

M_Hog_Squat:	spriteHeader
	spritePiece	-$C, -$C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $18, 0, 0, 0, 0
M_Hog_Squat_End

M_Hog_Leap:	spriteHeader
	spritePiece	-$C, -$1C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -$C, 3, 3, $1E, 0, 0, 0, 0
M_Hog_Leap_End

M_Hog_Ball1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $27, 0, 0, 0, 0
M_Hog_Ball1_End

M_Hog_Ball2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $2B, 0, 0, 0, 0
M_Hog_Ball2_End

	even
