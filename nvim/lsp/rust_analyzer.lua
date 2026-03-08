return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      procMacro = {
        enable = false,
      },
      cargo = {
        buildScripts = {
          enable = false,
        },
      },
    },
  },
}
