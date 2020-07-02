; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; Variables (v) and Flags (f)

v_regbuffer	= ramaddr ( $FFFFFC00 )	; stores registers d0-a7 during an error event ($40 bytes)
v_spbuffer	= ramaddr ( $FFFFFC40 )	; stores most recent sp address (4 bytes)
v_errortype	= ramaddr ( $FFFFFC44 )	; error type

v_256x256	= ramaddr (   $FF0000 )	; 256x256 tile mappings ($A400 bytes)
v_lvllayout	= ramaddr ( $FFFFA400 )	; level and background layouts ($400 bytes)
v_bgscroll_buffer	= ramaddr( $FFFFA800 )	; background scroll buffer ($200 bytes)
v_ngfx_buffer	= ramaddr ( $FFFFAA00 )	; Nemesis graphics decompression buffer ($200 bytes)
v_spritequeue	= ramaddr ( $FFFFAC00 )	; sprite display queue, in order of priority ($400 bytes)
v_16x16	= ramaddr ( $FFFFB000 )	; 16x16 tile mappings

v_sgfx_buffer	= ramaddr ( $FFFFC800 )	; buffered Sonic graphics ($17 cells) ($2E0 bytes)
v_tracksonic	= ramaddr ( $FFFFCB00 )	; position tracking data for Sonic ($100 bytes)
v_hscrolltablebuffer	= ramaddr ( $FFFFCC00 )	; scrolling table data (actually $380 bytes, but $400 is reserved for it)
v_objspace	= ramaddr ( $FFFFD000 )	; object variable space ($40 bytes per object) ($2000 bytes)
v_player	= v_objspace	; object variable space for Sonic ($40 bytes)
v_lvlobjspace	= ramaddr ( $FFFFD800 )	; level object variable space ($1800 bytes)

v_snddriver_ram  = ramaddr ( $FFFFF000 )	; start of RAM for the sound driver data ($5C0 bytes)

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
v_soundqueue0:		= $00A	; sound or music to play
v_soundqueue1:		= $00B	; special sound to play
v_soundqueue2:		= $00C	; unused sound to play

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

v_gamemode	= ramaddr ( $FFFFF600 )	; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
v_jpadhold2	= ramaddr ( $FFFFF602 )	; joypad input - held, duplicate
v_jpadpress2	= ramaddr ( $FFFFF603 )	; joypad input - pressed, duplicate
v_jpadhold1	= ramaddr ( $FFFFF604 )	; joypad input - held
v_jpadpress1	= ramaddr ( $FFFFF605 )	; joypad input - pressed

v_vdp_buffer1	= ramaddr ( $FFFFF60C )	; VDP instruction buffer (2 bytes)

v_demolength	= ramaddr ( $FFFFF614 )	; the length of a demo in frames (2 bytes)
v_scrposy_dup	= ramaddr ( $FFFFF616 )	; screen position y (duplicate) (2 bytes)
v_bgscrposy_dup	= ramaddr ( $FFFFF618 )	; background screen position y (duplicate) (2 bytes)
v_scrposx_dup	= ramaddr ( $FFFFF61A )	; screen position x (duplicate) (2 bytes)
v_bgscreenposx_dup_unused	= ramaddr ( $FFFFF61C )	; background screen position x (duplicate) (2 bytes)
v_bg3screenposy_dup_unused	= ramaddr ( $FFFFF61E )	; (2 bytes)
v_bg3screenposx_dup_unused	= ramaddr ( $FFFFF620 )	; (2 bytes)

