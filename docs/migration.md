---
title: Migrating from LunarVim
---

# Migrating from LunarVim

Your `lvim.*` configuration is the stable part: the config surface carries
over almost untouched. What changed is the runtime underneath — SolarVim
targets Neovim 0.11+ and current plugin majors. Internal module paths
(`lua/lvim/…`) and command names (`:LvimUpdate`, `:LvimInfo`, …) are
intentionally unchanged, so upstream snippets and cherry-picks keep working.

## Runtime requirements

- **Neovim 0.11+** — SolarVim refuses to start on older versions. LunarVim
  1.x supported 0.9.
- **`tree-sitter` CLI 0.26.1+** — parser builds happen on your machine when a
  parser is missing.

## What changed under the hood

| Area | LunarVim 1.x | SolarVim |
| --- | --- | --- |
| Neovim | 0.9+ | 0.11+ |
| Treesitter | nvim-treesitter `master` | `main` rewrite, `vim.treesitter.start()` |
| LSP wiring | `lspconfig` setup API | native `vim.lsp.config` / `vim.lsp.enable` |
| Mason | mason / mason-lspconfig v1 | mason v2 / mason-lspconfig v2 |
| Keymaps | which-key v2 | which-key v3 |
| Indent lines | indent-blankline v2 | v3 |
| Colorscheme default | onedarker | monokai-pro-light |

## Deprecated options

These options were removed upstream; setting them now prints a warning naming
this page. Migrate as follows:

| Deprecated | Replacement |
| --- | --- |
| `lvim.builtin.theme.options.*` | `lvim.builtin.theme.<theme>.options` |
| `lvim.builtin.notify` | Configure `noice.nvim` directly via `lvim.plugins` |
| `lvim.builtin.dashboard` | `lvim.builtin.alpha` |
| `lvim.lsp.popup_border` | Border options of the handler you use |
| `lvim.lsp.float` | Options provided by the handler |
| `lvim.lsp.diagnostics` | `vim.diagnostic.config { … }` |
| `lvim.lang.*` | Per-filetype LSP servers resolved automatically |
| `lvim.autocommands.custom_groups` | `vim.api.nvim_create_autocmd` |
| `lvim.lsp.automatic_servers_installation` | `lvim.lsp.automatic_configuration.skipped_servers` |
| `lvim.lsp.override` | `lvim.lsp.automatic_configuration.skipped_servers` |

## Steps

1. Install SolarVim alongside LunarVim (it uses `NVIM_APPNAME=solarvim`, so
   nothing is overwritten) — see [Installation](installation.md).
2. Copy the parts you care about from `~/.config/lvim/config.lua` into
   `~/.config/solarvim/config.lua` — do not copy the file blindly if it sets
   deprecated options above.
3. Start `solarvim`, fix any deprecation warnings it prints, then uninstall
   LunarVim when satisfied.
