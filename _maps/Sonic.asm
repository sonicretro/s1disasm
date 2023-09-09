; ---------------------------------------------------------------------------
; Sprite mappings - Sonic
; ---------------------------------------------------------------------------
Map_Sonic_internal:	mappingsTable
	mappingsTableEntry.w MS_Null
	mappingsTableEntry.w MS_Stand
	mappingsTableEntry.w MS_Wait1
	mappingsTableEntry.w MS_Wait2
	mappingsTableEntry.w MS_Wait3
	mappingsTableEntry.w MS_LookUp
	mappingsTableEntry.w MS_Walk11
	mappingsTableEntry.w MS_Walk12
	mappingsTableEntry.w MS_Walk13
	mappingsTableEntry.w MS_Walk14
	mappingsTableEntry.w MS_Walk15
	mappingsTableEntry.w MS_Walk16
	mappingsTableEntry.w MS_Walk21
	mappingsTableEntry.w MS_Walk22
	mappingsTableEntry.w MS_Walk23
	mappingsTableEntry.w MS_Walk24
	mappingsTableEntry.w MS_Walk25
	mappingsTableEntry.w MS_Walk26
	mappingsTableEntry.w MS_Walk31
	mappingsTableEntry.w MS_Walk32
	mappingsTableEntry.w MS_Walk33
	mappingsTableEntry.w MS_Walk34
	mappingsTableEntry.w MS_Walk35
	mappingsTableEntry.w MS_Walk36
	mappingsTableEntry.w MS_Walk41
	mappingsTableEntry.w MS_Walk42
	mappingsTableEntry.w MS_Walk43
	mappingsTableEntry.w MS_Walk44
	mappingsTableEntry.w MS_Walk45
	mappingsTableEntry.w MS_Walk46
	mappingsTableEntry.w MS_Run11
	mappingsTableEntry.w MS_Run12
	mappingsTableEntry.w MS_Run13
	mappingsTableEntry.w MS_Run14
	mappingsTableEntry.w MS_Run21
	mappingsTableEntry.w MS_Run22
	mappingsTableEntry.w MS_Run23
	mappingsTableEntry.w MS_Run24
	mappingsTableEntry.w MS_Run31
	mappingsTableEntry.w MS_Run32
	mappingsTableEntry.w MS_Run33
	mappingsTableEntry.w MS_Run34
	mappingsTableEntry.w MS_Run41
	mappingsTableEntry.w MS_Run42
	mappingsTableEntry.w MS_Run43
	mappingsTableEntry.w MS_Run44
	mappingsTableEntry.w MS_Roll1
	mappingsTableEntry.w MS_Roll2
	mappingsTableEntry.w MS_Roll3
	mappingsTableEntry.w MS_Roll4
	mappingsTableEntry.w MS_Roll5
	mappingsTableEntry.w MS_Warp1
	mappingsTableEntry.w MS_Warp2
	mappingsTableEntry.w MS_Warp3
	mappingsTableEntry.w MS_Warp4
	mappingsTableEntry.w MS_Stop1
	mappingsTableEntry.w MS_Stop2
	mappingsTableEntry.w MS_Duck
	mappingsTableEntry.w MS_Balance1
	mappingsTableEntry.w MS_Balance2
	mappingsTableEntry.w MS_Float1
	mappingsTableEntry.w MS_Float2
	mappingsTableEntry.w MS_Float3
	mappingsTableEntry.w MS_Float4
	mappingsTableEntry.w MS_Spring
	mappingsTableEntry.w MS_Hang1
	mappingsTableEntry.w MS_Hang2
	mappingsTableEntry.w MS_Leap1
	mappingsTableEntry.w MS_Leap2
	mappingsTableEntry.w MS_Push1
	mappingsTableEntry.w MS_Push2
	mappingsTableEntry.w MS_Push3
	mappingsTableEntry.w MS_Push4
	mappingsTableEntry.w MS_Surf
	mappingsTableEntry.w MS_BubStand
	mappingsTableEntry.w MS_Burnt
	mappingsTableEntry.w MS_Drown
	mappingsTableEntry.w MS_Death
	mappingsTableEntry.w MS_Shrink1
	mappingsTableEntry.w MS_Shrink2
	mappingsTableEntry.w MS_Shrink3
	mappingsTableEntry.w MS_Shrink4
	mappingsTableEntry.w MS_Shrink5
	mappingsTableEntry.w MS_Float5
	mappingsTableEntry.w MS_Float6
	mappingsTableEntry.w MS_Injury
	mappingsTableEntry.w MS_GetAir
	mappingsTableEntry.w MS_WaterSlide

