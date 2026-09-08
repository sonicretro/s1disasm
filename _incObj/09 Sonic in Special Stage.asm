; ===========================================================================
; ---------------------------------------------------------------------------
; Object 09 - Sonic the Hedgehog (in Special Stages)
; ---------------------------------------------------------------------------
sonss_maxspeed:		equ	$800		; Sonic's max speed when moving left/right
sonss_acceleration:	equ	$C		; Sonic's acceleration
sonss_deceleration:	equ	$40		; Sonic's deceleration
sonss_jumpspeed:	equ	$680		; Sonic's jump force
sonss_gravity:		equ	gravity-$E	; Sonic's gravity (=$2A, $E lower than main level gravity)
; ---------------------------------------------------------------------------

; Obj09:
SonicSpecial:
		tst.w	(v_debuguse).w				; is debug mode being used?
		beq.s	SonicSS_Normal				; if not, branch
		bsr.w	SS_FixCamera				; keep camera centered while in debug mode
		bra.w	DebugMode				; run debug mode instead of Sonic object
; ===========================================================================

; Obj09_Normal:
SonicSS_Normal:
		moveq	#0,d0					; clear d0
		move.b	obRoutine(a0),d0			; get current routine number
		move.w	SonicSS_Index(pc,d0.w),d1		; find appropriate entry in jump table
		jmp	SonicSS_Index(pc,d1.w)			; jump there
; ===========================================================================
; Obj09_Index:
SonicSS_Index:	dc.w SonicSS_Main-SonicSS_Index			; 0 - object init
		dc.w SonicSS_Control-SonicSS_Index		; 2 - main mode
		dc.w SonicSS_ExitStage-SonicSS_Index		; 4 - rotate stage while exiting
		dc.w SonicSS_ExitStage_Unused-SonicSS_Index	; 6 - unreachable secondary exiting state

sonss_touchedblock_id:	equ	objoff_30	; ID of currently touched block (byte)
sonss_touchedblock_ram: equ	objoff_32	; RAM address of currently touched block (longword)
sonss_timeout_updown:	equ	objoff_36	; timeout before an UP/DOWN block can be triggered again (byte)
sonss_timeout_r:	equ	objoff_37	; timeout before an R block can be triggered again (byte)
sonss_exittimer:	equ	objoff_38	; (unused) timer for the secondary exiting routine (word)
sonss_ghoststate:	equ	objoff_3A	; current solidity state of ghost blocks (byte)
; ===========================================================================

; Obj09_Main:
SonicSS_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; set to SonicSS_Control
		move.b	#sonic_roll_height,obHeight(a0)		; set rolling height
		move.b	#sonic_roll_width,obWidth(a0)		; set rolling width
		move.l	#Map_Sonic,obMap(a0)			; set mappings
		move.w	#ArtTile_Sonic,obGfx(a0)		; set VRAM location
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#0,obPriority(a0)			; set sprite priority to top

		move.b	#id_Roll,obAnim(a0)			; set to rolling animation
		bset	#2,obStatus(a0)				; set rolling flag
		bset	#1,obStatus(a0)				; set in-air flag
; ---------------------------------------------------------------------------

; Obj09_ChkDebug: SonicSS_ChkDebug:
SonicSS_Control: ; Routine 2
		tst.w	(f_debugmode).w				; is debug mode cheat enabled?
		beq.s	SonicSS_NoDebug				; if not, branch
		btst	#bitB,(v_jpadpress1).w			; is button B pressed?
		beq.s	SonicSS_NoDebug				; if not, branch
		move.w	#1,(v_debuguse).w			; change Sonic into a ring
	if FixBugs
		; A return command is missing here, causing Sonic to jump when
		; entering debug mode. This is likely due to this being forked
		; from an earlier version of the main Sonic object, because the
		; prototype has the same problem in stages.
		rts
	endif

; Obj09_NoDebug:
SonicSS_NoDebug:
		move.b	#0,sonss_touchedblock_id(a0)		; reset currently touched block to none (blank)

		moveq	#0,d0					; clear d0
		move.b	obStatus(a0),d0				; get Sonic's status flags
		andi.w	#%0010,d0				; limit to "is in air" flag
		move.w	SonicSS_Modes(pc,d0.w),d1		; use that as routine counter for the correct mode
		jsr	SonicSS_Modes(pc,d1.w)			; jump to that mode

		jsr	(Sonic_LoadGfx).l			; update Sonic's graphics if necessary (accessing Obj01)
		jmp	(DisplaySprite).l			; display Sonic's sprites


; ===========================================================================
; ---------------------------------------------------------------------------
; Modes for controlling Sonic in Special Stages
; ---------------------------------------------------------------------------
; Obj09_Modes:
SonicSS_Modes:	dc.w SonicSS_OnWall-SonicSS_Modes		; 0 - while touching a block
		dc.w SonicSS_InAir-SonicSS_Modes		; 2 - while airborne
; ===========================================================================

; Obj09_OnWall:
SonicSS_OnWall:	; While Sonic is touching a solid block
		bsr.w	SonicSS_Jump				; allow Sonic to jump from walls
		bsr.w	SonicSS_Move				; update position based on button inputs
		bsr.w	SonicSS_Fall				; apply gravity based on stage rotation
		bra.s	SonicSS_Display				; skip over
; ===========================================================================

; Obj09_InAir:
SonicSS_InAir:	; While Sonic is airborne from jumping or falling
		bsr.w	SonicSS_JumpHeight_Unused		; (disabled code) would have allowed to granularly control jump height
		bsr.w	SonicSS_Move				; update position based on button inputs
		bsr.w	SonicSS_Fall				; apply gravity based on stage rotation
