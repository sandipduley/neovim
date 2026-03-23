return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- ── Palette ───────────────────────────────────────────────────────────────
		local c = {
			bg = "#1e2030",
			bg2 = "#2d3149",
			bg3 = "#252840",
			fg = "#cdd6f4",
			subtext = "#a6adc8",

			red = "#ff6e8a",
			orange = "#ff9966",
			yellow = "#ffd080",
			green = "#00e5a0",
			blue = "#6eb5ff",
			purple = "#d18eff",
			cyan = "#00d4ff",
			teal = "#00e0c0",
		}

		-- ── Theme — y/z explicitly set so no mode color bleeds in ─────────────────
		local function make_mode(accent)
			return {
				a = { fg = c.bg, bg = accent, gui = "bold" },
				b = { fg = c.fg, bg = c.bg2 },
				c = { fg = c.fg, bg = c.bg3 },
				y = { fg = c.cyan, bg = c.bg2, gui = "bold" },
				z = { fg = accent, bg = c.bg2, gui = "bold" },
			}
		end

		local theme = {
			normal = make_mode(c.teal),
			insert = make_mode(c.blue),
			visual = make_mode(c.purple),
			replace = make_mode(c.red),
			terminal = make_mode(c.green),
			command = make_mode(c.orange),
			inactive = {
				a = { fg = c.subtext, bg = c.bg, gui = "bold" },
				b = { fg = c.subtext, bg = c.bg },
				c = { fg = c.subtext, bg = c.bg3 },
				y = { fg = c.subtext, bg = c.bg2 },
				z = { fg = c.subtext, bg = c.bg2 },
			},
		}

		-- ── Helpers ───────────────────────────────────────────────────────────────
		local wide = function()
			return vim.fn.winwidth(0) > 100
		end

		-- ── Components ────────────────────────────────────────────────────────────
		local mode = {
			"mode",
			fmt = function(str)
				return wide() and ("  " .. str .. " ") or ("  " .. str:sub(1, 1) .. " ")
			end,
		}

		local file = {
			"filename",
			file_status = true,
			path = 3, -- 0: filename, 1: relative, 2: absolute, 3: absolute + shorten home
			symbols = { modified = "  ", readonly = "  ", unnamed = "  " },
		}

		local branch = {
			"branch",
			icon = " ",
			color = { fg = c.purple, gui = "bold" },
		}

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn", "info", "hint" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			diagnostics_color = {
				error = { fg = c.red },
				warn = { fg = c.yellow },
				info = { fg = c.blue },
				hint = { fg = c.teal },
			},
			colored = true,
			update_in_insert = true,
			cond = wide,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = " +A ", modified = " ~M ", removed = " -D " },
			diff_color = {
				added = { fg = c.green },
				modified = { fg = c.yellow },
				removed = { fg = c.red },
			},
			cond = wide,
		}

		local filetype = {
			"filetype",
			colored = true,
			icon_only = false,
			cond = wide,
		}

		local encoding = {
			"encoding",
			fmt = string.upper,
			cond = wide,
			color = { fg = c.subtext },
		}

		-- ── Setup ─────────────────────────────────────────────────────────────────
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = theme,
				section_separators = { left = "", right = "" },
				component_separators = { left = "│", right = "│" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch, diff },
				lualine_c = { file, diagnostics },
				lualine_x = { encoding, filetype },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { file },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive", "neo-tree", "lazy" },
		})
	end,
}
