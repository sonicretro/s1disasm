; ===========================================================================
; ---------------------------------------------------------------------------
; Object 58 - giant moving spiked metal balls (SYZ)
; ---------------------------------------------------------------------------

BigSpikeBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BBall_Index(pc,d0.w),d1
		jmp	BBall_Index(pc,d1.w)
; ===========================================================================
BBall_Index:	dc.w BBall_Main-BBall_Index
		dc.w BBall_Move-BBall_Index

bball_origX:	equ objoff_3A		; original x-axis position
bball_origY:	equ objoff_38		; original y-axis position
bball_radius:	equ objoff_3C		; radius of circle (subtype $x3 only)
bball_speed:	equ objoff_3E		; rotation speed (subtype $x3 only)
; ===========================================================================

BBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to BBall_Move
		move.l	#Map_BBall,obMap(a0)			; set mappings
		move.w	#ArtTile_SYZ_Big_Spikeball,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#48/2,obActWid(a0)			; set sprite display width
		move.w	obX(a0),bball_origX(a0)			; remember initial X-position
		move.w	obY(a0),bball_origY(a0)			; remember initial Y-position
		move.b	#col_32x32|col_hurt,obColType(a0)	; make spike balls harmful on touch

		move.b	obSubtype(a0),d1			; get object subtype
		andi.b	#$F0,d1					; read only the upper digit
		ext.w	d1					; extend to word size
		asl.w	#3,d1					; multiply by 8
		move.w	d1,bball_speed(a0)			; set object speed (can be positive or negative)

		move.b	obStatus(a0),d0				; get status flags containing X/Y-flip flags
		ror.b	#2,d0					; move X/Y-flip flags in bits 0-1 to upper bits 6-7
		andi.b	#%11000000,d0				; limit to only bits 6-7 ($C0)
		move.b	d0,obAngle(a0)				; set initial angle for ball (subtype $x3 only)
		move.b	#$50,bball_radius(a0)			; set radius of circle motion (subtype $x3 only)
; ---------------------------------------------------------------------------

BBall_Move:	; Routine 2
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#7,d0					; read only the lower digit, limited to 0-7
		add.w	d0,d0					; double for word-based indexing
		move.w	BBall_Types(pc,d0.w),d1			; find behavior for ball type
		jsr	BBall_Types(pc,d1.w)			; execute behavior, then return here

		out_of_range.w	DeleteObject,bball_origX(a0)	; has spike ball gone out of range? if yes, delete it
		bra.w	DisplaySprite				; otherwise, display ball
; ===========================================================================
BBall_Types:	dc.w BBall_Type0_Stationary-BBall_Types
		dc.w BBall_Type1_LeftRight-BBall_Types
		dc.w BBall_Type2_UpDown-BBall_Types
		dc.w BBall_Type2_Circling-BBall_Types
; ===========================================================================

; Subtype $x0
BBall_Type0_Stationary:
		rts						; subtype $x0 doesn't move at all
; ===========================================================================

; Subtype $x1
BBall_Type1_LeftRight:
		move.w	#$60,d1					; adjustment offset for X-flipped balls (oscillation range * 2)
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$E).w,d0			; get oscillatory value (frequency 2, middle value $30)
		btst	#0,obStatus(a0)				; is spike ball X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		add.w	d1,d0					; keep flipped balls in the same $60px range

	.setX:
		move.w	bball_origX(a0),d1			; get initial X-position of spike ball
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obX(a0)				; move spike ball horizontally
		rts						; return
; ===========================================================================

; Subtype $x2
BBall_Type2_UpDown:
		move.w	#$60,d1					; (unused, probably a leftover from copying subtype $x1)
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$E).w,d0			; get oscillatory value (frequency 2, middle value $30)
		btst	#0,obStatus(a0)				; is spike ball Y-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		addi.w	#$60+$20,d0				; keep flipped balls in the same $60px range... plus an extra $20px

	.setY:
		move.w	bball_origY(a0),d1			; get initial Y-position of spike ball
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obY(a0)				; move spike ball vertically
		rts						; return
; ===========================================================================

; Subtype $x3
BBall_Type2_Circling:
		move.w	bball_speed(a0),d0			; get object circling speed (can be positive or negative)
		add.w	d0,obAngle(a0)				; add speed to current angle

		move.b	obAngle(a0),d0				; get current angle
		jsr	(CalcSine).l				; calculate sine and cosine for current angle
		move.w	bball_origY(a0),d2			; get initial X-position
		move.w	bball_origX(a0),d3			; get initial Y-position

		moveq	#0,d4					; clear d4
		move.b	bball_radius(a0),d4			; get circling radius (this is always $50)
		move.l	d4,d5					; copy radius
		muls.w	d0,d4					; multiply radius by angle sine
		asr.l	#8,d4					; shift result to lower word
		muls.w	d1,d5					; multiply radius by angle cosine
		asr.l	#8,d5					; shift result to lower word
		add.w	d2,d4					; add initial Y-position to sine
		add.w	d3,d5					; add initial X-position to cosine
		move.w	d4,obY(a0)				; set new X/Y-positions...
		move.w	d5,obX(a0)				; ...to move ball circularly
		rts						; return

; ===========================================================================

Map_BBall:	include	"_maps/Big Spiked Ball.asm"
