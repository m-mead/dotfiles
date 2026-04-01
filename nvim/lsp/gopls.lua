return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_markers = { "go.work", "go.mod" },
  settings = {
    gopls = {
      semanticTokens = true,
      staticcheck = true,
    },
  },
}
