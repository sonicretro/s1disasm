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

local compression = improved_dac_driver_compression and "kosinski-optimised" or "kosinski"
local message, abort = common.build_rom("sonic", "s1built", "", "-p=FF -z=0," .. compression .. ",Size_of_DAC_driver_guess,after", false, "https://github.com/sonicretro/s1disasm")

if message then
	exit_code = false
end

if abort then
	os.exit(exit_code, true)
end

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s1built.bin")

os.exit(exit_code, false)
