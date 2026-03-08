return {
  cmd = { "clangd" },
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
  },
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "<f3>", function()
      local method = "textDocument/switchSourceHeader"
      if not client:supports_method(method) then
        vim.notify(("method %s is not supported by the current client"):format(method), vim.log.levels.WARN)
        return
      end

      local params = vim.lsp.util.make_text_document_params(bufnr)
      client:request(method, params, function(err, result)
        if err then
          vim.notify(tostring(err), vim.log.levels.ERROR)
          return
        end
        if not result then
          vim.notify("corresponding file cannot be determined", vim.log.levels.INFO)
          return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
      end, bufnr)
    end, { desc = "switch header/source (C/C++)" })
  end,
}
