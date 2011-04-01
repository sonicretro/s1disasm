; ---------------------------------------------------------------------------
; Sprite mappings - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Newt:	dc.w M_Newt_Trans-Map_Newt, M_Newt_Norm-Map_Newt
		dc.w M_Newt_Fires-Map_Newt, M_Newt_Drop1-Map_Newt
		dc.w M_Newt_Drop2-Map_Newt, M_Newt_Drop3-Map_Newt
		dc.w M_Newt_Fly1a-Map_Newt, M_Newt_Fly1b-Map_Newt
		dc.w M_Newt_Fly2a-Map_Newt, M_Newt_Fly2b-Map_Newt
		dc.w M_Newt_Blank-Map_Newt
M_Newt_Trans:	dc.b 3
		dc.b $EC, $D, 0, 0, $EC	; partially visible
		dc.b $F4, 0, 0,	8, $C
		dc.b $FC, $E, 0, 9, $F4
M_Newt_Norm:	dc.b 3
		dc.b $EC, 6, 0,	$15, $EC ; visible
		dc.b $EC, 9, 0,	$1B, $FC
		dc.b $FC, $A, 0, $21, $FC
M_Newt_Fires:	dc.b 3
		dc.b $EC, 6, 0,	$2A, $EC ; open mouth, firing
		dc.b $EC, 9, 0,	$1B, $FC
		dc.b $FC, $A, 0, $21, $FC
M_Newt_Drop1:	dc.b 4
		dc.b $EC, 6, 0,	$30, $EC ; dropping
		dc.b $EC, 9, 0,	$1B, $FC
		dc.b $FC, 9, 0,	$36, $FC
		dc.b $C, 0, 0, $3C, $C
M_Newt_Drop2:	dc.b 3
		dc.b $F4, $D, 0, $3D, $EC
		dc.b $FC, 0, 0,	$20, $C
		dc.b 4,	8, 0, $45, $FC
M_Newt_Drop3:	dc.b 2
		dc.b $F8, $D, 0, $48, $EC
		dc.b $F8, 1, 0,	$50, $C
M_Newt_Fly1a:	dc.b 3
		dc.b $F8, $D, 0, $48, $EC ; flying
		dc.b $F8, 1, 0,	$50, $C
		dc.b $FE, 0, 0,	$52, $14
M_Newt_Fly1b:	dc.b 3
		dc.b $F8, $D, 0, $48, $EC
		dc.b $F8, 1, 0,	$50, $C
		dc.b $FE, 4, 0,	$53, $14
M_Newt_Fly2a:	dc.b 3
		dc.b $F8, $D, 0, $48, $EC
		dc.b $F8, 1, 0,	$50, $C
		dc.b $FE, 0, $E0, $52, $14
M_Newt_Fly2b:	dc.b 3
		dc.b $F8, $D, 0, $48, $EC
		dc.b $F8, 1, 0,	$50, $C
		dc.b $FE, 4, $E0, $53, $14
M_Newt_Blank:	dc.b 0
		even