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

local M = {}

M.is_matched = function(s, pos)
	return is_matched(s, pos, {
		"['\"].-['\"]",
		">.-<",
	})
end

return M
