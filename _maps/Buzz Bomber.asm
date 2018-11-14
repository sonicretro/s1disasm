; ---------------------------------------------------------------------------
; Sprite mappings - Buzz Bomber	enemy
; ---------------------------------------------------------------------------
Map_Buzz_internal:
		dc.w @Fly1-Map_Buzz_internal
		dc.w @Fly2-Map_Buzz_internal
		dc.w @Fly3-Map_Buzz_internal
		dc.w @Fly4-Map_Buzz_internal
		dc.w @Fire1-Map_Buzz_internal
		dc.w @Fire2-Map_Buzz_internal
@Fly1:		dc.b 6
		dc.b $F4, 9, 0,	0, $E8	; flying
		dc.b $F4, 9, 0,	$F, 0
		dc.b 4,	8, 0, $15, $E8
		dc.b 4,	4, 0, $18, 0
		dc.b $F1, 8, 0,	$1A, $EC
		dc.b $F1, 4, 0,	$1D, 4
@Fly2:		dc.b 6
		dc.b $F4, 9, 0,	0, $E8
		dc.b $F4, 9, 0,	$F, 0
		dc.b 4,	8, 0, $15, $E8
		dc.b 4,	4, 0, $18, 0
		dc.b $F4, 8, 0,	$1F, $EC
		dc.b $F4, 4, 0,	$22, 4
@Fly3:		dc.b 7
		dc.b 4,	0, 0, $30, $C
		dc.b $F4, 9, 0,	0, $E8
		dc.b $F4, 9, 0,	$F, 0
		dc.b 4,	8, 0, $15, $E8
		dc.b 4,	4, 0, $18, 0
		dc.b $F1, 8, 0,	$1A, $EC
		dc.b $F1, 4, 0,	$1D, 4
@Fly4:		dc.b 7
		dc.b 4,	4, 0, $31, $C
		dc.b $F4, 9, 0,	0, $E8
		dc.b $F4, 9, 0,	$F, 0
		dc.b 4,	8, 0, $15, $E8
		dc.b 4,	4, 0, $18, 0
		dc.b $F4, 8, 0,	$1F, $EC
		dc.b $F4, 4, 0,	$22, 4
@Fire1:		dc.b 6
		dc.b $F4, $D, 0, 0, $EC	; stopping and firing
		dc.b 4,	$C, 0, 8, $EC
		dc.b 4,	0, 0, $C, $C
		dc.b $C, 4, 0, $D, $F4
		dc.b $F1, 8, 0,	$1A, $EC
		dc.b $F1, 4, 0,	$1D, 4
@Fire2:		dc.b 4
		dc.b $F4, $D, 0, 0, $EC
		dc.b 4,	$C, 0, 8, $EC
		dc.b 4,	0, 0, $C, $C
		dc.b $C, 4, 0, $D, $F4
		dc.b $F4, 8, 0,	$1F, $EC
		dc.b $F4, 4, 0,	$22, 4
		even