v_hbla_hreg	= ramaddr ( $FFFFF624 )	; VDP H.interrupt register buffer (8Axx) (2 bytes)
v_hbla_line	= ramaddr ( $FFFFF625 )	; screen line where water starts and palette is changed by HBlank
v_pfade_start	= ramaddr ( $FFFFF626 )	; palette fading - start position in bytes
v_pfade_size	= ramaddr ( $FFFFF627 )	; palette fading - number of colours
v_vbla_routine	= ramaddr ( $FFFFF62A )	; VBlank - routine counter
v_spritecount	= ramaddr ( $FFFFF62C )	; number of sprites on-screen
v_pcyc_num	= ramaddr ( $FFFFF632 )	; palette cycling - current reference number (2 bytes)
v_pcyc_time	= ramaddr ( $FFFFF634 )	; palette cycling - time until the next change (2 bytes)
v_random	= ramaddr ( $FFFFF636 )	; pseudo random number buffer (4 bytes)
f_pause	= ramaddr ( $FFFFF63A )	; flag set to pause the game (2 bytes)
v_vdp_buffer2	= ramaddr ( $FFFFF640 )	; VDP instruction buffer (2 bytes)
f_hbla_pal	= ramaddr ( $FFFFF644 )	; flag set to change palette during HBlank (0000 = no; 0001 = change) (2 bytes)
v_waterpos1	= ramaddr ( $FFFFF646 )	; water height, actual (2 bytes)
v_waterpos2	= ramaddr ( $FFFFF648 )	; water height, ignoring sway (2 bytes)
v_waterpos3	= ramaddr ( $FFFFF64A )	; water height, next target (2 bytes)
f_water	= ramaddr ( $FFFFF64C )	; flag set for water
v_wtr_routine	= ramaddr ( $FFFFF64D )	; water event - routine counter
f_wtr_state	= ramaddr ( $FFFFF64E )	; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)

v_pal_buffer	= ramaddr ( $FFFFF650 )	; palette data buffer (used for palette cycling) ($30 bytes)
v_plc_buffer	= ramaddr ( $FFFFF680 )	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode	= ramaddr ( $FFFFF6E0 )	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)

f_plc_execute	= ramaddr ( $FFFFF6F8 )	; flag set for pattern load cue execution (2 bytes)

v_screenposx	= ramaddr ( $FFFFF700 )	; screen position x (2 bytes)
v_screenposy	= ramaddr ( $FFFFF704 )	; screen position y (2 bytes)
v_bgscreenposx	= ramaddr ( $FFFFF708 )	; background screen position x (2 bytes)
v_bgscreenposy	= ramaddr ( $FFFFF70C )	; background screen position y (2 bytes)
v_bg2screenposx	= ramaddr ( $FFFFF710 )	; 2 bytes
v_bg2screenposy	= ramaddr ( $FFFFF714 )	; 2 bytes
v_bg3screenposx	= ramaddr ( $FFFFF718 )	; 2 bytes
v_bg3screenposy	= ramaddr ( $FFFFF71C )	; 2 bytes

v_limitleft1	= ramaddr ( $FFFFF720 )	; left level boundary (2 bytes)
v_limitright1	= ramaddr ( $FFFFF722 )	; right level boundary (2 bytes)
v_limittop1	= ramaddr ( $FFFFF724 )	; top level boundary (2 bytes)
v_limitbtm1	= ramaddr ( $FFFFF726 )	; bottom level boundary (2 bytes)
v_limitleft2	= ramaddr ( $FFFFF728 )	; left level boundary (2 bytes)
v_limitright2	= ramaddr ( $FFFFF72A )	; right level boundary (2 bytes)
v_limittop2	= ramaddr ( $FFFFF72C )	; top level boundary (2 bytes)
v_limitbtm2	= ramaddr ( $FFFFF72E )	; bottom level boundary (2 bytes)

v_limitleft3	= ramaddr ( $FFFFF732 )	; left level boundary, at the end of an act (2 bytes)

v_scrshiftx	= ramaddr ( $FFFFF73A )	; x-screen shift (new - last) * $100
v_scrshifty	= ramaddr ( $FFFFF73C )	; y-screen shift (new - last) * $100

v_lookshift	= ramaddr ( $FFFFF73E )	; screen shift when Sonic looks up/down (2 bytes)
v_dle_routine	= ramaddr ( $FFFFF742 )	; dynamic level event - routine counter
f_nobgscroll	= ramaddr ( $FFFFF744 )	; flag set to cancel background scrolling

v_fg_xblock	= ramaddr ( $FFFFF74A )	; foreground x-block parity (for redraw)
v_fg_yblock	= ramaddr ( $FFFFF74B )	; foreground y-block parity (for redraw)
v_bg1_xblock	= ramaddr ( $FFFFF74C )	; background x-block parity (for redraw)
v_bg1_yblock	= ramaddr ( $FFFFF74D )	; background y-block parity (for redraw)
v_bg2_xblock	= ramaddr ( $FFFFF74E )	; secondary background x-block parity (for redraw)
v_bg2_yblock	= ramaddr ( $FFFFF74F )	; secondary background y-block parity (unused)
v_bg3_xblock	= ramaddr ( $FFFFF750 )	; teritary background x-block parity (for redraw)
v_bg3_yblock	= ramaddr ( $FFFFF751 )	; teritary background y-block parity (unused)

