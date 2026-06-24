; ===========================================================================
; ---------------------------------------------------------------------------
; Object 8B - Eggman on "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------

EndEggman:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	EEgg_Index(pc,d0.w),d1
		jsr	EEgg_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
EEgg_Index:	dc.w EEgg_Main-EEgg_Index	; 0
		dc.w EEgg_Animate-EEgg_Index	; 2
		dc.w EEgg_Juggle-EEgg_Index	; 4
		dc.w EEgg_Wait-EEgg_Index	; 6

eegg_time:	equ objoff_30		; time between juggle motions
; ===========================================================================

EEgg_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to EEgg_Animate
		move.w	#$80+$A0,obX(a0)			; set X-position
		move.w	#$80+$74,obScreenY(a0)			; set Y-position
		move.l	#Map_EEgg,obMap(a0)			; set mappings
		move.w	#ArtTile_Try_Again_Eggman,obGfx(a0)	; set art tile
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen-positioned mode
		move.b	#2,obPriority(a0)			; set sprite priority (behind emeralds)

		move.b	#2,obAnim(a0)				; use "END" tantrum animation by default (good ending)
		cmpi.b	#ss_emeralds_num,(v_emeralds).w		; do you have all 6 emeralds?
		beq.s	EEgg_Animate				; if yes, we have a good ending
		
		; Bad Ending (load emeralds)
		move.b	#id_CreditsText,(v_tryagain).w		; load credits object
		move.w	#9,(v_creditsnum).w			; use "TRY AGAIN" text for credits text object
		move.b	#id_TryChaos,(v_eggmanchaos).w		; load emeralds object on "TRY AGAIN" screen
		move.b	#0,obAnim(a0)				; use "TRY AGAIN" animation for Eggman
; ---------------------------------------------------------------------------

EEgg_Animate:	; Routine 2
		lea	(Ani_EEgg).l,a1				; load animation script
		jmp	(AnimateSprite).l			; ("TRY AGAIN" animations will advance obRoutine on finish)
; ===========================================================================

EEgg_Juggle:	; Routine 4
		addq.b	#2,obRoutine(a0)			; advance to EEgg_Wait

		moveq	#2,d0					; move emeralds at 2px/frame to the right
		btst	#0,obAnim(a0)				; is Eggman on second juggle animation?
		beq.s	.juggle					; if not, branch
		neg.w	d0					; move emeralds to the left instead
	.juggle:
		lea	(v_eggmanchaos).w,a1			; get RAM address for emeralds
		moveq	#ss_emeralds_num-1,d1			; juggle all 6 emeralds
	.loopJuggleEmeralds:
		move.b	d0,tcha_juggledir(a1)			; set emerald X-movement direction (+2 or -2)
		move.w	d0,d2					; copy juggle  direction
		asl.w	#3,d2					; multiply by 8
		add.b	d2,obAngle(a1)				; add that to each emerald's angle to get spacing between them
		lea	object_size(a1),a1			; advance to next object slot ($40)
		dbf	d1,.loopJuggleEmeralds			; loop for all emeralds

		addq.b	#1,obFrame(a0)				; force Eggman to "raised hand" frame after juggling
		move.w	#(2*60)-8,eegg_time(a0)			; wait roughly 2 seconds in between juggles
; ---------------------------------------------------------------------------

EEgg_Wait:	; Routine 6
		subq.w	#1,eegg_time(a0)			; decrement delaytimer
		bpl.s	.return					; branch if time remains
		bchg	#0,obAnim(a0)				; alternate between left and right juggle animations
		move.b	#2,obRoutine(a0)			; goto EEgg_Animate next

	.return:
		rts						; return
; ===========================================================================

		include "_anim/Try Again & End Eggman.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 8C - chaos emeralds on the "TRY AGAIN" screen
; ---------------------------------------------------------------------------

TryChaos:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	TCha_Index(pc,d0.w),d1
		jsr	TCha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
TCha_Index:	dc.w TCha_LoadEmeralds-TCha_Index	; 0
		dc.w TCha_JuggleEmeralds-TCha_Index	; 2

tcha_origX:	equ objoff_38		; anchor X-position for juggle circle
tcha_origY:	equ objoff_3A		; anchor Y-position for juggle circle
tcha_radius:	equ objoff_3C		; juggle circle radius (fixed to $1C)
tcha_juggledir:	equ objoff_3E		; current juggle direction/speed (+2 or -2)
; ===========================================================================

TCha_LoadEmeralds: ; Routine 0
		; One emerald object is loaded from the Eggman object.
		; From here, convert that one in into the 6 actual emeralds to display.
		movea.l	a0,a1					; overwrite this loader object with the first real emerald
		moveq	#0,d2					; used for frame IDs for collected emeralds
		moveq	#0,d3					; used for juggle delays between emeralds
		moveq	#ss_emeralds_num-1,d1			; load all emeralds...
		sub.b	(v_emeralds).w,d1			; ...minus how many you have collected
