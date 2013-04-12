; ---------------------------------------------------------------------------
; Sprite mappings - Sonic
; ---------------------------------------------------------------------------
Map_Sonic:	mappingsTable

ptr_MS_Null:	mappingsTableEntry.w MS_Null
ptr_MS_Stand:	mappingsTableEntry.w MS_Stand
ptr_MS_Wait1:	mappingsTableEntry.w MS_Wait1
ptr_MS_Wait2:	mappingsTableEntry.w MS_Wait2
ptr_MS_Wait3:	mappingsTableEntry.w MS_Wait3
ptr_MS_LookUp:	mappingsTableEntry.w MS_LookUp
ptr_MS_Walk11:	mappingsTableEntry.w MS_Walk11
ptr_MS_Walk12:	mappingsTableEntry.w MS_Walk12
ptr_MS_Walk13:	mappingsTableEntry.w MS_Walk13
ptr_MS_Walk14:	mappingsTableEntry.w MS_Walk14
ptr_MS_Walk15:	mappingsTableEntry.w MS_Walk15
ptr_MS_Walk16:	mappingsTableEntry.w MS_Walk16
ptr_MS_Walk21:	mappingsTableEntry.w MS_Walk21
ptr_MS_Walk22:	mappingsTableEntry.w MS_Walk22
ptr_MS_Walk23:	mappingsTableEntry.w MS_Walk23
ptr_MS_Walk24:	mappingsTableEntry.w MS_Walk24
ptr_MS_Walk25:	mappingsTableEntry.w MS_Walk25
ptr_MS_Walk26:	mappingsTableEntry.w MS_Walk26
ptr_MS_Walk31:	mappingsTableEntry.w MS_Walk31
ptr_MS_Walk32:	mappingsTableEntry.w MS_Walk32
ptr_MS_Walk33:	mappingsTableEntry.w MS_Walk33
ptr_MS_Walk34:	mappingsTableEntry.w MS_Walk34
ptr_MS_Walk35:	mappingsTableEntry.w MS_Walk35
ptr_MS_Walk36:	mappingsTableEntry.w MS_Walk36
ptr_MS_Walk41:	mappingsTableEntry.w MS_Walk41
ptr_MS_Walk42:	mappingsTableEntry.w MS_Walk42
ptr_MS_Walk43:	mappingsTableEntry.w MS_Walk43
ptr_MS_Walk44:	mappingsTableEntry.w MS_Walk44
ptr_MS_Walk45:	mappingsTableEntry.w MS_Walk45
ptr_MS_Walk46:	mappingsTableEntry.w MS_Walk46
ptr_MS_Run11:	mappingsTableEntry.w MS_Run11
ptr_MS_Run12:	mappingsTableEntry.w MS_Run12
ptr_MS_Run13:	mappingsTableEntry.w MS_Run13
ptr_MS_Run14:	mappingsTableEntry.w MS_Run14
ptr_MS_Run21:	mappingsTableEntry.w MS_Run21
ptr_MS_Run22:	mappingsTableEntry.w MS_Run22
ptr_MS_Run23:	mappingsTableEntry.w MS_Run23
ptr_MS_Run24:	mappingsTableEntry.w MS_Run24
ptr_MS_Run31:	mappingsTableEntry.w MS_Run31
ptr_MS_Run32:	mappingsTableEntry.w MS_Run32
ptr_MS_Run33:	mappingsTableEntry.w MS_Run33
ptr_MS_Run34:	mappingsTableEntry.w MS_Run34
ptr_MS_Run41:	mappingsTableEntry.w MS_Run41
ptr_MS_Run42:	mappingsTableEntry.w MS_Run42
ptr_MS_Run43:	mappingsTableEntry.w MS_Run43
ptr_MS_Run44:	mappingsTableEntry.w MS_Run44
ptr_MS_Roll1:	mappingsTableEntry.w MS_Roll1
ptr_MS_Roll2:	mappingsTableEntry.w MS_Roll2
ptr_MS_Roll3:	mappingsTableEntry.w MS_Roll3
ptr_MS_Roll4:	mappingsTableEntry.w MS_Roll4
ptr_MS_Roll5:	mappingsTableEntry.w MS_Roll5
ptr_MS_Warp1:	mappingsTableEntry.w MS_Warp1
ptr_MS_Warp2:	mappingsTableEntry.w MS_Warp2
ptr_MS_Warp3:	mappingsTableEntry.w MS_Warp3
ptr_MS_Warp4:	mappingsTableEntry.w MS_Warp4
ptr_MS_Stop1:	mappingsTableEntry.w MS_Stop1
ptr_MS_Stop2:	mappingsTableEntry.w MS_Stop2
ptr_MS_Duck:	mappingsTableEntry.w MS_Duck
ptr_MS_Balance1:mappingsTableEntry.w MS_Balance1
ptr_MS_Balance2:mappingsTableEntry.w MS_Balance2
ptr_MS_Float1:	mappingsTableEntry.w MS_Float1
ptr_MS_Float2:	mappingsTableEntry.w MS_Float2
ptr_MS_Float3:	mappingsTableEntry.w MS_Float3
ptr_MS_Float4:	mappingsTableEntry.w MS_Float4
ptr_MS_Spring:	mappingsTableEntry.w MS_Spring
ptr_MS_Hang1:	mappingsTableEntry.w MS_Hang1
ptr_MS_Hang2:	mappingsTableEntry.w MS_Hang2
ptr_MS_Leap1:	mappingsTableEntry.w MS_Leap1
ptr_MS_Leap2:	mappingsTableEntry.w MS_Leap2
ptr_MS_Push1:	mappingsTableEntry.w MS_Push1
ptr_MS_Push2:	mappingsTableEntry.w MS_Push2
ptr_MS_Push3:	mappingsTableEntry.w MS_Push3
ptr_MS_Push4:	mappingsTableEntry.w MS_Push4
ptr_MS_Surf:	mappingsTableEntry.w MS_Surf
ptr_MS_BubStand:mappingsTableEntry.w MS_BubStand
ptr_MS_Burnt:	mappingsTableEntry.w MS_Burnt
ptr_MS_Drown:	mappingsTableEntry.w MS_Drown
ptr_MS_Death:	mappingsTableEntry.w MS_Death
ptr_MS_Shrink1:	mappingsTableEntry.w MS_Shrink1
ptr_MS_Shrink2:	mappingsTableEntry.w MS_Shrink2
ptr_MS_Shrink3:	mappingsTableEntry.w MS_Shrink3
ptr_MS_Shrink4:	mappingsTableEntry.w MS_Shrink4
ptr_MS_Shrink5:	mappingsTableEntry.w MS_Shrink5
ptr_MS_Float5:	mappingsTableEntry.w MS_Float5
ptr_MS_Float6:	mappingsTableEntry.w MS_Float6
ptr_MS_Injury:	mappingsTableEntry.w MS_Injury
ptr_MS_GetAir:	mappingsTableEntry.w MS_GetAir
ptr_MS_WaterSlide:mappingsTableEntry.w MS_WaterSlide

