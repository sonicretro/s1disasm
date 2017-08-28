; ---------------------------------------------------------------------------
; Sprite mappings - swinging ball on a chain from GHZ boss
; ---------------------------------------------------------------------------
Map_GBall_internal:
		dc.w .shiny-Map_GBall_internal
		dc.w .check1-Map_GBall_internal
		dc.w .check2-Map_GBall_internal
		dc.w .check3-Map_GBall_internal
.shiny:		dc.b 6
		dc.b $F0, 4, 0,	$24, $F0
		dc.b $F8, 4, $10, $24, $F0
		dc.b $E8, $A, 0, 0, $E8
		dc.b $E8, $A, 8, 0, 0
		dc.b 0,	$A, $10, 0, $E8
		dc.b 0,	$A, $18, 0, 0
.check1:	dc.b 4
		dc.b $E8, $A, 0, 9, $E8
		dc.b $E8, $A, 8, 9, 0
		dc.b 0,	$A, $10, 9, $E8
		dc.b 0,	$A, $18, 9, 0
.check2:	dc.b 4
		dc.b $E8, $A, 0, $12, $E8
		dc.b $E8, $A, 0, $1B, 0
		dc.b 0,	$A, $18, $1B, $E8
		dc.b 0,	$A, $18, $12, 0
.check3:	dc.b 4
		dc.b $E8, $A, 8, $1B, $E8
		dc.b $E8, $A, 8, $12, 0
		dc.b 0,	$A, $10, $12, $E8
		dc.b 0,	$A, $10, $1B, 0
		even