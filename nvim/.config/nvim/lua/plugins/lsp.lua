return {
	"b0o/SchemaStore.nvim",
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						border = "double",
					},
				},
			},
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. (desc or "") })
					end

					-- Diagnostics Related
					map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
					map("gK", vim.lsp.buf.signature_help, "Signature Help")
					map("K", vim.lsp.buf.hover, "Hover")
					map("]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Next Diagnostic")
					map("[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Prev Diagnostic")
					map("gl", vim.diagnostic.open_float, "Line Diagnostics")
					map("<leader>c", "", "Code")
					-- NOTE: <leader>cs / <leader>cS are owned by Snacks picker
					-- (lsp_symbols / lsp_workspace_symbols). Defaults gO also covers symbols.
					map("<leader>cr", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			require("utils.fns").diagnostics_config()

			local capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			})

			local servers = {
				gopls = {},
				pyright = {},
				vtsls = {},
				astro = {},
				svelte = {},
				html = {},
				emmet_language_server = {
					init_options = {
						showExpandedAbbreviation = "always",
						showSuggestionsAsSnippets = true,
					},
				},
				jsonls = {
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
							schemas = require("schemastore").json.schemas(),
						},
					},
				},
				tailwindcss = {},
				cssls = {
					settings = {
						scss = { validate = true, lint = { unknownAtRules = "ignore" } },
						less = { validate = true, lint = { unknownAtRules = "ignore" } },
						css = { validate = true, lint = { unknownAtRules = "ignore" } },
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
				},
				biome = {},
				rust_analyzer = {},
			}

			local function to_mason_name(lspconfig_name)
				local overrides = {
					html = "html-lsp",
					emmet_language_server = "emmet-language-server",
					tailwindcss = "tailwindcss-language-server",
					lua_ls = "lua-language-server",
					cssls = "css-lsp",
					jsonls = "json-lsp",
					rust_analyzer = "rust-analyzer",
					astro = "astro-language-server",
					svelte = "svelte-language-server",
					clangd = "clangd",
				}
				return overrides[lspconfig_name] or lspconfig_name
			end

			local ensure_installed = vim.tbl_map(to_mason_name, vim.tbl_keys(servers))
			vim.list_extend(ensure_installed, { "stylua", "tree-sitter-cli", "prettier", "clang-format" })

			require("mason").setup()
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, config in pairs(servers) do
				local server_config = vim.tbl_deep_extend("force", { capabilities = capabilities }, config)

				-- Filter unknown filetypes to suppress checkhealth warnings
				local template = vim.lsp.config[name]
				local filetypes = server_config.filetypes or (template and template.filetypes)
				if filetypes then
					server_config.filetypes = vim.tbl_filter(function(ft)
						return #vim.fn.getcompletion(ft, "filetype") > 0
					end, filetypes)
				end

				vim.lsp.config(name, server_config)
			end
			vim.lsp.enable(vim.tbl_keys(servers))

			if vim.fn.executable("sourcekit-lsp") == 1 then
				local sourcekit_config = {
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						workspace = { didchangewatchedfiles = { dynamicregistration = true } },
					}),
					single_file_support = true,
				}
				vim.lsp.config("sourcekit", sourcekit_config)
				vim.lsp.enable("sourcekit")
			end
		end,
	},
}
