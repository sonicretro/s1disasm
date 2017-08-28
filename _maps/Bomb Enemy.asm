; ---------------------------------------------------------------------------
; Sprite mappings - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------
Map_Bomb_internal:
		dc.w .stand1-Map_Bomb_internal
		dc.w .stand2-Map_Bomb_internal
		dc.w .walk1-Map_Bomb_internal
		dc.w .walk2-Map_Bomb_internal
		dc.w .walk3-Map_Bomb_internal
		dc.w .walk4-Map_Bomb_internal
		dc.w .activate1-Map_Bomb_internal
		dc.w .activate2-Map_Bomb_internal
		dc.w .fuse1-Map_Bomb_internal
		dc.w .fuse2-Map_Bomb_internal
		dc.w .shrapnel1-Map_Bomb_internal
		dc.w .shrapnel2-Map_Bomb_internal
.stand1:	dc.b 3
		dc.b $F1, $A, 0, 0, $F4	; bomb standing still
		dc.b 9,	8, 0, $12, $F4
		dc.b $E7, 1, 0,	$21, $FC
.stand2:	dc.b 3
		dc.b $F1, $A, 0, 9, $F4
		dc.b 9,	8, 0, $12, $F4
		dc.b $E7, 1, 0,	$21, $FC
.walk1:		dc.b 3
		dc.b $F0, $A, 0, 0, $F4	; bomb walking
		dc.b 8,	8, 0, $15, $F4
		dc.b $E6, 1, 0,	$21, $FC
.walk2:		dc.b 3
		dc.b $F1, $A, 0, 9, $F4
		dc.b 9,	8, 0, $18, $F4
		dc.b $E7, 1, 0,	$21, $FC
.walk3:		dc.b 3
		dc.b $F0, $A, 0, 0, $F4
		dc.b 8,	8, 0, $1B, $F4
		dc.b $E6, 1, 0,	$21, $FC
.walk4:		dc.b 3
		dc.b $F1, $A, 0, 9, $F4
		dc.b 9,	8, 0, $1E, $F4
		dc.b $E7, 1, 0,	$21, $FC
.activate1:	dc.b 2
		dc.b $F1, $A, 0, 0, $F4	; bomb during detonation countdown
		dc.b 9,	8, 0, $12, $F4
.activate2:	dc.b 2
		dc.b $F1, $A, 0, 9, $F4
		dc.b 9,	8, 0, $12, $F4
.fuse1:		dc.b 1
		dc.b $E7, 1, 0,	$23, $FC ; fuse	(just before it	explodes)
.fuse2:		dc.b 1
		dc.b $E7, 1, 0,	$25, $FC
.shrapnel1:	dc.b 1
		dc.b $FC, 0, 0,	$27, $FC ; shrapnel (after it exploded)
.shrapnel2:	dc.b 1
		dc.b $FC, 0, 0,	$28, $FC
		even