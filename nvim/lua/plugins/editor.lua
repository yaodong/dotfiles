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
}
