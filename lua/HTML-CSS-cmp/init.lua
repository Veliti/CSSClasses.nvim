TS_utils = require("vim.treesitter.languagetree")

M = {}

M._cssdir = {}

M.setup = function(opts)
	table.insert(M._cssdir, vim.loop.cwd())
	M._cssFiles = vim.fs.find(function(name, path)
		return name:match(".css$")
	end, { type = "file", limit = math.huge })
end

return M
