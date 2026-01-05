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
      colorscheme = "catppuccin-mocha",
    },
  },

  -- catppuccin: colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = { blink_cmp = true },
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
