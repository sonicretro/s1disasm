; ---------------------------------------------------------------------------
; Animation script - energy ball launcher (FZ)
; ---------------------------------------------------------------------------
Ani_PLaunch:	dc.w @red-Ani_PLaunch
		dc.w @redsparking-Ani_PLaunch
		dc.w @whitesparking-Ani_PLaunch
@red:		dc.b $7E, 0, afEnd
		even
@redsparking:	dc.b 1,	0, 2, 0, 3, afEnd
		even
@whitesparking:	dc.b 1,	1, 2, 1, 3, afEnd
		even