.loopEmeralds:
		move.b	#id_TryChaos,obID(a1)			; load emerald object
		addq.b	#2,obRoutine(a1)			; advance to TCha_Move
		move.l	#Map_ECha,obMap(a1)			; set mappings (same ones used in ending sequence)
		move.w	#ArtTile_Try_Again_Emeralds,obGfx(a1)	; set art tile
		move.b	#sprite_cam_screen,obRender(a1)		; set to screen-positioned mode
		move.b	#1,obPriority(a1)			; set sprite priority (above Eggman)
		move.w	#$80+$84,obX(a1)			; start X-position
		move.w	#$80+$A0,tcha_origX(a1)			; X-position for radius anchor point
		move.w	#$80+$6C,obScreenY(a1)			; start Y-position
		move.w	obScreenY(a1),tcha_origY(a1)		; use that as Y-position for radius anchor point
		move.b	#$1C,tcha_radius(a1)			; circle radius of juggled emeralds (doesn't change)

		lea	(v_emldlist).w,a3			; get array of collected emeralds
	.check:	moveq	#0,d0					; clear d0 for word-based addressing
		move.b	(v_emeralds).w,d0			; get total number of collected emeralds
		subq.w	#1,d0					; decrement for dbf
		bcs.s	.showEmerald				; if underflowed, you have collected 0 emeralds (juggle all)
	.loop:	cmp.b	(a3,d0.w),d2				; has this specific emerald been collected?
		bne.s	.next					; if not, check next emerald
		addq.b	#1,d2					; emerald was collected, skip frame
		bra.s	.check					; check if the next emerald has been collected
	.next:	dbf	d0,.loop				; loop for number of collected emeralds

	.showEmerald:
		move.b	d2,obFrame(a1)				; set frame of uncollected emerald color...
		addq.b	#1,obFrame(a1)				; ...plus one (frame 0 is flashing/white)
		addq.b	#1,d2					; advance to next emerald frame ID
		move.b	#$80,obAngle(a1)			; set base angle to 180 degrees (in Eggman's right hand)
		move.b	d3,obTimeFrame(a1)			; set extra delay for current emerald to rest in Eggman's hand
		move.b	d3,obDelayAni(a1)			; remember that delay for repeated juggles
		addi.w	#10,d3					; increase juggle delay between each emeralds by 10 frames

		lea	object_size(a1),a1			; advance to next object RAM slot ($40)
		dbf	d1,.loopEmeralds			; repeat 5 times
; ---------------------------------------------------------------------------

TCha_JuggleEmeralds: ; Routine 2
		tst.w	tcha_juggledir(a0)			; are emeralds currently being juggled?
		beq.s	.return					; if not, do nothing

		tst.b	obTimeFrame(a0)				; has per-emerald delay expired?
		beq.s	.moveEmerald				; if yes, make emerald move
		subq.b	#1,obTimeFrame(a0)			; decrement per-emerald delay
		bne.s	.checkInHand				; if time remains, branch

	.moveEmerald:
		move.w	tcha_juggledir(a0),d0			; get current juggle direction (+2 or -2)
		add.w	d0,obAngle(a0)				; add juggle direction to current angle

	.checkInHand:
		move.b	obAngle(a0),d0				; get current emerald angle
		beq.s	.landedInHand				; has emerald landed in Eggman's left hand (0 degrees)? if yes, branch
		cmpi.b	#$80,d0					; has emerald landed in Eggman's right hand (180 degrees)?
		bne.s	.juggleRadius				; if not, branch

	.landedInHand:
		clr.w	tcha_juggledir(a0)			; make emeralds stop in Eggman's hand
		move.b	obDelayAni(a0),obTimeFrame(a0)		; reset delay for emerald to rest in Eggman's hand

.juggleRadius:
		jsr	(CalcSine).l				; current angle around the circle; d0 = sin(angle), d1 = cos(angle)
		moveq	#0,d4					; clear d4 for juggle radius
		move.b	tcha_radius(a0),d4			; get current circle radius (fixed to $1C in this case)
		muls.w	d4,d1					; X-offset = cos(angle) * radius
		asr.l	#8,d1					; convert from fixed-point value
		muls.w	d4,d0					; Y-offset = sin(angle) * radius
		asr.l	#8,d0					; convert from fixed-point value
		add.w	tcha_origX(a0),d1			; move relative to anchor X-position
		add.w	tcha_origY(a0),d0			; move relative to anchor Y-position
		move.w	d1,obX(a0)				; set final X-position on circle
		move.w	d0,obScreenY(a0)			; set final Y-position on circle

	.return:
		rts						; return
; ===========================================================================

Map_EEgg:	include	"_maps/Try Again & End Eggman.asm"
