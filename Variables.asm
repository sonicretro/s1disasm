; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; Variables (v) and Flags (f)

	phase ramaddr ( $FFFF0000 )
v_ram_start:

v_256x256:		ds.b	$52*$200	; 256x256 tile mappings ($52 chunks)
v_256x256_end:

v_lvllayout:		ds.b	$400		; level and background layouts
v_lvllayout_end:
v_bgscroll_buffer:	ds.b	$200		; background scroll buffer
v_ngfx_buffer:		ds.b	$200		; Nemesis graphics decompression buffer
v_ngfx_buffer_end:
v_spritequeue:		ds.b	$400		; sprite display queue, in order of priority
v_16x16:		ds.b	$1800		; 16x16 tile mappings

v_sgfx_buffer:		ds.b	$2E0		; buffered Sonic graphics ($17 cells)
			ds.b	$20		; unused
v_tracksonic:		ds.b	$100		; position tracking data for Sonic
v_hscrolltablebuffer:	ds.b	$380		; scrolling table data
v_hscrolltablebuffer_end:
			ds.b	$80		; unused
v_hscrolltablebuffer_end_padded:

v_objspace:		ds.b	object_size*$80	; object variable space ($40 bytes per object)

; Title screen objects
v_sonicteam	= v_objspace+object_size*2	; object variable space for the "SONIC TEAM PRESENTS" text ($40 bytes)
v_titlesonic	= v_objspace+object_size*1	; object variable space for Sonic in the title screen ($40 bytes)
v_pressstart	= v_objspace+object_size*2	; object variable space for the "PRESS START BUTTON" text ($40 bytes)
v_titletm	= v_objspace+object_size*3	; object variable space for the trademark symbol ($40 bytes)
v_ttlsonichide	= v_objspace+object_size*4	; object variable space for hiding part of Sonic ($40 bytes)

; Level objects
v_player	= v_objspace+object_size*0	; object variable space for Sonic ($40 bytes)
v_hud		= v_objspace+object_size*1	; object variable space for the HUD ($40 bytes)

v_titlecard	= v_objspace+object_size*2	; object variable space for the title card ($100 bytes)
v_ttlcardname	= v_titlecard+object_size*0		; object variable space for the title card zone name text ($40 bytes)
v_ttlcardzone	= v_titlecard+object_size*1	; object variable space for the title card "ZONE" text ($40 bytes)
v_ttlcardact	= v_titlecard+object_size*2	; object variable space for the title card act text ($40 bytes)
v_ttlcardoval	= v_titlecard+object_size*3	; object variable space for the title card oval ($40 bytes)

v_gameovertext1	= v_objspace+object_size*2	; object variable space for the "GAME"/"TIME" in "GAME OVER"/"TIME OVER" text ($40 bytes)
v_gameovertext2	= v_objspace+object_size*3	; object variable space for the "OVER" in "GAME OVER"/"TIME OVER" text ($40 bytes)

v_shieldobj	= v_objspace+object_size*6	; object variable space for the shield ($40 bytes)
v_starsobj1	= v_objspace+object_size*8	; object variable space for the invincibility stars #1 ($40 bytes)
v_starsobj2	= v_objspace+object_size*9	; object variable space for the invincibility stars #2 ($40 bytes)
v_starsobj3	= v_objspace+object_size*10	; object variable space for the invincibility stars #3 ($40 bytes)
v_starsobj4	= v_objspace+object_size*11	; object variable space for the invincibility stars #4 ($40 bytes)

v_splash	= v_objspace+object_size*12	; object variable space for the water splash ($40 bytes)
v_sonicbubbles	= v_objspace+object_size*13	; object variable space for the bubbles that come out of Sonic's mouth/drown countdown ($40 bytes)
v_watersurface1	= v_objspace+object_size*30	; object variable space for the water surface #1 ($40 bytes)
v_watersurface2	= v_objspace+object_size*31	; object variable space for the water surface #1 ($40 bytes)

