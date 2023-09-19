package.path = "deps/?.lua;" .. "deps/?/init.lua;" .. package.path
---@type uv
local uv = require("uv")
local dbg = require("debugger")
local json = require("json")

-- standard loop
uv.run()
uv.walk(uv.close)
uv.run()
