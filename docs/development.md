---
title: Development
---

# Development

## Working from a checkout

Run your local tree against isolated directories without touching a real
install:

```sh
./utils/installer/install.sh -l [--overwrite]
```

Or skip the installer entirely:

```sh
export NVIM_APPNAME=solarvim
export LUNARVIM_RUNTIME_DIR=/tmp/solarvim-dev/rdir
export LUNARVIM_CONFIG_DIR=/tmp/solarvim-dev/cdir
export LUNARVIM_CACHE_DIR=/tmp/solarvim-dev/cdir-cache
nvim -u /path/to/SolarVim/init.lua
```

## Tests

The suite is [plenary.nvim's busted](https://github.com/nvim-lua/plenary.nvim)
running headless Neovim; there is no standalone Lua interpreter.

```sh
make test                                # everything
make test TEST=tests/specs/lsp_spec.lua  # one spec
```

`utils/ci/run_test.sh` points `LUNARVIM_CONFIG_DIR`/`_CACHE_DIR` at fresh
`mktemp` dirs and sets `LVIM_TEST_ENV=true`, so tests never touch your real
config. Specs get the bootstrap globals (`join_paths`, `get_config_dir`, …)
because `tests/` is prepended to the runtimepath.

## Lint and format

```sh
make lint    # luacheck + shellcheck
make style   # stylua --check + shfmt -d
```

CI parity: PRs to `rolling` need `make lint`; PRs to `master` additionally
need `make style`. Commit messages follow Conventional Commits
(`<type>(<scope>): summary`, header ≤ 72 chars) — enforced by commitlint.

## Plugin pins

Core plugin commits are pinned in `snapshots/default.json`. After touching
`lua/lvim/plugins.lua`, regenerate the snapshot and verify:

```sh
./utils/scripts/regenerate-snapshot.sh   # or: make generate_new_lockfile
bash utils/ci/verify_plugins.sh          # exits 1 on pin mismatch
```

A weekly workflow bumps the pins and opens a `plugins-bump` PR
(`.github/workflows/plugins.yml`, runs on this repository).

## Layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Boot order lives here |
| `lua/lvim/bootstrap.lua` | Globals, version gate, stdpath redirection |
| `lua/lvim/config/defaults.lua` | Source of the `lvim` table |
| `lua/lvim/plugins.lua` + `snapshots/default.json` | Core specs and lockfile |
| `lua/lvim/plugin-loader.lua` | lazy.nvim wrapper |
| `lua/lvim/core/builtins/init.lua` | Ordered builtin registry |
| `lua/lvim/lsp/manager.lua` | Server resolution, `vim.lsp.enable` |
| `docs/` | This site (`mkdocs build` locally) |

Code that must survive a config reload fetches modules with the global
`reload("lvim.…")` instead of `require`.
