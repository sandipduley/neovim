return {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", desc = "Undotree: toggle" },
	},
	config = function()
		-- ── Helpers ───────────────────────────────────────────────────────────────
		local function find_undotree_win()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ok, ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
				if ok and ft == "undotree" then
					return win
				end
			end
		end

		local function resize_undotree(win)
			if not win or not vim.api.nvim_win_is_valid(win) then
				return
			end
			vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.3))
			vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.6))
		end

		-- ── Resize on VimResized (created once) ───────────────────────────────────
		vim.api.nvim_create_augroup("UndotreeResize", { clear = true })
		vim.api.nvim_create_autocmd("VimResized", {
			group = "UndotreeResize",
			callback = function()
				resize_undotree(find_undotree_win())
			end,
		})

		-- ── Keymap ────────────────────────────────────────────────────────────────
		vim.keymap.set("n", "<leader>u", function()
			vim.cmd.UndotreeToggle()
			vim.defer_fn(function()
				local win = find_undotree_win()
				if not win then
					return
				end
				vim.api.nvim_set_current_win(win)
				resize_undotree(win)
				vim.wo[win].number = false
				vim.wo[win].relativenumber = false
				vim.cmd("hi! link UndoTreeCurrentLine CursorLine")
			end, 50)
		end, { desc = "Undotree: toggle" })
	end,
}
