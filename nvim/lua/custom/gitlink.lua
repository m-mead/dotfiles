--- @class gitlink.BufInfo
--- @field root string
--- @field path string
--- @field branch string
--- @field remote string
--- @field line integer

--- @class gitlink.Provider
--- @field url function

---  @class gitlink.URLOpts
---  @field base_url string
---  @field branch string
---  @field path string
---  @field line integer

--- @class gitlink.SetupOpts
--- @field origin string|nil
--- @field providers gitlink.Provider[]|nil
--- @field base_url_fn function|nil

--- @param remote string
--- @return string
local function get_base_url(remote)
  local url = remote:gsub("^git@", "")

  url = url:gsub(".com:", ".com/")
  url = url:gsub(".org:", ".org/")

  local protocol = "https"
  if string.match(remote, "^http://") then
    url = url:gsub("^http://", "")
    protocol = "http"
  else
    url = url:gsub("^https://", "")
  end

  url = url:gsub(".git$", "")

  return string.format("%s://%s", protocol, url)
end

--- @type gitlink.Provider
local GitHubProvider = {
  --- @param opts gitlink.URLOpts
  --- @return string
  url = function(opts)
    return string.format("%s/blob/%s/%s#L%s",
      opts.base_url,
      opts.branch,
      opts.path,
      opts.line)
  end
}

--- @type gitlink.Provider
local GitLabProvider = {
  --- @param opts gitlink.URLOpts
  --- @return string
  url = function(opts)
    return string.format("%s/-/blob/%s/%s?ref_type=heads#L%s",
      opts.base_url,
      opts.branch,
      opts.path,
      opts.line)
  end
}

local GitLink = {
  origin = "origin",
  providers = {
    github = GitHubProvider,
    gitlab = GitLabProvider,
  },
  base_url_fn = get_base_url,
}

--- @return string
function GitLink.remote()
  local url = nil

  require("plenary.job"):new({
    command = "git",
    args = { "remote", "get-url", GitLink.origin },
    on_exit = function(_, return_val)
      if return_val ~= 0 then
        url = nil
      end
    end,
    on_stdout = function(_, data)
      url = data
    end,
  }):sync()

  if url == nil then
    error("could not determine git remote: " .. GitLink.opts.remote_name)
  end

  return url
end

--- @return string
function GitLink.branch()
  local branch = nil

  require("plenary.job"):new({
    command = "git",
    args = { "rev-parse", "--abbrev-ref", "HEAD" },
    on_exit = function(_, return_val)
      if return_val ~= 0 then
        branch = nil
      end
    end,
    on_stdout = function(_, data)
      branch = data
    end,
  }):sync()

  if branch == nil then
    error("could not determine git branch")
  end

  return branch
end

---@return gitlink.BufInfo
function GitLink.buf_info(buffer)
  local root = vim.fs.root(buffer, ".git")
  if root == nil then
    error("buf does not belong to git repository")
  end

  root = root:gsub("/$", "")

  local path = vim.api.nvim_buf_get_name(buffer)
  path = path:gsub("^" .. vim.pesc(root), "")
  path = path:gsub("^/", "")

  local line, _ = unpack(vim.api.nvim_win_get_cursor(0))

  return {
    root = root,
    path = path,
    branch = GitLink.branch(),
    remote = GitLink.remote(),
    line = line,
  }
end

--- @param remote string
--- @return gitlink.Provider
function GitLink.provider(remote)
  for name, provider in pairs(GitLink.providers) do
    if (
          string.match(remote, "^git@" .. name) or
          string.match(remote, "^http://" .. name) or
          string.match(remote, "^https://" .. name)
        ) then
      return provider
    end
  end
  error("no provider for remote: " .. remote)
end

---@return string
function GitLink.link()
  local info = GitLink.buf_info(0)

  local provider = GitLink.provider(info.remote)

  return provider.url({
    base_url = get_base_url(info.remote),
    branch = info.branch,
    path = info.path,
    line = info.line,
  })
end

function GitLink.show()
  print(GitLink.link())
end

function GitLink.open()
  local _, err = vim.ui.open(GitLink.link())
  if err ~= nil then
    error("failed to open link: " .. err)
  end
end

function GitLink.system_clipboard()
  vim.fn.setreg("+", GitLink.link())
end

--- @param opts gitlink.SetupOpts
function GitLink.setup(opts)
  GitLink.origin = opts.origin or GitLink.origin
  GitLink.providers = opts.providers or GitLink.providers
  GitLink.base_url_fn = opts.base_url_fn or GitLink.base_url_fn
end

local Commands = {
  system_clipboard = GitLink.system_clipboard,
  open = GitLink.open,
  show = GitLink.show,
}

vim.api.nvim_create_user_command("GitLink",
  function(opts) Commands[unpack(opts.fargs)]() end,
  {
    nargs = "?",
    complete = function(_, line)
      local words = vim.split(line, "%s+")
      local n = #words

      if n ~= 2 then
        return {}
      end

      local matches = {}
      for k, _ in pairs(Commands) do
        if vim.startswith(k, words[2]) then
          vim.list_extend(matches, { k })
        end
      end

      return matches
    end
  })

return GitLink
