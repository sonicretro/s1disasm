; ---------------------------------------------------------------------------
; Animation script - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

Ani_Elec:	offsetTable
		ptr .idle
		ptr .discharge

.idle:		dc.b 7
		dc.b 0
		dc.b afEnd
		even

.discharge:	dc.b 0
		dc.b 1, 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 0
		dc.b afChange, 0
		even
