@echo OFF
setlocal EnableDelayedExpansion

cd ..

REM // To easily verify that merging the main AS branch doesn't break Project128. "Revision" must be set to 1.
REM // If engine changes are made to this branch, be sure to update the hash in this script!

call build

if exist s1built.bin (
	REM // Hash the ROM.
	for /f "tokens=1" %%H in ('
		certutil -hashfile "s1built.bin" MD5 ^| findstr /v "hash"
	') do set HASH=%%H
	echo s1built.bin MD5 hash is: !HASH!

	REM // Verify the hash against known builds.
	if /I "!HASH!"=="E925D91813F9290816F4DC986630F342" (
		echo ROM is bit-perfect with latest stable Project1TwoEight build.
	) else (
		echo ROM is NOT bit-perfect with latest stable Project1TwoEight build!
	)
)

REM // Prevent the window from disappearing immediately.
pause

