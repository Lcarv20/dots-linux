return {
	"OXY2DEV/markview.nvim",
	lazy = true,
	cmd = { "Markview" },
	ft = { "markdown", "codecompanion", "Avante" },
	opts = function(_, opts)
		local presets = require("markview.presets")
		opts.markdown = {
			headings = presets.headings.glow,
		}
		opts.code_blocks = {
			style = "fancy",
		}

		opts.preview = {
			enable = false,
			filetypes = { "markdown", "codecompanion", "Avante" },
			ignore_buftypes = { "nofile" },
			modes = { "n", "i", "c", ":", "no", "io", "co" },
			hybrid_modes = { "i", "n" },
		}
	end,
}
