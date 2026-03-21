return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()

		-- ── Persistent autocomplete toggle ────────────────────────────────────────
		local state_file = vim.fn.stdpath("data") .. "/cmp_state.txt"
		local ac_on = vim.fn.filereadable(state_file) == 1 and vim.fn.readfile(state_file)[1] == "true" or true

		-- ── Kind icons ────────────────────────────────────────────────────────────
		local icons = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "",
		}

		-- ── Source labels ─────────────────────────────────────────────────────────
		local labels = {
			nvim_lsp = "[LSP]",
			luasnip = "[Snip]",
			buffer = "[Buf]",
			path = "[Path]",
		}

		-- ── Setup ─────────────────────────────────────────────────────────────────
		cmp.setup({
			enabled = function()
				return ac_on
			end,

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
					col_offset = -3,
					side_padding = 2,
					scrollbar = false,
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
					max_width = 60,
					max_height = 15,
					side_padding = 2,
				},
			},

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					local icon = icons[item.kind] or ""
					item.kind = string.format(" %s %s ", icon, item.kind)
					item.menu = labels[entry.source.name] or ""
					item.abbr = item.abbr:sub(1, 40) -- truncate long names
					return item
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),

				-- Confirm only with <S-CR>; plain <CR> keeps default behaviour
				["<S-CR>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping(function(fallback)
					fallback()
				end, { "i", "s" }),

				-- Tab: next item or expand/jump snippet
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				-- S-Tab: prev item or jump back in snippet
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			sources = cmp.config.sources(
				{ { name = "nvim_lsp" }, { name = "luasnip" } },
				{ { name = "buffer" }, { name = "path" } }
			),

			-- Show docs automatically
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
		})

		-- ── Highlight tweaks ──────────────────────────────────────────────────────
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				-- completion popup
				vim.api.nvim_set_hl(0, "CmpNormal", { link = "NormalFloat" })
				vim.api.nvim_set_hl(0, "CmpBorder", { link = "FloatBorder" })
				vim.api.nvim_set_hl(0, "CmpSel", { link = "PmenuSel" })
				-- documentation popup
				vim.api.nvim_set_hl(0, "CmpDocNormal", { link = "NormalFloat" })
				vim.api.nvim_set_hl(0, "CmpDocBorder", { link = "FloatBorder" })
				-- ghost text (inline preview)
				vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment" })
			end,
		})
		-- Apply immediately for current session
		vim.cmd("doautocmd ColorScheme")

		-- ── Toggle keymap ─────────────────────────────────────────────────────────
		vim.keymap.set("n", "<leader>ta", function()
			ac_on = not ac_on
			vim.fn.writefile({ tostring(ac_on) }, state_file)
			cmp.setup({
				enabled = function()
					return ac_on
				end,
			})
			vim.cmd("redraw")
			print(ac_on and " Autocomplete ON" or " Autocomplete OFF")
		end, { desc = "Toggle autocomplete" })
	end,
}