v_endcard	= v_objspace+object_size*23	; object variable space for the level results card ($1C0 bytes)
v_endcardsonic	= v_endcard+object_size*0	; object variable space for the level results card "SONIC HAS" text ($40 bytes)
v_endcardpassed	= v_endcard+object_size*1	; object variable space for the level results card "PASSED" text ($40 bytes)
v_endcardact	= v_endcard+object_size*2	; object variable space for the level results card act text ($40 bytes)
v_endcardscore	= v_endcard+object_size*3	; object variable space for the level results card score tally ($40 bytes)
v_endcardtime	= v_endcard+object_size*4	; object variable space for the level results card time bonus tally ($40 bytes)
v_endcardring	= v_endcard+object_size*5	; object variable space for the level results card ring bonus tally ($40 bytes)
v_endcardoval	= v_endcard+object_size*6	; object variable space for the level results card oval ($40 bytes)

v_lvlobjspace	= v_objspace+object_size*32	; level object variable space ($1800 bytes)
v_lvlobjend	= v_lvlobjspace+object_size*96
v_objend	= v_lvlobjend

; Special Stage objects
v_ssrescard	= v_objspace+object_size*23	; object variable space for the Special Stage results card ($140 bytes)
v_ssrestext	= v_ssrescard+object_size*0	; object variable space for the Special Stage results card text ($40 bytes)
v_ssresscore	= v_ssrescard+object_size*1	; object variable space for the Special Stage results card score tally ($40 bytes)
v_ssresring	= v_ssrescard+object_size*2	; object variable space for the Special Stage results card ring bonus tally ($40 bytes)
v_ssresoval	= v_ssrescard+object_size*3	; object variable space for the Special Stage results card oval ($40 bytes)
v_ssrescontinue	= v_ssrescard+object_size*4	; object variable space for the Special Stage results card continue icon ($40 bytes)
v_ssresemeralds	= v_objspace+object_size*32	; object variable space for the emeralds in the Special Stage results ($180 bytes)

; Continue screen objects
v_continuetext	= v_objspace+object_size*1	; object variable space for the continue screen text ($40 bytes)
v_continuelight	= v_objspace+object_size*2	; object variable space for the continue screen light spot ($40 bytes)
v_continueicon	= v_objspace+object_size*3	; object variable space for the continue screen icon ($40 bytes)

; Ending objects
v_endemeralds	= v_objspace+object_size*16	; object variable space for the emeralds in the ending ($180 bytes)
v_endemeralds_end	= v_objspace+object_size*32
v_endlogo	= v_objspace+object_size*16	; object variable space for the logo in the ending ($40 bytes)

; Credits objects
v_credits	= v_objspace+object_size*2	; object variable space for the credits text ($40 bytes)
v_endeggman	= v_objspace+object_size*2	; object variable space for Eggman after the credits ($40 bytes)
v_tryagain	= v_objspace+object_size*3	; object variable space for the "TRY AGAIN" text ($40 bytes)
v_eggmanchaos	= v_objspace+object_size*32	; object variable space for the emeralds juggled by Eggman ($180 bytes)

v_snddriver_ram:	ds.b	$5C0		; start of RAM for the sound driver data
			ds.b	$40		; unused

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================
v_startofvariables:	= $000
v_sndprio:		= $000	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	= $001	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		= $002	; Used for music only
f_pausemusic:		= $003	; flag set to stop music when paused
v_fadeout_counter:	= $004

v_fadeout_delay:	= $006
v_communication_byte:	= $007	; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		= $008	; $80 if updating DAC, $00 otherwise
v_sound_id:		= $009	; sound or music copied from below
v_soundqueue_start:	= $00A
v_soundqueue0:		= v_soundqueue_start+0	; sound or music to play
v_soundqueue1:		= v_soundqueue_start+1	; special sound to play
v_soundqueue2:		= v_soundqueue_start+2	; unused sound to play
v_soundqueue_end:	= v_soundqueue_start+3

f_voice_selector:	= $00E	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		= $018	; voice data pointer (4 bytes)

