local null_ls = require("null-ls")
local agrigator = require("CSSClasses.agrigator")
local insertions = require("CSSClasses.insertions")

local M = {}
M.logger = require("null-ls.logger")

M.setup_null_ls = function()
	local completion_source = {
		method = null_ls.methods.COMPLETION,
		filetypes = insertions.get_supported_files(),
		generator = {
			---@param params NullLsParams
			fn = function(params)
				local line = params.content[params.row]
				local cursor = params.col

				if insertions[params.filetype] and insertions[params.filetype](line, cursor) then
					local list = agrigator:get_complition_list()
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
