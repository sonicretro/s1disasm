; ---------------------------------------------------------------------------
; Animation script - harpoon (LZ)
; ---------------------------------------------------------------------------

Ani_Harp:	offsetTable
		ptr .h_extending
		ptr .h_retracting
		ptr .v_extending
		ptr .v_retracting

.h_extending:	dc.b 3
		dc.b 1, 2
		dc.b afRoutine
		even

.h_retracting:	dc.b 3
		dc.b 1, 0
		dc.b afRoutine
		even

.v_extending:	dc.b 3
		dc.b 4, 5
		dc.b afRoutine
		even

.v_retracting:	dc.b 3
		dc.b 4, 3
		dc.b afRoutine
		even
