return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	cmd = "Telescope", -- lazy-load on :Telescope command
	event = "VeryLazy", -- also load on idle so keymaps register
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		local themes = require("telescope.themes")

		-- ─── Setup ───────────────────────────────────────────────────
		telescope.setup({
			defaults = {
				-- Use ripgrep with hidden files, respecting .gitignore
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/",
				},

				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top", -- top feels more natural
						preview_width = 0.55,
						width = { padding = 0 },
						height = { padding = 0 },
					},
				},

				sorting_strategy = "ascending", -- pairs with prompt_position=top
				winblend = 0,
				prompt_prefix = "   ",
				selection_caret = " ",
				multi_icon = " ",

				-- Global ignore patterns (applies to all pickers)
				file_ignore_patterns = {
					"node_modules/",
					"%.git/",
					"%.venv/",
					"%.lock",
					"dist/",
					"build/",
					"__pycache__/",
				},

				path_display = { filename_first = { reverse_directories = true } },

				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-l>"] = actions.select_default,
						["<C-s>"] = actions.select_horizontal, -- open in split
						["<C-v>"] = actions.select_vertical, -- open in vsplit
						["<C-t>"] = actions.select_tab, -- open in new tab
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<C-c>"] = actions.close,
						["<C-u>"] = false, -- allow clearing prompt with C-u
						["<C-d>"] = actions.preview_scrolling_down,
						["<C-f>"] = actions.preview_scrolling_up,
					},
					n = {
						["q"] = actions.close,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					},
				},
			},

			pickers = {
				find_files = {
					hidden = true,
					follow = true, -- follow symlinks
				},

				live_grep = {
					additional_args = { "--hidden" },
				},

				buffers = {
					initial_mode = "normal",
					sort_lastused = true,
					sort_mru = true,
					mappings = {
						n = {
							["d"] = actions.delete_buffer,
							["l"] = actions.select_default,
						},
					},
				},

				marks = { initial_mode = "normal" },
				oldfiles = { initial_mode = "normal" },

				-- Show LSP diagnostics across the whole workspace by default
				diagnostics = { bufnr = 0 },
			},

			extensions = {
				["ui-select"] = themes.get_dropdown({ winblend = 10 }),
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- ─── Load extensions ─────────────────────────────────────────
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		-- ─── Keymaps ─────────────────────────────────────────────────
		local function map(key, fn, desc)
			vim.keymap.set("n", key, fn, { silent = true, noremap = true, desc = desc })
		end

		-- ── Files ──────────────────────────────────────────────────
		map("<leader>sf", builtin.find_files, "Find Files")
		map("<leader>so", builtin.oldfiles, "Recent Files")
		map("<leader>s.", builtin.oldfiles, "Recent Files (.)")

		-- ── Buffers ────────────────────────────────────────────────
		map("<leader>sb", builtin.buffers, "Buffers")
		map("<leader><tab>", builtin.buffers, "Buffers")
		map("<leader>bb", builtin.buffers, "Buffers")

		-- ── Search / Grep ──────────────────────────────────────────
		map("<leader>sh", builtin.help_tags, "Help Tags")
		map("<leader>sk", builtin.keymaps, "Keymaps")
		map("<leader>sc", builtin.commands, "Commands")
		map("<leader>sw", builtin.grep_string, "Grep Word Under Cursor") -- ✅ was <leader>gs (conflict)
		map("<leader>gl", builtin.live_grep, "Live Grep")
		map("<leader>sd", builtin.diagnostics, "Diagnostics")
		map("<leader>sr", builtin.resume, "Resume Last Picker")
		map("<leader>sm", builtin.marks, "Marks")
		map("<leader>s;", builtin.command_history, "Command History")
		map("<leader>s/", builtin.search_history, "Search History")

		-- ── Git ────────────────────────────────────────────────────
		map("<leader>gf", builtin.git_files, "Git Files")
		map("<leader>gc", builtin.git_commits, "Git Commits")
		map("<leader>gcf", builtin.git_bcommits, "Git Buffer Commits")
		map("<leader>gb", builtin.git_branches, "Git Branches")
		map("<leader>gs", builtin.git_status, "Git Status") -- ✅ no longer conflicts

		-- ── LSP Symbols ────────────────────────────────────────────
		map("<leader>sds", function()
			builtin.lsp_document_symbols({
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Property",
				},
			})
		end, "Document Symbols")

		map("<leader>sws", function()
			builtin.lsp_dynamic_workspace_symbols({
				symbols = { "Class", "Function", "Method", "Interface" },
			})
		end, "Workspace Symbols")

		-- ── Contextual searches ────────────────────────────────────
		-- Grep only in open buffers
		map("<leader>s<leader>", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Grep in Open Buffers",
			})
		end, "Grep Open Buffers")

		-- Fuzzy search inside current buffer
		map("<leader>/", function()
			builtin.current_buffer_fuzzy_find(themes.get_dropdown({ previewer = false }))
		end, "Fuzzy Search Buffer")

		-- Neovim config files
		map("<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, "Neovim Config Files")
	end,
}