MS_Null:	spriteHeader
MS_Null_End

MS_Stand:	spriteHeader
	spritePiece	-$10, -$14, 3, 1, 0, 0, 0, 0, 0	; standing
	spritePiece	-$10, -$C, 4, 2, 3, 0, 0, 0, 0
	spritePiece	-$10, 4, 3, 1, $B, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $E, 0, 0, 0, 0
MS_Stand_End

MS_Wait1:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0	; waiting 1
	spritePiece	-$10, -4, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_Wait1_End

MS_Wait2:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0	; waiting 2
	spritePiece	-$10, -4, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_Wait2_End

MS_Wait3:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0	; waiting 3
	spritePiece	-$10, -4, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_Wait3_End

MS_LookUp:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, 0, 0, 0, 0, 0	; looking up
	spritePiece	-$10, 4, 3, 1, 9, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $C, 0, 0, 0, 0
MS_LookUp_End

MS_Walk11:	spriteHeader
	spritePiece	-$14, -$15, 4, 2, 0, 0, 0, 0, 0	; walking 1-1
	spritePiece	-$14, -5, 3, 2, 8, 0, 0, 0, 0
	spritePiece	4, -5, 2, 3, $E, 0, 0, 0, 0
	spritePiece	-$14, $B, 2, 1, $14, 0, 0, 0, 0
MS_Walk11_End

MS_Walk12:	spriteHeader
	spritePiece	-$13, -$14, 4, 2, 0, 0, 0, 0, 0	; walking 1-2
	spritePiece	-$B, -4, 4, 3, 8, 0, 0, 0, 0
MS_Walk12_End

MS_Walk13:	spriteHeader
	spritePiece	-$D, -$13, 3, 2, 0, 0, 0, 0, 0	; walking 1-3
	spritePiece	-$D, -3, 3, 3, 6, 0, 0, 0, 0
MS_Walk13_End

MS_Walk14:	spriteHeader
	spritePiece	-$C, -$15, 3, 2, 0, 0, 0, 0, 0	; walking 1-4
	spritePiece	-$14, -5, 3, 2, 6, 0, 0, 0, 0
	spritePiece	4, -5, 2, 3, $C, 0, 0, 0, 0
	spritePiece	-$14, $B, 2, 1, $12, 0, 0, 0, 0
MS_Walk14_End

MS_Walk15:	spriteHeader
	spritePiece	-$D, -$14, 3, 2, 0, 0, 0, 0, 0	; walking 1-5
	spritePiece	-$15, -4, 4, 3, 6, 0, 0, 0, 0
MS_Walk15_End

MS_Walk16:	spriteHeader
	spritePiece	-$14, -$13, 4, 2, 0, 0, 0, 0, 0	; walking 1-6
	spritePiece	-$C, -3, 4, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, 5, 3, 2, $C, 0, 0, 0, 0
MS_Walk16_End

MS_Walk21:	spriteHeader
	spritePiece	-$15, -$15, 3, 2, 0, 0, 0, 0, 0	; walking 2-1
	spritePiece	3, -$15, 2, 3, 6, 0, 0, 0, 0
	spritePiece	-$15, -5, 3, 1, $C, 0, 0, 0, 0
	spritePiece	-$D, 3, 3, 2, $F, 0, 0, 0, 0
	spritePiece	-5, $13, 1, 1, $15, 0, 0, 0, 0
MS_Walk21_End

MS_Walk22:	spriteHeader
	spritePiece	-$14, -$14, 3, 2, 0, 0, 0, 0, 0	; walking 2-2
	spritePiece	4, -$14, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$14, -4, 4, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $C, 0, 0, 0, 0
	spritePiece	$C, -4, 2, 2, $12, 0, 0, 0, 0
	spritePiece	$14, -$C, 1, 1, $16, 0, 0, 0, 0
