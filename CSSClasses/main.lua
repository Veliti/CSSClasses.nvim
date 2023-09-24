---@type uv
local uv = require("uv")
local jrpc = require("CSSClasses.lsp.jrcp")

-- standard loop
uv.run()
uv.walk(uv.close)
uv.run()
