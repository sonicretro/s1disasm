; ---------------------------------------------------------------------------
; Sprite mappings - Sonic on the ending	sequence
; ---------------------------------------------------------------------------
Map_ESon:	dc.w M_ESon_Hold1-Map_ESon, M_ESon_Hold2-Map_ESon
		dc.w M_ESon_Up-Map_ESon, M_ESon_Conf1-Map_ESon
		dc.w M_ESon_Conf2-Map_ESon, M_ESon_Leap1-Map_ESon
		dc.w M_ESon_Leap2-Map_ESon, M_ESon_Leap3-Map_ESon
M_ESon_Hold1:	dc.b 2
		dc.b $EC, $B, 0, 0, $F8	; holding emeralds
		dc.b $C, $C, 0,	$C, $F0
M_ESon_Hold2:	dc.b 3
		dc.b $FC, $D, 0, $10, $F0 ; holding emeralds (glowing)
		dc.b $EC, $B, 0, 0, $F8
		dc.b $C, $C, 0,	$C, $F0
M_ESon_Up:	dc.b 2
		dc.b $EC, 9, 0,	$18, $F8 ; looking up
		dc.b $FC, $E, 0, $1E, $F0
M_ESon_Conf1:	dc.b 2
		dc.b $EC, 9, 0,	$2A, $F8 ; confused
		dc.b $FC, $E, 0, $30, $F0
M_ESon_Conf2:	dc.b 2
		dc.b $EC, 9, 8,	$2A, $F0 ; confused #2
		dc.b $FC, $E, 8, $30, $F0
M_ESon_Leap1:	dc.b 3
		dc.b $EC, 6, 0,	$3C, $F0 ; leaping
		dc.b $EC, 6, 8,	$3C, 0
		dc.b 4,	$D, 0, $42, $F0
M_ESon_Leap2:	dc.b 7
		dc.b $B2, $C, 0, $4A, $F8 ; leaping #2
		dc.b $BA, $F, 0, $4E, $F0
		dc.b $BA, 5, 0,	$5E, $10
		dc.b $CA, 2, 0,	$62, $10
		dc.b $DA, $C, 0, $65, $F0
		dc.b $E2, 8, 0,	$69, $F8
		dc.b $EA, 5, 0,	$6C, $F8
M_ESon_Leap3:	dc.b $18
		dc.b $80, $F, 0, $70, $F8 ; leaping #3
		dc.b $90, $B, 0, $80, $E0
		dc.b $90, $B, 0, $8C, $18
		dc.b $98, $B, 0, $98, $30
		dc.b $A0, $F, 0, $A4, $58
		dc.b $88, 0, 0,	$B4, $F0
		dc.b $80, 5, 0,	$B5, $18
		dc.b $A0, $F, 0, $B9, $F8
		dc.b $B0, $B, 0, $C9, $E0
		dc.b $B8, $F, 0, $D5, $38
		dc.b $A8, 5, 0,	$E5, $48
		dc.b $C0, 2, 0,	$E9, $58
		dc.b $C0, $F, 0, $EC, $F8
		dc.b $B8, $F, 0, $FC, $18
		dc.b $B0, 8, 1,	$C, $18
		dc.b $D8, $D, 1, $F, $30
		dc.b $D8, 8, 1,	$17, $18
		dc.b $D8, $F, 1, $1A, $D8
		dc.b $E0, $D, 1, $2A, $F8
		dc.b $E0, 0, 1,	$32, $28
		dc.b $D0, 4, 1,	$33, $E0
		dc.b $E8, 5, 1,	$35, $C8
		dc.b $F8, $C, 1, $39, $C8
		dc.b $F0, 6, 1,	$3D, $F8
		even