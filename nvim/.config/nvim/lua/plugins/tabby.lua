return {
	"nanozuki/tabby.nvim",
	enabled = true,
	lazy = true,
	event = { "TabEnter", "TabNew", "TabClosed" },
	keys = {
		{ "<leader>t", desc = "tabs" },
		{ "<leader>tn", desc = "new" },
		{ "<leader>tc", desc = "close" },
		{ "<leader>tr", desc = "rename" },
	},
	config = function()
		-- Keymaps
		vim.keymap.set("n", "<leader>t", "", { desc = "tabs" })
		vim.keymap.set("n", "<leader>tn", ":tabnew<cr>", { desc = "new" })
		vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { desc = "close" })
		vim.keymap.set("n", "<leader>tr", function()
			---@type snacks.Config
			Snacks.input({
				prompt = "new tab name: ",
			}, function(new_name)
				if new_name and new_name ~= "" then
					vim.cmd("Tabby rename_tab " .. new_name)
				else
					vim.cmd("Tabby rename_tab")
				end
			end)
		end, { desc = "rename" })

		-- Options
		vim.o.showtabline = 1

		local colors = require("utils.colors").colors()

		vim.api.nvim_set_hl(0, "TabLineFill", { link = "Normal" })
		require("tabby").setup({
			line = function(line)
				return {
					{
						line.sep("🭪", { bg = colors.green }, { fg = colors.fg, bg = colors.bg }),
						{ "  ", hl = { fg = colors.green, bg = colors.bg, style = "bold" } },
						line.sep(" ", { bg = colors.bg }, { fg = colors.bg, bg = "NONE" }),
					},
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and { fg = colors.orange, bg = colors.bg, style = "bold" }
							or { fg = colors.subtle_gray, bg = colors.bg }
						return {
							line.sep(" ", hl, { fg = colors.bg, bg = "NONE", style = "bold" }),
							tab.is_current() and " " or "",
							tab.number(),
							tab.name(),
							-- tab.close_btn(""),
							line.sep(" ", hl, { fg = colors.fg, bg = colors.bg, style = "bold" }),
							hl = hl,
              margin = " ",
							line.sep("", hl, { fg = colors.bg, bg = "NONE", style = "bold" }),
						}
					end),
					line.spacer(),
				}
			end,
		})
	end,
}
