local logo = [[
 ✦   ████ ✧     ✦           ☆        ✦     ☆        
  ☆ ░░███     ✧   ☆  ✧    ✦  ✧            ✧     ✧ ☆ 
     ░███  ☆██████  ██████  ████████☆ █████ █████  ✧
✦  ☆ ░███  ███░░███░░░░░███░░███░░███░░███ ░░███ ✧  
     ░███ ░███ ░░░  ███████ ░███ ░░░  ░███  ░███    
   ✧ ░███ ░███  ███░██░░███ ░███  ✦   ░░███ ███  ✦  
     █████░░██████░░█████████████   ✧  ░░█████  ☆   
☆   ░░░░░✦ ░░░░░░☆ ░░░░░░░░░░░░░ ✧     ✦░░░░░     ✦ 
   ✧    ✧    ☆      ✧  ✦       ☆       ☆  ✧   ✦     
]]

local global_border = require("utils.fns").get_border()
return {
	"folke/snacks.nvim",
	enabled = true,
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		image = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = logo,
				-- keys = default_keys,
			},
		},
		explorer = {
			enabled = true,
		},
		indent = {
			indent = {
				priority = 1,
				enabled = true, -- enable indent guides
				char = "│",
				only_scope = true, -- only show indent guides of the scope
				only_current = false, -- only show indent guides in the current window
				hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
				-- can be a list of hl groups to cycle through
				-- hl = {
				--     "SnacksIndent1",
				--     "SnacksIndent2",
				--     "SnacksIndent3",
				--     "SnacksIndent4",
				--     "SnacksIndent5",
				--     "SnacksIndent6",
				--     "SnacksIndent7",
				--     "SnacksIndent8",
				-- },
			},
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				style = "out",
				easing = "linear",
				duration = {
					step = 20, -- ms per step
					total = 500, -- maximum duration
				},
			},
			---@class snacks.indent.Scope.Config: snacks.scope.Config
			scope = {
				enabled = true, -- enable highlighting the current scope
				priority = 200,
				char = "│",
				underline = false, -- underline the start of the scope
				only_current = false, -- only show scope in the current window
				hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
			},
			chunk = {
				-- when enabled, scopes will be rendered as chunks, except for the
				-- top-level scope which will be rendered as a scope.
				enabled = false,
				-- only show chunk scopes in the current window
				only_current = false,
				priority = 200,
				hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
				char = {
					corner_top = "┌",
					corner_bottom = "└",
					-- corner_top = "╭",
					-- corner_bottom = "╰",
					horizontal = "─",
					vertical = "│",
					arrow = ">",
				},
			},
			-- filter for buffers to enable indent guides
			filter = function(buf)
				return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
			end,
		},
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
			border = "none",
			filter = function(notif)
				if notif.title and notif.title:find("pyright") then
					return false
				end
				return true
			end,
		},
		picker = {
			enabled = true,
			layouts = {
				vscode = {
					preview = "main",
					layout = {
						backdrop = false,
						row = 1,
						width = 0.4,
						min_width = 80,
						height = 0.4,
						border = "none",
						box = "vertical",
						{
							win = "input",
							height = 1,
							border = global_border,
							title = "{title} {live} {flags}",
							title_pos = "center",
						},
						{ win = "list", border = global_border },
						{ win = "preview", title = "{preview}", border = global_border },
					},
				},
			},
			sources = {
				files = {
					hidden = true,
					exclude = {
						".DS_Store",
						".git",
						"node_modules",
					},
				},
				explorer = {
					hidden = true,
					ignored = true,
					exclude = {
						".DS_Store",
						".git",
						"node_modules",
					},
				},
			},
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		zen = {
			toggles = {
				dim = false,
				git_signs = true,
			},
		},
		styles = {
			notification = {
				-- wo = { wrap = true }, -- Wrap notifications
			},
		},
	},
	-- init = function()
	-- 	vim.keymap.set("n", "<leader>s", "", { desc = "Search" })
	-- 	vim.keymap.set("n", "<leader>b", "", { desc = "Buffers" })
	-- end,

	keys = {
		-- Top Pickers & Explorer
		{
			"<leader>fs",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<D-b>",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		-- find
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<D-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		-- git
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		-- Grep
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word",
			mode = { "n", "x" },
		},
		-- search
		{
			'<leader>s"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>cd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>cD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>si",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Search for Plugin Spec",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>uC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
		},
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"<leader>cs",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>cS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		-- Other
		{
			"<leader>uz",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>bz",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
		{
			"<leader>bn",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>bs",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			-- NOTE: ]]/[[ are owned by treesitter-textobjects (class navigation).
			-- Words jump moved to ]w/[w to avoid shadowing.
			"]w",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[w",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},
	init = function()
		vim.ui.select = require("snacks.picker").select
		vim.ui.input = require("snacks").input

		vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Comment" })

		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				Snacks.toggle.option("list", { name = "󱁐 List (Visible Whitespace)" }):map("<leader>ux")
				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
				local snacks = require("snacks")

				snacks.toggle
					.new({
						name = "LSP Virtual Text/Lines",
						get = function()
							local config = vim.diagnostic.config() or {}
							local vt = config.virtual_text
							return vt == true or (type(vt) == "table" and vt ~= nil)
						end,
						set = function(state)
							if state then
								vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
							else
								vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
							end
						end,
					})
					:map("<leader>l")

				local markview_on = false
				snacks.toggle
					.new({
						name = "Markview",
						get = function()
							return markview_on
						end,
						set = function(state)
							markview_on = state
							if state then
								vim.cmd("Markview Enable")
							else
								vim.cmd("Markview Disable")
							end
						end,
					})
					:map("<leader>um")
			end,
		})
	end,
}
