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
		"Jaq",
		"qf",
		"git",
		"help",
		"man",
		"lspinfo",
		"spectre_panel",
		"lir",
		"oil",
		"DressingSelect",
		"tsplayground",
		"codecompanion",
		-- "vim",
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

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- 	pattern = { "*" },
-- 	callback = function()
-- 		local buftype = vim.bo.buftype
--
-- 		if buftype == "help" then
-- 			vim.cmd([[
-- 		    nnoremap <silent> <buffer> q :close<CR>
-- 		    nnoremap <silent> <buffer> <esc> :close<CR>
-- 		    set nobuflisted
-- 		  ]])
-- 		end
-- 	end,
-- })

-- autocmd to set wrap and spell in text filetypes
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

-- Lsp progress
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
			id = "LspProgress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

-- Cursor style
vim.api.nvim_create_autocmd({ "ColorScheme", "WinEnter" }, {
	pattern = "*",
	callback = function()
		require("utils.fns").cursor_style()
	end,
})

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
