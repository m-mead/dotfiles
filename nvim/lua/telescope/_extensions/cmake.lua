-- TODO
--
-- [x] Build CMake target via telescope selection
-- [ ] Show all CMake generators via telescope
-- [ ] Run CTest tests via telescope
-- [ ] Persist CMake settings via project specified save file in share directory
local pickers      = require('telescope.pickers')
local config       = require('telescope.config').values
local finders      = require('telescope.finders')
local action_state = require('telescope.actions.state')
local actions      = require('telescope.actions')
local job          = require 'plenary.job'

local logger       = require('plenary.log'):new()
logger.level       = 'debug'


--- Check if the project is a cmake project
--- @param dir string
--- @param build_dir string
--- @return boolean
local function check_is_cmake_project(dir, build_dir)
  local cmakelists = dir .. '/CMakeLists.txt'

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

--- Create a new telescope finder for finding cmake targets
--- @param build_dir string
--- @return table
local function create_cmake_target_finder(build_dir)
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

--- Create a new telescope sorter
--- @param opts table
--- @return table
local function create_sorter(opts)
  return config.generic_sorter(opts)
end

--- Run an async job using plenary and send the output to a new window.
---
--- By default, the buffer will be a horizontal split below the current buffer.
--- @param opts table
local function run_aysnc_job_and_stream_output(opts)
  local layout_command = opts.layout_command or "botright split"

  local output_buffer = -1

  local function send_output_to_buffer(err, data)
    if err then
      error(err)
    end

    vim.schedule(function()
      if output_buffer == -1 then
        vim.cmd(layout_command)

        local window = vim.api.nvim_get_current_win()
        output_buffer = vim.api.nvim_create_buf(true, true)

        vim.api.nvim_win_set_buf(window, output_buffer)
      end

      if data then
        local line_count = vim.api.nvim_buf_line_count(output_buffer) - 1

        vim.api.nvim_buf_set_lines(output_buffer, line_count, line_count, true, { data })
      end
    end)
  end

  job:new({
    command = opts.command,
    args = opts.args,
    cwd = opts.cwd,
    on_stdout = send_output_to_buffer,
    on_stderr = send_output_to_buffer,
  }):start()
end

--- Select and build a cmake target via telescope
---
--- @param prompt_bufnr integer
--- @param build_dir string
local function select_cmake_target(prompt_bufnr, build_dir)
  local selection = action_state.get_selected_entry()

  run_aysnc_job_and_stream_output({
    command = "cmake",
    args = { '--build', '.', '--target', selection.value, '--parallel' },
    cwd = build_dir,
  })

  actions.close(prompt_bufnr)
end

local M                 = {}

M.show_cmake_targets    = function(opts)
  opts = opts or {}

  local root = opts.root or vim.fn.getcwd()

  local build_dir = root .. '/build'

  if not check_is_cmake_project(root, build_dir) then
    error('directory must be the root directory of a cmake project')
  end

  local function on_select_cmake_target(prompt_bufnr)
    select_cmake_target(prompt_bufnr, build_dir)
  end

  pickers.new(opts, {
    finder = create_cmake_target_finder(build_dir),
    sorter = create_sorter(opts),
    attach_mappings = function(_, map)
      map('i', '<cr>', on_select_cmake_target)
      map('i', '<c-y>', on_select_cmake_target)

      map('n', '<cr>', on_select_cmake_target)
      map('n', '<c-y>', on_select_cmake_target)

      return true
    end,
  }):find()
end

M.show_cmake_generators = function(opts)
  error('function show_cmake_generators is not implemented')
end

M.show_ctest_tests      = function(opts)
  -- TODO(mmead): use "ctest --show-only=json-v1"
  error('function show_ctest_tests is not implemented')
end

return require('telescope').register_extension {
  setup = function(_) end,
  exports = {
    show_cmake_targets = M.show_cmake_targets,
    show_cmake_generators = M.show_cmake_generators,
    show_ctest_tests = M.show_ctest_tests,
  },
}
