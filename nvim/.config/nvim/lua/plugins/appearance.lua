local function is_dark()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") ~= nil
  end
  return false
end

local dark = is_dark()

if not dark then
  vim.o.background = "light"
end

return {

  {
    "folke/noice.nvim",
    opts = {
      cmdline = { format = { cmdline = { lang = "" } } },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = dark and "catppuccin-mocha" or "alabaster",
    },
  },

  -- alabaster: light colorscheme
  {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 1000,
  },

  -- catppuccin: dark colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        blink_cmp = true,
        native_lsp = { enabled = true },
        bufferline = false,
      },
    },
  },

  -- dark-notify: auto-switch colorscheme with macOS appearance
  {
    "cormacrelf/dark-notify",
    config = function()
      require("dark_notify").run({
        schemes = {
          dark = "catppuccin-mocha",
          light = "alabaster",
        },
      })
    end,
  },

  -- incline: creating lightweight floating statuslines
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("incline").setup({
        hide = {
          cursorline = true,
        },
      })
    end,
  },

  -- Disable unused default theme
  { "folke/tokyonight.nvim", enabled = false },
}
