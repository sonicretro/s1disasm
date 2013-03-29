; ---------------------------------------------------------------------------
; Sprite mappings - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Newt:	mappingsTable
	mappingsTableEntry.w	M_Newt_Trans
	mappingsTableEntry.w	M_Newt_Norm
	mappingsTableEntry.w	M_Newt_Fires
	mappingsTableEntry.w	M_Newt_Drop1
	mappingsTableEntry.w	M_Newt_Drop2
	mappingsTableEntry.w	M_Newt_Drop3
	mappingsTableEntry.w	M_Newt_Fly1a
	mappingsTableEntry.w	M_Newt_Fly1b
	mappingsTableEntry.w	M_Newt_Fly2a
	mappingsTableEntry.w	M_Newt_Fly2b
	mappingsTableEntry.w	M_Newt_Blank

M_Newt_Trans:	spriteHeader
	spritePiece	-$14, -$14, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, -4, 4, 3, 9, 0, 0, 0, 0
M_Newt_Trans_End

M_Newt_Norm:	spriteHeader
	spritePiece	-$14, -$14, 2, 3, $15, 0, 0, 0, 0
	spritePiece	-4, -$14, 3, 2, $1B, 0, 0, 0, 0
	spritePiece	-4, -4, 3, 3, $21, 0, 0, 0, 0
M_Newt_Norm_End

M_Newt_Fires:	spriteHeader
	spritePiece	-$14, -$14, 2, 3, $2A, 0, 0, 0, 0
	spritePiece	-4, -$14, 3, 2, $1B, 0, 0, 0, 0
	spritePiece	-4, -4, 3, 3, $21, 0, 0, 0, 0
M_Newt_Fires_End

M_Newt_Drop1:	spriteHeader
	spritePiece	-$14, -$14, 2, 3, $30, 0, 0, 0, 0
	spritePiece	-4, -$14, 3, 2, $1B, 0, 0, 0, 0
	spritePiece	-4, -4, 3, 2, $36, 0, 0, 0, 0
	spritePiece	$C, $C, 1, 1, $3C, 0, 0, 0, 0
M_Newt_Drop1_End

M_Newt_Drop2:	spriteHeader
	spritePiece	-$14, -$C, 4, 2, $3D, 0, 0, 0, 0
	spritePiece	$C, -4, 1, 1, $20, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 1, $45, 0, 0, 0, 0
M_Newt_Drop2_End

M_Newt_Drop3:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
M_Newt_Drop3_End

M_Newt_Fly1a:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 1, 1, $52, 0, 0, 0, 0
M_Newt_Fly1a_End

M_Newt_Fly1b:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 2, 1, $53, 0, 0, 0, 0
M_Newt_Fly1b_End

M_Newt_Fly2a:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 1, 1, $52, 0, 0, 3, 1
M_Newt_Fly2a_End

M_Newt_Fly2b:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 2, 1, $53, 0, 0, 3, 1
M_Newt_Fly2b_End

M_Newt_Blank:	spriteHeader
M_Newt_Blank_End

	even
