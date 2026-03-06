return {
	"lewis6991/gitsigns.nvim",
	-- enabled = false,
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(bufnr, _)
			local gitsigns = require("gitsigns")

			local function create_diff_tab(type)
				-- Create new tab
				vim.cmd("tab split")

				-- Set the variable for the current tabpage
				vim.t.is_difftab = true

				-- Set the tab title
				vim.opt_local.titlestring = " DiffTab"
				vim.opt_local.title = true

				-- Show the diff
				gitsigns.diffthis(type)
			end

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git change" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git change" })

			-- Actions
			-- visual mode
			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git stage hunk" })
			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git reset hunk" })
			-- normal mode
			map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "git stage/unstage hunk" })
			map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "git reset hunk" })
			map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "git Stage buffer" })
			map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "git Reset buffer" })
			map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "git preview hunk" })
			map("n", "<leader>gb", gitsigns.blame_line, { desc = "git blame line" })
			map("n", "<leader>gd", create_diff_tab, { desc = "git diff against index" })
			map("n", "<leader>gD", function()
				create_diff_tab("@")
				-- gitsigns.diffthis("@")
			end, { desc = "git Diff against last commit" })
			-- Toggles
			map("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Toggle git show blame line" })
			map("n", "<leader>gx", gitsigns.toggle_deleted, { desc = "Toggle git show Deleted" })
		end,
	},
}
