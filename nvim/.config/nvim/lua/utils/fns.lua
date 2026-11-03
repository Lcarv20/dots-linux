local M = {}

-- Add icons to diagnostics, and configure the diagnotics message
M.diagnostics_config = function(border)
	if vim.g.have_nerd_font then
		local signs = { ERROR = " ", WARN = " ", INFO = " ", HINT = "" }
		local diagnostic_signs = {}
		for type, icon in pairs(signs) do
			diagnostic_signs[vim.diagnostic.severity[type]] = icon
		end

		local popup_signs = {
			{ name = "DiagnosticSignError", text = " " },
			{ name = "DiagnosticSignWarn", text = " " },
			{ name = "DiagnosticSignInfo", text = " " },
			{ name = "DiagnosticSignHint", text = "" },
		}

		vim.diagnostic.config({
			signs = { text = diagnostic_signs },
			virtual_text = {
				prefix = "⏺",
			},
			virtual_lines = false,
			update_in_insert = false,
			underline = { severity = { min = vim.diagnostic.severity.WARN } },
			severity_sort = true,
			float = {
				focusable = true,
				border = M.get_border(border),
				source = true,
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
		})
	end
end

M.get_border = function(border)
	-- 0.11+: winborder is the global default, so just follow it unless overridden
	return border or vim.o.winborder or "rounded"
end

-- Find the project root by searching for a marker file like .git
M.find_project_root = function()
	local root = vim.fs.root(0, { ".git", "package.json", "go.mod" })
	if root then
		return vim.fs.basename(root)
	end
	return nil
end

return M
