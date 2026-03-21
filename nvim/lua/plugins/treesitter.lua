return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"c",
				"css",
				"dockerfile",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
				"gitignore",
			},

			auto_install = true,
			highlight = { enable = true },
			indent = { enable = false },

			-- ── Incremental selection ──────────────────────────────────────────────
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},

			-- ── Textobjects ───────────────────────────────────────────────────────
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = { query = "@parameter.outer", desc = "outer argument" },
						["ia"] = { query = "@parameter.inner", desc = "inner argument" },
						["af"] = { query = "@function.outer", desc = "outer function" },
						["if"] = { query = "@function.inner", desc = "inner function" },
						["ac"] = { query = "@class.outer", desc = "outer class" },
						["ic"] = { query = "@class.inner", desc = "inner class" },
					},
				},

				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = { query = "@function.outer", desc = "next function start" },
						["]]"] = { query = "@class.outer", desc = "next class start" },
					},
					goto_next_end = {
						["]M"] = { query = "@function.outer", desc = "next function end" },
						["]["] = { query = "@class.outer", desc = "next class end" },
					},
					goto_previous_start = {
						["[m"] = { query = "@function.outer", desc = "prev function start" },
						["[["] = { query = "@class.outer", desc = "prev class start" },
					},
					goto_previous_end = {
						["[M"] = { query = "@function.outer", desc = "prev function end" },
						["[]"] = { query = "@class.outer", desc = "prev class end" },
					},
				},

				swap = {
					enable = true,
					swap_next = { ["<leader>a"] = { query = "@parameter.inner", desc = "swap next param" } },
					swap_previous = { ["<leader>A"] = { query = "@parameter.inner", desc = "swap prev param" } },
				},
			},
		})
	end,
}
