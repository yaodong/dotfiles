return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "pyright"
      }
    },
  },

  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = function ()
      return {
        adapters = {
          require("neotest-python"),
        },
      }
    end
  }
}
