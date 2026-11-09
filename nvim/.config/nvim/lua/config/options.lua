local fns = require("utils.fns")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable 24-bit RGB colors. Required by nvim-colorizer and most colorschemes.
vim.opt.termguicolors = true

vim.opt.winborder = "rounded"
vim.g.have_nerd_font = true
vim.opt.laststatus = 3 -- Don't show status lines everywhere
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 2 -- set number column width to 2 {default 4}
vim.opt.showtabline = 1
vim.opt.laststatus = 3
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.clipboard = ""
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.fillchars = {
	eob = " ",
	fold = " ",
	foldopen = "",
	foldsep = " ",
	foldclose = "",
}
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.updatetime = 200
vim.opt.swapfile = false
vim.opt.timeoutlen = 200
vim.opt.timeout = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false -- Enable listchars
vim.opt.listchars = {
	tab = "  ",
	trail = "·",
	leadmultispace = "·",
	lead = "·",
	space = " ",
}
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.statuscolumn = ""

-- Set title
vim.opt.title = true