v_fg_scroll_flags	= ramaddr ( $FFFFF754 )	; screen redraw flags for foreground
v_bg1_scroll_flags	= ramaddr ( $FFFFF756 )	; screen redraw flags for background 1
v_bg2_scroll_flags	= ramaddr ( $FFFFF758 )	; screen redraw flags for background 2
v_bg3_scroll_flags	= ramaddr ( $FFFFF75A )	; screen redraw flags for background 3
f_bgscrollvert	= ramaddr ( $FFFFF75C )	; flag for vertical background scrolling
v_sonspeedmax	= ramaddr ( $FFFFF760 )	; Sonic's maximum speed (2 bytes)
v_sonspeedacc	= ramaddr ( $FFFFF762 )	; Sonic's acceleration (2 bytes)
v_sonspeeddec	= ramaddr ( $FFFFF764 )	; Sonic's deceleration (2 bytes)
v_sonframenum	= ramaddr ( $FFFFF766 )	; frame to display for Sonic
f_sonframechg	= ramaddr ( $FFFFF767 )	; flag set to update Sonic's sprite frame
v_anglebuffer	= ramaddr ( $FFFFF768 )	; angle of collision block that Sonic or object is standing on

v_opl_routine	= ramaddr ( $FFFFF76C )	; ObjPosLoad - routine counter
v_opl_screen	= ramaddr ( $FFFFF76E )	; ObjPosLoad - screen variable
v_opl_data	= ramaddr ( $FFFFF770 )	; ObjPosLoad - data buffer ($10 bytes)

v_ssangle	= ramaddr ( $FFFFF780 )	; Special Stage angle (2 bytes)
v_ssrotate	= ramaddr ( $FFFFF782 )	; Special Stage rotation speed (2 bytes)
v_btnpushtime1	= ramaddr ( $FFFFF790 )	; button push duration - in level (2 bytes)
v_btnpushtime2	= ramaddr ( $FFFFF792 )	; button push duration - in demo (2 bytes)
v_palchgspeed	= ramaddr ( $FFFFF794 )	; palette fade/transition speed (0 is fastest) (2 bytes)
v_collindex	= ramaddr ( $FFFFF796 )	; ROM address for collision index of current level (4 bytes)
v_palss_num	= ramaddr ( $FFFFF79A )	; palette cycling in Special Stage - reference number (2 bytes)
v_palss_time	= ramaddr ( $FFFFF79C )	; palette cycling in Special Stage - time until next change (2 bytes)

