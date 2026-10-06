---
title: Configuration
---

# Configuration

Everything is configured by mutating the global `lvim` table from
`~/.config/solarvim/config.lua`. SolarVim loads that file with `dofile` —
there is no deep-merge, so **assign into `lvim.*`, never `return` a table**.

```lua
-- ~/.config/solarvim/config.lua
lvim.colorscheme = "monokai-pro" -- or any installed colorscheme

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.plugins = {
  { "folke/trouble.nvim" },
}
```

Saving any file under the config dir triggers a hot reload, so most tweaks
apply without restarting.

## Keymaps

All default keymaps live in the `lvim.keys` per-mode tables:

```lua
lvim.keys.normal_mode = {
  ["<C-j>"] = ":bnext<cr>",
  ["<C-k>"] = ":bprev<cr>",
}
```

Leader mappings follow the which-key v3 spec; add yours with `vim.keymap.set`
in a `lvim.keys` table or an autocommand, not by re-defining core defaults.

## Plugins

Extend `lvim.plugins` with [lazy.nvim](https://github.com/folke/lazy.nvim)
specs — they merge with SolarVim's pinned core set:

```lua
lvim.plugins = {
  {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
    end,
  },
}
```

## LSP

SolarVim resolves each server through native `vim.lsp.config`:

1. [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) defaults
2. A provider file in `lua/lvim/lsp/providers/<server>.lua`, if present
3. Your overrides

```lua
-- skip a server you configure yourself
lvim.lsp.automatic_configuration.skipped_servers =
  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "graphql" })

-- tweak a managed server's settings
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
```

Formatting and linting for non-LSP sources run through null-ls; add sources
with `lvim.format_on_save` and the `lvim.lsp.null_ls` helpers documented in
the generated ftplugin templates.

## Builtin modules

Every builtin (`telescope`, `nvimtree`, `cmp`, `dap`, `bufferline`, `alpha`,
…) exposes its options under `lvim.builtin.<name>`:

```lua
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
```

!!! warning "Deprecated options"

    Setting removed upstream options (like `lvim.builtin.theme.options.*`)
    prints a warning pointing at the [migration guide](migration.md). The
    warning is your signal the option no longer does anything.
