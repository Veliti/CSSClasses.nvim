local jrpc = require("CSSClasses.lsp.jrpc")
local stdio = require("CSSClasses.io.stdio")

local M = {}

M.notify = function(method, params)
	stdio.write(jrpc.encode({
		method = method,
		params = params,
	}))
end

-- M.request = function(id, method, params)
-- 	stdio.write(jrpc.encode({
-- 		id = id,
-- 		method = method,
-- 		params = params,
-- 	}))
-- end

M.response = function(id, result, err)
	stdio.write(jrpc.encode({
		id = id,
		result = result,
		error = err,
	}))
end

---lisen for incoming messages
---@param callback fun(msg: RPCMessage)
M.lisen = function(callback)
	local data = ""
	stdio.lisen(function(part)
		local msg, rest = jrpc.decode(data)
		if msg then
			callback(msg)
			data = rest
		end
	end)
end

return M
