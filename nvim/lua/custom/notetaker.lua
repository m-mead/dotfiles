-- notetaker

---@class notetaker.Config
---@field root string?

---@class notetaker.M
---@field root string
---@field tag_pattern string
---@field setup fun(opts?: notetaker.Config)
---@field new_note fun(filename?: string)
---@field add_tag fun(tag?: string)
---@field list_tags fun(pattern?: string)
---@field search_tag fun(tag?: string)

local uv = vim.uv or vim.loop

---@class notetaker.M
local M = {
  root = uv.os_homedir() .. "/notes",
  tag_pattern = "\\[\\[[^]\r\n]+\\]\\]",
}

---@param opts? notetaker.Config
---@return nil
function M.setup(opts)
  M.root = opts and opts.root or M.root
end

---@param filename string?
---@return nil
function M.new_note(filename)
  if filename == nil then
    local default_filename = os.date("%Y-%m-%d") .. "-daily.md"
    vim.ui.input({ prompt = "Filename: ", default = default_filename }, function(f)
      filename = f
    end)

    if filename == nil then
      return
    end
  end

  vim.cmd.edit(M.root .. "/" .. filename)
end

---@param tag string?
---@return nil
function M.add_tag(tag)
  if tag == nil then
    vim.ui.input({ prompt = "Tag: " }, function(t)
      tag = t
    end)

    if tag == nil then
      return
    end
  end

  local tag_ref = ("[[%s]]"):format(tag)
  vim.api.nvim_put({ tag_ref }, "c", true, true)
end

---@param pattern string?
---@return nil
function M.list_tags(pattern)
  local cb = function(result)
    local lines = vim.split(result.stdout or "", "\n", { trimempty = true })
    local items = vim.fn.getqflist({ lines = lines, efm = "%f:%l:%c:%m" }).items
    vim.fn.setqflist({}, " ", { title = "tags", items = items })
    vim.cmd.copen()
  end

  pattern = pattern or M.tag_pattern
  local cmd = { "rg", "--vimgrep", pattern, M.root }
  vim.system(cmd, { text = true }, vim.schedule_wrap(cb))
end

---@param tag string?
---@return nil
function M.search_tag(tag)
  if tag == nil then
    vim.ui.input({ prompt = "Tag: " }, function(t)
      tag = t
    end)

    if tag == nil then
      return
    end
  end

  M.list_tags(("\\[\\[%s\\]\\]"):format(vim.pesc(tag)))
end

local complete = function(arglead, _, _)
  return vim.tbl_filter(function(item)
    return vim.startswith(item, arglead)
  end, { "list_tags", "new_note", "search_tag", "add_tag" })
end

vim.api.nvim_create_user_command("Notetaker", function(opts)
  local subcmd = opts.fargs[1]
  local arg = opts.fargs[2]

  if subcmd == "list_tags" then
    M.list_tags()
  elseif subcmd == "new_note" then
    M.new_note(arg)
  elseif subcmd == "search_tag" then
    M.search_tag(arg)
  elseif subcmd == "add_tag" then
    M.add_tag(arg)
  else
    vim.notify("Unknown subcommand: " .. tostring(subcmd), vim.log.levels.ERROR)
  end
end, { nargs = "+", complete = complete })

return M
