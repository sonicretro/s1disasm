#!/usr/bin/env lua

local md5 = require "build_tools.Lua.md5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

-- Hash the ROM.
local hash = md5.HashFile("s1built.bin")

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
