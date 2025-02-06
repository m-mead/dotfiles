local M = {
  target = 'all',
  build_dir = 'build',
  configure_flags = '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
  num_jobs = nil,
}

function M.setup(args)
  if args.target then
    M.target = args.target
  end

  if args.build_dir then
    M.build_dir = args.build_dir
  end

  if args.configure_flags then
    M.configure_flags = args.configure_flags
  end

  if args.num_jobs then
    M.num_jobs = args.num_jobs
  end
end

local function dispatch(args)
  vim.cmd(':Dispatch ' .. args)
end

function M.cmake_configure(args)
  local flags = args or M.configure_flags
  dispatch('mkdir -p build && cd build && cmake .. ' .. flags)
end

function M.cmake_build(args)
  local target = args or M.target

  local parallel_flag = '--parallel'
  if M.num_jobs then
    parallel_flag = parallel_flag .. ' ' .. M.num_jobs
  end

  dispatch('cd build && cmake --build . --target ' .. target .. ' ' .. parallel_flag)
end

function M.cmake_list_targets(build_dir)
  build_dir = build_dir or vim.fn.getcwd() .. '/' .. M.build_dir

  local Job = require 'plenary.job'

  local stdout = {}
  local is_okay = false

  Job:new({
    command = 'cmake',
    args = { '--build', '.', '--target', 'help' },
    cwd = build_dir,
    on_exit = function(_, return_val)
      is_okay = (return_val == 0)
    end,
    on_stdout = function(_, data)
      vim.list_extend(stdout, { data })
    end,
  }):sync()

  if not is_okay then
    return {}
  end

  local targets = {}
  for _, v in ipairs(stdout) do
    if vim.startswith(v, '...') then
      vim.list_extend(targets, { vim.split(v, ' ')[2] })
    end
  end

  return targets
end

function complete_target(arglead, line)
  local words = vim.split(line, '%s+')
  local n = #words

  if n ~= 2 then
    return {}
  end

  local matches = {}

  for _, v in ipairs(M.cmake_list_targets()) do
    if vim.startswith(v, words[2]) then
      vim.list_extend(matches, { v })
    end
  end

  return matches
end

vim.api.nvim_create_user_command('CMakeConfigure', function(opts)
  M.cmake_configure(unpack(opts.fargs))
end, { nargs = '?' })

vim.api.nvim_create_user_command('CMakeBuild', function(opts)
  M.cmake_build(unpack(opts.fargs))
end, { nargs = '?', complete = complete_target })

vim.api.nvim_create_user_command('CMakeClean', function()
  M.cmake_build('--target clean')
end, { nargs = 0 })

vim.api.nvim_create_user_command('CMakeListTargets', function()
  M.cmake_build('--target help')
end, { nargs = 0 })

vim.api.nvim_create_user_command('CTest', function()
  dispatch('cd build && ctest')
end, { nargs = 0 })

vim.api.nvim_create_user_command('CMakeListTargets', function(opts)
  local targets = M.cmake_list_targets(unpack(opts.fargs))
  for _, v in ipairs(targets) do
    print(v)
  end
end, { nargs = '?' })

vim.api.nvim_create_user_command('CMakeSetTarget', function(opts) M.target = opts.fargs[1] end,
  { nargs = 1, complete = complete_target })

vim.api.nvim_create_user_command('CMakeGetTarget', function(_) print(M.target) end,
  { nargs = 0 })

vim.api.nvim_create_user_command('CMakeSetBuildDir', function(opts) M.build_dir = opts.fargs[1] end,
  { nargs = 1 })

vim.api.nvim_create_user_command('CMakeGetBuildDir', function(_) print(M.build_dir) end,
  { nargs = 0 })

vim.api.nvim_create_user_command('CMakeSetConfigureFlags', function(opts) M.configure_flags = opts.fargs[1] end,
  { nargs = 1 })

vim.api.nvim_create_user_command('CMakeGetConfigureFlags', function(_) print(M.configure_flags) end,
  { nargs = 0 })

vim.api.nvim_create_user_command('CMakeSetNumJobs', function(opts) M.num_jobs = opts.fargs[1] end,
  { nargs = 1 })

vim.api.nvim_create_user_command('CMakeGetNumJobs', function(_) print(M.num_jobs) end,
  { nargs = 0 })

return M
