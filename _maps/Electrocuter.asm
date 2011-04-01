; ---------------------------------------------------------------------------
; Sprite mappings - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------
Map_Elec:	dc.w @normal-Map_Elec, @zap1-Map_Elec
		dc.w @zap2-Map_Elec, @zap3-Map_Elec
		dc.w @zap4-Map_Elec, @zap5-Map_Elec
@normal:	dc.b 2
		dc.b $F8, 4, $60, 0, $F8
		dc.b 0,	6, $40,	2, $F8
@zap1:		dc.b 3
		dc.b $F8, 5, 0,	8, $F8
		dc.b $F8, 4, $60, 0, $F8
		dc.b 0,	6, $40,	2, $F8
@zap2:		dc.b 5
		dc.b $F8, 5, 0,	8, $F8
		dc.b $F8, 4, $60, 0, $F8
		dc.b 0,	6, $40,	2, $F8
		dc.b $F6, $D, 0, $C, 8
		dc.b $F6, $D, 8, $C, $DC
@zap3:		dc.b 4
		dc.b $F8, 4, $60, 0, $F8
		dc.b 0,	6, $40,	2, $F8
		dc.b $F6, $D, 0, $C, 8
		dc.b $F6, $D, 8, $C, $DC
@zap4:		dc.b 6
		dc.b $F8, 4, $60, 0, $F8
		dc.b 0,	6, $40,	2, $F8
		dc.b $F6, $D, $10, $C, 8
		dc.b $F6, $D, $18, $C, $DC
		dc.b $F6, $D, 0, $C, $24
		dc.b $F6, $D, 8, $C, $C0
@zap5:		dc.b 4
		dc.b $F8, 4, $60, 0, $F8
		dc.b 0,	6, $40,	2, $F8
		dc.b $F6, $D, $10, $C, $24
		dc.b $F6, $D, $18, $C, $C0
		even