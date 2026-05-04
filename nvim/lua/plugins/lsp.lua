return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{
			"j-hui/fidget.nvim",
			opts = { notification = { window = { winblend = 0 } } },
		},
	},

	config = function()
		local lsp = vim.lsp
		local api = vim.api
		local tb = require("telescope.builtin")

		-- ─── Diagnostic UI ───────────────────────────────────────────
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			virtual_text = {
				spacing = 4,
				source = "if_many", -- only show source when there are multiple
				prefix = "●",
			},
			float = {
				border = "rounded",
				source = true, -- always show diagnostic source in float
				header = "",
				prefix = "",
			},
		})

		-- ─── Bordered hover/signature windows ───────────────────────
		vim.lsp.config("*", {
			handlers = {
				["textDocument/hover"] = function(err, result, ctx, config)
					vim.lsp.handlers.hover(
						err,
						result,
						ctx,
						vim.tbl_extend("force", config or {}, { border = "rounded", max_width = 80 })
					)
				end,
				["textDocument/signatureHelp"] = function(err, result, ctx, config)
					vim.lsp.handlers.signature_help(
						err,
						result,
						ctx,
						vim.tbl_extend("force", config or {}, { border = "rounded", max_width = 80 })
					)
				end,
			},
		})
		-- ─── Augroups ────────────────────────────────────────────────
		local attach_group = api.nvim_create_augroup("LspAttach", { clear = true })
		local highlight_group = api.nvim_create_augroup("LspHighlight", { clear = true })
		local format_group = api.nvim_create_augroup("LspFormat", { clear = true })
		local hint_group = api.nvim_create_augroup("LspInlayHints", { clear = true })

		-- ─── On Attach ───────────────────────────────────────────────
		api.nvim_create_autocmd("LspAttach", {
			group = attach_group,
			callback = function(event)
				local buf = event.buf
				local client = lsp.get_client_by_id(event.data.client_id)
				local methods = lsp.protocol.Methods

				local map = function(keys, fn, desc, mode)
					vim.keymap.set(mode or "n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
				end

				-- ── Navigation ──────────────────────────────────────
				map("gd", tb.lsp_definitions, "Goto Definition")
				map("gD", lsp.buf.declaration, "Goto Declaration")
				map("gr", tb.lsp_references, "Goto References")
				map("gI", tb.lsp_implementations, "Goto Implementation")
				map("gy", tb.lsp_type_definitions, "Goto Type Definition")

				-- ── Symbols ─────────────────────────────────────────
				map("<leader>ds", tb.lsp_document_symbols, "Document Symbols")
				map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace Symbols")

				-- ── Actions ─────────────────────────────────────────
				map("<leader>rn", lsp.buf.rename, "Rename Symbol")
				map("<leader>ca", lsp.buf.code_action, "Code Action")
				map("<leader>ca", lsp.buf.code_action, "Code Action", "v") -- visual mode too
				map("<leader>cf", function()
					lsp.buf.format({
						bufnr = buf,
						filter = function(c)
							return c.name == "null-ls"
						end,
					})
				end, "Format Buffer")

				-- ── Hover & Signature ────────────────────────────────
				map("K", lsp.buf.hover, "Hover Documentation")
				map("gK", lsp.buf.signature_help, "Signature Help")
				map("<C-k>", lsp.buf.signature_help, "Signature Help", "i")

				-- ── Diagnostics ──────────────────────────────────────
				map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
				map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
				map("[e", function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end, "Prev Error")
				map("]e", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
				end, "Next Error")
				map("<leader>dl", vim.diagnostic.open_float, "Line Diagnostics")
				map("<leader>dq", vim.diagnostic.setloclist, "Diagnostics to Quickfix")

				-- ── Document Highlight ───────────────────────────────
				if client and client:supports_method(methods.textDocument_documentHighlight) then
					api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = buf,
						group = highlight_group,
						callback = lsp.buf.document_highlight,
					})
					api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = buf,
						group = highlight_group,
						callback = lsp.buf.clear_references,
					})
				end

				-- ── Inlay Hints (Neovim 0.10+) ───────────────────────
				if client and client:supports_method(methods.textDocument_inlayHint) then
					-- Toggle inlay hints with <leader>th
					map("<leader>th", function()
						local enabled = lsp.inlay_hint.is_enabled({ bufnr = buf })
						lsp.inlay_hint.enable(not enabled, { bufnr = buf })
					end, "Toggle Inlay Hints")

					-- Enable inlay hints by default
					api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
						buffer = buf,
						group = hint_group,
						callback = function()
							lsp.inlay_hint.enable(true, { bufnr = buf })
						end,
					})
					-- Disable inlay hints while typing (less distraction)
					api.nvim_create_autocmd("InsertEnter", {
						buffer = buf,
						group = hint_group,
						callback = function()
							lsp.inlay_hint.enable(false, { bufnr = buf })
						end,
					})
				end

				-- ✅ NEW — enable once on attach, Neovim handles refresh automatically
				if client and client:supports_method(methods.textDocument_codeLens) then
					lsp.codelens.enable(true, { bufnr = buf })
					map("<leader>cl", lsp.codelens.run, "Run Code Lens")
				end

				-- ── Format on Save (null-ls only) ────────────────────
				if client and client:supports_method(methods.textDocument_formatting) then
					api.nvim_clear_autocmds({ group = format_group, buffer = buf })
					api.nvim_create_autocmd("BufWritePre", {
						group = format_group,
						buffer = buf,
						callback = function()
							lsp.buf.format({
								bufnr = buf,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		-- ─── Capabilities (with snippet + label details support) ─────
		local capabilities = vim.tbl_deep_extend(
			"force",
			lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)
		-- Enable label details in completion (shows parameter info inline)
		capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
		capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

		-- ─── LSP Servers ─────────────────────────────────────────────
		local servers = {

			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = api.nvim_get_runtime_file("", true),
						},
						hint = { -- inlay hints for Lua
							enable = true,
							setType = true,
							paramName = "All",
						},
						format = { enable = false },
					},
				},
			},

			pyright = {
				settings = {
					python = {
						pythonPath = vim.fn.exepath("python3"),
						analysis = {
							typeCheckingMode = "standard", -- "strict" can be noisy; bump per-project
							diagnosticMode = "workspace", -- catches errors across all files
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							inlayHints = {
								variableTypes = true,
								functionReturnTypes = true,
								callArgumentNames = true,
								pytestParameters = true,
							},
						},
					},
				},
			},

			ts_ls = {
				settings = {
					typescript = {
						format = { enable = false },
						inlayHints = {
							includeInlayParameterNameHints = "all", -- "none"|"literals"|"all"
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						format = { enable = false },
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			},

			gopls = {
				settings = {
					gopls = {
						-- ── Formatting ──────────────────────────────────────────
						gofumpt = true,

						-- ── Analyses ────────────────────────────────────────────
						-- NOTE: "fieldalignment" was REMOVED in gopls v0.17.0.
						-- Struct field size/offset info now appears on hover.
						analyses = {
							unusedparams = true,
							unusedvariable = true, -- also useful, off by default
							shadow = true,
							nilness = true,
							useany = true,
						},

						-- ── Staticcheck (experimental but stable in practice) ───
						staticcheck = true,

						-- ── Completion ──────────────────────────────────────────
						usePlaceholders = true, -- fills parameter names as snippets
						completeFunctionCalls = true, -- already default, explicit is clearer

						-- ── Vulnerability scanning ──────────────────────────────
						vulncheck = "Imports", -- warn about vulnerable dependencies

						-- ── Code Lenses ─────────────────────────────────────────
						-- "run_govulncheck" is superseded by "vulncheck" codelens
						codelenses = {
							generate = true,
							regenerate_cgo = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
							vulncheck = true, -- replaces run_govulncheck
						},

						-- ── Inlay Hints ─────────────────────────────────────────
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},

			html = { filetypes = { "html" } },
			eslint = { settings = { workingDirectory = { mode = "auto" } } },

			bashls = {
				settings = {
					bashIde = { globPattern = "**/*@(.sh|.bash|.zsh|.command)" },
				},
			},

			tailwindcss = {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
				init_options = {
					userLanguages = { eelixir = "html" },
				},
			},

			dockerls = {},
			docker_compose_language_service = {},
		}

		-- ─── Install & Register ───────────────────────────────────────
		require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(servers) })

		for name, cfg in pairs(servers) do
			cfg.capabilities = capabilities
			lsp.config(name, cfg)
			lsp.enable(name)
		end
	end,
}