MS_Walk22_End

MS_Walk23:	spriteHeader
	spritePiece	-$13, -$13, 3, 2, 0, 0, 0, 0, 0	; walking 2-3
	spritePiece	5, -$13, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$B, -3, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-3, $D, 3, 1, $10, 0, 0, 0, 0
MS_Walk23_End

MS_Walk24:	spriteHeader
	spritePiece	-$15, -$15, 3, 2, 0, 0, 0, 0, 0	; walking 2-4
	spritePiece	3, -$15, 2, 2, 6, 0, 0, 0, 0
	spritePiece	-$D, -5, 4, 2, $A, 0, 0, 0, 0
	spritePiece	-$D, $B, 3, 1, $12, 0, 0, 0, 0
	spritePiece	-5, $13, 2, 1, $15, 0, 0, 0, 0
MS_Walk24_End

MS_Walk25:	spriteHeader
	spritePiece	-$14, -$14, 3, 2, 0, 0, 0, 0, 0	; walking 2-5
	spritePiece	4, -$14, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$C, -4, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-4, $C, 3, 1, $10, 0, 0, 0, 0
MS_Walk25_End

MS_Walk26:	spriteHeader
	spritePiece	-$13, -$13, 3, 2, 0, 0, 0, 0, 0	; walking 2-6
	spritePiece	5, -$13, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$13, -3, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-$B, -3, 4, 2, 9, 0, 0, 0, 0
	spritePiece	-3, $D, 3, 1, $11, 0, 0, 0, 0
MS_Walk26_End

MS_Walk31:	spriteHeader
	spritePiece	-$15, -$C, 2, 4, 0, 0, 0, 0, 0	; walking 3-1
	spritePiece	-5, -$14, 3, 2, 8, 0, 0, 0, 0
	spritePiece	-5, -4, 2, 1, $E, 0, 0, 0, 0
	spritePiece	-5, 4, 3, 2, $10, 0, 0, 0, 0
MS_Walk31_End

MS_Walk32:	spriteHeader
	spritePiece	-$14, -$C, 2, 4, 0, 0, 0, 0, 0	; walking 3-2
	spritePiece	-4, -$14, 3, 4, 8, 0, 0, 0, 0
MS_Walk32_End

MS_Walk33:	spriteHeader
	spritePiece	-$13, -$C, 2, 3, 0, 0, 0, 0, 0	; walking 3-3
	spritePiece	-3, -$C, 3, 3, 6, 0, 0, 0, 0
MS_Walk33_End

MS_Walk34:	spriteHeader
	spritePiece	-$15, -$C, 2, 3, 0, 0, 0, 0, 0	; walking 3-4
	spritePiece	-5, -$14, 3, 2, 6, 0, 0, 0, 0
	spritePiece	-5, -4, 2, 1, $C, 0, 0, 0, 0
	spritePiece	-5, 4, 3, 2, $E, 0, 0, 0, 0
MS_Walk34_End

MS_Walk35:	spriteHeader
	spritePiece	-$14, -$C, 2, 3, 0, 0, 0, 0, 0	; walking 3-5
	spritePiece	-4, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Walk35_End

MS_Walk36:	spriteHeader
	spritePiece	-$13, -$C, 2, 4, 0, 0, 0, 0, 0	; walking 3-6
	spritePiece	-3, -$14, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-3, -$C, 3, 3, 9, 0, 0, 0, 0
MS_Walk36_End

MS_Walk41:	spriteHeader
	spritePiece	-$15, -3, 2, 3, 0, 0, 0, 0, 0	; walking 4-1
	spritePiece	-$D, -$13, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-$15, -$B, 2, 1, 8, 0, 0, 0, 0
	spritePiece	-5, -$B, 3, 3, $A, 0, 0, 0, 0
	spritePiece	-5, $D, 1, 1, $13, 0, 0, 0, 0
	spritePiece	$13, -3, 1, 1, $14, 0, 0, 0, 0
