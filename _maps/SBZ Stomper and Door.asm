; ---------------------------------------------------------------------------
; Sprite mappings - stomper and	platforms (SBZ)
; ---------------------------------------------------------------------------
Map_Stomp:	dc.w @door-Map_Stomp, @stomper-Map_Stomp
		dc.w @stomper-Map_Stomp, @stomper-Map_Stomp
		dc.w @bigdoor-Map_Stomp
@door:		dc.b 4
		dc.b $F4, $E, $21, $AF,	$C0 ; horizontal sliding door
		dc.b $F4, $E, $21, $B2,	$E0
		dc.b $F4, $E, $21, $B2,	0
		dc.b $F4, $E, $29, $AF,	$20
@stomper:	dc.b 8
		dc.b $E0, $C, 0, $C, $E4 ; stomper block with yellow/black stripes
		dc.b $E0, 8, 0,	$10, 4
		dc.b $E8, $E, $20, $13,	$E4
		dc.b $E8, $A, $20, $1F,	4
		dc.b 0,	$E, $20, $13, $E4
		dc.b 0,	$A, $20, $1F, 4
		dc.b $18, $C, 0, $C, $E4
		dc.b $18, 8, 0,	$10, 4
@bigdoor:	dc.b $E
		dc.b $C0, $F, 0, 0, $80	; huge diagonal sliding door from SBZ3
		dc.b $C0, $F, 0, $10, $A0
		dc.b $C0, $F, 0, $20, $C0
		dc.b $C0, $F, 0, $10, $E0
		dc.b $C0, $F, 0, $20, 0
		dc.b $C0, $F, 0, $10, $20
		dc.b $C0, $F, 0, $30, $40
		dc.b $C0, $D, 0, $40, $60
		dc.b $E0, $F, 0, $48, $80
		dc.b $E0, $F, 0, $48, $C0
		dc.b $E0, $F, 0, $58, 0
		dc.b 0,	$F, 0, $48, $80
		dc.b 0,	$F, 0, $58, $C0
		dc.b $20, $F, 0, $58, $80
		even