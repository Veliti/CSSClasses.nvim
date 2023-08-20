local agrigator = require("CSSClasses.agrigator")
local lsp = require("CSSClasses.null-ls")
local io = require("CSSClasses.io")
local parsers = require("CSSClasses.parsers")
local insertons = require("CSSClasses.insertions")

LSP_NAME = "CSSClasses"
AUGROUP_NAME = LSP_NAME .. "_setup"
AUGROUP = vim.api.nvim_create_augroup(AUGROUP_NAME, { clear = true })
local M = {}

---@param opts table | nil
M.setup = function(opts)
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = AUGROUP,
		pattern = insertons.get_supported_files(),
		once = true,
		callback = function(params)
			local root = io.get_root(params.file, { ".git", ".csproj" })
			if not root then
				lsp.logger:warn("couldnt find root defaulting to uv.cwd")
				root = assert(vim.loop.cwd(), "CWD DOESNT EXIST ")
			end
			lsp.logger:info(string.format("root: %s", root))

			agrigator:init(root)
			lsp.setup_null_ls(root)
			vim.api.nvim_clear_autocmds({ group = AUGROUP, event = { "FileType" } })
		end,
	})
end
return M
