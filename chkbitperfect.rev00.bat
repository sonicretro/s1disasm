@echo OFF

REM // build the ROM
call build

REM  // run fc against a Sonic 1 Rev 00 ROM
echo -------------------------------------------------------------
if exist s1built.bin ( fc /b s1built.bin s1rev00.bin
) else echo s1built.bin does not exist, probably due to an assembly error

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause
