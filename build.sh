#!/bin/bash

output_filename="s1built"

# Delete old ROM.
rm -f $output_filename".prev.gen"

# Backup the most recent ROM.
mv $output_filename".gen" $output_filename".prev.gen"


# Compile object files.
wla-z80 -v -o Build/z80.o sound/z80.asm

# wla-68000 -v -o Build/sonic.o sonic.asm
#
# cd Build
#
# # Link compiled binaries to make ROM file.
# wlalink -r -v -S link.def $output_filename".gen"
