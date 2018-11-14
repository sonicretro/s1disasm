; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	collapsing ledge
; ---------------------------------------------------------------------------
Map_Ledge_internal:
		dc.w @left-Map_Ledge_internal
		dc.w @right-Map_Ledge_internal
		dc.w @leftsmash-Map_Ledge_internal
		dc.w @rightsmash-Map_Ledge_internal
@left:		dc.b $10
		dc.b $C8, $E, 0, $57, $10 ; ledge facing left
		dc.b $D0, $D, 0, $63, $F0
		dc.b $E0, $D, 0, $6B, $10
		dc.b $E0, $D, 0, $73, $F0
		dc.b $D8, 6, 0,	$7B, $E0
		dc.b $D8, 6, 0,	$81, $D0
		dc.b $F0, $D, 0, $87, $10
		dc.b $F0, $D, 0, $8F, $F0
		dc.b $F0, 5, 0,	$97, $E0
		dc.b $F0, 5, 0,	$9B, $D0
		dc.b 0,	$D, 0, $9F, $10
		dc.b 0,	5, 0, $A7, 0
		dc.b 0,	$D, 0, $AB, $E0
		dc.b 0,	5, 0, $B3, $D0
		dc.b $10, $D, 0, $AB, $10
		dc.b $10, 5, 0,	$B7, 0
@right:		dc.b $10
		dc.b $C8, $E, 0, $57, $10 ; ledge facing right
		dc.b $D0, $D, 0, $63, $F0
		dc.b $E0, $D, 0, $6B, $10
		dc.b $E0, $D, 0, $73, $F0
		dc.b $D8, 6, 0,	$7B, $E0
		dc.b $D8, 6, 0,	$BB, $D0
		dc.b $F0, $D, 0, $87, $10
		dc.b $F0, $D, 0, $8F, $F0
		dc.b $F0, 5, 0,	$97, $E0
		dc.b $F0, 5, 0,	$C1, $D0
		dc.b 0,	$D, 0, $9F, $10
		dc.b 0,	5, 0, $A7, 0
		dc.b 0,	$D, 0, $AB, $E0
		dc.b 0,	5, 0, $B7, $D0
		dc.b $10, $D, 0, $AB, $10
		dc.b $10, 5, 0,	$B7, 0
@leftsmash:	dc.b $19
		dc.b $C8, 6, 0,	$5D, $20 ; ledge facing	left in	pieces
		dc.b $C8, 6, 0,	$57, $10
		dc.b $D0, 5, 0,	$67, 0
		dc.b $D0, 5, 0,	$63, $F0
		dc.b $E0, 5, 0,	$6F, $20
		dc.b $E0, 5, 0,	$6B, $10
		dc.b $E0, 5, 0,	$77, 0
		dc.b $E0, 5, 0,	$73, $F0
		dc.b $D8, 6, 0,	$7B, $E0
		dc.b $D8, 6, 0,	$81, $D0
		dc.b $F0, 5, 0,	$8B, $20
		dc.b $F0, 5, 0,	$87, $10
		dc.b $F0, 5, 0,	$93, 0
		dc.b $F0, 5, 0,	$8F, $F0
		dc.b $F0, 5, 0,	$97, $E0
		dc.b $F0, 5, 0,	$9B, $D0
		dc.b 0,	5, 0, $8B, $20
		dc.b 0,	5, 0, $8B, $10
		dc.b 0,	5, 0, $A7, 0
		dc.b 0,	5, 0, $AB, $F0
		dc.b 0,	5, 0, $AB, $E0
		dc.b 0,	5, 0, $B3, $D0
		dc.b $10, 5, 0,	$AB, $20
		dc.b $10, 5, 0,	$AB, $10
		dc.b $10, 5, 0,	$B7, 0
@rightsmash:	dc.b $19
		dc.b $C8, 6, 0,	$5D, $20 ; ledge facing	right in pieces
		dc.b $C8, 6, 0,	$57, $10
		dc.b $D0, 5, 0,	$67, 0
		dc.b $D0, 5, 0,	$63, $F0
		dc.b $E0, 5, 0,	$6F, $20
		dc.b $E0, 5, 0,	$6B, $10
		dc.b $E0, 5, 0,	$77, 0
		dc.b $E0, 5, 0,	$73, $F0
		dc.b $D8, 6, 0,	$7B, $E0
		dc.b $D8, 6, 0,	$BB, $D0
		dc.b $F0, 5, 0,	$8B, $20
		dc.b $F0, 5, 0,	$87, $10
		dc.b $F0, 5, 0,	$93, 0
		dc.b $F0, 5, 0,	$8F, $F0
		dc.b $F0, 5, 0,	$97, $E0
		dc.b $F0, 5, 0,	$C1, $D0
		dc.b 0,	5, 0, $8B, $20
		dc.b 0,	5, 0, $8B, $10
		dc.b 0,	5, 0, $A7, 0
		dc.b 0,	5, 0, $AB, $F0
		dc.b 0,	5, 0, $AB, $E0
		dc.b 0,	5, 0, $B7, $D0
		dc.b $10, 5, 0,	$AB, $20
		dc.b $10, 5, 0,	$AB, $10
		dc.b $10, 5, 0,	$B7, 0
		even