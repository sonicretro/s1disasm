; ===========================================================================
; BuildSprites camera pointers to be used depending on bits 2-3 in obRender.

; Here they point to the camera X-position, and it's expected that 4 bytes
; after it the camera Y-position is located (e.g. v_screenposx/v_screenposy).
; Note that the last two background camera pointers go completely unused
; in the entire game, though they may have once been used for the
; foreground palm trees in the Tokyo Toy Show demo.

; BldSpr_ScrPos:
BuildSpr_Cameras:
		dc.l 0					; null (fallback for on-screen coordinates)
		dc.l v_screenposx&$FFFFFF		; foreground camera
		dc.l v_bgscreenposx&$FFFFFF		; background camera 1 (unused)
		dc.l v_bg3screenposx&$FFFFFF		; background camera 2 (unused)
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) into proper Mega Drive sprites
; and queue them into a linked sprite buffer table (transferred in VBlank).
; ---------------------------------------------------------------------------

BuildSprites:
		lea	(v_spritetablebuffer).w,a2
		moveq	#0,d5				; d5 will be used as counter for total rendered sprites

		lea	(v_spritequeue).w,a4
		moveq	#spritelayer_num-1,d7
.priorityLoop:
		tst.w	(a4)				; are there objects left to draw in current priority layer?
		beq.w	.nextPriority			; if not, go to next priority layer

		moveq	#2,d6				; initialize offset pointer to first object after entry counter (2 bytes)
	.objectLoop:
		movea.w	(a4,d6.w),a0			; load object's address in RAM
		tst.b	obID(a0)			; has an object been queued for display but deleted?
		beq.w	.skipObject			; if yes, skip (this appears to be an effort to fix display-and-delete bugs)
		bclr	#sprite_rendered_bit,obRender(a0) ; set object as not visible

	; --- Coordinate system ---
		move.b	obRender(a0),d0
		move.b	d0,d4
		andi.w	#sprite_cam_field|sprite_cam_bg,d0 ; get drawing coordinate system in render flags (bit 2-3)
		beq.s	.screenCoords			; branch if 0 (on-screen positioning coordinate system)
		movea.l	BuildSpr_Cameras(pc,d0.w),a1	; load camera pointers for coordinate system (in practice, only foreground camera is ever used)

	; --- Screen bounds check for X-position ---
		moveq	#0,d0
		move.b	obActWid(a0),d0			; get display width
		move.w	obX(a0),d3
		sub.w	(a1),d3				; subtract camera X-position
		move.w	d3,d1
		add.w	d0,d1				; d1 = obX - cameraX + obActWid
		bmi.w	.skipObject			; if underflowed, left edge is out of bounds
		move.w	d3,d1
		sub.w	d0,d1				; d1 = obX - cameraX - obActWid
		cmpi.w	#320,d1				; is result greater than screen width?
		bge.s	.skipObject			; if yes, right edge is out of bounds
		addi.w	#$80,d3				; add VDP sprite start

	; --- Screen bounds check for Y-position ---
		btst	#sprite_customheight_bit,d4	; is custom height flag set?
		beq.s	.assumeHeight			; if not, assume height instead

		moveq	#0,d0
		move.b	obHeight(a0),d0			; use custom height
		move.w	obY(a0),d2
		sub.w	4(a1),d2			; subtract camera Y-position
		move.w	d2,d1
		add.w	d0,d1				; d1 = obY - cameraY + obHeight
		bmi.s	.skipObject			; if negative, top edge is out of bounds
		move.w	d2,d1
		sub.w	d0,d1				; d1 = obY - cameraY - obHeight
		cmpi.w	#224,d1				; is result greater than screen height?
		bge.s	.skipObject			; if yes, bottom edge is out of bounds
		addi.w	#$80,d2				; add VDP sprite start
		bra.s	.drawObject
; ---------------------------------------------------------------------------

	.screenCoords:
		move.w	obScreenY(a0),d2		; special variable for screen Y
		move.w	obX(a0),d3
		bra.s	.drawObject
; ---------------------------------------------------------------------------

	.assumeHeight:
		.ah:	equ 32				; assumed height = 32px ($20)
		move.w	obY(a0),d2
		sub.w	4(a1),d2			; subtract camera Y-position
		addi.w	#$80,d2
		cmpi.w	#$80-.ah,d2			; is top Y-position with assumed height out of bounds?
		blo.s	.skipObject			; if yes, branch
		cmpi.w	#$80+224+.ah,d2			; is bottom Y-position with assumed height out of bounds?
		bhs.s	.skipObject			; if yes, branch

	; --- Load sprite mappings ---
	.drawObject:
		movea.l	obMap(a0),a1

		moveq	#1-1,d1				; write only one sprite for raw-mappings
		btst	#sprite_rawmappings_bit,d4	; is "raw-mappings" flag on?
		bne.s	.drawFrame			; if yes, branch (assume mappings point to a single sprite piece)

		move.b	obFrame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1			; get mappings frame address
		move.b	(a1)+,d1			; get number of sprite pieces in frame
		subq.b	#1,d1				; subtract 1 for dbf
		bmi.s	.setVisible			; skip rendering if mapping was blank

	; --- Do the actual sprite mapping rendering ---
	.drawFrame:
		bsr.w	BuildSpr_Draw

	.setVisible:
		bset	#sprite_rendered_bit,obRender(a0) ; set object as visible

	.skipObject:
		addq.w	#2,d6				; advance to next entry in layer
		subq.w	#2,(a4)				; decrement number of objects left
		bne.w	.objectLoop			; if entries remain, loop

