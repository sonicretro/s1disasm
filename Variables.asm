; Variables (v) and Flags (f)

v_regbuffer:	equ $FFFFFC00	; stores registers d0-a7 during an error event ($40 bytes)
v_spbuffer:	equ $FFFFFC40	; stores most recent sp address (4 bytes)
v_errortype:	equ $FFFFFC44	; error type

v_256x256:	equ   $FF0000	; 256x256 tile mappings ($A400 bytes)
v_lvllayout:	equ $FFFFA400	; level and background layouts ($400 bytes)
v_bgscroll_buffer:	equ	$FFFFA800	; background scroll buffer ($200 bytes)
v_ngfx_buffer:	equ $FFFFAA00	; Nemesis graphics decompression buffer ($200 bytes)
v_spritequeue:	equ $FFFFAC00	; sprite display queue, in order of priority ($400 bytes)
v_16x16:		equ $FFFFB000	; 16x16 tile mappings

v_sgfx_buffer:	equ $FFFFC800	; buffered Sonic graphics ($17 cells) ($2E0 bytes)
v_tracksonic:	equ $FFFFCB00	; position tracking data for Sonic ($100 bytes)
v_hscrolltablebuffer:	equ $FFFFCC00 ; scrolling table data (actually $380 bytes, but $400 is reserved for it)
v_objspace:	equ $FFFFD000	; object variable space ($40 bytes per object) ($2000 bytes)
v_player:	equ v_objspace	; object variable space for Sonic ($40 bytes)
v_lvlobjspace:	equ $FFFFD800	; level object variable space ($1800 bytes)

v_snddriver_ram:	equ $FFFFF000 ; start of RAM for the sound driver data ($5C0 bytes)

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================
v_startofvariables:	equ $000
v_sndprio:		equ $000	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	equ $001	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		equ $002	; Used for music only
f_pausemusic:		equ $003	; flag set to stop music when paused
v_fadeout_counter:	equ $004

v_fadeout_delay:	equ $006
v_communication_byte:	equ $007	; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		equ $008	; $80 if updating DAC, $00 otherwise
v_sound_id:		equ $009	; sound or music copied from below
v_soundqueue0:		equ $00A	; sound or music to play
v_soundqueue1:		equ $00B	; special sound to play
v_soundqueue2:		equ $00C	; unused sound to play

f_voice_selector:	equ $00E	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		equ $018	; voice data pointer (4 bytes)

v_special_voice_ptr:	equ $020	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		equ $024	; Flag for fade in
v_fadein_delay:		equ $025
v_fadein_counter:	equ $026	; Timer for fade in/out
f_1up_playing:		equ $027	; flag indicating 1-up song is playing
v_tempo_mod:		equ $028	; music - tempo modifier
v_speeduptempo:		equ $029	; music - tempo modifier with speed shoes
f_speedup:		equ $02A	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		equ $02B	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		equ $02C	; if set, prevents further push sounds from playing

v_music_track_ram:	equ $040	; Start of music RAM

v_music_fmdac_tracks:	equ v_music_track_ram+TrackSz*0
v_music_dac_track:	equ v_music_fmdac_tracks+TrackSz*0
v_music_fm_tracks:	equ v_music_fmdac_tracks+TrackSz*1
v_music_fm1_track:	equ v_music_fm_tracks+TrackSz*0
v_music_fm2_track:	equ v_music_fm_tracks+TrackSz*1
v_music_fm3_track:	equ v_music_fm_tracks+TrackSz*2
v_music_fm4_track:	equ v_music_fm_tracks+TrackSz*3
v_music_fm5_track:	equ v_music_fm_tracks+TrackSz*4
v_music_fm6_track:	equ v_music_fm_tracks+TrackSz*5
v_music_fm_tracks_end:	equ v_music_fm_tracks+TrackSz*6
v_music_fmdac_tracks_end:	equ v_music_fm_tracks_end
v_music_psg_tracks:	equ v_music_fmdac_tracks_end
v_music_psg1_track:	equ v_music_psg_tracks+TrackSz*0
v_music_psg2_track:	equ v_music_psg_tracks+TrackSz*1
v_music_psg3_track:	equ v_music_psg_tracks+TrackSz*2
v_music_psg_tracks_end:	equ v_music_psg_tracks+TrackSz*3
v_music_track_ram_end:	equ v_music_psg_tracks_end

