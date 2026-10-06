---
title: Home
hide:
  - navigation
  - toc
---

<div class="solar-hero" markdown>

# SolarVim

Neovim 0.11+, ready today.
An IDE layer with sane defaults — LunarVim's lineage, rebuilt on current Neovim.

<div class="solar-install" markdown>

```sh
bash <(curl -s https://raw.githubusercontent.com/rand0me/SolarVim/master/utils/installer/install.sh)
```

</div>

</div>

<div class="solar-term" role="img" aria-label="The SolarVim startup screen: a braille sun banner above a menu of file-finder actions.">
<span class="solar-term-bar">~/.config/solarvim — nvim</span>
<pre>
<span class="solar-dim">~ nvim</span>
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣆⠀⠀⠀⠀⠀⠀⢠⣿⡟
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡆⠀⠀⠀⠀⠀⢿⡟
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣶⣶⣶⣤⣄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⢷⣦⣄⡀⠀⠀⠀⣴⣿⠿⠋⠉⠀⠀⠀⠉⠙⠿⣦⡀⠀⠀⢀⣠⣴⣾⡿⠆
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠷⠀⣾⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡄⠘⠿⠟⠋⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣷
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣄⠀⢿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⡏⢠⣤⣀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣶⣿⠿⠛⠉⠀⠀⠻⣧⣄⠀⠀⠀⠀⠀⠀⣠⣴⣿⠏⠀⠀⠉⠛⠿⣶⣤⡀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⢷⣶⣶⣾⡿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠉⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⡄⠀⠀⠀⠀⠀⣶⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⠁⠀⠀⠀⠀⠀⠘⣿⡄

    <span class="solar-gold">f</span> Find File      <span class="solar-gold">n</span> New File
    <span class="solar-gold">p</span> Projects       <span class="solar-gold">r</span> Recent files
    <span class="solar-gold">t</span> Find Text      <span class="solar-gold">c</span> Configuration
    <span class="solar-gold">q</span> Quit

    <span class="solar-dim">rand0me.github.io/SolarVim</span>
    <span class="solar-dim">master-4c1ac6a9</span>
</pre>
</div>

<div class="solar-reqs" markdown>
Requires Neovim 0.11+, `git`, `tar`, `curl`, a C compiler, and
[`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) 0.26.1+ for parser builds.
</div>

## Why SolarVim

LunarVim development stalled on Neovim 0.9, and its frozen plugin pins break on
newer Neovim. SolarVim keeps the same editing experience while targeting current
Neovim:

- **nvim-treesitter** on the `main` rewrite — highlighting via `vim.treesitter.start()`, parsers built by the new installer
- **LSP** on native `vim.lsp.config` / `vim.lsp.enable` with mason-lspconfig v2
- All 42 core plugin pins regenerated and kept fresh: which-key v3, indent-blankline v3, telescope, mason v2, …
- Defaults tuned for daily work: `monokai-pro` colorscheme, `<C-j>`/`<C-k>` buffer navigation

Coming from LunarVim? Your `lvim.*` configuration carries over — see
[Migrating from LunarVim](migration.md) for what changed under the hood.

SolarVim installs under `NVIM_APPNAME=solarvim` (config in `~/.config/solarvim`,
launcher `solarvim`), so it coexists with a stock Neovim or LunarVim install.

SolarVim is a fork of [LunarVim](https://github.com/LunarVim/LunarVim) — all
credit for the original design and the vast majority of the code goes to the
LunarVim community.
