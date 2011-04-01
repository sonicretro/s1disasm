; ---------------------------------------------------------------------------
; Sprite mappings - helix of spikes on a pole (GHZ)
; ---------------------------------------------------------------------------
Map_Hel:	dc.w byte_7E08-Map_Hel, byte_7E0E-Map_Hel
		dc.w byte_7E14-Map_Hel, byte_7E1A-Map_Hel
		dc.w byte_7E20-Map_Hel, byte_7E26-Map_Hel
		dc.w byte_7E2D+2-Map_Hel, byte_7E2C-Map_Hel
byte_7E08:	dc.b 1
		dc.b $F0, 1, 0,	0, $FC	; points straight up (harmful)
byte_7E0E:	dc.b 1
		dc.b $F5, 5, 0,	2, $F8	; 45 degree
byte_7E14:	dc.b 1
		dc.b $F8, 5, 0,	6, $F8	; 90 degree
byte_7E1A:	dc.b 1
		dc.b $FB, 5, 0,	$A, $F8	; 45 degree
byte_7E20:	dc.b 1
		dc.b 0,	1, 0, $E, $FC	; straight down
byte_7E26:	dc.b 1
		dc.b 4,	0, 0, $10, $FD	; 45 degree
byte_7E2D:	; reads the 0 below	; not visible
byte_7E2C:	dc.b 1
		dc.b $F4, 0, 0,	$11, $FD ; 45 degree
		even