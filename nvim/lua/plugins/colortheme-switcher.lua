return {
	-- ── Themes ────────────────────────────────────────────────────────────────
	{ "folke/tokyonight.nvim", lazy = true },
	{ "tiagovla/tokyodark.nvim", lazy = true },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "Mofiqul/dracula.nvim", lazy = true },
	{ "samharju/synthweave.nvim", lazy = true },
	{ "maxmx03/fluoromachine.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "sainnhe/sonokai", lazy = true },
	{ "bluz71/vim-moonfly-colors", lazy = true },
	{ "projekt0n/github-nvim-theme", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },
	-- ── Neon / Cyberpunk ──────────────────────────────────────────────────────
	{ "scottmckendry/cyberdream.nvim", lazy = true },
	{ "olivercederborg/poimandres.nvim", lazy = true },
	{ "ray-x/aurora", lazy = true },
	{ "embark-theme/vim", name = "embark", lazy = true },
	{ "dasupradyumna/midnight.nvim", lazy = true },
	-- ── Neon Pink / Synthwave ─────────────────────────────────────────────────
	{ "sainnhe/edge", lazy = true },

	-- ── Themery ───────────────────────────────────────────────────────────────
	{
		"zaldih/themery.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			pcall(function()
				require("themery").loadTheme()
			end)

			vim.g.edge_style = "neon"

			require("themery").setup({
				livePreview = true,
				themes = {
					-- ── Neon Pink / Synthwave ──────────────────────────────────
					{ name = "Fluoromachine", colorscheme = "fluoromachine" },
					{ name = "Synthweave", colorscheme = "synthweave" },
					{ name = "Edge Neon", colorscheme = "edge" },
					-- ── Neon / Cyberpunk ───────────────────────────────────────
					{ name = "Cyberdream", colorscheme = "cyberdream" },
					{ name = "Poimandres", colorscheme = "poimandres" },
					{ name = "Aurora", colorscheme = "aurora" },
					{ name = "Embark", colorscheme = "embark" },
					{ name = "Midnight", colorscheme = "midnight" },
					{ name = "Oxocarbon", colorscheme = "oxocarbon" },
					-- ── Dark ──────────────────────────────────────────────────
					{ name = "Tokyo Night", colorscheme = "tokyonight" },
					{ name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
					{ name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
					{ name = "Tokyo Dark", colorscheme = "tokyodark" },
					{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
					{ name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
					{ name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
					{ name = "Dracula", colorscheme = "dracula" },
					{ name = "Dracula Soft", colorscheme = "dracula-soft" },
					{ name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
					{ name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
					{ name = "Rose Pine", colorscheme = "rose-pine" },
					{ name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
					{ name = "Nightfox", colorscheme = "nightfox" },
					{ name = "Nordfox", colorscheme = "nordfox" },
					{ name = "Carbonfox", colorscheme = "carbonfox" },
					{ name = "Terafox", colorscheme = "terafox" },
					{ name = "Duskfox", colorscheme = "duskfox" },
					{ name = "Sonokai", colorscheme = "sonokai" },
					{ name = "Moonfly", colorscheme = "moonfly" },
					{ name = "GitHub Dark", colorscheme = "github_dark" },
					{ name = "GitHub Dark Dimmed", colorscheme = "github_dark_dimmed" },
				},
			})

			vim.keymap.set("n", "<leader>ct", "<cmd>Themery<CR>", { desc = "Theme switcher" })
		end,
	},
}
