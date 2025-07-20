-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Rails test keybindings (fallback if neotest has issues)
vim.keymap.set("n", "<leader>tR", function()
  local file = vim.fn.expand("%")
  vim.cmd("terminal bundle exec rails test " .. file)
end, { desc = "Run Rails test file" })

vim.keymap.set("n", "<leader>tL", function()
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  vim.cmd("terminal bundle exec rails test " .. file .. ":" .. line)
end, { desc = "Run Rails test at line" })
