---@type uv
local uv = require("uv")

local M = {}
---@type uv_tcp_t
local server

M.start = function(port)
	server = uv.new_tcp()
	assert(server:bind("127.0.0.1", port))
end

M.stop = function()
	server:close()
end

M.send = function(message)
	assert(server:write(message))
end

M.listen = function(callback)
	server:read_start(function(err, data)
		if err then
			print(err)
		elseif data then
			print(data)
		end
	end)
end

return M
