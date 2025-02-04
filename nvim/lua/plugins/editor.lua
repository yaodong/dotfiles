return {
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
  },

  -- programming language parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "ruby",
        "embedded_template",
      },
    },
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
    },
  },

  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/neotest-python",
      "zidhuss/neotest-minitest",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python"),
          require("neotest-minitest"),
        },
      }
    end,
  },
}
