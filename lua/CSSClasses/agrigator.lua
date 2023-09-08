local parsers = require("CSSClasses.parsers")
local ftdetect = require("plenary.filetype")
local io = require("CSSClasses.io")

---@class RuleSet
---@field classnames string[]
---@field bounds {upper: number, lower : number}

---@class RuleSets
---@field file_dictionary table<string, RuleSet[]> path to ruleset dictionary
local RuleSets = {
	file_dictionary = {},
}

function RuleSets:init(root)
	local callback = function(type, file)
		---@type table<fs_event, function>
		local handle_fs = {
			["NEW"] = function(filename)
				if not self:contains(filename) then
					self:insert(filename, io.read_file(filename))
				end
			end,
			["CHANGED"] = function(filename)
				self:insert(filename, io.read_file(filename))
			end,
			["REMOVED"] = function(filename)
				self:remove(filename)
			end,
		}
		handle_fs[type](file)
	end

	io.watch_folder(root, callback)
end

---@param filename string
---@param source string
function RuleSets:insert(filename, source)
	local ft = ftdetect.detect(filename, {})
	local parser = parsers[ft]
	if not parser then
		return
	end
	self.file_dictionary[filename] = parser.parse(source)
end
---@param filename string
function RuleSets:remove(filename)
	self.file_dictionary[filename] = nil
end
---@param filename string
function RuleSets:contains(filename)
	return self.file_dictionary[filename]
end

--- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionList
---@param params NullLsParams
---@return lsp.CompletionList
function RuleSets:get_complition_list(params)
	local comp_list = {
		items = {},
		isIncomplete = false,
	}

	local set = {}
	for _, rules in pairs(self.file_dictionary) do
		for _, rule in ipairs(rules) do
			for _, class in ipairs(rule.classnames) do
				set[class] = true
			end
		end
	end
	for class, _ in pairs(set) do
		table.insert(comp_list.items, {
			label = "." .. class,
			textEdit = {
				newText = class,
				range = {
					start = {
						line = params.lsp_params.position.line,
						character = params.lsp_params.position.character - #params.word_to_complete - 1,
					},
					["end"] = params.lsp_params.position,
				},
			},
			kind = 7,
		})
	end
	return comp_list
end

return RuleSets
