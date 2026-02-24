local function get_theme()
  local f = io.open(os.getenv("HOME") .. "/.config/theme/current", "r")
  if f then
    local theme = f:read("*l")
    f:close()
    if theme == "light" then
      return "latte"
    end
  end
  return "mocha"
end

local flavour = get_theme()

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
      colorscheme = "catppuccin-" .. flavour,
    },
  },

  -- catppuccin: colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = flavour,
      integrations = {
        blink_cmp = true,
        -- Explicitly disable bufferline integration to avoid missing module error
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
