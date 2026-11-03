-- lua/config/statusline.lua
-- Neovim 0.12 Native Statusline (Gemini Theme Aesthetic)
-- Transparent background with pill-shaped components matching original exactly

local M = {}

local pill_bg = "#212121"

local function hl(name, val)
	vim.api.nvim_set_hl(0, name, val)
end

-- Initialize highlights for the pill aesthetic
local function init_hls()
	local colors = require("utils.colors").colors()

	hl("StatusLine", { bg = "NONE" })
	hl("StatusLineNC", { bg = "NONE" })
	hl("StatusLinePill", { bg = pill_bg, fg = colors.fg })
	hl("StatusLinePillSep", { fg = pill_bg, bg = "NONE" })
	hl("StatusLinePillStart", { fg = colors.mauve, bg = pill_bg })

	hl("StatusLineModeNormal", { fg = colors.red, bg = pill_bg, bold = true })
	hl("StatusLineModeInsert", { fg = colors.green, bg = pill_bg, bold = true })
	hl("StatusLineModeVisual", { fg = colors.blue, bg = pill_bg, bold = true })
	hl("StatusLineModeCmd", { fg = colors.magenta, bg = pill_bg, bold = true })

	hl("StatusLineDiagError", { fg = colors.red, bg = pill_bg })
	hl("StatusLineDiagWarn", { fg = colors.yellow, bg = pill_bg })
	hl("StatusLineDiagInfo", { fg = colors.cyan, bg = pill_bg })

	hl("StatusLineGitBranch", { fg = colors.violet, bg = pill_bg, bold = true })
	hl("StatusLineGitAdd", { fg = colors.green, bg = pill_bg })
	hl("StatusLineGitChange", { fg = colors.orange, bg = pill_bg })
	hl("StatusLineGitRemove", { fg = colors.red, bg = pill_bg })

	hl("StatusLineFileInfo", { fg = colors.magenta, bg = pill_bg, bold = true })

	hl("StatusLineMacroRecorded", { fg = colors.green, bg = pill_bg, bold = true })
	hl("StatusLineMacroRecording", { fg = colors.red, bg = pill_bg, bold = true })
end

local function get_mode()
	local mode_map = {
		n = { " ", "StatusLineModeNormal" },
		i = { " ", "StatusLineModeInsert" },
		v = { " ", "StatusLineModeVisual" },
		V = { " ", "StatusLineModeVisual" },
		["\22"] = { "", "StatusLineModeVisual" },
		c = { " ", "StatusLineModeCmd" },
		t = { " ", "StatusLineModeNormal" },
	}
	local m = mode_map[vim.fn.mode()] or { " ", "StatusLineModeNormal" }
	return string.format("%%#StatusLinePillStart#🭪 %%#%s#%s %%#StatusLinePillSep#", m[2], m[1])
end

local function get_location()
	local line_count = vim.fn.line("$")
	local percent = line_count > 0 and math.floor(vim.fn.line(".") * 100 / line_count) or 0
	return string.format("%%#StatusLinePillSep# %%#StatusLinePill#%%l:%%c  %d%%%%%%#StatusLinePillSep#", percent)
end

local function get_diagnostics()
	local counts = vim.diagnostic.count(0)
	if vim.tbl_isempty(counts) then
		return ""
	end

	local parts = {}
	if counts[vim.diagnostic.severity.ERROR] then
		table.insert(parts, string.format("%%#StatusLineDiagError# %d", counts[vim.diagnostic.severity.ERROR]))
	end
	if counts[vim.diagnostic.severity.WARN] then
		table.insert(parts, string.format("%%#StatusLineDiagWarn# %d", counts[vim.diagnostic.severity.WARN]))
	end
	if counts[vim.diagnostic.severity.INFO] then
		table.insert(parts, string.format("%%#StatusLineDiagInfo# %d", counts[vim.diagnostic.severity.INFO]))
	end

	if #parts == 0 then
		return ""
	end
	return string.format("%%#StatusLinePillSep# %%#StatusLinePill#%s%%#StatusLinePillSep#", table.concat(parts, " "))
end