; ---------------------------------------------------------------------------

; Obj09_Display:
SonicSS_Display:
		bsr.w	SonicSS_ChkItems_NonSolidActionBlock	; check if items without collision were touched (rings etc.)
		bsr.w	SonicSS_ChkItems_SolidActionBlock	; check if items with collision were touched (UP/DOWN blocks etc.)

		jsr	(SpeedToPos).l				; apply velocity and update position
		bsr.w	SS_FixCamera				; keep camera fixated on Sonic

		move.w	(v_ssangle).w,d0			; get current stage rotation angle
		add.w	(v_ssrotate).w,d0			; apply current rotation speed
		move.w	d0,(v_ssangle).w			; save new angle

		jsr	(Sonic_Animate).l			; animate Sonic (accessing Obj01)
		rts						; return
; End of function SonicSS_Control


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move Sonic in Special Stages based on D-Pad inputs
; ---------------------------------------------------------------------------

; Obj09_Move:
SonicSS_Move:
		btst	#bitL,(v_jpadhold2).w			; is left being held?
		beq.s	SonicSS_ChkRight			; if not, branch
		bsr.w	SonicSS_MoveLeft			; apply left side movement updates

; Obj09_ChkRight:
SonicSS_ChkRight:
		btst	#bitR,(v_jpadhold2).w			; is right being held?
		beq.s	SonicSS_CheckDpadLetGo			; if not, branch
		bsr.w	SonicSS_MoveRight			; apply right side movement updates
; ---------------------------------------------------------------------------

; This part is mostly identical to Sonic_CheckDpadLetGo in Obj01,
; except that the deceleration value is hardcoded.

; loc_1BA78:
SonicSS_CheckDpadLetGo:
		move.b	(v_jpadhold2).w,d0			; get held buttons
		andi.b	#btnL+btnR,d0				; is left or right being held?
		bne.s	SonicSS_AngleSpeed			; if yes, branch (don't decrease speed)
		move.w	obInertia(a0),d0			; get Sonic's current ground speed
		beq.s	SonicSS_AngleSpeed			; is he standing still? if yes, branch
		bmi.s	.movingleftward				; is he moving to the left? if yes, branch
		subi.w	#sonss_acceleration,d0			; reduce current rightward speed by acceleration
		bcc.s	.stillright				; if result is still to the right, branch
		move.w	#0,d0					; reset speed to zero on sign change

; loc_1BA94:
.stillright:
		move.w	d0,obInertia(a0)			; set Sonic's new ground speed
		bra.s	SonicSS_AngleSpeed			; skip over
; ===========================================================================

; loc_1BA9A:
.movingleftward:
		addi.w	#sonss_acceleration,d0			; reduce current leftward speed by acceleration
		bcc.s	.stillleft				; if result is still to the left, branch
		move.w	#0,d0					; reset speed to zero on sign change

; loc_1BAA4:
.stillleft:
		move.w	d0,obInertia(a0)			; set Sonic's new ground speed
; ---------------------------------------------------------------------------

; loc_1BAA8:
SonicSS_AngleSpeed:
		move.b	(v_ssangle).w,d0			; get current angle of the special stage rotation
		addi.b	#$20,d0					; rotate angle by 45 degrees clockwise
		andi.b	#$C0,d0					; snap angle to nearest multiple of 90 degrees
		neg.b	d0					; negate for sine calculation
		jsr	(CalcSine).l				; get sine and cosine values based on angle
		muls.w	obInertia(a0),d1			; multiply cosine value by current ground speed
		add.l	d1,obX(a0)				; add delta to X-velocity
		muls.w	obInertia(a0),d0			; multiply sine value by current ground speed
		add.l	d0,obY(a0)				; add delta to Y-velocity

		movem.l	d0-d1,-(sp)				; backup X and Y speed deltas
		move.l	obY(a0),d2				; get Sonic's current Y position
		move.l	obX(a0),d3				; get Sonic's current X position
		bsr.w	SonicSS_FindWall			; has Sonic touched a (solid) block?
		beq.s	.nowall					; if not, branch
		movem.l	(sp)+,d0-d1				; restore X and Y speed deltas
		sub.l	d1,obX(a0)				; undo delta addition to X-velocity
		sub.l	d0,obY(a0)				; undo delta addition to Y-velocity
		move.w	#0,obInertia(a0)			; reset ground speed
		rts						; return
; ===========================================================================

; loc_1BAF2:
.nowall:
		movem.l	(sp)+,d0-d1				; restore stack
		rts						; return
; End of function SonicSS_Move


; ---------------------------------------------------------------------------
; Subroutine handling Sonic's movement while moving to the left
; ---------------------------------------------------------------------------

; Obj09_MoveLeft:
SonicSS_MoveLeft:
		bset	#0,obStatus(a0)				; set X-flip flag (Sonic is facing left)

		move.w	obInertia(a0),d0			; get Sonic's current ground speed
		beq.s	.accelerate				; is Sonic standing still? if yes, branch
		bpl.s	.changeddirection			; has Sonic changed direction? if yes, branch

; loc_1BB06:
.accelerate:
		subi.w	#sonss_acceleration,d0			; increase leftward speed
		cmpi.w	#-sonss_maxspeed,d0			; is new speed above max speed?
		bgt.s	.nocap					; if not, branch
		move.w	#-sonss_maxspeed,d0			; cap Sonic's ground speed

; loc_1BB14:
.nocap:
		move.w	d0,obInertia(a0)			; set new ground speed
		rts
; ===========================================================================

; loc_1BB1A:
.changeddirection:
		subi.w	#sonss_deceleration,d0			; apply deceleration to current speed

		; Unknown, removed extra functionality. In Obj01, this part gives
		; a tiny speed boost on a sign change, but here it does nothing.
		bcc.s	.stilldecel    				; if still decelerating, branch
		nop						; no operation

; loc_1BB22:
.stilldecel:
		move.w	d0,obInertia(a0)			; set new ground speed
		rts						; return
; End of function SonicSS_MoveLeft


; ---------------------------------------------------------------------------
; Subroutine handling Sonic's movement while moving to the right
; ---------------------------------------------------------------------------

; Obj09_MoveRight:
SonicSS_MoveRight:
		bclr	#0,obStatus(a0)				; clear X-flip flag (Sonic is facing right)

		move.w	obInertia(a0),d0			; get Sonic's current ground speed
		bmi.s	.changedirection			; has Sonic changed direction? if yes, branch
		addi.w	#sonss_acceleration,d0			; increase rightward speed
		cmpi.w	#sonss_maxspeed,d0			; is new speed above max speed?
		blt.s	.nocap					; if not, branch
		move.w	#sonss_maxspeed,d0			; cap Sonic's ground speed

; loc_1BB42:
.nocap:
		move.w	d0,obInertia(a0)			; set new ground speed
		bra.s	.return					; skip over
; ===========================================================================

; loc_1BB48:
.changedirection:
		addi.w	#sonss_deceleration,d0			; apply deceleration to current speed

		; Unknown, removed extra functionality. In Obj01, this part gives
		; a tiny speed boost on a sign change, but here it does nothing.
		bcc.s	.stilldecel				; if still decelerating, branch
		nop						; no operation

; loc_1BB50:
.stilldecel:
		move.w	d0,obInertia(a0)			; set new ground speed

; locret_1BB54:
.return:
		rts						; return
; End of function SonicSS_MoveRight


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump in Special Stages
; ---------------------------------------------------------------------------

; Obj09_Jump:
SonicSS_Jump:
		move.b	(v_jpadpress2).w,d0			; get pressed buttons
		andi.b	#btnABC,d0				; is A, B or C pressed?
		beq.s	SonicSS_NoJump				; if not, branch

		move.b	(v_ssangle).w,d0			; get current angle of the special stage rotation
		andi.b	#$FC,d0					; snap to nearest multiple of 4 to match stage rotation
		neg.b	d0					; negate for sine calculation
		subi.b	#$40,d0					; rotate it perpendicularly for jump trajectory
		jsr	(CalcSine).l				; get sine and cosine values based on angle
		muls.w	#sonss_jumpspeed,d1			; apply jump force to the cosine angle
		asr.l	#8,d1					; shift result to lower word
		move.w	d1,obVelX(a0)				; set result as new X speed
		muls.w	#sonss_jumpspeed,d0			; apply jump force to the sine angle
		asr.l	#8,d0					; shift result to lower word
		move.w	d0,obVelY(a0)				; set result as new Y speed

		bset	#1,obStatus(a0)				; set in-air flag

		move.w	#sfx_Jump,d0				; set jump sound
		jsr	(QueueSound2).l				; play jumping sound

; Obj09_NoJump:
SonicSS_NoJump:
		rts						; return
; End of function SonicSS_Jump


; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to limit Sonic's upward vertical speed depending on
; how long the jump button was held after the initial jump. This likely got
; removed as it doesn't work (it doesn't account for the stage rotation).
; ---------------------------------------------------------------------------

