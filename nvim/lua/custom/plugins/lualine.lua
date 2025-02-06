return {
  'nvim-lualine/lualine.nvim',
  commit = '2a5bae925481f999263d6f5ed8361baef8df4f83',
  config = function()
    require('lualine').setup({
      options = {
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_c = {
          { 'filename', path = 1 }
        }
      }
    })
  end
}
