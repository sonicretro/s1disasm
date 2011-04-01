; ---------------------------------------------------------------------------
; Sprite mappings - Eggman (SBZ2)
; ---------------------------------------------------------------------------
Map_SEgg:	dc.w @stand-Map_SEgg, @laugh1-Map_SEgg
		dc.w @laugh2-Map_SEgg, @jump1-Map_SEgg
		dc.w @jump2-Map_SEgg, @surprise-Map_SEgg
		dc.w @starjump-Map_SEgg, @running1-Map_SEgg
		dc.w @running2-Map_SEgg, @intube-Map_SEgg
		dc.w @cockpit-Map_SEgg
@stand:		dc.b 3
		dc.b $FC, 0, 0,	$8F, $E8
		dc.b $E8, $E, 0, 0, $F0
		dc.b 0,	$F, 0, $6F, $F0
@laugh1:	dc.b 4
		dc.b $E8, $D, 0, $E, $F0
		dc.b $E8, $E, 0, 0, $F0
		dc.b 0,	$F, 0, $6F, $F0
		dc.b $FC, 0, 0,	$8F, $E8
		dc.b 0
@laugh2:	dc.b 4
		dc.b $E9, $D, 0, $E, $F0
		dc.b $E9, $E, 0, 0, $F0
		dc.b 1,	$F, 0, $7F, $F0
		dc.b $FD, 0, 0,	$8F, $E8
		dc.b 0
@jump1:		dc.b 4
		dc.b $F4, $F, 8, $20, $F0
		dc.b $F5, 4, 8,	$30, $10
		dc.b 8,	9, 8, $4E, $F0
		dc.b $EC, $E, 0, 0, $F0
		dc.b 0
@jump2:		dc.b 4
		dc.b $F0, $F, 8, $20, $F0
		dc.b $F1, 4, 8,	$30, $10
		dc.b 8,	6, 8, $3E, $F8
		dc.b $E8, $E, 0, 0, $F0
		dc.b 0
@surprise:	dc.b 4
		dc.b $E8, $D, 0, $16, $EC
		dc.b $E8, 1, 0,	$1E, $C
		dc.b $E8, $E, 0, 0, $F0
		dc.b 0,	$F, 0, $6F, $F0
		dc.b 0
@starjump:	dc.b 7
		dc.b $E8, $D, 0, $16, $EC
		dc.b $E8, 1, 0,	$1E, $C
		dc.b 4,	9, 8, $34, 0
		dc.b 4,	5, 8, $3A, $E8
		dc.b $F0, $F, 8, $20, $F0
		dc.b $F1, 4, 8,	$54, $10
		dc.b $F1, 4, 0,	$54, $E0
@running1:	dc.b 5
		dc.b $F0, $F, 8, $20, $F0
		dc.b $F1, 4, 8,	$30, $10
		dc.b 4,	9, 8, $34, 0
		dc.b 4,	5, 8, $3A, $E8
		dc.b $E8, $E, 0, 0, $F0
@running2:	dc.b 6
		dc.b $EE, $F, 8, $20, $F0
		dc.b $EF, 4, 8,	$30, $10
		dc.b 9,	5, 8, $44, 0
		dc.b 3,	1, 8, $48, $F8
		dc.b $B, 5, 8, $4A, $E8
		dc.b $E6, $E, 0, 0, $F0
		dc.b 0
@intube:	dc.b 8
		dc.b $E8, $D, 0, $16, $EC ; Eggman inside tube in Final Zone
		dc.b $E8, 1, 0,	$1E, $C
		dc.b $E8, $E, 0, 0, $F0
		dc.b 0,	$F, 0, $6F, $F0
		dc.b $E0, $D, $3E, $F0,	$F0
		dc.b $F0, $D, $3E, $F0,	$F0
		dc.b 0,	$D, $3E, $F0, $F0
		dc.b $10, $D, $3E, $F0,	$F0
@cockpit:	dc.b 3
		dc.b $EC, $D, 0, $56, $E4 ; empty cockpit of Eggmobile in Final Zone
		dc.b $F4, 8, 0,	$5E, 4
		dc.b $EC, $D, 0, $61, $FC
		even