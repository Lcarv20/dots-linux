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
			"williamboman/mason-lspconfig.nvim",
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
					map("<leader>cs", vim.lsp.buf.document_symbol, "Document Symbols")
					map("<leader>cS", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
					map("<leader>cr", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
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
				end,
			})

			require("utils.fns").diagnostics_config()
			require("utils.fns").lsp_popover_borders()

			local capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			}
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

			local servers = {
				gopls = {},
				pyright = {},
				vtsls = {},
				astro = {},
				jsonls = {
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				tailwindcss = {
					filetype_exclude = { "markdown" },
					settings = {
						tailwindCSS = {
							classFunctions = { "cva", "cx" },
							classAttributes = { "class", "className" }, -- Keep these for actual attributes
							-- This is the key part for variable assignments
							experimental = {
								classRegex = {
									-- Default patterns
									"class=['\"][^'\"]*['\"]",
									"className=['\"][^'\"]*['\"]",
									-- Pattern for variable assignments ending with 'Styles'
									"\\b\\w*[Ss]tyles\\s*=\\s*['\"]([^'\"]*)['\"]",
									-- More general pattern for any variable with tailwind classes
									"\\b(?:const|let|var)\\s+\\w*[Ss]tyles\\s*=\\s*['\"]([^'\"]*)['\"]",
									-- Template literals
									"\\b\\w*[Ss]tyles\\s*=\\s*`([^`]*)`",
								},
							},
						},
					},
				},
				cssls = {
					settings = {
						scss = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						less = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
        biome = {},
        rust_analyzer = {},
        clangd = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"clang-format",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason").setup()
			vim.lsp.enable(ensure_installed)

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				vim.lsp.config(name, config)
			end
		end,
	},
}
