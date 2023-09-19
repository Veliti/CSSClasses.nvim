---@type IParser
---@alias iter fun() : number | nil, number | nil, string | nil
local gfind = require("CSSClasses.utils.gfind")

M = {}

---comment
---@param source string
---@return RuleSet
M.parse = function(source)
	local rulesets = {}
	for start, stop, selectors in gfind(source, "([^{}]+){[^{}]*}") do
		---@type RuleSet
		local ruleset = {
			classnames = {},
			bounds = { upper = start, lower = stop },
		}

		for _, _, class in gfind(selectors, "%.([%w-_]+)") do
			table.insert(ruleset.classnames, class)
		end
		if #ruleset.classnames > 0 then
			table.insert(rulesets, ruleset)
		end
	end
	return rulesets
end

return M
