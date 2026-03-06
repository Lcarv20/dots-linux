-- INFO: In the future, for GUI apps, configure this extension properly
return {
	"wojciech-kulik/xcodebuild.nvim",
  enabled = false,
	ft = { "swift" },
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"stevearc/oil.nvim", -- (optional) to manage project files
		"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
	},
	config = function()
		require("xcodebuild").setup({
			-- put some options here or leave it empty to use default settings
		})
	end,
}
