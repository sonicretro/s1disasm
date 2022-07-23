#!/usr/bin/env lua

local md5 = require "build_tools.Lua.md5"

-- Build the ROM.
dofile("build.lua")

-- Create MD5 hasher.
local md5_hasher = md5.new()

-- Hash the ROM.
local rom = io.open("s1built.bin", "rb")

local hash

repeat
	local block_string = rom:read(64)

	if block_string == nil then
		bytes = 0
	else
		bytes = block_string:len()
	end

	if bytes == 64 then
		md5_hasher:PushData(block_string) -- All 64 bytes
	else
		hash = md5_hasher:PushFinalData(block_string, bytes * 8) -- 63 or fewer bytes
	end
until bytes ~= 64

rom:close()

-- Verify the hash against known builds.
print "-------------------------------------------------------------"

if hash == "1BC674BE034E43C96B86487AC69D9293" then
	print "ROM is bit-perfect with REV00."
elseif hash == "09DADB5071EB35050067A32462E39C5F" then
	print "ROM is bit-perfect with REV01."
elseif hash == "C6C15AEA60BDA10AE11C6BC375296153" then
	print "ROM is bit-perfect with REVXB."
else
	print "ROM is not bit-perfect with REV00, REV01, or REVXB."
end
