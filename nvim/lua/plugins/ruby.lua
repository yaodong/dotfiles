return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "zidhuss/neotest-minitest",
    },
    opts = function ()
      return {
        adapters = {
          require("neotest-minitest"),
        },
      }
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "ruby",
        "embedded_template"
      },
    },
  },

    {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "erb-formatter",
      }
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ruby_lsp",
        "rubocop",
      }
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          enabled = true
        },
        rubocop = {
          enabled = true
        }
      }
    }
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
        eruby = { "erb_format" },
      },
      formatters = {
        erb_format = {
          prepend_args = { "--print-width", "120" },
        },
      },
    }
  },

}
