return {
	{
		"Lcarv20/gruber-darker.nvim",
		-- enabled = false,
		config = function()
			require("gruber-darker").setup({
				-- OPTIONAL
				transparent = true, -- removes the background
				underline = true, -- disables underline fonts
				bold = true, -- disables bold fonts
			})
			-- vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Pmenu", force = true })
			-- vim.cmd.colorscheme("gruber-darker")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			-- vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true, -- disables setting the background color.
				float = {
					transparent = true, -- enable transparent floating windows
					solid = true, -- use solid styling for floating windows, see |winborder|
				},
			})
			-- vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"topazape/oldtale.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("oldtale")
		end,
	},
	{
		"killitar/obscure.nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- vim.cmd.colorscheme("obscure")
		end,
	},
	{
		"khoido2003/classic_monokai.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- Theme style: choose "dark" for classic Monokai or "light" for light mode
			style = "dark", -- "dark" | "light"

			-- Background style for dark mode: "default" (classic), "dark" (darker), "transparent", or a hex color (e.g. "#1a1a1a")
			dark_style_background = "dark", -- "default" | "dark" | "transparent" | "#RRGGBB"
			-- Background style for light mode: "default" (classic), "dark" (darker), "transparent", or a hex color
			light_style_background = "default", -- "default" | "dark" | "transparent" | "#RRGGBB"

			hl_styles = {
				-- Enable/disable italic for comments
				comments = { italic = true }, -- true | false
				-- Enable/disable italic for keywords
				keywords = { italic = true }, -- true | false
				-- Enable/disable italic for functions
				functions = { italic = true }, -- true | false
				-- Enable/disable italic for variables
				variables = { italic = false }, -- true | false
				-- Background style for floating windows: "default", "dark", "transparent", or hex color
				floats = "dark", -- "default" | "dark" | "transparent" | "#RRGGBB"
				-- Background style for sidebars (nvim-tree, etc.): "default", "dark", "transparent", or hex color
				sidebars = "default", -- "default" | "dark" | "transparent" | "#RRGGBB"
			},

			-- Automatically enable plugin integrations (set to false to manually control plugins)
			auto_enable_plugins = true, -- true | false

			-- Enable colored headers in markdown files
			color_headers = true, -- true | false

			-- Dim inactive windows for better focus
			dim_inactive = false, -- true | false

			-- Use bold font in lualine section headers
			lualine_bold = true, -- true | false
			-- Lualine background style: "default" (follows theme), "dark", or "light"
			lualine_style = "default", -- "default" | "dark" | "light"

			-- Highlight '#' in markdown headers
			markdown_header_marks = false, -- true | false

			-- Set terminal colors: true to enable, false to disable, or provide a table/function for custom colors
			terminal_colors = true, -- true | false | table | function

			-- Enable theme caching for better performance
			cache = true, -- true | false
		},
		config = function(_, opts)
			require("classic_monokai").setup(opts)
			-- vim.cmd.colorscheme("classic-monokai")
		end,
	},
	{
		"Lcarv20/nvim-noirbuddy",
		lazy = false,
		priority = 1000,
		enabled = false,
		dependencies = {
			{ "tjdevries/colorbuddy.nvim" },
		},
		opts = {
			colors = {
				primary = "#e89b6c",
				background = "#3e3e3e",
			},
		},
		name = "lcarv-noir",
		config = function()
			-- vim.cmd.colorscheme("lcarv-noir")
		end,
	},
	{
		"Lcarv20/sugoi.nvim",
		-- dir = "~/Developer/nvim-plugins/sugoi.nvim",
		dependencies = { "tjdevries/colorbuddy.nvim" },
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
		config = function(_, opts)
			require("sugoi").setup(opts)
			vim.cmd.colorscheme("sugoi") -- applies when you want
		end,
	},
	-- Using Lazy
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "darker",
			})
			-- Enable theme
			-- require("onedark").load()
		end,
	},
	{
		"jesseleite/nvim-noirbuddy",
		enabled = false,
		dependencies = {
			{ "tjdevries/colorbuddy.nvim" },
		},
		lazy = false,
		priority = 1000,
		opts = {
			-- preset = "miami-nights",
			styles = {
				italic = true,
				bold = true,
			},

			colors = {
				-- backgrounds
				background = "#181818", -- oklch(14.1% 0.005 285.823) - darker, stone-like
				diff_add = "#a6e3a1", -- muted green for additions, adjusted for darker bg
				diff_delete = "#f38ba8", -- muted red for deletions, adjusted for darker bg
				diff_change = "#b4befe", -- muted blue for changes, adjusted for darker bg
				-- semantic/diagnostic colors (retained warm tones)
				diagnostic_error = "#d66b6c", -- red for errors
				diagnostic_warning = "#e89b6c", -- orange for warnings
				diagnostic_info = "#7a9fc6", -- muted blue for info
				diagnostic_hint = "#a9b87f", -- muted olive for hints
				-- foreground / text
				foreground = "#eae6e1", -- slightly brighter off-white for better contrast
				comment = "#929094", -- muted grey for comments
				-- main accent colors (warm tones, slightly richer against darker background)
				primary = "#e89b6c", -- warm terracotta
				secondary = "#d66b6c", -- muted coral/rose
				-- grayscale palette (adjusted to lean warmer and darker overall)
				noir_0 = "#eae6e1", -- lightest, near foreground
				noir_1 = "#dbd6d2",
				noir_2 = "#c9c5c1",
				noir_3 = "#b7b3af",
				noir_4 = "#a5a19d",
				noir_5 = "#938f8b",
				noir_6 = "#817d79",
				noir_7 = "#6f6b67", -- near comment color
				noir_8 = "#5c5854",
				noir_9 = "#323136", -- darkest, near bg_float
			},
		},
	},

	--- Utilities ---
	{ "typicode/bg.nvim", lazy = false },
	-- TODO: Use the colors from the "utils.colors" table
	{
		"f-person/auto-dark-mode.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = {
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd.colorscheme("sugoi")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd.colorscheme("sugoi")
			end,
			update_interval = 3000,
			fallback = "dark",
		},
	},
}
