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

		-- Shared augroups
		local attach_group = api.nvim_create_augroup("LspAttach", { clear = true })
		local highlight_group = api.nvim_create_augroup("LspHighlight", { clear = true })
		local format_group = api.nvim_create_augroup("LspFormat", { clear = true })

		-- Keymaps and highlights on attach
		api.nvim_create_autocmd("LspAttach", {
			group = attach_group,
			callback = function(event)
				local buf = event.buf
				local client = lsp.get_client_by_id(event.data.client_id)

				local map = function(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
				end

				-- Navigation
				map("gd", tb.lsp_definitions, "Goto Definition")
				map("gr", tb.lsp_references, "Goto References")
				map("gI", tb.lsp_implementations, "Goto Implementation")
				map("<leader>D", tb.lsp_type_definitions, "Type Definition")
				map("<leader>ds", tb.lsp_document_symbols, "Document Symbols")
				map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace Symbols")

				-- Actions
				map("<leader>rn", lsp.buf.rename, "Rename")
				map("<leader>ca", lsp.buf.code_action, "Code Action")
				map("K", lsp.buf.hover, "Hover")
				map("gD", lsp.buf.declaration, "Goto Declaration")

				-- Symbol highlighting
				if client and client.supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
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

				-- Format on save (only null-ls)
				if client and client.supports_method("textDocument/formatting") then
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

		-- Capabilities for completion
		local capabilities = vim.tbl_deep_extend(
			"force",
			lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		-- LSP servers
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
						format = { enable = false },
					},
				},
			},
			pyright = {
				settings = {
					python = {
						pythonPath = vim.fn.exepath("python3"),
						analysis = {
							typeCheckingMode = "strict",
							diagnosticMode = "openFilesOnly",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
			ts_ls = {
				settings = {
					javascript = { format = { enable = false } },
					typescript = { format = { enable = false } },
				},
			},
			html = { filetypes = { "html" } },
			eslint = { settings = { workingDirectory = { mode = "auto" } } },
			bashls = { settings = { bashIde = { globPattern = "**/*@(.sh|.bash|.zsh|.command)" } } },
			dockerls = {},
			docker_compose_language_service = {},

			gopls = {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			},

			-- Tailwind CSS LSP
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
					userLanguages = {
						eelixir = "html",
					},
				},
			},
		}

		-- Ensure LSP servers are installed
		require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(servers) })

		-- Register servers
		for name, cfg in pairs(servers) do
			cfg.capabilities = capabilities
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end
	end,
}