MS_Walk41_End

MS_Walk42:	spriteHeader
	spritePiece	-$14, -4, 2, 3, 0, 0, 0, 0, 0	; walking 4-2
	spritePiece	-$C, -$1C, 3, 1, 6, 0, 0, 0, 0
	spritePiece	-4, -$14, 2, 1, 9, 0, 0, 0, 0
	spritePiece	-$14, -$C, 2, 1, $B, 0, 0, 0, 0
	spritePiece	-4, -$C, 3, 3, $D, 0, 0, 0, 0
	spritePiece	-4, $C, 1, 1, $16, 0, 0, 0, 0
MS_Walk42_End

MS_Walk43:	spriteHeader
	spritePiece	-$13, -5, 2, 3, 0, 0, 0, 0, 0	; walking 4-3
	spritePiece	-$13, -$D, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-3, -$15, 3, 3, 8, 0, 0, 0, 0
	spritePiece	-3, 3, 2, 1, $11, 0, 0, 0, 0
MS_Walk43_End

MS_Walk44:	spriteHeader
	spritePiece	-$15, -3, 2, 3, 0, 0, 0, 0, 0	; walking 4-4
	spritePiece	-$D, -$13, 3, 1, 6, 0, 0, 0, 0
	spritePiece	-$15, -$B, 2, 1, 9, 0, 0, 0, 0
	spritePiece	-5, -$B, 4, 2, $B, 0, 0, 0, 0
	spritePiece	-5, 5, 3, 1, $13, 0, 0, 0, 0
MS_Walk44_End

MS_Walk45:	spriteHeader
	spritePiece	-$14, -4, 2, 3, 0, 0, 0, 0, 0	; walking 4-5
	spritePiece	-$14, -$C, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-4, -$14, 3, 3, 8, 0, 0, 0, 0
	spritePiece	-4, 4, 2, 1, $11, 0, 0, 0, 0
MS_Walk45_End

MS_Walk46:	spriteHeader
	spritePiece	-$13, -5, 2, 3, 0, 0, 0, 0, 0	; walking 4-6
	spritePiece	-3, -$15, 3, 3, 6, 0, 0, 0, 0
	spritePiece	-$13, -$D, 2, 1, $F, 0, 0, 0, 0
	spritePiece	-3, 3, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-3, $B, 1, 1, $13, 0, 0, 0, 0
MS_Walk46_End

MS_Run11:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0	; running 1-1
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run11_End

MS_Run12:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0	; running 1-2
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run12_End

MS_Run13:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0	; running 1-3
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run13_End

MS_Run14:	spriteHeader
	spritePiece	-$C, -$12, 3, 2, 0, 0, 0, 0, 0	; running 1-4
	spritePiece	-$14, -2, 4, 3, 6, 0, 0, 0, 0
MS_Run14_End

MS_Run21:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0	; running 2-1
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
	spritePiece	-$12, -2, 1, 1, $14, 0, 0, 0, 0
MS_Run21_End

MS_Run22:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0	; running 2-2
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
MS_Run22_End

MS_Run23:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0	; running 2-3
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
	spritePiece	-$12, -2, 1, 1, $14, 0, 0, 0, 0
MS_Run23_End

MS_Run24:	spriteHeader
	spritePiece	-$12, -$12, 3, 2, 0, 0, 0, 0, 0	; running 2-4
	spritePiece	6, -$12, 1, 2, 6, 0, 0, 0, 0
	spritePiece	-$A, -2, 4, 3, 8, 0, 0, 0, 0
MS_Run24_End

MS_Run31:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0	; running 3-1
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run31_End

MS_Run32:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0	; running 3-2
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run32_End

MS_Run33:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0	; running 3-3
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run33_End

MS_Run34:	spriteHeader
	spritePiece	-$12, -$C, 2, 3, 0, 0, 0, 0, 0	; running 3-4
	spritePiece	-2, -$C, 3, 4, 6, 0, 0, 0, 0
MS_Run34_End

MS_Run41:	spriteHeader
	spritePiece	-$12, -6, 2, 3, 0, 0, 0, 0, 0	; running 4-1
	spritePiece	-$12, -$E, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-2, $A, 1, 1, $14, 0, 0, 0, 0
