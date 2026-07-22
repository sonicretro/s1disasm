; ---------------------------------------------------------------------------
; Object 82 - Eggman (SBZ2)
; ---------------------------------------------------------------------------

; loc_1982C:
FalseFloor_Delete:
		; This is part of Object 82, but it is only ever called
		; from Object 83 (the collapsing floor)
		jmp	(DeleteObject).l
; ===========================================================================

ScrapEggman:
		moveq	#0,d0
		move.b	obRoutine(a0),d0		; copy object routine
		move.w	SEgg_Index(pc,d0.w),d1		; use the object routine index and SEgg_Index to calculate our offset
		jmp	SEgg_Index(pc,d1.w)		; jump into the table and use our offset to pick a routine in the index to go to
; ===========================================================================
SEgg_Index:	dc.w SEgg_Main-SEgg_Index
		dc.w SEgg_Eggman-SEgg_Index
		dc.w SEgg_Switch-SEgg_Index

SEgg_ParentObj equ objoff_34				; pointer to main boss controller
SEgg_GenericTimer equ objoff_3C				; timer for how many frames to wait before doing an action
FFloor_BlockListStart equ objoff_30			; starting offset used for start of floor block array

SEgg_ObjData:	dc.b 2,	0, 3		; routine number, animation, priority
		dc.b 4,	0, 3
; ===========================================================================

SEgg_Main:	; Routine 0
		lea	SEgg_ObjData(pc),a2		; load objdata table for indexing
		move.w	#boss_sbz2_x+$110,obX(a0)	; set position
		move.w	#boss_sbz2_y+$94,obY(a0)
		move.b	#col_48x48|col_boss,obColType(a0) ; set collision type
		move.b	#16,obBossHits(a0) 		; SBZ2 Eggman is set to 16 hits, despite being unhittable
		bclr	#0,obStatus(a0)			; clear object status
		clr.b	ob2ndRout(a0)			; clear 2nd routine
		move.b	(a2)+,obRoutine(a0)		; copy routine number, animation, priority
		move.b	(a2)+,obAnim(a0)
		move.b	(a2)+,obPriority(a0)
		move.l	#Map_SEgg,obMap(a0)		; load mappings, art, and set priority
		move.w	#ArtTile_Eggman,obGfx(a0)
		move.b	#sprite_cam_field,obRender(a0)
		bset	#sprite_rendered_bit,obRender(a0)
		move.b	#64/2,obActWid(a0)		; set object width radius for rendering purposes
		jsr	(FindNextFreeObj).l
		bne.s	SEgg_Eggman

; SEgg_ParentObj is used here as a reference back to the main boss controller. 
; This is because when we are in ExecuteObjects, a0 is set to each object and sub objects own slot, so we need a way to find the original boss object.
; This cutscene chooses not to loop, and instead copy it manually as there are only 2 things to load here
		move.l	a0,SEgg_ParentObj(a1)
		move.b	#id_ScrapEggman,obID(a1) 	; load switch object
		move.w	#boss_sbz2_x+$E0,obX(a1)	; set position
		move.w	#boss_sbz2_y+$AC,obY(a1)
		clr.b	ob2ndRout(a0)			; clear 2nd routine again
		move.b	(a2)+,obRoutine(a1)		; copy routine number, animation, priority
		move.b	(a2)+,obAnim(a1)
		move.b	(a2)+,obPriority(a1)
		move.l	#Map_But,obMap(a1)		; load mappings, art, and set priority
		move.w	#ArtTile_Eggman_Button,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)
		bset	#sprite_rendered_bit,obRender(a1)
		move.b	#32/2,obActWid(a1)		; set object width radius for rendering purposes
		move.b	#0,obFrame(a1)			; set switch frame

SEgg_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	SEgg_EggIndex(pc,d0.w),d1	; use the object routine index and SEgg_EggIndex to calculate our offset
		jsr	SEgg_EggIndex(pc,d1.w)		; jump into the table (but return later)
		lea	Ani_SEgg(pc),a1			; return after the routine has been executed to load and animate sprites
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
SEgg_EggIndex:	dc.w SEgg_ChkSonic-SEgg_EggIndex
		dc.w SEgg_PreLeap-SEgg_EggIndex
		dc.w SEgg_Leap-SEgg_EggIndex
		dc.w SEgg_Move-SEgg_EggIndex
; ===========================================================================

