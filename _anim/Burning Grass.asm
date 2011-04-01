; ---------------------------------------------------------------------------
; Animation script - burning grass that sits on the floor (MZ)
; ---------------------------------------------------------------------------
Ani_GFire:	dc.w @burn-Ani_GFire
@burn:		dc.b 5,	0, $20,	1, $21,	afEnd
		even