.nextPriority:
		lea	spritelayer_size(a4),a4		; advance to next layer (each layer is $80 bytes)
		dbf	d7,.priorityLoop
		
		move.b	d5,(v_spritecount).w		; write number of rendered sprites to debug var
		cmpi.b	#sprites_max,d5			; check if sprite limit was exhausted
		beq.s	.spriteLimit			; if yes, branch
		move.l	#0,(a2)				; unlink last sprite
		rts
; ---------------------------------------------------------------------------

	.spriteLimit:
		move.b	#0,-5(a2)			; unlink penultimate sprite
		rts
; End of function BuildSprites


; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for all BuildSpr_Draw functions, to visualize the differences between them.
; All four variants work on the same basic principle, only coming with
; modifications for the flipping.
; 
; input:
;	d1 = number of sprite pieces in mapping minus 1
;	d2 = base Y-position
;	d3 = base X-position
;	d5 = total rendered sprites so far (max 80)
;	a1 = pointer to starting sprite piece in sprite mappings (see breakdown above)
;	a2 = pointer to sprite link buffer (v_spritetablebuffer)
;	a3 = art tile / VRAM setting (obGfx)
;
; 	uses d0.w, d4.w
;
; Each sprite piece is exactly 5 bytes. See here for a breakdown:
; https://info.sonicretro.org/SCHG:Sonic_the_Hedgehog_(16-bit)/Object_Editing#Mappings_editing
; ---------------------------------------------------------------------------

buildsprite:	macro xflip,yflip

.loopSpritePieces:
	; --- Sprite limit check ---
		cmpi.b	#sprites_max,d5			; check sprite limit
		beq.s	.return				; if all sprite slots are taken up, abort process

	; --- Y-position ---
		move.b	(a1)+,d0			; get relative Y-offset
		if yflip
			move.b	(a1),d4			; get dimensions of sprite piece
			ext.w	d0
			neg.w	d0
			lsl.b	#3,d4
			andi.w	#%11000,d4
			addq.w	#8,d4
			sub.w	d4,d0			; d0 = flipped Y-position
		else
			ext.w	d0
		endif
		add.w	d2,d0				; add base Y-position
		move.w	d0,(a2)+			; write Y-position to buffer

	; --- Sprite width/height ---
		if xflip
			move.b	(a1)+,d4		; get dimensions of sprite piece (WWHH) (backup for later)
			move.b	d4,(a2)+		; write sprite width to buffer
		else
			move.b	(a1)+,(a2)+		; write sprite width to buffer
		endif

	; --- Sprite link ---
		addq.b	#1,d5				; increase total sprites counter
		move.b	d5,(a2)+			; write sprite link to buffer

	; --- VRAM settings / art tile / flipping ---
		move.b	(a1)+,d0			; get first half of VRAM settings
		lsl.w	#8,d0
		move.b	(a1)+,d0			; get second half of VRAM settings
		add.w	a3,d0				; add base art tile offset of object
		if xflip|yflip
			eori.w	#xflip<<11|yflip<<12,d0	; toggle X-flip ($800) and/or Y-flip ($1000) in VDP
		endif
		move.w	d0,(a2)+			; write VRAM settings to buffer

	; --- X-position ---
		move.b	(a1)+,d0			; get relative X-offset
		ext.w	d0
		if xflip
			neg.w	d0
			add.b	d4,d4
			andi.w	#%11000,d4
			addq.w	#8,d4
			sub.w	d4,d0			; d0 = flipped X-position
		endif
		add.w	d3,d0				; add X-position
		andi.w	#$1FF,d0			; keep within 512px (screen wrap)
		bne.s	.x				; if non-zero, branch
		addq.w	#1,d0				; force zero X-position to non-zero (avoid unwanted sprite masking)
	.x:	move.w	d0,(a2)+			; write X-position to buffer

	; --- Loop for all pieces in mapping ---
		dbf	d1,.loopSpritePieces

	.return:
		rts

	endm


; ---------------------------------------------------------------------------
; Subroutine to convert a object mapping frame (with multiple sprite pieces)
; into valid, linked Mega Drive sprites and buffer them, with flipping.
; ---------------------------------------------------------------------------

BuildSpr_Draw:
		movea.w	obGfx(a0),a3

		btst	#sprite_xflip_bit,d4		; is X-flip flag set?
		bne.s	BuildSpr_FlipX			; if yes, branch
		btst	#sprite_yflip_bit,d4		; is Y-flip flag set?
		bne.w	BuildSpr_FlipY			; if yes, branch

BuildSpr_Normal:
		buildsprite	0,0
; ---------------------------------------------------------------------------

BuildSpr_FlipX:
		btst	#sprite_yflip_bit,d4		; is Y-flip flag set as well?
		bne.w	BuildSpr_FlipXY			; if yes, branch

		buildsprite	1,0
; ---------------------------------------------------------------------------

BuildSpr_FlipY:
		buildsprite	0,1
; ---------------------------------------------------------------------------

BuildSpr_FlipXY:
		buildsprite	1,1
; End of function BuildSpr_Draw
