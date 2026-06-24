; ---------------------------------------------------------------------------
; Object 25 - rings
; ---------------------------------------------------------------------------

Rings:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Ring_Index(pc,d0.w),d1
		jmp	Ring_Index(pc,d1.w)
; ===========================================================================
Ring_Index:	dc.w Ring_Main-Ring_Index	; 0
		dc.w Ring_Animate-Ring_Index	; 2
		dc.w Ring_Collect-Ring_Index	; 4
		dc.w Ring_Sparkle-Ring_Index	; 6
		dc.w Ring_Delete-Ring_Index	; 8

ring_origX:	 equ objoff_32
ring_respawnbit: equ objoff_34
; ===========================================================================

; ---------------------------------------------------------------------------
; Distances between rings (format: horizontal, vertical)
; ---------------------------------------------------------------------------
Ring_PosData:	dc.b  $10,   0		; $0 - right, short
		dc.b  $18,   0		; $1 - right, medium
		dc.b  $20,   0		; $2 - right, far

		dc.b    0, $10		; $3 - down, short
		dc.b    0, $18		; $4 - down, medium
		dc.b    0, $20		; $5 - down, far

		dc.b  $10, $10		; $6 - diagonal right, short
		dc.b  $18, $18		; $7 - diagonal right, medium
		dc.b  $20, $20		; $8 - diagonal right, far

		dc.b -$10, $10		; $9 - diagonal left, short
		dc.b -$18, $18		; $A - diagonal left, medium
		dc.b -$20, $20		; $B - diagonal left, far

		dc.b  $10,   8		; $C - diagonal right-right, short
		dc.b  $18, $10		; $D - diagonal right-right, medium

		dc.b -$10,   8		; $E - diagonal left-left, short
		dc.b -$18, $10		; $F - diagonal left-left, medium
; ===========================================================================

