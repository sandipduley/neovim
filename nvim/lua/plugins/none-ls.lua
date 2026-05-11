return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local mason_null_ls = require("mason-null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- ── Mason: auto-install every tool declared below ──────────────────────────
    mason_null_ls.setup({
      ensure_installed = {
        "prettier", -- JS / TS / HTML / CSS / JSON / YAML / Markdown
        "stylua", -- Lua
        "ruff", -- Python (format + lint)
        "gofumpt", -- Go – strict gofmt superset
        "goimports", -- Go – organise imports
        "shfmt", -- Shell
        "sqlfluff", -- SQL
        "hadolint", -- Dockerfile
        "markdownlint", -- Markdown lint
      },
      automatic_installation = true,
    })

    -- ── Format-on-save toggle ──────────────────────────────────────────────────
    local fmt_enabled = true

    vim.keymap.set("n", "<leader>of", function()
      fmt_enabled = not fmt_enabled
      vim.notify("Format-on-save " .. (fmt_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
    end, { desc = "None-ls: toggle format-on-save" })

    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
    end, { desc = "None-ls: format buffer / range" })

    -- ── Sources ────────────────────────────────────────────────────────────────
    null_ls.setup({
      default_timeout = 5000,
      debug = false,

      sources = {

        -- ── Web ────────────────────────────────────────────────────────────────
        formatting.prettier.with({
          filetypes = {
            "html",
            "css",
            "scss",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "astro",
            "json",
            "jsonc",
            "yaml",
            "toml",
            "markdown",
            "mdx",
            "graphql",
          },
          extra_args = function(params)
            local rc = vim.fn.findfile(".prettierrc", params.root .. ";")
            if rc ~= "" then
              return {}
            end
            return {
              "--single-quote",
              "--trailing-comma",
              "es5",
              "--print-width",
              "100",
            }
          end,
          condition = function(utils)
            return not utils.root_has_file({ ".prettierignore" })
              or not utils.root_has_file({ ".prettierrc.js", ".prettierrc.cjs" })
          end,
        }),

        -- ── Lua ────────────────────────────────────────────────────────────────
        -- Fix #13: removed `or true` that made condition always pass
        formatting.stylua.with({
          extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }),

        -- ── Python ─────────────────────────────────────────────────────────────
        require("none-ls.formatting.ruff_format").with({
          extra_args = { "--line-length", "100" },
        }),
        require("none-ls.diagnostics.ruff").with({
          extra_args = { "--select", "E,F,W,I,N,UP,B,C4,SIM,RUF" },
        }),

        -- ── Dockerfile ─────────────────────────────────────────────────────────
        diagnostics.hadolint,

        -- ── Markdown ───────────────────────────────────────────────────────────
        diagnostics.markdownlint.with({
          extra_args = { "--disable", "MD013" },
        }),
      },

      -- Fix: replaced deprecated vim.api.nvim_buf_set_option
      on_attach = function(_, bufnr)
        vim.bo[bufnr].formatexpr = "" -- Let null-ls own gq
      end,
    })
  end,
}
