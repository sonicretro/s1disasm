; ===========================================================================
; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

DynamicLevelEvents:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	DLE_Index(pc,d0.w),d0
		jsr	DLE_Index(pc,d0.w)			; run level-specific events
		moveq	#2,d1
		move.w	(v_limitbtm1).w,d0			; new boundary y pos is written here
		sub.w	(v_limitbtm2).w,d0
		beq.s	.keep_boundary				; branch if boundary is where it should be
		bhs.s	.move_boundary_down			; branch if new boundary is below current one

		neg.w	d1
		move.w	(v_screenposy).w,d0
		cmp.w	(v_limitbtm1).w,d0
		bls.s	.camera_below				; branch if camera y pos is above boundary
		move.w	d0,(v_limitbtm2).w			; match boundary to camera
		andi.w	#$FFFE,(v_limitbtm2).w			; round down to nearest 2px

	; loc_6DA0:
	.camera_below:
		add.w	d1,(v_limitbtm2).w			; move boundary up 2px
		move.b	#1,(f_bgscrollvert).w

	; DLE_NoChg:
	.keep_boundary:
		rts
; ===========================================================================

; loc_6DAC:
.move_boundary_down:
		move.w	(v_screenposy).w,d0
		addq.w	#8,d0
		cmp.w	(v_limitbtm2).w,d0
		blo.s	.down_2px				; branch if boundary is at least 8px below camera
		btst	#1,(v_player+obStatus).w
		beq.s	.down_2px				; branch if Sonic isn't in the air
		add.w	d1,d1
		add.w	d1,d1					; boundary moves 8px instead of 2px

	; loc_6DC4:
	.down_2px:
		add.w	d1,(v_limitbtm2).w			; move boundary down 2px (or 8px)
		move.b	#1,(f_bgscrollvert).w
		rts
; End of function DynamicLevelEvents

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:	dc.w DLE_GHZ-DLE_Index
		dc.w DLE_LZ-DLE_Index
		dc.w DLE_MZ-DLE_Index
		dc.w DLE_SLZ-DLE_Index
		dc.w DLE_SYZ-DLE_Index
		dc.w DLE_SBZ-DLE_Index
		zonewarning DLE_Index,2
		dc.w DLE_Ending-DLE_Index

; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_GHZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_GHZx(pc,d0.w),d0
		jmp	DLE_GHZx(pc,d0.w)
; ===========================================================================
DLE_GHZx:	dc.w DLE_GHZ1-DLE_GHZx
		dc.w DLE_GHZ2-DLE_GHZx
		dc.w DLE_GHZ3-DLE_GHZx
; ===========================================================================
; Green Hill Zone - Act 1

DLE_GHZ1:
	if FixBugs
		; Prevent the title screen from using GHZ1's DLE logic
		cmpi.b	#id_Title,(v_gamemode).w
		beq.s	.exit
	endif

		move.w	#$300,(v_limitbtm1).w			; initial boundary
		cmpi.w	#$1780,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1780

		move.w	#$400,(v_limitbtm1).w			; set lower y-boundary

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone - Act 2

DLE_GHZ2:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$ED0,(v_screenposx).w
		blo.s	.exit

		move.w	#$200,(v_limitbtm1).w
		cmpi.w	#$1600,(v_screenposx).w
		blo.s	.exit

		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1D60,(v_screenposx).w
		blo.s	.exit

		move.w	#$300,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone - Act 3

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_GHZ3_Index(pc,d0.w),d0
		jmp	DLE_GHZ3_Index(pc,d0.w)
; ===========================================================================
DLE_GHZ3_Index:	dc.w DLE_GHZ3_Main-DLE_GHZ3_Index
		dc.w DLE_GHZ3_Boss-DLE_GHZ3_Index
		dc.w DLE_GHZ3_End-DLE_GHZ3_Index
; ===========================================================================

DLE_GHZ3_Main:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$380,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $380

		move.w	#$310,(v_limitbtm1).w
		cmpi.w	#$960,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $960

		cmpi.w	#$280,(v_screenposy).w
		blo.s	.final_section				; branch if camera is above $280

		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1380,(v_screenposx).w
		bhs.s	.skip_underground			; branch if camera is right of $1380

		move.w	#$4C0,(v_limitbtm1).w
		move.w	#$4C0,(v_limitbtm2).w

	.skip_underground:
		cmpi.w	#$1700,(v_screenposx).w
		bhs.s	.final_section				; branch if camera is right of $1700

	.exit:
		rts
