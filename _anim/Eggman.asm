; ---------------------------------------------------------------------------
; Animation script - Eggman (bosses)
; ---------------------------------------------------------------------------
Ani_Eggman:	dc.w @ship-Ani_Eggman
		dc.w @facenormal1-Ani_Eggman
		dc.w @facenormal2-Ani_Eggman
		dc.w @facenormal3-Ani_Eggman
		dc.w @facelaugh-Ani_Eggman
		dc.w @facehit-Ani_Eggman
		dc.w @facepanic-Ani_Eggman
		dc.w @blank-Ani_Eggman
		dc.w @flame1-Ani_Eggman
		dc.w @flame2-Ani_Eggman
		dc.w @facedefeat-Ani_Eggman
		dc.w @escapeflame-Ani_Eggman
@ship:		dc.b $F, 0, afEnd
		even
@facenormal1:	dc.b 5,	1, 2, afEnd
		even
@facenormal2:	dc.b 3,	1, 2, afEnd
		even
@facenormal3:	dc.b 1,	1, 2, afEnd
		even
@facelaugh:	dc.b 4,	3, 4, afEnd
		even
@facehit:	dc.b $1F, 5, 1,	afEnd
		even
@facepanic:	dc.b 3,	6, 1, afEnd
		even
@blank:		dc.b $F, $A, afEnd
		even
@flame1:	dc.b 3,	8, 9, afEnd
		even
@flame2:	dc.b 1,	8, 9, afEnd
		even
@facedefeat:	dc.b $F, 7, afEnd
		even
@escapeflame:	dc.b 2,	9, 8, $B, $C, $B, $C, 9, 8, afBack, 2
		even