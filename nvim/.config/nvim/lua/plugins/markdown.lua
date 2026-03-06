return {
	"OXY2DEV/markview.nvim",
	enabled = false,
	lazy = false,
	ft = { "markdown", "codecompanion", "Avante" },
	opts = function(_, opts)
		local presets = require("markview.presets")
		opts.markdown = {
			headings = presets.headings.glow,
		}
		opts.code_blocks = {
			style = "fancy", -- or "fancy" for more styling
		}

		opts.preview = {
			filetypes = { "markdown", "codecompanion", "Avante" },
			-- ignore_buftypes = { "nofile" },
			ignore_buftypes = { "nofile" },
			modes = { "n", "i", "c", ":", "no", "io", "co" },
			hybrid_modes = { "i", "n" },
			-- ignore_nodes = { "fenced_code_block" },
		}
	end,
}
