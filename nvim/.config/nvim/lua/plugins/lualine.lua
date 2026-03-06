return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- enabled = false,
		lazy = true,
		event = "VeryLazy",
		config = function()
			local themes = require("utils.configs.lualine_configs")
			-- require("lualine").setup(themes.lcarv_evil())
			require("lualine").setup(themes.gemini())
			-- require("lualine").setup(themes.cosmicink())

			-- -- Create an autocommand group for our lualine refresh commands
			-- local lualine_refresh_group = vim.api.nvim_create_augroup("LualineRefresh", { clear = true })
			--
			-- -- Autocommand to refresh lualine when a colorscheme is loaded
			-- vim.api.nvim_create_autocmd("ColorScheme", {
			-- 	group = lualine_refresh_group,
			-- 	pattern = "*", -- Run for all colorschemes
			-- 	desc = "Refresh lualine on colorscheme change",
			-- 	callback = function()
			-- 		-- local themes = require("utils.configs.lualine_configs")
			-- 		require("lualine").setup(themes.lcarv_shrugged())
			-- 		require("tabby").setup(require("utils.configs.tabby_configs").default_config)
			-- 	end,
			-- })
			--
			-- -- Autocommand to refresh lualine when 'background' option is set
			-- vim.api.nvim_create_autocmd("OptionSet", {
			-- 	group = lualine_refresh_group,
			-- 	pattern = "background", -- Only run when the 'background' option is set
			-- 	desc = "Refresh lualine on background change",
			-- 	callback = function()
			-- 		-- local themes = require("utils.configs.lualine_configs")
			-- 		require("lualine").setup(themes.lcarv_shrugged())
			-- 		require("tabby").setup(require("utils.configs.tabby_configs").default_config)
			-- 	end,
			-- })

      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
		end,
	},
}
