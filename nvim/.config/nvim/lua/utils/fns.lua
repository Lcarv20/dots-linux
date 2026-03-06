local M = {}

M.cursor_style = function()
	-- create highlights for the different modes
	local colors = require("utils.colors").colors()

	vim.api.nvim_set_hl(0, "NCursor", { bg = colors.blue })
	vim.api.nvim_set_hl(0, "ICursor", { bg = colors.green })
	vim.api.nvim_set_hl(0, "VCursor", { bg = colors.yellow })
	vim.api.nvim_set_hl(0, "RCursor", { bg = colors.red })
	vim.api.nvim_set_hl(0, "ComCursor", { bg = colors.cyan })
	vim.api.nvim_set_hl(0, "NoiceCursor", { bg = colors.orange })
end

-- Add icons to diagnostics, and configure the diagnotics message
M.diagnostics_config = function(border)
	if vim.g.have_nerd_font then
		local signs = { ERROR = " ", WARN = " ", INFO = " ", HINT = "" }
		local diagnostic_signs = {}
		for type, icon in pairs(signs) do
			diagnostic_signs[vim.diagnostic.severity[type]] = icon
		end
		-- vim.diagnostic.config({ signs = { text = diagnostic_signs } })

		local popup_signs = {
			{ name = "diagnosticsignerror", text = " " },
			{ name = "diagnosticsignwarn", text = " " },
			{ name = "diagnosticsigninfo", text = " " },
			{ name = "diagnosticsignhint", text = "" },
		}

		for _, sign in ipairs(popup_signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
		end

		local default_diagnostic_config = {
			signs = {
				active = popup_signs,
				text = diagnostic_signs,
			},
			virtual_text = {
				prefix = "⏺",
			},
			virtual_lines = false,
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focusable = true,
				max_width = 80,
				max_height = 20,
				style = "minimal",
				border = M.get_border(border),
				source = "always",
				wrap = true,
				header = "",
				prefix = function(diagnostic, i, total)
					local function get_i()
						if total > 1 then
							return " " .. i .. ")"
						end
						return ""
					end

					local get_lnum_range = function()
						if diagnostic.lnum ~= diagnostic.end_lnum then
							return diagnostic.lnum + 1 .. ":" .. diagnostic.end_lnum + 1
						end
						return diagnostic.lnum + 1
					end

					local get_col_range = function()
						if diagnostic.col ~= diagnostic.end_col then
							return diagnostic.col .. ":" .. diagnostic.end_col
						end
						return diagnostic.col
					end

					local sign = popup_signs[diagnostic.severity].text
					local hl = popup_signs[diagnostic.severity].name

					return string.format("%s%s [%s,%s] ", sign, get_i(), get_lnum_range(), get_col_range()), hl
				end,
			},
		}

		vim.diagnostic.config(default_diagnostic_config)

		for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config() or {}, "signs", "values") or {}) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
		end
	end
end

-- Configure the LSP hover and signature help popups borders
M.lsp_popover_borders = function(border)
	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
	---@diagnostic disable-next-line: duplicate-set-field
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = M.get_border(border)
		return orig_util_open_floating_preview(contents, syntax, opts, ...)
	end
end

--- Create a temporary notification using mini.notify.
-- This function displays a notification message with a specified level and automatically removes it after a delay.
-- @param msg The notification message to display.
-- @param level "INFO" | "WARN" | "ERROR" | "DEBUG": The level of the notification
-- @param delay number: (optional) The delay in milliseconds before removing the notification. Defaults to 2500.
---@type fun(msg: string, level: "'INFO'" | "'WARN'" | "'ERROR'" | "'DEBUG'", delay?: number)
M.create_notification = function(msg, level, delay)
	delay = delay or 2500 -- Use the provided delay or default to 2500

	local hl = level == "INFO" and "DiagnosticInfo"
		or level == "WARN" and "DiagnosticWarn"
		or level == "ERROR" and "DiagnosticError"
		or "DiagnosticHint"

	local id = require("mini.notify").add(msg, level, hl)
	vim.defer_fn(function()
		require("mini.notify").remove(id)
	end, delay)
end

M.get_border = function(border)
	return border or vim.g.neovide == true and "solid" or "rounded"
end

-- Find the project root by searching for a marker file like .git
M.find_project_root = function()
	local dir = vim.fn.getcwd()
	local path_to_search = vim.fs.normalize(dir)
	local marker_files = vim.fs.find(
		{ ".git", "package.json", "go.mod" },
		{ path = path_to_search, upward = true, stop = vim.env.HOME }
	)
	if marker_files and #marker_files > 0 then
		local root_dir = vim.fs.dirname(marker_files[1])
		local project_name = vim.fs.basename(root_dir)
		return project_name
	end
	return nil
end

return M
