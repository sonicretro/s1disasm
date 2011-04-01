@echo off

asm68k /k /p /o ae- sonic.asm, s1built.bin >errors.txt, , sonic.lst
rem rompad.exe s1built.bin 255 0
fixheadr.exe s1built.bin