; ---------------------------------------------------------------------------
; Uncompressed graphics	loading	array for Sonic
; ---------------------------------------------------------------------------
SonicDynPLC:	mappingsTable
	mappingsTableEntry.w	SonPLC_Null
	mappingsTableEntry.w	SonPLC_Stand
	mappingsTableEntry.w	SonPLC_Wait1
	mappingsTableEntry.w	SonPLC_Wait2
	mappingsTableEntry.w	SonPLC_Wait3
	mappingsTableEntry.w	SonPLC_LookUp
	mappingsTableEntry.w	SonPLC_Walk11
	mappingsTableEntry.w	SonPLC_Walk12
	mappingsTableEntry.w	SonPLC_Walk13
	mappingsTableEntry.w	SonPLC_Walk14
	mappingsTableEntry.w	SonPLC_Walk15
	mappingsTableEntry.w	SonPLC_Walk16
	mappingsTableEntry.w	SonPLC_Walk21
	mappingsTableEntry.w	SonPLC_Walk22
	mappingsTableEntry.w	SonPLC_Walk23
	mappingsTableEntry.w	SonPLC_Walk24
	mappingsTableEntry.w	SonPLC_Walk25
	mappingsTableEntry.w	SonPLC_Walk26
	mappingsTableEntry.w	SonPLC_Walk31
	mappingsTableEntry.w	SonPLC_Walk32
	mappingsTableEntry.w	SonPLC_Walk33
	mappingsTableEntry.w	SonPLC_Walk34
	mappingsTableEntry.w	SonPLC_Walk35
	mappingsTableEntry.w	SonPLC_Walk36
	mappingsTableEntry.w	SonPLC_Walk41
	mappingsTableEntry.w	SonPLC_Walk42
	mappingsTableEntry.w	SonPLC_Walk43
	mappingsTableEntry.w	SonPLC_Walk44
	mappingsTableEntry.w	SonPLC_Walk45
	mappingsTableEntry.w	SonPLC_Walk46
	mappingsTableEntry.w	SonPLC_Run11
	mappingsTableEntry.w	SonPLC_Run12
	mappingsTableEntry.w	SonPLC_Run13
	mappingsTableEntry.w	SonPLC_Run14
	mappingsTableEntry.w	SonPLC_Run21
	mappingsTableEntry.w	SonPLC_Run22
	mappingsTableEntry.w	SonPLC_Run23
	mappingsTableEntry.w	SonPLC_Run24
	mappingsTableEntry.w	SonPLC_Run31
	mappingsTableEntry.w	SonPLC_Run32
	mappingsTableEntry.w	SonPLC_Run33
	mappingsTableEntry.w	SonPLC_Run34
	mappingsTableEntry.w	SonPLC_Run41
	mappingsTableEntry.w	SonPLC_Run42
	mappingsTableEntry.w	SonPLC_Run43
	mappingsTableEntry.w	SonPLC_Run44
	mappingsTableEntry.w	SonPLC_Roll1
	mappingsTableEntry.w	SonPLC_Roll2
	mappingsTableEntry.w	SonPLC_Roll3
	mappingsTableEntry.w	SonPLC_Roll4
	mappingsTableEntry.w	SonPLC_Roll5
	mappingsTableEntry.w	SonPLC_Warp1
	mappingsTableEntry.w	SonPLC_Warp2
	mappingsTableEntry.w	SonPLC_Warp3
	mappingsTableEntry.w	SonPLC_Warp4
	mappingsTableEntry.w	SonPLC_Stop1
	mappingsTableEntry.w	SonPLC_Stop2
	mappingsTableEntry.w	SonPLC_Duck
	mappingsTableEntry.w	SonPLC_Balance1
	mappingsTableEntry.w	SonPLC_Balance2
	mappingsTableEntry.w	SonPLC_Float1
	mappingsTableEntry.w	SonPLC_Float2
	mappingsTableEntry.w	SonPLC_Float3
	mappingsTableEntry.w	SonPLC_Float4
	mappingsTableEntry.w	SonPLC_Spring
	mappingsTableEntry.w	SonPLC_Hang1
	mappingsTableEntry.w	SonPLC_Hang2
	mappingsTableEntry.w	SonPLC_Leap1
	mappingsTableEntry.w	SonPLC_Leap2
	mappingsTableEntry.w	SonPLC_Push1
	mappingsTableEntry.w	SonPLC_Push2
	mappingsTableEntry.w	SonPLC_Push3
	mappingsTableEntry.w	SonPLC_Push4
	mappingsTableEntry.w	SonPLC_Surf
	mappingsTableEntry.w	SonPLC_BubStand
	mappingsTableEntry.w	SonPLC_Death
	mappingsTableEntry.w	SonPLC_Drown
	mappingsTableEntry.w	SonPLC_Burnt
	mappingsTableEntry.w	SonPLC_Shrink1
	mappingsTableEntry.w	SonPLC_Shrink2
	mappingsTableEntry.w	SonPLC_Shrink3
	mappingsTableEntry.w	SonPLC_Shrink4
	mappingsTableEntry.w	SonPLC_Shrink5
	mappingsTableEntry.w	SonPLC_Float1
	mappingsTableEntry.w	SonPLC_Float3
	mappingsTableEntry.w	SonPLC_Injury
	mappingsTableEntry.w	SonPLC_GetAir
	mappingsTableEntry.w	SonPLC_WaterSlide

