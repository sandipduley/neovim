-- Install lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	local result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		repo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		error("Failed to clone lazy.nvim:\n" .. result)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Plugin setup

require("lazy").setup({
	spec = {
		{ import = "plugins.alpha" },
		{ import = "plugins.autocompletion" },
		{ import = "plugins.bufferline" },
		{ import = "plugins.cmp" },
		{ import = "plugins.colortheme-switcher" },
		{ import = "plugins.comments" },
		-- { import = "plugins.debug" },
		{ import = "plugins.extra-plugins" },
		{ import = "plugins.gitsigns" },
		{ import = "plugins.indent-blankline" },
		{ import = "plugins.lazygit" },
		{ import = "plugins.lualine" },
		{ import = "plugins.lsp" },
		-- { import = "plugins.neotree" },
		{ import = "plugins.none-ls" },
		{ import = "plugins.telescope" },
		{ import = "plugins.tiny-inline-diagnostic" },
		{ import = "plugins.undotree" },
		{ import = "plugins.yazi" },
		{ import = "plugins.render-markdown" },
	},

	-- Loading treesitter separately to prevent unable to load/find treesitter dir
	{ import = "plugins.treesitter" },
	change_detection = {
		notify = false,
	},

	-- Core configuration

	require("core.options"),
	require("core.keymaps"),

	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤",
		},
	},
})

-- Restore cursor position + center view

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local ft = vim.bo.filetype
		if ft == "gitcommit" or ft == "gitrebase" then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line = mark[1]
		local total = vim.api.nvim_buf_line_count(0)

		if line > 1 and line <= total then
			vim.cmd([[normal! g`"zz]])
		end
	end,
})
