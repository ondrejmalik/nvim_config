vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.shell = "pwsh"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"
require("lazy").setup({
  { import = "plugins" },
}, lazy_config)
require("transparent").setup({
  groups = {
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {},
  exclude_groups = {},

  on_clear = function() end,
})
require 'nvim-treesitter.configs'.setup {

  sync_install = false,

  auto_install = false,
  ignore_install = { "rust" },

  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = true,
  },
}
-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

local vim = vim

vim.cmd('silent! colorscheme seoul256')
vim.diagnostic.setqflist()

-- require("mason").setup()
-- require("mason-lspconfig").setup({
--   ensure_installed = { "omnisharp" }, -- Ensure Omnisharp is installed via Mason
-- })

local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.omnisharp.setup({
  cmd = {
    "dotnet",
    vim.fn.expand("C:/Users/Administrator/AppData/Local/nvim-data/mason/packages/omnisharp/libexec/Omnisharp.dll"),
  },
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", "*.cs"),
  enable_roslyn_analyzers = true,
})

local harpoon = require('harpoon')
harpoon:setup({})

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
  { desc = "Open harpoon window" })
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "gofmt" },
    rust = { "rustfmt", lsp_format = "fallback" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  format_after_save = {
    lsp_format = "fallback",
  },

  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
  notify_no_formatters = true,
  formatters = {
    my_formatter = {
      command = "my_cmd",
      args = { "--stdin-from-filename", "$FILENAME" },
      range_args = function(self, ctx)
        return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
      end,
      stdin = true,
      cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
      require_cwd = true,
      tmpfile_format = ".conform.$RANDOM.$FILENAME",
      condition = function(self, ctx)
        return vim.fs.basename(ctx.filename) ~= "README.md"
      end,
      exit_codes = { 0, 1 },
      env = {
        VAR = "value",
      },
      inherit = true,
      prepend_args = { "--use-tabs" },
      append_args = { "--trailing-comma" },
    },
    -- These can also be a function that returns the formatter
    other_formatter = function(bufnr)
      return {
        command = "my_cmd",
      }
    end,
  },
})

-- You can set formatters_by_ft and formatters directly
require("conform").formatters_by_ft.lua = { "stylua" }
require("conform").formatters.my_formatter = {
  command = "my_cmd",
}


require("CopilotChat").setup {


  model = 'claude-3.7-sonnet', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
  mappings = {
    complete = {
      insert = '<Tab>',
    },
    close = {
      normal = 'CQ',
      insert = '<C-c>',
    },
    reset = {
      normal = '<C-l>',
      insert = '<C-l>',
    },
    submit_prompt = {
      normal = '<leader>ccc',
      insert = '<C-s>',
    },
    toggle_sticky = {
      normal = 'grr',
    },
    clear_stickies = {
      normal = 'grx',
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>',
    },
    jump_to_diff = {
      normal = 'gj',
    },
    quickfix_answers = {
      normal = 'gqa',
    },
    quickfix_diffs = {
      normal = 'gqd',
    },
    yank_diff = {
      normal = 'gy',
      register = '"', -- Default register to use for yanking
    },
    show_diff = {
      normal = 'gd',
      full_diff = false, -- Show full diff instead of unified diff when showing diff window
    },
    show_info = {
      normal = 'gi',
    },
    show_context = {
      normal = 'gc',
    },
    show_help = {
      normal = 'gh',
    },
  },
}
vim.keymap.set('n', '<leader>ccq', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, {
      selection = require("CopilotChat.select").buffer
    })
  end
end, { desc = "CopilotChat - Quick chat" })

vim.keymap.set('n', '<leader>cct', function()
  require("CopilotChat").toggle()
end, { desc = "CopilotChat - Quick chat" })
-- vim.opt.shell = "pwsh"
--require("toggleterm").setup({
--  open_mapping = [[<c-\>]], -- change this mapping if you prefer another key
--  direction = "float",      -- use a floating window
--  float_opts = {
--    border = "curved",      -- or "double", "single", etc.
--  },
--  shell = "cmd",            -- ensure PowerShell is used on Windows
--})
--
--local Terminal = require("toggleterm.terminal").Terminal
--
--local lazygit = Terminal:new({
--  cmd = "winpty lazygit", -- command to run lazygit (ensure it's in your PATH)
--  direction = "float",
--  float_opts = {
--    border = "curved",
--  },
--  hidden = true, -- start hidden and toggle on demand
--})
--
--function _LAZYGIT_TOGGLE()
--  lazygit:toggle()
--end
--
--vim.api.nvim_set_keymap("n", "<leader>ccg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>v", ":vsplit | resize +5 | term<CR>i", { noremap = true, silent = true })
vim.o.ttimeoutlen = 0
vim.o.timeoutlen = 0

vim.opt.cmdheight = 1

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = vim.api.nvim_create_augroup(
    'cmdheight_1_on_cmdlineenter',
    { clear = true }
  ),
  desc = 'Don\'t hide the status line when typing a command',
  command = ':set cmdheight=1',
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = vim.api.nvim_create_augroup(
    'cmdheight_0_on_cmdlineleave',
    { clear = true }
  ),
  desc = 'Hide cmdline when not typing a command',
  command = ':set cmdheight=0',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup(
    'hide_message_after_write',
    { clear = true }
  ),
  desc = 'Get rid of message after writing a file',
  pattern = { '*' },
  command = 'redrawstatus',
})