SEgg_ChkSonic:
		move.w	obX(a0),d0			
		sub.w	(v_player+obX).w,d0		; calculate offset of Sonic's X and Eggman's
		cmpi.w	#128,d0			; is Sonic within 128 pixels of Eggman?
		bhs.s	SEgg_Move			; if not, branch
		addq.b	#2,ob2ndRout(a0)		; advance object routine
		move.w	#180,SEgg_GenericTimer(a0)	; set delay to 3 seconds
		move.b	#1,obAnim(a0)			; increment animation state

; loc_19934:
SEgg_Move:
		jmp	(SpeedToPos).l			; calculate movement
; ===========================================================================

SEgg_PreLeap:
		subq.w	#1,SEgg_GenericTimer(a0)	; subtract 1 from time delay
		bne.s	.exit				; if time remains, branch
		addq.b	#2,ob2ndRout(a0)		; no time left, increment routine to Leap
		move.b	#2,obAnim(a0)			; increment animation state
		addq.w	#4,obY(a0)			; subtract Y slightly (this is where Eggman "crouches" to leap)
		move.w	#15,SEgg_GenericTimer(a0)	; set a timer for 15 frames

; loc_19954:
.exit:
		bra.s	SEgg_Move
; ===========================================================================

SEgg_Leap:
		subq.w	#1,SEgg_GenericTimer(a0)	; subtract 1 from time delay
		bgt.s	.exit				; is timer above 0? if yes, branch
		bne.s	.checkLeap			; timer is below 0, already leaping, branch
		move.w	#-$FC,obVelX(a0) 		; make Eggman leap
		move.w	#-$3C0,obVelY(a0)

; loc_1996A:
.checkLeap:
		cmpi.w	#boss_sbz2_x+$E2,obX(a0)	; has Eggman reached the switch?
		bgt.s	.applyGravity			; if not, branch
		clr.w	obVelX(a0)			; yes, fall straight down

; loc_19976:
.applyGravity
		addi.w	#$24,obVelY(a0)			; add more downward momentum
		tst.w	obVelY(a0)			; is Eggman currently moving upward?
		bmi.s	.findBlocks			; if so, branch
		cmpi.w	#boss_sbz2_y+$85,obY(a0)	; is Eggman above this Y offset?
		blo.s	.findBlocks			; no, branch
		move.w	#"SW",obSubtype(a0)		; use Subtype as a status offset
		cmpi.w	#boss_sbz2_y+$8B,obY(a0)	; has Eggman reached the floor?
		blo.s	.findBlocks			; if not, branch
		move.w	#boss_sbz2_y+$8B,obY(a0)	; snap to floor	
		clr.w	obVelY(a0)			; stop falling

; SEgg_FindBlocks:
.findBlocks:
		move.w	obVelX(a0),d0			; copy X velocity
		or.w	obVelY(a0),d0			; OR X with Y
		bne.s	.exit				; if Eggman is moving, leave

	if FixBugs
		lea	(v_lvlobjspace-object_size).w,a1
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0
	else
		lea	(v_objspace).w,a1 ; Nonsensical starting point, since dynamic object allocations begin at v_lvlobjspace.
		moveq	#(v_objspace_end-(v_objspace+object_size*1))/object_size/2-1,d0	; Nonsensical length, it only covers the first half of object RAM.
	endif
		moveq	#object_size,d1

; SEgg_FindLoop:
.findLoop:
		adda.w	d1,a1				; jump to next object RAM
		cmpi.b	#id_FalseFloor,obID(a1) 	; is object a block? (object $83)
		dbeq	d0,.findLoop 			; if not, repeat (max $3E times)

		bne.s	.exit				; no objects were found, so leave
		move.w	#"GO",obSubtype(a1) 		; set block to disintegrate
		addq.b	#2,ob2ndRout(a0)		; increment routine counter
		move.b	#1,obAnim(a0)			; set animation routine

; loc_199D0:
.exit:
		bra.w	SEgg_Move
; ===========================================================================

SEgg_Switch:	; Routine 4
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	SEgg_SwIndex(pc,d0.w),d0	; use the object routine index and SEgg_SwIndex to calculate our offset
		jmp	SEgg_SwIndex(pc,d0.w)		; jump into the table and no need to return to animate the sprite unlike routine 2
; ===========================================================================
SEgg_SwIndex:	dc.w SEgg_SwChk-SEgg_SwIndex
		dc.w SEgg_SwDisplay-SEgg_SwIndex
; ===========================================================================

