; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------
Map_Hog_internal:
		dc.w M_Hog_Stand-Map_Hog_internal
		dc.w M_Hog_Open-Map_Hog_internal
		dc.w M_Hog_Squat-Map_Hog_internal
		dc.w M_Hog_Leap-Map_Hog_internal
		dc.w M_Hog_Ball1-Map_Hog_internal
		dc.w M_Hog_Ball2-Map_Hog_internal
M_Hog_Stand:	dc.b 2
		dc.b $EF, 9, 0,	0, $F4
		dc.b $FF, $A, 0, 6, $F4	; Ball hog standing
M_Hog_Open:	dc.b 2
		dc.b $EF, 9, 0,	0, $F4
		dc.b $FF, $A, 0, $F, $F4 ; Ball hog with hatch open
M_Hog_Squat:	dc.b 2
		dc.b $F4, 9, 0,	0, $F4
		dc.b 4,	9, 0, $18, $F4	; Ball hog squatting
M_Hog_Leap:	dc.b 2
		dc.b $E4, 9, 0,	0, $F4
		dc.b $F4, $A, 0, $1E, $F4 ; Ball hog leaping
M_Hog_Ball1:	dc.b 1
		dc.b $F8, 5, 0,	$27, $F8 ; Ball (black)
M_Hog_Ball2:	dc.b 1
		dc.b $F8, 5, 0,	$2B, $F8 ; Ball (red)
		even