v_sfx_track_ram:	equ v_music_track_ram_end	; Start of SFX RAM, straight after the end of music RAM

v_sfx_fm_tracks:	equ v_sfx_track_ram+TrackSz*0
v_sfx_fm3_track:	equ v_sfx_fm_tracks+TrackSz*0
v_sfx_fm4_track:	equ v_sfx_fm_tracks+TrackSz*1
v_sfx_fm5_track:	equ v_sfx_fm_tracks+TrackSz*2
v_sfx_fm_tracks_end:	equ v_sfx_fm_tracks+TrackSz*3
v_sfx_psg_tracks:	equ v_sfx_fm_tracks_end
v_sfx_psg1_track:	equ v_sfx_psg_tracks+TrackSz*0
v_sfx_psg2_track:	equ v_sfx_psg_tracks+TrackSz*1
v_sfx_psg3_track:	equ v_sfx_psg_tracks+TrackSz*2
v_sfx_psg_tracks_end:	equ v_sfx_psg_tracks+TrackSz*3
v_sfx_track_ram_end:	equ v_sfx_psg_tracks_end

v_spcsfx_track_ram:	equ v_sfx_track_ram_end	; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	equ v_spcsfx_track_ram+TrackSz*0
v_spcsfx_psg3_track:	equ v_spcsfx_track_ram+TrackSz*1
v_spcsfx_track_ram_end:	equ v_spcsfx_track_ram+TrackSz*2

v_1up_ram_copy:		equ v_spcsfx_track_ram_end

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode:	equ $FFFFF600	; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
v_jpadhold2:	equ $FFFFF602	; joypad input - held, duplicate
v_jpadpress2:	equ $FFFFF603	; joypad input - pressed, duplicate
v_jpadhold1:	equ $FFFFF604	; joypad input - held
v_jpadpress1:	equ $FFFFF605	; joypad input - pressed

v_vdp_buffer1:	equ $FFFFF60C	; VDP instruction buffer (2 bytes)

v_demolength:	equ $FFFFF614	; the length of a demo in frames (2 bytes)
v_scrposy_dup:	equ $FFFFF616	; screen position y (duplicate) (2 bytes)
v_bgscrposy_dup:	equ $FFFFF618	; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:	equ $FFFFF61A	; screen position x (duplicate) (2 bytes)
v_bgscreenposx_dup_unused:	equ $FFFFF61C	; background screen position x (duplicate) (2 bytes)
v_bg3screenposy_dup_unused:	equ $FFFFF61E	; (2 bytes)
v_bg3screenposx_dup_unused:	equ $FFFFF620	; (2 bytes)

v_hbla_hreg:	equ $FFFFF624	; VDP H.interrupt register buffer (8Axx) (2 bytes)
v_hbla_line:	equ $FFFFF625	; screen line where water starts and palette is changed by HBlank
v_pfade_start:	equ $FFFFF626	; palette fading - start position in bytes
v_pfade_size:	equ $FFFFF627	; palette fading - number of colours
v_vbla_routine:	equ $FFFFF62A	; VBlank - routine counter
v_spritecount:	equ $FFFFF62C	; number of sprites on-screen
v_pcyc_num:	equ $FFFFF632	; palette cycling - current reference number (2 bytes)
v_pcyc_time:	equ $FFFFF634	; palette cycling - time until the next change (2 bytes)
v_random:	equ $FFFFF636	; pseudo random number buffer (4 bytes)
f_pause:		equ $FFFFF63A	; flag set to pause the game (2 bytes)
v_vdp_buffer2:	equ $FFFFF640	; VDP instruction buffer (2 bytes)
f_hbla_pal:	equ $FFFFF644	; flag set to change palette during HBlank (0000 = no; 0001 = change) (2 bytes)
v_waterpos1:	equ $FFFFF646	; water height, actual (2 bytes)
v_waterpos2:	equ $FFFFF648	; water height, ignoring sway (2 bytes)
v_waterpos3:	equ $FFFFF64A	; water height, next target (2 bytes)
f_water:		equ $FFFFF64C	; flag set for water
v_wtr_routine:	equ $FFFFF64D	; water event - routine counter
f_wtr_state:	equ $FFFFF64E	; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)

