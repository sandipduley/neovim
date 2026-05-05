return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- No need to load before a file is open
  opts = {
    -- ── Gutter signs ────────────────────────────────────────────────────────
    signs = {
      add = { text = "▋" },
      change = { text = "▋" },
      delete = { text = "▼" },
      topdelete = { text = "▲" },
      changedelete = { text = "▋" },
      untracked = { text = "▋" },
    },
    signs_staged = {
      add = { text = "▋" },
      change = { text = "▋" },
      delete = { text = "▼" },
      topdelete = { text = "▲" },
      changedelete = { text = "▋" },
    },
    signs_staged_enable = true,

    -- ── Blame ────────────────────────────────────────────────────────────────
    current_line_blame = false, -- Toggle with <leader>gb
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 400, -- ms before blame appears
      ignore_whitespace = true,
    },
    current_line_blame_formatter = " <author>, <author_time:%d %b %Y> · <summary>",

    -- ── Behaviour ────────────────────────────────────────────────────────────
    signcolumn = true,
    numhl = false, -- Flip to true to highlight line numbers instead
    linehl = false,
    word_diff = false, -- Toggle live with <leader>gw
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = true,
    update_debounce = 100,
    max_file_length = 40000, -- Skip files > 40 k lines

    -- ── Preview ───────────────────────────────────────────────────────────────
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },

    -- ── Keymaps (on_attach gives us buffer-local maps for free) ───────────────
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigation: jump between hunks, wrapping at file boundaries
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Git: next hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Git: prev hunk")

      map("n", "]H", function()
        gs.nav_hunk("last")
      end, "Git: last hunk")
      map("n", "[H", function()
        gs.nav_hunk("first")
      end, "Git: first hunk")

      -- Hunk actions
      map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Git: stage hunk")
      map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Git: reset hunk")
      map("n", "<leader>gS", gs.stage_buffer, "Git: stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Git: reset buffer")
      map("n", "<leader>gu", gs.undo_stage_hunk, "Git: undo stage hunk")

      -- Preview
      map("n", "<leader>gp", gs.preview_hunk, "Git: preview hunk")
      map("n", "<leader>gP", gs.preview_hunk_inline, "Git: preview hunk inline")

      -- Blame
      map("n", "<leader>gb", function()
        gs.toggle_current_line_blame()
      end, "Git: toggle line blame")
      map("n", "<leader>gB", function()
        gs.blame_line({ full = true }) -- Full commit message in float
      end, "Git: blame line (full)")

      -- Diff
      map("n", "<leader>gd", gs.diffthis, "Git: diff this")
      map("n", "<leader>gD", function()
        gs.diffthis("~") -- Diff against last commit
      end, "Git: diff against ~")
      map("n", "<leader>gw", gs.toggle_word_diff, "Git: toggle word diff")

      -- Text object: ih = inside hunk (works in operator-pending + visual)
      map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>", "Git: select hunk")
    end,
  },
}
