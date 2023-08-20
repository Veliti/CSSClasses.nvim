---@alias match fun(s : string, position : integer) : boolean checks if coplition should be provided

local is_matched = function(s, pos, patterns)
	patterns = vim.tbl_flatten({ patterns })
end

local insertions = {
	html = function(s, position)
		return is_matched(s, position, {
			"class[%w]*=['\"].-['\"]",
			"%.",
		})
	end,
	css = function(s, position)
		return is_matched(s, position, "%.[%w]*")
	end,
}

---@type table<string, match>
return setmetatable({
	get_supported_files = function()
		return vim.tbl_keys(insertions)
	end,
}, { __index = insertions })
