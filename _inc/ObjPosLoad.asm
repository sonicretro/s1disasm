; ---------------------------------------------------------------------------
; Subroutine to load a level's objects
; 
;	uses d0.l, d1.w, d2.l, d6.l, a0, a1, a2
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)

; ===========================================================================
OPL_Index:	dc.w OPL_Main-OPL_Index
		dc.w OPL_Next-OPL_Index
; ===========================================================================

; Spawn window is initially -256px to -128px (relative to v_screenposx)
; This is moved to -128px to 640px during OPL_Next so that all on-screen objects load at level start

OPL_Main:
		addq.b	#2,(v_opl_routine).w		; goto OPL_Next next
		move.w	(v_zone_act).w,d0		; get zone/act numbers
		lsl.b	#6,d0
		lsr.w	#4,d0				; combine zone/act into single number, times 4
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1				; copy index pointer to a1
		adda.w	(a0,d0.w),a0			; jump to objpos list for specified zone/act
		move.l	a0,(v_opl_data).w		; copy objpos list address
		move.l	a0,(v_opl_data+4).w
		adda.w	2(a1,d0.w),a1			; jump to secondary objpos list (this is always blank)
		move.l	a1,(v_opl_data+8).w		; copy objpos list address
		move.l	a1,(v_opl_data+$C).w
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+			; start respawn counter at 1
	if FixBugs
		move.w	#(v_objstate_end-v_objstate-2)/4-1,d0
	else
		; This clears longwords, but the loop counter is measured in words!
		; This causes $17C bytes to be cleared instead of $BE.
		move.w	#(v_objstate_end-v_objstate-2)/2-1,d0
	endif

	; OPL_ClrList:
	.clear_respawn_list:
		clr.l	(a2)+
		dbf	d0,.clear_respawn_list		; clear object respawn list

	if FixBugs
		; Clear the last word, since the above loop only does longwords.
		if (v_objstate_end-v_objstate-2)&2
			clr.w	(a2)+
		endif
	endif

		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		subi.w	#128,d6				; d6 = 128px to left of screen
		bcc.s	.use_screen_x			; branch if camera is > 128px from left boundary
		moveq	#0,d6				; assume 0 if camera is close to left boundary

	; loc_D93C:
	.use_screen_x:
		andi.w	#$FF80,d6			; round down to nearest $80
		movea.l	(v_opl_data).w,a0		; get objpos data pointer

; loc_D944:
.loop_find_right_init:
		cmp.w	(a0),d6				; (a0) = x pos of object; d6 = edge of spawn window
		bls.s	.found_right			; branch if object is right of edge (1st object outside spawn window)
		tst.b	4(a0)				; 4(a0) = object id and remember state flag
		bpl.s	.no_respawn			; branch if no remember flag found
		move.b	(a2),d2				; d2 = respawn state
		addq.b	#1,(a2)				; increment respawn list counter

	; loc_D952:
	.no_respawn:
		addq.w	#6,a0				; goto next object in objpos list
		bra.s	.loop_find_right_init		; loop until object is found within window
; ===========================================================================

; loc_D956:
.found_right:
		move.l	a0,(v_opl_data).w		; save pointer for objpos, 128px left of screen
		movea.l	(v_opl_data+4).w,a0		; get first objpos in list again
		subi.w	#128,d6				; d6 = 256px to left of screen
		bcs.s	.found_left			; branch if camera is close to left boundary

; loc_D964:
.loop_find_left_init:
		cmp.w	(a0),d6				; (a0) = x pos of object; d6 = edge of spawn window
		bls.s	.found_left			; branch if object is right of edge (1st object inside spawn window)
		tst.b	4(a0)				; 4(a0) = object id and remember state flag
		bpl.s	.no_respawn2			; branch if no remember flag found
		addq.b	#1,1(a2)			; increment second respawn list counter

	; loc_D972:
	.no_respawn2:
		addq.w	#6,a0				; goto next object in objpos list
		bra.s	.loop_find_left_init		; loop until object is found within window
