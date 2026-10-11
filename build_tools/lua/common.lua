local common = {}

local clownmd5 = require "build_tools.lua.clownmd5"

local os_name, arch_name = require "build_tools.lua.get_os_name".get_os_name()

------------------------
-- Internal Utilities --
------------------------

local function is_windows()
	return os_name == "Windows"
end

local function open_file_with_warning(path, mode)
	local file = io.open(path, mode)

	if not file then
		print("Failed to open file '" .. path .. "'!")
	end

	return file
end

local function get_file_size(file_path)
	local file = io.open(file_path, "rb")

	if file then
		local size = file:seek("end")
		file:close()
		return size
	end
end

-- File Reading --

local function read_wrapper(file, format, bytes)
	local data = file:read(bytes)

	if data then
		return string.unpack(format, data)
	end
end

local function read_s8(file)
	return read_wrapper(file, "i1", 1)
end

local function read_s16le(file)
	return read_wrapper(file, "<i2", 2)
end

local function read_s32le(file)
	return read_wrapper(file, "<i4", 4)
end

local function read_u8(file)
	return read_wrapper(file, "I1", 1)
end

local function read_u16le(file)
	return read_wrapper(file, "<I2", 2)
end

local function read_u32le(file)
	return read_wrapper(file, "<I4", 4)
end

-- Division --

local function divide_round_up(dividend, divisor)
	return (dividend + (divisor - 1)) // divisor
end

local function divide_round_down(dividend, divisor)
	return dividend // divisor
end

