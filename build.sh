#!/bin/bash

output_filename="s1built"

# Compiler Flags
flags_z80="-v -o"

# Delete old ROM.
# rm -f $output_filename".prev.gen"

# Backup the most recent ROM.
# mv $output_filename".gen" $output_filename".prev.gen"


# Compile object files.
wla-z80 $flags_z80 Build/z80.o Sound/z80.asm

# wla-68000 -v -o Build/sonic.o sonic.asm
#
# cd Build
#
# # Link compiled binaries to make ROM file.
# wlalink -r -v -S link.def $output_filename".gen"
