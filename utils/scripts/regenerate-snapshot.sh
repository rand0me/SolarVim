#!/usr/bin/env bash
# Regenerate snapshots/default.json with the latest commit of each plugin's default branch.
# Special cases: nvim-treesitter tracks the incompatible `main` rewrite.
set -euo pipefail


REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

python3 - "$REPO_ROOT" <<'PY'
import json, subprocess, sys
from pathlib import Path

SPECIAL = {"nvim-treesitter": "main"}

snapshot_path = Path(sys.argv[1]) / "snapshots" / "default.json"
plugins_path = Path(sys.argv[1]) / "lua" / "lvim" / "plugins.lua"

# map lazy short names (snapshot keys) to owner/repo slugs (plugins.lua specs)
import re
slugs = {}
for spec in re.findall(r'"([\w.-]+/[\w.-]+)"', plugins_path.read_text()):
    name = spec.split("/")[-1]
    slugs[name] = spec

with open(snapshot_path) as f:
    snapshot = json.load(f)

new_snapshot = {}
for repo, info in snapshot.items():
    slug = slugs.get(repo, repo)
    branch = SPECIAL.get(repo)
    try:
        if branch is None:
            branch = subprocess.run(
                ["gh", "api", f"repos/{slug}", "--jq", ".default_branch"],
                capture_output=True, text=True, check=True).stdout.strip()
        sha = subprocess.run(
            ["gh", "api", f"repos/{slug}/commits/{branch}", "--jq", ".sha"],
            capture_output=True, text=True, check=True).stdout.strip()[:7]
        new_snapshot[repo] = {"commit": sha}
        print(f"{repo}: {info.get('commit')} -> {sha} ({branch})")
    except subprocess.CalledProcessError as e:
        print(f"{repo}: KEEP {info.get('commit')} ({e.stderr.strip()})", file=sys.stderr)
        new_snapshot[repo] = info

with open(snapshot_path, "w") as f:
    json.dump(new_snapshot, f, indent=2)
    f.write("\n")
PY