MS_Null:	spriteHeader
MS_Null_End

MS_Stand:	spriteHeader
	spritePiece	-$10, -$14, 3, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -$C, 4, 2, 3, 0, 0, 0, 0
	spritePiece	-$10, 4, 3, 1, $B, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $E, 0, 0, 0, 0
MS_Stand_End

MS_Wait1:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -4, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_Wait1_End

MS_Wait2:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -4, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_Wait2_End

MS_Wait3:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -4, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_Wait3_End

MS_LookUp:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, 4, 3, 1, 9, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_LookUp_End

MS_Walk11:	spriteHeader
	spritePiece	-$14, -$15, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -5, 3, 2, 8, 0, 0, 0, 0
	spritePiece	4, -5, 2, 3, $E, 0, 0, 0, 0
	spritePiece	-$14, $B, 2, 1, $14, 0, 0, 0, 0
MS_Walk11_End

MS_Walk12:	spriteHeader
	spritePiece	-$13, -$14, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$B, -4, 4, 3, 8, 0, 0, 0, 0
MS_Walk12_End

MS_Walk13:	spriteHeader
	spritePiece	-$D, -$13, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$D, -3, 3, 3, 6, 0, 0, 0, 0
MS_Walk13_End

MS_Walk14:	spriteHeader
	spritePiece	-$C, -$15, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -5, 3, 2, 6, 0, 0, 0, 0
	spritePiece	4, -5, 2, 3, $C, 0, 0, 0, 0
	spritePiece	-$14, $B, 2, 1, $12, 0, 0, 0, 0
