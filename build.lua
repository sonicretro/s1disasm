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

os.exit(common.build_rom("sonic", "s1built", "", "-p=FF -z=0," .. (improved_dac_driver_compression and "kosinski-optimised" or "kosinski") .. ",Size_of_DAC_driver_guess,after", false, true, "https://github.com/sonicretro/s1disasm"))
