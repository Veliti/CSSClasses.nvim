local null_ls = require("null-ls")
local agrigator = require("CSSClasses.agrigator")

local M = {}
M.logger = require("null-ls.logger")

---@type table<fs_event, function>

---@param root string
M.setup_null_ls = function(root)
	local completion_source = {
		method = null_ls.methods.COMPLETION,
		filetypes = { "html", "css" },
		generator = {
			async = true,
			---@param params NullLsParams
			fn = function(params, done)
				local line = params.content[params.row]
				local cursor = params.col
				local patterns = M.complition_patterns[params.filetype]

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

				local list = agrigator:get_complition_list()
				done({ list })
			end,
		},
	}
	if null_ls.is_registered(LSP_NAME) then
		null_ls.deregister(LSP_NAME)
	end
	null_ls.register({ name = LSP_NAME, sources = { completion_source } })
end
return M
