; ---------------------------------------------------------------------------
; Sprite mappings - chain of spiked balls (SYZ)
; ---------------------------------------------------------------------------
Map_SBall_internal:
		dc.w .f0-Map_SBall_internal
.f0:		dc.b 1
		dc.b $F8, 5, 0,	0, $F8
		even