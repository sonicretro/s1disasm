# Sonic 1 disassembly for wla-dx compiler
## This is a work in progress
============

See: http://info.sonicretro.org/Disassemblies
- This fork is not affiliated with Sonic Retro)

A fork of the very latest Sonic 1 Disassembly made for wla-dx.

# Notes for developers coming from AS or asm68k compilers
WLA-DX has some slight syntax differences
| Topic | asw/asm68k | wla-68000 |
| --- | --- | --- |
| Sizing jumps  | .s .w ?? .l | .b .w .l .d |
| Sizing values | .b .w ?? .l | .b .w .l .d |
| Equates       | variable: equ calculation | .define variable calculation |
| Equates       | variable: equ calculation | .define variable calculation |

Documentation: https://wla-dx.readthedocs.io/en/latest/


DISCLAIMER:
Any and all content presented in this repository is presented for informational and educational purposes only.
Commercial usage is expressly prohibited. Sonic Retro claims no ownership of any code in these repositories.
You assume any and all responsibility for using this content responsibly. Sonic Retro claims no responsibiliy or warranty.
