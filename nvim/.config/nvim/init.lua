require("config.options")
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
require("config.highlight")
if vim.g.neovide then
	require("config.neovide")
end
