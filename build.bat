@ECHO OFF

CALL "build_tools\node.bat" build.js || pause REM // Pause on failure so that the user can read the error message.
