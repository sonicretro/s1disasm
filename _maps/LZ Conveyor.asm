; ---------------------------------------------------------------------------
; Sprite mappings - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------
Map_LConv_internal:
		dc.w .wheel1-Map_LConv_internal
		dc.w .wheel2-Map_LConv_internal
		dc.w .wheel3-Map_LConv_internal
		dc.w .wheel4-Map_LConv_internal
		dc.w .platform-Map_LConv_internal
.wheel1:	dc.b 1
		dc.b $F0, $F, 0, 0, $F0
.wheel2:	dc.b 1
		dc.b $F0, $F, 0, $10, $F0
.wheel3:	dc.b 1
		dc.b $F0, $F, 0, $20, $F0
.wheel4:	dc.b 1
		dc.b $F0, $F, 0, $30, $F0
.platform:	dc.b 1
		dc.b $F8, $D, 0, $40, $F0
		even