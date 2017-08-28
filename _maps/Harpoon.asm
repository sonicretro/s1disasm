; ---------------------------------------------------------------------------
; Sprite mappings - harpoon (LZ)
; ---------------------------------------------------------------------------
Map_Harp_internal:
		dc.w .h_retracted-Map_Harp_internal
		dc.w .h_middle-Map_Harp_internal
		dc.w .h_extended-Map_Harp_internal
		dc.w .v_retracted-Map_Harp_internal
		dc.w .v_middle-Map_Harp_internal
		dc.w .v_extended-Map_Harp_internal
.h_retracted:	dc.b 1
		dc.b $FC, 4, 0,	0, $F8
.h_middle:	dc.b 1
		dc.b $FC, $C, 0, 2, $F8
.h_extended:	dc.b 2
		dc.b $FC, 8, 0,	6, $F8
		dc.b $FC, 8, 0,	3, $10
.v_retracted:	dc.b 1
		dc.b $F8, 1, 0,	9, $FC
.v_middle:	dc.b 1
		dc.b $E8, 3, 0,	$B, $FC
.v_extended:	dc.b 2
		dc.b $D8, 2, 0,	$B, $FC
		dc.b $F0, 2, 0,	$F, $FC
		even