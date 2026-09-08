; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------

lvlsize macro left,right,top,bottom
	; $0004 is an unused value, $0060 is the default vertical screen shift.
	; Both are always the same and redundant.
	dc.w $0004, left, right, top, bottom, $0060
	endm

; ---------------------------------------------------------------------------

		;           |---------------------------------Left boundary
		;           |      |--------------------------Right boundary
		;           |      |      |-------------------Top boundary
		;           |      |      |      |------------Bottom boundary
		; GHZ       |      |      |      |
		lvlsize     0, $24BF,     0,  $300 ; GHZ1
		lvlsize     0, $1EBF,     0,  $300 ; GHZ2
		lvlsize     0, $2960,     0,  $300 ; GHZ3
		lvlsize     0, $2ABF,     0,  $300 ; GHZ4 (unused)
		; LZ
		lvlsize     0, $19BF,     0,  $530 ; LZ1
		lvlsize     0, $10AF,     0,  $720 ; LZ2
		lvlsize     0, $202F, -$100,  $800 ; LZ3 (level wrapping)
		lvlsize     0, $20BF,     0,  $720 ; LZ4 (SBZ3)
		; MZ
		lvlsize     0, $17BF,     0,  $1D0 ; MZ1
		lvlsize     0, $17BF,     0,  $520 ; MZ2
		lvlsize     0, $1800,     0,  $720 ; MZ3
		lvlsize     0, $16BF,     0,  $720 ; MZ4 (unused)
		; SLZ
		lvlsize     0, $1FBF,     0,  $640 ; SLZ1
		lvlsize     0, $1FBF,     0,  $640 ; SLZ2
		lvlsize     0, $2000,     0,  $6C0 ; SLZ3
		lvlsize     0, $3EC0,     0,  $720 ; SLZ4 (unused)
		; SYZ
		lvlsize     0, $22C0,     0,  $420 ; SYZ1
		lvlsize     0, $28C0,     0,  $520 ; SYZ2
		lvlsize     0, $2C00,     0,  $620 ; SYZ3
		lvlsize     0, $2EC0,     0,  $620 ; SYZ4 (unused)
		; SBZ
		lvlsize     0, $21C0,     0,  $720 ; SBZ1
		lvlsize     0, $1E40, -$100,  $800 ; SBZ2 (level wrapping)
		lvlsize $2080, $2460,  $510,  $510 ; SBZ3 (FZ)
		lvlsize     0, $3EC0,     0,  $720 ; SBZ4 (unused)
		zonewarning LevelSizeArray,$30
		; Ending
		lvlsize     0,  $500,  $110,  $110 ; good ending
		lvlsize     0,  $DC0,  $110,  $110 ; bad ending
		lvlsize     0, $2FFF,     0,  $320 ; (unused)
		lvlsize     0, $2FFF,     0,  $320 ; (unused)
		even
