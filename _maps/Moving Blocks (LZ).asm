; ---------------------------------------------------------------------------
; Sprite mappings - moving block (LZ)
; ---------------------------------------------------------------------------
Map_MBlockLZ_internal:
		dc.w .f0-Map_MBlockLZ_internal
.f0:		dc.b 1
		dc.b $F8, $D, 0, 0, $F0
		even