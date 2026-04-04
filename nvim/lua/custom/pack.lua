local plugin_dir = "custom.plugins"

local plugins = {
  "eddy",
  "mini-completion",
  "mini-diff",
  "mini-pick",
  "vim-surround",
}

local specs = {}
local config_functions = {}

for _, v in ipairs(plugins) do
  local spec = require(plugin_dir .. "." .. v)
  table.insert(specs, { src = spec.src, version = spec.version })
  table.insert(config_functions, spec.config)
end

vim.pack.add(specs)

for _, v in ipairs(config_functions) do
  if v ~= nil then
    v()
  end
end
