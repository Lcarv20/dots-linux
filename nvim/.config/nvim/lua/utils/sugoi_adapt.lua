local M = {}

local uv = vim.uv or vim.loop
local path = vim.fn.expand("~/.cache/dms/dms-colors.json")
local settings_path = vim.fn.expand("~/.config/dms/settings.json")

function M.is_dux_active()
	return vim.fn.executable("dms") == 1 and uv.fs_stat(path) ~= nil
end

function M.is_sugoi_active()
	return vim.g.colors_name == "sugoi"
end

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function rgb_to_hex(r, g, b)
	return string.format(
		"#%02x%02x%02x",
		math.floor(math.min(255, math.max(0, r))),
		math.floor(math.min(255, math.max(0, g))),
		math.floor(math.min(255, math.max(0, b)))
	)
end

local function lerp(h1, h2, t)
	local r1, g1, b1 = hex_to_rgb(h1)
	local r2, g2, b2 = hex_to_rgb(h2)
	return rgb_to_hex(r1 + (r2 - r1) * t, g1 + (g2 - g1) * t, b1 + (b2 - b1) * t)
end

function M.get_adapted_palette()
	if not M.is_dux_active() then
		return nil, nil
	end

	local f = io.open(path, "r")
	if not f then
		return nil, nil
	end
	local raw = f:read("*a")
	f:close()

	local ok, data = pcall(vim.json.decode, raw)
	if not ok or type(data) ~= "table" or not data.colors then
		return nil, nil
	end

	-- Check DMS settings for terminalsAlwaysDark
	local terminals_always_dark = false
	local sf = io.open(settings_path, "r")
	if sf then
		local sok, sdata = pcall(vim.json.decode, sf:read("*a"))
		sf:close()
		if sok and type(sdata) == "table" and sdata.terminalsAlwaysDark then
			terminals_always_dark = true
		end
	end

	local mode = terminals_always_dark and "dark" or (data.mode or (vim.o.background or "dark"))
	local c = data.colors[mode]
	local d16 = data.dank16 or {}

	if not c then
		return nil, nil
	end

	local d16_c = function(key, fallback)
		if d16[key] and d16[key].default then
			return d16[key].default
		end
		return fallback
	end

	local palette = {
		background = c.background,
		foreground = c.on_surface,
		primary = c.primary,
		secondary = c.secondary,
		accent = c.tertiary,
		diagnostic_error = c.error,
		diagnostic_warning = d16_c("color3", mode == "dark" and "#fff872" or "#767400"),
		diagnostic_info = d16_c("color4", mode == "dark" and "#93b2f2" or "#2c5eb0"),
		diagnostic_hint = d16_c("color2", mode == "dark" and "#7fff92" or "#087e19"),
		diff_add = d16_c("color2", mode == "dark" and "#7fff92" or "#087e19"),
		diff_change = d16_c("color4", mode == "dark" and "#93b2f2" or "#2c5eb0"),
		diff_delete = c.error,
		sugoi_0 = c.on_surface,
		sugoi_1 = lerp(c.on_surface, c.outline, 0.15),
		sugoi_2 = lerp(c.on_surface, c.outline, 0.30),
		sugoi_3 = lerp(c.on_surface, c.outline, 0.45),
		sugoi_4 = lerp(c.on_surface, c.outline, 0.60),
		sugoi_5 = lerp(c.on_surface, c.outline, 0.75),
		sugoi_6 = lerp(c.on_surface, c.outline, 0.90),
		sugoi_7 = c.outline,
		sugoi_8 = mode == "dark" and c.surface_container_highest or c.surface_container_high,
		sugoi_9 = mode == "dark" and c.surface_container or c.surface_container_low,
	}

	return palette, mode
end

function M.apply(force)
	-- Guard: If a different theme is actively set and not forced, don't hijack it
	if not force and vim.g.colors_name and vim.g.colors_name ~= "sugoi" then
		return
	end

	-- Guard: If Dux is not the shell, simply run standard sugoi
	if not M.is_dux_active() then
		require("sugoi").setup({ transparent = true })
		vim.cmd.colorscheme("sugoi")
		return
	end

	local pal, mode = M.get_adapted_palette()
	if pal and mode then
		vim.o.background = mode
		local palette_name = (mode == "light") and "light" or "default"
		require("sugoi").setup({
			transparent = true,
			palette = palette_name,
			colors = pal,
		})
	else
		require("sugoi").setup({
			transparent = true,
		})
	end
	vim.cmd.colorscheme("sugoi")
end

function M.watch()
	if _G._sugoi_dms_watcher then
		return
	end

	-- Guard: Don't start watching if Dux is not installed or active
	if not M.is_dux_active() then
		return
	end

	local watcher = uv.new_fs_event()
	local debounce_timer = uv.new_timer()

	_G._sugoi_dms_watcher = { watcher = watcher, timer = debounce_timer }

	local function on_change(err, filename, events)
		if err then
			return
		end
		debounce_timer:stop()
		debounce_timer:start(
			100,
			0,
			vim.schedule_wrap(function()
				-- Guard: Only adapt if sugoi is STILL the active colorscheme AND Dux is active!
				if M.is_sugoi_active() and M.is_dux_active() then
					M.apply(true)
					vim.notify("Sugoi palette adapted from DMS", vim.log.levels.INFO, { title = "Sugoi" })
				end
				-- Re-arm watcher to cleanly handle atomic file writes / inode recreation
				pcall(function()
					watcher:stop()
					watcher:start(path, {}, on_change)
				end)
			end)
		)
	end

	pcall(function()
		watcher:start(path, {}, on_change)
	end)
end

return M
