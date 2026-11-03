local fns = require("utils.fns")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- close with q for certain FileType
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = {
		"netrw",
		"qf",
		"git",
		"help",
		"man",
		"lspinfo",
		"oil",
		"codecompanion",
		"",
	},
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      nnoremap <silent> <buffer> <esc> :close<CR>
      set nobuflisted
    ]])
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- disable auto comment for XML & HTML
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "svelte", "html", "xml" },
	callback = function()
		vim.opt_local.formatoptions:remove({ "o", "r" }) -- Disable for HTML/XML
	end,
})

-- Make terminal buffers not show up in `ls` or `vim -p`
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "term://*",
	callback = function()
		vim.bo.noswapfile = true
		vim.bo.buftype = "nofile"
	end,
})

-- disable conceal for json
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Make lsp and hightlight work on .swiftinterface files, and disable diagnostics
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.swiftinterface",
	callback = function()
		vim.bo.filetype = "swift"

		vim.diagnostic.enable(false, {
			bufnr = 0,
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "codecompanion" },
	callback = function()
		vim.opt_local.conceallevel = 3
		vim.opt_local.concealcursor = "n"
	end,
})

-- Lsp progress is handled by the built-in Progress event + Snacks notifier.
-- Use vim.lsp.status() in the statusline for progress display.

-- Update the terminal title when the buffer changes
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function()
		local project_name = fns.find_project_root() or "Neovim"
		vim.opt.titlestring = string.format(" %s |  %%t", project_name)
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = "*",
})
