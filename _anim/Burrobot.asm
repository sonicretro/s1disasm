; ---------------------------------------------------------------------------
; Animation script - Burrobot enemy
; ---------------------------------------------------------------------------
Ani_Burro:	dc.w @walk1-Ani_Burro
		dc.w @walk2-Ani_Burro
		dc.w @digging-Ani_Burro
		dc.w @fall-Ani_Burro
@walk1:		dc.b 3,	0, 6, afEnd
@walk2:		dc.b 3,	0, 1, afEnd
@digging:	dc.b 3,	2, 3, afEnd
@fall:		dc.b 3,	4, afEnd
		even