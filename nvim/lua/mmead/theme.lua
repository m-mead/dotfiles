require('lualine').setup({
  options = {
    theme = 'tokyonight-night',
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_c = {
      { 'filename', path = 1 }
    }
  }
})
