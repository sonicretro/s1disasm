; ---------------------------------------------------------------------------
; Animation script - energy balls (FZ)
; ---------------------------------------------------------------------------
Ani_Plasma:	dc.w @full-Ani_Plasma
		dc.w @short-Ani_Plasma
@full:		dc.b 1,	0, $A, 8, $A, 1, $A, 9,	$A, 6, $A, 7, $A, 0, $A
		dc.b 8,	$A, 1, $A, 9, $A, 6, $A, 7, $A,	2, $A, 3, $A, 4
		dc.b $A, 5, afEnd
		even
@short:		dc.b 0,	6, 5, 1, 5, 7, 5, 1, 5,	afEnd
		even