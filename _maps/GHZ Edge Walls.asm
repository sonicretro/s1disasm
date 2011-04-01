; ---------------------------------------------------------------------------
; Sprite mappings - walls (GHZ)
; ---------------------------------------------------------------------------
Map_Edge:	dc.w M_Edge_Shadow-Map_Edge
		dc.w M_Edge_Light-Map_Edge
		dc.w M_Edge_Dark-Map_Edge
M_Edge_Shadow:	dc.b 4
		dc.b $E0, 5, 0,	4, $F8	; light with shadow
		dc.b $F0, 5, 0,	8, $F8
		dc.b 0,	5, 0, 8, $F8
		dc.b $10, 5, 0,	8, $F8
M_Edge_Light:	dc.b 4
		dc.b $E0, 5, 0,	8, $F8	; light with no shadow
		dc.b $F0, 5, 0,	8, $F8
		dc.b 0,	5, 0, 8, $F8
		dc.b $10, 5, 0,	8, $F8
M_Edge_Dark:	dc.b 4
		dc.b $E0, 5, 0,	0, $F8	; all shadow
		dc.b $F0, 5, 0,	0, $F8
		dc.b 0,	5, 0, 0, $F8
		dc.b $10, 5, 0,	0, $F8
		even