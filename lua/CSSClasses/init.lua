local io = require("CSSClasses.io")
local parsers = require("CSSClasses.parsers")
local ftdetect = require("plenary.filetype")

local M = {}

local path = "/home/veliti/Documents/Projects/CSSClasses.nvim/lua/CSSClasses/test/"

---@class RuleSet
---@field classnames string[]
---@field bounds {upper: number, lower : number}

M.RuleSets = {
	---@type table<string, RuleSet[]>
	dictionary = {},
}

---@param filename string
function M.RuleSets:insert(filename)
	local ft = ftdetect.detect(filename, {})
	local parser = parsers[ft]
	if not parser then
		return
	end
	local source = io.read_file(filename)
	self.dictionary[filename] = parser.parse(source)
end
---@param filename string
function M.RuleSets:remove(filename)
	self.dictionary[filename] = nil
end
---@param filename string
function M.RuleSets:contains(filename)
	return self.dictionary[filename]
end

---@type table<fs_event, function>
M.handle_fs = {
	["CREATED"] = function(file)
		if not M.RuleSets:contains(file) then
			M.RuleSets:insert(file)
		end
	end,
	["CHANGED"] = function(file)
		M.RuleSets:insert(file)
	end,
	["RENAMDED"] = function(file, newname) end,
	["REMOVED"] = function(file)
		M.RuleSets:remove(file)
	end,
}
---@param opts table | nil
M.setup = function(opts)
	-- TODO: stuff
	---@type fs_callback
	local callback = function(type, file, ...)
		M.handle_fs[type](file, ...)
	end

	io.poll_fs(path, callback)
end
return M