SonPLC_Null:	dplcHeader
SonPLC_Null_End

SonPLC_Stand:	dplcHeader
	dplcEntry	3, 0
	dplcEntry	8, 3
	dplcEntry	3, $B
	dplcEntry	3, $E
SonPLC_Stand_End

SonPLC_Wait1:	dplcHeader
	dplcEntry	6, $11
	dplcEntry	6, $17
	dplcEntry	3, $1D
SonPLC_Wait1_End

SonPLC_Wait2:	dplcHeader
	dplcEntry	6, $20
	dplcEntry	6, $17
	dplcEntry	3, $1D
SonPLC_Wait2_End

SonPLC_Wait3:	dplcHeader
	dplcEntry	6, $20
	dplcEntry	6, $17
	dplcEntry	3, $26
SonPLC_Wait3_End

SonPLC_LookUp:	dplcHeader
	dplcEntry	9, $29
	dplcEntry	3, $B
	dplcEntry	3, $E
SonPLC_LookUp_End

SonPLC_Walk11:	dplcHeader
	dplcEntry	8, $32
	dplcEntry	6, $3A
	dplcEntry	6, $40
	dplcEntry	2, $46
SonPLC_Walk11_End

SonPLC_Walk12:	dplcHeader
	dplcEntry	8, $32
	dplcEntry	$C, $48
SonPLC_Walk12_End

SonPLC_Walk13:	dplcHeader
	dplcEntry	6, $54
	dplcEntry	9, $5A
SonPLC_Walk13_End

SonPLC_Walk14:	dplcHeader
	dplcEntry	6, $54
	dplcEntry	6, $63
	dplcEntry	6, $69
	dplcEntry	2, $6F
SonPLC_Walk14_End

SonPLC_Walk15:	dplcHeader
	dplcEntry	6, $54
	dplcEntry	$C, $71
SonPLC_Walk15_End

SonPLC_Walk16:	dplcHeader
	dplcEntry	8, $32
	dplcEntry	4, $7D
	dplcEntry	6, $81
SonPLC_Walk16_End

SonPLC_Walk21:	dplcHeader
	dplcEntry	6, $87
	dplcEntry	6, $8D
	dplcEntry	3, $93
	dplcEntry	6, $96
	dplcEntry	1, $9C
SonPLC_Walk21_End

SonPLC_Walk22:	dplcHeader
	dplcEntry	6, $87
	dplcEntry	2, $9D
	dplcEntry	4, $9F
	dplcEntry	6, $A3
	dplcEntry	4, $A9
	dplcEntry	1, $AD
SonPLC_Walk22_End

SonPLC_Walk23:	dplcHeader
	dplcEntry	6, $AE
	dplcEntry	2, $B4
	dplcEntry	8, $B6
	dplcEntry	3, $BE
SonPLC_Walk23_End

SonPLC_Walk24:	dplcHeader
	dplcEntry	6, $C1
	dplcEntry	4, $C7
	dplcEntry	8, $CB
	dplcEntry	3, $D3
	dplcEntry	2, $D6