; nullsub_2:
SonicSS_JumpHeight_Unused:
		rts						; immediately return
; ---------------------------------------------------------------------------

		; dead code
		move.w	#-$400,d1				; set maximum jump speed
		cmp.w	obVelY(a0),d1				; is Sonic already below the cap?
		ble.s	.return					; if yes, branch
		move.b	(v_jpadhold2).w,d0			; get held buttons
		andi.b	#btnABC,d0				; is A, B, or C being held?
		bne.s	.return					; if yes, branch
		move.w	d1,obVelY(a0)				; cap vertical speed if not holding ABC

; locret_1BBB4:
.return:
		rts						; return
; End of function SonicSS_JumpHeight


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fix the camera on Sonic's position (special stage)
; ---------------------------------------------------------------------------

SS_FixCamera:
		move.w	obY(a0),d2				; get Sonic's current Y position

		move.w	obX(a0),d3				; get Sonic's current X position
		move.w	(v_screenposx).w,d0			; get current horizontal camera position
		subi.w	#320/2,d3				; subtract half screen width from Sonic's X position
		bcs.s	.updatevertical				; did result underflow? if yes, branch
		sub.w	d3,d0					; subtract result from horizontal camera positon
		sub.w	d0,(v_screenposx).w			; set result as new horizontal camera position

; loc_1BBCE:
.updatevertical:
		move.w	(v_screenposy).w,d0			; get current vertical camera position
		subi.w	#224/2,d2				; subtract half screen height from Sonic's Y position
		bcs.s	.return					; did result underflow? if yes, branch
		sub.w	d2,d0					; subtract result from vertical camera positon
		sub.w	d0,(v_screenposy).w			; set result as new vertical camera position

; locret_1BBDE:
.return:
		rts						; return
; End of function SS_FixCamera


; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic while exiting a Special Stage (make it spin increasingly faster)
; ---------------------------------------------------------------------------

; Obj09_ExitStage:
SonicSS_ExitStage:
		addi.w	#ss_rotatespeed,(v_ssrotate).w		; increase spin speed during exit sequence
		cmpi.w	#$60*ss_rotatespeed,(v_ssrotate).w	; is the stage spinning fast enough? ($1800)
		bne.s	.noexit					; if not, branch
		move.b	#id_Level,(v_gamemode).w		; change game mode to Level to trigger exit in main loop

