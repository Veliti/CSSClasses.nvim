local json = require("json")
local gfind = require("CSSClasses.utils.gfind")

local M = {}

---@class RPCMessage
---@field id number?
---@field method string?
---@field params table?
---@field result string | number | boolean | table | nil
---@field error RPCMessage.Error?

---@class RPCMessage.Error
---@field code integer
---@field message string
---@field data string | number | boolean | table | nil

---@param tbl RPCMessage
---@return string
M.encode = function(tbl)
	tbl.jsonrpc = "2.0"
	local content = json.encode(tbl)
	return table.concat({
		"Content-Length: ",
		#content,
		"\r\n\r\n",
		content,
	})
end

---try to decode message
---@param data string
---@return RPCMessage, string
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
