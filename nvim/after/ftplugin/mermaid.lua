vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.opt_local.makeprg = [[mmdc -i "%" -o "%:r.svg"]]
vim.opt_local.errorformat = "%f:%l:%c %m,%f:%l %m,%m"

local function render_mermaid(opts, open_after)
  local lines

  if opts.range > 0 then
    lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  else
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  end

  if not lines or vim.tbl_isempty(lines) then
    vim.notify("No Mermaid content to render", vim.log.levels.WARN)
    return
  end

  local infile = vim.fn.tempname() .. ".mmd"
  local base = vim.fn.expand("%:p:r")
  local outfile = (opts.range > 0)
    and (base .. "-selection.svg")
    or (base .. ".svg")

  vim.fn.writefile(lines, infile)

  local result = vim.system({
    "mmdc",
    "-i", infile,
    "-o", outfile,
  }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify(result.stderr or "Mermaid render failed", vim.log.levels.ERROR)
    return
  end

  vim.notify("Rendered to " .. outfile, vim.log.levels.INFO)

  if open_after then
    vim.fn.jobstart({ "open", outfile }, { detach = true })
  end
end

vim.api.nvim_buf_create_user_command(0, "Mermaid", function(opts)
  render_mermaid(opts, false)
end, {
  range = true,
  desc = "Render Mermaid diagram to SVG",
})

vim.api.nvim_buf_create_user_command(0, "MermaidOpen", function(opts)
  render_mermaid(opts, true)
end, {
  range = true,
  desc = "Render Mermaid diagram to SVG and open it",
})
