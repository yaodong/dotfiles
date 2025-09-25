-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Rails test keybindings (fallback if neotest has issues)
local function run_rails_test(target)
  if not target or target == "" then
    vim.notify("No file name for Rails test", vim.log.levels.WARN)
    return
  end
  vim.cmd("terminal bundle exec rails test " .. vim.fn.shellescape(target))
end

vim.keymap.set("n", "<leader>tR", function()
  run_rails_test(vim.fn.expand("%:p"))
end, { desc = "Run Rails test file" })

vim.keymap.set("n", "<leader>tL", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  run_rails_test(string.format("%s:%d", file, line))
end, { desc = "Run Rails test at line" })
