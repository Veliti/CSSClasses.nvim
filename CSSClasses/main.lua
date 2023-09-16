require = require("../deps/require.lua")

---@type uv
local uv = require("uv")
local json = require("json")

print(json)

uv.run()
uv.walk(uv.close)
uv.run()
