return {
  -- install formatters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "erb-formatter",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
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
}