; ===========================================================================

.final_section:
		move.w	#boss_ghz_y,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Boss next
		rts
; ===========================================================================

DLE_GHZ3_Boss:
		cmpi.w	#$960,(v_screenposx).w
		bhs.s	.dont_return				; branch if camera is right of $960
		subq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Main next

	.dont_return:
		cmpi.w	#boss_ghz_x,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $2960
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		_move.b	#id_BossGreenHill,obID(a1)		; load GHZ boss object
		move.w	#boss_ghz_x+$100,obX(a1)
		move.w	#boss_ghz_y-$80,obY(a1)

	.fail:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1				; play boss music
		move.b	#1,(f_lockscreen).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_End next
		moveq	#plcid_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts
; ===========================================================================

DLE_GHZ3_End:
		move.w	(v_screenposx).w,(v_limitleft2).w	; set boundary to current position
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_LZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_LZx(pc,d0.w),d0
		jmp	DLE_LZx(pc,d0.w)
; ===========================================================================
DLE_LZx:	dc.w DLE_LZ12-DLE_LZx
		dc.w DLE_LZ12-DLE_LZx
		dc.w DLE_LZ3-DLE_LZx
		dc.w DLE_SBZ3-DLE_LZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone - Act 1 & 2

DLE_LZ12:
		rts						; no events for acts 1/2
; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone - Act 3

DLE_LZ3:
		tst.b	(f_switch+$F).w				; has switch $F	been pressed?
		beq.s	.skip_layout				; if not, branch
		lea	(v_lvllayout_fg+((layout_row*2)+6)).w,a1 ; target chunk at row 2, column 6 (zero-based)
		cmpi.b	#7,(a1)
		beq.s	.skip_layout				; branch if already modified
		move.b	#7,(a1)					; modify level layout
		move.w	#sfx_Rumbling,d0
		bsr.w	QueueSound2				; play rumbling sound

	.skip_layout:
		tst.b	(v_dle_routine).w
		bne.s	.skip_boss				; branch if boss is already loaded
	if FixBugs
	; Easy fix to load the boss quicker to prevent Eggman's graphics still decompressing briefly while on screen
		cmpi.w	#boss_lz_x-$1C0,(v_screenposx).w
	else
		cmpi.w	#boss_lz_x-$140,(v_screenposx).w
	endif
		blo.s	.skip_boss2				; branch if camera is left of $1CA0
		cmpi.w	#boss_lz_y+$540,(v_screenposy).w
		bhs.s	.skip_boss2				; branch if camera is below $600

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		_move.b	#id_BossLabyrinth,obID(a1)		; load LZ boss object

	.fail:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1				; play boss music
		move.b	#1,(f_lockscreen).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; don't load boss again
		moveq	#plcid_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.skip_boss2:
		rts
; ===========================================================================

.skip_boss:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap Brain Zone - Act 3 (Labyrinth Zone - Act 4)

DLE_SBZ3:
		cmpi.w	#$D00,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $D00
		cmpi.w	#$18,(v_player+obY).w			; has Sonic reached the top of the level?
		bhs.s	.exit					; if not, branch

		clr.b	(v_lastlamp).w
		move.w	#1,(f_restart).w			; restart level
		move.w	#id_FZ,(v_zone_act).w			; set level number to 0502 (FZ)
		move.b	#1,(f_playerctrl).w			; lock controls, position & animation

	.exit:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_MZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_MZx(pc,d0.w),d0
		jmp	DLE_MZx(pc,d0.w)
; ===========================================================================
DLE_MZx:	dc.w DLE_MZ1-DLE_MZx
		dc.w DLE_MZ2-DLE_MZx
		dc.w DLE_MZ3-DLE_MZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone - Act 1

DLE_MZ1:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_MZ1_Index(pc,d0.w),d0
		jmp	DLE_MZ1_Index(pc,d0.w)