MS_Walk14_End

MS_Walk15:	spriteHeader
	spritePiece	-$D, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$15, -4, 4, 3, 6, 0, 0, 0, 0
MS_Walk15_End

MS_Walk16:	spriteHeader
	spritePiece	-$14, -$13, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -3, 4, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, 5, 3, 2, $C, 0, 0, 0, 0
MS_Walk16_End

MS_Walk21:	spriteHeader
	spritePiece	-$15, -$15, 3, 2, 0, 0, 0, 0, 0
	spritePiece	3, -$15, 2, 3, 6, 0, 0, 0, 0
	spritePiece	-$15, -5, 3, 1, $C, 0, 0, 0, 0
	spritePiece	-$D, 3, 3, 2, $F, 0, 0, 0, 0
	spritePiece	-5, $13, 1, 1, $15, 0, 0, 0, 0
MS_Walk21_End

MS_Walk22:	spriteHeader
	spritePiece	-$14, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	4, -$14, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$14, -4, 4, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $C, 0, 0, 0, 0
	spritePiece	$C, -4, 2, 2, $12, 0, 0, 0, 0
	spritePiece	$14, -$C, 1, 1, $16, 0, 0, 0, 0
MS_Walk22_End

MS_Walk23:	spriteHeader
	spritePiece	-$13, -$13, 3, 2, 0, 0, 0, 0, 0
	spritePiece	5, -$13, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$B, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-3, $D, 3, 1, $10, 0, 0, 0, 0
MS_Walk23_End

MS_Walk24:	spriteHeader
	spritePiece	-$15, -$15, 3, 2, 0, 0, 0, 0, 0
	spritePiece	3, -$15, 2, 2, 6, 0, 0, 0, 0
	spritePiece	-$D, -5, 4, 2, $A, 0, 0, 0, 0
	spritePiece	-$D, $B, 3, 1, $12, 0, 0, 0, 0
	spritePiece	-5, $13, 2, 1, $15, 0, 0, 0, 0
MS_Walk24_End

MS_Walk25:	spriteHeader
	spritePiece	-$14, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	4, -$14, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$C, -4, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-4, $C, 3, 1, $10, 0, 0, 0, 0
MS_Walk25_End

MS_Walk26:	spriteHeader
	spritePiece	-$13, -$13, 3, 2, 0, 0, 0, 0, 0
	spritePiece	5, -$13, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$13, -3, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-$B, -3, 4, 2, 9, 0, 0, 0, 0
	spritePiece	-3, $D, 3, 1, $11, 0, 0, 0, 0
MS_Walk26_End

MS_Walk31:	spriteHeader
	spritePiece	-$15, -$C, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-5, -$14, 3, 2, 8, 0, 0, 0, 0
	spritePiece	-5, -4, 2, 1, $E, 0, 0, 0, 0
	spritePiece	-5, 4, 3, 2, $10, 0, 0, 0, 0
MS_Walk31_End

MS_Walk32:	spriteHeader
	spritePiece	-$14, -$C, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-4, -$14, 3, 4, 8, 0, 0, 0, 0
MS_Walk32_End

MS_Walk33:	spriteHeader
	spritePiece	-$13, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-3, -$C, 3, 3, 6, 0, 0, 0, 0
MS_Walk33_End

MS_Walk34:	spriteHeader
	spritePiece	-$15, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-5, -$14, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-5, -4, 2, 1, $C, 0, 0, 0, 0
	spritePiece	-5, 4, 3, 2, $E, 0, 0, 0, 0
MS_Walk34_End

MS_Walk35:	spriteHeader
	spritePiece	-$14, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-4, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Walk35_End

