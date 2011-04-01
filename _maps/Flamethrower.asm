; ---------------------------------------------------------------------------
; Sprite mappings - flame thrower (SBZ)
; ---------------------------------------------------------------------------
Map_Flame:	dc.w @pipe1-Map_Flame, @pipe2-Map_Flame
		dc.w @pipe3-Map_Flame, @pipe4-Map_Flame
		dc.w @pipe5-Map_Flame, @pipe6-Map_Flame
		dc.w @pipe7-Map_Flame, @pipe8-Map_Flame
		dc.w @pipe9-Map_Flame, @pipe10-Map_Flame
		dc.w @pipe11-Map_Flame, @valve1-Map_Flame
		dc.w @valve2-Map_Flame, @valve3-Map_Flame
		dc.w @valve4-Map_Flame, @valve5-Map_Flame
		dc.w @valve6-Map_Flame, @valve7-Map_Flame
		dc.w @valve8-Map_Flame, @valve9-Map_Flame
		dc.w @valve10-Map_Flame, @valve11-Map_Flame
@pipe1:		dc.b 1
		dc.b $28, 5, $40, $14, $FB ; broken pipe style flamethrower
@pipe2:		dc.b 2
		dc.b $20, 1, 0,	0, $FD
		dc.b $28, 5, $40, $14, $FB
@pipe3:		dc.b 2
		dc.b $20, 1, 8,	0, $FC
		dc.b $28, 5, $40, $14, $FB
@pipe4:		dc.b 3
		dc.b $10, 6, 0,	2, $F8
		dc.b $20, 1, 0,	0, $FD
		dc.b $28, 5, $40, $14, $FB
@pipe5:		dc.b 3
		dc.b $10, 6, 8,	2, $F8
		dc.b $20, 1, 8,	0, $FC
		dc.b $28, 5, $40, $14, $FB
@pipe6:		dc.b 4
		dc.b 8,	6, 0, 2, $F8
		dc.b $10, 6, 0,	2, $F8
		dc.b $20, 1, 0,	0, $FD
		dc.b $28, 5, $40, $14, $FB
@pipe7:		dc.b 4
		dc.b 8,	6, 8, 2, $F8
		dc.b $10, 6, 8,	2, $F8
		dc.b $20, 1, 8,	0, $FC
		dc.b $28, 5, $40, $14, $FB
@pipe8:		dc.b 5
		dc.b $F8, $B, 0, 8, $F4
		dc.b 8,	6, 0, 2, $F8
		dc.b $10, 6, 0,	2, $F8
		dc.b $20, 1, 0,	0, $FD
		dc.b $28, 5, $40, $14, $FB
@pipe9:		dc.b 5
		dc.b $F8, $B, 8, 8, $F4
		dc.b 8,	6, 8, 2, $F8
		dc.b $10, 6, 8,	2, $F8
		dc.b $20, 1, 8,	0, $FC
		dc.b $28, 5, $40, $14, $FB
@pipe10:	dc.b 6
		dc.b $E8, $B, 0, 8, $F4
		dc.b $F7, $B, 0, 8, $F4
		dc.b 8,	6, 0, 2, $F8
		dc.b $F, 6, 0, 2, $F8
		dc.b $20, 1, 0,	0, $FD
		dc.b $28, 5, $40, $14, $FB
@pipe11:	dc.b 6
		dc.b $E7, $B, 8, 8, $F4
		dc.b $F8, $B, 8, 8, $F4
		dc.b 7,	6, 8, 2, $F8
		dc.b $10, 6, 8,	2, $F8
		dc.b $20, 1, 8,	0, $FC
		dc.b $28, 5, $40, $14, $FB
@valve1:	dc.b 1
		dc.b $28, 5, $40, $18, $F9 ; valve style flamethrower
@valve2:	dc.b 2
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 0,	0, $FD
@valve3:	dc.b 2
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 8,	0, $FC
@valve4:	dc.b 3
		dc.b $10, 6, 0,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 0,	0, $FD
@valve5:	dc.b 3
		dc.b $10, 6, 8,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 8,	0, $FC
@valve6:	dc.b 4
		dc.b 8,	6, 0, 2, $F8
		dc.b $10, 6, 0,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 0,	0, $FD
@valve7:	dc.b 4
		dc.b 8,	6, 8, 2, $F8
		dc.b $10, 6, 8,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 8,	0, $FC
@valve8:	dc.b 5
		dc.b $F8, $B, 0, 8, $F4
		dc.b 8,	6, 0, 2, $F8
		dc.b $10, 6, 0,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 0,	0, $FD
@valve9:	dc.b 5
		dc.b $F8, $B, 8, 8, $F4
		dc.b 8,	6, 8, 2, $F8
		dc.b $10, 6, 8,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 8,	0, $FC
@valve10:	dc.b 6
		dc.b $E8, $B, 0, 8, $F4
		dc.b $F7, $B, 0, 8, $F4
		dc.b 8,	6, 0, 2, $F8
		dc.b $F, 6, 0, 2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 0,	0, $FD
@valve11:	dc.b 6
		dc.b $E7, $B, 8, 8, $F4
		dc.b $F8, $B, 8, 8, $F4
		dc.b 7,	6, 8, 2, $F8
		dc.b $10, 6, 8,	2, $F8
		dc.b $28, 5, $40, $18, $F9
		dc.b $20, 1, 8,	0, $FC
		even