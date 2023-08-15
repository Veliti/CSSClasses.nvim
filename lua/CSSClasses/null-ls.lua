local null_ls = require("null-ls")
local parsers = require("CSSClasses.parsers")

M.setuplsp = function()
	local completion_source = {
		method = null_ls.methods.COMPLETION,
		filetypes = {},
		generator = {
			async = true,
			fn = function(params, done)
				local line = params.content[params.row]
				local cursor = params.col
				local patterns = M.complitionPatterns[parsers.get_lang_at_cursor()]

				local result
				for _, pattern in ipairs(patterns) do
					result = M.find(line, pattern, cursor)
					if result then
						break
					end
				end
				if not result then
					return
				end

				local items = M.createComplitionItems(M._classes, params.word_to_complete)
				done({ {
					items = items,
					isIncomplete = #items > 0,
				} })
			end,
		},
	}
	if null_ls.is_registered(M._name) then
		null_ls.deregister(M._name)
	end
	null_ls.register({ name = M._name, sources = { completion_source } })
end

--TODO class or tag selection
M.complitionPatterns = {
	html = {
		"class[%w]*=['\"].-['\"]",
		"%.",
	},
	css = {
		"%.",
	},
}
M.find = function(s, pattern, pos)
	local result = {}
	repeat
		result = { string.find(s, pattern, result[2] or 0) }
		if #result == 0 then
			return false
		end
	until result[2] or 0 >= pos
	return true
end

M.createComplitionItems = function(data, search)
	local classNames = {}
	for key, _ in pairs(data) do
		if string.match(key, search) then
			local completionItem = {
				label = key,
				kind = 7,
			}
			table.insert(classNames, completionItem)
		end
	end
	return classNames
end
