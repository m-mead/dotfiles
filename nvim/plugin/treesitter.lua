require("custom.treesitter").setup({
  { src = "https://github.com/tree-sitter/tree-sitter-bash",       lang = "bash",       ft = "sh",                                version = "a06c2e4415e9bc0346c6b86d401879ffb44058f7" },                      -- v0.25.1
  { src = "https://github.com/tree-sitter/tree-sitter-css",        lang = "css",        ft = "css",                               version = "dda5cfc5722c429eaba1c910ca32c2c0c5bb1a3f" },                      -- v0.25.0
  { src = "https://github.com/tree-sitter/tree-sitter-go",         lang = "go",         ft = "go",                                version = "1547678a9da59885853f5f5cc8a99cc203fa2e2c" },                      -- v0.25.0
  { src = "https://github.com/tree-sitter/tree-sitter-html",       lang = "html",       ft = "html",                              version = "5a5ca8551a179998360b4a4ca2c0f366a35acc03" },                      -- v0.23.2
  { src = "https://github.com/tree-sitter/tree-sitter-javascript", lang = "javascript", ft = { "javascript", "javascriptreact" }, version = "44c892e0be055ac465d5eeddae6d3e194424e7de" },                      -- v0.25.0
  { src = "https://github.com/tree-sitter/tree-sitter-json",       lang = "json",       ft = "json",                              version = "ee35a6ebefcef0c5c416c0d1ccec7370cfca5a24" },                      -- v0.24.8
  { src = "https://github.com/tree-sitter/tree-sitter-python",     lang = "python",     ft = "python",                            version = "293fdc02038ee2bf0e2e206711b69c90ac0d413f" },                      -- v0.25.0
  { src = "https://github.com/tree-sitter/tree-sitter-rust",       lang = "rust",       ft = "rust",                              version = "77a3747266f4d621d0757825e6b11edcbf991ca5" },                      -- v0.24.2
  { src = "https://github.com/tree-sitter/tree-sitter-typescript", lang = "tsx",        ft = "typescriptreact",                   version = "f975a621f4e7f532fe322e13c4f79495e0a7b2e7", root = "tsx" },        -- v0.23.2
  { src = "https://github.com/tree-sitter/tree-sitter-typescript", lang = "typescript", ft = "typescript",                        version = "f975a621f4e7f532fe322e13c4f79495e0a7b2e7", root = "typescript" }, -- v0.23.2
})
