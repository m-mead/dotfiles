--- @class mermaid.RenderOpts
--- @field theme string|nil
--- @field background string|nil

--- @class mermaid.SetupOpts
--- @field theme string|nil
--- @field background string|nil
--- @field file_patterns table[string]

local M = {
  theme = nil,
  background = nil,
  file_patterns = { "markdown", "mermaid", "text" },
}

--- @param opts mermaid.SetupOpts
function M.setup(opts)
  M.theme = opts.theme or M.theme
  M.background = opts.background or M.background
  M.file_patterns = opts.file_patterns or M.file_patterns
end

--- TODO: see `help: health-dev` and add health.lua.
function M.check()
  vim.health.start("mermaid report")

  local ok = true

  if vim.fn.executable("mmdc") ~= 0 then
    vim.health.error("missing dependency: mmdc")
    ok = false
  end

  if ok then
    vim.health.ok("setup is correct")
  end
end

--- @param lines table
--- @param opts mermaid.RenderOpts|nil
--- @param on_success function|nil
function M.render(lines, opts, on_success)
  if not lines or vim.tbl_isempty(lines) then
    vim.notify("No content", vim.log.levels.ERROR)
    return
  end

  local default_output_path = vim.fn.expand("%:p:r") .. ".svg"

  vim.ui.input({ prompt = "Output: ", default = default_output_path }, function(output_path)
    if not output_path then
      return
    end

    local command = { "mmdc", "-i", "-", "-o", output_path }

    local theme = opts and opts.theme or M.theme
    if theme ~= nil then
      table.insert(command, "-t")
      table.insert(command, theme)
    end

    local background = opts and opts.background or M.background
    if background ~= nil then
      table.insert(command, "-b")
      table.insert(command, background)
    end

    local result = vim.system(command, { text = true, stdin = table.concat(lines, "\n") }):wait()

    if result.code ~= 0 then
      vim.notify(result.stderr or "Render failed", vim.log.levels.ERROR)
    elseif on_success ~= nil then
      on_success(output_path)
    end
  end)
end

local function open_file(path)
  for _, opener in pairs({ "open", "xdg-open" }) do
    if vim.fn.executable(opener) then
      vim.fn.jobstart({ opener, path }, { detach = true })
      return
    end
  end
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

local group = vim.api.nvim_create_augroup("Mermaid", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = M.file_patterns,
  group = group,
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "Mermaid", function(opts)
      local action = opts.args ~= "" and opts.args or "render"

      if action ~= "render" and action ~= "open" then
        vim.notify("Usage: :Mermaid [render|open]", vim.log.levels.ERROR)
        return
      end

      local lines = get_lines(opts)

      if action == "render" then
        M.render(lines, nil, nil)
      elseif action == "open" then
        M.render(lines, nil, open_file)
      end
    end, {
      nargs = "?",
      range = true,
      complete = complete,
    })
  end,
})

return M
