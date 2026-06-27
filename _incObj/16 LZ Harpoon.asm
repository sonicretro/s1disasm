; ===========================================================================
; ---------------------------------------------------------------------------
; Object 16 - harpoon (LZ)
; ---------------------------------------------------------------------------

Harpoon:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Harp_Index(pc,d0.w),d1
		jmp	Harp_Index(pc,d1.w)
; ===========================================================================
Harp_Index:	dc.w Harp_Main-Harp_Index
		dc.w Harp_Move-Harp_Index
		dc.w Harp_Wait-Harp_Index

harp_time:	equ objoff_30		; time to wait between extending/retracting
; ===========================================================================

Harp_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Harp_Move
		move.l	#Map_Harp,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Harpoon,obGfx(a0)		; set art tile
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	obSubtype(a0),obAnim(a0)		; get harpoon type (0 = sideways // 2 = upright)
		move.b	#40/2,obActWid(a0)			; set sprite display width
		move.w	#60,harp_time(a0)			; set extending/retracting time delay to 1 second
; ---------------------------------------------------------------------------

Harp_Move:	; Routine 2
		lea	(Ani_Harp).l,a1				; load animation scripts
		bsr.w	AnimateSprite				; (advances obRoutine to Harp_Wait on animation finish)

		moveq	#0,d0
		move.b	obFrame(a0),d0				; get current frame number after animations have run
		move.b	Harp_ColTypes(pc,d0.w),obColType(a0)	; get collision type based on current harpoon frame ID

		bra.w	RememberState				; display harpoon or delete if out of range

; ===========================================================================
Harp_ColTypes:	dc.b col_16x8|col_hurt	; frame 0, sideways, retracted
		dc.b col_48x8|col_hurt	; frame 1, sideways, moving
		dc.b col_80x8|col_hurt	; frame 2, sideways, extended
		dc.b col_8x16|col_hurt	; frame 3, upright,  retracted
		dc.b col_8x48|col_hurt	; frame 4, upright,  moving
		dc.b col_8x80|col_hurt	; frame 5, upright,  extended
		even
; ===========================================================================

Harp_Wait:	; Routine 4
		subq.w	#1,harp_time(a0)			; decrement waiting timer
		bpl.s	.display				; branch if time remains
		move.w	#60,harp_time(a0)			; reset timer to 1 second
		subq.b	#2,obRoutine(a0)			; go back to Harp_Move routine
		bchg	#0,obAnim(a0)				; toggle between extending/retracting animation

	.display:
		bra.w	RememberState				; display harpoon or delete if out of range
; ===========================================================================

		include	"_anim/Harpoon.asm"
Map_Harp:	include	"_maps/Harpoon.asm"
