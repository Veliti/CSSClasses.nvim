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

---@param callback fun(err : string, data : string)
M.listen = function(callback)
	server:listen(1, function(err)
		assert(not err, err)
		local client = uv.new_tcp()
		server:accept(client)
	end)
end

return M
