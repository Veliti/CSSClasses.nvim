---@type uv
local uv = require("uv")
local tcp = require("CSSClasses.io.tcp")
tcp.start(1111)

tcp.listen(callback)

uv.run()
uv.walk(uv.close)
uv.run()
