return {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", desc = "Undotree: toggle / focus" },
	},

	-- ── Global options (must live in `init`, before the plugin loads) ──────────
	init = function()
		vim.g.undotree_WindowLayout = 2 -- Tree left, diff panel below tree
		vim.g.undotree_SplitWidth = 35 -- Starting width (overridden by dynamic resize)
		vim.g.undotree_DiffpanelHeight = 12
		vim.g.undotree_SetFocusWhenToggle = 0 -- We handle focus ourselves
		vim.g.undotree_ShortIndicators = 1 -- Compact timestamps: "1h", "3d" …
		vim.g.undotree_RelativeTimestamp = 1
		vim.g.undotree_HelpLine = 0 -- Hide "press ? for help" noise
		vim.g.undotree_TreeNodeShape = "◉"
		vim.g.undotree_TreeVertShape = "│"
		vim.g.undotree_TreeSplitShape = "╱"
		vim.g.undotree_TreeReturnShape = "╲"
	end,

	config = function()
		-- ── Persistent undo ───────────────────────────────────────────────────────
		-- Without this every undo history is lost when the buffer closes.
		local undodir = vim.fn.stdpath("data") .. "/undotree"
		if vim.fn.isdirectory(undodir) == 0 then
			vim.fn.mkdir(undodir, "p")
		end
		vim.opt.undodir = undodir
		vim.opt.undofile = true
		vim.opt.undolevels = 10000 -- Keep up to 10 000 change records per file
		vim.opt.undoreload = 100000 -- Preserve history when reloading files ≤ 100 k lines

		-- ── Helpers ───────────────────────────────────────────────────────────────
		---Find a visible window whose buffer has the given filetype.
		---@param ft string
		---@return integer|nil window handle
		local function find_win_by_ft(ft)
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ok, buf_ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
				if ok and buf_ft == ft then
					return win
				end
			end
		end

		---Resize the undotree panel to 28 % of the current terminal width.
		---@param win integer|nil
		local function resize_undotree(win)
			if not win or not vim.api.nvim_win_is_valid(win) then
				return
			end
			vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.28))
		end

		---Apply visual / UI options to the undotree window.
		---@param win integer|nil
		local function apply_win_opts(win)
			if not win or not vim.api.nvim_win_is_valid(win) then
				return
			end
			local wo = vim.wo[win]
			wo.number = false
			wo.relativenumber = false
			wo.signcolumn = "no"
			wo.foldcolumn = "0"
			wo.cursorline = true
			wo.wrap = false
			wo.winfixwidth = true -- Prevent other splits from stealing width
		end

		-- ── Semantic highlight links ───────────────────────────────────────────────
		-- Tie undotree colours to your existing theme so they stay consistent
		-- across colorscheme switches.
		local function setup_highlights()
			local links = {
				UndotreeCurrentLine = "CursorLine",
				UndotreeBranch = "Comment",
				UndotreeNode = "Special",
				UndotreeNodeCurrent = "Title",
				UndotreeSavedBig = "DiagnosticOk",
				UndotreeSavedSmall = "DiagnosticOk",
				UndotreeTimeStamp = "NonText",
				UndotreeSeq = "Identifier",
				UndotreeNext = "MoreMsg",
				UndotreeCurrentReturn = "MoreMsg",
				UndotreeHead = "Function",
			}
			for group, link in pairs(links) do
				vim.api.nvim_set_hl(0, group, { link = link, default = true })
			end
		end

		-- ── Autocmds ──────────────────────────────────────────────────────────────
		local ag = vim.api.nvim_create_augroup("UndotreeEnhanced", { clear = true })

		-- Keep the panel width proportional when the terminal is resized.
		vim.api.nvim_create_autocmd("VimResized", {
			group = ag,
			callback = function()
				resize_undotree(find_win_by_ft("undotree"))
			end,
		})

		-- Re-apply opts + highlights whenever an undotree buffer enters any window.
		-- Needed because UndotreeToggle recreates the window each time.
		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = ag,
			callback = function()
				local win = find_win_by_ft("undotree")
				if win then
					apply_win_opts(win)
					setup_highlights()
				end
			end,
		})

		-- Register `q` inside the undotree buffer to close the panel.
		-- Done via FileType so the mapping survives buffer recreation.
		vim.api.nvim_create_autocmd("FileType", {
			group = ag,
			pattern = "undotree",
			callback = function(ev)
				vim.keymap.set("n", "q", vim.cmd.UndotreeToggle, {
					buffer = ev.buf,
					silent = true,
					desc = "Undotree: close",
				})
			end,
		})

		-- ── Smart 3-state toggle ──────────────────────────────────────────────────
		--  State 1 – panel closed          → open it and focus it
		--  State 2 – panel open, not focused → move focus to it
		--  State 3 – panel open, focused    → close it
		vim.keymap.set("n", "<leader>u", function()
			local tree_win = find_win_by_ft("undotree")
			local cur_win = vim.api.nvim_get_current_win()
			local cur_buf = vim.api.nvim_win_get_buf(cur_win)
			local cur_ft = vim.api.nvim_get_option_value("filetype", { buf = cur_buf })

			-- State 3: focused on the tree → close
			if cur_ft == "undotree" then
				vim.cmd.UndotreeToggle()
				return
			end

			-- State 2: tree already open → just move focus
			if tree_win then
				vim.api.nvim_set_current_win(tree_win)
				return
			end

			-- State 1: tree closed → open, then configure
			vim.cmd.UndotreeToggle()
			vim.defer_fn(function()
				local win = find_win_by_ft("undotree")
				if not win then
					return
				end
				resize_undotree(win)
				apply_win_opts(win)
				setup_highlights()
				vim.api.nvim_set_current_win(win)
			end, 50)
		end, { desc = "Undotree: toggle / focus" })
	end,
}
