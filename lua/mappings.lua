require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
local opts = { noremap = true, silent = true }



vim.g.clipboard = {
  name = 'win32yank',
  copy = {
    ["+"] = 'win32yank -i --crlf',
    ["*"] = 'win32yank -i --crlf',
  },
  paste = {
    ["+"] = 'win32yank -o --lf',
    ["*"] = 'win32yank -o --lf',
  },
  cache_enabled = 0,
}
map("n", ";", ":", { desc = "CMD enter command mode" })

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



vim.keymap.set('n', '<C-w>', '<Plug>(expand_region_expand)', { remap = true })
vim.keymap.set('v', '<C-w>', '<Plug>(expand_region_expand)', { remap = true })
vim.keymap.set('x', '<C-w>', '<Plug>(expand_region_expand)', { remap = true })

vim.keymap.set('v', '<C-S-w>', '<Plug>(expand_region_shrink)', { remap = true })
vim.keymap.set('x', '<C-S-w>', '<Plug>(expand_region_shrink)', { remap = true })



if vim.fn.argc() == 1 then
  local arg = vim.fn.argv(0)
  local stat = vim.loop.fs_stat(arg)
  if stat and stat.type == "directory" then
    require("nvim-tree.api").tree.toggle({ find_file = true, open = true })
  end
end
-- local function apply_import_actions(diagnostics, index)
--   -- Base case: stop if we've processed all diagnostics
--   if index > #diagnostics then
--     return
--   end
--
--   local diag = diagnostics[index]
--   local bufnr = vim.api.nvim_get_current_buf()
--   local params = {
--     range = diag.range,
--     context = {
--       diagnostics = { diag },
--     },
--   }
--
--   -- Request code actions for the diagnostic
--   vim.lsp.buf_request(bufnr, 'textDocument/codeAction', params, function(err, result, ctx)
--     if err then
--       -- If there's an error, move to the next diagnostic
--       apply_import_actions(diagnostics, index + 1)
--       return
--     end
--
--     if result and #result > 0 then
--       for _, action in ipairs(result) do
--         -- Look for an action that adds an import
--         if string.find(action.title, "Import") then
--           if action.edit then
--             vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
--           elseif action.command then
--             vim.lsp.buf.execute_command(action.command)
--           end
--           break -- Apply the first import action and move on
--         end
--       end
--     end
--
--     -- Process the next diagnostic
--     apply_import_actions(diagnostics, index + 1)
--   end)
-- end
--
-- function auto_import()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local diagnostics = vim.diagnostic.get(bufnr)
--   local unresolved_diagnostics = {}
--
--   -- Filter diagnostics related to unresolved names
--   for _, diag in ipairs(diagnostics) do
--     if string.find(diag.message, "cannot find") or string.find(diag.message, "unresolved") then
--       table.insert(unresolved_diagnostics, diag)
--     end
--   end
--
--   -- Start processing diagnostics from the first one
--   apply_import_actions(unresolved_diagnostics, 1)
-- end

-- vim.api.nvim_buf_set_keymap(0, 'n', '<leader>oi', '<cmd>lua auto_import()<cr>', { noremap = true, silent = true })
