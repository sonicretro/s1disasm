.DEFINE SonicMappingsVer 1
.DEFINE SonicDplcVer 1

.DEFINE current_mappings_table

; macro to declare a mappings table (taken from Sonic 2 Hg disassembly)
.MACRO mappingsTable
__	REDEFINE current_mappings_table = __
	.ENDM

; macro to declare an entry in a mappings table (taken from Sonic 2 Hg disassembly)
.MACRO mappingsTableEntry.b
	.DB __label__-current_mappings_table
.ENDM

.MACRO mappingsTableEntry.w
	.DW __label__-current_mappings_table
.ENDM

.MACRO mappingsTableEntry.l
	.DL __label__-current_mappings_table
.ENDM

.MACRO spriteHeader
	.IF SonicMappingsVer == 1
	dc.b ((@end - @begin) / 5)
	.ELIF SonicMappingsVer == 2
	dc.w ((@end - @begin) / 8)
	.ELSE
	dc.w ((@end - @begin) / 6)
	.ENDIF
@begin:
	.ENDM

.MACRO spritePiece ARGS xpos,ypos,width,height,tile,xflip,yflip,pal,pri
	.IF SonicMappingsVer == 1
	.DB	ypos
	.DB	(((width-1)&3)<<2)|((height-1)&3)
	.DB	((((pri&1)<<15)|((pal&3)<<13)|((yflip&1)<<12)|((xflip&1)<<11))+(tile))>>8
	.DB	tile&$FF
	.DB	xpos
	.ELIF SonicMappingsVer == 2
	.DW	((ypos&$FF)<<8)|(((width-1)&3)<<2)|((height-1)&3)
	.DW	(((pri&1)<<15)|((pal&3)<<13)|((yflip&1)<<12)|((xflip&1)<<11))+(tile)
	.DW	(((pri&1)<<15)|((pal&3)<<13)|((yflip&1)<<12)|((xflip&1)<<11))+(((tile)>>1)|((tile)&$8000))
	.DW	xpos
	.ELSE
	.DW	((ypos&$FF)<<8)|(((width-1)&3)<<2)|((height-1)&3)
	.DW	(((pri&1)<<15)|((pal&3)<<13)|((yflip&1)<<12)|((xflip&1)<<11))+(tile)
	.DW	xpos
	.ENDIF
	.ENDM
	
.MACRO dplcHeader
	.IF SonicDplcVer == 1
	.DB (@end - @begin) /2
	.ELSEIF SonicDplcVer == 2
	.DW (@end - @begin) / 2
	.ELSE
	.DW ((@end - @begin) / 2)-1
	.ENDIF
@begin:
	.ENDM

.MACRO dplcEntry ARGS tiles,offset
	.IF SonicDplcVer == 3
	.DW	((offset&$FFF)<<4)|((tiles-1)&$F)
	.ELSEIF SonicDplcVer == 4
	.DW	(((tiles-1)&$F)<<12)|((offset&$FFF)<<4)
	.ELSE
	.DW	(((tiles-1)&$F)<<12)|(offset&$FFF)
	.ENDIF
	.ENDM
	
