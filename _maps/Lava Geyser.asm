; ---------------------------------------------------------------------------
; Sprite mappings - lava geyser / lava that falls from the ceiling (MZ)
; ---------------------------------------------------------------------------
Map_Geyser:	dc.w @bubble1-Map_Geyser, @bubble2-Map_Geyser
		dc.w @bubble3-Map_Geyser, @bubble4-Map_Geyser
		dc.w @bubble5-Map_Geyser, @bubble6-Map_Geyser
		dc.w @end1-Map_Geyser, @end2-Map_Geyser
		dc.w @medcolumn1-Map_Geyser, @medcolumn2-Map_Geyser
		dc.w @medcolumn3-Map_Geyser, @shortcolumn1-Map_Geyser
		dc.w @shortcolumn2-Map_Geyser, @shortcolumn3-Map_Geyser
		dc.w @longcolumn1-Map_Geyser, @longcolumn2-Map_Geyser
		dc.w @longcolumn3-Map_Geyser, @bubble7-Map_Geyser
		dc.w @bubble8-Map_Geyser, @blank-Map_Geyser
@bubble1:	dc.b 2
		dc.b $EC, $B, 0, 0, $E8
		dc.b $EC, $B, 8, 0, 0
@bubble2:	dc.b 2
		dc.b $EC, $B, 0, $18, $E8
		dc.b $EC, $B, 8, $18, 0
@bubble3:	dc.b 4
		dc.b $EC, $B, 0, 0, $C8
		dc.b $F4, $E, 0, $C, $E0
		dc.b $F4, $E, 8, $C, 0
		dc.b $EC, $B, 8, 0, $20
@bubble4:	dc.b 4
		dc.b $EC, $B, 0, $18, $C8
		dc.b $F4, $E, 0, $24, $E0
		dc.b $F4, $E, 8, $24, 0
		dc.b $EC, $B, 8, $18, $20
@bubble5:	dc.b 6
		dc.b $EC, $B, 0, 0, $C8
		dc.b $F4, $E, 0, $C, $E0
		dc.b $F4, $E, 8, $C, 0
		dc.b $EC, $B, 8, 0, $20
		dc.b $E8, $E, 0, $90, $E0
		dc.b $E8, $E, 8, $90, 0
@bubble6:	dc.b 6
		dc.b $EC, $B, 0, $18, $C8
		dc.b $F4, $E, 0, $24, $E0
		dc.b $F4, $E, 8, $24, 0
		dc.b $EC, $B, 8, $18, $20
		dc.b $E8, $E, 8, $90, $E0
		dc.b $E8, $E, 0, $90, 0
@end1:		dc.b 2
		dc.b $E0, $F, 0, $30, $E0
		dc.b $E0, $F, 8, $30, 0
@end2:		dc.b 2
		dc.b $E0, $F, 8, $30, $E0
		dc.b $E0, $F, 0, $30, 0
@medcolumn1:	dc.b $A
		dc.b $90, $F, 0, $40, $E0
		dc.b $90, $F, 8, $40, 0
		dc.b $B0, $F, 0, $40, $E0
		dc.b $B0, $F, 8, $40, 0
		dc.b $D0, $F, 0, $40, $E0
		dc.b $D0, $F, 8, $40, 0
		dc.b $F0, $F, 0, $40, $E0
		dc.b $F0, $F, 8, $40, 0
		dc.b $10, $F, 0, $40, $E0
		dc.b $10, $F, 8, $40, 0
@medcolumn2:	dc.b $A
		dc.b $90, $F, 0, $50, $E0
		dc.b $90, $F, 8, $50, 0
		dc.b $B0, $F, 0, $50, $E0
		dc.b $B0, $F, 8, $50, 0
		dc.b $D0, $F, 0, $50, $E0
		dc.b $D0, $F, 8, $50, 0
		dc.b $F0, $F, 0, $50, $E0
		dc.b $F0, $F, 8, $50, 0
		dc.b $10, $F, 0, $50, $E0
		dc.b $10, $F, 8, $50, 0
@medcolumn3:	dc.b $A
		dc.b $90, $F, 0, $60, $E0
		dc.b $90, $F, 8, $60, 0
		dc.b $B0, $F, 0, $60, $E0
		dc.b $B0, $F, 8, $60, 0
		dc.b $D0, $F, 0, $60, $E0
		dc.b $D0, $F, 8, $60, 0
		dc.b $F0, $F, 0, $60, $E0
		dc.b $F0, $F, 8, $60, 0
		dc.b $10, $F, 0, $60, $E0
		dc.b $10, $F, 8, $60, 0
