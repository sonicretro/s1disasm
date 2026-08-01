; ===========================================================================
; ---------------------------------------------------------------------------
; Object code execution subroutine
; 
; output:
;	d7.l = OST index of last object (must not be changed by any object)
;	a0 = address of OST of last object
; ---------------------------------------------------------------------------

ExecuteObjects:
		lea	(v_objspace).w,a0			; set address for object RAM
		moveq	#(v_objspace_end-v_objspace)/object_size-1,d7 ; $80 objects - 1
		moveq	#0,d0					; clear d0
		cmpi.b	#6,(v_player+obRoutine).w		; is Sonic dying?
		bhs.s	.sonic_dead				; if yes, branch to alternate logic

; loc_D348:
.run_object:
		move.b	(a0),d0					; load object ID from RAM
		beq.s	.next_object				; if ID is 0, this is an empty object slot, branch
		add.w	d0,d0					; quadruple for...
		add.w	d0,d0					; ...long-based indexing
		movea.l	Obj_Index-4(pc,d0.w),a1			; find relevant object pointer (minus -4 because entries skip ID 00)
		jsr	(a1)					; run the object's code
		moveq	#0,d0					; clear d0 for next loop

	; loc_D358:
	.next_object:
		lea	object_size(a0),a0			; increase a0 to go to next object entry ($40 bytes)
		dbf	d7,.run_object				; loop until all objects have been executed
		rts						; return
; ===========================================================================

; Separate logic while Sonic is dying, used to freeze level objects in place
; while still executing reserved objects normally (mainly Sonic himself).

; loc_D362:
.sonic_dead:
		moveq	#(v_lvlobjspace-v_objspace)/object_size-1,d7 ; run first 32 objects normally (reserved objects like Sonic)
		bsr.s	.run_object				; execute those objects and return here

		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d7 ; run the remaining 96 objects in display-only mode
; loc_D368:
.display_object:
		moveq	#0,d0					; clear d0
		move.b	obID(a0),d0				; load object ID from RAM
		beq.s	.next_object_displayonly		; if ID is 0, this is an empty object slot, branch
		tst.b	obRender(a0)				; was object on-screen as Sonic died?
		bpl.s	.next_object_displayonly		; if not, branch
		bsr.w	DisplaySprite				; keep displaying the object as Sonic dies but don't execute it

	; loc_D378:
	.next_object_displayonly:
		lea	object_size(a0),a0			; increase a0 to go to next object entry ($40 bytes)
		dbf	d7,.display_object			; loop until all objects have been executed
		rts						; return
; End of function ExecuteObjects
