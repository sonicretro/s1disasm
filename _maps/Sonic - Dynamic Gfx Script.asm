; ---------------------------------------------------------------------------
; Uncompressed graphics	loading	array for Sonic
; ---------------------------------------------------------------------------
SonicDynPLC_internal:
		dc.w SonPLC_Null-SonicDynPLC_internal
		dc.w SonPLC_Stand-SonicDynPLC_internal
		dc.w SonPLC_Wait1-SonicDynPLC_internal
		dc.w SonPLC_Wait2-SonicDynPLC_internal
		dc.w SonPLC_Wait3-SonicDynPLC_internal
		dc.w SonPLC_LookUp-SonicDynPLC_internal
		dc.w SonPLC_Walk11-SonicDynPLC_internal
		dc.w SonPLC_Walk12-SonicDynPLC_internal
		dc.w SonPLC_Walk13-SonicDynPLC_internal
		dc.w SonPLC_Walk14-SonicDynPLC_internal
		dc.w SonPLC_Walk15-SonicDynPLC_internal
		dc.w SonPLC_Walk16-SonicDynPLC_internal
		dc.w SonPLC_Walk21-SonicDynPLC_internal
		dc.w SonPLC_Walk22-SonicDynPLC_internal
		dc.w SonPLC_Walk23-SonicDynPLC_internal
		dc.w SonPLC_Walk24-SonicDynPLC_internal
		dc.w SonPLC_Walk25-SonicDynPLC_internal
		dc.w SonPLC_Walk26-SonicDynPLC_internal
		dc.w SonPLC_Walk31-SonicDynPLC_internal
		dc.w SonPLC_Walk32-SonicDynPLC_internal
		dc.w SonPLC_Walk33-SonicDynPLC_internal
		dc.w SonPLC_Walk34-SonicDynPLC_internal
		dc.w SonPLC_Walk35-SonicDynPLC_internal
		dc.w SonPLC_Walk36-SonicDynPLC_internal
		dc.w SonPLC_Walk41-SonicDynPLC_internal
		dc.w SonPLC_Walk42-SonicDynPLC_internal
		dc.w SonPLC_Walk43-SonicDynPLC_internal
		dc.w SonPLC_Walk44-SonicDynPLC_internal
		dc.w SonPLC_Walk45-SonicDynPLC_internal
		dc.w SonPLC_Walk46-SonicDynPLC_internal
		dc.w SonPLC_Run11-SonicDynPLC_internal
		dc.w SonPLC_Run12-SonicDynPLC_internal
		dc.w SonPLC_Run13-SonicDynPLC_internal
		dc.w SonPLC_Run14-SonicDynPLC_internal
		dc.w SonPLC_Run21-SonicDynPLC_internal
		dc.w SonPLC_Run22-SonicDynPLC_internal
		dc.w SonPLC_Run23-SonicDynPLC_internal
		dc.w SonPLC_Run24-SonicDynPLC_internal
		dc.w SonPLC_Run31-SonicDynPLC_internal
		dc.w SonPLC_Run32-SonicDynPLC_internal
		dc.w SonPLC_Run33-SonicDynPLC_internal
		dc.w SonPLC_Run34-SonicDynPLC_internal
		dc.w SonPLC_Run41-SonicDynPLC_internal
		dc.w SonPLC_Run42-SonicDynPLC_internal
		dc.w SonPLC_Run43-SonicDynPLC_internal
		dc.w SonPLC_Run44-SonicDynPLC_internal
		dc.w SonPLC_Roll1-SonicDynPLC_internal
		dc.w SonPLC_Roll2-SonicDynPLC_internal
		dc.w SonPLC_Roll3-SonicDynPLC_internal
		dc.w SonPLC_Roll4-SonicDynPLC_internal
		dc.w SonPLC_Roll5-SonicDynPLC_internal
		dc.w SonPLC_Warp1-SonicDynPLC_internal
		dc.w SonPLC_Warp2-SonicDynPLC_internal
		dc.w SonPLC_Warp3-SonicDynPLC_internal
		dc.w SonPLC_Warp4-SonicDynPLC_internal
		dc.w SonPLC_Stop1-SonicDynPLC_internal
		dc.w SonPLC_Stop2-SonicDynPLC_internal
		dc.w SonPLC_Duck-SonicDynPLC_internal
		dc.w SonPLC_Balance1-SonicDynPLC_internal
		dc.w SonPLC_Balance2-SonicDynPLC_internal
		dc.w SonPLC_Float1-SonicDynPLC_internal
		dc.w SonPLC_Float2-SonicDynPLC_internal
		dc.w SonPLC_Float3-SonicDynPLC_internal
		dc.w SonPLC_Float4-SonicDynPLC_internal
		dc.w SonPLC_Spring-SonicDynPLC_internal
		dc.w SonPLC_Hang1-SonicDynPLC_internal
		dc.w SonPLC_Hang2-SonicDynPLC_internal
		dc.w SonPLC_Leap1-SonicDynPLC_internal
		dc.w SonPLC_Leap2-SonicDynPLC_internal
		dc.w SonPLC_Push1-SonicDynPLC_internal
		dc.w SonPLC_Push2-SonicDynPLC_internal
		dc.w SonPLC_Push3-SonicDynPLC_internal
		dc.w SonPLC_Push4-SonicDynPLC_internal
		dc.w SonPLC_Surf-SonicDynPLC_internal
		dc.w SonPLC_BubStand-SonicDynPLC_internal
		dc.w SonPLC_Death-SonicDynPLC_internal
		dc.w SonPLC_Drown-SonicDynPLC_internal
		dc.w SonPLC_Burnt-SonicDynPLC_internal
		dc.w SonPLC_Shrink1-SonicDynPLC_internal
		dc.w SonPLC_Shrink2-SonicDynPLC_internal
		dc.w SonPLC_Shrink3-SonicDynPLC_internal
		dc.w SonPLC_Shrink4-SonicDynPLC_internal
		dc.w SonPLC_Shrink5-SonicDynPLC_internal
		dc.w SonPLC_Float1-SonicDynPLC_internal
		dc.w SonPLC_Float3-SonicDynPLC_internal
		dc.w SonPLC_Injury-SonicDynPLC_internal
		dc.w SonPLC_GetAir-SonicDynPLC_internal
		dc.w SonPLC_WaterSlide-SonicDynPLC_internal