v_obj31ypos	= ramaddr ( $FFFFF7A4 )	; y-position of object 31 (MZ stomper) (2 bytes)
v_bossstatus	= ramaddr ( $FFFFF7A7 )	; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)
v_trackpos	= ramaddr ( $FFFFF7A8 )	; position tracking reference number (2 bytes)
v_trackbyte	= ramaddr ( $FFFFF7A9 )	; low byte for position tracking
f_lockscreen	= ramaddr ( $FFFFF7AA )	; flag set to lock screen during bosses
v_256loop1	= ramaddr ( $FFFFF7AC )	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2	= ramaddr ( $FFFFF7AD )	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1	= ramaddr ( $FFFFF7AE )	; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2	= ramaddr ( $FFFFF7AF )	; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame	= ramaddr ( $FFFFF7B0 )	; level graphics animation 0 - current frame
v_lani0_time	= ramaddr ( $FFFFF7B1 )	; level graphics animation 0 - time until next frame
v_lani1_frame	= ramaddr ( $FFFFF7B2 )	; level graphics animation 1 - current frame
v_lani1_time	= ramaddr ( $FFFFF7B3 )	; level graphics animation 1 - time until next frame
v_lani2_frame	= ramaddr ( $FFFFF7B4 )	; level graphics animation 2 - current frame
v_lani2_time	= ramaddr ( $FFFFF7B5 )	; level graphics animation 2 - time until next frame
v_lani3_frame	= ramaddr ( $FFFFF7B6 )	; level graphics animation 3 - current frame
v_lani3_time	= ramaddr ( $FFFFF7B7 )	; level graphics animation 3 - time until next frame
v_lani4_frame	= ramaddr ( $FFFFF7B8 )	; level graphics animation 4 - current frame
v_lani4_time	= ramaddr ( $FFFFF7B9 )	; level graphics animation 4 - time until next frame
v_lani5_frame	= ramaddr ( $FFFFF7BA )	; level graphics animation 5 - current frame
v_lani5_time	= ramaddr ( $FFFFF7BB )	; level graphics animation 5 - time until next frame
v_gfxbigring	= ramaddr ( $FFFFF7BE )	; settings for giant ring graphics loading (2 bytes)
f_conveyrev	= ramaddr ( $FFFFF7C0 )	; flag set to reverse conveyor belts in LZ/SBZ
v_obj63	= ramaddr ( $FFFFF7C1 )	; object 63 (LZ/SBZ platforms) variables (6 bytes)
f_wtunnelmode	= ramaddr ( $FFFFF7C7 )	; LZ water tunnel mode
f_lockmulti	= ramaddr ( $FFFFF7C8 )	; flag set to lock controls, lock Sonic's position & animation
f_wtunnelallow	= ramaddr ( $FFFFF7C9 )	; LZ water tunnels (00 = enabled; 01 = disabled)
f_jumponly	= ramaddr ( $FFFFF7CA )	; flag set to lock controls apart from jumping
v_obj6B	= ramaddr ( $FFFFF7CB )	; object 6B (SBZ stomper) variable
f_lockctrl	= ramaddr ( $FFFFF7CC )	; flag set to lock controls during ending sequence
f_bigring	= ramaddr ( $FFFFF7CD )	; flag set when Sonic collects the giant ring
v_itembonus	= ramaddr ( $FFFFF7D0 )	; item bonus from broken enemies, blocks etc. (2 bytes)
v_timebonus	= ramaddr ( $FFFFF7D2 )	; time bonus at the end of an act (2 bytes)
v_ringbonus	= ramaddr ( $FFFFF7D4 )	; ring bonus at the end of an act (2 bytes)
f_endactbonus	= ramaddr ( $FFFFF7D6 )	; time/ring bonus update flag at the end of an act
v_sonicend	= ramaddr ( $FFFFF7D7 )	; routine counter for Sonic in the ending sequence
v_lz_deform	= ramaddr ( $FFFFF7D8 )	; LZ deformtaion offset, in units of $80 (2 bytes)
f_switch	= ramaddr ( $FFFFF7E0 )	; flags set when Sonic stands on a switch ($10 bytes)
v_scroll_block_1_size	= ramaddr ( $FFFFF7F0 )	; (2 bytes)
v_scroll_block_2_size	= ramaddr ( $FFFFF7F2 )	; unused (2 bytes)
v_scroll_block_3_size	= ramaddr ( $FFFFF7F4 )	; unused (2 bytes)
v_scroll_block_4_size	= ramaddr ( $FFFFF7F6 )	; unused (2 bytes)

v_spritetablebuffer	= ramaddr ( $FFFFF800 ) ; sprite table ($280 bytes, last $80 bytes are overwritten by v_pal_water_dup)
v_pal_water_dup	= ramaddr ( $FFFFFA00 ) ; duplicate underwater palette, used for transitions ($80 bytes)
v_pal_water	= ramaddr ( $FFFFFA80 )	; main underwater palette ($80 bytes)
v_pal_dry	= ramaddr ( $FFFFFB00 )	; main palette ($80 bytes)
v_pal_dry_dup	= ramaddr ( $FFFFFB80 )	; duplicate palette, used for transitions ($80 bytes)
v_objstate	= ramaddr ( $FFFFFC00 )	; object state list ($200 bytes)