v_special_voice_ptr:	= $020	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		= $024	; Flag for fade in
v_fadein_delay:		= $025
v_fadein_counter:	= $026	; Timer for fade in/out
f_1up_playing:		= $027	; flag indicating 1-up song is playing
v_tempo_mod:		= $028	; music - tempo modifier
v_speeduptempo:		= $029	; music - tempo modifier with speed shoes
f_speedup:		= $02A	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		= $02B	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		= $02C	; if set, prevents further push sounds from playing

v_music_track_ram:	= $040	; Start of music RAM

v_music_fmdac_tracks:	= v_music_track_ram+TrackSz*0
v_music_dac_track:	= v_music_fmdac_tracks+TrackSz*0
v_music_fm_tracks:	= v_music_fmdac_tracks+TrackSz*1
v_music_fm1_track:	= v_music_fm_tracks+TrackSz*0
v_music_fm2_track:	= v_music_fm_tracks+TrackSz*1
v_music_fm3_track:	= v_music_fm_tracks+TrackSz*2
v_music_fm4_track:	= v_music_fm_tracks+TrackSz*3
v_music_fm5_track:	= v_music_fm_tracks+TrackSz*4
v_music_fm6_track:	= v_music_fm_tracks+TrackSz*5
v_music_fm_tracks_end:	= v_music_fm_tracks+TrackSz*6
v_music_fmdac_tracks_end:	= v_music_fm_tracks_end
v_music_psg_tracks:	= v_music_fmdac_tracks_end
v_music_psg1_track:	= v_music_psg_tracks+TrackSz*0
v_music_psg2_track:	= v_music_psg_tracks+TrackSz*1
v_music_psg3_track:	= v_music_psg_tracks+TrackSz*2
v_music_psg_tracks_end:	= v_music_psg_tracks+TrackSz*3
v_music_track_ram_end:	= v_music_psg_tracks_end

v_sfx_track_ram:	= v_music_track_ram_end	; Start of SFX RAM, straight after the end of music RAM

v_sfx_fm_tracks:	= v_sfx_track_ram+TrackSz*0
v_sfx_fm3_track:	= v_sfx_fm_tracks+TrackSz*0
v_sfx_fm4_track:	= v_sfx_fm_tracks+TrackSz*1
v_sfx_fm5_track:	= v_sfx_fm_tracks+TrackSz*2
v_sfx_fm_tracks_end:	= v_sfx_fm_tracks+TrackSz*3
v_sfx_psg_tracks:	= v_sfx_fm_tracks_end
v_sfx_psg1_track:	= v_sfx_psg_tracks+TrackSz*0
v_sfx_psg2_track:	= v_sfx_psg_tracks+TrackSz*1
v_sfx_psg3_track:	= v_sfx_psg_tracks+TrackSz*2
v_sfx_psg_tracks_end:	= v_sfx_psg_tracks+TrackSz*3
v_sfx_track_ram_end:	= v_sfx_psg_tracks_end

v_spcsfx_track_ram:	= v_sfx_track_ram_end	; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	= v_spcsfx_track_ram+TrackSz*0
v_spcsfx_psg3_track:	= v_spcsfx_track_ram+TrackSz*1
v_spcsfx_track_ram_end:	= v_spcsfx_track_ram+TrackSz*2

v_1up_ram_copy:		= v_spcsfx_track_ram_end

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode:		ds.b	1		; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
			ds.b	1		; unused
v_jpadhold2:		ds.b	1		; joypad input - held, duplicate
v_jpadpress2:		ds.b	1		; joypad input - pressed, duplicate
v_jpadhold1:		ds.b	1		; joypad input - held
v_jpadpress1:		ds.b	1		; joypad input - pressed
			ds.b	6		; unused
v_vdp_buffer1:		ds.w	1		; VDP instruction buffer
			ds.b	6		; unused
v_demolength:		ds.w	1		; the length of a demo in frames
v_scrposy_vdp:		ds.w	1		; screen position y (VDP)
v_bgscrposy_vdp:	ds.w	1		; background screen position y (VDP)
v_scrposx_vdp:		ds.w	1		; screen position x (VDP)
v_bgscrposx_vdp:	ds.w	1		; background screen position x (VDP)
v_bg3scrposy_vdp:	ds.w	1
v_bg3scrposx_vdp:	ds.w	1
			ds.b	2		; unused
