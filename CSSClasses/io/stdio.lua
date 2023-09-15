---@type uv
local uv = require("uv")
local json = require("CSSClasses.deps.json")

local M = {}

M.write = function(text)
	io.stdout:write(text)
end

M.lisen = function(callback) end

return M
