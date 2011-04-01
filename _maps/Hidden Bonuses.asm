; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of	a level
; ---------------------------------------------------------------------------
Map_Bonus:	dc.w @blank-Map_Bonus, @10000-Map_Bonus
		dc.w @1000-Map_Bonus, @100-Map_Bonus
@blank:		dc.b 0
@10000:		dc.b 1
		dc.b $F4, $E, 0, 0, $F0
@1000:		dc.b 1
		dc.b $F4, $E, 0, $C, $F0
@100:		dc.b 1
		dc.b $F4, $E, 0, $18, $F0
		even