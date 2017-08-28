; ---------------------------------------------------------------------------
; Sprite mappings - bubbles (LZ)
; ---------------------------------------------------------------------------
Map_Bub_internal:
		dc.w @bubble1-Map_Bub_internal
		dc.w @bubble2-Map_Bub_internal
		dc.w @bubble3-Map_Bub_internal
		dc.w @bubble4-Map_Bub_internal
		dc.w @bubble5-Map_Bub_internal
		dc.w @bubble6-Map_Bub_internal
		dc.w @bubblefull-Map_Bub_internal
		dc.w @burst1-Map_Bub_internal
		dc.w @burst2-Map_Bub_internal
		dc.w @zero_sm-Map_Bub_internal
		dc.w @five_sm-Map_Bub_internal
		dc.w @three_sm-Map_Bub_internal
		dc.w @one_sm-Map_Bub_internal
		dc.w @zero-Map_Bub_internal
		dc.w @five-Map_Bub_internal
		dc.w @four-Map_Bub_internal
		dc.w @three-Map_Bub_internal
		dc.w @two-Map_Bub_internal
		dc.w @one-Map_Bub_internal
		dc.w @bubmaker1-Map_Bub_internal
		dc.w @bubmaker2-Map_Bub_internal
		dc.w @bubmaker3-Map_Bub_internal
		dc.w @blank-Map_Bub_internal
@bubble1:	dc.b 1
		dc.b $FC, 0, 0,	0, $FC	; bubbles, increasing in size
@bubble2:	dc.b 1
		dc.b $FC, 0, 0,	1, $FC
@bubble3:	dc.b 1
		dc.b $FC, 0, 0,	2, $FC
@bubble4:	dc.b 1
		dc.b $F8, 5, 0,	3, $F8
@bubble5:	dc.b 1
		dc.b $F8, 5, 0,	7, $F8
@bubble6:	dc.b 1
		dc.b $F4, $A, 0, $B, $F4
@bubblefull:	dc.b 1
		dc.b $F0, $F, 0, $14, $F0
@burst1:	dc.b 4
		dc.b $F0, 5, 0,	$24, $F0 ; large bubble bursting
		dc.b $F0, 5, 8,	$24, 0
		dc.b 0,	5, $10,	$24, $F0
		dc.b 0,	5, $18,	$24, 0
@burst2:	dc.b 4
		dc.b $F0, 5, 0,	$28, $F0
		dc.b $F0, 5, 8,	$28, 0
		dc.b 0,	5, $10,	$28, $F0
		dc.b 0,	5, $18,	$28, 0
@zero_sm:	dc.b 1
		dc.b $F4, 6, 0,	$2C, $F8 ; small, partially-formed countdown numbers
@five_sm:	dc.b 1
		dc.b $F4, 6, 0,	$32, $F8
@three_sm:	dc.b 1
		dc.b $F4, 6, 0,	$38, $F8
@one_sm:	dc.b 1
		dc.b $F4, 6, 0,	$3E, $F8
@zero:		dc.b 1
		dc.b $F4, 6, $20, $44, $F8 ; fully-formed countdown numbers
@five:		dc.b 1
		dc.b $F4, 6, $20, $4A, $F8
@four:		dc.b 1
		dc.b $F4, 6, $20, $50, $F8
@three:		dc.b 1
		dc.b $F4, 6, $20, $56, $F8
@two:		dc.b 1
		dc.b $F4, 6, $20, $5C, $F8
@one:		dc.b 1
		dc.b $F4, 6, $20, $62, $F8
@bubmaker1:	dc.b 1
		dc.b $F8, 5, 0,	$68, $F8
@bubmaker2:	dc.b 1
		dc.b $F8, 5, 0,	$6C, $F8
@bubmaker3:	dc.b 1
		dc.b $F8, 5, 0,	$70, $F8
@blank:		dc.b 0
		even