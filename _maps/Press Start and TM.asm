; ---------------------------------------------------------------------------
; Sprite mappings - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------
Map_PSB:	dc.w byte_A7CD-Map_PSB
		dc.w M_PSB_PSB-Map_PSB
		dc.w M_PSB_Limiter-Map_PSB
		dc.w M_PSB_TM-Map_PSB
M_PSB_PSB:	dc.b 6			; "PRESS START BUTTON"
byte_A7CD:	dc.b 0,	$C, 0, $F0, 0
		dc.b 0,	0, 0, $F3, $20
		dc.b 0,	0, 0, $F3, $30
		dc.b 0,	$C, 0, $F4, $38
		dc.b 0,	8, 0, $F8, $60
		dc.b 0,	8, 0, $FB, $78
M_PSB_Limiter:	dc.b $1E		; sprite line limiter
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $B8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $D8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
		dc.b $F8, $F, 0, 0, $80
M_PSB_TM:	dc.b 1			; "TM"
		dc.b $FC, 4, 0,	0, $F8
		even