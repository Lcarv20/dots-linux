	return {
	"saghen/blink.cmp",
	version = "*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "enter",
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<Tab>"] = {
				function(cmp)
					if vim.snippet.active({ direction = 1 }) then
						return cmp.accept()
					else
						return nil
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		snippets = {
			preset = "default", -- Use native vim.snippet
		},
		completion = {
			menu = {
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?", ":%" }, vim.fn.getcmdtype())
				end,
				border = "none",
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				window = { border = "rounded" },
			},
			ghost_text = { enabled = true },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
