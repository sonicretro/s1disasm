; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------
Map_Burro_internal:
		dc.w @walk1-Map_Burro_internal
		dc.w @walk2-Map_Burro_internal
		dc.w @digging1-Map_Burro_internal
		dc.w @digging2-Map_Burro_internal
		dc.w @fall-Map_Burro_internal
		dc.w @facedown-Map_Burro_internal
		dc.w @walk3-Map_Burro_internal
@walk1:		dc.b 2
		dc.b $EC, $A, 0, 0, $F0	; walking
		dc.b 4,	9, 0, 9, $F4
@walk2:		dc.b 2
		dc.b $EC, $A, 0, $F, $F0
		dc.b 4,	9, 0, $18, $F4
@digging1:	dc.b 2
		dc.b $E8, $A, 0, $1E, $F4 ; digging
		dc.b 0,	$A, 0, $27, $F4
@digging2:	dc.b 2
		dc.b $E8, $A, 0, $30, $F4
		dc.b 0,	$A, 0, $39, $F4
@fall:		dc.b 2
		dc.b $E8, $A, 0, $F, $F0 ; falling after jumping up
		dc.b 0,	$A, 0, $42, $F4
@facedown:	dc.b 2
		dc.b $F4, 6, 0,	$4B, $E8 ; facing down (unused)
		dc.b $F4, $A, 0, $51, $F8
@walk3:		dc.b 2
		dc.b $EC, $A, 0, $F, $F0
		dc.b 4,	9, 0, 9, $F4
		even