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

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = { settings = { css = { lint = { unknownAtRules = "ignore" } } } },
      },
    },
  },

  {
    "echasnovski/mini.trailspace",
    version = "*",
  },

  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      local ls = require("luasnip")
      ls.filetype_extend("eruby", { "html" })
      return opts
    end,
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>su", vim.cmd.UndotreeToggle, desc = "Undo Tree" },
    },
  },
}
