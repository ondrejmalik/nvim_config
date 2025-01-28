return {
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    lazy = false,
  },
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
    ["rust-analyzer"] = {
      cargo = {
        allFeature = true,
      }
    }
  },
  -- Add nvim-cmp and dependencies
  {
    "hrsh7th/nvim-cmp",
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
          { name = "nvim_lsp" },
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
  }, {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      enable = true,     -- Enable transparency
      extra_groups = {   -- Additional groups to clear (optional)
        "NormalFloat",   -- Floating windows
        "NvimTreeNormal" -- Example for NvimTree
      },
      exclude = {},      -- Exclude specific groups from clearing
    })
  end,
},
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig"
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "terryma/vim-expand-region",
    event = 'BufRead',
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
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
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  }
}
