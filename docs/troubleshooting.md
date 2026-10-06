---
title: Troubleshooting
---

# Troubleshooting

## Check the version first

```vim
:LvimVersion   " branch-commit or tag
:LvimInfo      " LSP/formatter/linter state for the current buffer
```

Include both when filing an issue.

## Enable more logging

```lua
lvim.log.level = "debug"   -- in config.lua, or set LUNARVIM_LOG_LEVEL=debug
```

Logs live under `~/.cache/solarvim/`. Restart after changing the level.

## Startup errors

1. Run `solarvim --headless "+Lazy! sync" +qa` — a stale lazy cache after an
   update is the most common cause.
2. If a plugin pin mismatch is reported, SolarVim verifies installed commits
   against `snapshots/default.json`; rerun `:Lazy sync`.
3. Reset SolarVim's cache with `:LvimCacheReset` and restart.

## Treesitter parser build failures

The `main` nvim-treesitter builds parsers locally. Errors like
`tree-sitter CLI not found` or version-mismatch output mean the CLI is
missing or too old:

```sh
tree-sitter --version   # needs >= 0.26.1
npm install -g tree-sitter-cli
```

A working C compiler must be on your `PATH`.

## A language server is not attaching

Check what SolarVim resolved for the buffer in `:LvimInfo`, then:

- the server may be in `lvim.lsp.automatic_configuration.skipped_servers` —
  remove it there if you want SolarVim to manage it
- make sure the binary is installed (`:Mason` manages installs)
- run `:checkhealth vim.lsp` for native `vim.lsp` diagnostics

## Still stuck?

[Open an issue](https://github.com/rand0me/SolarVim/issues) with the output of
`:LvimVersion`, `:LvimInfo`, `nvim --version`, and the relevant log lines.

For questions about the upstream project itself, the
[LunarVim Discord](https://discord.gg/Xb9B4Ny) remains active.
