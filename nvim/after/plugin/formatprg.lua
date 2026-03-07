local function set_typescript_formatprg()
  if vim.fn.executable("prettier") ~= 1 then
    return
  end

  local buffer = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_get_name(buffer)

  vim.system(
    { "prettier", "--find-config-path", filename },
    {},
    function(result)
      local config = vim.trim(result.stdout or "")
      if result.code ~= 0 then
        return
      end

      if vim.fn.filereadable(config) ~= 1 then
        return
      end

      vim.bo[buffer].formatprg = string.format("prettier --config %s --stdin-filepath %s", config, filename)
      vim.bo[buffer].formatexpr = ""
    end
  )
end

local group = vim.api.nvim_create_augroup("FormatprgCustom", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
  },
  callback = set_typescript_formatprg
})