; ===========================================================================
DLE_MZ1_Index:	dc.w DLE_MZ1_0-DLE_MZ1_Index
		dc.w DLE_MZ1_2-DLE_MZ1_Index
		dc.w DLE_MZ1_4-DLE_MZ1_Index
		dc.w DLE_MZ1_6-DLE_MZ1_Index
; ===========================================================================

DLE_MZ1_0:
		move.w	#$1D0,(v_limitbtm1).w
		cmpi.w	#$700,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $700

		move.w	#$220,(v_limitbtm1).w
		cmpi.w	#$D00,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $D00

		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$340,(v_screenposy).w
		blo.s	.exit					; branch if camera is above $340

		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_2 next

	.exit:
		rts
; ===========================================================================

DLE_MZ1_2:
		cmpi.w	#$340,(v_screenposy).w
		bhs.s	.next					; branch if camera is below $340

		subq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_0 next
		rts
; ===========================================================================

.next:
		move.w	#0,(v_limittop2).w
		cmpi.w	#$E00,(v_screenposx).w
		bhs.s	.exit					; branch if camera is right of $E00

		move.w	#$340,(v_limittop2).w
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$A90,(v_screenposx).w
		bhs.s	.exit					; branch if camera is right of $A90

		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$370,(v_screenposy).w
		blo.s	.exit					; branch if camera is above $370

		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_4 next

	.exit:
		rts
; ===========================================================================

DLE_MZ1_4:
		cmpi.w	#$370,(v_screenposy).w
		bhs.s	.next					; branch if camera is below $370

		subq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_2 next
		rts
; ===========================================================================

.next:
		cmpi.w	#$500,(v_screenposy).w
		blo.s	.exit					; branch if camera is above $500
	if Revision<>0
		cmpi.w	#$B80,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $B80
	endif
		move.w	#$500,(v_limittop2).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_6 next

	.exit:
		rts
; ===========================================================================

DLE_MZ1_6:
	if Revision<>0
		cmpi.w	#$B80,(v_screenposx).w
		bhs.s	.skip_mid				; branch if camera is right of $B80

		cmpi.w	#$340,(v_limittop2).w
		beq.s	.exit					; branch if top boundary is set for middle section

		subq.w	#2,(v_limittop2).w			; move top boundary up 2px
		rts
.skip_mid:
		cmpi.w	#$500,(v_limittop2).w
		beq.s	.skip_btm				; branch if top boundary is set for bottom section

		cmpi.w	#$500,(v_screenposy).w
		blo.s	.exit					; branch if camera is above $500

		move.w	#$500,(v_limittop2).w
.skip_btm:
	endif

		cmpi.w	#$E70,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $E70

		move.w	#0,(v_limittop2).w
		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$1430,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1430

		move.w	#$210,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone - Act 2

DLE_MZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$1700,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1700

		move.w	#$200,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone - Act 3

DLE_MZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_MZ3_Index(pc,d0.w),d0
		jmp	DLE_MZ3_Index(pc,d0.w)
; ===========================================================================
DLE_MZ3_Index:	dc.w DLE_MZ3_Boss-DLE_MZ3_Index
		dc.w DLE_MZ3_End-DLE_MZ3_Index
; ===========================================================================

DLE_MZ3_Boss:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#boss_mz_x-$2A0,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1560

		move.w	#boss_mz_y,(v_limitbtm1).w
		cmpi.w	#boss_mz_x-$10,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $17F0

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		_move.b	#id_BossMarble,obID(a1)			; load MZ boss object
		move.w	#boss_mz_x+$1F0,obX(a1)
		move.w	#boss_mz_y+$1C,obY(a1)

	.fail:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1				; play boss music
		move.b	#1,(f_lockscreen).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ3_End next
		moveq	#plcid_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts
; ===========================================================================

DLE_MZ3_End:
		move.w	(v_screenposx).w,(v_limitleft2).w	; set boundary to current position
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SLZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SLZx(pc,d0.w),d0
		jmp	DLE_SLZx(pc,d0.w)
; ===========================================================================
DLE_SLZx:	dc.w DLE_SLZ12-DLE_SLZx
		dc.w DLE_SLZ12-DLE_SLZx
		dc.w DLE_SLZ3-DLE_SLZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone - Act 1 & 2

