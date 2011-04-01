; ---------------------------------------------------------------------------
; Animation script - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
Ani_Missile:	dc.w @flare-Ani_Missile
		dc.w @missile-Ani_Missile
@flare:		dc.b 7,	0, 1, afRoutine
@missile:	dc.b 1,	2, 3, afEnd
		even