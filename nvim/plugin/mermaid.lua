local M = {
  theme = nil,
  background = nil,
}

function M.setup(config)
  if not config then
    return
  end

  M.theme = config.theme or M.theme
  M.background = config.background or M.background
end

function M.render(lines, on_success)
  if not lines or vim.tbl_isempty(lines) then
    vim.notify("No content", vim.log.levels.WARN)
    return
  end

  local input_file = vim.fn.tempname() .. ".mmd"
  local default_output = vim.fn.expand("%:p:r") .. ".svg"

  vim.ui.input({ prompt = "Output: ", default = default_output }, function(output_path)
    if output_path == nil or output_path == "" then
      return
    end

    vim.fn.writefile(lines, input_file)

    local command = {
      "mmdc",
      "-i", input_file,
      "-o", output_path,
    }

    if M.theme ~= nil then
      table.insert(command, "-t")
      table.insert(command, M.theme)
    end

    if M.background ~= nil then
      table.insert(command, "-b")
      table.insert(command, M.background)
    end

    local result = vim.system({
      "mmdc",
      "-i", input_file,
      "-o", output_path,
    }, { text = true }):wait()

    if result.code ~= 0 then
      vim.notify(result.stderr or "Mermaid render failed", vim.log.levels.ERROR)
      return
    end

    if on_success then
      on_success(output_path)
    end
  end)
end

local function complete(arglead)
  return vim.tbl_filter(function(v)
    return vim.startswith(v, arglead)
  end, { "render", "open" })
end

local function get_lines(opts)
  if opts.range > 0 then
    return vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  end
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function open_file(path)
  for _, opener in pairs({ "open", "xdg-open" }) do
    if vim.fn.executable(opener) then
      vim.fn.jobstart({ opener, path }, { detach = true })
      return
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mermaid", "text" },
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "Mermaid", function(opts)
      local action = opts.args ~= "" and opts.args or "render"

      if action ~= "render" and action ~= "open" then
        vim.notify("Usage: :Mermaid [render|open]", vim.log.levels.ERROR)
        return
      end

      local lines = get_lines(opts)

      if action == "render" then
        M.Mrender(lines, nil)
      elseif action == "open" then
        M.render(lines, open_file)
      end
    end, {
      nargs = "?",
      range = true,
      complete = complete,
    })
  end,
})

return M
