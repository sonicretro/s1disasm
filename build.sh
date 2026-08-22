#!/bin/bash

output_filename="s1built"

# Compiler Flags
flags_z80="-v -o"
flags_68k="-v -o"
flags_lnk="-r -S"

# Delete old ROM.
# rm -f Build/$output_filename".prev.gen"
rm -f Build/pcm_driver.z80
rm -f Build/z80_boot.z80

# Backup the most recent ROM.
# mv Build/$output_filename".gen" Build/$output_filename".prev.gen"

echo """\
----------------------------------------
---		Compiling...	     ---
----------------------------------------
"""

# Compile libraries.
# By default there are no libraries with ROM data.

# Compile object files.
echo '
-----------------------------[Sound/z80.asm]'
wla-z80 $flags_z80 Build/pcm_driver.o Sound/z80.asm
echo '
------------------------[misc/Z80 Boot.asm]'
wla-z80 $flags_z80 Build/z80_boot.o "misc/Z80 Boot.asm"
echo '
--------------------------------[sonic.asm]'
wla-68000 $flags_68k Build/sonic.o sonic.asm

echo """\
----------------------------------------
---		Linking...	     ---
----------------------------------------
"""
cd Build

# Link compiled binaries to make ROM file.
#wlalink $flags_lnk link_pcm.def pcm_driver.z80

wlalink $flags_lnk link_z80_boot.def z80_boot.z80

wlalink $flags_lnk link_main.def $output_filename".gen"

