; ---------------------------------------------------------------------------
; Sprite mappings - water splash (LZ)
; ---------------------------------------------------------------------------
Map_Splash:	dc.w @splash1-Map_Splash
		dc.w @splash2-Map_Splash
		dc.w @splash3-Map_Splash
@splash1:	dc.b 2
		dc.b $F2, 4, 0,	$6D, $F8
		dc.b $FA, $C, 0, $6F, $F0
@splash2:	dc.b 2
		dc.b $E2, 0, 0,	$73, $F8
		dc.b $EA, $E, 0, $74, $F0
@splash3:	dc.b 1
		dc.b $E2, $F, 0, $80, $F0
		even