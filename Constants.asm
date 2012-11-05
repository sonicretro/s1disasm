; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_SegaPCM:		equ $6978

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_dac3_pitch:		equ $A000EA
z80_dac_status:		equ $A01FFD
z80_dac_sample:		equ $A01FFF
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_data:	equ $A10002
z80_port_1_control:	equ $A10008
z80_port_2_control:	equ $A1000A
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200
ym2612_a0: 		equ $A04000
ym2612_d0: 		equ $A04001
ym2612_a1: 		equ $A04002
ym2612_d1: 		equ $A04003

security_addr:		equ $A14000

; Sound driver constants
zTrackSz:	equ $30

; VRAM data
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sonic:	equ $F000	; Sonic graphics
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

; Game modes
id_Sega:	equ ptr_GM_Sega-GameModeArray	; $00
id_Title:	equ ptr_GM_Title-GameModeArray	; $04
id_Demo:	equ ptr_GM_Demo-GameModeArray	; $08
id_Level:	equ ptr_GM_Level-GameModeArray	; $0C
id_Special:	equ ptr_GM_Special-GameModeArray; $10
id_Continue:	equ ptr_GM_Cont-GameModeArray	; $14
id_Ending:	equ ptr_GM_Ending-GameModeArray	; $18
id_Credits:	equ ptr_GM_Credits-GameModeArray; $1C

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ ZoneCount	; 7 by default

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obInertia:	equ $14	; potential speed (2 bytes)
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obActWid:	equ $19	; action width
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obNextAni:	equ $1D	; next animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag

; Object variables (Sonic 2 disassembly nomenclature)
render_flags:	equ 1	; bitfield for x/y flip, display mode
art_tile:	equ 2	; palette line & VRAM setting (2 bytes)
mappings:	equ 4	; mappings address (4 bytes)
x_pos:		equ 8	; x-axis position (2-4 bytes)
y_pos:		equ $C	; y-axis position (2-4 bytes)
x_vel:		equ $10	; x-axis velocity (2 bytes)
y_vel:		equ $12	; y-axis velocity (2 bytes)
y_radius:	equ $16	; height/2
x_radius:	equ $17	; width/2
priority:	equ $18	; sprite stack priority -- 0 is front
width_pixels:	equ $19	; action width
mapping_frame:	equ $1A	; current frame displayed
anim_frame:	equ $1B	; current frame in animation script
anim:		equ $1C	; current animation
next_anim:	equ $1D	; next animation
anim_frame_duration: equ $1E ; time to next frame
collision_flags: equ $20 ; collision response type
collision_property: equ $21 ; collision extra property
status:		equ $22	; orientation or mode
respawn_index:	equ $23	; respawn list index number
routine:	equ $24	; routine number
routine_secondary: equ $25 ; secondary routine number
angle:		equ $26	; angle
subtype:	equ $28	; object subtype

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter

; Background music
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+$81
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+$81
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+$81
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+$81
bgm_SYZ:	equ ((ptr_mus85-MusicIndex)/4)+$81
bgm_SBZ:	equ ((ptr_mus86-MusicIndex)/4)+$81
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+$81
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+$81
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+$81
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+$81
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+$81
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+$81
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+$81
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+$81
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+$81
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+$81
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+$81
bgm_Drowning:	equ ((ptr_mus92-MusicIndex)/4)+$81
bgm_Emerald:	equ ((ptr_mus93-MusicIndex)/4)+$81
bgm_Fade:	equ $E0
bgm_Stop:	equ $E4

; Sound effects
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+$A0
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+$A0
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+$A0
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+$A0
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+$A0
sfx_A5:		equ ((ptr_sndA5-SoundIndex)/4)+$A0
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+$A0
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+$A0
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+$A0
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+$A0
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+$A0
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/4)+$A0
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+$A0
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+$A0
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+$A0
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+$A0
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+$A0
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+$A0
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+$A0
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+$A0
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+$A0
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+$A0
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+$A0
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+$A0
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+$A0
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+$A0
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+$A0
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+$A0
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+$A0
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+$A0
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+$A0
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+$A0
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+$A0
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+$A0
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+$A0
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+$A0
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+$A0
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+$A0
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+$A0
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+$A0
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+$A0
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+$A0
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+$A0
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+$A0
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+$A0
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+$A0
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+$A0
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+$A0
sfx_Waterfall:	equ $D0
sfx_Sega:	equ $E1