v_systemstack	= ramaddr ( $FFFFFE00 )
f_restart	= ramaddr ( $FFFFFE02 )	; restart level flag (2 bytes)
v_framecount	= ramaddr ( $FFFFFE04 )	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte	= v_framecount+1; low byte for frame counter
v_debugitem	= ramaddr ( $FFFFFE06 )	; debug item currently selected (NOT the object number of the item)
v_debuguse	= ramaddr ( $FFFFFE08 )	; debug mode use & routine counter (when Sonic is a ring/item) (2 bytes)
v_debugxspeed	= ramaddr ( $FFFFFE0A )	; debug mode - horizontal speed
v_debugyspeed	= ramaddr ( $FFFFFE0B )	; debug mode - vertical speed
v_vbla_count	= ramaddr ( $FFFFFE0C )	; vertical interrupt counter (adds 1 every VBlank) (4 bytes)
v_vbla_word	= v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte	= v_vbla_word+1	; low byte for vertical interrupt counter
v_zone		= ramaddr ( $FFFFFE10 )	; current zone number
v_act		= ramaddr ( $FFFFFE11 )	; current act number
v_lives	= ramaddr ( $FFFFFE12 )	; number of lives
v_air		= ramaddr ( $FFFFFE14 )	; air remaining while underwater (2 bytes)
v_airbyte	= v_air+1	; low byte for air
v_lastspecial	= ramaddr ( $FFFFFE16 )	; last special stage number
v_continues	= ramaddr ( $FFFFFE18 )	; number of continues
f_timeover	= ramaddr ( $FFFFFE1A )	; time over flag
v_lifecount	= ramaddr ( $FFFFFE1B )	; lives counter value (for actual number, see "v_lives")
f_lifecount	= ramaddr ( $FFFFFE1C )	; lives counter update flag
f_ringcount	= ramaddr ( $FFFFFE1D )	; ring counter update flag
f_timecount	= ramaddr ( $FFFFFE1E )	; time counter update flag
f_scorecount	= ramaddr ( $FFFFFE1F )	; score counter update flag
v_rings	= ramaddr ( $FFFFFE20 )	; rings (2 bytes)
v_ringbyte	= v_rings+1	; low byte for rings
v_time		= ramaddr ( $FFFFFE22 )	; time (4 bytes)
v_timemin	= ramaddr ( $FFFFFE23 )	; time - minutes
v_timesec	= ramaddr ( $FFFFFE24 )	; time - seconds
v_timecent	= ramaddr ( $FFFFFE25 )	; time - centiseconds
v_score	= ramaddr ( $FFFFFE26 )	; score (4 bytes)
v_shield	= ramaddr ( $FFFFFE2C )	; shield status (00 = no; 01 = yes)
v_invinc	= ramaddr ( $FFFFFE2D )	; invinciblity status (00 = no; 01 = yes)
v_shoes	= ramaddr ( $FFFFFE2E )	; speed shoes status (00 = no; 01 = yes)
v_lastlamp	= ramaddr ( $FFFFFE30 )	; number of the last lamppost you hit
v_lamp_xpos	= v_lastlamp+2	; x-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_ypos	= v_lastlamp+4	; y-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_rings	= v_lastlamp+6	; rings stored at lamppost (2 bytes)
v_lamp_time	= v_lastlamp+8	; time stored at lamppost (2 bytes)
v_lamp_dle	= v_lastlamp+$C	; dynamic level event routine counter at lamppost
v_lamp_limitbtm	= v_lastlamp+$E	; level bottom boundary at lamppost (2 bytes)
v_lamp_scrx	= v_lastlamp+$10 ; x-axis screen at lamppost (2 bytes)
v_lamp_scry	= v_lastlamp+$12 ; y-axis screen at lamppost (2 bytes)

