; ===========================================================================
; ---------------------------------------------------------------------------
; Macros (assembler-specific)
; ---------------------------------------------------------------------------

; boolean constants for asm68k
TRUE:	equ 1
FALSE:	equ 0

; instructions that were used with 0(a#) syntax
; defined to assemble as they originally did

_move:	macro
	if ZeroOffsetOptimization=0
		pusho
		opt oz-
	endif
	move.\0 \_
	if ZeroOffsetOptimization=0
		popo
	endif
	endm

_clr:	macro
	pusho
	opt oz-
	clr.\0 \_
	if ZeroOffsetOptimization=0
		popo
	endif
	endm

_add:	macro
	if ZeroOffsetOptimization=0
		pusho
		opt oz-
	endif
	add.\0 \_
	if ZeroOffsetOptimization=0
		popo
	endif
	endm

_cmp:	macro
	if ZeroOffsetOptimization=0
		pusho
		opt oz-
	endif
	cmp.\0 \_
	if ZeroOffsetOptimization=0
		popo
	endif
	endm

_cmpi:	macro
	if ZeroOffsetOptimization=0
		pusho
		opt oz-
	endif
	cmpi.\0 \_
	if ZeroOffsetOptimization=0
		popo
	endif
	endm

_tst:	macro
	if ZeroOffsetOptimization=0
		pusho
		opt oz-
	endif
	tst.\0 \_
	if ZeroOffsetOptimization=0
		popo
	endif
	endm
