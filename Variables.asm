
;
; Sega Mega Drive/Genesis MC68000 Memory Map (WLA-DX repository)
; 

.MEMORYMAP
DEFAULTSLOT 0
	SLOT 0 START $000000 SIZE $400000 NAME "ROM"   ; 4MB ROM / Cartridge RAM / Cartridge
	SLOT 1 START $A00000 SIZE   $2000 NAME "ZRAM"  ; 8KB Z80 RAM
	SLOT 2 START $FF0000 SIZE  $10000 NAME "WRAM"  ; 64KB Work RAM
.ENDME

.ROMBANKSIZE $0FFFFF
.ROMBANKS 1

; Undefined labels (TODO)
.DEFINE v_systemstack 0 
.DEFINE port_1_control_hi $A10008
.DEFINE expansion_control_hi $A1000C
.DEFINE z80_ram $A00000
.DEFINE z80_ram_end $A02000

.DEFINE z80_reset $A11200
.DEFINE z80_bus_request $A11100
.DEFINE vdp_data_port $C00000
.DEFINE vdp_control_port $C00004

; Constants (TODO)
.DEFINE tile_size 8*8/2	; size of a single 8x8 tile
.DEFINE chunk_size $200	; size of a single 256x256 chunk

.STRUCT Object SIZE $40
obID		DB ; (00) Object's type (ID)
obRender	DB ; (01) Bitfield for x/y flip & display mode
obGfx		DW ; (02) Palette & VRAM setting
obMap		DD ; (04) Mappings address
obX		DD ; (08) X-axis position
obScreenY	DW ; (0A) Y-axis screen-fixed position
obY		DD ; (0C) Y-axis position
obVelX		DW ; (10) X-axis velocity
obVelY		DW ; (12) Y-axis velocity
obInertia	DW ; (14) Potential speed
obHeight	DB ; (16) Height/2
obWidth		DB ; (17) Width/2
obPriority	DB ; (18) Sprite priority -- 0 is front
obActWid	DB ; (19) Action width
obFrame		DB ; (1A) Current frame displayed
obAniFrame	DB ; (1B) Offset in animation script
obAnim		DB ; (1C) Current animation
obPrevAni	DB ; (1D) Previous animation
obTimeFrame	DB ; (1E) Time to next frame
obDelayAni	DB ; (1F) Time to delay animation
obColType	DB ; (20) Collision response type
obColProp	DB ; (21) Collision extra property
obStatus	DB ; (22) Orientation or mode
obRespawnNo	DB ; (23) Respawn list index number
obRoutine	DB ; (24) Routine number

ob2ndRout	DB ; (25) Secondary routine number
obAngle		DB ; (26) Object's angle
obSubtype	DB ; (27) Object's subtype
.ENDST

.DEFINE Object.obSolid Object.ob2ndRout ; Solid status flag

.DEFINE v_256x256_end = v_256x256+_sizeof_v_256x256

.DEFINE v_lvllayout_end = v_lvllayout+_sizeof_v_lvllayout

.RAMSECTION "LevelData" BANK 0 SLOT "WRAM"
v_256x256		DSB $52*chunk_size ; 256x256 chunks (16 blocks)
		
v_lvllayout		DSB $400 ; Level and background layouts
;v_lvllayout_end

v_bgscroll_buffer	DSB $200 ; Background scroll buffer
v_ngfx_buffer		DSB $200 ; Nemesis graphics decompression buffer
;v_ngfx_buffer_end

v_spritequeue		DSB $400 ; Object display queue, in order of priority
v_16x16			DSB $1800 ; 16x16 blocks for levels (4 tiles)

v_sgfx_buffer		DSB tile_size*23 ; Sonic's art buffer
;v_sgfx_buffer_end
.			DSB $20 ; Unused bytes
v_tracksonic		DSB $100 ; Sonic's tracked positions
v_hscrolltablebuffer	DSB $380 ; Horizontal scroll buffer
;v_hscrolltablebuffer_end:
.			DSB $80 ; v_hscrolltablebuffer leaks here 
.ENDS

.RAMSECTION "ObjectSpace" APPENDTO "LevelData"
v_objspace 		INSTANCEOF Object $20 STARTFROM 0 ; Object variable space
v_lvlobjspace 		INSTANCEOF Object $40 STARTFROM 0 ; Object variable space
.ENDS
