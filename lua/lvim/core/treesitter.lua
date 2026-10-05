local M = {}
local Log = require "lvim.core.log"

function M.config()
  lvim.builtin.treesitter = {
    on_config_done = nil,

    -- A list of parser names to install
    ensure_installed = { "comment", "markdown_inline", "regex" },

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    -- A directory to install the parsers into.
    -- By default parsers are installed to either the package dir, or the "site" dir.
    -- If a custom path is used (not nil) it must be added to the runtimepath.
    parser_install_dir = nil,

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    matchup = {
      enable = false, -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      additional_vim_regex_highlighting = false,
      disable = function(lang, buf)
        if vim.tbl_contains({ "latex" }, lang) then
          return true
        end

        local status_ok, big_file_detected = pcall(vim.api.nvim_buf_get_var, buf, "bigfile_disable_treesitter")
        return status_ok and big_file_detected
      end,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
      config = {
        -- Languages that have a single comment style
        typescript = "// %s",
        css = "/* %s */",
        scss = "/* %s */",
        html = "<!-- %s -->",
        svelte = "<!-- %s -->",
        vue = "<!-- %s -->",
        json = "",
      },
    },
    indent = { enable = true, disable = { "yaml", "python" } },
    autotag = { enable = false },
    textobjects = {
      swap = {
        enable = false,
        -- swap_next = textobj_swap_keymaps,
      },
      -- move = textobj_move_keymaps,
      select = {
        enable = false,
        -- keymaps = textobj_sel_keymaps,
      },
    },
    textsubjects = {
      enable = false,
      keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    playground = {
      enable = false,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    rainbow = {
      enable = false,
      extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
      max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
  }
end

function M.setup()
  local ts_status_ok, ts = pcall(require, "nvim-treesitter")
  if not ts_status_ok then
    Log:error "Failed to load nvim-treesitter"
    return
  end

  local opts = vim.deepcopy(lvim.builtin.treesitter)

  -- handle deprecated API, https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82
  local ts_context_ok, ts_context_commentstring = pcall(require, "ts_context_commentstring")
  if ts_context_ok then
    ts_context_commentstring.setup(opts.context_commentstring)
  end

  ts.setup {
    install_dir = opts.parser_install_dir,
  }

  if opts.ensure_installed and #opts.ensure_installed > 0 then
    local install = ts.install(opts.ensure_installed)
    if opts.sync_install and install then
      install:wait(300000)
    end
  end

  -- nvim-treesitter `main` no longer ships the `configs` module:
  -- highlighting and indentation are Neovim builtins that we enable per filetype
  vim.api.nvim_create_augroup("_lvim_treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = "_lvim_treesitter",
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match) or args.match

      if opts.highlight and opts.highlight.enable then
        local disabled = type(opts.highlight.disable) == "function" and opts.highlight.disable(lang, args.buf)
        if not disabled then
          pcall(vim.treesitter.start, args.buf)
        end
      end

      if
        opts.indent
        and opts.indent.enable
        and not vim.tbl_contains(opts.indent.disable or {}, lang)
      then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      if
        opts.auto_install
        and #vim.api.nvim_get_runtime_file(("parser/%s.*"):format(lang), false) == 0
      then
        pcall(ts.install, { lang })
      end
    end,
  })

  if lvim.builtin.treesitter.on_config_done then
    lvim.builtin.treesitter.on_config_done(ts)
  end
end

return M
