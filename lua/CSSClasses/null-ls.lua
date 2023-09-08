local null_ls = require("null-ls")
local agrigator = require("CSSClasses.agrigator")
local insertion = require("CSSClasses.insertion")

local M = {}
M.logger = require("null-ls.logger")

M.setup_null_ls = function()
	local completion_source = {
		method = null_ls.methods.COMPLETION,
		filetypes = { "html", "css" },
		generator = {
			---@param params NullLsParams
			fn = function(params)
				if insertion.is_matched(table.concat(params.content), params.col) then
					local list = agrigator:get_complition_list(params)
					return { list }
				end
			end,
		},
	}
	if null_ls.is_registered(LSP_NAME) then
		null_ls.deregister(LSP_NAME)
	end
	null_ls.register({ name = LSP_NAME, sources = { completion_source } })
end
return M
