local pickers      = require('telescope.pickers')
local config       = require('telescope.config').values
local finders      = require('telescope.finders')
local previewers   = require('telescope.previewers')
local utils        = require('telescope.previewers.utils')
local action_state = require('telescope.actions.state')
local actions      = require('telescope.actions')
local job          = require 'plenary.job'

local logger       = require('plenary.log'):new()
logger.level       = 'debug'

local function get_build_dir(dir)
  return dir .. '/build'
end

local function check_is_cmake_root(dir)
  local cmakelists = dir .. '/CMakeLists.txt'
  local build_dir = get_build_dir(dir)

  if vim.fn.filereadable(cmakelists) == 0 then
    print('current working directory must container a CMakeLists.txt')
    return false
  end

  if vim.fn.isdirectory(build_dir) == 0 then
    print('could not locate build directory, expected at ' .. build_dir)
    return false
  end

  return true
end

local function create_new_finder(build_dir)
  return finders.new_async_job({
    cwd = build_dir,
    command_generator = function()
      return { 'cmake', '--build', '.', '--target', 'help' }
    end,
    entry_maker = function(entry)
      -- Valid cmake entries are prefixed by three dots and a trailing space
      local parts = vim.fn.split(entry, '... ')
      if vim.fn.len(parts) == 1 then
        local target = parts[1]
        return { value = target, display = target, ordinal = target, }
      else
        return nil
      end
    end
  })
end

local function create_new_previewer()
  return previewers.new_buffer_previewer({
    title = 'CMake Targets',
    define_preview = function(self, entry)
      vim.api.nvim_buf_set_lines(
        self.state.bufnr,
        0,
        0,
        true,
        vim.iter({ 'cmake', '--build', '.', vim.split(vim.inspect(entry.value), '\n'), }):flatten():totable()
      )
      utils.highlighter(self.state.bufnr, 'markdown')
    end
  })
end

local function create_new_sorter(opts)
  return config.generic_sorter(opts)
end

local function select_cmake_target(prompt_bufnr)
  local selection = action_state.get_selected_entry()

  job:new({
    command = 'cmake',
    args = { '--build', '.', '--target', selection.value, '--parallel' },
    cwd = get_build_dir(vim.fn.getcwd()),
  }):start()

  actions.close(prompt_bufnr)
end

local M              = {}

M.show_cmake_targets = function(opts)
  opts = opts or {}
  local root = opts.root or vim.fn.getcwd()

  if not check_is_cmake_root(root) then
    error('directory must be the root directory of a cmake project')
  end

  pickers.new(opts, {
    finder = create_new_finder(get_build_dir(root)),
    sorter = create_new_sorter(opts),
    previewer = create_new_previewer(),
    attach_mappings = function(_, map)
      map('i', '<cr>', select_cmake_target)
      map('i', '<c-y>', select_cmake_target)

      map('n', '<cr>', select_cmake_target)
      map('n', '<c-y>', select_cmake_target)
      return true
    end,
  }):find()
end

return require('telescope').register_extension {
  setup = function(_) end,
  exports = {
    show_cmake_targets = M.show_cmake_targets
  },
}
