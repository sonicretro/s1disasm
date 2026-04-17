; ---------------------------------------------------------------------------
; Animation script - flamethrower (SBZ)
; ---------------------------------------------------------------------------

Ani_Flame:	offsetTable
		ptr .pipe1
		ptr .pipe2
		ptr .valve1
		ptr .valve2

.pipe1:		dc.b 3
		dc.b 0, 1, 2, 3, 4, 5, 6, 7, 8
		dc.b 9, $A
		dc.b afBack, 2
		even

.pipe2:		dc.b 0
		dc.b 9, 7, 5, 3, 1
		dc.b 0
		dc.b afBack, 1
		even

.valve1:	dc.b 3
		dc.b $B, $C, $D, $E, $F, $10, $11, $12, $13
		dc.b $14, $15
		dc.b afBack, 2
		even

.valve2:	dc.b 0
		dc.b $14, $12, $11, $F, $D
		dc.b $B
		dc.b afBack, 1
		even