MS_Run41_End

MS_Run42:	spriteHeader
	spritePiece	-$12, -$E, 2, 4, 0, 0, 0, 0, 0	; running 4-2
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
MS_Run42_End

MS_Run43:	spriteHeader
	spritePiece	-$12, -6, 2, 3, 0, 0, 0, 0, 0	; running 4-3
	spritePiece	-$12, -$E, 2, 1, 6, 0, 0, 0, 0
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
	spritePiece	-2, $A, 1, 1, $14, 0, 0, 0, 0
MS_Run43_End

MS_Run44:	spriteHeader
	spritePiece	-$12, -$E, 2, 4, 0, 0, 0, 0, 0	; running 4-4
	spritePiece	-2, -$16, 3, 4, 8, 0, 0, 0, 0
MS_Run44_End

MS_Roll1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; rolling 1
MS_Roll1_End

MS_Roll2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; rolling 2
MS_Roll2_End

MS_Roll3:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; rolling 3
MS_Roll3_End

MS_Roll4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; rolling 4
MS_Roll4_End

MS_Roll5:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; rolling 5
MS_Roll5_End

MS_Warp1:	spriteHeader
	spritePiece	-$14, -$C, 4, 3, 0, 0, 0, 0, 0	; warped 1 (unused)
	spritePiece	$C, -$C, 1, 3, $C, 0, 0, 0, 0
MS_Warp1_End

MS_Warp2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; warped 2 (unused)
MS_Warp2_End

MS_Warp3:	spriteHeader
	spritePiece	-$C, -$14, 3, 4, 0, 0, 0, 0, 0	; warped 3 (unused)
	spritePiece	-$C, $C, 3, 1, $C, 0, 0, 0, 0
MS_Warp3_End

MS_Warp4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0	; warped 4 (unused)
MS_Warp4_End

MS_Stop1:	spriteHeader
	spritePiece	-$10, -$13, 3, 2, 0, 0, 0, 0, 0	; stopping 1
	spritePiece	-$10, -3, 4, 3, 6, 0, 0, 0, 0
MS_Stop1_End

MS_Stop2:	spriteHeader
	spritePiece	-$10, -$13, 3, 2, 0, 0, 0, 0, 0	; stopping 2
	spritePiece	-$10, -3, 4, 2, 6, 0, 0, 0, 0
	spritePiece	0, $D, 2, 1, $E, 0, 0, 0, 0
	spritePiece	-$18, 5, 1, 1, $10, 0, 0, 0, 0
MS_Stop2_End

MS_Duck:	spriteHeader
	spritePiece	-4, -$C, 2, 1, 0, 0, 0, 0, 0	; ducking
	spritePiece	-$C, -4, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-$C, $C, 3, 1, $A, 0, 0, 0, 0
	spritePiece	-$14, 4, 1, 1, $D, 0, 0, 0, 0
MS_Duck_End

MS_Balance1:	spriteHeader
	spritePiece	-$18, -$14, 3, 1, 0, 1, 0, 0, 0	; balancing 1
	spritePiece	0, -$C, 1, 3, 3, 1, 0, 0, 0
	spritePiece	-$20, -$C, 4, 4, 6, 1, 0, 0, 0
MS_Balance1_End

MS_Balance2:	spriteHeader
	spritePiece	-$18, -$14, 4, 3, 0, 1, 0, 0, 0	; balancing 2
	spritePiece	-$20, 4, 4, 2, $C, 1, 0, 0, 0
	spritePiece	0, $C, 1, 1, $14, 1, 1, 0, 0
MS_Balance2_End

MS_Float1:	spriteHeader
	spritePiece	-4, -$C, 4, 2, 0, 0, 0, 0, 0	; spinning 1 (LZ)
	spritePiece	-$14, -4, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 1, $C, 0, 0, 0, 0
MS_Float1_End

MS_Float2:	spriteHeader
	spritePiece	-$18, -$C, 3, 3, 0, 0, 0, 0, 0	; spinning 2 (LZ)
	spritePiece	0, -$C, 3, 3, 0, 1, 0, 0, 0
