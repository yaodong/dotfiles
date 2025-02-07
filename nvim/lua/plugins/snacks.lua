return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>o",
        function()
          Snacks.picker.pickers({
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            layout = {
              preset = "vscode",
            },
            win = {
              input = {
                keys = {
                  ["dd"] = "bufdelete",
                  ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
                },
              },
              list = { keys = { ["dd"] = "bufdelete" } },
            },
          })
        end,
        desc = "Buffers",
      },
    },
  },
}