v_pal_buffer:	equ $FFFFF650	; palette data buffer (used for palette cycling) ($30 bytes)
v_plc_buffer:	equ $FFFFF680	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode:	equ $FFFFF6E0	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)

f_plc_execute:	equ $FFFFF6F8	; flag set for pattern load cue execution (2 bytes)

v_screenposx:	equ $FFFFF700	; screen position x (2 bytes)
v_screenposy:	equ $FFFFF704	; screen position y (2 bytes)
v_bgscreenposx:	equ $FFFFF708	; background screen position x (2 bytes)
v_bgscreenposy:	equ $FFFFF70C	; background screen position y (2 bytes)
v_bg2screenposx:	equ $FFFFF710	; 2 bytes
v_bg2screenposy:	equ $FFFFF714	; 2 bytes
v_bg3screenposx:	equ $FFFFF718	; 2 bytes
v_bg3screenposy:	equ $FFFFF71C	; 2 bytes

v_limitleft1:	equ $FFFFF720	; left level boundary (2 bytes)
v_limitright1:	equ $FFFFF722	; right level boundary (2 bytes)
v_limittop1:	equ $FFFFF724	; top level boundary (2 bytes)
v_limitbtm1:	equ $FFFFF726	; bottom level boundary (2 bytes)
v_limitleft2:	equ $FFFFF728	; left level boundary (2 bytes)
v_limitright2:	equ $FFFFF72A	; right level boundary (2 bytes)
v_limittop2:	equ $FFFFF72C	; top level boundary (2 bytes)
v_limitbtm2:	equ $FFFFF72E	; bottom level boundary (2 bytes)

v_limitleft3:	equ $FFFFF732	; left level boundary, at the end of an act (2 bytes)

v_scrshiftx:	equ $FFFFF73A	; x-screen shift (new - last) * $100
v_scrshifty:	equ $FFFFF73C	; y-screen shift (new - last) * $100

v_lookshift:	equ $FFFFF73E	; screen shift when Sonic looks up/down (2 bytes)
v_dle_routine:	equ $FFFFF742	; dynamic level event - routine counter
f_nobgscroll:	equ $FFFFF744	; flag set to cancel background scrolling

v_fg_xblock:	equ	$FFFFF74A	; foreground x-block parity (for redraw)
v_fg_yblock:	equ	$FFFFF74B	; foreground y-block parity (for redraw)
v_bg1_xblock:	equ	$FFFFF74C	; background x-block parity (for redraw)
v_bg1_yblock:	equ	$FFFFF74D	; background y-block parity (for redraw)
v_bg2_xblock:	equ	$FFFFF74E	; secondary background x-block parity (for redraw)
v_bg2_yblock:	equ	$FFFFF74F	; secondary background y-block parity (unused)
v_bg3_xblock:	equ	$FFFFF750	; teritary background x-block parity (for redraw)
v_bg3_yblock:	equ	$FFFFF751	; teritary background y-block parity (unused)

v_fg_scroll_flags:	equ $FFFFF754	; screen redraw flags for foreground
v_bg1_scroll_flags:	equ $FFFFF756	; screen redraw flags for background 1
v_bg2_scroll_flags:	equ $FFFFF758	; screen redraw flags for background 2
v_bg3_scroll_flags:	equ $FFFFF75A	; screen redraw flags for background 3
f_bgscrollvert:	equ $FFFFF75C	; flag for vertical background scrolling
v_sonspeedmax:	equ $FFFFF760	; Sonic's maximum speed (2 bytes)
v_sonspeedacc:	equ $FFFFF762	; Sonic's acceleration (2 bytes)
v_sonspeeddec:	equ $FFFFF764	; Sonic's deceleration (2 bytes)
v_sonframenum:	equ $FFFFF766	; frame to display for Sonic
f_sonframechg:	equ $FFFFF767	; flag set to update Sonic's sprite frame
v_anglebuffer:	equ $FFFFF768	; angle of collision block that Sonic or object is standing on

v_opl_routine:	equ $FFFFF76C	; ObjPosLoad - routine counter
v_opl_screen:	equ $FFFFF76E	; ObjPosLoad - screen variable
v_opl_data:	equ $FFFFF770	; ObjPosLoad - data buffer ($10 bytes)

