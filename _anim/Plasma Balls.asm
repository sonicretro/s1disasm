; ---------------------------------------------------------------------------
; Animation script - plasma balls in final boss fight (FZ)
; ---------------------------------------------------------------------------

Ani_Plasma:	offsetTable
		ptr .full
		ptr .short

.full:		dc.b 1
		dc.b 0, $A, 8, $A, 1, $A, 9, $A, 6, $A, 7, $A, 0, $A, 8, $A
		dc.b 1, $A, 9, $A, 6, $A, 7, $A, 2, $A, 3, $A, 4, $A, 5
		dc.b afEnd
		even

.short:		dc.b 0
		dc.b 6, 5, 1, 5, 7, 5, 1, 5
		dc.b afEnd
		even