; loc_1BBF4:
.noexit:	; Impossible condition, see notes below
		cmpi.w	#2*($60*ss_rotatespeed),(v_ssrotate).w	; is stage spinning twice as fast as exit trigger above? ($3000)
		blt.s	.noexit2				; if not, branch
		move.w	#0,(v_ssrotate).w			; stop stage rotation
		move.w	#$4000,(v_ssangle).w			; keep rotation fixed to 90 degrees clockwise
		addq.b	#2,obRoutine(a0)			; advance to "SonicSS_ExitStage_Unused"
		move.w	#60,sonss_exittimer(a0)			; set delay timer in there to one second

; loc_1BC12:
.noexit2:
		move.w	(v_ssangle).w,d0			; get current stage rotation angle
		add.w	(v_ssrotate).w,d0			; apply current rotation speed
		move.w	d0,(v_ssangle).w			; save new angle

		jsr	(Sonic_Animate).l			; animate Sonic (accessing Obj01)
		jsr	(Sonic_LoadGfx).l			; update Sonic's graphics if necessary (accessing Obj01)
		bsr.w	SS_FixCamera				; keep camera centered on Sonic
		jmp	(DisplaySprite).l			; display Sonic's sprites
; End of function SonicSS_ExitStage


; ---------------------------------------------------------------------------
; Unused secondary exiting mode. This would technically be triggered once
; the stage is spinning fast enough during the exiting sequence above, but
; this will in practice never be the case before the stage is forcibly exited
; in the main game mode loop, as the code above already changes the game mode
; before it has any chance to spin fast enough. It's likely that this was a
; leftover from the prototype, where the stage would restart indefinitely.
; ---------------------------------------------------------------------------

; Obj09_Exit2: SonicSS_Exit2:
SonicSS_ExitStage_Unused:
		subq.w	#1,sonss_exittimer(a0)			; decrement remaining delay
		bne.s	.timeremaining				; if time remains, branch
		move.b	#id_Level,(v_gamemode).w		; change game mode to Level to trigger exit in main loop

; loc_1BC40:
.timeremaining:
		jsr	(Sonic_Animate).l			; animate Sonic (accessing Obj01)
		jsr	(Sonic_LoadGfx).l			; update Sonic's graphics if necessary (accessing Obj01)
		bsr.w	SS_FixCamera				; keep camera centered on Sonic
		jmp	(DisplaySprite).l			; display Sonic's sprites
; End of function SonicSS_ExitStage_Unused


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to apply gravity to Sonic based on the current layout rotation
; ---------------------------------------------------------------------------

; Obj09_Fall:
SonicSS_Fall:
		move.l	obY(a0),d2				; get Sonic's current Y position
		move.l	obX(a0),d3				; get Sonic's current X position
		move.b	(v_ssangle).w,d0			; get current angle of the special stage rotation
		andi.b	#$FC,d0					; snap to nearest multiple of 4 to match stage rotation
		jsr	(CalcSine).l				; get sine and cosine values based on angle

		move.w	obVelX(a0),d4				; get Sonic's current X velocity
		ext.l	d4					; extend X velocity to longword
		asl.l	#8,d4					; shift it to upper word
		muls.w	#sonss_gravity,d0			; multiply sine value by gravitational force
		add.l	d4,d0					; add shifted X velocity to it
		move.w	obVelY(a0),d4				; get Sonic's current Y velocity
		ext.l	d4					; extend Y velocity to longword
		asl.l	#8,d4					; shift it to upper word
		muls.w	#sonss_gravity,d1			; multiply cosine value by gravitational force
		add.l	d4,d1					; add shifted Y velocity to it

		add.l	d0,d3					; add new X delta to target X position
		bsr.w	SonicSS_FindWall			; check if the new result would make Sonic clip through a left/right wall
		beq.s	.noleftrightwall			; if not, branch
		sub.l	d0,d3					; undo X delta addition
		moveq	#0,d0					; clear d0
		move.w	d0,obVelX(a0)				; stop Sonic's horizonal momentum
		bclr	#1,obStatus(a0)				; clear in-air flag

		add.l	d1,d2					; add new Y delta to target Y position
		bsr.w	SonicSS_FindWall			; check if the new result would make Sonic clip through a floor wall
		beq.s	.nofloor				; if not, branch
		sub.l	d1,d2					; undo Y delta addition
		moveq	#0,d1					; clear d1
		move.w	d1,obVelY(a0)				; stop Sonic's vertical momentum
		rts						; return
; ===========================================================================

; loc_1BCB0:
.noleftrightwall:
		add.l	d1,d2					; add new Y delta to target Y position
		bsr.w	SonicSS_FindWall			; check if the new result would make Sonic clip through a floor wall
		beq.s	.airborne				; if not, branch
		sub.l	d1,d2					; undo Y delta addition
		moveq	#0,d1					; clear d1
		move.w	d1,obVelY(a0)				; stop Sonic's vertical momentum
		bclr	#1,obStatus(a0)				; clear in-air flag

; loc_1BCC6:
.nofloor:
		asr.l	#8,d0					; shift new X speed back to word range
		asr.l	#8,d1					; shift new Y speed back to word range
		move.w	d0,obVelX(a0)				; set new X velocity
		move.w	d1,obVelY(a0)				; set new Y velocity
		rts						; return
; ===========================================================================

; loc_1BCD4:
.airborne:
		asr.l	#8,d0					; shift new X speed back to word range
		asr.l	#8,d1					; shift new Y speed back to word range
		move.w	d0,obVelX(a0)				; set new X velocity
		move.w	d1,obVelY(a0)				; set new Y velocity
		bset	#1,obStatus(a0)				; set in-air flag
		rts						; return
