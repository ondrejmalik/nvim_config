return {
  { 'akinsho/toggleterm.nvim', version = "*", config = true },
  {
    event = "VeryLazy",
    "terrortylor/nvim-comment"
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
  },
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    "ldelossa/nvim-dap-projects",
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
    ft = "rust",
    config = function()
    end
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
    end,
  },
  -- Add nvim-cmp and dependencies
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",       -- Buffer completions
      "hrsh7th/cmp-path",         -- Path completions
      "hrsh7th/cmp-cmdline",      -- Command-line completions
      "hrsh7th/cmp-nvim-lsp",     -- LSP completions
      "saadparwaiz1/cmp_luasnip", -- Snippet completions
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "neovim/nvim-lspconfig",    -- LSP configuration
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-s>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ['<C-x>'] = cmp.mapping(function()
            if cmp.visible_docs() then
              cmp.close_docs()
            else
              cmp.open_docs()
            end
            open_docs_in_split()
          end, { 'i' }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "crates" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered({
            focusable = false,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            -- Other window options...
          }),
          documentation = {
            focusable = false,
            border = 'rounded',
            -- Force the window to stay open even when losing focus
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
        },
        preselect = cmp.PreselectMode.None,
        experimental = {
          ghost_text = false,
        },
      })
    end
  },
  {
    "xiyaowong/transparent.nvim",
    event = "VimEnter",
    config = function()
      require("transparent").setup({
        enable = true,      -- Enable transparency
        extra_groups = {    -- Additional groups to clear (optional)
          "NormalFloat",    -- Floating windows
          "NvimTreeNormal", -- Example for NvimTree
          "NvimTreeNormalNC",
          "NvimTreeEndOfBuffer",
        },
        exclude = {}, -- Exclude specific groups from clearing
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "terryma/vim-expand-region",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css"
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    lazy = true,
    keys = {
      { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Quick Menu" },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    end,
    branch = "harpoon2",
    cmd = { "Harpoon", "HarpoonAdd", "HarpoonToggle", "HarpoonQuickMenu" },
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-tree/nvim-tree.lua",
    -- Lazy-load on these commands
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = {
          side = "right",
          float = {
            enable = false,
          },
        },
      })
    end,
  },
  {
    "saecki/crates.nvim",
    -- Lazy-load when opening a file of type 'toml'
    ft = "toml",
    config = function()
      require("crates").setup({
        completion = {
          crates = {
            enabled = true,
          },
        },
        -- other settings can be added here...
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = "LspAttach", -- Load only when LSP attaches to a buffer
    config = function()
      require("mason").setup()
    end,
  }
}
