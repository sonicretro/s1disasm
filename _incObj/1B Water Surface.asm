; ---------------------------------------------------------------------------
; Object 1B - water surface (LZ)
; ---------------------------------------------------------------------------

WaterSurface:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Surf_Index(pc,d0.w),d1
		jmp	Surf_Index(pc,d1.w)
; ===========================================================================
Surf_Index:	dc.w Surf_Main-Surf_Index
		dc.w Surf_Action-Surf_Index

surf_origX = $30		; original x-axis position
surf_freeze = $32		; flag to freeze animation
; ===========================================================================

Surf_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Surf,obMap(a0)
		move.w	#$C300,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$80,obActWid(a0)
		move.w	obX(a0),surf_origX(a0)

Surf_Action:	; Routine 2
		move.w	(v_screenposx).w,d1
		andi.w	#$FFE0,d1
		add.w	surf_origX(a0),d1
		btst	#0,(v_framebyte).w
		beq.s	.even		; branch on even frames
		addi.w	#$20,d1

.even:
		move.w	d1,obX(a0)	; match	obj x-position to screen position
		move.w	(v_waterpos1).w,d1
		move.w	d1,obY(a0)	; match	obj y-position to water	height
		tst.b	surf_freeze(a0)
		bne.s	.stopped
		btst	#bitStart,(v_jpadpress1).w ; is Start button pressed?
		beq.s	.animate	; if not, branch
		addq.b	#3,obFrame(a0)	; use different	frames
		move.b	#1,surf_freeze(a0) ; stop animation
		bra.s	.display
; ===========================================================================

.stopped:
		tst.w	(f_pause).w	; is the game paused?
		bne.s	.display	; if yes, branch
		move.b	#0,surf_freeze(a0) ; resume animation
		subq.b	#3,obFrame(a0)	; use normal frames

.animate:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.display
		move.b	#7,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#3,obFrame(a0)
		bcs.s	.display
		move.b	#0,obFrame(a0)

.display:
		bra.w	DisplaySprite
