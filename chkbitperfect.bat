@ECHO OFF

"build_tools/Lua/lua.exe" chkbitperfect.lua || pause REM // Pause on Lua parse failure so that the user can read the error message.

pause
