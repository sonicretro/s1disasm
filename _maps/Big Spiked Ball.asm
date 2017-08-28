; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball on a chain (SBZ) and big spiked ball (SYZ)
; ---------------------------------------------------------------------------
Map_BBall_internal:
		dc.w .ball-Map_BBall_internal
		dc.w .chain-Map_BBall_internal
		dc.w .anchor-Map_BBall_internal
.ball:		dc.b 5
		dc.b $E8, 4, 0,	0, $F8	; big spiked ball
		dc.b $F0, $F, 0, 2, $F0
		dc.b $F8, 1, 0,	$12, $E8
		dc.b $F8, 1, 0,	$14, $10
		dc.b $10, 4, 0,	$16, $F8
.chain:		dc.b 1
		dc.b $F8, 5, 0,	$20, $F8 ; chain link (SBZ)
.anchor:	dc.b 2
		dc.b $F8, $D, 0, $18, $F0 ; anchor at base of chain (SBZ)
		dc.b $E8, $D, $10, $18,	$F0
		even