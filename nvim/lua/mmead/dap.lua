-- Debug adapter
local dap = require('dap')

-- C++ configuration
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'OpenDebugAD7',
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

-- dap keybindings
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'debug continue' })
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = 'debug step over' })
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = 'debug step into' })
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = 'debug step out' })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'debug breakpoint toggle' })
vim.keymap.set('n', '<leader>dB', function() require('dap').set_breakpoint() end, { desc = 'debug breakpoint set' })
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'debug open repl' })
vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'debug ran last' })
vim.keymap.set({ 'n', 'v' }, '<leader>dh', function() require('dap.ui.widgets').hover() end, { desc = 'debug hover' })
vim.keymap.set({ 'n', 'v' }, '<leader>dp', function() require('dap.ui.widgets').preview() end, { desc = 'debug preview' })

vim.keymap.set('n', '<leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = 'debug open frames' })

vim.keymap.set('n', '<leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = 'debug open scopes' })
