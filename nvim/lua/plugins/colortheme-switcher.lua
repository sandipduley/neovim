return {
	-- ── Themes ────────────────────────────────────────────────────────────────
	{
		"folke/tokyonight.nvim",
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		lazy = true,
	},
	{ "tiagovla/tokyodark.nvim", lazy = true },
	{ "samharju/synthweave.nvim", lazy = true },
	{ "maxmx03/fluoromachine.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "bluz71/vim-moonfly-colors", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },
	-- ── Neon / Cyberpunk ──────────────────────────────────────────────────────
	{ "scottmckendry/cyberdream.nvim", lazy = true },
	{ "dasupradyumna/midnight.nvim", lazy = true },
	-- ── Neon Pink / Synthwave ─────────────────────────────────────────────────
	{ "sainnhe/edge", lazy = true },
	-- ── Minimal / Other ───────────────────────────────────────────────────────
	{ "shatur/neovim-ayu", lazy = true },
	{
		"Tsuzat/NeoSolarized.nvim",
		lazy = true,
		config = function()
			require("NeoSolarized").setup({
				style = "dark",
				transparent = true,
				terminal_colors = true,
				enable_italics = true,
			})
		end,
	},
	{
		"zaldih/themery.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			-- ✅ Set style globals BEFORE loadTheme() so they are
			-- already in place when the saved colorscheme is restored.
			vim.g.edge_style = "neon"

			pcall(function()
				require("themery").loadTheme()
			end)

			require("themery").setup({
				livePreview = true,
				themes = {
					-- ── Neon Pink / Synthwave ──────────────────────────────────
					{ name = "Fluoromachine", colorscheme = "fluoromachine" },
					{ name = "Synthweave", colorscheme = "synthweave" },
					{ name = "Edge Neon", colorscheme = "edge" },
					-- ── Neon / Cyberpunk ───────────────────────────────────────
					{ name = "Cyberdream", colorscheme = "cyberdream" },
					{ name = "Midnight", colorscheme = "midnight" },
					{ name = "Oxocarbon", colorscheme = "oxocarbon" },
					-- ── Dark ──────────────────────────────────────────────────
					{ name = "Tokyo Night", colorscheme = "tokyonight" },
					{ name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
					{ name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
					{ name = "Tokyo Dark", colorscheme = "tokyodark" },
					{ name = "Rose Pine", colorscheme = "rose-pine" },
					{ name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
					{ name = "Moonfly", colorscheme = "moonfly" },
					{ name = "NeoSolarized", colorscheme = "NeoSolarized" },
					-- ── One ───────────────────────────────────────────────────
					{ name = "Ayu Dark", colorscheme = "ayu-dark" },
				},
			})

			vim.keymap.set("n", "<leader>ct", "<cmd>Themery<CR>", { desc = "Theme switcher" })
		end,
	},
}
