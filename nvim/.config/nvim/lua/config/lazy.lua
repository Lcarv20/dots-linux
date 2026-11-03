local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- import/override with your plugins
		{ import = "plugins" },
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true, -- default: true
		notify = true, -- get a notification when changes are found
	},
	checker = {
		enabled = true, -- check for plugin updates periodically
		notify = true, -- notify on update
	}, -- automatically check for plugin updates
	ui = {
		border = "double",
	},
	install = { colorscheme = { "sugoi", "default" } },
})
