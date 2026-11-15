# claude-kitty

Claude Code agent-team teammates as native kitty splits, via a fake `tmux`
that translates Claude Code's `--teammate-mode tmux` calls into `kitten @`
remote-control commands.

Vendored (unmodified) from <https://github.com/jLAM-ERR/kitty-extensions>,
module `tmux-shim/`:

| Upstream file            | Package path                          | Stowed to                              |
|--------------------------|---------------------------------------|----------------------------------------|
| `tmux-shim/tmux`         | `.claude/kitty-tmux-shim/bin/tmux`    | `~/.claude/kitty-tmux-shim/bin/tmux`   |
| `tmux-shim/claude-kitty` | `.local/bin/claude-kitty`             | `~/.local/bin/claude-kitty`            |

- Commit: `cf0f640dbb7a66628af113bafd6bc77c95ca51cd` (2026-07-02)
- sha256 `tmux`:         `03c5bf1d9fb7de2bdcf202fb2e7e1e4955abd75658c7e9cc706f32f465412ab3`
- sha256 `claude-kitty`: `d79cbb570d6519b34b5cf427b3273be1ba60a882b6b81c639e0145817f4808fa`

Upstream `install.sh` is intentionally **not** used: it copies files into
`$HOME` and appends to `kitty.conf` directly (with `allow_remote_control yes`).

## Install

```bash
cd ~/dotfiles && stow --no-folding claude-kitty
```

`--no-folding` is required. The shim writes `shim.log` and `state.json` into
`~/.claude/kitty-tmux-shim/`; without it stow would make that directory a
symlink into this repo and the log would land here (both files are also in
`.gitignore` as a safety net).

The real `tmux` is not shadowed: the shim's `bin/` is put on `PATH` only by the
`claude-kitty` launcher, for that one process.

## kitty.conf requirements

Already satisfied by `kitty/.config/kitty/kitty.conf`:

- `allow_remote_control socket-only`
- `listen_on unix:/tmp/kitty` — kitty appends `-<pid>`; the shim uses
  `$KITTY_LISTEN_ON`, so the exact path does not matter
- `enabled_layouts ...` includes `splits` — `launch --location vsplit/hsplit`
  only applies in the splits layout; switch the tab to it (`opt+4`) before
  running `claude-kitty` for real splits, otherwise teammates are placed by the
  current layout

`listen_on` changes need a full kitty restart (not a config reload). Check with
`kitten @ ls`.

## Use

```bash
claude-kitty [any claude args...]   # = claude --teammate-mode tmux, shim on PATH
tail -f ~/.claude/kitty-tmux-shim/shim.log
grep -E 'UNHANDLED|EXC' ~/.claude/kitty-tmux-shim/shim.log
```

`shim.log` is never rotated and contains every tmux argv, including teammate
commands and text sent via `send-keys`. Truncate it from time to time.

## Update to a newer upstream commit

```bash
OLD=cf0f640dbb7a66628af113bafd6bc77c95ca51cd
tmp=$(mktemp -d) && git clone https://github.com/jLAM-ERR/kitty-extensions.git "$tmp/ke"
git -C "$tmp/ke" log --oneline "$OLD"..HEAD -- tmux-shim/        # what changed
git -C "$tmp/ke" diff "$OLD"..HEAD -- tmux-shim/ CLAUDE.md       # review it (incl. kitty.conf requirements)
cp -p "$tmp/ke/tmux-shim/tmux"         ~/dotfiles/claude-kitty/.claude/kitty-tmux-shim/bin/tmux
cp -p "$tmp/ke/tmux-shim/claude-kitty" ~/dotfiles/claude-kitty/.local/bin/claude-kitty
git -C "$tmp/ke" rev-parse HEAD                                  # put this SHA + new sha256 sums above
```

No restow is needed when only file contents change (the symlinks stay valid).
If upstream adds new files that must be installed, add them to the package and
run `stow --restow --no-folding claude-kitty`.

## Uninstall

```bash
cd ~/dotfiles && stow -D claude-kitty
rm -rf ~/.claude/kitty-tmux-shim     # optional: log + state left by the shim
```
