local agrigator = require("CSSClasses.agrigator")
local lsp = require("CSSClasses.null-ls")
local io = require("CSSClasses.io")
local parsers = require("CSSClasses.parsers")
local insertons = require("CSSClasses.insertions")

LSP_NAME = "CSSClasses"
AUGROUP = vim.api.nvim_create_augroup(LSP_NAME, { clear = true })
local M = {}
print("pre source")

---@param opts table | nil
M.setup = function(opts)
	print("setup")
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		group = AUGROUP,
		pattern = vim.tbl_extend("keep", parsers.get_supported_files(), insertons.get_supported_files()),
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
		end,
	})
end
print("post source")
return M
