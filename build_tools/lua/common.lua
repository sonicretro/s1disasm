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

local function show_flashy_message(message)
	local width = 70

	local function do_full_line()
		local line = ""

		for _ = 1, width do
			line = line .. "*"
		end

		return line .. "\n"
	end

	local function do_empty_line()
		local line = "*"

		for _ = 1 + 1, width - 1 do
			line = line .. " "
		end

		return line .. "*\n"
	end

	local function do_message_line()
		local left_padding = (width - 2 - #message) // 2
		local right_padding = width - 2 - #message - left_padding

		if left_padding < 0 then
			left_padding = 0
		end

		if right_padding < 0 then
			right_padding = 0
		end

		local line = "*"

		for _ = 1, left_padding do
			line = line .. " "
		end

		line = line .. message

		for _ = 1, right_padding do
			line = line .. " "
		end

		return line .. "*\n"
	end

	print("\n" .. do_full_line() .. do_empty_line() .. do_message_line() .. do_empty_line() .. do_full_line())
end

local function get_platform_specific_info()
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
	local platform_directory = "build_tools" .. path_separator .. os_name .. "-" .. arch_name .. path_separator

	-- Return the list of tools.
	return platform_directory, executable_suffix, as_filename
end

local platform_directory_cached, executable_suffix_cached, as_filename_cached

local function get_platform_specific_info_memoised()
	if platform_directory_cached ~= nil then
		return platform_directory_cached, executable_suffix_cached, as_filename_cached
	end

	platform_directory_cached, executable_suffix_cached, as_filename_cached = get_platform_specific_info()

	return platform_directory_cached, executable_suffix_cached, as_filename_cached
end

local tools_cached = {}

-- Returns a table containing paths to the specified native tools.
-- Returns nil if the tools could not be found for the current platform.
local function find_tools(name, source_repo, pull_repo, ...)
	local platform_directory, executable_suffix = get_platform_specific_info_memoised()

	local tools = {}
	local tools_missing = false

	-- Create the paths to the specified tools.
	for _, tool_name in ipairs{...} do
		if tools_cached[tool_name] == nil then
			local tool_path = platform_directory .. tool_name .. executable_suffix

			if not file_exists(tool_path) then
				-- Tool could not be found.
				print("Could not find '" .. tool_path .. "'.")
				tools_missing = true
			else
				tools_cached[tool_name] = tool_path
			end
		end

		tools[tool_name] = tools_cached[tool_name]
	end

	if tools_missing then
		print("\n\z
			Sorry, the " .. name .. " for your platform is outdated and needs recompiling.\n\z
			\n\z
			You can find the source code at '" .. source_repo .. "'.\n\z
			Once compiled, copy the executable(s) to '" .. platform_directory .. "'.\n\z
			\n\z
			We'd appreciate it if you could send us your executables in a pull request at\n\z
			'" .. pull_repo .. "', so that other users don't have this\n\z
			problem in the future.")

		return nil
	end

	-- Return the list of tools.
	return tools
end

local function find_assembler(repository)
	local _, _, as_filename = get_platform_specific_info_memoised()
	local tools = find_tools("assembler", "https://github.com/Clownacy/asl-releases", repository, as_filename)

	if tools == nil then
		return nil
	end

	return tools[as_filename]
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
			checksum = checksum + (string.unpack("I1", bytes) << 8)
		end
	end

	-- Write the checksum to the ROM header.
	rom:seek("set", 0x18E)
	rom:write(string.pack(">I2", checksum & 0xFFFF))

	-- We're done editing the ROM header.
	rom:close()
end

-- Produce a binary from an assembly file.
-- Returns two booleans: the first indicating whether the build was entirely successful,
-- and the second indicating whether the build process should continue or not.
local function assemble_file(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)
	local function assemble_file_inner(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)
		-- Obtain the paths to the native build tools for the current platform.
		local tools = find_tools("'p2bin' tool", "https://github.com/Clownacy/p2bin", repository, "p2bin")

		if tools == nil then
			return "failure"
		end

		tools.as = find_assembler(repository)

		if tools.as == nil then
			return "failure"
		end

		-- As substitutes everything after the first period.
		local input_filename_before_first_period = string.match(input_filename, "(.-)%.")

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
		os.execute(tools.as .. " -xx -n -q -A -L -U -E -i . " .. (create_header_file and "-c" or "") .. " " .. as_arguments .. " " .. input_filename)

		-- If the assembler encountered an error, then the object file will not exist.
		if not file_exists(object_filename) then
			if not file_exists(log_filename) then
				return "crash"
			else
				return "error", log_filename
			end
		end

		-- Convert the object file to a flat binary.
		os.execute(tools.p2bin .. " " .. p2bin_arguments .. " " .. object_filename .. " " .. output_filename .. " " .. (create_header_file and header_filename or ""))

		-- Remove the object file, since we no longer need it.
		os.remove(object_filename)

		if not file_exists(output_filename) then
			return "failure"
		elseif file_exists(log_filename) then
			return "warning", log_filename
		end
	end

	local result, log_filename = assemble_file_inner(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)

	if log_filename ~= nil then
		for line in io.lines(log_filename) do
			print(line)
		end
	end

	if result == "failure" then
		show_flashy_message("Build failed. See above for more details.")
		return true, true -- Error message, abort.
	elseif result == "crash" then
		show_flashy_message("The assembler crashed. See above for more details.")
		return true, true -- Error message, abort.
	elseif result == "error" then
		show_flashy_message("There were build errors. See " .. log_filename .. " for more details.")
		return true, true -- Error message, abort.
	elseif result == "warning" then
		show_flashy_message("There were build warnings. See " .. log_filename .. " for more details.")
		return true, false -- Warning message, continue.
	else
		return false, false -- No message, continue.
	end
end

local function build_rom(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)
	-- Delete old ROM.
	os.remove(output_filename .. ".prev.bin")

	-- Backup the most recent ROM.
	os.rename(output_filename .. ".bin", output_filename .. ".prev.bin")

	local log_filename = input_filename .. ".log"

	-- Assemble the ROM.
	return assemble_file(input_filename .. ".asm", output_filename .. ".bin", as_arguments, p2bin_arguments, create_header_file, repository)
end

return {
	file_exists = file_exists,
	show_flashy_message = show_flashy_message,
	find_tools = find_tools,
	fix_header = fix_header,
	assemble_file = assemble_file,
	build_rom = build_rom,
}
