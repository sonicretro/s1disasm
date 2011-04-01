; ---------------------------------------------------------------------------
; Sprite mappings - water surface (LZ)
; ---------------------------------------------------------------------------
Map_Surf:	dc.w @normal1-Map_Surf, @normal2-Map_Surf
		dc.w @normal3-Map_Surf, @paused1-Map_Surf
		dc.w @paused2-Map_Surf, @paused3-Map_Surf
@normal1:	dc.b 3
		dc.b $FD, $D, 0, 0, $A0
		dc.b $FD, $D, 0, 0, $E0
		dc.b $FD, $D, 0, 0, $20
@normal2:	dc.b 3
		dc.b $FD, $D, 0, 8, $A0
		dc.b $FD, $D, 0, 8, $E0
		dc.b $FD, $D, 0, 8, $20
@normal3:	dc.b 3
		dc.b $FD, $D, 8, 0, $A0
		dc.b $FD, $D, 8, 0, $E0
		dc.b $FD, $D, 8, 0, $20
@paused1:	dc.b 6
		dc.b $FD, $D, 0, 0, $A0
		dc.b $FD, $D, 0, 0, $C0
		dc.b $FD, $D, 0, 0, $E0
		dc.b $FD, $D, 0, 0, 0
		dc.b $FD, $D, 0, 0, $20
		dc.b $FD, $D, 0, 0, $40
@paused2:	dc.b 6
		dc.b $FD, $D, 0, 8, $A0
		dc.b $FD, $D, 0, 8, $C0
		dc.b $FD, $D, 0, 8, $E0
		dc.b $FD, $D, 0, 8, 0
		dc.b $FD, $D, 0, 8, $20
		dc.b $FD, $D, 0, 8, $40
@paused3:	dc.b 6
		dc.b $FD, $D, 8, 0, $A0
		dc.b $FD, $D, 8, 0, $C0
		dc.b $FD, $D, 8, 0, $E0
		dc.b $FD, $D, 8, 0, 0
		dc.b $FD, $D, 8, 0, $20
		dc.b $FD, $D, 8, 0, $40
		even