return {
  "mfussenegger/nvim-dap",

  dependencies = {
    -- UI for debugger
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",

    -- Auto-install debuggers
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Language-specific debuggers
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Automatic Debugger Installation

    require("mason-nvim-dap").setup({
      automatic_setup = true,
      automatic_installation = true,
      ensure_installed = { "debugpy" }, -- Python debugger
      handlers = {},
    })

    -- Debugging Keymaps

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })

    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: Toggle Result Window" })

    -- DAP UI Configuration

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    -- Auto Open/Close DAP UI

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Language-specific Setup

    require("dap-python").setup()
  end,
}
