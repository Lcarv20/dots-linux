-- local hex_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg", "gui")
-- vim.api.nvim_set_hl(0, "Separator", { bg = hex_bg })

vim.api.nvim_set_hl(0, "WinSeparator", { link = "FloatBorder" })