SonPLC_Null:	dc.b 0
SonPLC_Stand:	dc.b 4,	$20, 0,	$70, 3,	$20, $B, $20, $E
SonPLC_Wait1:	dc.b 3,	$50, $11, $50, $17, $20, $1D
SonPLC_Wait2:	dc.b 3,	$50, $20, $50, $17, $20, $1D
SonPLC_Wait3:	dc.b 3,	$50, $20, $50, $17, $20, $26
SonPLC_LookUp:	dc.b 3,	$80, $29, $20, $B, $20,	$E
SonPLC_Walk11:	dc.b 4,	$70, $32, $50, $3A, $50, $40, $10, $46
SonPLC_Walk12:	dc.b 2,	$70, $32, $B0, $48
SonPLC_Walk13:	dc.b 2,	$50, $54, $80, $5A
SonPLC_Walk14:	dc.b 4,	$50, $54, $50, $63, $50, $69, $10, $6F
SonPLC_Walk15:	dc.b 2,	$50, $54, $B0, $71
SonPLC_Walk16:	dc.b 3,	$70, $32, $30, $7D, $50, $81
SonPLC_Walk21:	dc.b 5,	$50, $87, $50, $8D, $20, $93, $50, $96,	0, $9C
SonPLC_Walk22:	dc.b 6,	$50, $87, $10, $9D, $30, $9F, $50, $A3,	$30, $A9, 0, $AD
SonPLC_Walk23:	dc.b 4,	$50, $AE, $10, $B4, $70, $B6, $20, $BE
SonPLC_Walk24:	dc.b 5,	$50, $C1, $30, $C7, $70, $CB, $20, $D3,	$10, $D6
SonPLC_Walk25:	dc.b 4,	$50, $C1, $10, $D8, $70, $DA, $20, $E2
SonPLC_Walk26:	dc.b 5,	$50, $87, $10, $9D, 0, $93, $70, $E5, $20, $ED
SonPLC_Walk31:	dc.b 4,	$70, $F0, $50, $F8, $10, $FE, $51, 0
SonPLC_Walk32:	dc.b 2,	$70, $F0, $B1, 6
SonPLC_Walk33:	dc.b 2,	$51, $12, $81, $18
SonPLC_Walk34:	dc.b 4,	$51, $12, $51, $21, $11, $27, $51, $29
SonPLC_Walk35:	dc.b 2,	$51, $12, $B1, $2F
SonPLC_Walk36:	dc.b 3,	$70, $F0, 1, 6,	$81, $3B
SonPLC_Walk41:	dc.b 6,	$51, $44, $11, $4A, $11, $4C, $81, $4E,	1, $57,	1, $58
SonPLC_Walk42:	dc.b 6,	$51, $44, $21, $59, $11, $5C, $11, $5E,	$81, $60, 1, $57
SonPLC_Walk43:	dc.b 4,	$51, $69, $11, $6F, $81, $71, $11, $7A
SonPLC_Walk44:	dc.b 5,	$51, $7C, $21, $82, $11, $85, $71, $87,	$21, $8F
SonPLC_Walk45:	dc.b 4,	$51, $7C, $11, $92, $81, $94, $11, $9D
SonPLC_Walk46:	dc.b 5,	$51, $44, $81, $9F, $11, $5E, $11, $A8,	1, $57
SonPLC_Run11:	dc.b 2,	$51, $AA, $B1, $B0
SonPLC_Run12:	dc.b 2,	$50, $54, $B1, $BC
SonPLC_Run13:	dc.b 2,	$51, $AA, $B1, $C8
SonPLC_Run14:	dc.b 2,	$50, $54, $B1, $D4
SonPLC_Run21:	dc.b 4,	$51, $E0, $11, $E6, $B1, $E8, 1, $F4
SonPLC_Run22:	dc.b 3,	$51, $F5, $11, $FB, $B1, $FD
SonPLC_Run23:	dc.b 4,	$51, $E0, $12, 9, $B2, $B, 1, $F4
SonPLC_Run24:	dc.b 3,	$51, $F5, $11, $FB, $B2, $17
SonPLC_Run31:	dc.b 2,	$52, $23, $B2, $29
SonPLC_Run32:	dc.b 2,	$51, $12, $B2, $35
SonPLC_Run33:	dc.b 2,	$52, $23, $B2, $41
SonPLC_Run34:	dc.b 2,	$51, $12, $B2, $4D
SonPLC_Run41:	dc.b 4,	$52, $59, $12, $5F, $B2, $61, 2, $6D
SonPLC_Run42:	dc.b 2,	$72, $6E, $B2, $76
SonPLC_Run43:	dc.b 4,	$52, $59, $12, $82, $B2, $84, 2, $6D
SonPLC_Run44:	dc.b 2,	$72, $6E, $B2, $90
SonPLC_Roll1:	dc.b 1,	$F2, $9C
SonPLC_Roll2:	dc.b 1,	$F2, $AC
SonPLC_Roll3:	dc.b 1,	$F2, $BC
SonPLC_Roll4:	dc.b 1,	$F2, $CC
SonPLC_Roll5:	dc.b 1,	$F2, $DC
SonPLC_Warp1:	dc.b 2,	$B2, $EC, $22, $F8
SonPLC_Warp2:	dc.b 1,	$F2, $FB
SonPLC_Warp3:	dc.b 2,	$B3, $B, $23, $17
SonPLC_Warp4:	dc.b 1,	$F3, $1A
SonPLC_Stop1:	dc.b 2,	$53, $2A, $B3, $30
SonPLC_Stop2:	dc.b 4,	$53, $3C, $73, $42, $13, $4A, 3, $4C
SonPLC_Duck:	dc.b 4,	$13, $4D, $73, $4F, $23, $57, 3, $5A
SonPLC_Balance1:dc.b 3,	$23, $5B, $23, $5E, $F3, $61
SonPLC_Balance2:dc.b 3,	$B3, $71, $73, $7D, 0, $71
SonPLC_Float1:	dc.b 3,	$73, $85, $33, $8D, $23, $91
SonPLC_Float2:	dc.b 1,	$83, $94
SonPLC_Float3:	dc.b 3,	$73, $9D, 3, $A5, $33, $A6
SonPLC_Float4:	dc.b 3,	$73, $AA, $33, $B2, $23, $B6
SonPLC_Spring:	dc.b 3,	$B3, $B9, $13, $C5, 3, $C7
SonPLC_Hang1:	dc.b 4,	$B3, $C8, $33, $D4, 3, $D8, 3, $D9
SonPLC_Hang2:	dc.b 4,	$B3, $DA, $33, $E6, 3, $EA, 3, $EB
SonPLC_Leap1:	dc.b 5,	$83, $EC, $13, $F5, $53, $F7, $13, $FD,	3, $FF
SonPLC_Leap2:	dc.b 5,	$84, 0,	$14, 9,	$53, $F7, $13, $FD, 3, $FF
SonPLC_Push1:	dc.b 2,	$84, $B, $74, $14
SonPLC_Push2:	dc.b 3,	$84, $1C, $24, $25, $14, $28
SonPLC_Push3:	dc.b 2,	$84, $2A, $74, $33
SonPLC_Push4:	dc.b 3,	$84, $1C, $24, $3B, $14, $3E
SonPLC_Surf:	dc.b 2,	$54, $40, $B4, $46
SonPLC_BubStand:dc.b 3,	$84, $52, $34, $5B, 4, $5F
SonPLC_Death:	dc.b 3,	$74, $60, $14, $68, $B4, $6A
SonPLC_Drown:	dc.b 5,	$74, $76, $14, $7E, $54, $80, $34, $86,	4, $8A
SonPLC_Burnt:	dc.b 5,	$74, $8B, $14, $7E, $54, $93, $34, $86,	4, $8A
SonPLC_Shrink1:	dc.b 2,	$24, $99, $F4, $9C
SonPLC_Shrink2:	dc.b 3,	$24, $AC, $B4, $AF, $24, $BB
SonPLC_Shrink3:	dc.b 1,	$B4, $BE
SonPLC_Shrink4:	dc.b 1,	$54, $CA
SonPLC_Shrink5:	dc.b 1,	$14, $D0
SonPLC_Injury:	dc.b 3,	$B4, $D2, $14, $DE, $34, $E0
SonPLC_GetAir:	dc.b 3,	$54, $E4, $B4, $EA, $10, $6D
SonPLC_WaterSlide:dc.b 2, $F4, $F6, $25, 6
		even