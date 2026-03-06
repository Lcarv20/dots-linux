local M = {}

M.colors = function()
	local is_dark = vim.o.background == "dark"

	-- Safely get colors with fallbacks
	local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	local normal_bg = normal_hl.bg and string.format("#%06x", normal_hl.bg) or (is_dark and "#181818" or "#ffffff")
	local normal_fg = normal_hl.fg and string.format("#%06x", normal_hl.fg) or (is_dark and "#eae6e1" or "#000000")

	local light = {
		bg = normal_bg,
		fg = normal_fg,
		pink_shock = "#eb53ed",
		cyan = "#00ffff",
		mauve = "#cba6f7",
		mutted = "#dbd9d7",
		teal = "#a6e3a1",
		suave_red = "#f38ba8",
		yellow = "#ffdd33",
		saphire = "#74c7ec",
		green = "#73c936",
		purple = "#7d4bfa",
		dark_blue = "#2c50f2",
		blue = "#69bef0",
		red = "#d41343",
		orange = "#ff9e64",
		subtle_gray = "#736b6b",
		violet = "#6C71C4",
		magenta = "#D33682",
	}

	-- Pastel, eye-friendly dark palette inspired by Catppuccin/Nord
	local dark = {
		bg = normal_bg,
		fg = normal_fg,
		pink_shock = "#f5c2e7", -- soft pink
		cyan = "#94e2d5", -- soft cyan/aqua
		mauve = "#cba6f7", -- soft lavender
		mutted = "#474747",
		teal = "#94e2d5", -- soft teal
		suave_red = "#f38ba8", -- soft rose
		yellow = "#f9e2af", -- soft yellow
		saphire = "#89b4fa", -- soft blue
		green = "#a6e3a1", -- soft green
		purple = "#b4befe", -- soft purple
		dark_blue = "#6c7086", -- muted blue-gray
		blue = "#89b4fa", -- soft blue
		red = "#f38ba8", -- soft red
		orange = "#fab387", -- soft peach
		subtle_gray = "#6c7086", -- soft gray
		violet = "#b4befe", -- soft violet
		magenta = "#f5c2e7", -- soft magenta
	}

	if is_dark then
		return dark
	else
		return light
	end
end

return M
