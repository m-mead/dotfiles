local M = {
  name  = "drift",
  theme = {
    dark = {
      background = "dark",
      palette    = {
        bg           = "#1a2821", -- desaturated pine green
        bg_highlight = "#22332b", -- elevated pine green

        fg           = "#e8e3d5", -- warm parchment
        fg_bright    = "#ede7d9", -- brighter parchment emphasis text
        fg_gutter    = "#82937f", -- muted olive-gray

        blue         = "#adcbe0", -- soft powder blue
        gray         = "#a79f95", -- warm gray
        green        = "#c8dfb8", -- soft sage green
        orange       = "#d69f73", -- muted amber orange
        red          = "#cc9488", -- muted clay red
        violet       = "#d8bdd3", -- soft mauve violet
        yellow       = "#d8c39a", -- muted sand gold
      },
    },
  }
}

--- Set highlights for the global namespace.
---
--- @param name string Highlight group name, e.g. "ErrorMsg"
--- @param value vim.api.keyset.highlight Highlight definition map
local function set_highlight(name, value)
  vim.api.nvim_set_hl(0, name, value)
end

--- Link one highlight group to another.
---
--- @param source string Highlight group to link
--- @param target string Highlight group target
local function link_highlight(source, target)
  set_highlight(source, { link = target })
end

