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

local exit_code
local repository = "https://github.com/sonicretro/s1disasm"

local function success_continue_wrapper(success, continue)
	if not success then
		exit_code = false
	end

	if not continue then
		os.exit(false)
	end
end

success_continue_wrapper(common.build_rom("sonic", "s1built", "", "-p=FF -z=0," .. (improved_dac_driver_compression and "kosinski-optimised" or "kosinski") .. ",Size_of_DAC_driver_guess,after", false, repository))

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s1built.bin")

-- A successful build; we can quit now.
os.exit(exit_code)