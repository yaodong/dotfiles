return {

  -- configurate nvim-lspconfig base on then mason configuration
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "rubocop",
        "ruby_lsp",
        "cssls",
        "tailwindcss",
        "yamlls",
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
        stylua = {
          enabled = false,
        },
      },
      diagnostics = {
        virtual_text = false,
      },
    },
  },
}
