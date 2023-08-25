---@alias matched fun(s : string, position : integer) : boolean checks if coplition should be provided

---@param s string
---@param pos integer
---@param patterns string | string[]
local is_matched = function(s, pos, patterns)
	patterns = vim.tbl_flatten({ patterns })
	for _, pattern in pairs(patterns) do
		local start, stop
		repeat
			start, stop = s:find(pattern, stop)
			if start and start <= pos and stop >= pos then
				return true
			end
		until not start or start > pos
	end
	return false
end

local insertions = {
	html = function(s, position)
		return is_matched(s, position, {
			"=['\"].-['\"]",
			"%.[%S]*",
		})
	end,
	css = function(s, position)
		return is_matched(s, position, "%.[%S]*")
	end,
}

---@type table<string, matched>
return setmetatable({
	get_supported_files = function()
		return vim.tbl_keys(insertions)
	end,
}, { __index = insertions })