v_ssangle:	equ $FFFFF780	; Special Stage angle (2 bytes)
v_ssrotate:	equ $FFFFF782	; Special Stage rotation speed (2 bytes)
v_btnpushtime1:	equ $FFFFF790	; button push duration - in level (2 bytes)
v_btnpushtime2:	equ $FFFFF792	; button push duration - in demo (2 bytes)
v_palchgspeed:	equ $FFFFF794	; palette fade/transition speed (0 is fastest) (2 bytes)
v_collindex:	equ $FFFFF796	; ROM address for collision index of current level (4 bytes)
v_palss_num:	equ $FFFFF79A	; palette cycling in Special Stage - reference number (2 bytes)
v_palss_time:	equ $FFFFF79C	; palette cycling in Special Stage - time until next change (2 bytes)

v_obj31ypos:	equ $FFFFF7A4	; y-position of object 31 (MZ stomper) (2 bytes)
v_bossstatus:	equ $FFFFF7A7	; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)
v_trackpos:	equ $FFFFF7A8	; position tracking reference number (2 bytes)
v_trackbyte:	equ $FFFFF7A9	; low byte for position tracking
f_lockscreen:	equ $FFFFF7AA	; flag set to lock screen during bosses
v_256loop1:	equ $FFFFF7AC	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:	equ $FFFFF7AD	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:	equ $FFFFF7AE	; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:	equ $FFFFF7AF	; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame:	equ $FFFFF7B0	; level graphics animation 0 - current frame
v_lani0_time:	equ $FFFFF7B1	; level graphics animation 0 - time until next frame
v_lani1_frame:	equ $FFFFF7B2	; level graphics animation 1 - current frame
v_lani1_time:	equ $FFFFF7B3	; level graphics animation 1 - time until next frame
v_lani2_frame:	equ $FFFFF7B4	; level graphics animation 2 - current frame
v_lani2_time:	equ $FFFFF7B5	; level graphics animation 2 - time until next frame
v_lani3_frame:	equ $FFFFF7B6	; level graphics animation 3 - current frame
v_lani3_time:	equ $FFFFF7B7	; level graphics animation 3 - time until next frame
v_lani4_frame:	equ $FFFFF7B8	; level graphics animation 4 - current frame
v_lani4_time:	equ $FFFFF7B9	; level graphics animation 4 - time until next frame
v_lani5_frame:	equ $FFFFF7BA	; level graphics animation 5 - current frame
v_lani5_time:	equ $FFFFF7BB	; level graphics animation 5 - time until next frame
v_gfxbigring:	equ $FFFFF7BE	; settings for giant ring graphics loading (2 bytes)
f_conveyrev:	equ $FFFFF7C0	; flag set to reverse conveyor belts in LZ/SBZ
v_obj63:		equ $FFFFF7C1	; object 63 (LZ/SBZ platforms) variables (6 bytes)
f_wtunnelmode:	equ $FFFFF7C7	; LZ water tunnel mode
f_lockmulti:	equ $FFFFF7C8	; flag set to lock controls, lock Sonic's position & animation
f_wtunnelallow:	equ $FFFFF7C9	; LZ water tunnels (00 = enabled; 01 = disabled)
f_jumponly:	equ $FFFFF7CA	; flag set to lock controls apart from jumping
v_obj6B:		equ $FFFFF7CB	; object 6B (SBZ stomper) variable
f_lockctrl:	equ $FFFFF7CC	; flag set to lock controls during ending sequence
f_bigring:	equ $FFFFF7CD	; flag set when Sonic collects the giant ring
v_itembonus:	equ $FFFFF7D0	; item bonus from broken enemies, blocks etc. (2 bytes)
v_timebonus:	equ $FFFFF7D2	; time bonus at the end of an act (2 bytes)
v_ringbonus:	equ $FFFFF7D4	; ring bonus at the end of an act (2 bytes)
f_endactbonus:	equ $FFFFF7D6	; time/ring bonus update flag at the end of an act
v_sonicend:	equ $FFFFF7D7	; routine counter for Sonic in the ending sequence
v_lz_deform:	equ	$FFFFF7D8	; LZ deformtaion offset, in units of $80 (2 bytes)
f_switch:	equ $FFFFF7E0	; flags set when Sonic stands on a switch ($10 bytes)
v_scroll_block_1_size:	equ $FFFFF7F0	; (2 bytes)
v_scroll_block_2_size:	equ $FFFFF7F2	; unused (2 bytes)
v_scroll_block_3_size:	equ $FFFFF7F4	; unused (2 bytes)
v_scroll_block_4_size:	equ $FFFFF7F6	; unused (2 bytes)

