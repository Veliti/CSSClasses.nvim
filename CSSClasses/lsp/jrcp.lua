local json = require("deps.json")

local M = {}

M.encode = function(method, params)
	local body = {
		["jsonrpc"] = "2,0",
		["id"] = 1,
		["method"] = method,
		["params"] = params,
	}
	local content = json.encode(body)
	return "Content-Length: " .. #content .. "\r\n\r\n" .. content
end

---@param data string
M.decode = function(data)
	local s, e, length = data:find("Content-Length:([%d ]+)\r\n")
	length = assert(tonumber(length), "RPC: COULDNT READ LENGTH")
	local s, e = data:find(".*\r\n", e)
	-- check if we have full message
	if #data - e >= length then
		local response = json.decode(data:sub(e, e + length))
	end
end

return M
