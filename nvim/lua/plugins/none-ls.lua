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

		-- Ensure formatters/linters are installed
		mason_null_ls.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"ruff",
				"gofumpt",
				"gopls"
				"goimports",
				"shfmt",
				"sqlfluff",
			},
			automatic_installation = true,
		})

		-- null-ls setup
		null_ls.setup({
			sources = {
				formatting.prettier.with({
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"yaml",
						"markdown",
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
				formatting.sqlfluff.with({ extra_args = { "--dialect", "mysql" } }),
				diagnostics.sqlfluff,
			},
		})
	end,
}
