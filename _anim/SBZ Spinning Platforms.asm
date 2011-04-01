; ---------------------------------------------------------------------------
; Animation script - trapdoor (SBZ)
; ---------------------------------------------------------------------------
Ani_Spin:	dc.w @trapopen-Ani_Spin
		dc.w @trapclose-Ani_Spin
		dc.w @spin1-Ani_Spin
		dc.w @spin2-Ani_Spin
@trapopen:	dc.b 3,	0, 1, 2, afBack, 1
@trapclose:	dc.b 3,	2, 1, 0, afBack, 1
@spin1:		dc.b 1,	0, 1, 2, 3, 4, $43, $42, $41, $40, $61,	$62, $63, $64, $23, $22, $21, 0, afBack, 1
@spin2:		dc.b 1,	0, 1, 2, 3, 4, $43, $42, $41, $40, $61,	$62, $63, $64, $23, $22, $21, 0, afBack, 1
		even