; ===========================================================================

; loc_D976:
.found_left:
		move.l	a0,(v_opl_data+4).w		; save pointer for objpos, 256px left of screen
		move.w	#-1,(v_opl_screen).w		; start screen at -1 so OPL_Next thinks it's moving right
		; fall-through to OPL_Next...

; ---------------------------------------------------------------------------
; Primary level object loading routine
; ---------------------------------------------------------------------------

OPL_Next:
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6			; d6 = camera x pos rounded down to nearest $80
		cmp.w	(v_opl_screen).w,d6		; compare to previous screen position
		beq.w	OPL_NoMove			; branch if screen hasn't moved
		bge.s	OPL_MovedRight			; branch if screen is right of previous position (or if level just started)
; ---------------------------------------------------------------------------

OPL_MovedLeft:
		move.w	d6,(v_opl_screen).w		; update screen position
		movea.l	(v_opl_data+4).w,a0		; jump to objpos on left side of window
		subi.w	#128,d6				; d6 = 128px to left of screen
		bcs.s	.found_left			; branch if camera is close to left boundary

; loc_D9A6:
.loop_find_left:
		cmp.w	-6(a0),d6			; read objpos backwards
		bge.s	.found_left			; branch if object is outside spawn window
		subq.w	#6,a0				; update pointer
		tst.b	4(a0)				; 4(a0) = object id and remember state flag
		bpl.s	.no_respawn			; branch if no remember flag found
		subq.b	#1,1(a2)			; decrement second respawn list counter
		move.b	1(a2),d2			; get respawn counter

	; loc_D9BC:
	.no_respawn:
		bsr.w	OPL_SpawnObj			; check respawn flag and spawn object
		bne.s	.failed_to_spawn		; branch if spawn fails
		subq.w	#6,a0				; goto previous object in objpos list
		bra.s	.loop_find_left			; loop until object is found within window
; ===========================================================================

; loc_D9C6:
.failed_to_spawn:
		tst.b	4(a0)				; did object that failed to spawn have remember flag set?
		bpl.s	.no_respawn2			; if not, branch
		addq.b	#1,1(a2)			; revert decrementing second respawn list counter from above

	; loc_D9D0:
	.no_respawn2:
		addq.w	#6,a0				; advance objpos

; loc_D9D2:
.found_left:
		move.l	a0,(v_opl_data+4).w		; save pointer for objpos
		movea.l	(v_opl_data).w,a0		; jump to objpos on right side of window
		addi.w	#128+320+320,d6			; d6 = 320px to right of screen

; loc_D9DE:
.loop_find_right:
		cmp.w	-6(a0),d6			; read objpos backwards
		bgt.s	.found_right			; branch if object is within spawn window
		tst.b	-2(a0)				; -2(a0) = object id and remember state flag
		bpl.s	.no_respawn3			; branch if no remember flag found
		subq.b	#1,(a2)				; decrement respawn list counter

	; loc_D9EC:
	.no_respawn3:
		subq.w	#6,a0				; goto previous object in objpos list
		bra.s	.loop_find_right
; ===========================================================================

; loc_D9F0:
.found_right:
		move.l	a0,(v_opl_data).w		; save pointer for objpos
		rts
; End of function OPL_MovedLeft
; ===========================================================================

; loc_D9F6:
OPL_MovedRight:
		move.w	d6,(v_opl_screen).w		; update screen position
		movea.l	(v_opl_data).w,a0		; jump to objpos on right side of window
		addi.w	#320+320,d6			; d6 = 320px to right of screen