; End of function SonicSS_Fall


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to detect a Special Stage wall at a given position
; 
; input:
;	d2 = y position (including subpixel)
;	d3 = x position (including subpixel)
; 
; output:
;	d4 = id of wall or item
;	d5 = flag: 0 = no collision (e.g. rings); -1 = collision with solid wall
; ---------------------------------------------------------------------------

; sub_1BCE8:
SonicSS_FindWall:
		lea	(v_sslayout_base).l,a1			; get special stage layout in RAM

		moveq	#0,d4					; clear d4
		swap	d2					; move main pixel Y position into lower word
		move.w	d2,d4					; copy that word to d4
		swap	d2					; revert swapping
		addi.w	#20+(ss_blocksize*2),d4			; manually adjust target Y position by 68 pixels down
		divu.w	#ss_blocksize,d4			; divide by size of SS blocks (24 pixels)
		mulu.w	#ss_layout_rowlength,d4			; multiply by bytes per layout row
		adda.l	d4,a1					; add result to a1 to find current row Sonic is in

		moveq	#0,d4					; clear d4
		swap	d3					; move main pixel X position into lower word
		move.w	d3,d4					; copy that word to d4
		swap	d3					; revert swapping
		addi.w	#20,d4					; manually adjust target X position by 20 pixels to the right
		divu.w	#ss_blocksize,d4			; divide by size of SS blocks (24 pixels)
		adda.w	d4,a1					; add result to a1 to find current column Sonic is in

		; a1 is now pointing to the exact byte (row/column) within the layout Sonic is in.
		; From there, check if this position intersects with any of the four nearest blocks
		; around Sonic, checking them one by one. If any of them are solid, d5 gets set.

		moveq	#0,d5					; set to no collision detected

		move.b	(a1)+,d4				; get top-left block
		bsr.s	SonicSS_FindWall_CheckType		; check for collision
		move.b	(a1)+,d4				; get top-right block
		bsr.s	SonicSS_FindWall_CheckType		; check for collision
		adda.w	#ss_layout_rowlength-2,a1		; advance to next row (2 bytes were already advanced)
		move.b	(a1)+,d4				; get bottom-left block
		bsr.s	SonicSS_FindWall_CheckType		; check for collision
		move.b	(a1)+,d4				; get bottom-right block
		bsr.s	SonicSS_FindWall_CheckType		; check for collision

		tst.b	d5					; unset Z-flag if any of the four blocks were solid
		rts						; return with result in CCR
; ===========================================================================

; sub_1BD30:
SonicSS_FindWall_CheckType:
		beq.s	.return					; if it's a blank block ($00), branch
		cmpi.b	#id_SS_1Up,d4				; is block ID = $28? (1-Up)
		beq.s	.return					; if yes, branch
		cmpi.b	#id_SS_Ring,d4				; is block ID < $3A? (solid blocks, ring is first non-solid)
		blo.s	.solidblock				; if yes, branch
		; IDs $3A-$4A are non-solid blocks (e.g. rings)
		cmpi.b	#id_SS_Glass_Ani1,d4			; is block ID >= $4B (special blocks for broken glass)
		bhs.s	.solidblock				; if yes, branch

; locret_1BD44:
.return:
		rts						; return with d5 unchanged
; ===========================================================================

; loc_1BD46:
.solidblock:
		move.b	d4,sonss_touchedblock_id(a0)		; remember ID of touched block
		move.l	a1,sonss_touchedblock_ram(a0)		; remember RAM address of touched block
		moveq	#-1,d5					; set flag that a solid block was found
		rts						; return with d5 changed
; End of function SonicSS_FindWall


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check for collision blocks that have no solidity (rings etc.)
; 
; output:
;	d4 = (unused) 0 if block is a regular item or blank; -1 otherwise
; ---------------------------------------------------------------------------

; Obj09_ChkItems: SonicSS_ChkItems:
SonicSS_ChkItems_NonSolidActionBlock:
		lea	(v_sslayout_base).l,a1			; get special stage layout in RAM

		moveq	#0,d4					; clear d4
		move.w	obY(a0),d4				; get Sonic's Y position
		addi.w	#80,d4					; manually adjust a bit
		divu.w	#ss_blocksize,d4			; divide by size of SS blocks (24 pixels)
		mulu.w	#ss_layout_rowlength,d4			; multiply by bytes per layout row
		adda.l	d4,a1					; add result to a1 to find current row Sonic is in

		moveq	#0,d4					; clear d4
		move.w	obX(a0),d4				; get Sonic's X position
		addi.w	#32,d4					; manually adjust a bit
		divu.w	#ss_blocksize,d4			; divide by size of SS blocks (24 pixels)
		adda.w	d4,a1					; add result to a1 to find current column Sonic is in

		move.b	(a1),d4					; is Sonic touching a non-blank block?
		bne.s	SonicSS_ChkRing				; if yes, check which one it was

		tst.b	sonss_ghoststate(a0)			; has ghost block or its trigger been passed?
		bne.w	SonicSS_MakeGhostSolid			; if yes, branch

		moveq	#0,d4					; blank
		rts						; return
; ===========================================================================

; Obj09_ChkCont:
SonicSS_ChkRing:
		cmpi.b	#id_SS_Ring,d4				; is the item a ring?
		bne.s	SonicSS_Chk1Up				; if not, branch

		bsr.w	SS_FindFreeAnimationSlot		; find a free animation slot
		bne.s	SonicSS_GetContinue			; if none are free, branch
		_move.b	#1,ss_ani_id(a2)			; set to SS_AniRingSparks
		move.l	a1,ss_ani_block(a2)			; store address of this block for animation