MS_Walk36:	spriteHeader
	spritePiece	-$13, -$C, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-3, -$14, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-3, -$C, 3, 3, 9, 0, 0, 0, 0
MS_Walk36_End

MS_Walk41:	spriteHeader
	spritePiece	-$15, -3, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$D, -$13, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-$15, -$B, 2, 1, 8, 0, 0, 0, 0
	spritePiece	-5, -$B, 3, 3, $A, 0, 0, 0, 0
	spritePiece	-5, $D, 1, 1, $13, 0, 0, 0, 0
	spritePiece	$13, -3, 1, 1, $14, 0, 0, 0, 0
MS_Walk41_End

MS_Walk42:	spriteHeader
	spritePiece	-$14, -4, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, -$1C, 3, 1, 6, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, 9, 0, 0, 0, 0
	spritePiece	-$14, -$C, 2, 1, $B, 0, 0, 0, 0
	spritePiece	-4, -$C, 3, 3, $D, 0, 0, 0, 0
	spritePiece	-4, $C, 1, 1, $16, 0, 0, 0, 0
MS_Walk42_End

MS_Walk43:	spriteHeader
	spritePiece	-$13, -5, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$13, -$D, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-3, -$15, 3, 3, 8, 0, 0, 0, 0
	spritePiece	-3, 3, 2, 1, $11, 0, 0, 0, 0
MS_Walk43_End

MS_Walk44:	spriteHeader
	spritePiece	-$15, -3, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$D, -$13, 3, 1, 6, 0, 0, 0, 0
	spritePiece	-$15, -$B, 2, 1, 9, 0, 0, 0, 0
	spritePiece	-5, -$B, 4, 2, $B, 0, 0, 0, 0
	spritePiece	-5, 5, 3, 1, $13, 0, 0, 0, 0
MS_Walk44_End

MS_Walk45:	spriteHeader
	spritePiece	-$14, -4, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$14, -$C, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-4, -$14, 3, 3, 8, 0, 0, 0, 0
	spritePiece	-4, 4, 2, 1, $11, 0, 0, 0, 0
MS_Walk45_End

MS_Walk46:	spriteHeader
	spritePiece	-$13, -5, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-3, -$15, 3, 3, 6, 0, 0, 0, 0
	spritePiece	-$13, -$D, 2, 1, $F, 0, 0, 0, 0
	spritePiece	-3, 3, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-3, $B, 1, 1, $13, 0, 0, 0, 0
MS_Walk46_End

MS_Run11:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run11_End

MS_Run12:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run12_End

MS_Run13:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run13_End

MS_Run14:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run14_End

MS_Run21:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
	spritePiece	-$12, -2, 1, 1, $14, 0, 0, 0, 0
MS_Run21_End

MS_Run22:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
MS_Run22_End

MS_Run23:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
	spritePiece	-$12, -2, 1, 1, $14, 0, 0, 0, 0
MS_Run23_End

MS_Run24:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
MS_Run24_End

MS_Run31:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run31_End

MS_Run32:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run32_End

MS_Run33:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run33_End

MS_Run34:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run34_End

MS_Run41:	spriteHeader
	spritePiece	-$12, -6, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$12, -$E, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-2, $A, 1, 1, $14, 0, 0, 0, 0
MS_Run41_End

MS_Run42:	spriteHeader
	spritePiece	-$12, -$E, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
MS_Run42_End

MS_Run43:	spriteHeader
	spritePiece	-$12, -6, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$12, -$E, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-2, $A, 1, 1, $14, 0, 0, 0, 0
MS_Run43_End

MS_Run44:	spriteHeader
	spritePiece	-$12, -$E, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
MS_Run44_End

MS_Roll1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Roll1_End

MS_Roll2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Roll2_End

MS_Roll3:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Roll3_End

MS_Roll4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Roll4_End

MS_Roll5:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Roll5_End

MS_Warp1:	spriteHeader
	spritePiece	-$14, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$C, -$C, 1, 3, $C, 0, 0, 0, 0
MS_Warp1_End

MS_Warp2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Warp2_End

MS_Warp3:	spriteHeader
	spritePiece	-$C, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$C, $C, 3, 1, $C, 0, 0, 0, 0