--- Setup and apply the color theme.
---
--- @param config table|nil Theme config table.
function M.setup(config)
  if not config then
    config = { theme = "dark" }
  end

  local theme = M.theme[config.theme]
  if not theme then
    error("invalid theme: " .. config.theme)
  end

  local palette = theme.palette

  -- Setup
  vim.cmd("highlight clear")
  vim.o.background = theme.background
  vim.g.colors_name = M.name

  -- Editor
  set_highlight("ColorColumn", { bg = palette.bg_highlight })
  set_highlight("Cursor", { bg = palette.fg_bright })
  set_highlight("CursorColumn", { bg = palette.bg_highlight })
  set_highlight("CursorLine", { bg = palette.bg_highlight })
  set_highlight("CursorLineNr", { fg = palette.fg_bright, bg = palette.bg })
  set_highlight("FloatBorder", { fg = palette.fg_gutter, bg = palette.bg_highlight })
  set_highlight("FloatFooter", { fg = palette.blue, bg = palette.bg_highlight })
  set_highlight("FloatShadow", { bg = palette.bg_highlight, blend = 80 })
  set_highlight("FloatShadowThrough", { bg = palette.bg, blend = 100 })
  set_highlight("FloatTitle", { fg = palette.blue, bg = palette.bg_highlight, bold = true })
  set_highlight("FoldColumn", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("Folded", { fg = palette.fg_gutter, bg = palette.bg_highlight })
  set_highlight("LineNr", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("MatchParen", { bg = palette.orange })
  set_highlight("NonText", { fg = palette.fg_gutter })
  set_highlight("Normal", { fg = palette.fg, bg = palette.bg })
  set_highlight("NormalFloat", { fg = palette.fg, bg = palette.bg_highlight })
  set_highlight("NormalNC", { fg = palette.fg, bg = palette.bg })
  set_highlight("NormalSB", { fg = palette.fg, bg = palette.bg_highlight })
  set_highlight("Pmenu", { fg = palette.fg, bg = palette.bg_highlight })
  set_highlight("PmenuExtra", { fg = palette.fg, bg = palette.bg_highlight })
  set_highlight("PmenuExtraSel", { fg = palette.fg_bright, bg = palette.orange })
  set_highlight("PmenuKind", { fg = palette.fg, bg = palette.bg_highlight })
  set_highlight("PmenuKindSel", { fg = palette.fg_bright, bg = palette.orange })
  set_highlight("PmenuSbar", { bg = palette.bg_highlight })
  set_highlight("PmenuSel", { fg = palette.fg_bright, bg = palette.orange })
  set_highlight("PmenuThumb", { bg = palette.fg_gutter })
  set_highlight("SignColumn", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("SpecialKey", { fg = palette.fg_gutter })
  set_highlight("SpellBad", { sp = palette.red, undercurl = true })
  set_highlight("SpellCap", { sp = palette.orange, undercurl = true })
  set_highlight("SpellLocal", { sp = palette.blue, undercurl = true })
  set_highlight("SpellRare", { sp = palette.blue, undercurl = true })
  set_highlight("TermCursorNC", { bg = palette.fg_gutter })
  set_highlight("VertSplit", { fg = palette.fg_gutter })
  set_highlight("Visual", { fg = palette.fg, bg = palette.fg_gutter })
  set_highlight("VisualNOS", { fg = palette.fg, bg = palette.fg_gutter })
  set_highlight("WinSeparator", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("healthError", { fg = palette.red, bg = palette.bg_highlight })
  set_highlight("healthSuccess", { fg = palette.green, bg = palette.bg_highlight })
  set_highlight("healthWarning", { fg = palette.orange, bg = palette.bg_highlight })
  set_highlight("iCursor", { fg = palette.bg, bg = palette.fg })

  -- Language
  set_highlight("Annotation", { fg = palette.green })
  set_highlight("Bold", { bold = true })
  set_highlight("Boolean", { fg = palette.blue })
  set_highlight("Character", { fg = palette.violet })
  set_highlight("Comment", { fg = palette.gray })
  set_highlight("Conceal", { fg = palette.fg_gutter })
  set_highlight("Conditional", { fg = palette.red })
  set_highlight("Constant", { fg = palette.violet })
  set_highlight("Decorator", { fg = palette.green })
  set_highlight("Define", { fg = palette.green })
  set_highlight("Delimiter", { fg = palette.fg })
  set_highlight("Error", { fg = palette.red })
  set_highlight("Exception", { fg = palette.fg_bright })
  set_highlight("Float", { fg = palette.blue })
  set_highlight("Function", { fg = palette.fg })
  set_highlight("Identifier", { fg = palette.fg })
  set_highlight("Include", { fg = palette.green })
  set_highlight("Italic", { italic = true })
  set_highlight("Keyword", { fg = palette.red })
  set_highlight("Label", { fg = palette.fg_bright })
  set_highlight("Number", { fg = palette.violet })
  set_highlight("Operator", { fg = palette.red })
  set_highlight("PreProc", { fg = palette.green })
  set_highlight("Repeat", { fg = palette.red })
  set_highlight("Special", { fg = palette.orange })
  set_highlight("SpecialChar", { fg = palette.orange })
  set_highlight("SpecialComment", { fg = palette.gray })
  set_highlight("Statement", { fg = palette.red })
  set_highlight("StorageClass", { fg = palette.fg_bright })
  set_highlight("String", { fg = palette.green })
  set_highlight("Structure", { fg = palette.fg_bright })
  set_highlight("Tag", { fg = palette.fg })
  set_highlight("Todo", { fg = palette.orange, bold = true })
  set_highlight("Type", { fg = palette.green })
  set_highlight("Typedef", { fg = palette.fg_bright })
  set_highlight("Underline", { underline = true })
  set_highlight("WarningMsg", { fg = palette.orange })
  set_highlight("markdownBlockquote", { fg = palette.gray })
  set_highlight("markdownCode", { fg = palette.violet })
  set_highlight("markdownH1", { fg = palette.fg_bright, bold = true })
  set_highlight("markdownLinkText", { fg = palette.blue, underline = true })
  set_highlight("markdownListMarker", { fg = palette.green })
  set_highlight("markdownUrl", { fg = palette.blue, underline = true })

  -- Diagnostic
  set_highlight("DiagnosticDeprecated", { fg = palette.fg_gutter, strikethrough = true })
  set_highlight("DiagnosticError", { fg = palette.red })
  set_highlight("DiagnosticHint", { fg = palette.violet })
  set_highlight("DiagnosticInfo", { fg = palette.blue })
  set_highlight("DiagnosticOk", { fg = palette.green })
  set_highlight("DiagnosticUnderlineError", { sp = palette.red, undercurl = true })
  set_highlight("DiagnosticUnderlineHint", { sp = palette.violet, undercurl = true })
  set_highlight("DiagnosticUnderlineInfo", { sp = palette.blue, undercurl = true })
  set_highlight("DiagnosticUnderlineOk", { sp = palette.green, undercurl = true })
  set_highlight("DiagnosticUnderlineWarn", { sp = palette.orange, undercurl = true })
  set_highlight("DiagnosticUnnecessary", { fg = palette.fg_gutter, italic = true })
  set_highlight("DiagnosticVirtualTextError", { fg = palette.red, bg = palette.bg_highlight })
  set_highlight("DiagnosticVirtualTextHint", { fg = palette.violet, bg = palette.bg_highlight })
  set_highlight("DiagnosticVirtualTextInfo", { fg = palette.blue, bg = palette.bg_highlight })
  set_highlight("DiagnosticVirtualTextOk", { fg = palette.green, bg = palette.bg_highlight })
  set_highlight("DiagnosticVirtualTextWarn", { fg = palette.orange, bg = palette.bg_highlight })
  set_highlight("DiagnosticWarn", { fg = palette.orange })

  link_highlight("DiagnosticFloatingError", "DiagnosticError")
  link_highlight("DiagnosticFloatingHint", "DiagnosticHint")
  link_highlight("DiagnosticFloatingInfo", "DiagnosticInfo")
  link_highlight("DiagnosticFloatingOk", "DiagnosticOk")
  link_highlight("DiagnosticFloatingWarn", "DiagnosticWarn")
  link_highlight("DiagnosticSignError", "DiagnosticError")
  link_highlight("DiagnosticSignHint", "DiagnosticHint")
  link_highlight("DiagnosticSignInfo", "DiagnosticInfo")
  link_highlight("DiagnosticSignOk", "DiagnosticOk")
  link_highlight("DiagnosticSignWarn", "DiagnosticWarn")
  link_highlight("DiagnosticVirtualLinesError", "DiagnosticError")
  link_highlight("DiagnosticVirtualLinesHint", "DiagnosticHint")
  link_highlight("DiagnosticVirtualLinesInfo", "DiagnosticInfo")
  link_highlight("DiagnosticVirtualLinesOk", "DiagnosticOk")
  link_highlight("DiagnosticVirtualLinesWarn", "DiagnosticWarn")

  -- StatusLine, WinBar, etc.
  link_highlight("StatusLineTerm", "StatusLine")
  link_highlight("StatusLineTermNC", "StatusLineNC")
  set_highlight("EndOfBuffer", { fg = palette.bg, bg = palette.bg })
  set_highlight("ErrorMsg", { fg = palette.fg_bright, bg = palette.red })
  set_highlight("ModeMsg", { fg = palette.fg, bold = true })
  set_highlight("MoreMsg", { fg = palette.blue })
  set_highlight("MsgArea", { fg = palette.fg, bg = palette.bg })
  set_highlight("MsgSeparator", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("Question", { fg = palette.blue })
  set_highlight("StatusLine", { fg = palette.bg, bg = palette.yellow })
  set_highlight("StatusLineNC", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("WildMenu", { fg = palette.fg_bright, bg = palette.orange })
  set_highlight("WinBar", { fg = palette.fg, bg = palette.bg })
  set_highlight("WinBarNC", { fg = palette.fg_gutter, bg = palette.bg })

  -- Treesitter
  link_highlight("@annotation", "Annotation")
  link_highlight("@attribute", "Decorator")
  link_highlight("@boolean", "Boolean")
  link_highlight("@character", "Character")
  link_highlight("@character.special", "SpecialChar")
  link_highlight("@comment", "Comment")
  link_highlight("@conditional", "Conditional")
  link_highlight("@constant", "Constant")
  link_highlight("@constant.builtin", "Constant")
  link_highlight("@constant.macro", "Define")
  link_highlight("@constructor", "Function")
  link_highlight("@exception", "Exception")
  link_highlight("@field", "Identifier")
  link_highlight("@float", "Float")
  link_highlight("@function", "Function")
  link_highlight("@function.builtin", "Function")
  link_highlight("@function.call", "Function")
  link_highlight("@function.macro", "Function")
  link_highlight("@include", "Include")
  link_highlight("@keyword", "Keyword")
  link_highlight("@keyword.function", "Keyword")
  link_highlight("@keyword.operator", "Operator")
  link_highlight("@keyword.return", "Keyword")
  link_highlight("@label", "Label")
  link_highlight("@markup.heading", "markdownH1")
  link_highlight("@markup.italic", "Italic")
  link_highlight("@markup.link", "markdownLinkText")
  link_highlight("@markup.link.url", "markdownUrl")
  link_highlight("@markup.list", "markdownListMarker")
  link_highlight("@markup.quote", "markdownBlockquote")
  link_highlight("@markup.raw", "markdownCode")
  link_highlight("@markup.raw.block", "markdownCode")
  link_highlight("@markup.strikethrough", "Comment")
  link_highlight("@markup.strong", "Bold")
  link_highlight("@markup.underline", "Underline")
  link_highlight("@method", "Function")
  link_highlight("@method.call", "Function")
  link_highlight("@module", "Include")
  link_highlight("@namespace", "Include")
  link_highlight("@number", "Number")
  link_highlight("@operator", "Operator")
  link_highlight("@parameter", "Identifier")
  link_highlight("@preproc", "PreProc")
  link_highlight("@property", "Identifier")
  link_highlight("@punctuation.bracket", "Delimiter")
  link_highlight("@punctuation.delimiter", "Delimiter")
  link_highlight("@punctuation.special", "SpecialChar")
  link_highlight("@repeat", "Repeat")
  link_highlight("@storageclass", "StorageClass")
  link_highlight("@string", "String")
  link_highlight("@string.escape", "SpecialChar")
  link_highlight("@string.regex", "SpecialChar")
  link_highlight("@string.special", "SpecialChar")
  link_highlight("@symbol", "Identifier")
  link_highlight("@tag", "Tag")
  link_highlight("@tag.attribute", "Identifier")
  link_highlight("@tag.delimiter", "Delimiter")
  link_highlight("@text.emphasis", "Italic")
  link_highlight("@text.literal", "markdownCode")
  link_highlight("@text.reference", "markdownLinkText")
  link_highlight("@text.strong", "Bold")
  link_highlight("@text.title", "markdownH1")
  link_highlight("@text.todo", "Todo")
  link_highlight("@text.underline", "Underline")
  link_highlight("@text.uri", "markdownUrl")
  link_highlight("@type", "Type")
  link_highlight("@type.builtin", "Type")
  link_highlight("@type.definition", "Typedef")
  link_highlight("@variable", "Identifier")
  link_highlight("@variable.builtin", "Keyword")
  link_highlight("@variable.member", "Identifier")

  -- LSP
  set_highlight("LspCodeLens", { fg = palette.fg_gutter, italic = true })
  set_highlight("LspInlayHint", { fg = palette.fg_gutter, bg = palette.bg_highlight, italic = true })
  set_highlight("LspReferenceRead", { fg = palette.orange })
  set_highlight("LspReferenceText", { fg = palette.orange })
  set_highlight("LspReferenceWrite", { fg = palette.orange })
  set_highlight("LspSignatureActiveParameter", { fg = palette.orange })

  link_highlight("@lsp.mod.deprecated", "DiagnosticDeprecated")
  link_highlight("@lsp.mod.readonly", "Constant")
  link_highlight("@lsp.type.class", "@type")
  link_highlight("@lsp.type.comment", "@comment")
  link_highlight("@lsp.type.decorator", "@attribute")
  link_highlight("@lsp.type.enum", "@type")
  link_highlight("@lsp.type.enumMember", "@constant")
  link_highlight("@lsp.type.function", "@function")
  link_highlight("@lsp.type.interface", "@type")
  link_highlight("@lsp.type.keyword", "@keyword")
  link_highlight("@lsp.type.macro", "@constant.macro")
  link_highlight("@lsp.type.method", "@method")
  link_highlight("@lsp.type.namespace", "@namespace")
  link_highlight("@lsp.type.number", "@number")
  link_highlight("@lsp.type.operator", "@operator")
  link_highlight("@lsp.type.parameter", "@parameter")
  link_highlight("@lsp.type.property", "@property")
  link_highlight("@lsp.type.string", "@string")
  link_highlight("@lsp.type.struct", "@type")
  link_highlight("@lsp.type.type", "@type")
  link_highlight("@lsp.type.typeParameter", "@type.definition")
  link_highlight("@lsp.type.variable", "@variable")
  link_highlight("@lsp.typemod.class.defaultLibrary", "@type.builtin")
  link_highlight("@lsp.typemod.enum.defaultLibrary", "@type.builtin")
  link_highlight("@lsp.typemod.enumMember.defaultLibrary", "@constant.builtin")
  link_highlight("@lsp.typemod.function.defaultLibrary", "@function.builtin")
  link_highlight("@lsp.typemod.keyword.async", "@keyword")
  link_highlight("@lsp.typemod.method.defaultLibrary", "@function.builtin")
  link_highlight("@lsp.typemod.operator.injected", "@operator")
  link_highlight("@lsp.typemod.property.readonly", "@constant")
  link_highlight("@lsp.typemod.variable.defaultLibrary", "@variable.builtin")
  link_highlight("@lsp.typemod.variable.readonly", "@constant")
  link_highlight("@lsp.typemod.variable.static", "@constant")
  link_highlight("LspDiagnosticsDefaultError", "DiagnosticError")
  link_highlight("LspDiagnosticsDefaultHint", "DiagnosticHint")
  link_highlight("LspDiagnosticsDefaultInformation", "DiagnosticInfo")
  link_highlight("LspDiagnosticsDefaultWarning", "DiagnosticWarn")
  link_highlight("LspDiagnosticsUnderlineError", "DiagnosticUnderlineError")
  link_highlight("LspDiagnosticsUnderlineHint", "DiagnosticUnderlineHint")
  link_highlight("LspDiagnosticsUnderlineInformation", "DiagnosticUnderlineInfo")
  link_highlight("LspDiagnosticsUnderlineWarning", "DiagnosticUnderlineWarn")

  -- Navigation
  set_highlight("Directory", { fg = palette.orange })

  -- Search
  set_highlight("CurSearch", { fg = palette.bg, bg = palette.orange, bold = true })
  set_highlight("IncSearch", { fg = palette.bg, bg = palette.yellow, underline = true })
  set_highlight("Search", { fg = palette.bg, bg = palette.yellow })
  set_highlight("Substitute", { fg = palette.bg, bg = palette.yellow, bold = true })

  -- Tab
  set_highlight("TabLine", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("TabLineFill", { fg = palette.fg_gutter, bg = palette.bg })
  set_highlight("TabLineSel", { fg = palette.bg, bg = palette.yellow, bold = true })

  -- Window
  set_highlight("QuickFixLine", { bg = palette.bg_highlight })
  set_highlight("Title", { fg = palette.fg, bold = true })
  set_highlight("Whitespace", { fg = palette.fg_gutter })

  -- Diff
  set_highlight("Added", { fg = palette.green })
  set_highlight("Changed", { fg = palette.orange })
  set_highlight("DiffAdd", { fg = palette.green, bg = palette.bg_highlight })
  set_highlight("DiffChange", { fg = palette.orange, bg = palette.bg_highlight })
  set_highlight("DiffDelete", { fg = palette.red, bg = palette.bg_highlight })
  set_highlight("DiffText", { fg = palette.blue, bg = palette.bg_highlight, bold = true })
  set_highlight("Removed", { fg = palette.red })
end

return M