SonPLC_Walk24_End

SonPLC_Walk25:	dplcHeader
	dplcEntry	6, $C1
	dplcEntry	2, $D8
	dplcEntry	8, $DA
	dplcEntry	3, $E2
SonPLC_Walk25_End

SonPLC_Walk26:	dplcHeader
	dplcEntry	6, $87
	dplcEntry	2, $9D
	dplcEntry	1, $93
	dplcEntry	8, $E5
	dplcEntry	3, $ED
SonPLC_Walk26_End

SonPLC_Walk31:	dplcHeader
	dplcEntry	8, $F0
	dplcEntry	6, $F8
	dplcEntry	2, $FE
	dplcEntry	6, $100
SonPLC_Walk31_End

SonPLC_Walk32:	dplcHeader
	dplcEntry	8, $F0
	dplcEntry	$C, $106
SonPLC_Walk32_End

SonPLC_Walk33:	dplcHeader
	dplcEntry	6, $112
	dplcEntry	9, $118
SonPLC_Walk33_End

SonPLC_Walk34:	dplcHeader
	dplcEntry	6, $112
	dplcEntry	6, $121
	dplcEntry	2, $127
	dplcEntry	6, $129
SonPLC_Walk34_End

SonPLC_Walk35:	dplcHeader
	dplcEntry	6, $112
	dplcEntry	$C, $12F
SonPLC_Walk35_End

SonPLC_Walk36:	dplcHeader
	dplcEntry	8, $F0
	dplcEntry	1, $106
	dplcEntry	9, $13B
SonPLC_Walk36_End

SonPLC_Walk41:	dplcHeader
	dplcEntry	6, $144
	dplcEntry	2, $14A
	dplcEntry	2, $14C
	dplcEntry	9, $14E
	dplcEntry	1, $157
	dplcEntry	1, $158
SonPLC_Walk41_End

SonPLC_Walk42:	dplcHeader
	dplcEntry	6, $144
	dplcEntry	3, $159
	dplcEntry	2, $15C
	dplcEntry	2, $15E
	dplcEntry	9, $160
	dplcEntry	1, $157
SonPLC_Walk42_End

SonPLC_Walk43:	dplcHeader
	dplcEntry	6, $169
	dplcEntry	2, $16F
	dplcEntry	9, $171
	dplcEntry	2, $17A
SonPLC_Walk43_End

SonPLC_Walk44:	dplcHeader
	dplcEntry	6, $17C
	dplcEntry	3, $182
	dplcEntry	2, $185
	dplcEntry	8, $187
	dplcEntry	3, $18F
SonPLC_Walk44_End

SonPLC_Walk45:	dplcHeader
	dplcEntry	6, $17C
	dplcEntry	2, $192
	dplcEntry	9, $194
	dplcEntry	2, $19D
SonPLC_Walk45_End

SonPLC_Walk46:	dplcHeader
	dplcEntry	6, $144
	dplcEntry	9, $19F
	dplcEntry	2, $15E
	dplcEntry	2, $1A8
	dplcEntry	1, $157
SonPLC_Walk46_End

SonPLC_Run11:	dplcHeader
	dplcEntry	6, $1AA
	dplcEntry	$C, $1B0
SonPLC_Run11_End

SonPLC_Run12:	dplcHeader
	dplcEntry	6, $54
	dplcEntry	$C, $1BC
SonPLC_Run12_End

SonPLC_Run13:	dplcHeader
	dplcEntry	6, $1AA
	dplcEntry	$C, $1C8
SonPLC_Run13_End

SonPLC_Run14:	dplcHeader
	dplcEntry	6, $54
	dplcEntry	$C, $1D4
SonPLC_Run14_End

SonPLC_Run21:	dplcHeader
	dplcEntry	6, $1E0
	dplcEntry	2, $1E6
	dplcEntry	$C, $1E8
	dplcEntry	1, $1F4
SonPLC_Run21_End

SonPLC_Run22:	dplcHeader
	dplcEntry	6, $1F5
	dplcEntry	2, $1FB
	dplcEntry	$C, $1FD
SonPLC_Run22_End

SonPLC_Run23:	dplcHeader
	dplcEntry	6, $1E0
	dplcEntry	2, $209
	dplcEntry	$C, $20B
	dplcEntry	1, $1F4
