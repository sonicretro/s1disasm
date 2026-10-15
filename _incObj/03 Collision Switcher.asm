; ===========================================================================
; ----------------------------------------------------------------------------
; Object 03 - Collision plane/layer switcher (ported from Sonic 2)
; ----------------------------------------------------------------------------

pswap_bit_size0:		equ 0	
pswap_bit_size1:		equ 1	
pswap_bit_horizontal:		equ 2	
pswap_bit_path2_rightdown:	equ 3	
pswap_bit_path2_leftup:		equ 4	
pswap_bit_priority_rightdown:	equ 5	
pswap_bit_priority_leftup:	equ 6	
; pswap_bit_groundonly:		equ 7	; implicitly through a bpl check
pswap_render_priorityonly:	equ 0

pswap_size:	equ objoff_32	; hitbox size of path swapper divided by 2
pswap_passed:	equ objoff_34	; flag set if path swapper has been passed

; ----------------------------------------------------------------------------

PathSwapper:
		moveq	#0,d0					; clear d0
		move.b	obRoutine(a0),d0			; get routine counter
		move.w	PSwapper_Index(pc,d0.w),d1		; find current entry in jump table
		jsr	PSwapper_Index(pc,d1.w)			; jump there and return
; ----------------------------------------------------------------------------

	if DebugPathSwappers
		tst.w	(f_debugcheat).w			; is debug cheat enabled?
		bne.w	RememberState				; if yes, make path swappers visible
	endif
		; like RememberState, but doesn't display (Sonic 2's MarkObjGone3)
		out_of_range.w	.offscreen			; if yes, branch
		rts						; otherwise, do nothing

	.offscreen:
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object's respawn table index
		beq.s	.delete					; if it's zero, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag for object

	.delete:
		bra.w	DeleteObject				; delete path swapper

; ===========================================================================
PSwapper_Index:	dc.w PSwapper_Init-PSwapper_Index		; 0
		dc.w PSwapper_MainX-PSwapper_Index		; 2
		dc.w PSwapper_MainY-PSwapper_Index		; 4
; ===========================================================================

PSwapper_Init:	; Routine 0
		addq.b	#2,obRoutine(a0)			; set to PSwapper_MainX
		move.l	#Map_PathSwapper,obMap(a0)		; set mappings for debug display
		move.w	#ArtTile_Ring|Tile_Pal2,obGfx(a0)	; use ring graphics for debug display
		ori.b	#4,obRender(a0)				; set to playfield positioning mode
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#5,obPriority(a0)			; set sprite priority

		move.b	obSubtype(a0),d0			; get subtype of path swapper
		btst	#pswap_bit_horizontal,d0		; is horizontal orientation bit set?
		beq.s	PSwapper_Init_CheckX			; if yes, branch
; ----------------------------------------------------------------------------

PSwapper_Init_CheckY:
		addq.b	#2,obRoutine(a0)			; set to PSwapper_MainY
		andi.w	#7,d0					; limit to frame IDs 4-7
		move.b	d0,obFrame(a0)				; set frame ID
		andi.w	#1<<pswap_bit_size0|1<<pswap_bit_size1,d0 ; limit to 4 sizes
		add.w	d0,d0					; double for word-based indexing
		move.w	PSwapper_Sizes(pc,d0.w),pswap_size(a0)	; get trigger size of path swapper

		move.w	obY(a0),d1				; get Y-pos of path swapper
		lea	(v_player).w,a1				; load Sonic player object
		cmp.w	obY(a1),d1				; was Sonic below path swapper as it spawned?
		bhs.w	PSwapper_MainY				; if not, branch
		st.b	pswap_passed(a0)			; already set "path swapper passed" flag
		bra.w	PSwapper_MainY				; advance to main logic

; ===========================================================================
PSwapper_Sizes:	; These size definitions are /2 (halved)
		dc.w   $20	; 0
		dc.w   $40	; 1
		dc.w   $80	; 2
		dc.w  $100	; 3
; ===========================================================================

PSwapper_Init_CheckX:
		andi.w	#1<<pswap_bit_size0|1<<pswap_bit_size1,d0 ; limit to frame IDs 0-3
		move.b	d0,obFrame(a0)				; set frame ID
		add.w	d0,d0					; double for word-based indexing
		move.w	PSwapper_Sizes(pc,d0.w),pswap_size(a0)	; get trigger size of path swapper

		move.w	obX(a0),d1				; get X-pos of path swapper
		lea	(v_player).w,a1				; load Sonic player object
		cmp.w	obX(a1),d1				; was Sonic to the right of the path swapper as it spawned?
		bhs.s	PSwapper_MainX				; if not, branch
		st.b	pswap_passed(a0)			; already set "path swapper passed" flag
; ----------------------------------------------------------------------------

