; ---------------------------------------------------------------------------
; Animation script - Eggman (SBZ2 cutscene)
; ---------------------------------------------------------------------------

Ani_SEgg:	offsetTable
		ptr .stand
		ptr .laugh
		ptr .jump1
		ptr .intube
		ptr .running
		ptr .jump2
		ptr .starjump

.stand:		dc.b 126
		dc.b 0
		dc.b afEnd
		even

.laugh:		dc.b 6
		dc.b 1, 2
		dc.b afEnd
		even

.jump1:		dc.b 14
		dc.b 3, 4, 4, 0, 0, 0
		dc.b afEnd
		even

.intube:	dc.b 0
		dc.b 5, 9
		dc.b afEnd
		even

.running:	dc.b 6
		dc.b 7, 4, 8, 4
		dc.b afEnd
		even

.jump2:		dc.b 15
		dc.b 4, 3, 3
		dc.b afEnd
		even

.starjump:	dc.b 126
		dc.b 6
		dc.b afEnd
		even
