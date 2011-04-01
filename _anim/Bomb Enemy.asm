; ---------------------------------------------------------------------------
; Animation script - Bomb enemy
; ---------------------------------------------------------------------------
Ani_Bomb:	dc.w @stand-Ani_Bomb
		dc.w @walk-Ani_Bomb
		dc.w @activated-Ani_Bomb
		dc.w @fuse-Ani_Bomb
		dc.w @shrapnel-Ani_Bomb
@stand:		dc.b $13, 1, 0,	afEnd
@walk:		dc.b $13, 5, 4,	3, 2, afEnd
@activated:	dc.b $13, 7, 6,	afEnd
@fuse:		dc.b 3,	8, 9, afEnd
@shrapnel:	dc.b 3,	$A, $B,	afEnd
		even