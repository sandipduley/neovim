return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },

	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = { "rafamadriz/friendly-snippets" },
		},
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local compare = require("cmp.config.compare")

		-- ─── Highlight Groups ─────────────────────────────────────────
		local set_hl = vim.api.nvim_set_hl
		local function define_cmp_hls()
			set_hl(0, "CmpNormal", { link = "NormalFloat" })
			set_hl(0, "CmpBorder", { link = "FloatBorder" })
			set_hl(0, "CmpSel", { link = "PmenuSel" })
		end

		define_cmp_hls()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("CmpHighlights", { clear = true }),
			callback = define_cmp_hls,
		})

		-- ─── Snippets ─────────────────────────────────────────────────
		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})

		-- ─── Icons ───────────────────────────────────────────────────
		local kind_icons = {
			Text = "󰉿",
			Method = "󰊕",
			Function = "󰊕",
			Constructor = "",
			Field = "󰇽",
			Variable = "󰆧",
			Class = "󰌗",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰇽",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰊄",
		}

		local source_labels = {
			nvim_lsp = "LSP",
			nvim_lsp_signature_help = "Sig",
			luasnip = "Snip",
			buffer = "Buf",
			path = "Path",
			cmdline = "Cmd",
		}

		-- ─── Helpers ─────────────────────────────────────────────────
		local function has_words_before()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		-- ─── Insert-mode completion ───────────────────────────────────
		cmp.setup({

			performance = {
				debounce = 60,
				throttle = 30,
				max_view_entries = 20,
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder",
				}),
			},

			-- ── Keymaps ──────────────────────────────────────────────
			mapping = cmp.mapping.preset.insert({

				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),

				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),

				-- Confirm only if explicitly selected — prevents accidental Enter
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				-- Force-confirm first item without selecting
				["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- Snippet jump forward / backward
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),

				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),

				-- Smart Tab: menu → snippet → trigger → fallback
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			-- ── Sources ───────────────────────────────────────────────
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "nvim_lsp_signature_help", priority = 900 },
				{ name = "luasnip", priority = 800 },
				{ name = "path", priority = 300 },
			}, {
				{
					name = "buffer",
					priority = 500,
					option = {
						-- Only pull from loaded normal buffers
						get_bufnrs = function()
							return vim.tbl_filter(function(b)
								return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buftype == ""
							end, vim.api.nvim_list_bufs())
						end,
					},
				},
			}),

			-- ── Formatting ───────────────────────────────────────────
			formatting = {
				fields = { "kind", "abbr", "menu" },
				expandable_indicator = true,
				format = function(entry, item)
					item.kind = string.format(" %s %s", kind_icons[item.kind] or "", item.kind)
					item.menu = string.format("[%s]", source_labels[entry.source.name] or entry.source.name)

					-- Truncate long labels
					local MAX = 40
					if #item.abbr > MAX then
						item.abbr = item.abbr:sub(1, MAX) .. "…"
					end

					return item
				end,
			},

			-- ── Behaviour ────────────────────────────────────────────
			completion = {
				completeopt = "menu,menuone,noinsert",
			},

			-- ── Sorting ──────────────────────────────────────────────
			sorting = {
				priority_weight = 2,
				comparators = {
					compare.offset,
					compare.exact,
					compare.score,
					compare.recently_used,
					compare.locality,
					compare.kind,
					compare.length,
					compare.order,
				},
			},

			-- Suppress completion inside comments
			enabled = function()
				local ctx = require("cmp.config.context")
				if vim.api.nvim_get_mode().mode == "c" then
					return true
				end
				return not ctx.in_treesitter_capture("comment") and not ctx.in_syntax_group("Comment")
			end,
		})

		-- ─── Cmdline: search (/ and ?) ────────────────────────────────
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = "buffer" } },
		})

		-- ─── Cmdline: commands (:) ────────────────────────────────────
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources(
				{ { name = "path" } },
				{ { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
			),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
	end,
}
