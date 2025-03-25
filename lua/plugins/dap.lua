local function define_colors()
  vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#b91c1c" })
  vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
  vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bold = true })

  vim.fn.sign_define("DapBreakpoint", {
    text = "🔴",
    numhl = "DapBreakpoint",
  })
  vim.fn.sign_define("DapBreakpointCondition", {
    text = "🔴",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
  })
  vim.fn.sign_define("DapBreakpointRejected", {
    text = "🔘",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
  })
  vim.fn.sign_define("DapStopped", {
    text = "🟢",
    linehl = "DapStopped",
    numhl = "DapStopped",
  })
  vim.fn.sign_define("DapLogPoint", {
    text = "🟣",
    linehl = "DapLogPoint",
    numhl = "DapLogPoint",
  })
end
local function setup_default_configurations()
  local dap = require "dap"

  local lldb_configuration = {
    {
      name = "Launch",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
  }

  local netcoredbg_configuration = {
    {
      type = "coreclr",
      name = "Launch .NET Core",
      request = "launch",
      program = function()
        return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
      end,
    },
  }

  dap.configurations.c = lldb_configuration
  dap.configurations.cpp = lldb_configuration
  dap.configurations.rust = lldb_configuration
  dap.configurations.asm = lldb_configuration
  dap.configurations.cs = netcoredbg_configuration

  dap.adapters.coreclr = {
    type = "executable",
    command = "C:/Program Files/netcoredbg/netcoredbg.exe",
    args = { "--interpreter=vscode" },
  }
end


return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    {
      "folke/edgy.nvim",
      lazy = true,
      opts = {},
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      lazy = true,
      config = function()
        require("telescope").load_extension "dap"
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      lazy = true,
      types = true,
    },
    {
      "nvim-neotest/nvim-nio",
      lazy = true
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      lazy = true,
      opts = {
        enabled = true,
      },
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
      require("edgy").close()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    define_colors()
    vim.keymap.set("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
    vim.keymap.set("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
    vim.keymap.set("n", "<F9>", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
    vim.keymap.set("n", "<F8>", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
    vim.keymap.set("n", "<F7>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
      { desc = "Debugger toggle breakpoint" })

    vim.keymap.set("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
    vim.keymap.set("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
    vim.keymap.set("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
    vim.keymap.set("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
    vim.keymap.set("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
      { desc = "Debugger toggle breakpoint" })
    vim.keymap.set("n", "<Leader>dd",
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      { desc = "Debugger set conditional breakpoint" })
    vim.keymap.set("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
    vim.keymap.set("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })
    vim.keymap.set("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

    dap.adapters.lldb = {
      type = "executable",
      command = "/Users/neogoose/.local/share/nvim/mason/bin/codelldb",
      name = "codelldb",
    }
    vim.keymap.set("n", "<F5>", function()
      setup_default_configurations()
      -- when debug is called firstly try to read and/or update launch.json configuration
      -- from the local project which will override all the default configurations
      if vim.fn.filereadable ".vscode/launch.json" then
        require("dap.ext.vscode").load_launchjs(nil, { lldb = { "rust", "c", "cpp" } })
      else
        -- If not possible stick to the default prebuilt configurations
        setup_default_configurations()
      end

      require("dap").continue()
    end)
  end
}
