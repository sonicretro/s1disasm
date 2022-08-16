-- Determine if a file exists.
local function file_exists(path)
	local file = io.open(path, "rb")

	if file then
		file:close()
		return true
	else
		return false
	end
end

-- Returns a table containing paths to the specified native tools.
-- Returns nil if the tools could not be found for the current platform.
local function find_tools(...)
	local path_separator, executable_suffix, as_filename

	local os_name, arch_name = require "build_tools.lua.get_os_name".get_os_name()

	if os_name == "Windows" then
		-- 64-bit x86 Windows can run 32-bit x86 executables.
		if arch_name == "x86_64" then
			arch_name = "x86"
		end
		path_separator = "\\"
		executable_suffix = ".exe"
		as_filename = "asw"
	else
		path_separator = "/"
		executable_suffix = ""
		as_filename = "asl"
	end

	-- Determine the platform directory.
	local platform_directory = "build_tools" .. path_separator .. os_name .. "-" .. arch_name

	local tools = {}

	-- Create the path to AS.
	tools.as = platform_directory .. path_separator .. as_filename .. executable_suffix

	-- Create the paths to the specified tools.
	for _, tool_name in ipairs{...} do
		local tool_path = platform_directory .. path_separator .. tool_name .. executable_suffix

		if not file_exists(tool_path) then
			-- Tool could not be found.
			return nil, platform_directory
		end

		tools[tool_name] = tool_path
	end

	-- Return the list of tools.
	return tools
end

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
local function fix_header(filename)
	local rom = io.open(filename, "r+b")

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
end

-- Produce a binary from an assembly file.
local function assemble_file(input_filename, output_filename, as_path, as_arguments, p2bin_path, p2bin_arguments, create_header)
	-- As substitutes everything after the first period.
	local input_filename_before_first_period = string.match(input_filename, "(.-)%.");

	local object_filename = input_filename_before_first_period .. ".p"
	local header_filename = input_filename_before_first_period .. ".h"
	local log_filename = input_filename_before_first_period .. ".log"

	-- Delete the object file, so that we can use its presence to detect a successful build later on.
	os.remove(object_filename)

	-- Assemble the ROM, producing an object file.
	-- '-xx'  - shows the most detailed error output
	-- '-q'   - shuts up AS
	-- '-A'   - gives us a small speedup
	-- '-U'   - forces case-sensitivity
	-- '-E'   - output errors to a file (*.log)
	-- '-i .' - allows (b)include paths to be absolute
	-- '-c'   - outputs a shared file (*.h)
	os.execute(as_path .. " -xx -n -q -A -L -U -E -i . " .. (create_header and "-c" or "") .. " " .. as_arguments .. " " .. input_filename)

	-- If the assembler encountered an error, then the object file will not exist.
	if not file_exists(object_filename) then
		if not file_exists(log_filename) then
			return "crash"
		else
			return "error"
		end
	end

	-- Convert the object file to a flat binary.
	os.execute(p2bin_path .. " " .. p2bin_arguments .. " " .. object_filename .. " " .. output_filename .. " " .. (create_header and header_filename or ""))

	-- Remove the object file, since we no longer need it.
	os.remove(object_filename)

	-- If a log file exists, then there were warnings.
	if not file_exists(log_filename) then
		return "success"
	else
		return "warning"
	end
end

return {
	file_exists = file_exists,
	find_tools = find_tools,
	fix_header = fix_header,
	assemble_file = assemble_file,
}
