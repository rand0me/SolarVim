local M = {}

M.config = function()
  lvim.builtin.indentlines = {
    active = true,
    on_config_done = nil,
    options = {
      enabled = true,
      buftype_exclude = { "terminal", "nofile" },
      filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "text",
      },
      char = lvim.icons.ui.LineLeft,
      context_char = lvim.icons.ui.LineLeft,
      show_trailing_blankline_indent = false,
      show_first_indent_level = true,
      use_treesitter = true,
      show_current_context = true,
    },
  }
end

M.setup = function()
  local status_ok, ibl = pcall(require, "ibl")
  if not status_ok then
    return
  end

  -- translate legacy (indent-blankline v2) option names to the v3 API
  local opts = lvim.builtin.indentlines.options or {}
  ibl.setup {
    enabled = opts.enabled ~= false,
    exclude = {
      buftypes = opts.buftype_exclude,
      filetypes = opts.filetype_exclude,
    },
    indent = {
      char = opts.char,
    },
    scope = {
      char = opts.context_char or opts.char,
      enabled = opts.show_current_context ~= false,
    },
  }

  if lvim.builtin.indentlines.on_config_done then
    lvim.builtin.indentlines.on_config_done()
  end
end

return M