MS_Float2_End

MS_Float3:	spriteHeader
	spritePiece	-$1C, -$C, 4, 2, 0, 0, 0, 0, 0	; spinning 3 (LZ)
	spritePiece	4, -4, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 1, 9, 0, 0, 0, 0
MS_Float3_End

MS_Float4:	spriteHeader
	spritePiece	-4, -$C, 4, 2, 0, 0, 0, 0, 0	; spinning 4 (LZ)
	spritePiece	-$14, -4, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 1, $C, 0, 0, 0, 0
MS_Float4_End

MS_Spring:	spriteHeader
	spritePiece	-$10, -$18, 3, 4, 0, 0, 0, 0, 0	; bouncing on a spring
	spritePiece	-8, 8, 2, 1, $C, 0, 0, 0, 0
	spritePiece	-8, $10, 1, 1, $E, 0, 0, 0, 0
MS_Spring_End

MS_Hang1:	spriteHeader
	spritePiece	-$18, -8, 4, 3, 0, 0, 0, 0, 0	; hanging 1 (LZ)
	spritePiece	8, 0, 2, 2, $C, 0, 0, 0, 0
	spritePiece	8, -8, 1, 1, $10, 0, 0, 0, 0
	spritePiece	-8, -$10, 1, 1, $11, 0, 0, 0, 0
MS_Hang1_End

MS_Hang2:	spriteHeader
	spritePiece	-$18, -8, 4, 3, 0, 0, 0, 0, 0	; hanging 2 (LZ)
	spritePiece	8, 0, 2, 2, $C, 0, 0, 0, 0
	spritePiece	8, -8, 1, 1, $10, 0, 0, 0, 0
	spritePiece	-8, -$10, 1, 1, $11, 0, 0, 0, 0
MS_Hang2_End

MS_Leap1:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, 0, 0, 0, 0, 0	; celebration leap 1 (unused)
	spritePiece	$C, -$10, 1, 2, 9, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 2, $B, 0, 0, 0, 0
	spritePiece	-$C, $10, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-$14, 0, 1, 1, $13, 0, 0, 0, 0
MS_Leap1_End

MS_Leap2:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, 0, 0, 0, 0, 0	; celebration leap 2 (unused)
	spritePiece	$C, -$18, 1, 2, 9, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 2, $B, 0, 0, 0, 0
	spritePiece	-$C, $10, 2, 1, $11, 0, 0, 0, 0
	spritePiece	-$14, 0, 1, 1, $13, 0, 0, 0, 0
MS_Leap2_End

MS_Push1:	spriteHeader
	spritePiece	-$D, -$13, 3, 3, 0, 0, 0, 0, 0	; pushing 1
	spritePiece	-$15, 5, 4, 2, 9, 0, 0, 0, 0
MS_Push1_End

MS_Push2:	spriteHeader
	spritePiece	-$D, -$14, 3, 3, 0, 0, 0, 0, 0	; pushing 2
	spritePiece	-$D, 4, 3, 1, 9, 0, 0, 0, 0
	spritePiece	-$D, $C, 2, 1, $C, 0, 0, 0, 0
MS_Push2_End

MS_Push3:	spriteHeader
	spritePiece	-$D, -$13, 3, 3, 0, 0, 0, 0, 0	; pushing 3
	spritePiece	-$15, 5, 4, 2, 9, 0, 0, 0, 0
MS_Push3_End

MS_Push4:	spriteHeader
	spritePiece	-$D, -$14, 3, 3, 0, 0, 0, 0, 0	; pushing 4
	spritePiece	-$D, 4, 3, 1, 9, 0, 0, 0, 0
	spritePiece	-$D, $C, 2, 1, $C, 0, 0, 0, 0
MS_Push4_End

MS_Surf:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, 0, 0, 0, 0, 0	; surfing or sliding (unused)
	spritePiece	-$10, -4, 4, 3, 6, 0, 0, 0, 0
MS_Surf_End

MS_BubStand:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, 0, 0, 0, 0, 0	; collecting bubble (unused)
	spritePiece	-8, 4, 2, 2, 9, 0, 0, 0, 0
	spritePiece	-8, -$1C, 1, 1, $D, 0, 0, 0, 0