local function divide_round_half_up(dividend, divisor)
	return divide_round_down(dividend + (divisor // 2), divisor)
end

local function divide_round_half_down(dividend, divisor)
	return divide_round_up(dividend - (divisor // 2), divisor)
end

local function divide_round_half_away_from_zero(dividend, divisor)
	if dividend < 0 then
		return divide_round_half_down(dividend, divisor)
	else
		return divide_round_half_up(dividend, divisor)
	end
end

-----------------------
-- General Utilities --
-----------------------

local function exit(release)
	os.exit(common.exit_code, release)
end

local function handle_failure(message_printed, abort)
	if message_printed then
		common.exit_code = false
	end

	if abort then
		exit(true)
	end
end

local function get_split_filename(filename)
	local index = filename:find(".", 1, true)

	if index == nil then
		return filename
	end

	return filename:sub(1, index - 1), filename:sub(index)
end

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

-----------------------
-- Directory Listing --
-----------------------

local function get_directory_contents(path, extension)
	local function get_directory_contents(path)
		local listing

		if is_windows() then
			listing = io.popen("dir /b \"" .. path .. "\"", "r")
		else
			-- Assumes POSIX.
			listing = io.popen("ls " .. path, "r")
		end

		local contents = {}
		for entry in listing:lines() do
			contents[1 + #contents] = entry
		end

		return contents
	end

	local contents = get_directory_contents(path)

	if not extension then
		return contents
	end

	-- Collect the entries that match the given file extension.
	local filtered_contents = {}

	for key, filename in ipairs(contents) do
		local filename_stem, filename_extension = get_split_filename(filename)

		if filename_extension == extension then
			filtered_contents[1 + #filtered_contents] = filename_stem
		end
	end

	return filtered_contents
end

local function load_hashes(file_path)
	local hashes_file = io.open(file_path, "r")

	local hashes

	if not hashes_file then
		-- 'hashes.lua' does not exist: create an empty table instead.
		hashes = {}
	else
		-- 'hashes.lua' does exist: turn it into a valid Lua chunk and load its data into the table.
		local chunk = load("return {" .. hashes_file:read("a") .. "}")
		hashes_file:close()

		-- If `hash.lua` fails to compile, then ignore it and load an empty table instead.
		hashes = chunk and chunk() or {}
	end

	return hashes
end

local function hash_to_string_literal(hash)
	local function hash_string_iterator()
		local position = 1

		return function()
				if position > hash:len() then
					return nil
				end

				local byte
				byte, position = string.unpack("I1", hash, position)

				return byte
			end
	end

	local hash_string = ""
	for byte in hash_string_iterator() do
		hash_string = hash_string .. string.format("\\x%02X", byte)
	end
	return hash_string
end

local function get_directory_contents_changed(directory, base_extension, replacement_extensions, custom_hashes)
	local lua_file_path = directory .. "/generated/hashes.lua"

	local hashes = load_hashes(lua_file_path)

	local function update_value(key, value)
		if hashes[key] ~= value then
			hashes[key] = value
			return true
		else
			return false
		end
	end

	local function update_hash(key, filename)
		return update_value(key, clownmd5.HashFile(filename))
	end

	local custom_hashes_differ = false
	if custom_hashes then
		for key, value in pairs(custom_hashes) do
			if hashes[key] ~= value then
				hashes[key] = value
				custom_hashes_differ = true
			end
		end
	end

	local filtered_contents = {}

	-- 'hashes.lua' contains the hashes of every assembled song. If a song's hash
	-- matches the one recorded in this file, then there is no need to assemble it again.
	-- Our first task is to load the hashes contained in this file into a table.
	for _, filename in ipairs(get_directory_contents(directory, base_extension)) do
		local file_differs = update_hash(filename, directory .. "/" .. filename .. base_extension)

		local function output_file_missing()
			for _, replacement_extension in ipairs(replacement_extensions) do
				local output_file_path = directory .. "/generated/" .. filename .. replacement_extension

				if not file_exists(output_file_path) then
					return true
				end
			end
		end

		if custom_hashes_differ or file_differs or output_file_missing() then
			filtered_contents[1 + #filtered_contents] = filename
		end
	end

	-- Now that that's done, we can begin re-writing 'hashes.lua' with the new hashes that we compute in the next step.
	local hashes_file = open_file_with_warning(lua_file_path, "w")

	if hashes_file then
		for key, value in pairs(hashes) do
			hashes_file:write( "['" .. key .. "'] = ")

			if type(value) == "string" then
				hashes_file:write("'" .. hash_to_string_literal(value) .. "'")
			else
				hashes_file:write(tostring(value))
			end

			hashes_file:write(",\n")
		end

		-- We've written the last part of the 'hashes.lua' file, so we can close it now.
		hashes_file:close()
	end

	return filtered_contents
end

-----------
-- Tools --
-----------

local function get_platform_specific_info()
	local path_separator, executable_suffix, as_filename, executable_arch

	if is_windows() then
		-- Use 64-bit executables for Windows, if possible.
		executable_arch = (arch_name == "x86_64") and arch_name or "x86"
		path_separator = "\\"
		executable_suffix = ".exe"
		as_filename = "asw"
	else
		executable_arch = arch_name
		path_separator = "/"
		executable_suffix = ""
		as_filename = "asl"
	end

	-- Determine the platform directory.
	local platform_directory = "build_tools" .. path_separator .. os_name .. "-" .. executable_arch .. path_separator

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
	local tools = find_tools("assembler", "https://github.com/flamewing/asl-releases", repository, as_filename)

	if tools == nil then
		return nil
	end

	return tools[as_filename]
end

--------------------
-- PCM Processing --
--------------------

local function read_wav_file(input_file_path)
	local audio = {}
	local message

	local input_file = open_file_with_warning(input_file_path, "rb")

	if input_file then
		local function read_chunk_header(file)
			local id = input_file:read(4)
			local size = read_u32le(input_file)

			if id and size then
				return id, size
			end
		end

		local fourcc, file_size = read_chunk_header(input_file)
		local format = input_file:read(4)

		if fourcc ~= "RIFF" then
			message = "FOURCC check failed; this is not a valid WAV file!"
		elseif format ~= "WAVE" then
			message = "RIFF format check failed; this is not a valid WAV file!"
		else
			local function chunk_size_check(name, size, expected_size)
				if size < expected_size then
					message = name .. " chunk was smaller than expected (" .. size .. " instead of " .. expected_size .. ")!"
				else
					return true
				end
			end

			audio.channels = 1
			audio.sample_rate = 8000
			audio.bytes_per_sample = 1

			for chunk_id, chunk_size in function() return read_chunk_header(input_file) end do
				local starting_position = input_file:seek()

				if chunk_id == "fmt " then
					if chunk_size_check("Format", chunk_size, 16) then
						local format = read_u16le(input_file)
						audio.channels = read_u16le(input_file)
						audio.sample_rate = read_u32le(input_file)
						local bytes_per_second = read_u32le(input_file)
						local bytes_per_block = read_u16le(input_file)
						audio.bytes_per_sample = divide_round_up(read_u16le(input_file), 8)

						if format ~= 1 then
							message = "Unsupported sample format '" .. format .. "' (only '1' is supported)!"
						end
					end
				elseif chunk_id == "data" then
					local function read_signed_sample()
						if audio.bytes_per_sample == 1 then
							-- 8-bit is unsigned.
							return read_u8(input_file) - 0x80
						else
							-- Everything else is signed.
							return string.unpack("<i" .. audio.bytes_per_sample, input_file:read(audio.bytes_per_sample))
						end
					end

					audio.samples = {}
					for _ = 1, chunk_size, audio.bytes_per_sample do
						audio.samples[1 + #audio.samples] = read_signed_sample()
					end
				end

				-- Advance past the chunk.
				input_file:seek("set", starting_position + chunk_size)
			end
		end

		input_file:close()
	end

	if message then
		return nil, message
	end

	return audio
end

local function convert_audio_to_u8(audio)
	local function read_sample(samples, sample_index)
		local sample = samples[sample_index]

		-- Downsample to 8-bit.
		sample = divide_round_half_away_from_zero(sample, 1 << 8 * (audio.bytes_per_sample - 1))

		-- Convert to unsigned.
		return sample + 0x80
	end

	local function read_frame(samples, sample_index)
		-- Downsample to mono by averaging the samples.
		local accumulator = 0
		for i = sample_index, sample_index + audio.channels - 1 do
			accumulator = accumulator + read_sample(samples, i)
		end
		accumulator = divide_round_half_away_from_zero(accumulator, audio.channels)

		return accumulator
	end

	local old_samples = audio.samples
	audio.samples = {}

	for i = 1, #old_samples, audio.channels do
		audio.samples[1 + #audio.samples] = read_frame(old_samples, i)
	end

	audio.channels = 1
	audio.bytes_per_sample = 1
end

local function convert_wav_file(audio, output_file_path, callback)
	local output_file = io.open(output_file_path, "wb")

	if not output_file then
		message = "Could not open output file '" .. output_file_path .. "'!"
	else
		for _, sample in ipairs(audio.samples) do
			callback(output_file, sample)
		end

		output_file:close()
	end

	return message
end

local function convert_pcm_file(audio, output_file_path)
	local function callback(output_file, sample)
		output_file:write(string.pack("I1", sample))
	end

	return convert_wav_file(audio, output_file_path, callback)
end

local function convert_dpcm_file(audio, output_file_path, deltas)
	local function find_closest_delta(sample, previous_sample)
		local best_error = math.huge
		local best_index

		for delta_index, delta in ipairs(deltas) do
			local approximated_sample = (previous_sample + delta) & 0xFF

			local error = math.abs(sample - approximated_sample)
			if best_error > error then
				best_error = error
				best_index = delta_index
			end
		end

		return best_index
	end

	local previous_sample = 0x80
	local accumulator = 0
	local flip_flop = false

	local function callback(output_file, sample)
		local index = find_closest_delta(sample, previous_sample)

		previous_sample = previous_sample + deltas[index]

		accumulator = accumulator & 0xF
		accumulator = accumulator << 4
		accumulator = accumulator | (index - 1)

		if flip_flop == true then
			output_file:write(string.pack("I1", accumulator))
		end

		flip_flop = not flip_flop
	end

	return convert_wav_file(audio, output_file_path, callback)
end

local function convert_wav_files_in_directory(directory, extension, callback, custom_hashes, ...)
	for _, filename_stem in ipairs(get_directory_contents_changed(directory, ".wav", {extension, ".inc"}, custom_hashes)) do
		local input_file_path = directory .. "/" .. filename_stem .. ".wav"
		local output_file_path = directory .. "/generated/" .. filename_stem .. extension
		local inc_file_path = directory .. "/generated/" .. filename_stem .. ".inc"

		print("Converting WAV file '" .. input_file_path .. "'...")

		local audio, message = read_wav_file(input_file_path)

		if audio ~= nil then
			convert_audio_to_u8(audio)

			message = callback(audio, output_file_path, ...)

			local inc_file = open_file_with_warning(inc_file_path, "w")

			if inc_file then
				inc_file:write(string.format(
[[
.sample_rate = %i
.size = %i
	binclude "%s"
]], audio.sample_rate, get_file_size(output_file_path), output_file_path
				))

				inc_file:close()
			end
		end

		if message then
			print("Failed to convert '" .. input_file_path .. "' to '" .. output_file_path .. "'. Error message was:\n\t" .. message)
			handle_failure(true, true)
		end
	end
end

local function convert_pcm_files_in_directory(directory)
	convert_wav_files_in_directory(directory, ".pcm", convert_pcm_file)
end

local function convert_dpcm_files_in_directory(directory)
	local deltas_file_path = directory .. "/deltas.bin"

	-- Load deltas file.
	local deltas_file = open_file_with_warning(deltas_file_path, "rb")

	-- Gracefully handle a missing file here to prevent a total build failure.
	-- Users of custom sound drivers may remove the file, and not need any of
	-- this conversion logic.
	if deltas_file == nil then
		print("Skipping conversion of DPCM files!")
		return
	end

	local deltas = {}
	repeat
		local byte = read_u8(deltas_file)
		deltas[1 + #deltas] = byte
	until not byte

	deltas_file:close()

	convert_wav_files_in_directory(directory, ".dpcm", convert_dpcm_file, {deltas = clownmd5.HashFile(deltas_file_path)}, deltas)
end

------------------
-- ROM Patching --
------------------

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
local function fix_header(filename)
	local rom = open_file_with_warning(filename, "r+b")

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

----------------
-- Assembling --
----------------

local function assemble_file_and_handle_failure(...)
	handle_failure(assemble_file(...))
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

local function build_rom_and_handle_failure(...)
	handle_failure(build_rom(...))
end

------------
-- Export --
------------

common.clownmd5 = clownmd5
common.exit = exit
common.handle_failure = handle_failure
common.get_directory_contents = get_directory_contents
common.get_directory_contents_changed = get_directory_contents_changed
common.get_split_filename = get_split_filename
common.file_exists = file_exists
common.show_flashy_message = show_flashy_message
common.find_tools = find_tools
common.convert_pcm_files_in_directory = convert_pcm_files_in_directory
common.convert_dpcm_files_in_directory = convert_dpcm_files_in_directory
common.fix_header = fix_header
common.assemble_file = assemble_file
common.assemble_file_and_handle_failure = assemble_file_and_handle_failure
common.build_rom = build_rom
common.build_rom_and_handle_failure = build_rom_and_handle_failure
return common
