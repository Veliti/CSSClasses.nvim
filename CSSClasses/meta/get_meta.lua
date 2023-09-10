local links = {
	"https://raw.githubusercontent.com/folke/neodev.nvim/main/types/nightly/uv.lua",
	"https://raw.githubusercontent.com/neovim/neovim/master/runtime/lua/vim/lsp/_meta/protocol.lua",
}

for _, link in ipairs(links) do
	local fname = link:match("[^/]+$")
	os.execute(string.format("curl %s -o %s", link, fname))
end
