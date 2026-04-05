local plugins_root = "custom.plugins"

local function iter_fns(config_functions)
  for _, v in ipairs(config_functions) do
    if v ~= nil then
      v()
    end
  end
end

local function setup_builtin()
  local builtin_dir = plugins_root .. ".builtin"

  local plugins = { "nvim-undotree" }
  local configs = {}

  for _, v in ipairs(plugins) do
    local spec = require(builtin_dir .. "." .. v)
    vim.cmd("packadd " .. spec.src)
    table.insert(configs, spec.config)
  end

  iter_fns(configs)
end

local function setup_thirdparty()
  local thirdparty_dir = plugins_root .. ".thirdparty"

  local plugins = {
    "eddy",
    "mini-completion",
    "mini-diff",
    "mini-pick",
    "mini-surround",
  }

  local specs = {}
  local configs = {}

  for _, v in ipairs(plugins) do
    local spec = require(thirdparty_dir .. "." .. v)
    table.insert(specs, { src = spec.src, version = spec.version })
    table.insert(configs, spec.config)
  end

  vim.pack.add(specs)
  iter_fns(configs)
end

setup_builtin()
setup_thirdparty()
