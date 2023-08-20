---@class IParser
---@field parse fun(source: string): RuleSet[]
local parsers = {
	css = require("CSSClasses.parsers.css"),
}

return setmetatable({
	get_supported_files = function()
		return vim.tbl_keys(parsers)
	end,
}, { __index = parsers })
