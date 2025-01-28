vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.shell = "pwsh"
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- local Plug = vim.fn['plug#']
--
-- vim.call('plug#begin')
--
-- Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
-- Plug 'rafi/awesome-vim-colorschemes'
-- Plug 'ap/vim-css-color'
-- Plug 'SirVer/ultisnips'
-- Plug 'honza/vim-snippets'
-- Plug 'preservim/nerdtree'
-- Plug 'jiangmiao/auto-pairs'
-- Plug 'tpope/vim-unimpaired'
-- vim.call('plug#end')


local lazy_config = require "configs.lazy"
-- load plugins
require("lazy").setup({
  { import = "plugins" },
}, lazy_config)
require("transparent").setup({
  -- table: default groups
  groups = {
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  -- table: additional groups that should be cleared
  extra_groups = {},
  -- table: groups you don't want to clear
  exclude_groups = {},
  -- function: code to be executed after highlight groups are cleared
  -- Also the user event "TransparentClear" will be triggered
  on_clear = function() end,
})
require 'nvim-treesitter.configs'.setup {

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,
  ignore_install = { "rust" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

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

-- Color schemes should be loaded after plug#end().
-- We prepend it with 'silent!' to ignore errors when it's not yet installed.
vim.cmd('silent! colorscheme seoul256')
vim.diagnostic.setqflist()


-- Add this section after plugins setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp" }, -- Ensure Omnisharp is installed via Mason
})

-- Configure LSP servers
local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Omnisharp setup
lspconfig.omnisharp.setup({
  cmd = {
    "dotnet",
    vim.fn.expand("C:/Users/Administrator/AppData/Local/nvim-data/mason/packages/omnisharp/libexec/Omnisharp.dll"),
  },
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", "*.cs"),
  enable_roslyn_analyzers = true,
})
--  require('mason').setup()
--  require('mason-lspconfig').setup({
--      handlers = {
--          lspzero.default_setup,
--          lua_ls = function()
--              lspconfig.lua_ls.setup(lspzero.nvim_lua_ls())
--          end,
--          omnisharp = function()
--              lspconfig.omnisharp.setup({
--                  handlers = { ['textDocument/definition'] = require('omnisharp_extended').handler }
--              })
--          end
--      }
--  })

local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope configuration
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
  -- Map of filetype to formatters
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    go = { "goimports", "gofmt" },
    -- You can also customize some of the format options for the filetype
    rust = { "rustfmt", lsp_format = "fallback" },
    -- You can use a function here to determine the formatters dynamically
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    -- Use the "*" filetype to run formatters on all filetypes.
    ["*"] = { "codespell" },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },
  -- Set this to change the default values when calling conform.format()
  -- This will also affect the default values for format_on_save/format_after_save
  default_format_opts = {
    lsp_format = "fallback",
  },
  -- If this is set, Conform will run the formatter on save.
  -- It will pass the table to conform.format().
  -- This can also be a function that returns the table.
  format_on_save = {
    -- I recommend these options. See :help conform.format for details.
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  -- If this is set, Conform will run the formatter asynchronously after save.
  -- It will pass the table to conform.format().
  -- This can also be a function that returns the table.
  format_after_save = {
    lsp_format = "fallback",
  },
  -- Set the log level. Use `:ConformInfo` to see the location of the log file.
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
  -- Conform will notify you when no formatters are available for the buffer
  notify_no_formatters = true,
  -- Custom formatters and overrides for built-in formatters
  formatters = {
    my_formatter = {
      -- This can be a string or a function that returns a string.
      -- When defining a new formatter, this is the only field that is required
      command = "my_cmd",
      -- A list of strings, or a function that returns a list of strings
      -- Return a single string instead of a list to run the command in a shell
      args = { "--stdin-from-filename", "$FILENAME" },
      -- If the formatter supports range formatting, create the range arguments here
      range_args = function(self, ctx)
        return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
      end,
      -- Send file contents to stdin, read new contents from stdout (default true)
      -- When false, will create a temp file (will appear in "$FILENAME" args). The temp
      -- file is assumed to be modified in-place by the format command.
      stdin = true,
      -- A function that calculates the directory to run the command in
      cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
      -- When cwd is not found, don't run the formatter (default false)
      require_cwd = true,
      -- When stdin=false, use this template to generate the temporary file that gets formatted
      tmpfile_format = ".conform.$RANDOM.$FILENAME",
      -- When returns false, the formatter will not be used
      condition = function(self, ctx)
        return vim.fs.basename(ctx.filename) ~= "README.md"
      end,
      -- Exit codes that indicate success (default { 0 })
      exit_codes = { 0, 1 },
      -- Environment variables. This can also be a function that returns a table.
      env = {
        VAR = "value",
      },
      -- Set to false to disable merging the config with the base definition
      inherit = true,
      -- When inherit = true, add these additional arguments to the beginning of the command.
      -- This can also be a function, like args
      prepend_args = { "--use-tabs" },
      -- When inherit = true, add these additional arguments to the end of the command.
      -- This can also be a function, like args
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
vim.o.ttimeoutlen = 0
vim.o.timeoutlen = 0
