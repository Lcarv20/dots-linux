return {
	"saghen/blink.cmp",
	-- enabled = false,
	dependencies = {
		"rafamadriz/friendly-snippets",
		"Kaiser-Yang/blink-cmp-avante",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
		},
	},
	version = "*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "enter",
			["<Tab>"] = {
				function(cmp)
					-- if vim.b[vim.api.nvim_get_current_buf()].nes_state then
					-- 	cmp.hide()
					-- 	return (
					-- 		require("copilot-lsp.nes").apply_pending_nes()
					-- 		and require("copilot-lsp.nes").walk_cursor_end_edit()
					-- 	)
					-- end
					if cmp.snippet_active() then
						return cmp.accept()
					else
						-- return cmp.select_and_accept()
						return nil
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		cmdline = {
			keymap = {
				preset = "inherit",
				-- ["<Tab>"] = { "show_and_insert", "select_next" },
				-- ["<S-Tab>"] = { "show_and_insert", "select_prev" },

				["<C-space>"] = { "show", "fallback" },

				["<C-n>"] = { "show_and_insert", "select_next", "fallback" },
				["<C-p>"] = { "show_and_insert", "select_prev", "fallback" },
				["<Right>"] = { "select_next", "fallback" },
				["<Left>"] = { "select_prev", "fallback" },

				["<C-y>"] = { "select_and_accept" },
				["<C-e>"] = { "cancel" },
			},
		},
		completion = {
			menu = {
				-- auto_show = true,
				auto_show = function(ctx)
					-- if ctx.mode == "cmdline" then
					-- end
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

			-- Display a preview of the selected item on the current line
			ghost_text = { enabled = true },
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
