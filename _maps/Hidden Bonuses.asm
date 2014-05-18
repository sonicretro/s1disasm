; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of	a level
; ---------------------------------------------------------------------------
Map_Bonus:	dc.w .blank-Map_Bonus, ._10000-Map_Bonus
		dc.w ._1000-Map_Bonus, ._100-Map_Bonus
.blank:		dc.b 0
._10000:		dc.b 1
		dc.b $F4, $E, 0, 0, $F0
._1000:		dc.b 1
		dc.b $F4, $E, 0, $C, $F0
._100:		dc.b 1
		dc.b $F4, $E, 0, $18, $F0
		even