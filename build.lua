#!/usr/bin/env lua

-- Set this to true to use a better compression algorithm for the DAC driver.
-- Having this set to false will use an inferior compression algorithm that
-- results in an accurate ROM being produced.
local improved_dac_driver_compression = false

local function file_exists(path)
	local file = io.open(path, "rb")
	
	if file then
		file:close()
		return true
	else
		return false
	end
end

-- Before we begin, let's detect our OS and set up our paths.
local os_name, arch_name = require "build_tools.Lua.get_os_name".get_os_name()

local platform_directory, as_path, p2bin_path

platform_directory = "build_tools"

if os_name == "Windows" then
	platform_directory = platform_directory .. "\\Win32"
	as_path = platform_directory .. "\\asw.exe"
	p2bin_path = platform_directory .. "\\s1p2bin.exe"
elseif os_name == "Mac" then
	platform_directory = platform_directory .. "/Osx"
	as_path = platform_directory .. "/asl"
	p2bin_path = platform_directory .. "/s1p2bin"
elseif os_name == "Linux" then
	if arch_name == "x86" then
		platform_directory = platform_directory .. "/Linux32"
	elseif arch_name == "x86_64" then
		platform_directory = platform_directory .. "/Linux"
	end

	as_path = platform_directory .. "/asl"
	p2bin_path = platform_directory .. "/s1p2bin"
else
	print "Build failed: Your OS is unsupported."
	return
end

if arch_name ~= "x86" and arch_name ~= "x86_64" then
	print "Build failed: Your CPU architecture is unsupported."
	return
end

if not file_exists(p2bin_path) then
	print(string.format("\z
		Sorry, the s1p2bin tool for your platform is outdated and needs recompiling.\n\z
		\n\z
		You can find the source code as well as a Makefile in 'build_tools/s1p2bin'.\n\z
		Once compiled, copy the executable to '%s'.\n\z
		\n\z
		We'd appreciate it if you could send us your binary in a pull request at\n\z
		https://github.com/sonicretro/s1disasm, so other users don't have this problem\n\z
		in the future.", platform_directory))
else
	-- Delete old ROM.
	os.remove("s1built.prev.bin")

	-- Backup the most recent ROM.
	os.rename("s1built.bin", "s1built.prev.bin")

	-- Delete object file, so that we can use its presence to detect a successful build.
	os.remove("sonic.p")

	-- Assemble the ROM, producing an object file.
	-- '-xx'  - shows the most detailed error output
	-- '-q'   - shuts up AS
	-- '-A'   - gives us a small speedup
	-- '-U'   - forces case-sensitivity
	-- '-E'   - output errors to a file (sonic.log)
	-- '-i .' - allows (b)include paths to be absolute
	os.execute(as_path .. " -xx -n -q -A -L -U -E -i . sonic.asm")

	-- If the assembler encountered an error, then the object file will not exist.
	if not file_exists("sonic.p") then
		print "\n\z
			**********************************************************************\n\z
			*                                                                    *\n\z
			*      There were build errors. See sonic.log for more details.      *\n\z
			*                                                                    *\n\z
			**********************************************************************\n\z"
	else
		-- Convert the object file into a ROM.
		local p2bin_args = "-a"

		if improved_dac_driver_compression then
			p2bin_args = ""
		end

		os.execute(p2bin_path .. " " .. p2bin_args .. " sonic.p s1built.bin")

		-- Correct the ROM's header with a proper checksum and end-of-ROM value.
		local rom = io.open("s1built.bin", "r+b")

		-- Obtain the end-of-ROM value.
		local rom_end = rom:seek("end", 0) - 1

		-- Write the end-of-ROM value to the ROM header.
		rom:seek("set", 0x1A4)
		rom:write(string.pack(">I4", rom_end))

		-- Calculate the checksum.
		local checksum = 0
		rom:seek("set", 0x200)
		for bytes in function() return rom:read(2) end do
			if bytes:len() == 2 then
				checksum = checksum + string.unpack(">I2", bytes)
			else
				checksum = checksum + (string.unpack("I1", byte) << 8)
			end
		end

		-- Write the checksum to the ROM header.
		rom:seek("set", 0x18E)
		rom:write(string.pack(">I2", checksum & 0xFFFF))

		-- We're done editing the ROM header.
		rom:close()

		-- If we've gotten this far but a log file exists, then there must have been build warnings.
		if file_exists("sonic.log") then
		print "\n\z
			**********************************************************************\n\z
			*                                                                    *\n\z
			*     There were build warnings. See sonic.log for more details.     *\n\z
			*                                                                    *\n\z
			**********************************************************************\n\z"
		else
			-- A successful build; we can quit now.
			return
		end
	end
end

-- If we're on Windows, then keep the console window open so that the user can read the message that we're trying to show them.
if os_name == "Windows" then
	os.execute("pause")
end
