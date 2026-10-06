---
title: Installation
---

# Installation

SolarVim installs itself as a separate Neovim app (`NVIM_APPNAME=solarvim`), so
it can coexist with stock Neovim or an existing LunarVim install.

## Requirements

- Neovim **0.11 or newer** — SolarVim refuses to boot on older versions
- `git`, `tar`, `curl`, and a C compiler (parser builds)
- [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) **0.26.1 or newer** — required by nvim-treesitter `main`
- Optional, offered during install: NodeJS (npm) for some language-tooling
  integrations, Python (pip) for `pynvim`

## Install

```sh
bash <(curl -s https://raw.githubusercontent.com/rand0me/SolarVim/master/utils/installer/install.sh)
```

The installer clones SolarVim into its runtime dir, bootstraps
[lazy.nvim](https://github.com/folke/lazy.nvim) from the pinned snapshot in
`snapshots/default.json`, verifies the plugin pins, and drops a `solarvim`
launcher on your `PATH`.

!!! tip "First launch"

    Run `:Lazy sync` once after the first start if the plugin verification
    step reported anything.

### What you end up with

| Location | Purpose |
| --- | --- |
| `~/.config/solarvim/` | Your configuration (`config.lua`) |
| `~/.local/share/solarvim/` | Runtime data: plugins, LSP servers, generated templates |
| `~/.cache/solarvim/` | Cache (lazy.nvim, logs) |
| `$INSTALL_PREFIX/bin/solarvim` | The launcher |

All locations can be moved with the `LUNARVIM_RUNTIME_DIR`,
`LUNARVIM_CONFIG_DIR`, and `LUNARVIM_CACHE_DIR` environment variables (the
`LUNARVIM_*` names are kept from upstream for compatibility).

Windows uses PowerShell equivalents: `install.ps1` / `uninstall.ps1` install a
`solarvim.ps1` launcher and optionally a `solarvim` alias in your profile.

## Update

```vim
:LvimUpdate
```

SolarVim fast-forwards its runtime checkout and resets the startup cache.
Branch and version show up in `:LvimVersion`.

## Uninstall

```sh
curl -s https://raw.githubusercontent.com/rand0me/SolarVim/master/utils/installer/uninstall.sh | bash
```

Add `--remove-config` to also delete `~/.config/solarvim`, and
`--remove-backups` to remove `.old`/`.bak` directories left by earlier
upgrades.

## Try it without installing

Point the environment at a local checkout:

```sh
export NVIM_APPNAME=solarvim
export LUNARVIM_RUNTIME_DIR=~/.local/share/solarvim-dev/rdir
export LUNARVIM_CONFIG_DIR=~/.local/share/solarvim-dev/cdir
export LUNARVIM_CACHE_DIR=~/.local/share/solarvim-dev/cdir-cache
nvim -u /path/to/SolarVim/init.lua
```

Or run everything from a container:

```sh
git clone https://github.com/rand0me/SolarVim && cd SolarVim
docker build -f utils/docker/Dockerfile.local . -t solarvim:local
docker run -it solarvim:local
```