; Obj09_GetCont:
SonicSS_GetContinue:
		jsr	(CollectRing).l				; add a ring
		cmpi.w	#ss_continue_rings,(v_rings).w		; check if you now have 50 rings
		blo.s	SonicSS_NoContinue			; if not, branch
		bset	#0,(v_lifecount).w			; remember that a continue has already been awarded
		bne.s	SonicSS_NoContinue			; if flag was already set, branch
		addq.b	#1,(v_continues).w			; add 1 to number of continues
		move.w	#sfx_Continue,d0			; set extra continue sound
		jsr	(QueueSound1).l				; play it

; Obj09_NoCont:
SonicSS_NoContinue:
		moveq	#0,d4					; regular item
		rts						; return
; ===========================================================================

; Obj09_Chk1Up:
SonicSS_Chk1Up:
		cmpi.b	#id_SS_1Up,d4				; is the item an extra life?
		bne.s	SonicSS_ChkEmerald			; if not, branch

		bsr.w	SS_FindFreeAnimationSlot		; find a free animation slot
		bne.s	SonicSS_Get1Up				; if none are free, branch
		_move.b	#3,ss_ani_id(a2)			; set to SS_Ani1Up
		move.l	a1,ss_ani_block(a2)			; store address of this block for animation

; Obj09_Get1Up:
SonicSS_Get1Up:
		addq.b	#1,(v_lives).w				; add 1 to number of lives
		addq.b	#1,(f_lifecount).w			; update the lives counter
		move.w	#bgm_ExtraLife,d0			; set extra life music
		jsr	(QueueSound1).l				; play it

		moveq	#0,d4					; regular item
		rts						; return
; ===========================================================================

; Obj09_ChkEmer:
SonicSS_ChkEmerald:
		cmpi.b	#id_SS_Emerald1_Blue,d4			; is the item an emerald? (lower bound)
		blo.s	SonicSS_ChkGhost			; if not, branch
		cmpi.b	#id_SS_Emerald6_Grey,d4			; is the item an emerald? (upper bound)
		bhi.s	SonicSS_ChkGhost			; if not, branch

		bsr.w	SS_FindFreeAnimationSlot		; find a free animation slot
		bne.s	SonicSS_GetEmerald			; if none are free, branch
		_move.b	#5,ss_ani_id(a2)			; set to SS_AniEmeraldSparks
		move.l	a1,ss_ani_block(a2)			; store address of this block for animation

; Obj09_GetEmer:
SonicSS_GetEmerald:
		cmpi.b	#ss_emeralds_num,(v_emeralds).w		; do you already have all the emeralds?
		beq.s	SonicSS_NoEmerald			; if yes, branch (probably a failsafe)

		subi.b	#id_SS_Emerald1_Blue,d4			; make emerald block ID 0-based
		moveq	#0,d0					; clear d0
		move.b	(v_emeralds).w,d0			; get number of emeralds already collected
		lea	(v_emldlist).w,a2			; get array of previously collected emerald colors
		move.b	d4,(a2,d0.w)				; insert newly collected emerald color as newest entry

		addq.b	#1,(v_emeralds).w			; add 1 to number of emeralds

; Obj09_NoEmer:
SonicSS_NoEmerald:
		move.w	#bgm_Emerald,d0				; set to emerald music
		jsr	(QueueSound2).l				; play it

		moveq	#0,d4					; regular item
		rts						; return
; ===========================================================================

; Obj09_ChkGhost:
SonicSS_ChkGhost:
		cmpi.b	#id_SS_Ghost,d4				; is the item a ghost block?
		bne.s	SonicSS_ChkGhostTag			; if not, branch

		move.b	#1,sonss_ghoststate(a0)			; mark the ghost block as "passed" (one-way)

; Obj09_ChkGhostTag:
SonicSS_ChkGhostTag:
		cmpi.b	#id_SS_InvGhostTrigger,d4		; is the item an invisible switch for ghost blocks?
		bne.s	SonicSS_NoItemBlock			; if not, branch

		cmpi.b	#1,sonss_ghoststate(a0)			; have the ghost blocks been passed?
		bne.s	SonicSS_NoItemBlock			; if not, branch
		move.b	#2,sonss_ghoststate(a0)			; trigger SonicSS_MakeGhostSolid

; Obj09_NoGhost:
SonicSS_NoItemBlock:
		moveq	#-1,d4					; is a ghost block or other non-item block
		rts						; return


; ---------------------------------------------------------------------------
; Turn all ghost blocks in the stage layout into solid blocks, if flag is set
; ---------------------------------------------------------------------------

; Obj09_MakeGhostSolid:
SonicSS_MakeGhostSolid:
		cmpi.b	#2,sonss_ghoststate(a0)			; have ghost block and then an invisible switch been passed?
		bne.s	SonicSS_GhostNotSolid			; if not, branch

		lea	(v_sslayout_actual).l,a1		; get start location of actual stage layout
		moveq	#(v_sslayout_end-v_sslayout_actual)/ss_layout_rowlength-1,d1 ; iterate through all rows
.nextrow:	moveq	#(ss_layout_rowlength/2)-1,d2		; iterate through all blocks in row
.checkblock:	cmpi.b	#id_SS_Ghost,(a1)			; is the item a ghost block?
		bne.s	.nextblock				; if not, branch
		move.b	#id_SS_RedWhite,(a1)			; replace ghost block with a solid red/white block
.nextblock:	addq.w	#1,a1					; advance to next block in row
		dbf	d2,.checkblock				; loop until row is done
		lea	ss_layout_rowlength/2(a1),a1		; advance to next row
		dbf	d1,.nextrow				; loop until all rows are done

