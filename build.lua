#!/usr/bin/env lua

--------------
-- Settings --
--------------

-- Set this to true to use a better compression algorithm for the DAC driver.
-- Having this set to false will use an inferior compression algorithm that
-- results in an accurate ROM being produced.
local improved_dac_driver_compression = false

---------------------
-- End of settings --
---------------------

local common = require "build_tools.lua.common"

-- Obtain the paths to the native build tools for the current platform.
local tools, platform_directory = common.find_tools("s1p2bin")

-- Present an error message to the user if the build tools for their platform do not exist.
if not tools then
	print(string.format("\z
		Sorry, the s1p2bin tool for your platform is outdated and needs recompiling.\n\z
		\n\z
		You can find the source code in 'build_tools/s1p2bin'.\n\z
		Once compiled, copy the executable to '%s'.\n\z
		\n\z
		We'd appreciate it if you could send us your binary in a pull request at\n\z
		https://github.com/sonicretro/s1disasm, so that other users don't have this\n\z
		problem in the future.", platform_directory))

	os.exit(false)
end

-- Delete old ROM.
os.remove("s1built.prev.bin")

-- Backup the most recent ROM.
os.rename("s1built.bin", "s1built.prev.bin")

-- Assemble the ROM.
local assemble_result = common.assemble_file("sonic.asm", "s1built.bin", tools.as, "", tools.s1p2bin, improved_dac_driver_compression and "" or " -a", false)

if assemble_result == "crash" then
	print "\n\z
		**********************************************************************\n\z
		*                                                                    *\n\z
		*         The assembler crashed. See above for more details.         *\n\z
		*                                                                    *\n\z
		**********************************************************************\n\z"

	os.exit(false)
elseif assemble_result == "error" then
	for line in io.lines("sonic.log") do
		print(line)
	end

	print "\n\z
		**********************************************************************\n\z
		*                                                                    *\n\z
		*      There were build errors. See sonic.log for more details.      *\n\z
		*                                                                    *\n\z
		**********************************************************************\n\z"

	os.exit(false)
end

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s1built.bin")

if assemble_result == "warning" then
	for line in io.lines("sonic.log") do
		print(line)
	end

	print "\n\z
		**********************************************************************\n\z
		*                                                                    *\n\z
		*     There were build warnings. See sonic.log for more details.     *\n\z
		*                                                                    *\n\z
		**********************************************************************\n\z"

	os.exit(false)
end

-- A successful build; we can quit now.