SonPLC_Run23_End

SonPLC_Run24:	dplcHeader
	dplcEntry	6, $1F5
	dplcEntry	2, $1FB
	dplcEntry	$C, $217
SonPLC_Run24_End

SonPLC_Run31:	dplcHeader
	dplcEntry	6, $223
	dplcEntry	$C, $229
SonPLC_Run31_End

SonPLC_Run32:	dplcHeader
	dplcEntry	6, $112
	dplcEntry	$C, $235
SonPLC_Run32_End

SonPLC_Run33:	dplcHeader
	dplcEntry	6, $223
	dplcEntry	$C, $241
SonPLC_Run33_End

SonPLC_Run34:	dplcHeader
	dplcEntry	6, $112
	dplcEntry	$C, $24D
SonPLC_Run34_End

SonPLC_Run41:	dplcHeader
	dplcEntry	6, $259
	dplcEntry	2, $25F
	dplcEntry	$C, $261
	dplcEntry	1, $26D
SonPLC_Run41_End

SonPLC_Run42:	dplcHeader
	dplcEntry	8, $26E
	dplcEntry	$C, $276
SonPLC_Run42_End

SonPLC_Run43:	dplcHeader
	dplcEntry	6, $259
	dplcEntry	2, $282
	dplcEntry	$C, $284
	dplcEntry	1, $26D
SonPLC_Run43_End

SonPLC_Run44:	dplcHeader
	dplcEntry	8, $26E
	dplcEntry	$C, $290
SonPLC_Run44_End

SonPLC_Roll1:	dplcHeader
	dplcEntry	$10, $29C
SonPLC_Roll1_End

SonPLC_Roll2:	dplcHeader
	dplcEntry	$10, $2AC
SonPLC_Roll2_End

SonPLC_Roll3:	dplcHeader
	dplcEntry	$10, $2BC
SonPLC_Roll3_End

SonPLC_Roll4:	dplcHeader
	dplcEntry	$10, $2CC
SonPLC_Roll4_End

SonPLC_Roll5:	dplcHeader
	dplcEntry	$10, $2DC
SonPLC_Roll5_End

SonPLC_Warp1:	dplcHeader
	dplcEntry	$C, $2EC
	dplcEntry	3, $2F8
SonPLC_Warp1_End

SonPLC_Warp2:	dplcHeader
	dplcEntry	$10, $2FB
SonPLC_Warp2_End

SonPLC_Warp3:	dplcHeader
	dplcEntry	$C, $30B
	dplcEntry	3, $317
SonPLC_Warp3_End

SonPLC_Warp4:	dplcHeader
	dplcEntry	$10, $31A
SonPLC_Warp4_End

SonPLC_Stop1:	dplcHeader
	dplcEntry	6, $32A
	dplcEntry	$C, $330
SonPLC_Stop1_End

SonPLC_Stop2:	dplcHeader
	dplcEntry	6, $33C
	dplcEntry	8, $342
	dplcEntry	2, $34A
	dplcEntry	1, $34C
SonPLC_Stop2_End

SonPLC_Duck:	dplcHeader
	dplcEntry	2, $34D
	dplcEntry	8, $34F
	dplcEntry	3, $357
	dplcEntry	1, $35A
SonPLC_Duck_End

SonPLC_Balance1:	dplcHeader
	dplcEntry	3, $35B
	dplcEntry	3, $35E
	dplcEntry	$10, $361
SonPLC_Balance1_End

SonPLC_Balance2:	dplcHeader
	dplcEntry	$C, $371
	dplcEntry	8, $37D
	dplcEntry	1, $71
SonPLC_Balance2_End

SonPLC_Float1:	dplcHeader
	dplcEntry	8, $385
	dplcEntry	4, $38D
	dplcEntry	3, $391
SonPLC_Float1_End

SonPLC_Float2:	dplcHeader
	dplcEntry	9, $394
SonPLC_Float2_End

SonPLC_Float3:	dplcHeader
	dplcEntry	8, $39D
	dplcEntry	1, $3A5
	dplcEntry	4, $3A6
SonPLC_Float3_End

