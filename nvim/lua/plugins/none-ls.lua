return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},

	config = function()
		local null_ls = require("null-ls")
		local mason_null_ls = require("mason-null-ls")

		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Mason Null-LS: ONLY formatters & linters
		mason_null_ls.setup({
			ensure_installed = {
				-- Web
				"prettier",

				-- Lua
				"stylua",

				-- Python
				"ruff",

				-- Go
				"gofumpt",
				"goimports",

				-- Shell
				"shfmt",

				-- SQL
				"sqlfluff",
			},
			automatic_installation = true,
		})

		-- none-ls setup
		null_ls.setup({
			sources = {

				-- JavaScript / TypeScript / Web

				formatting.prettier.with({
					filetypes = {
						"html",
						"json",
						"yaml",
						"markdown",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"css",
						"scss",
					},
				}),

				-- Lua
				formatting.stylua,

				-- Python
				require("none-ls.formatting.ruff_format"),
				require("none-ls.diagnostics.ruff"),

				-- Go
				formatting.gofumpt,
				formatting.goimports,

				-- Shell
				formatting.shfmt,

				-- SQL
				formatting.sqlfluff.with({
					extra_args = { "--dialect", "mysql" },
				}),
				diagnostics.sqlfluff,
			},
		})
	end,
}
