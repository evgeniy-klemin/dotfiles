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

Local addition (not from upstream): `.local/bin/claude-kitty-rc-proxy`, see
[Sandboxed lead (nono)](#sandboxed-lead-nono). The vendored files stay
unmodified.

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

## Sandboxed lead (nono)

Two modes:

- **Plain `claude-kitty`** — no sandbox. The shim talks to kitty's socket
  directly; teammates run unsandboxed, like the lead.
- **Lead under nono** — start it through `claude-kitty-rc-proxy`; every
  teammate gets the same sandbox as the lead.

The sandbox must never get kitty's socket (`$KITTY_LISTEN_ON`): under
`allow_remote_control socket-only` it is full control of kitty — `launch` any
command outside the sandbox, `send-text`/`get-text` on any window, `env`,
`load-config`, `action`, … Passwords do not fix that: in `password` mode a
request with an unknown password pops an "Allow remote control?" dialog whose
default button is *Allow*. So `kitty.conf` stays as is, and the proxy owns the
only path to the socket:

```zsh
sock="${TMPDIR:A}/claude-kitty-rc.$$.sock"   # AF_UNIX paths max out at 104 bytes
port=$(python3 -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1])')
prefix=("${commands[nono]}" run --silent --profile my-profile --allow-cwd --open-port "$port" --)
claude-kitty-rc-proxy serve --socket "$sock" --teammate-prefix "${(j: :)${(qq)prefix[@]}}" -- \
  nono run --profile my-profile --allow-cwd --proxy-port "$port" \
    --read ~/dotfiles/claude-kitty --allow-unix-socket "$sock" -- \
  claude-kitty
```

`serve` runs outside the sandbox: it binds `--socket`, starts the lead with
`KITTY_TMUX_SHIM_BIN` pointing at itself (inside the sandbox it acts as the
shim's `kitten` and forwards to `$CLAUDE_KITTY_RC_PROXY`), and exits with the
lead's status. The sandbox needs only `--read` on this stow package (the
`~/.local/bin` symlinks resolve into it) and `--allow-unix-socket` on the
proxy socket.

Policy — everything else is denied; decisions go to
`~/.claude/kitty-tmux-shim/rc-proxy.log`:

- only the shim's commands (`launch`, `send-text`, `send-key`, `get-text`,
  `close-window`, `set-spacing`, `set-window-title`), in the shapes it sends;
- `launch` always splits the lead's window (`KITTY_WINDOW_ID` at start) in the
  lead's cwd and runs `<teammate-prefix> <command>`. The requested
  `--cwd`/`--match` are ignored: a cwd of the lead's choosing would widen the
  teammate's `--allow-cwd` (e.g. to `$HOME`); teammates `cd` into their
  worktree themselves. At most 16 live teammate windows;
- every other command only on windows the proxy launched.

Teammates get `serve`'s environment (passed as `launch --env`), the way tmux
panes get the environment of the tmux server the lead started. kitty's own is
a GUI app's: `PATH` without Homebrew, so hooks fail with `node: command not
found`. Variables kitty sets per window (`KITTY_*`, `WINDOWID`, `TERM`, …) and
`TERM_*`, `PWD`, `SHLVL`, `TMUX*` are left out. The values are in the `kitten @
launch` argv (visible to the same user's `ps`), never in the log.

The nono proxy port: Claude Code passes the lead's `HTTPS_PROXY`/`HTTP_PROXY`
on to every teammate, and under a nono network profile that is nono's
filtering proxy (`http://nono:<token>@127.0.0.1:<port>`). A nono sandbox may
connect only to its own proxy, so teammates fail with `Unable to connect to
API (EPERM)`. Pin the lead's proxy (`--proxy-port P`) and give teammates
`--open-port P`: their traffic then goes through the lead's proxy and its
allow-list (the same flags anyway); direct connections stay blocked.

Give nono `--silent` in the prefix: the shim takes any `$ # % ❯ >` on the pane
as the shell prompt, and the nono banner would trigger that early.

Not covered: escape-sequence features any program in a kitty window can ask
for still prompt — e.g. `clone-in-kitty` (`allow_cloning ask`) and clipboard
reads (`clipboard_control` `read-*-ask`). Deny prompts you did not trigger.
Other processes of the same user can connect to the proxy socket, but they can
use kitty's own socket anyway.

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
