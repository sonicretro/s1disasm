; ---------------------------------------------------------------------------
; Sprite mappings - shield and invincibility stars
; ---------------------------------------------------------------------------
Map_Shield_internal:
		dc.w .shield1-Map_Shield_internal
		dc.w .shield2-Map_Shield_internal
		dc.w .shield3-Map_Shield_internal
		dc.w .shield4-Map_Shield_internal
		dc.w .stars1-Map_Shield_internal
		dc.w .stars2-Map_Shield_internal
		dc.w .stars3-Map_Shield_internal
		dc.w .stars4-Map_Shield_internal
.shield2:	dc.b 4
		dc.b $E8, $A, 0, 0, $E8
		dc.b $E8, $A, 0, 9, 0
.shield1:	dc.b 0,	$A, $10, 0, $E8
		dc.b 0,	$A, $10, 9, 0
.shield3:	dc.b 4
		dc.b $E8, $A, 8, $12, $E9
		dc.b $E8, $A, 0, $12, 0
		dc.b 0,	$A, $18, $12, $E9
		dc.b 0,	$A, $10, $12, 0
.shield4:	dc.b 4
		dc.b $E8, $A, 8, 9, $E8
		dc.b $E8, $A, 8, 0, 0
		dc.b 0,	$A, $18, 9, $E8
		dc.b 0,	$A, $18, 0, 0
.stars1:	dc.b 4
		dc.b $E8, $A, 0, 0, $E8
		dc.b $E8, $A, 0, 9, 0
		dc.b 0,	$A, $18, 9, $E8
		dc.b 0,	$A, $18, 0, 0
.stars2:	dc.b 4
		dc.b $E8, $A, 8, 9, $E8
		dc.b $E8, $A, 8, 0, 0
		dc.b 0,	$A, $10, 0, $E8
		dc.b 0,	$A, $10, 9, 0
.stars3:	dc.b 4
		dc.b $E8, $A, 0, $12, $E8
		dc.b $E8, $A, 0, $1B, 0
		dc.b 0,	$A, $18, $1B, $E8
		dc.b 0,	$A, $18, $12, 0
.stars4:	dc.b 4
		dc.b $E8, $A, 8, $1B, $E8
		dc.b $E8, $A, 8, $12, 0
		dc.b 0,	$A, $10, $12, $E8
		dc.b 0,	$A, $10, $1B, 0
		even