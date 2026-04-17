; ---------------------------------------------------------------------------
; Animation script - Eggman on the "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------

Ani_EEgg:	offsetTable
		ptr .tryagain1
		ptr .tryagain2
		ptr .endtantrum

.tryagain1:	dc.b 5
		dc.b 0
		dc.b afRoutine, 1
		even

.tryagain2:	dc.b 5
		dc.b 2
		dc.b afRoutine, 3
		even

.endtantrum:	dc.b 7
		dc.b 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 7, 5, 6, 5
		dc.b afEnd
		even