v_spritetablebuffer:	equ $FFFFF800 ; sprite table ($280 bytes, last $80 bytes are overwritten by v_pal_water_dup)
v_pal_water_dup:	equ $FFFFFA00 ; duplicate underwater palette, used for transitions ($80 bytes)
v_pal_water:	equ $FFFFFA80	; main underwater palette ($80 bytes)
v_pal_dry:	equ $FFFFFB00	; main palette ($80 bytes)
v_pal_dry_dup:	equ $FFFFFB80	; duplicate palette, used for transitions ($80 bytes)
v_objstate:	equ $FFFFFC00	; object state list ($200 bytes)


v_systemstack:	equ $FFFFFE00
f_restart:	equ $FFFFFE02	; restart level flag (2 bytes)
v_framecount:	equ $FFFFFE04	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:	equ v_framecount+1; low byte for frame counter
v_debugitem:	equ $FFFFFE06	; debug item currently selected (NOT the object number of the item)
v_debuguse:	equ $FFFFFE08	; debug mode use & routine counter (when Sonic is a ring/item) (2 bytes)
v_debugxspeed:	equ $FFFFFE0A	; debug mode - horizontal speed
v_debugyspeed:	equ $FFFFFE0B	; debug mode - vertical speed
v_vbla_count:	equ $FFFFFE0C	; vertical interrupt counter (adds 1 every VBlank) (4 bytes)
v_vbla_word:	equ v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:	equ v_vbla_word+1	; low byte for vertical interrupt counter
v_zone:		equ $FFFFFE10	; current zone number
v_act:		equ $FFFFFE11	; current act number
v_lives:		equ $FFFFFE12	; number of lives
v_air:		equ $FFFFFE14	; air remaining while underwater (2 bytes)
v_airbyte:	equ v_air+1	; low byte for air
v_lastspecial:	equ $FFFFFE16	; last special stage number
v_continues:	equ $FFFFFE18	; number of continues
f_timeover:	equ $FFFFFE1A	; time over flag
v_lifecount:	equ $FFFFFE1B	; lives counter value (for actual number, see "v_lives")
f_lifecount:	equ $FFFFFE1C	; lives counter update flag
f_ringcount:	equ $FFFFFE1D	; ring counter update flag
f_timecount:	equ $FFFFFE1E	; time counter update flag
f_scorecount:	equ $FFFFFE1F	; score counter update flag
v_rings:		equ $FFFFFE20	; rings (2 bytes)
v_ringbyte:	equ v_rings+1	; low byte for rings
v_time:		equ $FFFFFE22	; time (4 bytes)
v_timemin:	equ $FFFFFE23	; time - minutes
v_timesec:	equ $FFFFFE24	; time - seconds
v_timecent:	equ $FFFFFE25	; time - centiseconds
v_score:		equ $FFFFFE26	; score (4 bytes)
v_shield:	equ $FFFFFE2C	; shield status (00 = no; 01 = yes)
v_invinc:	equ $FFFFFE2D	; invinciblity status (00 = no; 01 = yes)
v_shoes:		equ $FFFFFE2E	; speed shoes status (00 = no; 01 = yes)
v_lastlamp:	equ $FFFFFE30	; number of the last lamppost you hit
v_lamp_xpos:	equ v_lastlamp+2	; x-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_ypos:	equ v_lastlamp+4	; y-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_rings:	equ v_lastlamp+6	; rings stored at lamppost (2 bytes)
v_lamp_time:	equ v_lastlamp+8	; time stored at lamppost (2 bytes)
v_lamp_dle:	equ v_lastlamp+$C	; dynamic level event routine counter at lamppost
v_lamp_limitbtm:	equ v_lastlamp+$E	; level bottom boundary at lamppost (2 bytes)
v_lamp_scrx:	equ v_lastlamp+$10 ; x-axis screen at lamppost (2 bytes)
v_lamp_scry:	equ v_lastlamp+$12 ; y-axis screen at lamppost (2 bytes)