v_hbla_hreg:		ds.w	1		; VDP H.interrupt register buffer (8Axx)
v_hbla_line = v_hbla_hreg+1			; screen line where water starts and palette is changed by HBlank
v_pfade_start:		ds.b	1		; palette fading - start position in bytes
v_pfade_size:		ds.b	1		; palette fading - number of colours

v_misc_variables:
v_vbla_0e_counter:	ds.b	1		; tracks how many times vertical interrupts routine 0E occured (pretty much unused because routine 0E is unused)
			ds.b	1		; unused
v_vbla_routine:		ds.b	1		; VBlank - routine counter
			ds.b	1		; unused
v_spritecount:		ds.b	1		; number of sprites on-screen
			ds.b	5		; unused
v_pcyc_num:		ds.w	1		; palette cycling - current reference number
v_pcyc_time:		ds.w	1		; palette cycling - time until the next change
v_random:		ds.l	1		; pseudo random number buffer
f_pause:		ds.w	1		; flag set to pause the game
			ds.b	4		; unused
v_vdp_buffer2:		ds.w	1		; VDP instruction buffer
			ds.b	2		; unused
f_hbla_pal:		ds.w	1		; flag set to change palette during HBlank (0000 = no; 0001 = change)
v_waterpos1:		ds.w	1		; water height, actual
v_waterpos2:		ds.w	1		; water height, ignoring sway
v_waterpos3:		ds.w	1		; water height, next target
f_water:		ds.b	1		; flag set for water
v_wtr_routine:		ds.b	1		; water event - routine counter
f_wtr_state:		ds.b	1		; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)
f_doupdatesinhblank:	ds.b	1		; defers performing various tasks to the Horizontal Interrupt (H-Blank)
v_pal_buffer:		ds.b	$30		; palette data buffer (used for palette cycling)
v_misc_variables_end:

v_plc_buffer:		ds.b	6*16		; pattern load cues buffer (maximum $10 PLCs)
v_plc_buffer_only_end:
v_plc_ptrnemcode:	ds.l	1		; pointer for nemesis decompression code ($1502 or $150C)
v_plc_repeatcount:	ds.l	1
v_plc_paletteindex:	ds.l	1
v_plc_previousrow:	ds.l	1
v_plc_dataword:		ds.l	1
v_plc_shiftvalue:	ds.l	1
v_plc_patternsleft:	ds.w	1
v_plc_framepatternsleft:ds.w	1
			ds.b	4		; unused
v_plc_buffer_end:

v_levelvariables:				; variables that are reset between levels
v_screenposx:		ds.l	1		; screen position x
v_screenposy:		ds.l	1		; screen position y
v_bgscreenposx:		ds.l	1		; background screen position x
v_bgscreenposy:		ds.l	1		; background screen position y
v_bg2screenposx:	ds.l	1
v_bg2screenposy:	ds.l	1
v_bg3screenposx:	ds.l	1
v_bg3screenposy:	ds.l	1
v_limitleft1:		ds.w	1		; left level boundary (unused)
v_limitright1:		ds.w	1		; right level boundary (unused)
v_limittop1:		ds.w	1		; top level boundary (unused)
v_limitbtm1:		ds.w	1		; bottom level boundary
v_limitleft2:		ds.w	1		; left level boundary
v_limitright2:		ds.w	1		; right level boundary
v_limittop2:		ds.w	1		; top level boundary
v_limitbtm2:		ds.w	1		; bottom level boundary
v_unused11:		ds.w	1		; unused
v_limitleft3:		ds.w	1		; left level boundary, at the end of an act
			ds.b	6		; unused
v_scrshiftx:		ds.w	1		; x-screen shift (new - last) * $100
v_scrshifty:		ds.w	1		; y-screen shift (new - last) * $100
v_lookshift:		ds.w	1		; screen shift when Sonic looks up/down
v_unused7:		ds.b	1		; unused
v_unused8:		ds.b	1		; unused
v_dle_routine:		ds.b	1		; dynamic level event - routine counter
			ds.b	1		; unused
