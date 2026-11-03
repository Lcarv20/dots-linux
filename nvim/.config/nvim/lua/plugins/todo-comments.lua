	return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = true },
	keys = {
		{
			"<leader>st",
			"<cmd>TodoTrouble<cr>",
			desc = "Todo",
		},
		{
			"<leader>sT",
			"<cmd>TodoTelescope<cr>",
			desc = "Todo (Telescope)",
		},
	},
}
