return {
	"sindrets/diffview.nvim",
	keys = {
		{
			"<leader>gv",
			function()
				vim.cmd("DiffviewOpen")
			end,
			desc = "DiffView",
		},
	},
	config = function()
		-- Create a keymap (q) that when on filetype "DiffviewFiles" runs the cmd "DiffviewClose"
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "DiffviewFiles",
			callback = function()
				vim.keymap.set("n", "q", "<cmd>DiffviewClose<CR>", { buffer = true })
			end,
		})
	end,
}