f_nobgscroll:		ds.b	1		; flag set to cancel background scrolling
			ds.b	1		; unused
v_unused9:		ds.b	1		; unused
			ds.b	1		; unused
v_unused10:		ds.b	1		; unused
			ds.b	1		; unused
v_fg_xblock:		ds.b	1		; foreground x-block parity (for redraw)
v_fg_yblock:		ds.b	1		; foreground y-block parity (for redraw)
v_bg1_xblock:		ds.b	1		; background x-block parity (for redraw)
v_bg1_yblock:		ds.b	1		; background y-block parity (for redraw)
v_bg2_xblock:		ds.b	1		; secondary background x-block parity (for redraw)
v_bg2_yblock:		ds.b	1		; secondary background y-block parity (unused)
v_bg3_xblock:		ds.b	1		; teritary background x-block parity (for redraw)
v_bg3_yblock:		ds.b	1		; teritary background y-block parity (unused)
			ds.b	2		; unused
v_fg_scroll_flags:	ds.w	1		; screen redraw flags for foreground
v_bg1_scroll_flags:	ds.w	1		; screen redraw flags for background 1
v_bg2_scroll_flags:	ds.w	1		; screen redraw flags for background 2
v_bg3_scroll_flags:	ds.w	1		; screen redraw flags for background 3
f_bgscrollvert:		ds.b	1		; flag for vertical background scrolling
			ds.b	3		; unused
v_sonspeedmax:		ds.w	1		; Sonic's maximum speed
v_sonspeedacc:		ds.w	1		; Sonic's acceleration
v_sonspeeddec:		ds.w	1		; Sonic's deceleration
v_sonframenum:		ds.b	1		; frame to display for Sonic
f_sonframechg:		ds.b	1		; flag set to update Sonic's sprite frame
v_anglebuffer:		ds.b	1		; angle of collision block that Sonic or object is standing on
			ds.b	1		; unused
v_anglebuffer2:		ds.b	1		; other angle of collision block that Sonic or object is standing on
			ds.b	1		; unused
v_opl_routine:		ds.b	1		; ObjPosLoad - routine counter
			ds.b	1		; unused
v_opl_screen:		ds.w	1		; ObjPosLoad - screen variable
v_opl_data:		ds.b	$10		; ObjPosLoad - data buffer
v_ssangle:		ds.w	1		; Special Stage angle
v_ssrotate:		ds.w	1		; Special Stage rotation speed
			ds.b	$C		; unused
v_btnpushtime1:		ds.w	1		; button push duration - in level
v_btnpushtime2:		ds.w	1		; button push duration - in demo
v_palchgspeed:		ds.w	1		; palette fade/transition speed (0 is fastest)
v_collindex:		ds.l	1		; ROM address for collision index of current level
v_palss_num:		ds.w	1		; palette cycling in Special Stage - reference number
v_palss_time:		ds.w	1		; palette cycling in Special Stage - time until next change
v_palss_index:		ds.w	1		; palette cycling in Special Stage - index into palette cycle 2 (unused?)
v_ssbganim:		ds.w	1		; Special Stage background animation
			ds.b	2		; unused
v_obj31ypos:		ds.w	1		; y-position of object 31 (MZ stomper)
			ds.b	1		; unused
v_bossstatus:		ds.b	1		; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)
v_trackpos:		ds.w	1		; position tracking reference number
v_trackbyte = v_trackpos+1			; low byte for position tracking
f_lockscreen:		ds.b	1		; flag set to lock screen during bosses
			ds.b	1		; unused
