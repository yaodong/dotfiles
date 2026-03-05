local function is_light()
  local f = io.open(os.getenv("HOME") .. "/.config/theme/current", "r")
  if f then
    local theme = f:read("*l")
    f:close()
    return theme == "light"
  end
  return false
end

local light = is_light()

if light then
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
      colorscheme = light and "solarized" or "catppuccin-mocha",
    },
  },

  -- solarized: light colorscheme
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
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
}
