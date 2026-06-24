; ===========================================================================
; ---------------------------------------------------------------------------
; Object 54 - invisible lava tag / hurt marker (MZ)
; ---------------------------------------------------------------------------

LavaTag:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LTag_Index(pc,d0.w),d1
		jmp	LTag_Index(pc,d1.w)
; ===========================================================================
LTag_Index:	dc.w LTag_Main-LTag_Index
		dc.w LTag_ChkDel-LTag_Index

LTag_ColTypes:	; collision types for ReactToItem
		dc.b	col_64x64|col_hurt 	; subtype 00 - damaging, 64x64  (small)
		dc.b	col_128x64|col_hurt	; subtype 01 - damaging, 128x64 (medium)
		dc.b	col_256x64|col_hurt	; subtype 02 - damaging, 256x64 (large)
		even
; ===========================================================================

LTag_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advacne to LTag_ChkDel
		moveq	#0,d0					; clear d0 for word-based addressing
		move.b	obSubtype(a0),d0			; get size in subtype (0-2)
		move.b	LTag_ColTypes(pc,d0.w),obColType(a0)	; set collision response type/size based on subtype
		move.l	#Map_LTag,obMap(a0)			; set mappings (blank)

		; The reason why this object enables its object rendered flag despite being
		; blank is because of an optimization made to ReactToItem that skips over
		; objects that haven't set it. From Sonic 2 onwards, this check was removed.
		; This, however, creates a flaw. If the object DID have proper mappings, it
		; would appear when dying. In fact, this occurs in Sonic 2 with the ARZ leaf
		; generator, whose initialization code was likely copied from here. It would
		; also effect the lava in that game had it not been for a hackish workaround
		; where it uses blank mappings outside of edit mode.
		move.b	#sprite_rendered|sprite_cam_field,obRender(a0) ; set object visible flag ($80) and playfield-positioned mode (4)
; ---------------------------------------------------------------------------

LTag_ChkDel:	; Routine 2
		out_of_range.w	DeleteObject,obX(a0),1		; contains a (redundant) bmi check
		rts						; don't delete, but also don't display
; ===========================================================================

Map_LTag:	include	"_maps/Lava Tag.asm"