local function get_lsp_status()
	-- 0.12+: vim.lsp.status() replaces vim.ui.progress_status()
	local get_status = vim.lsp.status or vim.ui.progress_status
	local status = get_status()
	if status == "" then
		return ""
	end
	return string.format("%%#StatusLinePillSep# %%#StatusLinePill#%s%%#StatusLinePillSep#", status)
end

local last_macro = ""
local macro_timer = nil

local function make_pill(content)
	return string.format("%%#StatusLinePillSep# %%#StatusLinePill#%s%%#StatusLinePillSep#", content)
end

local function get_macros()
	local recording_register = vim.fn.reg_recording()
	local recorded_register = vim.fn.reg_recorded()
	local pills = {}

	if recorded_register ~= "" and recording_register == "" then
		last_macro = recorded_register
	end

	if last_macro ~= "" and recording_register ~= last_macro then
		table.insert(pills, make_pill(string.format("%%#StatusLineMacroRecorded#󰐊 %s", last_macro)))
	end

	if recording_register ~= "" then
		table.insert(pills, make_pill(string.format("%%#StatusLineMacroRecording#󰑊 %s", recording_register)))
	end

	return table.concat(pills, " ")
end

local function get_git()
	local dict = vim.b.gitsigns_status_dict

	if not dict or type(dict) ~= "table" then
		return ""
	end

	local parts = {}
	-- Gitsigns uses 'head' for the branch name
	local branch = dict.head or dict.branch
	if branch and branch ~= "" then
		table.insert(parts, string.format("%%#StatusLineGitBranch# %s", branch))
	end
	if dict.added and dict.added > 0 then
		table.insert(parts, string.format("%%#StatusLineGitAdd# %d", dict.added))
	end
	if dict.changed and dict.changed > 0 then
		table.insert(parts, string.format("%%#StatusLineGitChange#󱨇 %d", dict.changed))
	end
	if dict.removed and dict.removed > 0 then
		table.insert(parts, string.format("%%#StatusLineGitRemove# %d", dict.removed))
	end

	if #parts == 0 then
		return ""
	end
	return string.format("%%#StatusLinePillSep# %%#StatusLinePill#%s%%#StatusLinePillSep#", table.concat(parts, " "))
end

local function get_file_info()
	local file = vim.fn.expand("%:t")
	if file == "" then
		return ""
	end

	local icon = ""
	local icon_hl = "StatusLinePill"
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if ok then
		local i, hl_group = devicons.get_icon(file, vim.fn.expand("%:e"), { default = true })
		if i then
			icon = i
			if hl_group then
				local hl_def = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
				if hl_def and hl_def.fg then
					local fg = string.format("#%06x", hl_def.fg)
					hl("StatusLineIcon_" .. hl_group, { fg = fg, bg = pill_bg })
					icon_hl = "StatusLineIcon_" .. hl_group
				end
			end
		end
	end

	return string.format("%%#StatusLinePillSep# %%#%s#%s  %%#StatusLineFileInfo#%s%%#StatusLinePillSep#", icon_hl, icon, file)
end

function M.render()
	init_hls()
	return table.concat({
		get_mode(),
		get_location(),
		get_diagnostics(),
		get_lsp_status(),
		"%=",
		get_macros(),
		"%=",
		get_file_info(),
		get_git(),
	})
end

function M.setup()
	vim.opt.statusline = "%!v:lua.require'config.statusline'.render()"

	-- Refresh statusline on macro recording events
	vim.api.nvim_create_autocmd("RecordingEnter", {
		callback = function()
			if macro_timer then
				macro_timer:stop()
				macro_timer = nil
			end
			vim.cmd("redrawstatus")
		end,
	})

	vim.api.nvim_create_autocmd("RecordingLeave", {
		callback = function()
			last_macro = vim.fn.reg_recorded()
			if macro_timer then
				macro_timer:stop()
			end
			macro_timer = vim.uv.new_timer()
			if macro_timer then
				macro_timer:start(10000, 0, vim.schedule_wrap(function()
					last_macro = ""
					macro_timer = nil
					vim.cmd("redrawstatus")
				end))
			end
			vim.cmd("redrawstatus")
		end,
	})
end

return M