; loc_199E6:
SEgg_SwChk:
		movea.l	SEgg_ParentObj(a0),a1
		cmpi.w	#"SW",obSubtype(a1)		; has the switch been triggered?
		bne.s	SEgg_SwDisplay			; if not, branch
		move.b	#1,obFrame(a0)			; set switch frame
		addq.b	#2,ob2ndRout(a0)		; increment routine counter

SEgg_SwDisplay:
		jmp	(DisplaySprite).l
; ===========================================================================


		include	"_anim/Eggman - Scrap Brain 2 & Final.asm"
Map_SEgg:	include	"_maps/Eggman - Scrap Brain 2.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate Eggman presses a switch (SBZ2)
; ---------------------------------------------------------------------------

FalseFloor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FFloor_Index(pc,d0.w),d1	; use the object routine index and FFloor_Index to calculate our offset
		jmp	FFloor_Index(pc,d1.w)		; jump into the table and use our offset to pick a routine
; ===========================================================================
FFloor_Index:	dc.w FFloor_Main-FFloor_Index
		dc.w FFloor_ChkBreak-FFloor_Index
		dc.w FFloor_Break-FFloor_Index
		dc.w FFloor_AllGone-FFloor_Index
		dc.w FFloor_Block-FFloor_Index
		dc.w FFloor_Frag-FFloor_Index
; ===========================================================================

FFloor_Main:	; Routine 0
		move.w	#boss_sbz2_x+$30,obX(a0)	; set position of main manager object
		move.w	#boss_sbz2_y+$C0,obY(a0)
		move.b	#256/2,obActWid(a0)		; set object width radius for rendering purposes
		move.b	#32/2,obHeight(a0)		; set height
		move.b	#sprite_cam_field,obRender(a0)	; set render properties
		bset	#sprite_rendered_bit,obRender(a0)
		moveq	#0,d4
		move.w	#boss_sbz2_x-$40,d5		; set position of first block
		moveq	#7,d6				; set loop amount to 8
		lea	FFloor_BlockListStart(a0),a2	; load starting offset address 

FFloor_MakeBlock:
		jsr	(FindFreeObj).l			
		bne.s	FFloor_ExitMake			; if no free object slots found, exit
		move.w	a1,(a2)+			; copy open slot into offset list above and increment offset list
		move.b	#id_FalseFloor,obID(a1) 	; set object ID to FalseFloor for this slot
		move.l	#Map_FFloor,obMap(a1)		; copy mappings, art, and set it to use palette line 3
		move.w	#ArtTile_Eggman_Trap_Floor|Tile_Pal3,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)	; set rendering flags, width and height
		move.b	#32/2,obActWid(a1)
		move.b	#32/2,obHeight(a1)
		move.b	#3,obPriority(a1)		; set priority (higher side)
		move.w	d5,obX(a1)			; set X position
		move.w	#boss_sbz2_y+$C0,obY(a1)	; set Y position
		addi.w	#$20,d5				; add $20 for next X position
		move.b	#8,obRoutine(a1)		; set routine to FFloor_Block
		dbf	d6,FFloor_MakeBlock 		; repeat sequence 7 more times

FFloor_ExitMake:
		addq.b	#2,obRoutine(a0)		; if left early, go to ChkBreak, otherwise go to Frag
		rts
; ===========================================================================

FFloor_ChkBreak:; Routine 2
		cmpi.w	#"GO",obSubtype(a0) 		; is object set to disintegrate?
		bne.s	FFloor_Solid			; if not, branch
		clr.b	obFrame(a0)			; clear current break counter (not used for animations, see below)
		addq.b	#2,obRoutine(a0) 		; next subroutine

; Rather than managing 8 separate collision boxes, the entire floor is treated
; as one solid surface that shrinks from the left as each block breaks.
; obFrame tracks how many blocks have broken, which determines the remaining width.
; This allows for the bridge to have dynamically updating collision.

FFloor_Solid:
		moveq	#0,d0
		move.b	obFrame(a0),d0			; copy current break counter
		neg.b	d0				; negate, then sign extend
		ext.w	d0
		addq.w	#8,d0				; calculate the number of blocks left to break
		asl.w	#4,d0				; shift left 4 bits, this calculates the width of the remaining bride
		move.w	#boss_sbz2_x+$B0,d4		; set an anchor point on the right side
		sub.w	d0,d4				; subtract anchor from remaining width/2 to get the center
		move.b	d0,obActWid(a0)			; set object width to remaining width
		move.w	d4,obX(a0)			; set object center location to width/2 of the bridge 
		moveq	#sonic_solid_width,d1		; copy Sonic's width
		add.w	d0,d1				; add the bridge width/2 to Sonic's width 
		moveq	#16,d2				; 16 pixel height above center
		moveq	#17,d3				; 17 pixel height below center
		jmp	(SolidObject).l			; apply collision