v_lamp_wtrpos	= v_lastlamp+$20 ; water position at lamppost (2 bytes)
v_lamp_wtrrout	= v_lastlamp+$22 ; water routine at lamppost
v_lamp_wtrstat	= v_lastlamp+$23 ; water state at lamppost
v_lamp_lives	= v_lastlamp+$24 ; lives counter at lamppost
v_emeralds	= ramaddr ( $FFFFFE57 )	; number of chaos emeralds
v_emldlist	= ramaddr ( $FFFFFE58 )	; which individual emeralds you have (00 = no; 01 = yes) (6 bytes)
v_oscillate	= ramaddr ( $FFFFFE5E )	; values which oscillate - for swinging platforms, et al ($42 bytes)
v_ani0_time	= ramaddr ( $FFFFFEC0 )	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame	= ramaddr ( $FFFFFEC1 )	; synchronised sprite animation 0 - current frame
v_ani1_time	= ramaddr ( $FFFFFEC2 )	; synchronised sprite animation 1 - time until next frame
v_ani1_frame	= ramaddr ( $FFFFFEC3 )	; synchronised sprite animation 1 - current frame
v_ani2_time	= ramaddr ( $FFFFFEC4 )	; synchronised sprite animation 2 - time until next frame
v_ani2_frame	= ramaddr ( $FFFFFEC5 )	; synchronised sprite animation 2 - current frame
v_ani3_time	= ramaddr ( $FFFFFEC6 )	; synchronised sprite animation 3 - time until next frame
v_ani3_frame	= ramaddr ( $FFFFFEC7 )	; synchronised sprite animation 3 - current frame
v_ani3_buf	= ramaddr ( $FFFFFEC8 )	; synchronised sprite animation 3 - info buffer (2 bytes)
v_limittopdb	= ramaddr ( $FFFFFEF0 )	; level upper boundary, buffered for debug mode (2 bytes)
v_limitbtmdb	= ramaddr ( $FFFFFEF2 )	; level bottom boundary, buffered for debug mode (2 bytes)

v_screenposx_dup	= ramaddr ( $FFFFFF10 )	; screen position x (duplicate) (2 bytes)
v_screenposy_dup	= ramaddr ( $FFFFFF14 )	; screen position y (duplicate) (2 bytes)
v_bgscreenposx_dup	= ramaddr ( $FFFFFF18 )	; background screen position x (duplicate) (2 bytes)
v_bgscreenposy_dup	= ramaddr ( $FFFFFF1C )	; background screen position y (duplicate) (2 bytes)
v_bg2screenposx_dup	= ramaddr ( $FFFFFF20 )	; 2 bytes
v_bg2screenposy_dup	= ramaddr ( $FFFFFF24 )	; 2 bytes
v_bg3screenposx_dup	= ramaddr ( $FFFFFF28 )	; 2 bytes
v_bg3screenposy_dup	= ramaddr ( $FFFFFF2C )	; 2 bytes
v_fg_scroll_flags_dup	= ramaddr ( $FFFFFF30 )
v_bg1_scroll_flags_dup	= ramaddr ( $FFFFFF32 )
v_bg2_scroll_flags_dup	= ramaddr ( $FFFFFF34 )
v_bg3_scroll_flags_dup	= ramaddr ( $FFFFFF36 )

v_levseldelay	= ramaddr ( $FFFFFF80 )	; level select - time until change when up/down is held (2 bytes)
v_levselitem	= ramaddr ( $FFFFFF82 )	; level select - item selected (2 bytes)
v_levselsound	= ramaddr ( $FFFFFF84 )	; level select - sound selected (2 bytes)
v_scorecopy	= ramaddr ( $FFFFFFC0 )	; score, duplicate (4 bytes)
v_scorelife	= ramaddr ( $FFFFFFC0 )	; points required for an extra life (4 bytes) (JP1 only)
f_levselcheat	= ramaddr ( $FFFFFFE0 )	; level select cheat flag
f_slomocheat	= ramaddr ( $FFFFFFE1 )	; slow motion & frame advance cheat flag
f_debugcheat	= ramaddr ( $FFFFFFE2 )	; debug mode cheat flag
f_creditscheat	= ramaddr ( $FFFFFFE3 )	; hidden credits & press start cheat flag
v_title_dcount	= ramaddr ( $FFFFFFE4 )	; number of times the d-pad is pressed on title screen (2 bytes)
v_title_ccount	= ramaddr ( $FFFFFFE6 )	; number of times C is pressed on title screen (2 bytes)

f_demo		= ramaddr ( $FFFFFFF0 )	; demo mode flag (0 = no; 1 = yes; $8001 = ending) (2 bytes)
v_demonum	= ramaddr ( $FFFFFFF2 )	; demo level number (not the same as the level number) (2 bytes)
v_creditsnum	= ramaddr ( $FFFFFFF4 )	; credits index number (2 bytes)
v_megadrive	= ramaddr ( $FFFFFFF8 )	; Megadrive machine type
f_debugmode	= ramaddr ( $FFFFFFFA )	; debug mode flag (sometimes 2 bytes)
v_init		= ramaddr ( $FFFFFFFC )	; 'init' text string (4 bytes)