MS_Warp3_End

MS_Warp4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
MS_Warp4_End

MS_Stop1:	spriteHeader
	spritePiece	-$10, -$13, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -3, 4, 3, 6, 0, 0, 0, 0
MS_Stop1_End

MS_Stop2:	spriteHeader
	spritePiece	-$10, -$13, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -3, 4, 2, 6, 0, 0, 0, 0
	spritePiece	0, $D, 2, 1, $E, 0, 0, 0, 0
	spritePiece	-$18, 5, 1, 1, $10, 0, 0, 0, 0
MS_Stop2_End

MS_Duck:	spriteHeader
	spritePiece	-4, -$C, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$C, -4, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-$C, $C, 3, 1, $A, 0, 0, 0, 0
	spritePiece	-$14, 4, 1, 1, $D, 0, 0, 0, 0
MS_Duck_End

MS_Balance1:	spriteHeader
	spritePiece	-$18, -$14, 3, 1, 0, 1, 0, 0, 0
	spritePiece	0, -$C, 1, 3, 3, 1, 0, 0, 0
	spritePiece	-$20, -$C, 4, 4, 6, 1, 0, 0, 0
MS_Balance1_End

MS_Balance2:	spriteHeader
	spritePiece	-$18, -$14, 4, 3, 0, 1, 0, 0, 0
	spritePiece	-$20, 4, 4, 2, $C, 1, 0, 0, 0
	spritePiece	0, $C, 1, 1, $14, 1, 1, 0, 0
MS_Balance2_End

MS_Float1:	spriteHeader
	spritePiece	-4, -$C, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -4, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 1, $C, 0, 0, 0, 0
MS_Float1_End

MS_Float2:	spriteHeader
	spritePiece	-$18, -$C, 3, 3, 0, 0, 0, 0, 0
	spritePiece	0, -$C, 3, 3, 0, 1, 0, 0, 0
MS_Float2_End

MS_Float3:	spriteHeader
	spritePiece	-$1C, -$C, 4, 2, 0, 0, 0, 0, 0
	spritePiece	4, -4, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 1, 9, 0, 0, 0, 0
MS_Float3_End

MS_Float4:	spriteHeader
	spritePiece	-4, -$C, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -4, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 1, $C, 0, 0, 0, 0
MS_Float4_End

MS_Spring:	spriteHeader
	spritePiece	-$10, -$18, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-8, 8, 2, 1, $C, 0, 0, 0, 0
	spritePiece	-8, $10, 1, 1, $E, 0, 0, 0, 0
MS_Spring_End

MS_Hang1:	spriteHeader
	spritePiece	-$18, -8, 4, 3, 0, 0, 0, 0, 0
	spritePiece	8, 0, 2, 2, $C, 0, 0, 0, 0
	spritePiece	8, -8, 1, 1, $10, 0, 0, 0, 0
	spritePiece	-8, -$10, 1, 1, $11, 0, 0, 0, 0
MS_Hang1_End

MS_Hang2:	spriteHeader
	spritePiece	-$18, -8, 4, 3, 0, 0, 0, 0, 0
	spritePiece	8, 0, 2, 2, $C, 0, 0, 0, 0
	spritePiece	8, -8, 1, 1, $10, 0, 0, 0, 0
	spritePiece	-8, -$10, 1, 1, $11, 0, 0, 0, 0
MS_Hang2_End

MS_Leap1:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$C, -$10, 1, 2, 9, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 2, $B, 0, 0, 0, 0
	spritePiece	-$C, $10, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-$14, 0, 1, 1, $13, 0, 0, 0, 0
MS_Leap1_End

MS_Leap2:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, 0, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, 9, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 2, $B, 0, 0, 0, 0
	spritePiece	-$C, $10, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-$14, 0, 1, 1, $13, 0, 0, 0, 0
MS_Leap2_End

MS_Push1:	spriteHeader
	spritePiece	-$D, -$13, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$15, 5, 4, 2, 9, 0, 0, 0, 0
MS_Push1_End

