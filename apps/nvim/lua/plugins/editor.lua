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

  -- telescope undo tree
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo History" },
    },
    opts = {
      extensions = {
        undo = {
          use_delta = true,
          use_custom_command = nil,
          side_by_side = false,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
}