; Obj09_GhostNotSolid:
SonicSS_GhostNotSolid:
		clr.b	sonss_ghoststate(a0)			; clear ghost trigger flag so this doesn't run again

		moveq	#0,d4					; not a ghost block (by itself at least)
		rts						; return
; End of function SonicSS_ChkItems_NotSolid


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check for collision blocks that have solidity
; ---------------------------------------------------------------------------

; Obj09_ChkItems2: SonicSS_ChkItems2:
SonicSS_ChkItems_SolidActionBlock:
		move.b	sonss_touchedblock_id(a0),d0		; was any solid block found during calls to SonicSS_FindWall?
		bne.s	SonicSS_ChkBumper			; if yes, check which one it was

		subq.b	#1,sonss_timeout_updown(a0)		; decrement the UP/DOWN blocks disable timeout
		bpl.s	.decrement_r				; if timeout remains, branch
		move.b	#0,sonss_timeout_updown(a0)		; re-enable UP/DOWN blocks

; loc_1BEA0:
.decrement_r:
		subq.b	#1,sonss_timeout_r(a0)			; decrement the R block disable timeout
		bpl.s	.return					; if timeout remains, branch
		move.b	#0,sonss_timeout_r(a0)			; re-enable R blocks

; locret_1BEAC:
.return:
		rts						; return
; ===========================================================================

; Obj09_ChkBumper:
SonicSS_ChkBumper:
		cmpi.b	#id_SS_Bumper,d0			; is the item a bumper?
		bne.s	SonicSS_ChkGOAL				; if not, branch

		move.l	sonss_touchedblock_ram(a0),d1		; get RAM location of touched bumper
		subi.l	#v_sslayout_base+1,d1			; subtract by base RAM offset to get logical address
		move.w	d1,d2					; copy for second check

		andi.w	#ss_layout_rowlength-1,d1		; limit to a single row ($7F)
		mulu.w	#ss_blocksize,d1			; multiply by size per block
		subi.w	#20,d1					; manually adjust a bit; d1 now is bumper X coordinate

		lsr.w	#7,d2					; divide by row length ($80)
		andi.w	#ss_layout_rowlength-1,d2		; limit to a single column ($7F)
		mulu.w	#ss_blocksize,d2			; multiply by size per block
		subi.w	#20+(ss_blocksize*2),d2			; manually adjust a bit; d1 now is bumper Y coordinate

		sub.w	obX(a0),d1				; subtract Sonic's X-pos from bumper X coordinate
		sub.w	obY(a0),d2				; subtract Sonic's Y-pos from bumper Y coordinate
		jsr	(CalcAngle).l				; calculate the angle of Sonic to target - atan2 of (dx,dy)
		jsr	(CalcSine).l				; calculate the sine (d0=Y-part) and cosine (d1=X-part) of the input angle in d0
		muls.w	#-$700,d1				; multiply X-speed by bumper force
		asr.l	#8,d1					; move result to lower word
		move.w	d1,obVelX(a0)				; set final result to Sonic's X-speed
		muls.w	#-$700,d0				; multiply Y-speed by bumper force
		asr.l	#8,d0					; move result to lower word
		move.w	d0,obVelY(a0)				; set final result to Sonic's Y-speed

		bset	#1,obStatus(a0)				; set in-air flag

		bsr.w	SS_FindFreeAnimationSlot		; find a free animation slot
		bne.s	SonicSS_BumpSnd				; if none are free, branch
		_move.b	#2,ss_ani_id(a2)			; set to SS_AniBumper
		move.l	sonss_touchedblock_ram(a0),d0		; get location in RAM of touched block
		subq.l	#1,d0					; actual touched block is the byte before it
		move.l	d0,ss_ani_block(a2)			; store address of this block for animation

; Obj09_BumpSnd:
SonicSS_BumpSnd:
		move.w	#sfx_Bumper,d0				; set bumper sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

; Obj09_GOAL:
SonicSS_ChkGOAL:
		cmpi.b	#id_SS_GOAL,d0				; is the item a "GOAL"?
		bne.s	SonicSS_ChkUP				; if not, branch

		addq.b	#2,obRoutine(a0)			; run routine "SonicSS_ExitStage"

		move.w	#sfx_SSGoal,d0				; set "GOAL" sound
		jsr	(QueueSound2).l				; play it
		rts						; return
; ===========================================================================

; Obj09_UPblock:
SonicSS_ChkUP:
		cmpi.b	#id_SS_UP,d0				; is the item an "UP" block?
		bne.s	SonicSS_ChkDOWN				; if not, branch

		tst.b	sonss_timeout_updown(a0)		; has an UP or DOWN block been touched recently?
		bne.w	SonicSS_NoSolidActionBlock		; if yes, disable action until timeout has expired
		move.b	#ss_timeout,sonss_timeout_updown(a0)	; set timeout to next action to half a second

	if FixBugs
		move.w	(v_ssrotate).w,d0			; get current rotation speed
		bpl.s	.pos					; if it's going clockwise, branch
		neg.w	d0					; if it's going counter-clockwise, negate
	.pos:	cmpi.w	#ss_rotatespeed*2,d0			; is stage already rotating at fast speed?
		bhs.s	SonicSS_UPsnd				; if yes, branch (prevent speeding up again)
	else
		; This check only works correctly if the base rotation speed is EXACTLY $40 (bit 6 = $40).
		; It is by default, but altering the default speed in GM_Special will break UP/DOWN blocks.
		btst	#6,(v_ssrotate+1).w			; is stage already at fast speed? (either rotation)
		beq.s	SonicSS_UPsnd				; if yes, branch (prevent speeding up twice)
	endif

		asl.w	(v_ssrotate).w				; multiply current stage rotation speed by 2

		; If this "UP" block successfully sped up the rotation, change it to a "DOWN" block
		movea.l	sonss_touchedblock_ram(a0),a1		; get location in RAM of touched block
		subq.l	#1,a1					; actual touched block is the byte before it
		move.b	#id_SS_DOWN,(a1)			; change block to a "DOWN" block