PSwapper_MainX:	; Routine 2
		tst.w	(v_debuguse).w				; is debug mode currently active?
		bne.w	.return					; if yes, disable interaction

		move.w	obX(a0),d1				; get X-pos of path swapper
		lea	(v_player).w,a1				; load Sonic player object
		tst.b	pswap_passed(a0)			; has path swapper already been passed?
		bne.w	PSwapper_MainX_Alt			; if yes, branch to alternate handler

		cmp.w	obX(a1),d1				; is Sonic to the right of the path swapper?
		bhi.s	.return					; if not, don't trigger path swap
		st.b	pswap_passed(a0)			; set "path swapper passed" flag

		move.w	obY(a0),d2				; get Y-pos of path swapper
		move.w	d2,d3					; copy Y-pos
		move.w	pswap_size(a0),d4			; get trigger size for path swapper
		sub.w	d4,d2					; d2 = top Y-pos of trigger
		add.w	d4,d3					; d3 = bottom Y-pos of trigger
		move.w	obY(a1),d4				; get Sonic's Y-pos
		cmp.w	d2,d4					; is Sonic below the top trigger?
		blt.s	.return					; if not, branch
		cmp.w	d3,d4					; is Sonic above the bottom trigger?
		bge.s	.return					; if not, branch

		move.b	obSubtype(a0),d0			; get path swapper settings
		bpl.s	.triggerPathSwap			; is "ground only" flag set (pswap_bit_groundonly)? if not, branch
		btst	#status_in_air_bit,obStatus(a1)		; is Sonic airborne?
		bne.s	.return					; if yes, don't trigger path swap

	.triggerPathSwap:
		btst	#pswap_render_priorityonly,obRender(a0)	; is "priority only" flag set for path swapper? (stored in X-flip flag)
		bne.s	.changePriority				; if yes, don't affect active path

		move.b	#$C,(v_top_solid_bit).w			; set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w			; set collision to 1st
		btst	#pswap_bit_path2_rightdown,d0		; is target path set to 2nd?
		beq.s	.changePriority				; if not, branch
		move.b	#$E,(v_top_solid_bit).w			; set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w			; set collision to 2nd

	.changePriority:
		andi.w	#$7FFF,obGfx(a1)			; set Sonic to low plane priority
		btst	#pswap_bit_priority_rightdown,d0	; is priority flag set?
		beq.s	.priorityDone				; if not, branch
		ori.w	#$8000,obGfx(a1)			; set Sonic to high plane priority
	.priorityDone:

	if DebugPathSwappers
		tst.b	(f_debugcheat).w			; is debug mode enabled?
		beq.s	.return					; if not, branch
		move.b	#sfx_Lamppost,d0			; play lamppost sound when touching path swapper
		jmp	(QueueSound2).l				; play it
	endif

	.return:
		rts						; return
; ===========================================================================

PSwapper_MainX_Alt:
		cmp.w	obX(a1),d1				; is Sonic to the left of the path swapper again?
		bls.s	.return					; if not, don't trigger path swap
		sf.b	pswap_passed(a0)			; clear "path swapper passed" flag

		move.w	obY(a0),d2				; get Y-pos of path swapper
		move.w	d2,d3					; copy Y-pos
		move.w	pswap_size(a0),d4			; get trigger size for path swapper
		sub.w	d4,d2					; d2 = top Y-pos of trigger
		add.w	d4,d3					; d3 = bottom Y-pos of trigger
		move.w	obY(a1),d4				; get Sonic's Y-pos
		cmp.w	d2,d4					; is Sonic below the top trigger?
		blt.s	.return					; if not, branch
		cmp.w	d3,d4					; is Sonic above the bottom trigger?
		bge.s	.return					; if not, branch

		move.b	obSubtype(a0),d0			; get path swapper settings
		bpl.s	.triggerPathSwap			; is "ground only" flag set (pswap_bit_groundonly)? if not, branch
		btst	#status_in_air_bit,obStatus(a1)		; is Sonic airborne?
		bne.s	.return					; if yes, don't trigger path swap

	.triggerPathSwap:
		btst	#pswap_render_priorityonly,obRender(a0)	; is "priority only" flag set for path swapper? (stored in X-flip flag)
		bne.s	.changePriority				; if yes, don't affect active path

		move.b	#$C,(v_top_solid_bit).w			; set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w			; set collision to 1st
		btst	#pswap_bit_path2_leftup,d0		; is target path set to 2nd?
		beq.s	.changePriority				; if not, branch
		move.b	#$E,(v_top_solid_bit).w			; set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w			; set collision to 2nd

	.changePriority:
		andi.w	#$7FFF,obGfx(a1)			; set Sonic to low plane priority
		btst	#pswap_bit_priority_leftup,d0		; is priority flag set?
		beq.s	.priorityDone				; if not, branch
		ori.w	#$8000,obGfx(a1)			; set Sonic to high plane priority
	.priorityDone:

	if DebugPathSwappers
		tst.b	(f_debugcheat).w			; is debug mode enabled?
		beq.s	.return					; if not, branch
		move.b	#sfx_Lamppost,d0			; play lamppost sound when touching path swapper
		jmp	(QueueSound2).l				; play it
	endif

	.return:
		rts						; return
; ===========================================================================
; ===========================================================================

