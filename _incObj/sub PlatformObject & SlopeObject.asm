; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to detect collision with a platform, and update relevant flags.
; Platform height is assumed to be 8px.
;
; input:
;	d0.w = y position (Plat_NoXCheck_AltY only)
;	d1.w = platform width
; 
; output:
;	d2.w = Sonic's y position
;	a1 = address of OST of Sonic
;	a2 = address of OST of platform that Sonic is already on
; 
;	uses d0.l, d1.w
; 
; usage:
;		moveq	#0,d1
;		move.b	obActWid(a0),d1
;		bsr.w	PlatformObject
; ---------------------------------------------------------------------------

PlatformObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)				; is Sonic moving up/jumping?
		bmi.w	Plat_Exit				; if yes, branch

		; perform x-axis range check
		move.w	obX(a1),d0
		sub.w	obX(a0),d0				; d0 = Sonic's distance from centre of platform (-ve if left of centre)
		add.w	d1,d0
		bmi.w	Plat_Exit				; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit				; branch if Sonic is right of the platform

	Plat_NoXCheck:						; jump here to skip x position check
		move.w	obY(a0),d0
		subq.w	#8,d0					; assume platform is 8px tall

	; Platform3:
	Plat_NoXCheck_AltY:					; jump here to skip x position check and use custom y position

		; perform y-axis range check
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1					; d1 = y pos of Sonic's bottom edge
		addq.w	#4,d1
		sub.w	d1,d0					; d0 = distance between top of platform and Sonic's bottom edge (-ve if below platform)
		bhi.w	Plat_Exit				; branch if Sonic is above platform
		cmpi.w	#-16,d0
		blo.w	Plat_Exit				; branch if Sonic is more than 16px below top of platform

	if FixBugs
		; Fix getting stuck on platforms when entering debug mode
		tst.w	(v_debuguse).w				; is debug mode active?
		bne.w	Plat_Exit				; if yes, prevent getting stuck to platform
	endif
		tst.b	(f_playerctrl).w			; is object collision off?
		bmi.w	Plat_Exit				; if yes, branch
		cmpi.b	#6,obRoutine(a1)			; is Sonic dying?
		bhs.w	Plat_Exit				; if yes, branch
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
		addq.b	#2,obRoutine(a0)			; increment object's routine counter

Plat_NoCheck:							; jump here to skip all checks
		btst	#3,obStatus(a1)				; is Sonic on a platform already?
		beq.s	.no					; if not, branch
		moveq	#0,d0
		move.b	standonobject(a1),d0			; get OST index for that platform
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0			; convert index to RAM address
		movea.l	d0,a2					; point a2 to that address
		bclr	#3,obStatus(a2)				; clear platform bit for the other platform
		clr.b	ob2ndRout(a2)
		cmpi.b	#4,obRoutine(a2)			; does its routine counter suggest it's being stood on? (platforms all use similar routines)
		bne.s	.no					; if not, branch
		subq.b	#2,obRoutine(a2)			; decrement counter to "detect mode"

	.no:
		move.w	a0,d0
		subi.w	#v_objspace&$FFFF,d0
		lsr.w	#object_size_bits,d0
		andi.w	#$7F,d0
		move.b	d0,standonobject(a1)			; convert current platform OST address to index and store it
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#1,obStatus(a1)				; is Sonic in the air/jumping?
		beq.s	.notinair				; if not, branch
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l			; make Sonic land
		movea.l	(sp)+,a0

	.notinair:
		bset	#3,obStatus(a1)
		bset	#3,obStatus(a0)

Plat_Exit:
		rts
; End of function PlatformObject


; ===========================================================================
; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	SLZ seesaws)
;
; input:
;	d1.w = platform half width
;	a2 = address of heightmap data
; 
; output:
;	d2.w = Sonic's y position
;	d3.l = height of platform where Sonic is standing
;	a1 = address of OST of Sonic
; 
;	uses d0.l, d1.w, a2
; 
; usage:
;		move.w	#$30,d1					; width
;		lea	(Ledge_SlopeData).l,a2			; heightmap
;		bsr.w	SlopeObject
; ---------------------------------------------------------------------------

; See also: SlopeObject_AssumeStoodOn inside Object 1A - Collapsing GHZ Ledges

SlopeObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)				; is Sonic moving up/jumping?
		bmi.w	Plat_Exit				; if yes, branch

		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0					; d0 = x pos of Sonic on platform
		bmi.s	Plat_Exit				; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	Plat_Exit				; branch if Sonic is right of the platform

		btst	#sprite_xflip_bit,obRender(a0)
		beq.s	.noflip
		not.w	d0
		add.w	d1,d0					; reverse position if platform is xflipped

	.noflip:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3				; get byte from heightmap
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Plat_NoXCheck_AltY			; detect y collision and make Sonic stand on the platform
; End of function SlopeObject


; ===========================================================================
; ---------------------------------------------------------------------------
; Alternate version of PlatformObject with custom solidity height input,
; instead of assuming 8px (only used by swinging platforms on chain links)
;
; input:
;	d1 = platform width
;	d3 = platform height
; ---------------------------------------------------------------------------

; Swing_Solid:
PlatformObject_CustomHeight:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)				; is Sonic moving up/jumping?
		bmi.w	Plat_Exit				; if yes, branch

		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit				; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit				; branch if Sonic is right of the platform

		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Plat_NoXCheck_AltY			; use custom platform height defined in d3
; End of function PlatformObject_CustomHeight
