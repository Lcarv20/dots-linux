return {
	dir = "~/Developer/nvim-plugins/sugoi-line.nvim",
	lazy = false,
	config = function()
		require("sugoi-line").setup()
	end,
}