DLE_SLZ12:
		rts						; no events for acts 1/2
; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone - Act 3

DLE_SLZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_SLZ3_Index(pc,d0.w),d0
		jmp	DLE_SLZ3_Index(pc,d0.w)
; ===========================================================================
DLE_SLZ3_Index:	dc.w DLE_SLZ3_Main-DLE_SLZ3_Index
		dc.w DLE_SLZ3_Boss-DLE_SLZ3_Index
		dc.w DLE_SLZ3_End-DLE_SLZ3_Index
; ===========================================================================

DLE_SLZ3_Main:
		cmpi.w	#boss_slz_x-$190,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1E70

		move.w	#boss_slz_y,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_SLZ3_Boss next

	.exit:
		rts
; ===========================================================================

DLE_SLZ3_Boss:
		cmpi.w	#boss_slz_x,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $2000

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossStarLight,obID(a1)		; load SLZ boss object

	.fail:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1				; play boss music
		move.b	#1,(f_lockscreen).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_SLZ3_End next
		moveq	#plcid_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts
; ===========================================================================

DLE_SLZ3_End:
		move.w	(v_screenposx).w,(v_limitleft2).w	; set boundary to current position
		rts
		rts	; redundant rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SYZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SYZx(pc,d0.w),d0
		jmp	DLE_SYZx(pc,d0.w)
; ===========================================================================
DLE_SYZx:	dc.w DLE_SYZ1-DLE_SYZx
		dc.w DLE_SYZ2-DLE_SYZx
		dc.w DLE_SYZ3-DLE_SYZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone - Act 1

DLE_SYZ1:
		rts						; no events for act 1
; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone - Act 2

DLE_SYZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$25A0,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $25A0

		move.w	#$420,(v_limitbtm1).w
		cmpi.w	#$4D0,(v_player+obY).w
		blo.s	.exit					; branch if Sonic is above $4D0

		move.w	#$520,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Spring Yard Zone - Act 3

DLE_SYZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_SYZ3_Index(pc,d0.w),d0
		jmp	DLE_SYZ3_Index(pc,d0.w)
; ===========================================================================
DLE_SYZ3_Index:	dc.w DLE_SYZ3_Main-DLE_SYZ3_Index
		dc.w DLE_SYZ3_Boss-DLE_SYZ3_Index
		dc.w DLE_SYZ3_End-DLE_SYZ3_Index
; ===========================================================================

DLE_SYZ3_Main:
		cmpi.w	#boss_syz_x-$140,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $2AC0

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.exit					; branch if not found
		move.b	#id_BossBlock,obID(a1)			; load blocks that boss picks up
		addq.b	#2,(v_dle_routine).w			; goto DLE_SYZ3_Boss next

	.exit:
		rts
; ===========================================================================

DLE_SYZ3_Boss:
		cmpi.w	#boss_syz_x,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $2C00

		move.w	#boss_syz_y,(v_limitbtm1).w
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossSpringYard,obID(a1)		; load SYZ boss object
		addq.b	#2,(v_dle_routine).w			; goto DLE_SYZ3_End next

	.fail:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1				; play boss music
		move.b	#1,(f_lockscreen).w			; lock screen
		moveq	#plcid_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts
; ===========================================================================

DLE_SYZ3_End:
		move.w	(v_screenposx).w,(v_limitleft2).w	; set boundary to current position
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap	Brain Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SBZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SBZx(pc,d0.w),d0
		jmp	DLE_SBZx(pc,d0.w)
; ===========================================================================
DLE_SBZx:	dc.w DLE_SBZ1-DLE_SBZx
		dc.w DLE_SBZ2-DLE_SBZx
		dc.w DLE_FZ-DLE_SBZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap Brain Zone - Act 1

DLE_SBZ1:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#$1880,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1880

		move.w	#$620,(v_limitbtm1).w
		cmpi.w	#$2000,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $2000

		move.w	#$2A0,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Scrap Brain Zone - Act 2

DLE_SBZ2:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_SBZ2_Index(pc,d0.w),d0
		jmp	DLE_SBZ2_Index(pc,d0.w)
