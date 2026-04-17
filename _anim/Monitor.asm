; ---------------------------------------------------------------------------
; Animation script - monitors
; ---------------------------------------------------------------------------

Ani_Monitor:	offsetTable
		ptr .static
		ptr .eggman
		ptr .sonic
		ptr .shoes
		ptr .shield
		ptr .invincible
		ptr .rings
		ptr .s
		ptr .goggles
		ptr .breaking

.static:	dc.b 1
		dc.b 0, 1, 2
		dc.b afEnd
		even

.eggman:	dc.b 1
		dc.b 0, 3, 3, 1, 3, 3, 2, 3, 3
		dc.b afEnd
		even

.sonic:		dc.b 1
		dc.b 0, 4, 4, 1, 4, 4, 2, 4, 4
		dc.b afEnd
		even

.shoes:		dc.b 1
		dc.b 0, 5, 5, 1, 5, 5, 2, 5, 5
		dc.b afEnd
		even

.shield:	dc.b 1
		dc.b 0, 6, 6, 1, 6, 6, 2, 6, 6
		dc.b afEnd
		even

.invincible:	dc.b 1
		dc.b 0, 7, 7, 1, 7, 7, 2, 7, 7
		dc.b afEnd
		even

.rings:		dc.b 1
		dc.b 0, 8, 8, 1, 8, 8, 2, 8, 8
		dc.b afEnd
		even

.s:		dc.b 1
		dc.b 0, 9, 9, 1, 9, 9, 2, 9, 9
		dc.b afEnd
		even

.goggles:	dc.b 1
		dc.b 0, $A, $A, 1, $A, $A, 2, $A, $A
		dc.b afEnd
		even

.breaking:	dc.b 2
		dc.b 0, 1, 2
		dc.b $B
		dc.b afBack, 1
		even
