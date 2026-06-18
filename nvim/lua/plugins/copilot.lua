return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },

  {
    "giuxtaposition/blink-cmp-copilot",
  },

  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = CompletionItemKind["Copilot"]
              if type(kind_idx) ~= "number" then
                for idx, name in ipairs(CompletionItemKind) do
                  if name == "Copilot" then
                    kind_idx = idx
                    break
                  end
                end
              end
              if type(kind_idx) ~= "number" then
                kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Copilot"
              end
              CompletionItemKind["Copilot"] = kind_idx
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
      },
    },
  },
}