; ===========================================================================
DLE_SBZ2_Index:	dc.w DLE_SBZ2_Main-DLE_SBZ2_Index
		dc.w DLE_SBZ2_Blocks-DLE_SBZ2_Index
		dc.w DLE_SBZ2_Eggman-DLE_SBZ2_Index
		dc.w DLE_SBZ2_End-DLE_SBZ2_Index
; ===========================================================================

DLE_SBZ2_Main:
		move.w	#$800,(v_limitbtm1).w
		cmpi.w	#$1800,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1800

		move.w	#boss_sbz2_y,(v_limitbtm1).w
		cmpi.w	#$1E00,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1E00

		addq.b	#2,(v_dle_routine).w			; goto DLE_SBZ2_Blocks next

	.exit:
		rts
; ===========================================================================

DLE_SBZ2_Blocks:
		cmpi.w	#boss_sbz2_x-$1A0,(v_screenposx).w
		blo.s	.exit					; branch if camera is left of $1EB0

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.exit					; branch if not found
		move.b	#id_FalseFloor,obID(a1)			; load collapsing block object
		addq.b	#2,(v_dle_routine).w			; goto DLE_SBZ2_Eggman next
		moveq	#plcid_EggmanSBZ2,d0
		bra.w	AddPLC					; load SBZ2 Eggman gfx
; ===========================================================================

.exit:
		rts
; ===========================================================================

DLE_SBZ2_Eggman:
		cmpi.w	#boss_sbz2_x-$F0,(v_screenposx).w
		blo.s	.set_boundary				; branch if camera is left of $1F60

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_ScrapEggman,obID(a1)		; load SBZ2 Eggman object
		addq.b	#2,(v_dle_routine).w			; goto DLE_SBZ2_End next

	.fail:
		move.b	#1,(f_lockscreen).w			; lock screen

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_SBZ2_End:
		cmpi.w	#boss_sbz2_x,(v_screenposx).w
		blo.s	DLE_SBZ2_SetBoundary			; branch if camera is left of $2050
		rts
; ===========================================================================

DLE_SBZ2_SetBoundary:
		move.w	(v_screenposx).w,(v_limitleft2).w	; set boundary to current position
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Final Zone (Scrap Brain Zone - Act 3)

DLE_FZ:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_FZ_Index(pc,d0.w),d0
		jmp	DLE_FZ_Index(pc,d0.w)
; ===========================================================================
DLE_FZ_Index:	dc.w DLE_FZ_Main-DLE_FZ_Index
		dc.w DLE_FZ_Boss-DLE_FZ_Index
		dc.w DLE_FZ_Arena-DLE_FZ_Index
		dc.w DLE_FZ_Wait-DLE_FZ_Index
		dc.w DLE_FZ_End-DLE_FZ_Index
; ===========================================================================

DLE_FZ_Main:
		cmpi.w	#boss_fz_x-$308,(v_screenposx).w
		blo.s	.set_boundary				; branch if camera is left of $2148

		addq.b	#2,(v_dle_routine).w			; goto DLE_FZ_Boss next
		moveq	#plcid_FZBoss,d0
		bsr.w	AddPLC					; load FZ boss gfx

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_FZ_Boss:
		cmpi.w	#boss_fz_x-$150,(v_screenposx).w
		blo.s	.set_boundary				; branch if camera is left of $2300

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.set_boundary				; branch if not found
		move.b	#id_BossFinal,obID(a1)			; load FZ boss object
		addq.b	#2,(v_dle_routine).w			; goto DLE_FZ_Arena next
		move.b	#1,(f_lockscreen).w			; lock screen

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_FZ_Arena:
		cmpi.w	#boss_fz_x,(v_screenposx).w		; boss arena is here
		blo.s	.set_boundary				; branch if camera is left of $2450

		addq.b	#2,(v_dle_routine).w			; goto DLE_FZ_Wait next

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_FZ_Wait:
		rts						; wait until boss is beaten
; ===========================================================================

DLE_FZ_End:
		bra.s	DLE_SBZ2_SetBoundary			; allow scrolling right

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence dynamic level events (empty)
; ---------------------------------------------------------------------------

DLE_Ending:
		rts