v_256loop1:		ds.b	1		; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:		ds.b	1		; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:		ds.b	1		; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:		ds.b	1		; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame:		ds.b	1		; level graphics animation 0 - current frame
v_lani0_time:		ds.b	1		; level graphics animation 0 - time until next frame
v_lani1_frame:		ds.b	1		; level graphics animation 1 - current frame
v_lani1_time:		ds.b	1		; level graphics animation 1 - time until next frame
v_lani2_frame:		ds.b	1		; level graphics animation 2 - current frame
v_lani2_time:		ds.b	1		; level graphics animation 2 - time until next frame
v_lani3_frame:		ds.b	1		; level graphics animation 3 - current frame
v_lani3_time:		ds.b	1		; level graphics animation 3 - time until next frame
v_lani4_frame:		ds.b	1		; level graphics animation 4 - current frame
v_lani4_time:		ds.b	1		; level graphics animation 4 - time until next frame
v_lani5_frame:		ds.b	1		; level graphics animation 5 - current frame
v_lani5_time:		ds.b	1		; level graphics animation 5 - time until next frame
			ds.b	2		; unused
v_gfxbigring:		ds.w	1		; settings for giant ring graphics loading
f_conveyrev:		ds.b	1		; flag set to reverse conveyor belts in LZ/SBZ
v_obj63:		ds.b	6		; object 63 (LZ/SBZ platforms) variables
f_wtunnelmode:		ds.b	1		; LZ water tunnel mode
f_playerctrl:		ds.b	1		; Player control override flags (object ineraction, control enable)
f_wtunnelallow:		ds.b	1		; LZ water tunnels (00 = enabled; 01 = disabled)
f_slidemode:		ds.b	1		; LZ water slide mode
v_obj6B:		ds.b	1		; object 6B (SBZ stomper) variable
f_lockctrl:		ds.b	1		; flag set to lock controls during ending sequence
f_bigring:		ds.b	1		; flag set when Sonic collects the giant ring
f_obj56:		ds.b	1		; object 56 flag
			ds.b	1		; unused
v_itembonus:		ds.w	1		; item bonus from broken enemies, blocks etc.
v_timebonus:		ds.w	1		; time bonus at the end of an act
v_ringbonus:		ds.w	1		; ring bonus at the end of an act
f_endactbonus:		ds.b	1		; time/ring bonus update flag at the end of an act
v_sonicend:		ds.b	1		; routine counter for Sonic in the ending sequence
v_lz_deform:		ds.w	1		; LZ deformation offset, in units of $80
			ds.b	6		; unused
f_switch:		ds.b	$10		; flags set when Sonic stands on a switch
v_scroll_block_1_size:	ds.w	1
v_scroll_block_2_size:	ds.w	1		; unused
v_scroll_block_3_size:	ds.w	1		; unused
v_scroll_block_4_size:	ds.w	1		; unused
			ds.b	8		; unused
v_levelvariables_end:

v_spritetablebuffer:	ds.b	$280		; sprite table (last $80 bytes are overwritten by v_pal_water_dup)
v_spritetablebuffer_end:
v_pal_water_dup = v_spritetablebuffer_end-$80	; duplicate underwater palette, used for transitions ($80 bytes)
v_pal_water:		ds.b	$80		; main underwater palette
v_pal_dry:		ds.b	$80		; main palette
v_pal_dry_dup:		ds.b	$80		; duplicate palette, used for transitions
v_objstate:		ds.b	$C0		; object state list
v_objstate_end:
			ds.b	$140		; stack
v_systemstack:
v_crossresetram:				; RAM beyond this point is only cleared on a cold-boot
			ds.b	2		; unused
f_restart:		ds.w	1		; restart level flag
v_framecount:		ds.w	1		; frame counter (adds 1 every frame)
v_framebyte = v_framecount+1			; low byte for frame counter
v_debugitem:		ds.b	1		; debug item currently selected (NOT the object number of the item)
			ds.b	1		; unused
v_debuguse:		ds.w	1		; debug mode use & routine counter (when Sonic is a ring/item)
v_debugxspeed:		ds.b	1		; debug mode - horizontal speed
v_debugyspeed:		ds.b	1		; debug mode - vertical speed
v_vbla_count:		ds.l	1		; vertical interrupt counter (adds 1 every VBlank)
v_vbla_word = v_vbla_count+2 			; low word for vertical interrupt counter (2 bytes)
v_vbla_byte = v_vbla_word+1			; low byte for vertical interrupt counter
v_zone:			ds.b	1		; current zone number
v_act:			ds.b	1		; current act number
v_lives:		ds.b	1		; number of lives
			ds.b	1		; unused