MS_Push2:	spriteHeader
	spritePiece	-$D, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$D, 4, 3, 1, 9, 0, 0, 0, 0
	spritePiece	-$D, $C, 2, 1, $C, 0, 0, 0, 0
MS_Push2_End

MS_Push3:	spriteHeader
	spritePiece	-$D, -$13, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$15, 5, 4, 2, 9, 0, 0, 0, 0
MS_Push3_End

MS_Push4:	spriteHeader
	spritePiece	-$D, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$D, 4, 3, 1, 9, 0, 0, 0, 0
	spritePiece	-$D, $C, 2, 1, $C, 0, 0, 0, 0
MS_Push4_End

MS_Surf:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -4, 4, 3, 6, 0, 0, 0, 0
MS_Surf_End

MS_BubStand:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-8, 4, 2, 2, 9, 0, 0, 0, 0
	spritePiece	-8, -$1C, 1, 1, $D, 0, 0, 0, 0
MS_BubStand_End

MS_Burnt:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, 8, 0, 0, 0, 0
	spritePiece	-$C, -8, 3, 4, $A, 0, 0, 0, 0
MS_Burnt_End

MS_Drown:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, 8, 0, 0, 0, 0
	spritePiece	-$C, -8, 3, 2, $A, 0, 0, 0, 0
	spritePiece	-$C, 8, 4, 1, $10, 0, 0, 0, 0
	spritePiece	-$C, $10, 1, 1, $14, 0, 0, 0, 0
MS_Drown_End

MS_Death:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$C, -$18, 1, 2, 8, 0, 0, 0, 0
	spritePiece	-$C, -8, 3, 2, $A, 0, 0, 0, 0
	spritePiece	-$C, 8, 4, 1, $10, 0, 0, 0, 0
	spritePiece	-$C, $10, 1, 1, $14, 0, 0, 0, 0
MS_Death_End

MS_Shrink1:	spriteHeader
	spritePiece	-$10, -$14, 3, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -$C, 4, 4, 3, 0, 0, 0, 0
MS_Shrink1_End

MS_Shrink2:	spriteHeader
	spritePiece	-$10, -$14, 3, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -$C, 4, 3, 3, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $F, 0, 0, 0, 0
MS_Shrink2_End

MS_Shrink3:	spriteHeader
	spritePiece	-$C, -$10, 3, 4, 0, 0, 0, 0, 0
MS_Shrink3_End

MS_Shrink4:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
MS_Shrink4_End

MS_Shrink5:	spriteHeader
	spritePiece	-4, -8, 1, 2, 0, 0, 0, 0, 0
MS_Shrink5_End

MS_Float5:	spriteHeader
	spritePiece	-$1C, -$C, 4, 2, 0, 1, 0, 0, 0
	spritePiece	4, -4, 2, 2, 8, 1, 0, 0, 0
	spritePiece	-$14, 4, 3, 1, $C, 1, 0, 0, 0
MS_Float5_End

MS_Float6:	spriteHeader
	spritePiece	-4, -$C, 4, 2, 0, 1, 0, 0, 0
	spritePiece	-$C, -4, 1, 1, 8, 1, 0, 0, 0
	spritePiece	-$C, 4, 4, 1, 9, 1, 0, 0, 0
MS_Float6_End

MS_Injury:	spriteHeader
	spritePiece	-$14, -$10, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$C, 8, 4, 1, $E, 0, 0, 0, 0
MS_Injury_End

MS_GetAir:	spriteHeader
	spritePiece	-$C, -$15, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, -5, 4, 3, 6, 0, 0, 0, 0
	spritePiece	$C, 3, 1, 2, $12, 0, 0, 0, 0
MS_GetAir_End

MS_WaterSlide:	spriteHeader
	spritePiece	-$14, -$10, 4, 4, 0, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 3, $10, 0, 0, 0, 0
MS_WaterSlide_End

	even

