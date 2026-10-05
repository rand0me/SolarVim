<div align="center">

# SolarVim

An actively maintained [Neovim](https://neovim.io) **0.11+** IDE layer with sane defaults.

Forked from [LunarVim](https://github.com/LunarVim/LunarVim) and ported to modern Neovim.

</div>

---

## Why SolarVim

LunarVim development stalled on Neovim 0.9 and its frozen plugin pins break on newer Neovim.
SolarVim keeps the LunarVim experience while targeting current Neovim:

- Requires **Neovim 0.11+** (developed and tested against 0.12)
- **nvim-treesitter** migrated to the `main` rewrite (highlighting via `vim.treesitter.start()`, new parser installer)
- **LSP** stack migrated to native `vim.lsp.config` / `vim.lsp.enable` with **mason-lspconfig v2**
- All 42 core plugin pins regenerated and kept fresh (indent-blankline v3, which-key v3, telescope, mason v2, …)
- Defaults: `monokai-pro-light` colorscheme, `<C-j>/<C-k>` buffer navigation

Internal module paths (`lua/lvim/`, `LvimUpdate`, `LvimDocs`, …) intentionally stay unchanged to
keep diffs small and upstream cherry-picks easy.

## Install

```sh
bash <(curl -s https://raw.githubusercontent.com/rand0me/SolarVim/main/utils/installer/install.sh)
```

Requirements:

- Neovim **>= 0.11** (`nvim` on your PATH)
- `git`, `tar`, `curl`, and a C compiler
- [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) **>= 0.26.1** (parser builds)
- Optional NodeJS/Rust dependencies are offered during install (same as LunarVim)

The installer uses `NVIM_APPNAME=solarvim`: config in `~/.config/solarvim`, runtime in
`~/.local/share/solarvim`, and a `solarvim` launcher on your PATH — it can coexist with a
stock Neovim or LunarVim install.

## Configure

Configuration lives in `~/.config/solarvim/config.lua` and works exactly like LunarVim's:

```lua
lvim.colorscheme = "monokai-pro"             -- or any installed colorscheme
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.plugins = {
  { "folke/trouble.nvim" },
}
```

## Development

```sh
# run a local checkout against an isolated runtime/config/cache
./utils/installer/install.sh -l [--overwrite]

# refresh the pinned core-plugin snapshot against upstream heads
./utils/scripts/regenerate-snapshot.sh
```

For sandboxed testing without installing, point the environment at a local checkout:

```sh
export NVIM_APPNAME=solarvim
export LUNARVIM_RUNTIME_DIR=~/.local/share/solarvim-dev/rdir
export LUNARVIM_CONFIG_DIR=~/.local/share/solarvim-dev/cdir
export LUNARVIM_CACHE_DIR=~/.local/share/solarvim-dev/cdir-cache
nvim -u /path/to/SolarVim/init.lua
```

## Credits

SolarVim is a fork of [LunarVim](https://github.com/LunarVim/LunarVim) — all credit for the
original design and the vast majority of the code goes to the LunarVim community.
