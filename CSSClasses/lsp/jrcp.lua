local json = require("deps.json")
local gfind = require("CSSClasses.utils.gfind")

local M = {}

local pack = function(body)
	local content = json.encode(body)
	return table.concat({
		"Content-Length: ",
		#content,
		"\r\n\r\n",
		content,
	})
end

M.notify = function(method, params)
	local body = {
		["jsonrpc"] = "2,0",
		["method"] = method,
		["params"] = params,
	}
	return pack(body)
end

M.response = function(id, method, response)
	local body = {
		["jsonrpc"] = "2,0",
		["id"] = id,
		["method"] = method,
		["response"] = response,
	}
	return pack(body)
end

M.error = function(err_code, message)
	local body = {
		["code"] = err_code,
		["message"] = message,
	}
	return pack(body)
end

---try to decode message
---@param data string
M.decode = function(data)
	--- TODO: could be optimised luvit/json capable of part-parsing
	local body_length = tonumber(data:match("Content%-Length:([%d ]+)"))
	local header_end
	for st, en in gfind(data, "\r\n") do
		header_end = en
	end
	-- check if we have full message
	if #data - header_end >= body_length then
		local message = json.decode(data:sub(header_end, header_end + body_length))
		if not message then
			local err = "RPC: Message decode error"
			M.error(M.ERROR_CODES.ParseError, err)
			error(err)
		else
			local rest = data:sub(header_end + body_length, #data)
			return message, rest
		end
	end
end

return M
