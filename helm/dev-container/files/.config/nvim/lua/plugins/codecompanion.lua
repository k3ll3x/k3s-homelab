if true then
  return {}
end

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    strategies = {
      cmd = {
        adapter = "ollama",
        model = "codellama",
      },

      chat = {
        adapter = "ollama",
        model = "llama3.1:8b",
      },

      inline = {
        adapter = "ollama",
        model = "phi4-mini",
      },
    },
  },
}
