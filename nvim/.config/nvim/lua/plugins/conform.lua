return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		notify_on_error = true,
		format_on_save = false,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			javascript = { "biome", "biome-organize-imports" },
			javascriptreact = { "biome", "biome-organize-imports" },
			typescript = { "biome", "biome-organize-imports" },
			typescriptreact = { "biome", "biome-organize-imports" },
      astro = { "prettier", stop_after_first = true },
		},
	},
}

-- return {
-- 	"stevearc/conform.nvim",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	keys = {
-- 		{
-- 			"<leader>cf",
-- 			function()
-- 				require("conform").format({ async = true, lsp_format = "fallback" })
-- 			end,
-- 			mode = { "n", "v" },
-- 			desc = "Format buffer",
-- 		},
-- 	},
-- 	config = function()
-- 		require("conform").setup({
-- 			formatters_by_ft = {
-- 				lua = { "stylua" },
-- 				rust = { "rustfmt" },
-- 				python = { "isort", "black" },
-- 				html = { "prettierd" },
-- 				astro = { "prettierd" },
-- 				javascript = { "prettierd" },
-- 				typescript = { "prettierd" },
-- 				javascriptreact = { "prettierd" },
-- 				typescriptreact = { "prettierd" },
-- 				svelte = { "prettierd" },
-- 				css = { "prettierd" },
-- 				markdown = { "prettierd" },
-- 				graphql = { "prettierd" },
-- 				json = { "jq" },
-- 				yaml = { "yq" },
-- 			},
-- 			-- formatters = {
-- 			-- 	prettierd = {
-- 			-- 		args = function(self, ctx)
-- 			-- 			if vim.endswith(ctx.filename, ".astro") then
-- 			-- 				return {
-- 			-- 					"--stdin-filepath",
-- 			-- 					"$FILENAME",
-- 			-- 					"--plugin",
-- 			-- 					"prettier-plugin-astro",
-- 			-- 				}
-- 			-- 			end
-- 			-- 			return { "--stdin-filepath", "$FILENAME" }
-- 			-- 		end,
-- 			-- 	},
-- 			-- },
-- 			format_on_save = {
-- 				timeout_ms = 500,
-- 			},
-- 		})
-- 	end,
-- }
