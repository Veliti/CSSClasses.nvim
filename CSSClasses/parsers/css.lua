---@type IParser
---@alias iter fun() : number | nil, number | nil, string | nil

M = {}

--- gets start and end of "selectors { params }" and selectors in as string
---@param source string
---@return iter
M._roolset_iter = function(source)
	local needle
	return function()
		local start, stop, selectors = source:find("([^{}]+){[^{}]*}", needle)
		needle = stop
		return start, stop, selectors
	end
end

---@param selectors string``
---@return iter
M._class_iter = function(selectors)
	local needle
	return function()
		local start, stop, class = selectors:find("%.([%w-_]+)", needle)
		needle = stop
		return start, stop, class
	end
end

---comment
---@param source string
---@return RuleSet
M.parse = function(source)
	local rulesets = {}
	for start, stop, selectors in M._roolset_iter(source) do
		---@type RuleSet
		local ruleset = {
			classnames = {},
			bounds = { upper = start, lower = stop },
		}

		for _, _, class in M._class_iter(selectors) do
			table.insert(ruleset.classnames, class)
		end
		if #ruleset.classnames > 0 then
			table.insert(rulesets, ruleset)
		end
	end
	return rulesets
end

return M
