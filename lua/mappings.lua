require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
local opts = { noremap = true, silent = true }



-- Use the system clipboard
vim.o.clipboard = 'unnamedplus'

-- Move cursor and select down
vim.api.nvim_set_keymap('v', '<S-j>', 'j', opts)
vim.api.nvim_set_keymap('n', '<S-j>', 'Vj', opts)

-- Move cursor and select up
vim.api.nvim_set_keymap('v', '<S-k>', 'k', opts)
vim.api.nvim_set_keymap('n', '<S-k>', 'Vk', opts)

-- Move cursor and select right
vim.api.nvim_set_keymap('v', '<S-l>', 'l', opts)
vim.api.nvim_set_keymap('n', '<S-l>', 'vl', opts)

-- Move cursor and select left
vim.api.nvim_set_keymap('v', '<S-h>', 'h', opts)
vim.api.nvim_set_keymap('n', '<S-h>', 'vh', opts)

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })

vim.g.mapleader = ' ' -- Set leader key to space

-- Move to the next tab
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<CR>', opts)

-- Move to the previous tab
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprevious<CR>', opts)

-- Close the current tab
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<CR>', opts)

-- Open a new tab
vim.api.nvim_set_keymap('n', '<leader>te', ':tabedit<CR>', opts)

-- Switch to the next buffer
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true })

-- Switch to the previous buffer
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-j>', vim.diagnostic.open_float, { desc = "Show diagnostic message" })
-- For hover documentation
vim.keymap.set('n', '<leader>df', vim.lsp.buf.hover, { desc = 'definition hover' })

-- For signature help (parameters)
vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature Help' })

vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature Help' })

vim.api.nvim_set_keymap('n', '<C-w>', '<Plug>(expand_region_expand)', {})
vim.api.nvim_set_keymap('v', '<C-w>', '<Plug>(expand_region_expand)', {})
vim.api.nvim_set_keymap('x', '<C-w>', '<Plug>(expand_region_expand)', {})

vim.api.nvim_set_keymap('v', '<C-S-w>', '<Plug>(expand_region_shrink)', {})
vim.api.nvim_set_keymap('x', '<C-S-w>', '<Plug>(expand_region_shrink)', {})

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