MS_BubStand_End

MS_Burnt:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, 0, 0, 0, 0, 0	; grey death
	spritePiece	$C, -$18, 1, 2, 8, 0, 0, 0, 0
	spritePiece	-$C, -8, 3, 4, $A, 0, 0, 0, 0
MS_Burnt_End

MS_Drown:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, 0, 0, 0, 0, 0	; drowning
	spritePiece	$C, -$18, 1, 2, 8, 0, 0, 0, 0
	spritePiece	-$C, -8, 3, 2, $A, 0, 0, 0, 0
	spritePiece	-$C, 8, 4, 1, $10, 0, 0, 0, 0
	spritePiece	-$C, $10, 1, 1, $14, 0, 0, 0, 0
MS_Drown_End

MS_Death:	spriteHeader
	spritePiece	-$14, -$18, 4, 2, 0, 0, 0, 0, 0	; death
	spritePiece	$C, -$18, 1, 2, 8, 0, 0, 0, 0
	spritePiece	-$C, -8, 3, 2, $A, 0, 0, 0, 0
	spritePiece	-$C, 8, 4, 1, $10, 0, 0, 0, 0
	spritePiece	-$C, $10, 1, 1, $14, 0, 0, 0, 0
MS_Death_End

MS_Shrink1:	spriteHeader
	spritePiece	-$10, -$14, 3, 1, 0, 0, 0, 0, 0	; shrinking 1 (unused)
	spritePiece	-$10, -$C, 4, 4, 3, 0, 0, 0, 0
MS_Shrink1_End

MS_Shrink2:	spriteHeader
	spritePiece	-$10, -$14, 3, 1, 0, 0, 0, 0, 0	; shrinking 2 (unused)
	spritePiece	-$10, -$C, 4, 3, 3, 0, 0, 0, 0
	spritePiece	-8, $C, 3, 1, $F, 0, 0, 0, 0
MS_Shrink2_End

MS_Shrink3:	spriteHeader
	spritePiece	-$C, -$10, 3, 4, 0, 0, 0, 0, 0	; shrinking 3 (unused)
MS_Shrink3_End

MS_Shrink4:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0	; shrinking 4 (unused)
MS_Shrink4_End

MS_Shrink5:	spriteHeader
	spritePiece	-4, -8, 1, 2, 0, 0, 0, 0, 0	; shrinking 5 (unused)
MS_Shrink5_End

MS_Float5:	spriteHeader
	spritePiece	-$1C, -$C, 4, 2, 0, 1, 0, 0, 0	; spinning 5 (LZ)
	spritePiece	4, -4, 2, 2, 8, 1, 0, 0, 0
	spritePiece	-$14, 4, 3, 1, $C, 1, 0, 0, 0
MS_Float5_End

MS_Float6:	spriteHeader
	spritePiece	-4, -$C, 4, 2, 0, 1, 0, 0, 0	; spinning 6 (LZ)
	spritePiece	-$C, -4, 1, 1, 8, 1, 0, 0, 0
	spritePiece	-$C, 4, 4, 1, 9, 1, 0, 0, 0
MS_Float6_End

MS_Injury:	spriteHeader
	spritePiece	-$14, -$10, 4, 3, 0, 0, 0, 0, 0	; injury
	spritePiece	$C, -8, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$C, 8, 4, 1, $E, 0, 0, 0, 0
MS_Injury_End

MS_GetAir:	spriteHeader
	spritePiece	-$C, -$15, 3, 2, 0, 0, 0, 0, 0	; collecting bubble (LZ)
	spritePiece	-$14, -5, 4, 3, 6, 0, 0, 0, 0
	spritePiece	$C, 3, 1, 2, $12, 0, 0, 0, 0
MS_GetAir_End

MS_WaterSlide:	spriteHeader
	spritePiece	-$14, -$10, 4, 4, 0, 0, 0, 0, 0	; water	slide (LZ)
	spritePiece	$C, -8, 1, 3, $10, 0, 0, 0, 0
MS_WaterSlide_End

	even
