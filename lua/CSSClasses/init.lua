local agrigator = require("CSSClasses.agrigator")
local lsp = require("CSSClasses.null-ls")
local io = require("CSSClasses.io")
local parsers = require("CSSClasses.parsers")
local insertons = require("CSSClasses.insertions")

LSP_NAME = "CSSClasses"
AUGROUP = vim.api.nvim_create_augroup(LSP_NAME, { clear = true })
local M = {}

---@param opts table | nil
M.setup = function(opts)
	opts = opts or {}

	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = AUGROUP,
		pattern = insertons.get_supported_files(),
		once = true,
		callback = function(params)
			local root = require("null-ls.utils").get_root()

			agrigator:init(root)
			lsp.setup_null_ls()
			vim.api.nvim_clear_autocmds({ group = AUGROUP, event = { "FileType" } })
		end,
	})
end
return M
