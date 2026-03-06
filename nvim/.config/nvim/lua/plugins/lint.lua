local M = {}

M.enabled = true

M.toggle_linter = function()
	M.enabled = not M.enabled

	if M.enabled then
		-- Enable linting by creating the autocommand group
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				if vim.opt_local.modifiable:get() then
					require("lint").try_lint()
				end
			end,
		})

		-- Trigger linting for the current buffer
		if vim.opt_local.modifiable:get() then
			require("lint").try_lint()
		end
	else
		-- Disable linting by clearing the autocommand group
		vim.api.nvim_clear_autocmds({ group = "lint" })

		-- Clear existing linting diagnostics in all buffers
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			vim.diagnostic.reset(nil, buf)
		end
	end

	-- Notify
	local msg = "Linter " .. (M.enabled and "enabled" or "disabled")
	Snacks.notify(msg)
end

M.config = {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			-- markdown = { "markdownlint" },
			swift = { "swiftlint" },
		}

		-- Set up a keybinding to toggle the linter
		vim.keymap.set("n", "<leader>cx", M.toggle_linter, { desc = "Toggle linter" })

		-- Create the default autocommands for linting
		if M.enabled then
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					if vim.opt_local.modifiable:get() then
						lint.try_lint()
					end
				end,
			})
		end
	end,
}

return M.config
