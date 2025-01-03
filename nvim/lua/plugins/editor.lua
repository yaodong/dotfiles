return {

  -- animations
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },

  -- incline
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("incline").setup()
    end,
  },

  -- formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        erb_format = {
          prepend_args = { "--print-width", "120" },
        },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "zidhuss/neotest-minitest",
    },
    opts = function(_, opts)
      opts.adapters = {
        require("neotest-minitest"),
      }
    end,
  },
}
