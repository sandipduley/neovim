return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  cmd = "Telescope",
  keys = "<leader>",
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

    -- Helper function for keymaps
    local function map_keys(maps)
      for mode, bindings in pairs(maps) do
        for key, action in pairs(bindings) do
          vim.keymap.set(mode, key, action, { silent = true, noremap = true })
        end
      end
    end

    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        prompt_prefix = "   ",
        selection_caret = "❯ ",
        winblend = 5,

        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.6,
            width = { padding = 0 },
            height = { padding = 0 },
          },
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-l>"] = actions.select_default,
            ["<C-c>"] = actions.close,
          },
          n = { ["q"] = actions.close },
        },

        path_display = {
          filename_first = { reverse_directories = true },
        },
      },

      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { "node_modules", ".git", ".venv" },
        },

        buffers = {
          initial_mode = "normal",
          sort_lastused = true,
          mappings = {
            n = {
              ["d"] = function(bufnr)
                actions.delete_buffer(bufnr, { force = true })
              end,
              ["l"] = actions.select_default,
            },
          },
        },

        marks = { initial_mode = "normal" },
        oldfiles = { initial_mode = "normal" },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = themes.get_dropdown(),
      },
    })

    -- Load extensions safely
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")

    -- Keymaps
    -- Keymaps
    map_keys({
      n = {
        -- Buffers & Marks
        ["<leader>sb"] = builtin.buffers, -- Search open buffers
        ["<leader><tab>"] = builtin.buffers, -- Search open buffers (tab shortcut)
        ["<leader>bb"] = builtin.buffers, -- Search open buffers (buffer prefix)
        ["<leader>sm"] = builtin.marks, -- Search marks
        ["<leader>so"] = builtin.oldfiles, -- Search recently opened files

        -- Git
        ["<leader>gf"] = builtin.git_files, -- Search git-tracked files
        ["<leader>gc"] = builtin.git_commits, -- Search git commit log
        ["<leader>gcf"] = builtin.git_bcommits, -- Search commits for current buffer
        ["<leader>gb"] = builtin.git_branches, -- Search and switch git branches
        ["<leader>gS"] = builtin.git_status, -- Search files with git changes

        -- Search
        ["<leader>sf"] = builtin.find_files, -- Search all files (including hidden)
        ["<leader>sh"] = builtin.help_tags, -- Search Neovim help tags
        ["<leader>sg"] = builtin.grep_string, -- Grep for word under cursor
        ["<leader>gl"] = builtin.live_grep, -- Live grep across project
        ["<leader>sd"] = builtin.diagnostics, -- Search LSP diagnostics
        ["<leader>sr"] = builtin.resume, -- Resume last Telescope picker

        -- LSP Symbols
        ["<leader>sds"] = function()
          builtin.lsp_document_symbols({ -- Search LSP symbols in current buffer
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
        end,

        -- Live grep in open files only (not whole project)
        ["<leader>s/"] = function()
          builtin.live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,

        -- Fuzzy search within the current buffer (dropdown, no preview)
        ["<leader>/"] = function()
          builtin.current_buffer_fuzzy_find(themes.get_dropdown({ previewer = false }))
        end,
      },
    })
  end,
}
