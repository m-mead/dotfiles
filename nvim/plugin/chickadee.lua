require("custom.chickadee").setup({
  { src = "https://github.com/tree-sitter/tree-sitter-go.git",         ft = "go",         version = "v0.25.0" },
  { src = "https://github.com/tree-sitter/tree-sitter-javascript.git", ft = "javascript", version = "v0.25.0" },
  { src = "https://github.com/tree-sitter/tree-sitter-python.git",     ft = "python",     version = "v0.25.0" },
  { src = "https://github.com/tree-sitter/tree-sitter-rust.git",       ft = "rust",       version = "v0.24.2" },
  {
    src = "https://github.com/tree-sitter/tree-sitter-typescript.git",
    ft = "typescript",
    version = "v0.23.2",
    root = function(p)
      return p .. "/typescript"
    end
  },
})
