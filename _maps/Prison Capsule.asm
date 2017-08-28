; ---------------------------------------------------------------------------
; Sprite mappings - prison capsule
; ---------------------------------------------------------------------------
Map_Pri_internal:
		dc.w @capsule-Map_Pri_internal
		dc.w @switch1-Map_Pri_internal
		dc.w @broken-Map_Pri_internal
		dc.w @switch2-Map_Pri_internal
		dc.w @unusedthing1-Map_Pri_internal
		dc.w @unusedthing2-Map_Pri_internal
		dc.w @blank-Map_Pri_internal
@capsule:	dc.b 7
		dc.b $E0, $C, $20, 0, $F0
		dc.b $E8, $D, $20, 4, $E0
		dc.b $E8, $D, $20, $C, 0
		dc.b $F8, $E, $20, $14,	$E0
		dc.b $F8, $E, $20, $20,	0
		dc.b $10, $D, $20, $2C,	$E0
		dc.b $10, $D, $20, $34,	0
@switch1:	dc.b 1
		dc.b $F8, 9, 0,	$3C, $F4
@broken:	dc.b 6
		dc.b 0,	8, $20,	$42, $E0
		dc.b 8,	$C, $20, $45, $E0
		dc.b 0,	4, $20,	$49, $10
		dc.b 8,	$C, $20, $4B, 0
		dc.b $10, $D, $20, $2C,	$E0
		dc.b $10, $D, $20, $34,	0
@switch2:	dc.b 1
		dc.b $F8, 9, 0,	$4F, $F4
@unusedthing1:	dc.b 2
		dc.b $E8, $E, $20, $55,	$F0
		dc.b 0,	$E, $20, $61, $F0
@unusedthing2:	dc.b 1
		dc.b $F0, 7, $20, $6D, $F8
@blank:		dc.b 0
		even