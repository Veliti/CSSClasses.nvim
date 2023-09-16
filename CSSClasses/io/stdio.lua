---@type uv
local uv = require("uv")

local M = {}

local stdin = assert(uv.new_pipe(false))
assert(stdin:open(0))
local stdout = assert(uv.new_pipe(false))
assert(stdout:open(1))

-- TODO: loging
M.write = function(data)
	stdin:write(data)
end

M.lisen = function(callback)
	stdout:read_start(function(err, data)
		assert(not err, err)
		if data then
			callback(data)
		end
	end)
end

return M
