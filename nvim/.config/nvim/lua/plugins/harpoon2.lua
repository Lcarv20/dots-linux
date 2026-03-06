return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local keys = {
			{
				"ma",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"mm",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list(), { border = require("utils.fns").get_border() })
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<leader>ma",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>mm",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list(), { border = require("utils.fns").get_border() })
				end,
				desc = "Harpoon Quick Menu",
			},
		}

		local harpoon = require("harpoon")

		harpoon:extend({
			UI_CREATE = function(cx)
				vim.keymap.set("n", "<C-v>", function()
					harpoon.ui:select_menu_item({ vsplit = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-x>", function()
					harpoon.ui:select_menu_item({ split = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-t>", function()
					harpoon.ui:select_menu_item({ tabedit = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-c>", function()
					harpoon.ui:close_menu()
				end, { buffer = cx.bufnr })
			end,
		})

		for i = 1, 5 do
			table.insert(keys, {
				"<C-" .. i .. ">",
				function()
					require("harpoon"):list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