; Obj09_UPsnd:
SonicSS_UPsnd:
		move.w	#sfx_SSItem,d0				; set blip sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

; Obj09_DOWNblock:
SonicSS_ChkDOWN:
		cmpi.b	#id_SS_DOWN,d0				; is the item a "DOWN" block?
		bne.s	SonicSS_ChkR				; if not, branch

		tst.b	sonss_timeout_updown(a0)		; has an UP or DOWN block been touched recently?
		bne.w	SonicSS_NoSolidActionBlock		; if yes, disable action until timeout has expired
		move.b	#ss_timeout,sonss_timeout_updown(a0)	; set timeout to next action to half a second

	if FixBugs
		move.w	(v_ssrotate).w,d0			; get current rotation speed
		bpl.s	.pos					; if it's going clockwise, branch
		neg.w	d0					; if it's going counter-clockwise, negate
	.pos:	cmpi.w	#ss_rotatespeed,d0			; is stage already rotating at slow speed?
		bls.s	SonicSS_DOWNsnd				; if yes, branch (prevent slowing down again)
	else
		; This check only works correctly if the base rotation speed is EXACTLY $40 (bit 6 = $40).
		; It is by default, but altering the default speed in GM_Special will break UP/DOWN blocks.
		btst	#6,(v_ssrotate+1).w			; is stage already at slow speed? (either rotation)
		bne.s	SonicSS_DOWNsnd				; if yes, branch (prevent slowing down twice)
	endif

		asr.w	(v_ssrotate).w				; divide current stage rotation speed by 2

		; If this "DOWN" block successfully slowed down the rotation, change it to an "UP" block
		movea.l	sonss_touchedblock_ram(a0),a1		; get location in RAM of touched block
		subq.l	#1,a1					; actual touched block is the byte before it
		move.b	#id_SS_UP,(a1)				; change block to an "UP" block

; Obj09_DOWNsnd:
SonicSS_DOWNsnd:
		move.w	#sfx_SSItem,d0				; set blip sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

; Obj09_Rblock:
SonicSS_ChkR:
		cmpi.b	#id_SS_R,d0				; is the item an "R" block?
		bne.s	SonicSS_ChkGlass			; if not, branch

		tst.b	sonss_timeout_r(a0)			; has an R block been touched recently?
		bne.w	SonicSS_NoSolidActionBlock		; if yes, disable action until timeout has expired
		move.b	#ss_timeout,sonss_timeout_r(a0)		; set timeout to next action to half a second

		bsr.w	SS_FindFreeAnimationSlot		; find a free animation slot
		bne.s	SonicSS_RevStage			; if none are free, branch
		_move.b	#4,ss_ani_id(a2)			; set to SS_AniReverse
		move.l	sonss_touchedblock_ram(a0),d0		; get location in RAM of touched block
		subq.l	#1,d0					; actual touched block is the byte before it
		move.l	d0,ss_ani_block(a2)			; store address of this block for animation

; Obj09_RevStage:
SonicSS_RevStage:
		neg.w	(v_ssrotate).w				; reverse stage rotation, preserving speed

		move.w	#sfx_SSItem,d0				; set blip sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

; Obj09_ChkGlass:
SonicSS_ChkGlass:
		cmpi.b	#id_SS_Glass1_Blue,d0			; is the item a (blue) glass block?
		beq.s	SonicSS_Glass				; if yes, branch
		cmpi.b	#id_SS_Glass2_Green,d0			; is the item a (green) glass block?
		beq.s	SonicSS_Glass				; if yes, branch
		cmpi.b	#id_SS_Glass3_Yellow,d0			; is the item a (yellow) glass block?
		beq.s	SonicSS_Glass				; if yes, branch
		cmpi.b	#id_SS_Glass4_Pink,d0			; is the item a (pink) glass block?
		bne.s	SonicSS_NoSolidActionBlock		; if not, branch

; Obj09_Glass:
SonicSS_Glass:
		bsr.w	SS_FindFreeAnimationSlot		; find a free animation slot
		bne.s	SonicSS_GlassSnd			; if none are free, branch
		_move.b	#6,ss_ani_id(a2)			; set to SS_AniGlassBlock
		movea.l	sonss_touchedblock_ram(a0),a1		; get location in RAM of touched block
		subq.l	#1,a1					; actual touched block is the byte before it
		move.l	a1,ss_ani_block(a2)			; store address of this block for animation

		move.b	(a1),d0					; get true ID of touched block
		addq.b	#1,d0					; advance to next glass type
		cmpi.b	#id_SS_Glass4_Pink,d0			; would new ID exceed pink glass blocks?
		bls.s	SonicSS_GlassUpdate			; if not, branch
		clr.b	d0					; otherwise, remove the glass block after pink ones

; Obj09_GlassUpdate:
SonicSS_GlassUpdate:
		move.b	d0,ss_ani_block(a2)			; prepare updating glass with weaker version (see SS_AniGlassBlock)

; Obj09_GlassSnd:
SonicSS_GlassSnd:
		move.w	#sfx_SSGlass,d0				; set glass block sound
		jmp	(QueueSound2).l				; play it
; ===========================================================================

; Obj09_NoGlass:
SonicSS_NoSolidActionBlock:
		rts						; block is no regular solid action block
; End of function SonicSS_ChkItems_Solid