Ring_Main:	; Routine 0

		; Ring respawn table data arrangement (in bits): R7654321
		;   R = respawn block flag for entire ring group
		;   # = "ring collected" flag per ring, set to 1 if collected
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0 (obRespawnNo is a byte, we need word addressing)
		move.b	obRespawnNo(a0),d0			; get object respawn index for ring group
		lea	2(a2,d0.w),a2				; load respawn data for this ring group
		move.b	(a2),d4					; store that data for later

		; Rings are stored in groups within the level layouts, with the subtype dictating
		; how many there are, and what distance/angle between individual rings to pick.
		; The format is as follows: $ON
		;   O = (Orientation) which entry in Ring_PosData to pick
		;   N = (Number) amount of rings to spawn plus 1 (so 0 is one ring)
		move.b	obSubtype(a0),d1			; get subtype for ring group
		move.b	d1,d0					; remember for later
		andi.w	#7,d1					; limit to 1-8 rings

		; The following check prevents an 8th ring from spawning, which would corrupt
		; the MSB in the respawn data byte (respawn block flag, reserved by object loader).
		; It is a bit odd, since ideally no ring groups with 8 rings should be placed to begin
		; with (and aren't anywhere), so this likely was used as a quick fix during development.
		cmpi.w	#7,d1					; is this a group with 8 rings?
		bne.s	.not8					; if not, branch
		moveq	#6,d1					; spawn 7 rings instead
	; loc_9B80:
	.not8:

		swap	d1					; store count in upper word (spawner will alternate between both words in d1)
		move.w	#0,d1					; clear lower word
		lsr.b	#4,d0					; shift orientation nybble to lower nybble
		add.w	d0,d0					; double for word-based indexing
		move.b	Ring_PosData+0(pc,d0.w),d5		; load ring spacing data for X-axis
		ext.w	d5					; extend to word for coordinates
		move.b	Ring_PosData+1(pc,d0.w),d6		; load ring spacing data for Y-axis
		ext.w	d6					; extend to word for coordinates

		movea.l	a0,a1					; load first actual ring into current RAM location
		move.w	obX(a0),d2				; remember base X-position
		move.w	obY(a0),d3				; remember base Y-position
		lsr.b	#1,d4					; shift out first ring collected bit
		bcs.s	Ring_NextRing				; has the first ring already been collected? if yes, skip spawning it
		bclr	#7,(a2)					; clear respawn block flag so ring group can spawn again
		bra.s	Ring_SpawnRing				; spawn first ring object
; ===========================================================================

Ring_MakeRings:
		swap	d1					; swap to respawn index bit
		lsr.b	#1,d4					; shift out next remembered ring respawn bit
		bcs.s	Ring_NextRing				; has this ring already been collected? if yes, branch
		bclr	#7,(a2)					; clear respawn block flag so ring group can spawn again

		bsr.w	FindFreeObj				; find a free RAM slot for the new ring
		bne.s	Ring_SpawningDone			; if object RAM is full, branch

; loc_9BBA:
Ring_SpawnRing:
		_move.b	#id_Rings,obID(a1)			; load new ring object
		addq.b	#2,obRoutine(a1)			; set to Ring_Animate
		move.w	d2,obX(a1)				; set x-axis position based on d2
		move.w	obX(a0),ring_origX(a1)			; remember original X-position for despawn logic
		move.w	d3,obY(a1)				; set y-axis position based on d3
		move.l	#Map_Ring,obMap(a1)			; set mappings
		move.w	#ArtTile_Ring|Tile_Pal2,obGfx(a1)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#2,obPriority(a1)			; set sprite priority
		move.b	#col_12x12|col_item,obColType(a1)	; set to power-up collision type and hitbox 12x12 (=$47)
		move.b	#16/2,obActWid(a1)			; set sprite display width
		move.b	obRespawnNo(a0),obRespawnNo(a1)		; remember respawn index of ring group
		move.b	d1,ring_respawnbit(a1)			; remember "ring collected" index bit in respawn data 

; loc_9C02:
Ring_NextRing:
		addq.w	#1,d1					; advance index bit for next ring
		add.w	d5,d2					; add ring X-spacing value to d2
		add.w	d6,d3					; add ring Y-spacing value to d3
		swap	d1					; swap to repeat count (dbf is for low word)
		dbf	d1,Ring_MakeRings			; repeat for number of rings

; loc_9C0E:
Ring_SpawningDone:
		btst	#0,(a2)					; has first ring already been collected?
		bne.w	DeleteObject				; if yes, delete it right away
; ---------------------------------------------------------------------------

Ring_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,obFrame(a0)		; set frame (updated in SynchroAnimate => Sync2)

	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		out_of_range.s	Ring_Delete,ring_origX(a0)	; has ring gone out of range (based on group X-position)? if yes, delete it
		bra.w	DisplaySprite				; otherwise, display ring sprite
	else
		bsr.w	DisplaySprite				; display ring sprite
		out_of_range.s	Ring_Delete,ring_origX(a0)	; has ring gone out of range (based on group X-position)? if yes, delete it
		rts						; return
	endif
; ===========================================================================

Ring_Collect:	; Routine 4 (set from ReactToItem)
		addq.b	#2,obRoutine(a0)			; advance to Ring_Sparkle
		move.b	#col_none,obColType(a0)			; prevent ring from being collected again
		move.b	#1,obPriority(a0)			; make ring sparkles appear in front of Sonic's sprites
		bsr.w	CollectRing				; add 1 ring 

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0 (obRespawnNo is a byte, we need word addressing)
		move.b	obRespawnNo(a0),d0			; get object respawn index for ring group
		move.b	ring_respawnbit(a0),d1			; get "ring collected" bit index for respawn data
		bset	d1,2(a2,d0.w)				; remember that this ring in the group has been collected
; ---------------------------------------------------------------------------

Ring_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1				; get ring animation script
		bsr.w	AnimateSprite				; advance ring animation
		bra.w	DisplaySprite				; display ring sprite
; ===========================================================================

Ring_Delete:	; Routine 8
		bra.w	DeleteObject				; delete this ring


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to add 1 ring, update ring HUD, and maybe add an extra life
; ---------------------------------------------------------------------------

CollectRing:
	if FixBugs
		; There isn't any limit to how many rings the player can
		; collect, which bugs out the ring counter at 999+ rings.
		; Sonic 2 and 3K would add a cap to stop this.
		moveq	#1,d0					; add 1 to rings
		add.w	(v_rings).w,d0				; get previous ring count
		cmpi.w	#999,d0					; does the player have 999 rings now?
		blo.s	.belowmax				; if not, branch
		move.w	#999,d0					; cap at 999 rings
.belowmax:	move.w	d0,(v_rings).w				; set new ring count
	else
		addq.w	#1,(v_rings).w				; add 1 to rings
	endif
		ori.b	#1,(f_ringcount).w			; update the rings counter

		move.w	#sfx_Ring,d0				; play ring sound

		cmpi.w	#100,(v_rings).w			; do you have 100 or more rings?
		blo.s	.playSound				; if not, branch
		bset	#1,(v_lifecount).w			; set "extra life for 100 rings" flag
		beq.s	.extraLife				; if it wasn't set before, award an extra life
		cmpi.w	#200,(v_rings).w			; do you have 200 or more rings?
		blo.s	.playSound				; if not, branch
		bset	#2,(v_lifecount).w			; set "extra life for 200 rings" flag
		bne.s	.playSound				; if it was already set, do not award another extra life

	.extraLife:
		addq.b	#1,(v_lives).w				; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w			; update the lives counter

		move.w	#bgm_ExtraLife,d0			; play extra life music

	.playSound:
		jmp	(QueueSound2).l				; play selected sound
; End of function CollectRing


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 37 - rings flying out of Sonic when he's hit
; ---------------------------------------------------------------------------

RingLoss:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	RLoss_Index(pc,d0.w),d1
		jmp	RLoss_Index(pc,d1.w)
; ===========================================================================
RLoss_Index:	dc.w RLoss_Count-RLoss_Index	; 0
		dc.w RLoss_Bounce-RLoss_Index	; 2
		dc.w RLoss_Collect-RLoss_Index	; 4
		dc.w RLoss_Sparkle-RLoss_Index	; 6
		dc.w RLoss_Delete-RLoss_Index	; 8

rloss_spread:	equ (2<<8)+$80+8	; (=$288) boost byte + angle fanning out + base angle variation
; ===========================================================================

RLoss_Count:	; Routine 0
		movea.l	a0,a1					; load first bouncing ring into current object RAM slot
		moveq	#0,d5					; clear d5
		move.w	(v_rings).w,d5				; check number of rings you have
		moveq	#32,d0					; spawn at most 32 rings
		cmp.w	d0,d5					; do you have 32 or more?
		blo.s	.belowmax				; if not, branch
		move.w	d0,d5					; if yes, cap number of rings to spawn to 32

	.belowmax:
		subq.w	#1,d5					; decrement d5 for dbf
		move.w	#rloss_spread,d4			; set initial ring angle spread value
		bra.s	.makerings				; spawn first ring object
; ===========================================================================

.loop:
		bsr.w	FindFreeObj				; find a free RAM slot for the new ring
		bne.w	.resetcounter				; if object RAM is full, branch

.makerings:
		_move.b	#id_RingLoss,obID(a1)			; load bouncing ring object
		addq.b	#2,obRoutine(a1)			; set to RLoss_Animate
		move.b	#16/2,obHeight(a1)			; set ring height
		move.b	#16/2,obWidth(a1)			; set right width
		move.w	obX(a0),obX(a1)				; spawn at same X-position
		move.w	obY(a0),obY(a1)				; spawn at same Y-position
		move.l	#Map_Ring,obMap(a1)			; set mappings
		move.w	#ArtTile_Ring|Tile_Pal2,obGfx(a1)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#3,obPriority(a1)			; set sprite priority (1 lower than normal rings)
		move.b	#col_12x12|col_item,obColType(a1)	; set to power-up collision type and hitbox 12x12 (=$47)
		move.b	#16/2,obActWid(a1)			; set sprite display width
	if FixBugs=0
		; This resets the timer for all spilled rings,
		; even if they were already close to getting deleted
		; https://info.sonicretro.org/SCHG_How-to:Fix_Ring_Timers
		move.b	#255,(v_ani3_time).w			; set bouncy ring animation timer to 255 frames
	endif

		; Calculate bouncy ring angles
		tst.w	d4					; are we spawning another ring and it's even?
		bmi.s	.setRingSpeed				; if yes, just repeat the last X/Y velocities but X-flipped
		move.w	d4,d0					; copy current spread value
		bsr.w	CalcSine				; calculate sine and cosine of current spread value (upper byte is ignored)
		move.w	d4,d2					; get current spread value again
		lsr.w	#8,d2					; get upper byte of spread value ($2xx => 2)
		asl.w	d2,d0					; boost X-speed by that value (multiply by 4)
		asl.w	d2,d1					; boost Y-speed by that value (multiply by 4)
		move.w	d0,d2					; store X-speed
		move.w	d1,d3					; store Y-speed
		addi.b	#$10,d4					; spread lost rings out further (don't affect boost byte)
		bcc.s	.setRingSpeed				; for the first 7 ring pairs, branch here
		subi.w	#$80,d4					; after 8 pairs of rings, reset angle (AND decrement boost byte)
		bcc.s	.setRingSpeed				; has spread value totally underflowed?
		move.w	#rloss_spread,d4			; if yes, reset it to default (impossible failsafe, can't happen with 32 rings)
	.setRingSpeed:
		move.w	d2,obVelX(a1)				; set X-velocity for lost ring
		move.w	d3,obVelY(a1)				; set Y-velocity for lost ring
		neg.w	d2					; negate X-velocity for next ring
		neg.w	d4					; negate ring spill angle for next ring

		dbf	d5,.loop				; repeat for number of rings (max 31)

.resetcounter:
		move.w	#0,(v_rings).w				; reset number of rings to zero
		move.b	#$80,(f_ringcount).w			; update ring counter ($80 means all digits should be reset to __0)
		move.b	#0,(v_lifecount).w			; reset the flags for extra lives on 100/200 rings collected

	if FixBugs
		; Fix Ring Timers
		; https://info.sonicretro.org/SCHG_How-to:Fix_Ring_Timers
		move.b	#255,d0					; set both timers to 255 frames
		move.b	d0,obDelayAni(a0)			; set ring despawn timer
		move.b	d0,(v_ani3_time).w			; set animation timer
	endif

		move.w	#sfx_RingLoss,d0			; set ring loss sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

RLoss_Bounce:	; Routine 2
		move.b	(v_ani3_frame).w,obFrame(a0)		; set frame (updated in SynchroAnimate => Sync4)

		bsr.w	SpeedToPos				; update ring position based on speed
		addi.w	#$18,obVelY(a0)				; make ring fall faster
		bmi.s	.chkdel					; is ring still going upwards? if yes, skip floor collision check

		move.b	(v_vblank_byte).w,d0			; get VBlank counter byte
		add.b	d7,d0					; add object RAM index as crude spreading-out of collision check over multiple frames
		andi.b	#3,d0					; only check for floor collision every 4th frame
		bne.s	.chkdel					; if on any other frame, branch

		jsr	(ObjFloorDist).l			; calculate distance between this ring and the floor
		tst.w	d1					; has ring hit the floor?
		bpl.s	.chkdel					; if not, branch
		add.w	d1,obY(a0)				; ring hit the floor, align it to the surface
		move.w	obVelY(a0),d0				; get current ring fall speed
		asr.w	#2,d0					; divide it by 4
		sub.w	d0,obVelY(a0)				; subtract that result from the previous speed to make it bounce less
		neg.w	obVelY(a0)				; negate fall speed to make ring bounce up

.chkdel:
	if FixBugs
		; Fix Ring Timers
		; https://info.sonicretro.org/SCHG_How-to:Fix_Ring_Timers
		subq.b	#1,obDelayAni(a0)			; decrement remaining time for bouncing ring
		beq.w	DeleteObject				; if time reached zero, delete ring
	else
		tst.b	(v_ani3_time).w				; has global lost rings animation timer expired?
		beq.s	RLoss_Delete				; if yes, delete ring
	endif

		move.w	(v_limitbtm2).w,d0			; get current bottom level boundary
		addi.w	#224,d0					; add vertical screen height
		cmp.w	obY(a0),d0				; has object moved below the bottom level boundary?
	if FixBugs
		; Fix accidental deletion of scattered rings at the top of the screen.
		; The cause is using an unsigned check instead of a signed one.
		blt.s	RLoss_Delete				; if yes, delete ring
	else
		blo.s	RLoss_Delete				; if yes, delete ring
	endif
		bra.w	DisplaySprite				; display this ring
; ===========================================================================

RLoss_Collect:	; Routine 4
		addq.b	#2,obRoutine(a0)			; advance to RLoss_Sparkle
		move.b	#col_none,obColType(a0)			; prevent ring from being collected again
		move.b	#1,obPriority(a0)			; make ring sparkles appear in front of Sonic's sprites
		bsr.w	CollectRing				; add 1 ring 
; ---------------------------------------------------------------------------

RLoss_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1				; get ring animation script
		bsr.w	AnimateSprite				; advance ring animation
		bra.w	DisplaySprite				; display ring sprite
; ===========================================================================

RLoss_Delete:	; Routine 8
		bra.w	DeleteObject				; delete this ring