v_air:			ds.w	1		; air remaining while underwater
v_airbyte = v_air+1				; low byte for air
v_lastspecial:		ds.b	1		; last special stage number
			ds.b	1		; unused
v_continues:		ds.b	1		; number of continues
			ds.b	1		; unused
f_timeover:		ds.b	1		; time over flag
v_lifecount:		ds.b	1		; lives counter value (for actual number, see "v_lives")
f_lifecount:		ds.b	1		; lives counter update flag
f_ringcount:		ds.b	1		; ring counter update flag
f_timecount:		ds.b	1		; time counter update flag
f_scorecount:		ds.b	1		; score counter update flag
v_rings:		ds.w	1		; rings
v_ringbyte = v_rings+1				; low byte for rings
v_time:			ds.l	1		; time
v_timemin = v_time+1				; time - minutes
v_timesec = v_time+2				; time - seconds
v_timecent = v_time+3				; time - centiseconds
v_score:		ds.l	1		; score
			ds.b	2		; unused
v_shield:		ds.b	1		; shield status (00 = no; 01 = yes)
v_invinc:		ds.b	1		; invinciblity status (00 = no; 01 = yes)
v_shoes:		ds.b	1		; speed shoes status (00 = no; 01 = yes)
v_unused1:		ds.b	1		; an unused fourth player status (Goggles?)

v_lastlamp:		ds.b	2		; number of the last lamppost you hit
v_lamp_xpos:		ds.w	1		; x-axis for Sonic to respawn at lamppost
v_lamp_ypos:		ds.w	1		; y-axis for Sonic to respawn at lamppost
v_lamp_rings:		ds.w	1		; rings stored at lamppost
v_lamp_time:		ds.l	1		; time stored at lamppost
v_lamp_dle:		ds.b	1		; dynamic level event routine counter at lamppost
			ds.b	1		; unused
v_lamp_limitbtm:	ds.w	1		; level bottom boundary at lamppost
v_lamp_scrx:		ds.w	1		; x-axis screen at lamppost
v_lamp_scry:		ds.w	1		; y-axis screen at lamppost
v_lamp_bgscrx:		ds.w	1		; x-axis BG screen at lamppost
v_lamp_bgscry:		ds.w	1		; y-axis BG screen at lamppost
v_lamp_bg2scrx:		ds.w	1		; x-axis BG2 screen at lamppost
v_lamp_bg2scry:		ds.w	1		; y-axis BG2 screen at lamppost
v_lamp_bg3scrx:		ds.w	1		; x-axis BG3 screen at lamppost
v_lamp_bg3scry:		ds.w	1		; y-axis BG3 screen at lamppost
v_lamp_wtrpos:		ds.w	1		; water position at lamppost
v_lamp_wtrrout:		ds.b	1		; water routine at lamppost
v_lamp_wtrstat:		ds.b	1		; water state at lamppost
v_lamp_lives:		ds.b	1		; lives counter at lamppost
			ds.b	2		; unused
v_emeralds:		ds.b	1		; number of chaos emeralds
v_emldlist:		ds.b	6		; which individual emeralds you have (00 = no; 01 = yes)
v_oscillate:		ds.w	1		; oscillation bitfield
v_timingandscreenvariables:
v_timingvariables:
			ds.b	$40		; values which oscillate - for swinging platforms, et al
			ds.b	$20		; unused
v_ani0_time:		ds.b	1		; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		ds.b	1		; synchronised sprite animation 0 - current frame
v_ani1_time:		ds.b	1		; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		ds.b	1		; synchronised sprite animation 1 - current frame
v_ani2_time:		ds.b	1		; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		ds.b	1		; synchronised sprite animation 2 - current frame
v_ani3_time:		ds.b	1		; synchronised sprite animation 3 - time until next frame
v_ani3_frame:		ds.b	1		; synchronised sprite animation 3 - current frame
v_ani3_buf:		ds.w	1		; synchronised sprite animation 3 - info buffer
			ds.b	$26		; unused
