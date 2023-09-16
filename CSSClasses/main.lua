---@type uv
local uv = require("uv")
local json = require("deps/json")

print(json)

uv.run()
uv.walk(uv.close)
uv.run()
