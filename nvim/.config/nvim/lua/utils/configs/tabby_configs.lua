local M = {}

M.default_config = {
	line = function(line)
		local colors = require("utils.colors").colors()
		vim.api.nvim_set_hl(0, "TabLineFill", { link = "Normal" })

		return {
			{
				line.sep("🭪", { bg = colors.mauve }, { fg = colors.fg, bg = colors.bg }),
				{ "   ", hl = { fg = colors.green, bg = colors.bg, style = "bold" } },
			},
			line.tabs().foreach(function(tab)
				local hl = tab.is_current() and { fg = colors.orange, bg = colors.bg, style = "bold" }
					or { fg = colors.subtle_gray, bg = colors.bg }
				return {
					line.sep(" ", hl, { fg = colors.fg, bg = colors.bg, style = "bold" }),
					tab.is_current() and " " or "",
					tab.number(),
					tab.name(),
					-- tab.close_btn(""),
					line.sep(" ", hl, { fg = colors.fg, bg = colors.bg, style = "bold" }),
					hl = hl,
					margin = " ",
				}
			end),
			line.spacer(),
		}
	end,
}
return M
