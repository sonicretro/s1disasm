@ECHO OFF

REM // Runs a Node.js script, downloading a portable copy of Node.js first if it
REM // is not already available.

SETLOCAL

SET NODE_VERSION=v22.22.0
SET NODE=build_tools\node.exe

IF EXIST "%NODE%" GOTO run

WHERE node >NUL 2>NUL
IF %ERRORLEVEL%==0 (
    SET NODE=node
    GOTO run
)

ECHO Downloading portable Node.js...

WHERE curl >NUL 2>NUL
IF %ERRORLEVEL%==0 (
    curl -L -o build_tools\node.zip https://nodejs.org/dist/%NODE_VERSION%/node-%NODE_VERSION%-win-x64.zip
) ELSE (
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/%NODE_VERSION%/node-%NODE_VERSION%-win-x64.zip' -OutFile 'build_tools\node.zip'"
)

ECHO Extracting...
powershell -Command "Expand-Archive -Path 'build_tools\node.zip' -DestinationPath 'build_tools' -Force"
MOVE build_tools\node-%NODE_VERSION%-win-x64\node.exe "%NODE%" >NUL
RMDIR /S /Q build_tools\node-%NODE_VERSION%-win-x64
DEL build_tools\node.zip

:run
"%NODE%" %*
