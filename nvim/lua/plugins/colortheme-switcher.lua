return {
	-- ── Themes ────────────────────────────────────────────────────────────────
	{ "folke/tokyonight.nvim", lazy = true },
	{ "tiagovla/tokyodark.nvim", lazy = true },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "navarasu/onedark.nvim", lazy = true },
	{ "sainnhe/everforest", lazy = true },
	{ "Mofiqul/dracula.nvim", lazy = true },
	{ "bluz71/vim-nightfly-colors", lazy = true },
	{ "samharju/synthweave.nvim", lazy = true },
	{ "Tsuzat/NeoSolarized.nvim", lazy = true },
	{ "maxmx03/fluoromachine.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "sainnhe/sonokai", lazy = true },
	{ "sainnhe/gruvbox-material", lazy = true },
	{ "marko-cerovac/material.nvim", lazy = true },
	{ "bluz71/vim-moonfly-colors", lazy = true },
	{ "projekt0n/github-nvim-theme", lazy = true },
	{ "olimorris/onedarkpro.nvim", lazy = true },
	{ "shaunsingh/nord.nvim", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },
	-- { "ficcdaf/anemo.nvim", lazy = true },

	-- ── Themery ───────────────────────────────────────────────────────────────
	{
		"zaldih/themery.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			pcall(function()
				require("themery").loadTheme()
			end)

			require("themery").setup({
				livePreview = true,
				themes = {
					-- Dark
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
					{ name = "Synthweave", colorscheme = "synthweave" },
					{ name = "Fluoromachine", colorscheme = "fluoromachine" },
					{ name = "Nightfly", colorscheme = "nightfly" },
					{ name = "Moonfly", colorscheme = "moonfly" },
					{ name = "Sonokai", colorscheme = "sonokai" },
					{ name = "Oxocarbon", colorscheme = "oxocarbon" },
					-- { name = "Anemo", colorscheme = "anemo" },
					-- Medium / neutral
					{ name = "OneDark", colorscheme = "onedark" },
					{ name = "Material Oceanic", colorscheme = "material-oceanic" },
					{ name = "Material Deep Ocean", colorscheme = "material-deep-ocean" },
					{ name = "Material Palenight", colorscheme = "material-palenight" },
					{ name = "Nord", colorscheme = "nord" },
					{ name = "NeoSolarized", colorscheme = "NeoSolarized" },
					{ name = "GitHub Dark", colorscheme = "github_dark" },
					{ name = "GitHub Dark Dimmed", colorscheme = "github_dark_dimmed" },
					-- Light / warm
					{ name = "Gruvbox", colorscheme = "gruvbox" },
					{ name = "Gruvbox Material", colorscheme = "gruvbox-material" },
					{ name = "Everforest", colorscheme = "everforest" },
					{ name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
					{ name = "Rose Pine Dawn", colorscheme = "rose-pine-dawn" },
					{ name = "GitHub Light", colorscheme = "github_light" },
				},
			})

			vim.keymap.set("n", "<leader>ct", "<cmd>Themery<CR>", { desc = "Theme switcher" })
		end,
	},
}