; ===========================================================================

; loc_19C36:
FFloor_Break:	; Routine 4
		subi.b	#$E,obTimeFrame(a0)		; subtract 14 from frame duration counter (offset being repurposed)
		bcc.s	.exit				; timer hasn't gone negative, so branch
		moveq	#-1,d0				; set up d0
		move.b	obFrame(a0),d0			; copy block break counter
		ext.w	d0				; extend this byte to a word
		add.w	d0,d0				; double this word to create a word-based index (result: $FFFFXXXX)
		move.w	FFloor_BlockListStart(a0,d0.w),d0 ; use the index to move into the block list
		movea.l	d0,a1				; copy calculated offset as an address
		move.w	#"GO",obSubtype(a1)		; set block broken flag for block calculated from the list
		addq.b	#1,obFrame(a0)			; increment frame
		cmpi.b	#8,obFrame(a0)			; has the block disappeared?
		beq.s	FFloor_AllGone			; if yes, branch

; FFloor_Solid2:
.exit:
		bra.s	FFloor_Solid
; ===========================================================================

; loc_19C62:
FFloor_AllGone:	; Routine 6
		bclr	#3,obStatus(a0)			; clear standing on flag
		bclr	#3,(v_player+obStatus).w	; clear Sonic standing on flag
		bra.w	FalseFloor_Delete
; ===========================================================================

; loc_19C72:
FFloor_Block:	; Routine 8
		cmpi.w	#"GO",obSubtype(a0)	; is object set to disintegrate?
		beq.s	FFloor_BlockBreak	; if yes, branch
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_19C80:
FFloor_Frag:	; Routine $A
		tst.b	obRender(a0)			; is the object on screen?
		bpl.w	FalseFloor_Delete		; if no, branch
		jsr	(ObjectFall).l
		jmp	(DisplaySprite).l
; ===========================================================================

FFloor_BlockBreak:
		lea	FFloor_FragSpeed(pc),a4		; load fragment speed and position table
		lea	FFloor_FragPos(pc),a5
		moveq	#1,d4				; set fragment to first frame
		moveq	#3,d1				; set up floor loop fragment for 4 loops
		moveq	#gravity,d2			; unused leftover from SmashObject
		addq.b	#2,obRoutine(a0)		; increment routine to Fall
		move.b	#16/2,obActWid(a0)		; set fragment width and height
		move.b	#16/2,obHeight(a0)
		lea	(a0),a1				; copy first block being broken
		bra.s	FFloor_MakeFrag
; ===========================================================================

FFloor_LoopFrag:
		jsr	(FindNextFreeObj).l
		bne.s	FFloor_BreakSnd			; no free objects found, branch

FFloor_MakeFrag:
		lea	(a0),a2				; set a2 to original block
		lea	(a1),a3				; set a3 to the destination (freeobjslot on all but first loop)
		moveq	#3,d3				; set loop for 4 times

; loc_19CC4:
.copyObject:
		move.l	(a2)+,(a3)+			; copy 4 bytes of original object to new object and increment pointer
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d3,.copyObject

; After everything has been copied to each fragment, when ExecuteObjects is ran it will find the objID sitting in RAM and run these fragments, for now we must run our current fragment

		move.w	(a4)+,obVelY(a1)		; copy frag speed from table into object
		move.w	(a5)+,d3			; copy position and increment
		add.w	d3,obX(a1)			; add position offset from table to current position
		move.w	(a5)+,d3			; copy position and increment
		add.w	d3,obY(a1)			; add position offset from table to current position
		move.b	d4,obFrame(a1)			; set current frame
		addq.w	#1,d4				; increment frame to set up next fragment
		dbf	d1,FFloor_LoopFrag 		; repeat sequence 3 more times

FFloor_BreakSnd:
		move.w	#sfx_WallSmash,d0
		jsr	(QueueSound2).l			; play smashing sound
		jmp	(DisplaySprite).l

; ===========================================================================
FFloor_FragSpeed:dc.w $80, 0
		dc.w $120, $C0
FFloor_FragPos:	dc.w -8, -8
		dc.w $10, 0
		dc.w 0,	$10
		dc.w $10, $10
; ===========================================================================

Map_FFloor:	include	"_maps/SBZ Eggman's Crumbling Floor.asm"
