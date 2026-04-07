return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#12131a',
				base01 = '#12131a',
				base02 = '#82897f',
				base03 = '#82897f',
				base04 = '#d4ded1',
				base05 = '#fafff8',
				base06 = '#fafff8',
				base07 = '#fafff8',
				base08 = '#ffb39f',
				base09 = '#ffb39f',
				base0A = '#b8e9a8',
				base0B = '#a9fea5',
				base0C = '#e2ffd9',
				base0D = '#b8e9a8',
				base0E = '#d3ffc4',
				base0F = '#d3ffc4',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#82897f',
				fg = '#fafff8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#b8e9a8',
				fg = '#12131a',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#82897f' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e2ffd9', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#d3ffc4',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#b8e9a8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#b8e9a8',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#e2ffd9',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a9fea5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d4ded1' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d4ded1' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#82897f',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
