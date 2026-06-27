; ---------------------------------------------------------------------------
; Animation script - stationary spinning platforms and trapdoors (SBZ)
; ---------------------------------------------------------------------------

Ani_Spin:	dc.w .trapopen-Ani_Spin
		dc.w .trapclose-Ani_Spin
		dc.w .spin1-Ani_Spin
		dc.w .spin2-Ani_Spin

.trapopen:	dc.b 3
		dc.b 0, 1
		dc.b 2
		dc.b afBack, 1
		even

.trapclose:	dc.b 3
		dc.b 2, 1
		dc.b 0
		dc.b afBack, 1
		even

.spin1:		dc.b 1
		dc.b 0, 1, 2, 3, 4
		dc.b 3|aniYFlip, 2|aniYFlip, 1|aniYFlip, 0|aniYFlip
		dc.b 1|aniXFlip|aniYFlip, 2|aniXFlip|aniYFlip, 3|aniXFlip|aniYFlip, 4|aniXFlip|aniYFlip
		dc.b 3|aniXFlip, 2|aniXFlip, 1|aniXFlip
		dc.b 0
		dc.b afBack, 1
		even

.spin2:		dc.b 1
		dc.b 0, 1, 2, 3, 4
		dc.b 3|aniYFlip, 2|aniYFlip, 1|aniYFlip, 0|aniYFlip
		dc.b 1|aniXFlip|aniYFlip, 2|aniXFlip|aniYFlip, 3|aniXFlip|aniYFlip, 4|aniXFlip|aniYFlip
		dc.b 3|aniXFlip, 2|aniXFlip, 1|aniXFlip
		dc.b 0
		dc.b afBack, 1
		even
