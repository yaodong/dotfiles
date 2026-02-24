return {
  -- install formatters
  {
    "mason-org/mason.nvim",
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
        javascript = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        svg = { "prettier_svg" },
      },
      formatters = {
        erb_format = {
          prepend_args = { "--print-width", "120" },
        },
        prettier_svg = {
          command = "prettier",
          args = { "--parser", "html", "--print-width", "512" },
        },
      },
    },
  },
}
