return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" }, -- lazy-load instead of on startup

	opts = {
		indent = {
			char = "▏",
			tab_char = "▏", -- consistent char for tabs too
		},

		whitespace = {
			remove_blankline_trail = true, -- clean up trailing whitespace on blank lines
		},

		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
			show_exact_scope = false,
			-- highlight scope line with a distinct color via treesitter
			highlight = { "IBLScope" },
			include = {
				node_type = {
					-- scope detection for common languages
					lua = { "table_constructor", "function", "if_statement", "for_statement" },
					python = { "function_definition", "class_definition", "for_statement", "if_statement" },
					go = { "func_literal", "function_declaration", "if_statement", "for_statement" },
					javascript = { "arrow_function", "function_declaration", "object", "if_statement" },
					typescript = { "arrow_function", "function_declaration", "object", "if_statement" },
				},
			},
		},

		exclude = {
			-- filetypes that don't benefit from indent guides
			filetypes = {
				"", -- unnamed buffers
				"help",
				"man",
				"lazy",
				"mason",
				"dashboard",
				"alpha",
				"startify",
				"neo-tree",
				"NvimTree",
				"Trouble",
				"trouble",
				"notify",
				"toggleterm",
				"TelescopePrompt",
				"TelescopeResults",
				"packer",
				"neogitstatus",
				"gitcommit",
				"lspinfo",
			},
			-- buffer types that should never have indent guides
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
				"acwrite",
			},
		},
	},

	config = function(_, opts)
		local ibl = require("ibl")
		local hooks = require("ibl.hooks")

		-- Custom highlight groups so indent lines don't fight your colorscheme
		vim.api.nvim_set_hl(0, "IBLIndent", { fg = "#3b4048", nocombine = true })
		vim.api.nvim_set_hl(0, "IBLScope", { fg = "#9C3028", nocombine = true })
		opts.indent.highlight = { "IBLIndent" }

		ibl.setup(opts)

		-- Re-apply highlights after colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "IBLIndent", { fg = "#3b4048", nocombine = true })
			vim.api.nvim_set_hl(0, "IBLScope", { fg = "#6b737e", nocombine = true })
		end)
	end,
}
