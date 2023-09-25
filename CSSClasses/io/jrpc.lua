---@type uv
local uv = require("uv")
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

local stdin = assert(uv.new_pipe(false))
assert(stdin:open(0))
local stdout = assert(uv.new_pipe(false))
assert(stdout:open(1))

local global_id = 0

local pack = function(tbl)
	tbl.jsonrpc = "2.0"
	local content = json.encode(tbl)
	return table.concat({
		"Content-Length: ",
		#content,
		"\r\n\r\n",
		content,
	})
end

-- M.lisen = function(callback)
-- 	stdout:read_start(function(err, data)
-- 		assert(not err, err)
-- 		if data then
-- 			callback(data)
-- 		end
-- 	end)
-- end

M.notify = function(method, params)
	stdout:write(pack({
		method = method,
		params = params,
	}))
end

M.request = function(method, params)
	global_id = global_id + 1
	stdout:write(pack({
		id = global_id,
		method = method,
		params = params,
	}))
	return global_id
end

M.response = function(id, result, err)
	stdout:write(pack({
		id = id,
		result = result,
		error = err,
	}))
end

---lisen for incoming messages
---@param callback fun(msg: RPCMessage)
M.lisen = function(callback)
	local data = ""
	stdin:read_start(function(err, part)
		assert(not err, err)
		if part then
			data = data .. part
		end
	end)
	-- stdio.lisen(function(part)
	-- 	local msg, rest = jrpc.decode(data)
	-- 	if msg then
	-- 		callback(msg)
	-- 		data = rest
	-- 	end
	-- end)
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