v_limittopdb:		ds.w	1		; level upper boundary, buffered for debug mode
v_limitbtmdb:		ds.w	1		; level bottom boundary, buffered for debug mode
			ds.b	$C		; unused
v_timingvariables_end:

v_chunk0collision:	ds.w	1		; very subtly (and perhaps unintentionally) used by FindNearestTile when encountering chunk 0
	if v_chunk0collision<>ramaddr($FFFFFF00)
		fatal "v_chunk0collision needs to be at address $FFFFFF00 so that FindNearestTile works correctly."
	endif
			ds.b	$E		; unused
v_screenposx_dup:	ds.l	1		; screen position x (duplicate)
v_screenposy_dup:	ds.l	1		; screen position y (duplicate)
v_bgscreenposx_dup:	ds.l	1		; background screen position x (duplicate)
v_bgscreenposy_dup:	ds.l	1		; background screen position y (duplicate)
v_bg2screenposx_dup:	ds.l	1
v_bg2screenposy_dup:	ds.l	1
v_bg3screenposx_dup:	ds.l	1
v_bg3screenposy_dup:	ds.l	1
v_fg_scroll_flags_dup:	ds.w	1
v_bg1_scroll_flags_dup:	ds.w	1
v_bg2_scroll_flags_dup:	ds.w	1
v_bg3_scroll_flags_dup:	ds.w	1
			ds.b	$48		; unused
v_timingandscreenvariables_end:

v_levseldelay:		ds.w	1		; level select - time until change when up/down is held
v_levselitem:		ds.w	1		; level select - item selected
v_levselsound:		ds.w	1		; level select - sound selected
			ds.b	$3A		; unused
	if Revision=0
v_scorecopy:		ds.l	1		; score, duplicate
	else
v_scorelife:		ds.l	1		; points required for an extra life (JP1 only)
	endif
			ds.b	$1C		; unused
f_levselcheat:		ds.b	1		; level select cheat flag
f_slomocheat:		ds.b	1		; slow motion & frame advance cheat flag
f_debugcheat:		ds.b	1		; debug mode cheat flag
f_creditscheat:		ds.b	1		; hidden credits & press start cheat flag
v_title_dcount:		ds.w	1		; number of times the d-pad is pressed on title screen
v_title_ccount:		ds.w	1		; number of times C is pressed on title screen
			ds.b	2		; unused
v_unused2:		ds.w	1		; unused
v_unused3:		ds.b	1		; unused
v_unused4:		ds.b	1		; unused
v_unused5:		ds.b	1		; unused
v_unused6:		ds.b	1		; unused
f_demo:			ds.w	1		; demo mode flag (0 = no; 1 = yes; $8001 = ending)
v_demonum:		ds.w	1		; demo level number (not the same as the level number)
v_creditsnum:		ds.w	1		; credits index number
			ds.b	2		; unused
v_megadrive:		ds.b	1		; Megadrive machine type
			ds.b	1		; unused
f_debugmode:		ds.w	1		; debug mode flag
v_init:			ds.l	1		; 'init' text string
v_ram_end:
    if * > 0	; Don't declare more space than the RAM can contain!
	fatal "The RAM variable declarations are too large by $\{*} bytes."
    endif
	dephase

; Special stage
v_ssbuffer1		= v_256x256
v_ssblockbuffer		= v_ssbuffer1+$1020 ; ($2000 bytes)
v_ssblockbuffer_end	= v_ssblockbuffer+$80*$40
v_ssbuffer2		= v_256x256+$4000
v_ssblocktypes		= v_ssbuffer2
v_ssitembuffer		= v_ssbuffer2+$400 ; ($100 bytes)
v_ssitembuffer_end	= v_ssitembuffer+$100
v_ssbuffer3		= v_256x256+$8000
v_ssscroll_buffer	= v_ngfx_buffer+$100

; Error handler
	phase v_objstate
v_regbuffer:	ds.b	$40	; stores registers d0-a7 during an error event
v_spbuffer:	ds.l	1	; stores most recent sp address
v_errortype:	ds.b	1	; error type
	dephase

	!org 0