v_lamp_wtrpos:	equ v_lastlamp+$20 ; water position at lamppost (2 bytes)
v_lamp_wtrrout:	equ v_lastlamp+$22 ; water routine at lamppost
v_lamp_wtrstat:	equ v_lastlamp+$23 ; water state at lamppost
v_lamp_lives:	equ v_lastlamp+$24 ; lives counter at lamppost
v_emeralds:	equ $FFFFFE57	; number of chaos emeralds
v_emldlist:	equ $FFFFFE58	; which individual emeralds you have (00 = no; 01 = yes) (6 bytes)
v_oscillate:	equ $FFFFFE5E	; values which oscillate - for swinging platforms, et al ($42 bytes)
v_ani0_time:	equ $FFFFFEC0	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:	equ $FFFFFEC1	; synchronised sprite animation 0 - current frame
v_ani1_time:	equ $FFFFFEC2	; synchronised sprite animation 1 - time until next frame
v_ani1_frame:	equ $FFFFFEC3	; synchronised sprite animation 1 - current frame
v_ani2_time:	equ $FFFFFEC4	; synchronised sprite animation 2 - time until next frame
v_ani2_frame:	equ $FFFFFEC5	; synchronised sprite animation 2 - current frame
v_ani3_time:	equ $FFFFFEC6	; synchronised sprite animation 3 - time until next frame
v_ani3_frame:	equ $FFFFFEC7	; synchronised sprite animation 3 - current frame
v_ani3_buf:	equ $FFFFFEC8	; synchronised sprite animation 3 - info buffer (2 bytes)
v_limittopdb:	equ $FFFFFEF0	; level upper boundary, buffered for debug mode (2 bytes)
v_limitbtmdb:	equ $FFFFFEF2	; level bottom boundary, buffered for debug mode (2 bytes)

v_screenposx_dup:	equ $FFFFFF10	; screen position x (duplicate) (2 bytes)
v_screenposy_dup:	equ $FFFFFF14	; screen position y (duplicate) (2 bytes)
v_bgscreenposx_dup:	equ $FFFFFF18	; background screen position x (duplicate) (2 bytes)
v_bgscreenposy_dup:	equ $FFFFFF1C	; background screen position y (duplicate) (2 bytes)
v_bg2screenposx_dup:	equ $FFFFFF20	; 2 bytes
v_bg2screenposy_dup:	equ $FFFFFF24	; 2 bytes
v_bg3screenposx_dup:	equ $FFFFFF28	; 2 bytes
v_bg3screenposy_dup:	equ $FFFFFF2C	; 2 bytes
v_fg_scroll_flags_dup:	equ $FFFFFF30
v_bg1_scroll_flags_dup:	equ $FFFFFF32
v_bg2_scroll_flags_dup:	equ $FFFFFF34
v_bg3_scroll_flags_dup:	equ $FFFFFF36

v_levseldelay:	equ $FFFFFF80	; level select - time until change when up/down is held (2 bytes)
v_levselitem:	equ $FFFFFF82	; level select - item selected (2 bytes)
v_levselsound:	equ $FFFFFF84	; level select - sound selected (2 bytes)
v_scorecopy:	equ $FFFFFFC0	; score, duplicate (4 bytes)
v_scorelife:	equ $FFFFFFC0	; points required for an extra life (4 bytes) (JP1 only)
f_levselcheat:	equ $FFFFFFE0	; level select cheat flag
f_slomocheat:	equ $FFFFFFE1	; slow motion & frame advance cheat flag
f_debugcheat:	equ $FFFFFFE2	; debug mode cheat flag
f_creditscheat:	equ $FFFFFFE3	; hidden credits & press start cheat flag
v_title_dcount:	equ $FFFFFFE4	; number of times the d-pad is pressed on title screen (2 bytes)
v_title_ccount:	equ $FFFFFFE6	; number of times C is pressed on title screen (2 bytes)

f_demo:		equ $FFFFFFF0	; demo mode flag (0 = no; 1 = yes; $8001 = ending) (2 bytes)
v_demonum:	equ $FFFFFFF2	; demo level number (not the same as the level number) (2 bytes)
v_creditsnum:	equ $FFFFFFF4	; credits index number (2 bytes)
v_megadrive:	equ $FFFFFFF8	; Megadrive machine type
f_debugmode:	equ $FFFFFFFA	; debug mode flag (sometimes 2 bytes)
v_init:		equ $FFFFFFFC	; 'init' text string (4 bytes)