SonPLC_Float4:	dplcHeader
	dplcEntry	8, $3AA
	dplcEntry	4, $3B2
	dplcEntry	3, $3B6
SonPLC_Float4_End

SonPLC_Spring:	dplcHeader
	dplcEntry	$C, $3B9
	dplcEntry	2, $3C5
	dplcEntry	1, $3C7
SonPLC_Spring_End

SonPLC_Hang1:	dplcHeader
	dplcEntry	$C, $3C8
	dplcEntry	4, $3D4
	dplcEntry	1, $3D8
	dplcEntry	1, $3D9
SonPLC_Hang1_End

SonPLC_Hang2:	dplcHeader
	dplcEntry	$C, $3DA
	dplcEntry	4, $3E6
	dplcEntry	1, $3EA
	dplcEntry	1, $3EB
SonPLC_Hang2_End

SonPLC_Leap1:	dplcHeader
	dplcEntry	9, $3EC
	dplcEntry	2, $3F5
	dplcEntry	6, $3F7
	dplcEntry	2, $3FD
	dplcEntry	1, $3FF
SonPLC_Leap1_End

SonPLC_Leap2:	dplcHeader
	dplcEntry	9, $400
	dplcEntry	2, $409
	dplcEntry	6, $3F7
	dplcEntry	2, $3FD
	dplcEntry	1, $3FF
SonPLC_Leap2_End

SonPLC_Push1:	dplcHeader
	dplcEntry	9, $40B
	dplcEntry	8, $414
SonPLC_Push1_End

SonPLC_Push2:	dplcHeader
	dplcEntry	9, $41C
	dplcEntry	3, $425
	dplcEntry	2, $428
SonPLC_Push2_End

SonPLC_Push3:	dplcHeader
	dplcEntry	9, $42A
	dplcEntry	8, $433
SonPLC_Push3_End

SonPLC_Push4:	dplcHeader
	dplcEntry	9, $41C
	dplcEntry	3, $43B
	dplcEntry	2, $43E
SonPLC_Push4_End

SonPLC_Surf:	dplcHeader
	dplcEntry	6, $440
	dplcEntry	$C, $446
SonPLC_Surf_End

SonPLC_BubStand:	dplcHeader
	dplcEntry	9, $452
	dplcEntry	4, $45B
	dplcEntry	1, $45F
SonPLC_BubStand_End

SonPLC_Death:	dplcHeader
	dplcEntry	8, $460
	dplcEntry	2, $468
	dplcEntry	$C, $46A
SonPLC_Death_End

SonPLC_Drown:	dplcHeader
	dplcEntry	8, $476
	dplcEntry	2, $47E
	dplcEntry	6, $480
	dplcEntry	4, $486
	dplcEntry	1, $48A
SonPLC_Drown_End

SonPLC_Burnt:	dplcHeader
	dplcEntry	8, $48B
	dplcEntry	2, $47E
	dplcEntry	6, $493
	dplcEntry	4, $486
	dplcEntry	1, $48A
SonPLC_Burnt_End

SonPLC_Shrink1:	dplcHeader
	dplcEntry	3, $499
	dplcEntry	$10, $49C
SonPLC_Shrink1_End

SonPLC_Shrink2:	dplcHeader
	dplcEntry	3, $4AC
	dplcEntry	$C, $4AF
	dplcEntry	3, $4BB
SonPLC_Shrink2_End

SonPLC_Shrink3:	dplcHeader
	dplcEntry	$C, $4BE
SonPLC_Shrink3_End

SonPLC_Shrink4:	dplcHeader
	dplcEntry	6, $4CA
SonPLC_Shrink4_End

SonPLC_Shrink5:	dplcHeader
	dplcEntry	2, $4D0
SonPLC_Shrink5_End

SonPLC_Injury:	dplcHeader
	dplcEntry	$C, $4D2
	dplcEntry	2, $4DE
	dplcEntry	4, $4E0
SonPLC_Injury_End

SonPLC_GetAir:	dplcHeader
	dplcEntry	6, $4E4
	dplcEntry	$C, $4EA
	dplcEntry	2, $6D
SonPLC_GetAir_End

SonPLC_WaterSlide:	dplcHeader
	dplcEntry	$10, $4F6
	dplcEntry	3, $506
SonPLC_WaterSlide_End

	even