PSwapper_MainY:	; Routine 4
		tst.w	(v_debuguse).w				; is debug mode currently active?
		bne.w	.return					; if yes, disable interaction

		move.w	obY(a0),d1				; get Y-pos of path swapper
		lea	(v_player).w,a1				; load Sonic player object
		tst.b	pswap_passed(a0)			; has path swapper already been passed?
		bne.s	PSwapper_MainY_Alt			; if yes, branch to alternate handler

		cmp.w	obY(a1),d1				; is Sonic below the path swapper?
		bhi.s	.return					; if not, don't trigger path swap
		st.b	pswap_passed(a0)			; set "path swapper passed" flag

		move.w	obX(a0),d2				; get X-pos of path swapper
		move.w	d2,d3					; copy X-pos
		move.w	pswap_size(a0),d4			; get trigger size for path swapper
		sub.w	d4,d2					; d2 = left X-pos of trigger
		add.w	d4,d3					; d3 = right X-pos of trigger
		move.w	obX(a1),d4				; get Sonic's X-pos
		cmp.w	d2,d4					; is Sonic to the right of the left trigger?
		blt.s	.return					; if not, branch
		cmp.w	d3,d4					; is Sonic to the left of the right trigger?
		bge.s	.return					; if not, branch

		move.b	obSubtype(a0),d0			; get path swapper settings
		bpl.s	.triggerPathSwap			; is "ground only" flag set (pswap_bit_groundonly)? if not, branch
		btst	#status_in_air_bit,obStatus(a1)		; is Sonic airborne?
		bne.s	.return					; if yes, don't trigger path swap

	.triggerPathSwap:
		btst	#pswap_render_priorityonly,obRender(a0)	; is "priority only" flag set for path swapper? (stored in X-flip flag)
		bne.s	.changePriority				; if yes, don't affect active path

		move.b	#$C,(v_top_solid_bit).w			; set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w			; set collision to 1st
		btst	#pswap_bit_path2_rightdown,d0		; is target path set to 2nd?
		beq.s	.changePriority				; if not, branch
		move.b	#$E,(v_top_solid_bit).w			; set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w			; set collision to 2nd

	.changePriority:
		andi.w	#$7FFF,obGfx(a1)			; set Sonic to low plane priority
		btst	#pswap_bit_priority_rightdown,d0	; is priority flag set?
		beq.s	.priorityDone				; if not, branch
		ori.w	#$8000,obGfx(a1)			; set Sonic to high plane priority
	.priorityDone:

	if DebugPathSwappers
		tst.b	(f_debugcheat).w			; is debug mode enabled?
		beq.s	.return					; if not, branch
		move.b	#sfx_Lamppost,d0			; play lamppost sound when touching path swapper
		jmp	(QueueSound2).l				; play it
	endif

	.return:
		rts						; return
; ===========================================================================

PSwapper_MainY_Alt:
		cmp.w	obY(a1),d1				; is Sonic above the path swapper again?
		bls.s	.return					; if not, don't trigger path swap
		sf.b	pswap_passed(a0)			; clear "path swapper passed" flag

		move.w	obX(a0),d2				; get X-pos of path swapper
		move.w	d2,d3					; copy X-pos
		move.w	pswap_size(a0),d4			; get trigger size for path swapper
		sub.w	d4,d2					; d2 = left X-pos of trigger
		add.w	d4,d3					; d3 = right X-pos of trigger
		move.w	obX(a1),d4				; get Sonic's X-pos
		cmp.w	d2,d4					; is Sonic to the right of the left trigger?
		blt.s	.return					; if not, branch
		cmp.w	d3,d4					; is Sonic to the left of the right trigger?
		bge.s	.return					; if not, branch

		move.b	obSubtype(a0),d0			; get path swapper settings
		bpl.s	.triggerPathSwap			; is "ground only" flag set (pswap_bit_groundonly)? if not, branch
		btst	#status_in_air_bit,obStatus(a1)		; is Sonic airborne?
		bne.s	.return					; if yes, don't trigger path swap

	.triggerPathSwap:
		btst	#pswap_render_priorityonly,obRender(a0)	; is "priority only" flag set for path swapper? (stored in X-flip flag)
		bne.s	.changePriority				; if yes, don't affect active path

		move.b	#$C,(v_top_solid_bit).w			; set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w			; set collision to 1st
		btst	#pswap_bit_path2_leftup,d0		; is target path set to 2nd?
		beq.s	.changePriority				; if not, branch
		move.b	#$E,(v_top_solid_bit).w			; set collision to 2nd
		move.b	#$F,(v_lrb_solid_bit).w			; set collision to 2nd

	.changePriority:
		andi.w	#$7FFF,obGfx(a1)			; set Sonic to low plane priority
		btst	#pswap_bit_priority_leftup,d0		; is priority flag set?
		beq.s	.priorityDone				; if not, branch
		ori.w	#$8000,obGfx(a1)			; set Sonic to high plane priority
	.priorityDone:

	if DebugPathSwappers
		tst.b	(f_debugcheat).w			; is debug mode enabled?
		beq.s	.return					; if not, branch
		move.b	#sfx_Lamppost,d0			; play lamppost sound when touching path swapper
		jmp	(QueueSound2).l				; play it
	endif

	.return:
		rts						; return
; ===========================================================================
