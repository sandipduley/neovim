return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"moll/vim-bbye",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local bufferline = require("bufferline")

		-- ── Palette ───────────────────────────────────────────────────────────────
		local c = {
			bg = "NONE",
			muted = "#565f89", -- inactive text (TokyoNight comment)
			subtle = "#3b4261", -- separators
			visible = "#7aa2f7", -- visible-but-not-focused (blue)
			selected = "#c0caf5", -- active tab text (TokyoNight fg)
			accent = "#7dcfff", -- indicator underline (cyan)
			modified = "#e0af68", -- unsaved dot (yellow)
			close = "#565f89", -- inactive close btn
			close_sel = "#f7768e", -- active close btn (red)
			sep_sel = "#bb9af7", -- selected separator (purple)
		}

		bufferline.setup({
			options = {
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = "Bdelete! %d",
				right_mouse_command = "Bdelete! %d",
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,

				-- Icons
				buffer_close_icon = "󰅖",
				close_icon = "󰯇",
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				icon_pinned = "󰐃",

				-- Layout
				max_name_length = 28,
				max_prefix_length = 28,
				tab_size = 20,
				minimum_padding = 1,
				maximum_padding = 4,
				maximum_length = 15,
				path_components = 1,

				-- Behaviour
				diagnostics = false,
				diagnostics_update_in_insert = false,
				persist_buffer_sort = true,
				sort_by = "insert_at_end",
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				show_tab_indicators = false,

				-- Visuals
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				separator_style = { "│", "│" },
				indicator = { style = "underline" },
			},

			highlights = {
				-- ── Fill ──────────────────────────────────────────────────────────
				fill = { bg = c.bg },

				-- ── Inactive ──────────────────────────────────────────────────────
				background = { fg = c.muted, bg = c.bg },

				-- ── Visible (unfocused split) ──────────────────────────────────────
				buffer_visible = { fg = c.visible, bg = c.bg },

				-- ── Active ────────────────────────────────────────────────────────
				buffer_selected = {
					fg = c.selected,
					bg = c.bg,
					bold = true,
					italic = false,
				},

				-- ── Separators ────────────────────────────────────────────────────
				separator = { fg = c.subtle, bg = c.bg },
				separator_visible = { fg = c.muted, bg = c.bg },
				separator_selected = { fg = c.sep_sel, bg = c.bg },

				-- ── Modified dot ──────────────────────────────────────────────────
				modified = { fg = c.modified, bg = c.bg },
				modified_visible = { fg = c.modified, bg = c.bg },
				modified_selected = { fg = c.modified, bg = c.bg },

				-- ── Close buttons ─────────────────────────────────────────────────
				close_button = { fg = c.close, bg = c.bg },
				close_button_visible = { fg = c.close, bg = c.bg },
				close_button_selected = { fg = c.close_sel, bg = c.bg },

				-- ── Indicator ─────────────────────────────────────────────────────
				indicator_selected = { fg = c.accent, bg = c.bg },

				-- ── Trunc markers ─────────────────────────────────────────────────
				trunc_marker = { fg = c.muted, bg = c.bg },

				-- ── Tab number (when numbers enabled) ─────────────────────────────
				numbers = { fg = c.muted, bg = c.bg },
				numbers_selected = { fg = c.selected, bg = c.bg, bold = true },
			},
		})

		-- ── Keymaps ───────────────────────────────────────────────────────────────
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
		end

		map("<Tab>", "<Cmd>BufferLineCycleNext<CR>", "Buffer: next")
		map("<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", "Buffer: prev")

		for i = 1, 9 do
			map(
				"<leader>" .. i,
				string.format("<Cmd>lua require('bufferline').go_to_buffer(%d)<CR>", i),
				"Buffer: go to " .. i
			)
		end
	end,
}