; loc_DA02:
.loop_find_right:
		cmp.w	(a0),d6				; (a0) = x pos of object; d6 = right edge of spawn window
		bls.s	.found_right			; branch if object is outside spawn window
		tst.b	4(a0)
		bpl.s	.no_respawn
		move.b	(a2),d2
		addq.b	#1,(a2)

	; loc_DA10:
	.no_respawn:
		bsr.w	OPL_SpawnObj			; check respawn flag and spawn object
		beq.s	.loop_find_right		; loop until object is found outside window
	if FixBugs
		; Fix a remember sprite related bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_remember_sprite_related_bug
		tst.b	4(a0)				; was this object a remember state?
		bpl.s	.found_right			; if not, branch
		subq.b	#1,(a2)				; move right counter back
	endif

	; loc_DA16:
	.found_right:
		move.l	a0,(v_opl_data).w		; save pointer for objpos
		movea.l	(v_opl_data+4).w,a0		; jump to objpos on left side of window
		subi.w	#320+320+128,d6			; d6 = 128px to left of screen
		bcs.s	.found_left

; loc_DA24:
.loop_find_left:
		cmp.w	(a0),d6				; (a0) = x pos of object; d6 = left edge of spawn window
		bls.s	.found_left			; branch if object is within spawn window
		tst.b	4(a0)
		bpl.s	.no_respawn2
		addq.b	#1,1(a2)

	; loc_DA32:
	.no_respawn2:
		addq.w	#6,a0
		bra.s	.loop_find_left
; ===========================================================================

; loc_DA36:
.found_left:
		move.l	a0,(v_opl_data+4).w

; locret_DA3A:
OPL_NoMove:
		rts
; End of function OPL_MovedRight
; End of function ObjPosLoad (as a whole)


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	load an object
; 
; input:
;	d2.w = position in respawn list
;	a0 = pointer to specific object in objpos list
;	a2 = v_objstate
; 
; output:
;	d0.l = 0 if object is spawned (or skipped because it was broken)
;	a1 = address of OST of spawned object
; 
;	uses d1.w, a0
; ---------------------------------------------------------------------------

; loc_DA3C:
OPL_SpawnObj:
		tst.b	4(a0)				; is remember respawn flag set?
		bpl.s	OPL_MakeItem			; if not, branch
	if FixBugs
		; Fix a remember sprite related bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_remember_sprite_related_bug
		btst	#7,2(a2,d2.w)			; is remember bit already set? (test only)
	else
		bset	#7,2(a2,d2.w)			; set flag so it isn't loaded more than once
	endif
		beq.s	OPL_MakeItem			; branch if object hasn't already been destroyed
		addq.w	#6,a0				; goto next object in objpos list
		moveq	#0,d0
		rts
; ===========================================================================

OPL_MakeItem:
		bsr.w	FindFreeObj			; find free OST slot
		bne.s	.fail				; branch if not found
		move.w	(a0)+,obX(a1)			; set x pos
		move.w	(a0)+,d0			; get y pos and x/y flip flags
		move.w	d0,d1
		andi.w	#$FFF,d0			; ignore x/y flip bits
		move.w	d0,obY(a1)			; set y pos
		rol.w	#2,d1
		andi.b	#sprite_xflip|sprite_yflip,d1	; read only x/y flip bits
		move.b	d1,obRender(a1)			; apply x/y flip
		move.b	d1,obStatus(a1)
		move.b	(a0)+,d0			; get object id
		bpl.s	.no_respawn_bit			; branch if remember respawn bit is not set
	if FixBugs
		; Fix a remember sprite related bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_remember_sprite_related_bug
		bset	#7,2(a2,d2.w)			; set as removed
	endif
		andi.b	#$7F,d0				; ignore respawn bit
		move.b	d2,obRespawnNo(a1)		; give object its place in the respawn table

	; loc_DA80:
	.no_respawn_bit:
		_move.b	d0,obID(a1)			; load object
		move.b	(a0)+,obSubtype(a1)		; set subtype
		moveq	#0,d0

	; locret_DA8A:
	.fail:
		rts
; End of function OPL_SpawnObj