fr_Null:	equ (ptr_MS_Null-Map_Sonic)/2		; 0
fr_Stand:	equ (ptr_MS_Stand-Map_Sonic)/2		; 1
fr_Wait1:	equ (ptr_MS_Wait1-Map_Sonic)/2		; 2
fr_Wait2:	equ (ptr_MS_Wait2-Map_Sonic)/2		; 3
fr_Wait3:	equ (ptr_MS_Wait3-Map_Sonic)/2		; 4
fr_LookUp:	equ (ptr_MS_LookUp-Map_Sonic)/2		; 5
fr_Walk11:	equ (ptr_MS_Walk11-Map_Sonic)/2		; 6
fr_Walk12:	equ (ptr_MS_Walk12-Map_Sonic)/2		; 7
fr_Walk13:	equ (ptr_MS_Walk13-Map_Sonic)/2		; 8
fr_Walk14:	equ (ptr_MS_Walk14-Map_Sonic)/2		; 9
fr_Walk15:	equ (ptr_MS_Walk15-Map_Sonic)/2		; $A
fr_Walk16:	equ (ptr_MS_Walk16-Map_Sonic)/2		; $B
fr_Walk21:	equ (ptr_MS_Walk21-Map_Sonic)/2		; $C
fr_Walk22:	equ (ptr_MS_Walk22-Map_Sonic)/2		; $D
fr_Walk23:	equ (ptr_MS_Walk23-Map_Sonic)/2		; $E
fr_Walk24:	equ (ptr_MS_Walk24-Map_Sonic)/2		; $F
fr_Walk25:	equ (ptr_MS_Walk25-Map_Sonic)/2		; $10
fr_Walk26:	equ (ptr_MS_Walk26-Map_Sonic)/2		; $11
fr_Walk31:	equ (ptr_MS_Walk31-Map_Sonic)/2		; $12
fr_Walk32:	equ (ptr_MS_Walk32-Map_Sonic)/2		; $13
fr_Walk33:	equ (ptr_MS_Walk33-Map_Sonic)/2		; $14
fr_Walk34:	equ (ptr_MS_Walk34-Map_Sonic)/2		; $15
fr_Walk35:	equ (ptr_MS_Walk35-Map_Sonic)/2		; $16
fr_Walk36:	equ (ptr_MS_Walk36-Map_Sonic)/2		; $17
fr_Walk41:	equ (ptr_MS_Walk41-Map_Sonic)/2		; $18
fr_Walk42:	equ (ptr_MS_Walk42-Map_Sonic)/2		; $19
fr_Walk43:	equ (ptr_MS_Walk43-Map_Sonic)/2		; $1A
fr_Walk44:	equ (ptr_MS_Walk44-Map_Sonic)/2		; $1B
fr_Walk45:	equ (ptr_MS_Walk45-Map_Sonic)/2		; $1C
fr_Walk46:	equ (ptr_MS_Walk46-Map_Sonic)/2		; $1D
fr_Run11:	equ (ptr_MS_Run11-Map_Sonic)/2		; $1E
fr_Run12:	equ (ptr_MS_Run12-Map_Sonic)/2		; $1F
fr_Run13:	equ (ptr_MS_Run13-Map_Sonic)/2		; $20
fr_Run14:	equ (ptr_MS_Run14-Map_Sonic)/2		; $21
fr_Run21:	equ (ptr_MS_Run21-Map_Sonic)/2		; $22
fr_Run22:	equ (ptr_MS_Run22-Map_Sonic)/2		; $23
fr_Run23:	equ (ptr_MS_Run23-Map_Sonic)/2		; $24
fr_Run24:	equ (ptr_MS_Run24-Map_Sonic)/2		; $25
fr_Run31:	equ (ptr_MS_Run31-Map_Sonic)/2		; $26
fr_Run32:	equ (ptr_MS_Run32-Map_Sonic)/2		; $27
fr_Run33:	equ (ptr_MS_Run33-Map_Sonic)/2		; $28
fr_Run34:	equ (ptr_MS_Run34-Map_Sonic)/2		; $29
fr_Run41:	equ (ptr_MS_Run41-Map_Sonic)/2		; $2A
fr_Run42:	equ (ptr_MS_Run42-Map_Sonic)/2		; $2B
fr_Run43:	equ (ptr_MS_Run43-Map_Sonic)/2		; $2C
fr_Run44:	equ (ptr_MS_Run44-Map_Sonic)/2		; $2D
fr_Roll1:	equ (ptr_MS_Roll1-Map_Sonic)/2		; $2E
fr_Roll2:	equ (ptr_MS_Roll2-Map_Sonic)/2		; $2F
fr_Roll3:	equ (ptr_MS_Roll3-Map_Sonic)/2		; $30
fr_Roll4:	equ (ptr_MS_Roll4-Map_Sonic)/2		; $31
fr_Roll5:	equ (ptr_MS_Roll5-Map_Sonic)/2		; $32
fr_Warp1:	equ (ptr_MS_Warp1-Map_Sonic)/2		; $33
fr_Warp2:	equ (ptr_MS_Warp2-Map_Sonic)/2		; $34
fr_Warp3:	equ (ptr_MS_Warp3-Map_Sonic)/2		; $35
fr_Warp4:	equ (ptr_MS_Warp4-Map_Sonic)/2		; $36
fr_Stop1:	equ (ptr_MS_Stop1-Map_Sonic)/2		; $37
fr_Stop2:	equ (ptr_MS_Stop2-Map_Sonic)/2		; $38
fr_Duck:	equ (ptr_MS_Duck-Map_Sonic)/2		; $39
fr_Balance1:	equ (ptr_MS_Balance1-Map_Sonic)/2	; $3A
fr_Balance2:	equ (ptr_MS_Balance2-Map_Sonic)/2	; $3B
fr_Float1:	equ (ptr_MS_Float1-Map_Sonic)/2		; $3C
fr_Float2:	equ (ptr_MS_Float2-Map_Sonic)/2		; $3D
fr_Float3:	equ (ptr_MS_Float3-Map_Sonic)/2		; $3E
fr_Float4:	equ (ptr_MS_Float4-Map_Sonic)/2		; $3F
fr_Spring:	equ (ptr_MS_Spring-Map_Sonic)/2		; $40
fr_Hang1:	equ (ptr_MS_Hang1-Map_Sonic)/2		; $41
fr_Hang2:	equ (ptr_MS_Hang2-Map_Sonic)/2		; $42
fr_Leap1:	equ (ptr_MS_Leap1-Map_Sonic)/2		; $43
fr_Leap2:	equ (ptr_MS_Leap2-Map_Sonic)/2		; $44
fr_Push1:	equ (ptr_MS_Push1-Map_Sonic)/2		; $45
fr_Push2:	equ (ptr_MS_Push2-Map_Sonic)/2		; $46
fr_Push3:	equ (ptr_MS_Push3-Map_Sonic)/2		; $47
fr_Push4:	equ (ptr_MS_Push4-Map_Sonic)/2		; $48
fr_Surf:	equ (ptr_MS_Surf-Map_Sonic)/2		; $49
fr_BubStand:	equ (ptr_MS_BubStand-Map_Sonic)/2	; $4A
fr_Burnt:	equ (ptr_MS_Burnt-Map_Sonic)/2		; $4B
fr_Drown:	equ (ptr_MS_Drown-Map_Sonic)/2		; $4C
fr_Death:	equ (ptr_MS_Death-Map_Sonic)/2		; $4D
fr_Shrink1:	equ (ptr_MS_Shrink1-Map_Sonic)/2	; $4E
fr_Shrink2:	equ (ptr_MS_Shrink2-Map_Sonic)/2	; $4F
fr_Shrink3:	equ (ptr_MS_Shrink3-Map_Sonic)/2	; $50
fr_Shrink4:	equ (ptr_MS_Shrink4-Map_Sonic)/2	; $51
fr_Shrink5:	equ (ptr_MS_Shrink5-Map_Sonic)/2	; $52
fr_Float5:	equ (ptr_MS_Float5-Map_Sonic)/2		; $53
fr_Float6:	equ (ptr_MS_Float6-Map_Sonic)/2		; $54
fr_Injury:	equ (ptr_MS_Injury-Map_Sonic)/2		; $55
fr_GetAir:	equ (ptr_MS_GetAir-Map_Sonic)/2		; $56
fr_WaterSlide:	equ (ptr_MS_WaterSlide-Map_Sonic)/2	; $57