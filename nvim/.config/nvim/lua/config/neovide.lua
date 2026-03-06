local map = vim.keymap.set
-- local ignore = { desc = "which_key_ignore" }
local opts = { silent = true, noremap = true }

-- font
vim.o.guifont = "JetBrainsMono Nerd Font:h14"
vim.opt.linespace = 12

-- auto theme
vim.g.neovide_theme = "auto"

vim.g.neovide_window_blurred = true
vim.g.neovide_show_border = true

vim.g.neovide_title_background_color =
	string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

vim.g.neovide_title_text_color = "pink"

vim.g.neovide_floating_blur_amount_x = 5.0
vim.g.neovide_floating_blur_amount_y = 5.0

vim.g.neovide_floating_corner_radius = 0.0

vim.g.neovide_opacity = 0.9
vim.g.neovide_normal_opacity = 1

-- copy/paste
map({ "v", "t" }, "<C-c>", '"+y', opts)
map({ "n", "t" }, "<C-v>", '"+P', opts)
map({ "v", "t" }, "<C-v>", '"+P', opts)
map({ "c", "t" }, "<C-v>", "<C-R>+", opts)
map({ "i", "t" }, "<C-v>", "<C-R>+", opts)

-- delete aka macos
map({ "i", "c", "t" }, "<C-BS>", "<C-u>", opts) -- Meta + Backspace
map({ "i", "t", "c" }, "<A-BS>", "<C-w>", opts) -- Option + Backspace

-- Move line down/up with Alt+j/k
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)

map("x", "<A-j>", ":m '>+1<CR>gv-gv", opts)
map("x", "<A-k>", ":m '<-2<CR>gv-gv", opts)
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

local fns = require("utils.fns")

fns.diagnostics_config("solid")
fns.lsp_popover_borders("solid")

-- disabling animations on buffer switch
-- https://github.com/neovide/neovide/issues/1771
vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		vim.g.neovide_scroll_animation_length = 0
		vim.g.neovide_cursor_animation_length = 0
	end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.fn.timer_start(70, function()
			vim.g.neovide_scroll_animation_length = 0.3
			vim.g.neovide_cursor_animation_length = 0.08
		end)
	end,
})