@shortcolumn1:	dc.b 6
		dc.b $90, $F, 0, $40, $E0
		dc.b $90, $F, 8, $40, 0
		dc.b $B0, $F, 0, $40, $E0
		dc.b $B0, $F, 8, $40, 0
		dc.b $D0, $F, 0, $40, $E0
		dc.b $D0, $F, 8, $40, 0
@shortcolumn2:	dc.b 6
		dc.b $90, $F, 0, $50, $E0
		dc.b $90, $F, 8, $50, 0
		dc.b $B0, $F, 0, $50, $E0
		dc.b $B0, $F, 8, $50, 0
		dc.b $D0, $F, 0, $50, $E0
		dc.b $D0, $F, 8, $50, 0
@shortcolumn3:	dc.b 6
		dc.b $90, $F, 0, $60, $E0
		dc.b $90, $F, 8, $60, 0
		dc.b $B0, $F, 0, $60, $E0
		dc.b $B0, $F, 8, $60, 0
		dc.b $D0, $F, 0, $60, $E0
		dc.b $D0, $F, 8, $60, 0
@longcolumn1:	dc.b $10
		dc.b $90, $F, 0, $40, $E0
		dc.b $90, $F, 8, $40, 0
		dc.b $B0, $F, 0, $40, $E0
		dc.b $B0, $F, 8, $40, 0
		dc.b $D0, $F, 0, $40, $E0
		dc.b $D0, $F, 8, $40, 0
		dc.b $F0, $F, 0, $40, $E0
		dc.b $F0, $F, 8, $40, 0
		dc.b $10, $F, 0, $40, $E0
		dc.b $10, $F, 8, $40, 0
		dc.b $30, $F, 0, $40, $E0
		dc.b $30, $F, 8, $40, 0
		dc.b $50, $F, 0, $40, $E0
		dc.b $50, $F, 8, $40, 0
		dc.b $70, $F, 0, $40, $E0
		dc.b $70, $F, 8, $40, 0
@longcolumn2:	dc.b $10
		dc.b $90, $F, 0, $50, $E0
		dc.b $90, $F, 8, $50, 0
		dc.b $B0, $F, 0, $50, $E0
		dc.b $B0, $F, 8, $50, 0
		dc.b $D0, $F, 0, $50, $E0
		dc.b $D0, $F, 8, $50, 0
		dc.b $F0, $F, 0, $50, $E0
		dc.b $F0, $F, 8, $50, 0
		dc.b $10, $F, 0, $50, $E0
		dc.b $10, $F, 8, $50, 0
		dc.b $30, $F, 0, $50, $E0
		dc.b $30, $F, 8, $50, 0
		dc.b $50, $F, 0, $50, $E0
		dc.b $50, $F, 8, $50, 0
		dc.b $70, $F, 0, $50, $E0
		dc.b $70, $F, 8, $50, 0
@longcolumn3:	dc.b $10
		dc.b $90, $F, 0, $60, $E0
		dc.b $90, $F, 8, $60, 0
		dc.b $B0, $F, 0, $60, $E0
		dc.b $B0, $F, 8, $60, 0
		dc.b $D0, $F, 0, $60, $E0
		dc.b $D0, $F, 8, $60, 0
		dc.b $F0, $F, 0, $60, $E0
		dc.b $F0, $F, 8, $60, 0
		dc.b $10, $F, 0, $60, $E0
		dc.b $10, $F, 8, $60, 0
		dc.b $30, $F, 0, $60, $E0
		dc.b $30, $F, 8, $60, 0
		dc.b $50, $F, 0, $60, $E0
		dc.b $50, $F, 8, $60, 0
		dc.b $70, $F, 0, $60, $E0
		dc.b $70, $F, 8, $60, 0
@bubble7:	dc.b 6
		dc.b $E0, $B, 0, 0, $C8
		dc.b $E8, $E, 0, $C, $E0
		dc.b $E8, $E, 8, $C, 0
		dc.b $E0, $B, 8, 0, $20
		dc.b $D8, $E, 0, $90, $E0
		dc.b $D8, $E, 8, $90, 0
@bubble8:	dc.b 6
		dc.b $E0, $B, 0, $18, $C8
		dc.b $E8, $E, 0, $24, $E0
		dc.b $E8, $E, 8, $24, 0
		dc.b $E0, $B, 8, $18, $20
		dc.b $D8, $E, 8, $90, $E0
		dc.b $D8, $E, 0, $90, 0
@blank:	dc.b 0
		even