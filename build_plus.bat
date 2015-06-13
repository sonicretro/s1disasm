@ECHO OFF

REM // make sure we can write to the file s1built.bin
REM // also make a backup to s1built.prev.bin
IF NOT EXIST s1built.bin goto LABLNOCOPY
IF EXIST s1built.prev.bin del s1built.prev.bin
IF EXIST s1built.prev.bin goto LABLNOCOPY
move /Y s1built.bin s1built.prev.bin
IF EXIST s1built.bin goto LABLERROR2
:LABLNOCOPY

REM // delete some intermediate assembler output just in case
IF EXIST sonic.p del sonic.p
IF EXIST sonic.p goto LABLERROR1

REM // clear the output window
cls

REM // run the assembler
REM // -xx shows the most detailed error output
REM // -q makes AS shut up
REM // -E outputs error messages to file
REM // -A gives us a small speedup
REM // -L generates a listing file
set AS_MSGPATH=AS/Win32
set USEANSI=n

REM // allow the user to choose to output error messages to file by supplying the -logerrors parameter
IF "%1"=="-logerrors" ( "AS/Win32/asw.exe" -xx -q -A -L sonic.asm ) ELSE "AS/Win32/asw.exe" -xx -q -E -A -L sonic.asm

REM // if there were errors, a log file is produced
IF EXIST sonic.log goto LABLERROR3

REM // combine the assembler output into a ROM
IF EXIST sonic.p "AS/Win32/s1p2bin_plus" sonic.p s1built.bin

REM // done -- pause if we seem to have failed, then exit
IF NOT EXIST sonic.p goto LABLPAUSE
IF NOT EXIST s1built.bin goto LABLPAUSE
fixheader s1built.bin
exit /b
:LABLPAUSE

pause


exit /b

:LABLERROR1
echo Failed to build because write access to sonic.p was denied.
pause


exit /b

:LABLERROR2
echo Failed to build because write access to s1built.bin was denied.
pause

exit /b

:LABLERROR3
REM // display a noticeable message
echo.
echo *************************************************************************
echo *                                                                       *
echo *   There were build errors/warnings. See sonic.log for more details.   *
echo *                                                                       *
echo *************************************************************************
echo.
pause

