return {

  -- install lsp servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- configurate nvim-lspconfig base on then mason configuration
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "black",
        "erb-formatter",
        "lua_ls",
        "pyright",
        "rubocop",
        "ruby_lsp",
        "stimulus_ls",
        "cssls",
        "tailwindcss",
      },
    },
  },

  -- configurate nvim to use lsp servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        ruby_lsp = {
          enabled = true,
        },
        rubocop = {
          enabled = true,
        },
        pyright = {
          enabled = true,
        },
      },
    },
  },
}
