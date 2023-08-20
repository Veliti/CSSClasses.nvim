local parsers = require("CSSClasses.parsers")
local ftdetect = require("plenary.filetype")
local io = require("CSSClasses.io")

---@class RuleSet
---@field classnames string[]
---@field bounds {upper: number, lower : number}

---@class RuleSets
---@field dictionary table<string, RuleSet[]> path to ruleset dictionary
local RuleSets = {
	dictionary = {},
}

function RuleSets:init(root)
	local handle_fs = {
		["CREATED"] = function(filename)
			if not self:contains(filename) then
				self:insert(filename, io.read_file(filename))
			end
		end,
		["CHANGED"] = function(filename)
			self:insert(filename, io.read_file(filename))
		end,
		["RENAMDED"] = function(filename, newname)
			error("UNIMPLEMENTED")
		end,
		["REMOVED"] = function(filename)
			self:remove(filename)
		end,
	}
	local callback = function(type, file, ...)
		handle_fs[type](file, ...)
	end

	io.get_files(root, callback)
	io.poll_fs(root, callback)
end

---@param filename string
---@param source string
function RuleSets:insert(filename, source)
	local ft = ftdetect.detect(filename, {})
	local parser = parsers[ft]
	if not parser then
		return
	end
	self.dictionary[filename] = parser.parse(source)
end
---@param filename string
function RuleSets:remove(filename)
	self.dictionary[filename] = nil
end
---@param filename string
function RuleSets:contains(filename)
	return self.dictionary[filename]
end

--- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionList
---@return table
function RuleSets:get_complition_list()
	local comp_list = {
		items = {},
		isIncomplete = false,
	}
	for _, rules in pairs(self.dictionary) do
		for _, rule in ipairs(rules) do
			for _, class in ipairs(rule.classnames) do
				table.insert(comp_list.items, {
					lable = class,
					-- TODO: better types
					kind = 7,
				})
			end
		end
	end
	return comp_list
end

return RuleSets
