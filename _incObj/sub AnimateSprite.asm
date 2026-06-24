; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

AnimateSprite:
		moveq	#0,d0				; clear d0
		move.b	obAnim(a0),d0			; move animation number to d0
		cmp.b	obPrevAni(a0),d0		; has animation changed?
		beq.s	Anim_Run			; if not, branch
		move.b	d0,obPrevAni(a0)		; remember new animation ID
		move.b	#0,obAniFrame(a0)		; reset animation frame index
		move.b	#0,obTimeFrame(a0)		; reset animation frame duration
; ---------------------------------------------------------------------------

Anim_Run:
		subq.b	#1,obTimeFrame(a0)		; subtract 1 from frame duration
		bpl.s	Anim_Wait			; if time remains, do nothing

Anim_LoadNextFrame:
		add.w	d0,d0				; double animation ID for word-based indexing
		adda.w	(a1,d0.w),a1			; jump to appropriate animation script
		move.b	(a1),obTimeFrame(a0)		; load frame duration (always the first byte)
		moveq	#0,d1				; clear d1
		move.b	obAniFrame(a0),d1		; load current frame index number
		move.b	1(a1,d1.w),d0			; read next frame ID from script
		bmi.s	Anim_End_FF			; if ID is negative, this is a special flag, branch
; ---------------------------------------------------------------------------

Anim_SetFrameAndFlipFlags:
		move.b	d0,d1				; copy new frame ID
		andi.b	#$1F,d0				; limit possible frame IDs to $20 (other bits are occupied by flags)
		move.b	d0,obFrame(a0)			; write new frame ID to object

		; Handle aniXFlip and aniYFlip flags if specified in animation scripts.
		; This part is the main reason why non-Sonic objects are limited to only $20 frames,
		; and in later games this limitation was removed (flipping was instead exclusively
		; handled through separate, flipped sprite mappings sets, rather than animation flags).
		move.b	obStatus(a0),d0			; get object's current status flags
		rol.b	#3,d1				; shift aniXFlip and aniYFlip into low bits to match obStatus format
		eor.b	d0,d1				; xor with existing flip state of object
		andi.b	#sprite_xflip|sprite_yflip,d1	; limit result to only X and Y flip state
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0) ; clear previous X and Y flip states of objects
		or.b	d1,obRender(a0)			; set new X and Y flip states for object

		addq.b	#1,obAniFrame(a0)		; advance animation script to next index
; ---------------------------------------------------------------------------

Anim_Wait:
		rts					; animation processing done

; ===========================================================================
; ---------------------------------------------------------------------------
; Handle special animation flags ($FA-$FF)
; ---------------------------------------------------------------------------

; afEnd = return to beginning of animation (loop indefinitely)
Anim_End_FF:
		addq.b	#1,d0				; is the end flag = $FF?
		bne.s	Anim_End_FE			; if not, branch
		move.b	#0,obAniFrame(a0)		; restart the animation from the beginning
		move.b	1(a1),d0			; read first frame ID in script
		bra.s	Anim_SetFrameAndFlipFlags	; display new frame
; ===========================================================================

; afBack = go back (specified number) of frames in animation script
Anim_End_FE:
		addq.b	#1,d0				; is the end flag = $FE?
		bne.s	Anim_End_FD			; if not, branch
		move.b	2(a1,d1.w),d0			; read the next byte in the script
		sub.b	d0,obAniFrame(a0)		; decrement script index by that amount
		sub.b	d0,d1				; jump back d0 bytes in the script
		move.b	1(a1,d1.w),d0			; read new frame ID in script
		bra.s	Anim_SetFrameAndFlipFlags	; display new frame
; ===========================================================================

; afChange = change to a different animation
Anim_End_FD:
		addq.b	#1,d0				; is the end flag = $FD?
		bne.s	Anim_End_FC			; if not, branch
		move.b	2(a1,d1.w),obAnim(a0)		; read next byte, run that animation
; ---------------------------------------------------------------------------

; afRoutine = increment routine counter
Anim_End_FC:
		addq.b	#1,d0				; is the end flag = $FC?
		bne.s	Anim_End_FB			; if not, branch
		addq.b	#2,obRoutine(a0)		; advance primary routine counter
; ---------------------------------------------------------------------------

; afReset = reset animation and secondary object routine counter
Anim_End_FB:
		addq.b	#1,d0				; is the end flag = $FB?
		bne.s	Anim_End_FA			; if not, branch
		move.b	#0,obAniFrame(a0)		; restart the animation from the beginning
		clr.b	ob2ndRout(a0)			; reset secondary routine counter
; ---------------------------------------------------------------------------

; af2ndRoutine = increment secondary object routine counter
Anim_End_FA:
		addq.b	#1,d0				; is the end flag = $FA?
		bne.s	Anim_End			; if not, branch
		addq.b	#2,ob2ndRout(a0)		; advance secondary routine counter
; ---------------------------------------------------------------------------

Anim_End:
		rts					; special flag handling done (or ID between $80-$F9 was used)
; End of function AnimateSprite
