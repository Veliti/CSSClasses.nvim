-- LSP_NAME = "CSSClasses"
-- AUGROUP = vim.api.nvim_create_augroup(LSP_NAME, { clear = true })
-- local M = {}
--
-- ---@param opts table | nil
-- M.setup = function(opts)
-- 	opts = opts or {}
--
-- 	vim.api.nvim_create_autocmd({ "FileType" }, {
-- 		group = AUGROUP,
-- 		pattern = { "html", "css" },
-- 		once = true,
-- 		callback = function(params)
-- 			local root = require("null-ls.utils").get_root()
--
-- 			agrigator:init(root)
-- 			lsp.setup_null_ls()
-- 			vim.api.nvim_clear_autocmds({ group = AUGROUP, event = { "FileType" } })
-- 		end,
-- 	})
-- end
local M = {}
M.setup = function(ots)
	-- not impl
end
return M
